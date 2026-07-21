//
//  AppModel.swift
//  Furcards
//
//  Created by Riley on 08/07/2026.
//

import Foundation
import FurcardsCore
import Observation
import UserNotifications

/// Owns the card store, settings, and the BLE exchange. No network: discovery
/// and exchange are phone-to-phone. The only location use is a one-shot stamp
/// when an encounter is recorded (city-level for walk-bys, precise for bumps).
@Observable
@MainActor
final class AppModel {
    let user: LocalUser
    let store: CardStore
    let settings: TradingSettings

    /// Set on first run so the Nearby Trading onboarding step runs before
    /// entering the app. Cleared once the step is completed.
    var needsWalkedBySetup = false

    /// Whether the app is active (UI has appeared).
    private var active = false

    /// One-shot location fixes for stamping encounters. Only location use left.
    private let stamper = EncounterStamper()

    /// Settings + collection mirror in the user's own iCloud Drive, restores
    /// fresh installs. Android counterpart is OS Auto Backup.
    private var cloudBackup: CloudBackup?

    init(user: LocalUser, store: CardStore, settings: TradingSettings) {
        self.user = user
        self.store = store
        self.settings = settings
        cloudBackup = CloudBackup(store: store, settings: settings)
        observeSettings()
        observeMyCard()
        reconcileBleExchange()
    }

    // MARK: Serverless BLE exchange

    /// Built lazily on first enable: identity keypair, sealed own-card blobs,
    /// relay cache, pubkey blocklist, and the CoreBluetooth coordinator.
    private var bleExchange: BleExchangeCoordinator?
    private var ownCardSigner: OwnCardSigner?
    private var blocklistStore: BlocklistStore?

    /// Read-only handle for badge mode, the bump screen, and DEBUG diagnostics.
    var bleExchangeDiagnostics: BleExchangeCoordinator? { bleExchange }

    /// Starts/stops the exchange to match the master toggle. Nullable backing
    /// instead of lazy so a toggled-off app start never touches the Keychain or
    /// mints an identity just to check state.
    func reconcileBleExchange() {
        guard settings.nearbyTradingEnabled else {
            bleExchange?.stop()
            return
        }
        if bleExchange == nil {
            guard let crypto = CryptoRegistry.shared.provider,
                  let storage = SecureStorageRegistry.shared.storage
            else { return }
            let identity = IdentityManager(storage: storage, crypto: crypto).loadOrCreate()
            let signer = OwnCardSigner(userID: store.userID, identity: identity, crypto: crypto)
            ownCardSigner = signer
            let blocklist = blocklistStore ?? BlocklistStore(userID: store.userID)
            blocklistStore = blocklist
            let coordinator = BleExchangeCoordinator(
                identity: identity,
                crypto: crypto,
                signer: signer,
                blobCache: BlobCache(userID: store.userID),
                blocklistStore: blocklist,
                store: store
            )
            coordinator.locationStamp = { [weak self] precise in
                guard let self, self.settings.locationStampsEnabled else { return nil }
                return await self.stamper.stamp(precise: precise)
            }
            // register the bump completion handler once here. registering it
            // from the bump sheet on appear raced the session and dropped
            // completions, so the sheet spun forever with the friend card
            // already in the collection.
            coordinator.onBumpCompleted = { [weak self] friend, message in
                self?.lastBumpCompletion = BumpCompletion(friend: friend, message: message)
            }
            bleExchange = coordinator
        }
        ownCardSigner?.ensureSealed(card: store.myCard, allowRelay: settings.allowRelay, allowEncounterCount: settings.allowEncounterCount,
            commonCount: Int64(store.seen.count), shinyCount: Int64(store.friends.count))
        bleExchange?.start()
        // a reseal mints a new cardVersion; peers dedupe on (ephId, version)
        // from the advertisement, so a stale advertised version means nobody
        // re-fetches the updated card
        bleExchange?.refreshAdvertisement()
    }

    // MARK: Trading state

    /// Nearby trading is the BLE exchange; the master toggle gates the radios.
    var isTradingAllowed: Bool {
        settings.nearbyTradingEnabled
    }

    /// Kicks the radios into the right state when the UI shows up. Idempotent.
    func activate() {
        active = true
        reconcileBleExchange()
        // refresh the daily reminder with the latest count on foreground
        rescheduleWalkedByNotification()
    }

