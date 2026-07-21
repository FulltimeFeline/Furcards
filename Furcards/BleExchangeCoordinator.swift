//
//  BleExchangeCoordinator.swift
//  Furcards
//
//  Serverless BLE card exchange, gated on TradingSettings.nearbyTradingEnabled.
//  Dual-role CoreBluetooth transport driving furcards-core's ExchangeSession.
//  All protocol behavior (hello, swap decisions, gossip, blocklist, anti-storm,
//  framing) lives in the core; this file moves bytes and feeds verified results
//  into the collection.
//
//  The session machine is driven directly (events in, actions out) rather than
//  through the core's coroutine ExchangeRunner: calling Kotlin suspend functions
//  from Swift buys nothing over the pure machine and costs interop pain. The
//  loop here is the same protocol byte-for-byte.
//
//  Two transports per PROTOCOL.md §4:
//   - GATT pipe (mandatory fallback): frames chunked over RX/TX via FramePipe.
//   - L2CAP channel (fast path): whole session as u32-length frames over a
//     CBL2CAPChannel; used whenever the peer publishes a nonzero PSM.
//
//  Core Bluetooth does nothing on the simulator; verifying this needs two
//  physical devices.
//

import CoreBluetooth
import os
import Foundation
import FurcardsCore

@MainActor
@Observable
final class BleExchangeCoordinator: NSObject {
    // PROTOCOL.md §4: the v1 exchange service (…0001/0002 were the retired
    // server-era token profile).
    static let serviceUUID = CBUUID(string: "9E1D0003-2B7A-4C3E-9C7B-0F1A2B3C4D5E")
    static let rxUUID = CBUUID(string: "9E1D0004-2B7A-4C3E-9C7B-0F1A2B3C4D5E") // central → peripheral
    static let txUUID = CBUUID(string: "9E1D0005-2B7A-4C3E-9C7B-0F1A2B3C4D5E") // peripheral → central
    static let psmUUID = CBUUID(string: "9E1D0007-2B7A-4C3E-9C7B-0F1A2B3C4D5E")

    // MARK: observable state (badge mode + DEBUG diagnostics)

    struct Peer: Identifiable {
        var id: String { ephemeralId }
        var ephemeralId: String
        var rssi: Int
        var at: Date
    }

    private(set) var isRunning = false
    private(set) var isAdvertising = false
    private(set) var isScanning = false
    private(set) var currentEphemeralId = ""
    private(set) var recentPeers: [Peer] = []
    private(set) var sessionLog: [String] = []

    /// Completed exchanges since start; drives the badge pulse + counter.
    private(set) var exchangeCount = 0

    /// Badge mode: full-duty advertise+scan regardless of the duty cycle
    /// recommendation. The point of wearing the badge is being discoverable.
    var badgeMode = false

    /// True while a bump is armed; unlocks the friend tier (D6). An armed bump
    /// is two people holding phones together waiting, so it forces the scanner
    /// to full duty immediately: waiting out a quiet-cycle off window (up to
    /// 15 s) is what made bumps feel slow.
    var bumpIntent = false {
        didSet {
            guard bumpIntent, isRunning, let central, central.state == .poweredOn else { return }
            ensureScanning(central)
        }
    }
    var bumpMessage = ""
    /// Hex pubkey the bump must complete with (bump-from-their-card flow);
    /// nil = bump whoever also armed (badge/idle, or a legacy card).
    var bumpTargetPubkey: String?
    /// Fires when a mutual bump lands, for the bump screen result UI.
    var onBumpCompleted: ((Furcard, String) -> Void)?

    /// One-shot location fix for stamping a just-recorded encounter:
    /// `false` = city-level (walk-bys), `true` = precise (bumps).
    /// nil / no permission means the encounter is timestamp-only.
    var locationStamp: ((Bool) async -> (Double, Double)?)?

    // MARK: dependencies

    private let identity: Identity
    private let crypto: CryptoProvider
    private let signer: OwnCardSigner
    private let blobCache: BlobCache
    private let blocklistStore: BlocklistStore
    private let store: CardStore
    private let policy = AntiStormPolicy()

    private var central: CBCentralManager?
    private var peripheralManager: CBPeripheralManager?
    private var txCharacteristic: CBMutableCharacteristic?
    /// PSM of our published L2CAP listener; 0 until CoreBluetooth confirms it.
    private var publishedPsm: UInt16 = 0
    /// Central-role sessions keyed by peripheral id (also retains the peripheral).
    private var centralSessions: [UUID: CentralSession] = [:]
    /// Peripheral-role GATT-pipe sessions keyed by the subscribed central's id.
    private var peripheralSessions: [UUID: GattPipeAdapter] = [:]
    /// Peripheral-role L2CAP sessions (channels opened toward our PSM).
    private var l2capLinks: [L2capStreamLink] = []
    private var pendingPeripheralPackets: [UUID: [Data]] = [:]
    private var dutyCycleTimer: Timer?
    private var scanPhaseEndsAt = Date.distantPast
    private var advertisedWindow: Int64 = 0
    /// When a not-seen-before advertisement last appeared; feeds the duty cycle.
    private var lastNewPeerMillis: Int64 = 0

    init(
        identity: Identity,
        crypto: CryptoProvider,
        signer: OwnCardSigner,
        blobCache: BlobCache,
        blocklistStore: BlocklistStore,
        store: CardStore
    ) {
        self.identity = identity
        self.crypto = crypto
        self.signer = signer
        self.blobCache = blobCache
        self.blocklistStore = blocklistStore
        self.store = store
        super.init()
    }

