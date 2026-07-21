//
//  ExchangeStores.swift
//  Furcards
//
//  Persistence for the serverless BLE exchange (Phase 3): received signed
//  blobs kept byte-exact for relay, the pubkey blocklist the core enforces,
//  and the user's own sealed card blobs. Mirrors the Android trio
//  (BlobCache / BlocklistStore / OwnCardSigner): same keys, same semantics.
//

import Foundation
import FurcardsCore
import UIKit

/// Received signed card blobs, kept as the exact bytes they arrived as.
/// Gossip re-transmits these verbatim: the sign-exact-bytes rule means a blob
/// we re-encoded ourselves would fail everyone else's verification.
@MainActor
final class BlobCache {
    private struct Entry: Codable {
        var blob: Data
        var receivedAt: Double
    }

    private let key: String
    private var entries: [Entry]

    init(userID: String) {
        key = "BlobCache.v1.\(userID)"
        if let data = UserDefaults.standard.data(forKey: key),
           let decoded = try? JSONDecoder().decode([Entry].self, from: data) {
            entries = decoded
        } else {
            entries = []
        }
    }

    /// Stores a verified common-tier blob for relay, newest first, one per
    /// identity with higher versions replacing lower. Friend blobs never
    /// enter a relay cache; they were given to this user alone.
    func put(_ verified: VerifiedCard, receivedAt: Date) {
        guard !verified.isFriendTier else { return }
        let incoming = verified.card
        entries.removeAll { entry in
            guard let existing = SignedCard.companion.fromBytes(bytes: entry.blob.kotlinByteArray) else { return true }
            return existing.publicKeyHex == incoming.publicKeyHex && existing.cardVersion <= incoming.cardVersion
        }
        entries.insert(Entry(blob: incoming.bytes.data, receivedAt: receivedAt.timeIntervalSince1970), at: 0)
        if entries.count > Self.maxEntries {
            entries.removeLast(entries.count - Self.maxEntries)
        }
        persist()
    }

    /// Relay candidates, newest first, re-verified on the way out (the cache
    /// is app storage, not a trust boundary).
    func relayCandidates(crypto: CryptoProvider) -> [VerifiedCard] {
        entries.compactMap { entry in
            SignedCard.companion.fromBytes(bytes: entry.blob.kotlinByteArray)?.verify(crypto: crypto)
        }
    }

    func removeIdentity(pubkeyHex: String) {
        entries.removeAll { entry in
            SignedCard.companion.fromBytes(bytes: entry.blob.kotlinByteArray)?.publicKeyHex == pubkeyHex
        }
        persist()
    }

    private func persist() {
        if let data = try? JSONEncoder().encode(entries) {
            UserDefaults.standard.set(data, forKey: key)
        }
    }

    /// A con-day of cards; oldest fall off and re-arrive via gossip.
    private static let maxEntries = 256
}

/// Persists the pubkey blocklist the core enforces (display + relay +
/// session gate). Local-only and identity-keyed; this is what survives the
/// server's removal. Server blocks get ported in while the backend is still
/// reachable (migration D10).
@MainActor
final class BlocklistStore {
    private struct Snapshot: Codable {
        var pubkeys: [String]
        var legacyIds: [String]
    }

    private let key: String
    private(set) var blocklist: Blocklist

    init(userID: String) {
        key = "Blocklist.v1.\(userID)"
        if let data = UserDefaults.standard.data(forKey: key),
           let snapshot = try? JSONDecoder().decode(Snapshot.self, from: data) {
            blocklist = Blocklist(blockedPublicKeys: Set(snapshot.pubkeys), blockedLegacyIds: Set(snapshot.legacyIds))
        } else {
            blocklist = Blocklist(blockedPublicKeys: [], blockedLegacyIds: [])
        }
    }

    func block(_ pubkey: KotlinByteArray) {
        blocklist.block(publicKey: pubkey)
        persist()
    }