    func deactivate() {
        active = false
        // exchange keeps running while the master toggle is on (bluetooth
        // background modes); nothing to pause here
    }

    // MARK: Bump (friend exchange over BLE, ruling D6)

    /// Arms bump intent with the message to attach. The next session with a
    /// peer who also armed carries the friend tier + messages. A target pubkey
    /// pins the bump to that identity (bump-from-their-card flow); nil bumps
    /// whoever also armed. Results arrive on
    /// `BleExchangeCoordinator.onBumpCompleted`.
    func beginBump(message: String, targetPubkeyHex: String? = nil) {
        reconcileBleExchange()
        bleExchange?.bumpMessage = message
        bleExchange?.bumpTargetPubkey = targetPubkeyHex
        bleExchange?.bumpIntent = true
    }

    func cancelBump() {
        bleExchange?.bumpIntent = false
        bleExchange?.bumpMessage = ""
        bleExchange?.bumpTargetPubkey = nil
    }

    /// Factory reset: wipe the collection, settings, sealed blobs, caches, and
    /// the keychain identity, then drop back to onboarding. iOS can't restart
    /// itself, so reset the live objects (which re-persist their defaults).
    func resetAllData() {
        bleExchange?.stop()
        bleExchange = nil
        ownCardSigner = nil
        blocklistStore = nil

        store.reset()
        settings.nearbyTradingEnabled = false
        settings.hasCompletedSetup = false
        settings.demoMode = false
        settings.locationStampsEnabled = false
        settings.dailyWalkedByNotification = false
        settings.allowEncounterCount = false

        // exchange caches + signer blobs + one-off UI flags
        let defaults = UserDefaults.standard
        for key in defaults.dictionaryRepresentation().keys
        where key.hasPrefix("OwnCardSigner") || key.hasPrefix("BlobCache") || key.hasPrefix("Blocklist") {
            defaults.removeObject(forKey: key)
        }
        defaults.removeObject(forKey: "hasSeenBackgroundTradeInfo")

        // drop the keychain identity keypair
        if let storage = SecureStorageRegistry.shared.storage,
           let crypto = CryptoRegistry.shared.provider {
            IdentityManager(storage: storage, crypto: crypto).destroy()
        }
    }

    /// The latest completed mutual bump. `id` makes every completion distinct
    /// so the bump sheet's `.onChange` fires even for a re-bump with the same
    /// friend. Set from the coordinator's `onBumpCompleted`, observed by the UI.
    struct BumpCompletion: Equatable {
        let id = UUID()
        let friend: Furcard
        let message: String
    }

    var lastBumpCompletion: BumpCompletion?

    // MARK: Daily walked-by notification

    /// Asks the user for notification permission, then turns the daily summary on.
    /// Called from onboarding / settings when the user opts in.
    func enableDailyWalkedByNotification() async -> Bool {
        let center = UNUserNotificationCenter.current()
        let granted = (try? await center.requestAuthorization(options: [.alert, .sound, .badge])) ?? false
        settings.dailyWalkedByNotification = granted
        rescheduleWalkedByNotification()
        return granted
    }

    /// Cancels, then (if enabled) re-schedules a daily local notification with
    /// how many people they've walked by, at their chosen time. iOS can't
    /// recompute the body later, so bake in the current count and re-schedule
    /// whenever the app foregrounds.
    func rescheduleWalkedByNotification() {
        let center = UNUserNotificationCenter.current()
        center.removePendingNotificationRequests(withIdentifiers: [Self.walkedByNotificationID])
        guard settings.dailyWalkedByNotification else { return }

        let count = store.seen.count
        let content = UNMutableNotificationContent()
        content.title = "Furcards"
        content.body = count == 1
            ? "You've traded cards with 1 person nearby. Open the app to see who it was."
            : "You've traded cards with \(count) people nearby. Open the app to see who they were."
        content.sound = .default

        var components = DateComponents()
        components.hour = settings.notificationHour
        components.minute = settings.notificationMinute
        let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: true)
        let request = UNNotificationRequest(identifier: Self.walkedByNotificationID, content: content, trigger: trigger)
        center.add(request)
    }

    private static let walkedByNotificationID = "daily-walked-by"