    func start() {
        guard !isRunning else { return }
        isRunning = true
        currentEphemeralId = ephemeralIdHex()
        lastNewPeerMillis = nowMillis()
        // restore identifiers opt into CoreBluetooth state restoration: if iOS
        // relaunches the app for a BLE event, willRestoreState hands back the
        // managers. sessions never survive a relaunch (they are sub-10 s);
        // restoration cleans up stale connections instead of leaking them.
        central = CBCentralManager(
            delegate: self,
            queue: .main,
            options: [CBCentralManagerOptionRestoreIdentifierKey: "furcards.exchange.central"]
        )
        peripheralManager = CBPeripheralManager(
            delegate: self,
            queue: .main,
            options: [CBPeripheralManagerOptionRestoreIdentifierKey: "furcards.exchange.peripheral"]
        )
        startDutyCycle()
        log("exchange started, eph \(currentEphemeralId)")
    }

    func stop() {
        isRunning = false
        dutyCycleTimer?.invalidate()
        dutyCycleTimer = nil
        central?.stopScan()
        peripheralManager?.stopAdvertising()
        peripheralManager?.removeAllServices()
        if publishedPsm != 0 {
            peripheralManager?.unpublishL2CAPChannel(CBL2CAPPSM(publishedPsm))
            publishedPsm = 0
        }
        centralSessions.values.forEach { session in
            central?.cancelPeripheralConnection(session.peripheral)
        }
        centralSessions.removeAll()
        peripheralSessions.removeAll()
        l2capLinks.forEach { $0.close() }
        l2capLinks.removeAll()
        pendingPeripheralPackets.removeAll()
        central = nil
        peripheralManager = nil
        isAdvertising = false
        isScanning = false
        log("exchange stopped")
    }

    /// Drops a blocked identity's blobs from the relay cache (block action).
    func evictIdentity(pubkeyHex: String) {
        blobCache.removeIdentity(pubkeyHex: pubkeyHex)
    }

    /// Restart advertising so the local name picks up a rotated eph id / version.
    func refreshAdvertisement() {
        guard isRunning, let manager = peripheralManager, manager.state == .poweredOn else { return }
        manager.stopAdvertising()
        startAdvertising(manager)
        currentEphemeralId = ephemeralIdHex()
    }

    private var activeSessionCount: Int {
        centralSessions.count + peripheralSessions.count + l2capLinks.filter { $0.driver?.finished == false }.count
    }

    // MARK: duty cycle (PROTOCOL.md §9)

    /// Continuous scan while peers are fresh; after 5 quiet minutes drop to
    /// 5 s on / 15 s off. Badge mode overrides to full duty. iOS doesn't
    /// throttle scan starts the way Android does, but the battery win is the
    /// same on both.
    private func startDutyCycle() {
        dutyCycleTimer?.invalidate()
        let timer = Timer(timeInterval: 1.0, repeats: true) { _ in
            Task { @MainActor [weak self] in self?.dutyCycleTick() }
        }
        RunLoop.main.add(timer, forMode: .common)
        dutyCycleTimer = timer
    }

    private func dutyCycleTick() {
        guard isRunning, let central, central.state == .poweredOn else { return }
        // rebroadcast when the 15-min ephemeral window rolls; the advertised
        // local name otherwise goes stale against the current id
        let window = EphemeralId.shared.window(epochSeconds: Int64(Date().timeIntervalSince1970))
        if window != advertisedWindow {
            advertisedWindow = window
            refreshAdvertisement()
        }
        let cycle = policy.dutyCycle(lastNewPeerMillis: lastNewPeerMillis, nowMillis: nowMillis())
        if badgeMode || bumpIntent || cycle == .active {
            ensureScanning(central)
            return
        }
        // quiet: alternate 5 s scanning / 15 s idle
        let now = Date()
        if now >= scanPhaseEndsAt {
            if isScanning {
                central.stopScan()
                isScanning = false
                scanPhaseEndsAt = now.addingTimeInterval(Double(cycle.scanOffMillis) / 1000)
            } else {
                ensureScanning(central)
                scanPhaseEndsAt = now.addingTimeInterval(Double(cycle.scanOnMillis) / 1000)
            }
        }
    }

    private func ensureScanning(_ central: CBCentralManager) {
        guard !isScanning else { return }
        central.scanForPeripherals(withServices: [Self.serviceUUID], options: nil)
        isScanning = true
    }

    // MARK: session plumbing

    /// One session at the frame level: the core machine plus a per-transport
    /// send/timeout shell. GATT wraps this in a FramePipe adapter; L2CAP feeds
    /// it whole frames.
    @MainActor
    final class SessionDriver {
        let session: ExchangeSession
        private let sendFrame: (Data) -> Void
        private var ticker: Timer?
        var onComplete: ((ExchangeSession.SessionResult) -> Void)?
        var onFail: ((ExchangeSession.FailReason) -> Void)?
        var finished = false

        init(session: ExchangeSession, sendFrame: @escaping (Data) -> Void) {
            self.session = session
            self.sendFrame = sendFrame
        }