    func blockLegacy(_ storageId: String) {
        blocklist.blockLegacy(storageId: storageId)
        persist()
    }

    func unblock(_ pubkey: KotlinByteArray) {
        blocklist.unblock(publicKey: pubkey)
        persist()
    }

    func unblockLegacy(_ storageId: String) {
        blocklist.unblockLegacy(storageId: storageId)
        persist()
    }

    private func persist() {
        let snapshot = Snapshot(
            pubkeys: Array(blocklist.blockedPublicKeys),
            legacyIds: Array(blocklist.blockedLegacyIds)
        )
        if let data = try? JSONEncoder().encode(snapshot) {
            UserDefaults.standard.set(data, forKey: key)
        }
    }
}

/// Seals the user's own card into the two signed blobs the protocol carries
/// (common + friend, ruling D5), bumping the monotonic cardVersion whenever
/// the content changes. Blobs are persisted so the version survives restarts:
/// re-sealing unchanged content must not mint a new version.
@MainActor
final class OwnCardSigner {
    private struct Sealed: Codable {
        var cardVersion: Int
        /// SHA-256 of the inputs that produced this version, for change detection.
        var contentHash: String
        var commonBlob: Data
        var friendBlob: Data
        var fullArt: Data?
    }

    private let key: String
    private let identity: Identity
    private let crypto: CryptoProvider
    private var sealed: Sealed?

    init(userID: String, identity: Identity, crypto: CryptoProvider) {
        key = "OwnCardSigner.v1.\(userID)"
        self.identity = identity
        self.crypto = crypto
        if let data = UserDefaults.standard.data(forKey: key),
           let decoded = try? JSONDecoder().decode(Sealed.self, from: data),
           decoded.cardVersion > 0 {
            sealed = decoded
        }
        // a restored install can carry sealed blobs from a different identity
        // (cloud restore mints a fresh key; import installs the bundle's key).
        // serving old-key blobs under the current hello makes peers drop the
        // card, so discard and reseal under the current identity.
        if let blob = sealed.flatMap({ SignedCard.companion.fromBytes(bytes: $0.commonBlob.kotlinByteArray) }),
           blob.publicKey.data != crypto.publicKey(privateKey: identity.privateKey).data {
            sealed = nil
        }
    }

    var commonCard: SignedCard? {
        sealed.flatMap { SignedCard.companion.fromBytes(bytes: $0.commonBlob.kotlinByteArray) }
    }

    var friendCard: SignedCard? {
        sealed.flatMap { SignedCard.companion.fromBytes(bytes: $0.friendBlob.kotlinByteArray) }
    }

    var fullArt: Data? { sealed?.fullArt }

    /// (Re)seals if the card content changed since the last seal. Call on
    /// startup and whenever myCard or the relay/count toggles change.
    /// `minVersion` is the import path's continuity floor: peers already know
    /// the bundle's cardVersion, so the restored device must seal above it or
    /// supersession rejects its own card everywhere.
    func ensureSealed(card: Furcard, allowRelay: Bool, allowEncounterCount: Bool, commonCount: Int64 = 0, shinyCount: Int64 = 0, minVersion: Int = 0) {
        // never seal a blank card: no name = no profile = nothing to
        // advertise (mirrors the android guard; there the store also emits a
        // blank first value on every start and sealing it shipped empty cards
        // to anyone exchanging in that window)
        guard !card.name.trimmingCharacters(in: .whitespaces).isEmpty else { return }
        let thumbnail = thumbnailBytes(card)
        let fullArt = fullArtBytes(card)
        let hash = contentHash(card, allowRelay, allowEncounterCount, thumbnail, fullArt, commonCount, shinyCount)
        if let current = sealed, current.contentHash == hash, current.cardVersion > minVersion { return }

        let version = UInt32(max(sealed?.cardVersion ?? 0, minVersion) + 1)
        let (common, friend) = card.sealed(
            version: version,
            privateKey: identity.privateKey.data,
            crypto: crypto,
            thumbnail: thumbnail,
            fullArt: fullArt,
            allowRelay: allowRelay,
            allowEncounterCount: allowEncounterCount,
            // server-era card id, so receivers holding the old unsigned card
            // can offer the in-place upgrade (D14/§8)
            legacyId: card.id.uuidString,
            commonCount: commonCount,
            shinyCount: shinyCount
        )
        let next = Sealed(
            cardVersion: Int(version),
            contentHash: hash,
            commonBlob: common.bytes.data,
            friendBlob: friend.bytes.data,
            fullArt: fullArt
        )
        sealed = next
        if let data = try? JSONEncoder().encode(next) {
            UserDefaults.standard.set(data, forKey: key)
        }
    }