#if DEBUG
    /// Debug-only: turns the demo collection on (fills Walked By, Friends,
    /// history, and a category with fake cards) or off (empties the collection).
    func setDemoMode(_ on: Bool) {
        settings.demoMode = on
        if on {
            store.populateTestData()
        } else {
            store.clearCollected()
        }
    }

    /// Debug-only: replays first-run onboarding from the top.
    func replayOnboarding() {
        settings.hasCompletedSetup = false
        needsWalkedBySetup = false
    }
#endif

    /// Flags that the Nearby Trading onboarding step should run.
    func setNeedsWalkedBySetup(_ needed: Bool) {
        needsWalkedBySetup = needed
    }

    func clearWalkedBySetup() {
        needsWalkedBySetup = false
    }

    /// Prompts for when-in-use location permission so encounters can be
    /// stamped with where they happened. Optional: denial means timestamp-only
    /// encounters.
    func requestLocationPermission() {
        stamper.requestPermission()
    }

    /// Saves the card locally; the exchange re-seals + re-advertises via
    /// observeMyCard. All local, so this can't fail.
    func saveCard(_ card: Furcard) {
        store.myCard = card
        let hasProfile = !card.name.trimmingCharacters(in: .whitespaces).isEmpty
        if hasProfile {
            settings.hasCompletedSetup = true
        }
    }

    // MARK: Block (local-only; no server to make it mutual)

    /// Hides this person forever on this device: pubkey blocklist (enforced by
    /// the core in session, relay, and display paths), relay-cache eviction,
    /// and removal from the collection. The legacy-id block keeps a server-era
    /// contact blocked even after they upgrade to a signed identity (D10).
    func block(_ card: Furcard) {
        store.remove(cardID: card.id)
        let store = blocklistStore ?? BlocklistStore(userID: self.store.userID)
        blocklistStore = store
        if let pubkey = card.pubkey, let bytes = Data(hexString: pubkey) {
            store.block(bytes.kotlinByteArray)
            bleExchange?.evictIdentity(pubkeyHex: pubkey)
        }
        store.blockLegacy(card.id.uuidString) // blocks a future signed upgrade too (D10)
    }

    /// Reverses a block.
    func unblock(_ card: Furcard) {
        let store = blocklistStore ?? BlocklistStore(userID: self.store.userID)
        blocklistStore = store
        if let pubkey = card.pubkey, let bytes = Data(hexString: pubkey) {
            store.unblock(bytes.kotlinByteArray)
        }
        store.unblockLegacy(card.id.uuidString)
    }

    // MARK: Export / import (manual "switching phones or ecosystems" path)

    /// Everything worth carrying to another device, sealed under a passphrase
    /// in the cross-platform bundle format (furcards-core ExportBundle). The
    /// file written here opens in the Android app and vice versa.
    func exportBundle(passphrase: String) throws -> Data {
        guard let crypto = CryptoRegistry.shared.provider,
              let storage = SecureStorageRegistry.shared.storage
        else { throw ExportError.cryptoUnavailable }
        let identity = IdentityManager(storage: storage, crypto: crypto).loadOrCreate()
        let signer = ownCardSigner ?? OwnCardSigner(userID: store.userID, identity: identity, crypto: crypto)
        let blocklist = blocklistStore ?? BlocklistStore(userID: store.userID)

        var historyByString = [String: [FurcardsCore.Encounter]]()
        for (cardID, encounters) in store.history {
            historyByString[cardID.uuidString] = encounters.map { $0.coreModel }
        }
        let payload = ExportPayload(
            privateKey: ExportPayload.companion.encodeKey(privateKey: identity.privateKey),
            ownCard: store.myCard.coreModel,
            cardVersion: Int64(signer.commonCard?.cardVersion ?? 0),
            seen: store.seen.map(\.coreModel),
            friends: store.friends.map(\.coreModel),
            history: historyByString,
            categories: store.categories.map { FurcardsCore.CardCategory(id: $0.id.uuidString, name: $0.name, cardIDs: $0.cardIDs.map(\.uuidString)) },
            blockedPubkeys: Array(blocklist.blocklist.blockedPublicKeys),
            blockedLegacyIds: Array(blocklist.blocklist.blockedLegacyIds),
            exportedAtMillis: Int64(Date().timeIntervalSince1970 * 1000)
        )
        var salt = Data(count: 16)
        var nonce = Data(count: 12)
        _ = salt.withUnsafeMutableBytes { SecRandomCopyBytes(kSecRandomDefault, 16, $0.baseAddress!) }
        _ = nonce.withUnsafeMutableBytes { SecRandomCopyBytes(kSecRandomDefault, 12, $0.baseAddress!) }
        return ExportBundle.shared.seal(
            payload: payload,
            passphrase: passphrase,
            crypto: crypto,
            salt: salt.kotlinByteArray,
            nonce: nonce.kotlinByteArray
        ).data
    }

    enum ExportError: Error { case cryptoUnavailable }

    /// Applies a bundle: replaces the identity + own card, merges the
    /// collection and blocklist, and reseals above the bundle's cardVersion so
    /// peers' supersession accepts the restored card. false = wrong passphrase
    /// or not a Furcards bundle.
    func importBundle(_ data: Data, passphrase: String) -> Bool {
        guard let crypto = CryptoRegistry.shared.provider,
              let storage = SecureStorageRegistry.shared.storage,
              let payload = ExportBundle.shared.open(bytes: data.kotlinByteArray, passphrase: passphrase, crypto: crypto),
              let privateKey = ExportPayload.companion.decodeKey(encoded: payload.privateKey)
        else { return false }

        // tear down anything derived from the old identity before replacing it
        bleExchange?.stop()
        bleExchange = nil
        ownCardSigner = nil
        let identity = IdentityManager(storage: storage, crypto: crypto).replace(privateKey: privateKey)

        var ownCard = Furcard.from(core: payload.ownCard)
        saveCard(ownCard)
        var history = [UUID: [Encounter]]()
        for (idString, encounters) in payload.history {
            guard let id = UUID(uuidString: idString) else { continue }
            history[id] = encounters.map { Encounter.from(core: $0) }
        }
        store.importCollection(
            seen: payload.seen.map { Furcard.from(core: $0) },
            friends: payload.friends.map { Furcard.from(core: $0) },
            history: history,
            categories: payload.categories.compactMap { core in
                guard let id = UUID(uuidString: core.id) else { return nil }
                return CardCategory(id: id, name: core.name, cardIDs: core.cardIDs.compactMap(UUID.init(uuidString:)))
            }
        )
        let blocklist = blocklistStore ?? BlocklistStore(userID: store.userID)
        blocklistStore = blocklist
        for pubkey in payload.blockedPubkeys {
            if let bytes = Data(hexString: pubkey) { blocklist.block(bytes.kotlinByteArray) }
        }
        for legacyID in payload.blockedLegacyIds { blocklist.blockLegacy(legacyID) }

        let signer = OwnCardSigner(userID: store.userID, identity: identity, crypto: crypto)
        ownCardSigner = signer
        signer.ensureSealed(
            card: ownCard,
            allowRelay: true,
            allowEncounterCount: false,
            minVersion: Int(payload.cardVersion)
        )
        reconcileBleExchange()
        return true
    }

    // MARK: Internal

    /// Re-seals and re-advertises the user's card whenever it changes.
    private func observeMyCard() {
        withObservationTracking {
            _ = store.myCard
        } onChange: {
            Task { @MainActor [weak self] in
                guard let self else { return }
                if self.settings.nearbyTradingEnabled {
                    self.ownCardSigner?.ensureSealed(card: self.store.myCard, allowRelay: self.settings.allowRelay, allowEncounterCount: self.settings.allowEncounterCount,
                        commonCount: Int64(self.store.seen.count), shinyCount: Int64(self.store.friends.count))
                    self.bleExchange?.refreshAdvertisement() // new version rides the local name
                }
                self.observeMyCard()
            }
        }
    }

    /// Reacts to the master toggle (start/stop the exchange) and the sharing
    /// consents. Relay/count ride the signed payload, so a consent change
    /// re-seals the card and re-advertises the new version.
    private func observeSettings() {
        withObservationTracking {
            _ = settings.nearbyTradingEnabled
            _ = settings.allowRelay
            _ = settings.allowEncounterCount
        } onChange: {
            Task { @MainActor [weak self] in
                guard let self else { return }
                self.reconcileBleExchange() // reseals with the current consents
                if self.settings.nearbyTradingEnabled {
                    self.bleExchange?.refreshAdvertisement() // new version rides the local name
                }
                self.observeSettings()
            }
        }
    }
}