        func begin(mtu: Int, nowMillis: Int64) {
            apply(session.onConnected(mtu: Int32(mtu), nowMillis: nowMillis))
            let timer = Timer(timeInterval: 0.5, repeats: true) { [weak self] _ in
                Task { @MainActor [weak self] in
                    guard let self, !self.finished else { return }
                    self.apply(self.session.onTick(nowMillis: Int64(Date().timeIntervalSince1970 * 1000)))
                }
            }
            RunLoop.main.add(timer, forMode: .common)
            ticker = timer
        }

        func feedFrame(_ frame: Data) {
            guard !finished else { return }
            noteActivity()
            apply(session.onFrame(frame: frame.kotlinByteArray))
        }

        /// Bytes arrived on the link (even mid-frame): push the session's stall
        /// deadline so a healthy-but-slow transfer (big art frame over GATT)
        /// isn't killed by a fixed whole-session timeout.
        func noteActivity() {
            guard !finished else { return }
            session.onProgress(nowMillis: Int64(Date().timeIntervalSince1970 * 1000))
        }

        func linkClosed() {
            guard !finished else { return }
            finish { $0.onFail?(.timeout) }
        }

        func poison() {
            guard !finished else { return }
            finish { $0.onFail?(.protocolViolation) }
        }

        // sealed-interface members flatten in the kotlin export, e.g.
        // ExchangeSession.Action.Send arrives as ExchangeSessionActionSend
        private func apply(_ actions: [ExchangeSessionAction]) {
            for action in actions {
                switch action {
                case let send as ExchangeSessionActionSend:
                    sendFrame(send.frame.data)
                case let complete as ExchangeSessionActionComplete:
                    finish { $0.onComplete?(complete.result) }
                case let fail as ExchangeSessionActionFail:
                    finish { $0.onFail?(fail.reason) }
                default:
                    break
                }
            }
        }

        private func finish(_ deliver: (SessionDriver) -> Void) {
            guard !finished else { return }
            finished = true
            ticker?.invalidate()
            ticker = nil
            deliver(self)
        }
    }

    /// FramePipe shell for the GATT path: packets in/out, frames to the driver.
    @MainActor
    final class GattPipeAdapter {
        let driver: SessionDriver
        private let decoder = FramePipeDecoder(maxFrameBytes: FramePipeDecoder.companion.MAX_FRAME_BYTES)

        init(session: ExchangeSession, mtu: Int, sendPacket: @escaping (Data) -> Void) {
            driver = SessionDriver(session: session) { frame in
                for packet in FramePipeEncoder(mtu: Int32(mtu)).encode(frame: frame.kotlinByteArray) {
                    sendPacket(packet.data)
                }
            }
        }

        func feedPacket(_ packet: Data) {
            driver.noteActivity()
            if let frame = decoder.accept(packet: packet.kotlinByteArray) {
                driver.feedFrame(frame.data)
            }
            if decoder.isPoisoned {
                driver.poison() // broken stream: drop, never guess
            }
        }
    }

    /// L2CAP shell: the channel's streams as whole u32-length-prefixed frames.
    @MainActor
    final class L2capStreamLink: NSObject, StreamDelegate {
        private let channel: CBL2CAPChannel
        private let reader = L2capFrameReader(maxFrameBytes: FramePipeDecoder.companion.MAX_FRAME_BYTES)
        private var pendingWrite = Data()
        private var closeWhenDrained = false
        private var closeScheduled = false
        private var onClosed: (() -> Void)?
        var driver: SessionDriver?

        init(channel: CBL2CAPChannel) {
            self.channel = channel
            super.init()
            for stream in [channel.inputStream as Stream, channel.outputStream as Stream] {
                stream.delegate = self
                stream.schedule(in: .main, forMode: .common)
                stream.open()
            }
        }

        func sendFrame(_ frame: Data) {
            pendingWrite.append(L2capFraming.shared.encode(frame: frame.kotlinByteArray).data)
            flush()
        }

        private var closed = false
        func close() {
            guard !closed else { return }
            closed = true
            channel.inputStream.close()
            channel.outputStream.close()
            onClosed?()
            onClosed = nil
        }

        /// close once every queued byte is out. closing immediately on session
        /// completion discarded whatever was still in [pendingWrite], usually
        /// our final DONE frame, so peers sat waiting for it and timed out while
        /// we logged a completed session. [then] runs after the streams close
        /// (e.g. to cancel the BLE connection).
        func closeAfterDrain(then: (() -> Void)? = nil) {
            onClosed = then
            closeWhenDrained = true
            scheduleCloseIfDrained()
        }

        /// output.write() only means the OS accepted bytes into its send
        /// buffer, not that L2CAP transmitted them. closing immediately can
        /// truncate the last frames in flight, which showed up as "iphone
        /// completed the bump but Android never got the friend card + DONE".
        /// once our buffer is empty, wait a short grace for the radio to drain
        /// before closing.
        private func scheduleCloseIfDrained() {
            guard closeWhenDrained, pendingWrite.isEmpty, !closeScheduled else { return }
            closeScheduled = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
                self?.close()
            }
        }

        private func flush() {
            let output = channel.outputStream!
            while output.hasSpaceAvailable, !pendingWrite.isEmpty {
                let written = pendingWrite.withUnsafeBytes { raw in
                    output.write(raw.bindMemory(to: UInt8.self).baseAddress!, maxLength: pendingWrite.count)
                }
                if written <= 0 { break }
                pendingWrite.removeFirst(written)
            }
            scheduleCloseIfDrained()
        }