    // MARK: artwork re-encoding to the wire caps (D2), at seal time only

    /// The image that goes on the wire. A picked photo wins; otherwise a
    /// bundled-asset artwork is rasterized here, because asset names never
    /// cross the wire (D3). Without this, asset-artwork cards ship imageless.
    private func sealableArtwork(_ card: Furcard) -> UIImage? {
        if let data = card.artworkData, let image = UIImage(data: data) { return image }
        if !card.artworkName.isEmpty { return UIImage(named: card.artworkName) }
        return nil
    }

    private func thumbnailBytes(_ card: Furcard) -> Data? {
        guard let image = sealableArtwork(card) else { return nil }
        let scaled = image.resized(to: CGSize(width: 256, height: 256))
        return scaled.jpegUnder(byteCap: Int(CardCaps.shared.MAX_THUMBNAIL_BYTES))
    }

    private func fullArtBytes(_ card: Furcard) -> Data? {
        guard let image = sealableArtwork(card) else { return nil }
        let maxSide = max(image.size.width, image.size.height)
        guard maxSide > 256 else { return nil }
        let scale = min(1, 1024 / maxSide)
        let scaled = image.resized(to: CGSize(width: image.size.width * scale, height: image.size.height * scale))
        return scaled.jpegUnder(byteCap: Int(CardCaps.shared.MAX_FULL_ART_BYTES))
    }

    private func contentHash(
        _ card: Furcard,
        _ allowRelay: Bool,
        _ allowEncounterCount: Bool,
        _ thumbnail: Data?,
        _ fullArt: Data?,
        _ commonCount: Int64,
        _ shinyCount: Int64
    ) -> String {
        var bits = [
            card.name, card.pronouns, card.identityFlags, card.artistCredit,
            card.tags.joined(separator: " "), card.bio, card.message,
            card.socials.map { "\($0.platform.rawValue):\($0.handle):\($0.visibility.rawValue)" }.joined(separator: " "),
            card.template?.rawValue ?? "",
            card.theme.colors.map { "\($0.red),\($0.green),\($0.blue)" }.joined(separator: " "),
            card.theme.pattern.rawValue,
            card.theme.glowColors.map { "\($0.red),\($0.green),\($0.blue)" }.joined(separator: " "),
            String(allowRelay), String(allowEncounterCount),
            String(commonCount), String(shinyCount),
        ].joined().data(using: .utf8) ?? Data()
        bits.append(thumbnail ?? Data())
        bits.append(fullArt ?? Data())
        return Sha256.shared.hash(message: bits.kotlinByteArray).data.hexString
    }
}

private extension UIImage {
    func resized(to size: CGSize) -> UIImage {
        UIGraphicsImageRenderer(size: size).image { _ in
            draw(in: CGRect(origin: .zero, size: size))
        }
    }

    /// Walks JPEG quality down until the encoded size fits the cap.
    func jpegUnder(byteCap: Int) -> Data? {
        for quality in [0.85, 0.7, 0.55, 0.4, 0.25] {
            if let data = jpegData(compressionQuality: quality), data.count <= byteCap {
                return data
            }
        }
        return nil // pathological image; ship without art rather than over cap
    }
}