        nonisolated func stream(_ aStream: Stream, handle eventCode: Stream.Event) {
            Task { @MainActor [weak self] in self?.handle(aStream, eventCode) }
        }

        private func handle(_ aStream: Stream, _ eventCode: Stream.Event) {
            switch eventCode {
            case .hasBytesAvailable:
                guard let input = aStream as? InputStream else { return }
                var buffer = [UInt8](repeating: 0, count: 8192)
                while input.hasBytesAvailable {
                    let read = input.read(&buffer, maxLength: buffer.count)
                    if read <= 0 { break }
                    driver?.noteActivity()
                    let frames = reader.accept(bytes: Data(buffer.prefix(read)).kotlinByteArray)
                    for frame in frames {
                        driver?.feedFrame(frame.data)
                    }
                    if reader.isPoisoned {
                        driver?.poison()
                        close()
                        return
                    }
                }
            case .hasSpaceAvailable:
                flush()
            case .endEncountered, .errorOccurred:
                driver?.linkClosed()
                close()
            default:
                break
            }
        }
    }

    private func makeSession() -> ExchangeSession? {
        guard let common = signer.commonCard else {
            log("session skipped: own card not sealed yet")
            return nil
        }
        return ExchangeSession(
            me: ExchangeSession.LocalIdentity(
                ephemeralId: currentEphemeralIdBytes(),
                commonCard: common,
                friendCard: bumpIntent ? signer.friendCard : nil,
                fullArt: signer.fullArt?.kotlinByteArray,
                seenBloom: seenBloom(),
                bumpIntent: bumpIntent,
                bumpMessage: bumpMessage,
                wantsPeerFullArt: true,
                bumpTargetPublicKey: bumpTargetPubkey.flatMap { Data(hexString: $0)?.kotlinByteArray }
            ),
            crypto: crypto,
            blocklist: blocklistStore.blocklist,
            relayCandidates: blobCache.relayCandidates(crypto: crypto),
            nowMillis: nowMillis()
        )
    }

    /// Bloom over every card key we hold; drives the peer's swap + gossip diff.
    private func seenBloom() -> BloomFilter {
        let bloom = BloomFilter(bits: KotlinByteArray(size: 256))
        for candidate in blobCache.relayCandidates(crypto: crypto) {
            bloom.add(key: BloomFilter.companion.cardKey(publicKey: candidate.publicKey, cardVersion: candidate.cardVersion))
        }
        // include our own card, or peers gossip our own card back to us
        // (seen in the field as gossip=1 self-receipt)
        if let own = signer.commonCard {
            bloom.add(key: BloomFilter.companion.cardKey(publicKey: own.publicKey, cardVersion: own.cardVersion))
        }
        return bloom
    }

    /// Verified session results into the collection. BLE is an additive source.
    /// Runs as a task so the one-shot location stamps can be awaited; ingest is
    /// fired from driver callbacks and ordering between results doesn't matter.
    private func ingest(_ result: ExchangeSession.SessionResult) {
        Task { @MainActor in
            let at = Date()
            // never store a card signed by our own identity (a peer relaying our
            // card back); backstop on top of the own-key bloom entry
            let ownKey = identity.publicKey.data
            func isSelf(_ card: VerifiedCard) -> Bool { card.publicKey.data == ownKey }

            let hasWalkBy = result.peerCard != nil
            if hasWalkBy || result.bumpCompleted {
                exchangeCount += 1 // badge pulse + counter
            }
            // one city-level fix stamps every walk-by in the session
            let walkByStamp = hasWalkBy ? await locationStamp?(false) : nil
            if let verified = result.peerCard, !isSelf(verified) {
                blobCache.put(verified, receivedAt: at)
                upgradeLegacyIfMatched(verified)
                store.recordSeen(
                    Furcard(verified: verified),
                    event: Encounter(kind: .walkedBy, date: at, latitude: walkByStamp?.0, longitude: walkByStamp?.1)
                )
            }
            if result.bumpCompleted, let friend = result.peerFriendCard {
                let stamp = await locationStamp?(true) // bumps remember the exact spot
                let card = Furcard(verified: friend)
                _ = store.recordBump(
                    with: card,
                    event: Encounter(
                        kind: .bump,
                        date: at,
                        latitude: stamp?.0,
                        longitude: stamp?.1,
                        myMessage: bumpMessage,
                        theirMessage: result.peerBumpMessage
                    )
                )
                onBumpCompleted?(card, result.peerBumpMessage)
                // a targeted bump is done once it lands with that target;
                // disarm so the accept-flow doesn't stay armed forever
                if friend.publicKeyHex.lowercased() == bumpTargetPubkey?.lowercased() {
                    bumpIntent = false
                    bumpMessage = ""
                    bumpTargetPubkey = nil
                }
            }
        }
    }

    /// Server-era cards upgrade in place when a signed card arrives in person
    /// carrying their legacyId (PROTOCOL.md §8). The in-person exchange is the
    /// human verification; the double match keeps a random bystander from
    /// hijacking an entry. Peer card only, never gossip.
    private func upgradeLegacyIfMatched(_ verified: VerifiedCard) {
        let candidates = (store.seen + store.friends).filter(\.isLegacy)
        for legacy in candidates {
            if CardSupersession.shared.legacyUpgradeCandidate(incoming: verified, legacyCardId: legacy.id.uuidString) {
                store.upgradeLegacy(legacyID: legacy.id, signed: Furcard(verified: verified))
                log("upgraded legacy card \(legacy.name) to signed identity")
            }
        }
    }

    // MARK: helpers

    private func nowMillis() -> Int64 { Int64(Date().timeIntervalSince1970 * 1000) }

    private func currentEphemeralIdBytes() -> KotlinByteArray {
        EphemeralId.shared.current(seed: identity.ephemeralSeed, epochSeconds: Int64(Date().timeIntervalSince1970))
    }

    private func ephemeralIdHex() -> String {
        currentEphemeralIdBytes().data.hexString
    }

    private func recordPeer(_ ephemeralId: String, rssi: Int) {
        if !recentPeers.contains(where: { $0.ephemeralId == ephemeralId }) {
            lastNewPeerMillis = nowMillis() // fresh face: stay at full scan duty
        }
        var peers = recentPeers.filter { $0.ephemeralId != ephemeralId }
        peers.insert(Peer(ephemeralId: ephemeralId, rssi: rssi, at: Date()), at: 0)
        recentPeers = Array(peers.prefix(12))
    }

    private func log(_ line: String) {
        sessionLog.append("\(Int(Date().timeIntervalSince1970) % 100_000)s \(line)")
        if sessionLog.count > 40 { sessionLog.removeFirst(sessionLog.count - 40) }
        #if DEBUG
        // mirror to the unified log so `log collect --device` can pull it;
        // the android side has had this via logcat
        Self.osLog.info("\(line, privacy: .public)")
        #endif
    }

    #if DEBUG
    private static let osLog = os.Logger(subsystem: "com.fulltimefeline.furcards", category: "BLE")
    #endif
}

// MARK: - Peripheral role

extension BleExchangeCoordinator: CBPeripheralManagerDelegate {
    func peripheralManagerDidUpdateState(_ peripheral: CBPeripheralManager) {
        guard peripheral.state == .poweredOn, isRunning else { return }
        let service = CBMutableService(type: Self.serviceUUID, primary: true)
        let rx = CBMutableCharacteristic(
            type: Self.rxUUID,
            properties: [.write, .writeWithoutResponse],
            value: nil,
            permissions: [.writeable]
        )
        let tx = CBMutableCharacteristic(type: Self.txUUID, properties: [.notify], value: nil, permissions: [])
        // dynamic value: answered in didReceiveRead with the live PSM,
        // 0 until publishL2CAPChannel confirms
        let psm = CBMutableCharacteristic(type: Self.psmUUID, properties: [.read], value: nil, permissions: [.readable])
        service.characteristics = [rx, tx, psm]
        txCharacteristic = tx
        peripheral.removeAllServices()
        peripheral.add(service)
        // L2CAP fast path: withEncryption=false avoids a pairing prompt
        // mid-walk-by; payloads are Ed25519-signed at the protocol layer.
        peripheral.publishL2CAPChannel(withEncryption: false)
        startAdvertising(peripheral)
    }

    func peripheralManager(_ peripheral: CBPeripheralManager, willRestoreState dict: [String: Any]) {
        // relaunched for a BLE event: advertising state is handed back; the
        // actual re-setup happens in peripheralManagerDidUpdateState.
    }

    func peripheralManager(_ peripheral: CBPeripheralManager, didPublishL2CAPChannel PSM: CBL2CAPPSM, error: Error?) {
        if let error {
            log("l2cap publish failed: \(error.localizedDescription) — gatt pipe only")
            return
        }
        publishedPsm = UInt16(PSM)
        log("l2cap listening on psm \(PSM)")
    }

    func peripheralManager(_ peripheral: CBPeripheralManager, didOpen channel: CBL2CAPChannel?, error: Error?) {
        guard let channel, error == nil else {
            log("l2cap open failed: \(error?.localizedDescription ?? "?")")
            return
        }
        guard policy.canStartSession(activeSessionCount: Int32(activeSessionCount)),
              let session = makeSession()
        else {
            // the peer sees this close as a broken pipe on first write; log it
            // so a "sessions full" condition is visible on this side too
            log("l2cap channel rejected (sessions full or card unsealed)")
            channel.inputStream.close()
            channel.outputStream.close()
            return
        }
        let link = L2capStreamLink(channel: channel)
        let driver = SessionDriver(session: session) { [weak link] frame in link?.sendFrame(frame) }
        driver.onComplete = { [weak self, weak link] result in
            self?.ingest(result)
            self?.log("peripheral l2cap session complete: card=\(result.peerCard != nil) bump=\(result.bumpCompleted)")
            link?.closeAfterDrain()
        }
        driver.onFail = { [weak self, weak link] reason in
            self?.log("peripheral l2cap session failed: \(reason)")
            link?.closeAfterDrain()
        }
        link.driver = driver
        l2capLinks.append(link)
        l2capLinks.removeAll { $0.driver?.finished == true && $0 !== link }
        driver.begin(mtu: 4096, nowMillis: nowMillis())
    }

    fileprivate func startAdvertising(_ manager: CBPeripheralManager) {
        // iOS cannot advertise service data (CoreBluetooth only exposes local
        // name + service UUIDs to peripherals), so unlike Android the ephemeral
        // id + card version ride the local name as "base64url(eph8)/version".
        // base64 because 16 hex chars + the 128-bit service UUID overflow the
        // packet and iOS silently drops the whole name (field-tested: Androids
        // saw "(unlabelled)"). backgrounded iPhones lose the name regardless
        // (overflow area); peers then connect blind and the address-keyed
        // anti-storm dedupe keeps that cheap.
        let version = signer.commonCard?.cardVersion ?? 0
        manager.startAdvertising([
            CBAdvertisementDataServiceUUIDsKey: [Self.serviceUUID],
            CBAdvertisementDataLocalNameKey: "\(currentEphemeralIdBytes().data.base64url)/\(version)",
        ])
        isAdvertising = true
    }

    func peripheralManager(_ peripheral: CBPeripheralManager, didReceiveRead request: CBATTRequest) {
        guard request.characteristic.uuid == Self.psmUUID else {
            peripheral.respond(to: request, withResult: .attributeNotFound)
            return
        }
        // psm 0 = "gatt pipe only" per PROTOCOL.md
        request.value = Data([UInt8(publishedPsm >> 8), UInt8(publishedPsm & 0xff)])
        peripheral.respond(to: request, withResult: .success)
    }

    func peripheralManager(_ peripheral: CBPeripheralManager, central: CBCentral, didSubscribeTo characteristic: CBCharacteristic) {
        guard characteristic.uuid == Self.txUUID, isRunning else { return }
        guard policy.canStartSession(activeSessionCount: Int32(activeSessionCount)),
              let session = makeSession()
        else { return }

        // maximumUpdateValueLength already excludes ATT overhead; the core's
        // chunker subtracts 3 itself, so add it back.
        let mtu = central.maximumUpdateValueLength + 3
        let centralId = central.identifier
        let adapter = GattPipeAdapter(session: session, mtu: mtu) { [weak self, weak peripheral] packet in
            guard let self, let peripheral, let tx = self.txCharacteristic else { return }
            if !peripheral.updateValue(packet, for: tx, onSubscribedCentrals: [central]) {
                // notify queue full: stash and flush from peripheralManagerIsReady
                self.pendingPeripheralPackets[centralId, default: []].append(packet)
            }
        }
        adapter.driver.onComplete = { [weak self] result in
            self?.ingest(result)
            self?.peripheralSessions[centralId] = nil
            self?.log("peripheral session complete: card=\(result.peerCard != nil) bump=\(result.bumpCompleted)")
        }
        adapter.driver.onFail = { [weak self] reason in
            self?.peripheralSessions[centralId] = nil
            self?.log("peripheral session failed: \(reason)")
        }
        peripheralSessions[centralId] = adapter
        adapter.driver.begin(mtu: mtu, nowMillis: nowMillis())
        log("central subscribed, gatt session started")
    }

    func peripheralManager(_ peripheral: CBPeripheralManager, central: CBCentral, didUnsubscribeFrom characteristic: CBCharacteristic) {
        peripheralSessions.removeValue(forKey: central.identifier)?.driver.linkClosed()
        pendingPeripheralPackets[central.identifier] = nil
    }

    func peripheralManager(_ peripheral: CBPeripheralManager, didReceiveWrite requests: [CBATTRequest]) {
        for request in requests {
            if request.characteristic.uuid == Self.rxUUID, let value = request.value {
                peripheralSessions[request.central.identifier]?.feedPacket(value)
            }
            peripheral.respond(to: request, withResult: .success)
        }
    }

    func peripheralManagerIsReady(toUpdateSubscribers peripheral: CBPeripheralManager) {
        guard let tx = txCharacteristic else { return }
        for (centralId, packets) in pendingPeripheralPackets {
            var remaining = packets
            while let packet = remaining.first {
                if peripheral.updateValue(packet, for: tx, onSubscribedCentrals: nil) {
                    remaining.removeFirst()
                } else {
                    break
                }
            }
            pendingPeripheralPackets[centralId] = remaining.isEmpty ? nil : remaining
        }
    }
}

// MARK: - Central role

extension BleExchangeCoordinator: CBCentralManagerDelegate, CBPeripheralDelegate {
    /// Everything one central-role connection needs retained together.
    @MainActor
    final class CentralSession {
        let peripheral: CBPeripheral
        var pipe: GattPipeAdapter?
        var l2capLink: L2capStreamLink?
        var rx: CBCharacteristic?
        var peerPsm: UInt16 = 0
        var ephemeralIdHex: String

        init(peripheral: CBPeripheral, ephemeralIdHex: String) {
            self.peripheral = peripheral
            self.ephemeralIdHex = ephemeralIdHex
        }
    }

    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        guard central.state == .poweredOn, isRunning else { return }
        ensureScanning(central)
    }

    func centralManager(_ central: CBCentralManager, willRestoreState dict: [String: Any]) {
        // relaunched for a BLE event: drop any restored connections. sessions
        // are sub-10 s and never survive a relaunch; anti-storm dedupe makes
        // the re-encounter cheap.
        let restored = dict[CBCentralManagerRestoredStatePeripheralsKey] as? [CBPeripheral] ?? []
        for peripheral in restored {
            central.cancelPeripheralConnection(peripheral)
        }
    }

    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String: Any], rssi RSSI: NSNumber) {
        // android peers advertise [eph 8][version u32] as service data; ios
        // peers carry "ephHex/version" as the local name; backgrounded iphones
        // carry neither (overflow area) and get connected blind.
        var ephHex = ""
        var version: UInt32 = 0
        var peerIsAndroid = false
        if let serviceData = advertisementData[CBAdvertisementDataServiceDataKey] as? [CBUUID: Data],
           let data = serviceData[Self.serviceUUID], data.count >= 12 {
            ephHex = data.prefix(8).hexString
            version = data.suffix(from: 8).prefix(4).reduce(0) { ($0 << 8) | UInt32($1) }
            peerIsAndroid = true // only android advertises service data
        } else if let name = advertisementData[CBAdvertisementDataLocalNameKey] as? String,
                  name.contains("/") {
            let parts = name.split(separator: "/", maxSplits: 1)
            let head = String(parts[0])
            // base64url(eph8) from ios peers, 16-char hex accepted too
            if head.count == 16, head.allSatisfy({ $0.isHexDigit }) {
                ephHex = head
            } else if let bytes = Data(base64url: head), bytes.count == 8 {
                ephHex = bytes.hexString
            }
            version = UInt32(parts.count > 1 ? parts[1] : "") ?? 0
        }

        recordPeer(ephHex.isEmpty ? "(unlabelled)" : ephHex, rssi: RSSI.intValue)
        // unlabelled peers get anti-storm keyed by the peripheral id instead
        // of skipping the policy; that skip caused the field-test connect storm
        let policyKey = ephHex.isEmpty ? peripheral.identifier.uuidString : ephHex
        // dual-role tie-break (mirrors android): both phones try to be central
        // at once, one connect wins and the other dies as a broken pipe or
        // timeout, the flood that made bumps miss their window. lower ephemeral
        // id connects, the higher waits to be connected to; both know both ids
        // so they agree with no extra wire data. unlabelled peers (no
        // comparable id) fall through and connect as before.
        //
        // android's central L2CAP is reliable; ios's is throttled the moment
        // the app isn't perfectly foregrounded, so ios always defers to an
        // android peer and lets android drive. this fixed "bump completes on
        // ios but not android", where the eph tie-break handed the connection
        // to the flaky ios central role. between two iphones, fall back to the
        // eph tie-break (lower connects).
        if peerIsAndroid {
            return // let android initiate; it's the reliable central
        }
        if !ephHex.isEmpty {
            let mine = currentEphemeralIdBytes().data.hexString
            if !mine.isEmpty, mine > ephHex { return } // other iphone with lower eph initiates
        }
        // an armed bump must reach a peer we just exchanged with (both users
        // are holding their phones together), so bypass the dedupe. without it
        // ios refused to reconnect for 30 min after the first session, so an
        // accepted bump could never complete from this side.
        if !bumpIntent, !policy.shouldConnect(ephemeralIdHex: policyKey, cardVersion: version, nowMillis: nowMillis()) {
            return
        }
        guard policy.canStartSession(activeSessionCount: Int32(activeSessionCount)),
              centralSessions[peripheral.identifier] == nil
        else { return }

        centralSessions[peripheral.identifier] = CentralSession(peripheral: peripheral, ephemeralIdHex: policyKey)
        peripheral.delegate = self
        central.connect(peripheral)
        log("connecting to \(ephHex.isEmpty ? peripheral.identifier.uuidString : ephHex) rssi \(RSSI.intValue)")
        // CoreBluetooth connects have no timeout: a peer that walked away (or
        // an android that restarted onto a new MAC) leaves the connect pending
        // forever. two of those and activeSessionCount sits at the cap, so
        // every inbound channel gets rejected until the app restarts (an
        // endless broken-pipe loop in the field). mirror android's 15 s connect
        // watchdog: no transport up by then, cancel and free the slot.
        let watchdogId = peripheral.identifier
        DispatchQueue.main.asyncAfter(deadline: .now() + 15) { [weak self] in
            guard let self,
                  let context = self.centralSessions[watchdogId],
                  context.pipe == nil, context.l2capLink == nil
            else { return }
            self.failCentral(context.peripheral, "connect watchdog: no transport after 15 s")
        }
    }

    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        peripheral.discoverServices([Self.serviceUUID])
    }

    func centralManager(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: Error?) {
        failCentral(peripheral, "connect failed: \(error?.localizedDescription ?? "?")")
    }

    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        let context = centralSessions.removeValue(forKey: peripheral.identifier)
        context?.pipe?.driver.linkClosed()
        context?.l2capLink?.driver?.linkClosed()
    }

    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        guard let service = peripheral.services?.first(where: { $0.uuid == Self.serviceUUID }) else {
            return failCentral(peripheral, "exchange service missing")
        }
        peripheral.discoverCharacteristics([Self.rxUUID, Self.txUUID, Self.psmUUID], for: service)
    }

    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        guard let rx = service.characteristics?.first(where: { $0.uuid == Self.rxUUID }),
              service.characteristics?.contains(where: { $0.uuid == Self.txUUID }) == true
        else { return failCentral(peripheral, "pipe characteristics missing") }
        centralSessions[peripheral.identifier]?.rx = rx
        if let psm = service.characteristics?.first(where: { $0.uuid == Self.psmUUID }) {
            peripheral.readValue(for: psm) // l2cap probe first; subscribe on answer
        } else {
            subscribeGatt(peripheral, service: service)
        }
    }

    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        switch characteristic.uuid {
        case Self.psmUUID:
            var psm: UInt16 = 0
            if error == nil, let value = characteristic.value, value.count >= 2 {
                psm = (UInt16(value[0]) << 8) | UInt16(value[1])
            }
            centralSessions[peripheral.identifier]?.peerPsm = psm
            if psm > 0 {
                peripheral.openL2CAPChannel(CBL2CAPPSM(psm))
            } else if let service = characteristic.service {
                subscribeGatt(peripheral, service: service)
            }
        case Self.txUUID:
            guard let value = characteristic.value else { return }
            centralSessions[peripheral.identifier]?.pipe?.feedPacket(value)
        default:
            break
        }
    }

    func peripheral(_ peripheral: CBPeripheral, didOpen channel: CBL2CAPChannel?, error: Error?) {
        guard let context = centralSessions[peripheral.identifier] else { return }
        guard let channel, error == nil else {
            // l2cap fast path failed, fall back to the mandatory gatt pipe
            log("l2cap open failed (\(error?.localizedDescription ?? "?")), falling back to gatt pipe")
            if let service = peripheral.services?.first(where: { $0.uuid == Self.serviceUUID }) {
                subscribeGatt(peripheral, service: service)
            }
            return
        }
        guard let session = makeSession() else { return failCentral(peripheral, "no session") }
        let link = L2capStreamLink(channel: channel)
        let driver = SessionDriver(session: session) { [weak link] frame in link?.sendFrame(frame) }
        driver.onComplete = { [weak self] result in
            self?.ingest(result)
            if !context.ephemeralIdHex.isEmpty {
                // dedupe every completed session, including "nothing new" ones;
                // only recording card transfers left devices re-handshaking
                // every few seconds in the field
                self?.policy.recordExchange(ephemeralIdHex: context.ephemeralIdHex, cardVersion: result.peerCardVersion, nowMillis: self?.nowMillis() ?? 0)
            }
            self?.log("central l2cap session complete: card=\(result.peerCard != nil) bump=\(result.bumpCompleted)")
            self?.centralSessions[peripheral.identifier] = nil
            // drain the channel before dropping the BLE link, or our final
            // DONE dies in the buffer and the peer times out
            link.closeAfterDrain { [weak self] in
                self?.central?.cancelPeripheralConnection(peripheral)
            }
        }
        driver.onFail = { [weak self] reason in
            self?.log("central l2cap session failed: \(reason)")
            if !context.ephemeralIdHex.isEmpty {
                self?.policy.recordFailure(ephemeralIdHex: context.ephemeralIdHex, nowMillis: self?.nowMillis() ?? 0)
            }
            self?.centralSessions[peripheral.identifier] = nil
            self?.central?.cancelPeripheralConnection(peripheral)
        }
        link.driver = driver
        context.l2capLink = link
        driver.begin(mtu: 4096, nowMillis: nowMillis())
    }

    private func subscribeGatt(_ peripheral: CBPeripheral, service: CBService) {
        guard let tx = service.characteristics?.first(where: { $0.uuid == Self.txUUID }) else {
            return failCentral(peripheral, "tx characteristic missing")
        }
        peripheral.setNotifyValue(true, for: tx)
    }

    func peripheral(_ peripheral: CBPeripheral, didUpdateNotificationStateFor characteristic: CBCharacteristic, error: Error?) {
        guard characteristic.uuid == Self.txUUID, error == nil,
              let context = centralSessions[peripheral.identifier],
              let rx = context.rx,
              let session = makeSession()
        else { return failCentral(peripheral, "subscribe failed: \(error?.localizedDescription ?? "no session")") }

        // maximumWriteValueLength already excludes ATT overhead; the core's
        // chunker subtracts 3 itself, so add it back.
        let mtu = peripheral.maximumWriteValueLength(for: .withoutResponse) + 3
        let adapter = GattPipeAdapter(session: session, mtu: mtu) { [weak peripheral] packet in
            peripheral?.writeValue(packet, for: rx, type: .withoutResponse)
        }
        adapter.driver.onComplete = { [weak self] result in
            self?.ingest(result)
            if !context.ephemeralIdHex.isEmpty {
                // dedupe every completed session, including "nothing new" ones;
                // only recording card transfers left devices re-handshaking
                // every few seconds in the field
                self?.policy.recordExchange(ephemeralIdHex: context.ephemeralIdHex, cardVersion: result.peerCardVersion, nowMillis: self?.nowMillis() ?? 0)
            }
            self?.log("central session complete: card=\(result.peerCard != nil) bump=\(result.bumpCompleted)")
            self?.centralSessions[peripheral.identifier] = nil
            // CoreBluetooth gives no delivery signal for write-without-response;
            // a short grace lets the last queued frames reach the air before the
            // link drops (a few connection events at 30-50 ms each)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.35) { [weak self] in
                self?.central?.cancelPeripheralConnection(peripheral)
            }
        }
        adapter.driver.onFail = { [weak self] reason in
            self?.log("central session failed: \(reason)")
            if !context.ephemeralIdHex.isEmpty {
                self?.policy.recordFailure(ephemeralIdHex: context.ephemeralIdHex, nowMillis: self?.nowMillis() ?? 0)
            }
            self?.centralSessions[peripheral.identifier] = nil
            self?.central?.cancelPeripheralConnection(peripheral)
        }
        context.pipe = adapter
        adapter.driver.begin(mtu: mtu, nowMillis: nowMillis())
    }

    private func failCentral(_ peripheral: CBPeripheral, _ reason: String) {
        log(reason)
        if let context = centralSessions.removeValue(forKey: peripheral.identifier),
           !context.ephemeralIdHex.isEmpty {
            policy.recordFailure(ephemeralIdHex: context.ephemeralIdHex, nowMillis: nowMillis())
        }
        central?.cancelPeripheralConnection(peripheral)
    }
}
