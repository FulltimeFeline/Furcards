//
//  GoldenVectorTests.swift
//  FurcardsTests
//
//  iOS half of the cross-platform golden-vector contract. Everything in
//  furcards-core/src/commonTest/resources/vectors/v1.json (synced here as
//  vectors-v1.json by scripts/refresh-core.sh) must reproduce byte-for-byte
//  through the FurcardsCore framework driven by the CryptoKit provider.
//
//  CryptoKit's Ed25519 signatures are randomized, so the exact signature
//  bytes aren't reproducible like Tink's. So the tests pin the signed region
//  (header + payload) against the vectors and check that signatures
//  cross-verify: Tink-signed vectors verify under CryptoKit, and
//  CryptoKit-signed blobs verify under the same RFC 8032 rules Tink uses.
//

import CryptoKit
import Foundation
import FurcardsCore
import Testing
@testable import Furcards

struct GoldenVectorTests {
    // MARK: vector plumbing

    static let vectors: [String: String] = {
        let url = Bundle(for: BundleToken.self).url(forResource: "vectors-v1", withExtension: "json")!
        let data = try! Data(contentsOf: url)
        return try! JSONDecoder().decode([String: String].self, from: data)
    }()

    private func vector(_ key: String) -> Data {
        Data(hexString: Self.vectors[key]!)!
    }

    private let crypto = CryptoKitCryptoProvider()
    private let legacyId = "11111111-2222-3333-4444-555555555555"
    private let epochSeconds: Int64 = 1_760_000_000
    private let cardVersion: UInt32 = 7

    private var thumbnail: Data { Data((0..<64).map { UInt8($0) }) }

    // MARK: rfc 8032: pin CryptoKit to the same vectors Tink passes

    @Test func rfc8032KeysDeriveAndVectorSignaturesVerify() {
        let seedA = vector("seedA").kotlinByteArray
        #expect(crypto.publicKey(privateKey: seedA).data == vector("pubA"))
        let seedB = vector("seedB").kotlinByteArray
        #expect(crypto.publicKey(privateKey: seedB).data == vector("pubB"))
    }

    @Test func cryptoKitSignaturesVerifyUnderRfc8032() {
        let seedA = vector("seedA").kotlinByteArray
        let message = "trade cards with me".data(using: .utf8)!.kotlinByteArray
        let signature = crypto.sign(privateKey: seedA, message: message)
        #expect(crypto.verify(publicKey: vector("pubA").kotlinByteArray, message: message, signature: signature))
        #expect(!crypto.verify(publicKey: vector("pubB").kotlinByteArray, message: message, signature: signature))
    }

    // MARK: signed blobs: tink-signed vectors must verify under cryptokit

    @Test func goldenBlobsVerifyWithCryptoKit() throws {
        let common = try #require(SignedCard.companion.fromBytes(bytes: vector("commonBlob").kotlinByteArray))
        let verified = try #require(common.verify(crypto: crypto))
        #expect(verified.payload.name == "Rowan Emberpaw")
        #expect(verified.publicKey.data == vector("pubA"))
        #expect(!verified.isFriendTier)
        #expect(verified.payload.socials.count == 2)

        let friend = try #require(SignedCard.companion.fromBytes(bytes: vector("friendBlob").kotlinByteArray))
        let verifiedFriend = try #require(friend.verify(crypto: crypto))
        #expect(verifiedFriend.isFriendTier)
        #expect(verifiedFriend.payload.socials.count == 3)

        var tampered = vector("commonBlob")
        tampered[120] ^= 0x01
        let tamperedCard = try #require(SignedCard.companion.fromBytes(bytes: tampered.kotlinByteArray))
        #expect(tamperedCard.verify(crypto: crypto) == nil)
    }

    // MARK: sealing: payload + header must reproduce exactly, sig re-verifies

    @Test func resealingReproducesSignedRegionByteForByte() throws {
        let card = FurcardsCore.Furcard.companion.samplePeople[0]
        func payload(friendTier: Bool) -> CardPayload {
            CardMapping.shared.toPayload(
                card: card,
                friendTier: friendTier,
                allowRelay: true,
                allowEncounterCount: true,
                thumbnail: thumbnail.kotlinByteArray,
                fullArtHash: nil,
                legacyId: legacyId
            )
        }
        let sealed = SignedCard.companion.seal(
            payload: payload(friendTier: false),
            cardVersion: cardVersion,
            privateKey: vector("seedA").kotlinByteArray,
            crypto: crypto
        )
        let expected = vector("commonBlob")
        // header prefix (format, version, length, pubkey): bytes [0, 41)
        #expect(sealed.bytes.data.prefix(41) == expected.prefix(41))
        // payload region, bytes [105, end): the exact bytes that were signed
        #expect(sealed.bytes.data.dropFirst(105) == expected.dropFirst(105))
        #expect(sealed.payloadBytes.data == vector("commonPayload"))
        // signature bytes differ (randomized ed25519) but must verify
        #expect(sealed.verify(crypto: crypto) != nil)

        let friendSealed = SignedCard.companion.seal(
            payload: payload(friendTier: true),
            cardVersion: cardVersion,
            privateKey: vector("seedA").kotlinByteArray,
            crypto: crypto
        )
        #expect(friendSealed.payloadBytes.data == vector("friendPayload"))
    }

    // MARK: hello, bloom, ephemeral ids: fully deterministic, exact match

    @Test func ephemeralIdsMatchVectors() {
        let seed = EphemeralId.shared.deriveSeed(privateKey: vector("seedA").kotlinByteArray)
        #expect(seed.data == vector("ephSeedA"))
        let window = EphemeralId.shared.window(epochSeconds: epochSeconds)
        #expect(EphemeralId.shared.forWindow(seed: seed, window: window).data == vector("ephIdA"))
        #expect(EphemeralId.shared.forWindow(seed: seed, window: window + 1).data == vector("ephIdA_next"))
    }

    @Test func bloomAndHelloMatchVectors() {
        let bloom = BloomFilter(bits: KotlinByteArray(size: 256))
        let pubB = vector("pubB").kotlinByteArray
        let pubC = Data(repeating: 0xCC, count: 32).kotlinByteArray
        bloom.add(key: BloomFilter.companion.cardKey(publicKey: pubB, cardVersion: 1))
        bloom.add(key: BloomFilter.companion.cardKey(publicKey: pubB, cardVersion: 3))
        bloom.add(key: BloomFilter.companion.cardKey(publicKey: pubC, cardVersion: 2))
        #expect(bloom.bits.data == vector("bloom"))
        #expect(!bloom.mightContain(key: BloomFilter.companion.cardKey(publicKey: pubB, cardVersion: 2)))

        let hello = Hello(
            protocolVersion: 1,
            ephemeralId: vector("ephIdA").kotlinByteArray,
            cardVersion: Int64(cardVersion),
            seenBloom: bloom.bits,
            bumpIntent: true,
            bumpMessage: "vector hello",
            publicKey: vector("pubA").kotlinByteArray
        )
        #expect(hello.encode().data == vector("hello"))
    }

    // MARK: platform actuals: keychain storage + identity manager

    @Test func keychainBackedIdentityIsStableAndDestroyable() throws {
        let storage = KeychainSecureStorage()
        storage.delete(key: IdentityManager.companion.KEY_PRIVATE) // clean slate
        let manager = IdentityManager(storage: storage, crypto: crypto)
        let first = manager.loadOrCreate()
        let second = manager.loadOrCreate()
        #expect(first.privateKey.data == second.privateKey.data)
        #expect(first.publicKey.data == second.publicKey.data)
        #expect(first.publicKey.data == crypto.publicKey(privateKey: first.privateKey).data)
        manager.destroy()
        let third = manager.loadOrCreate()
        #expect(third.privateKey.data != first.privateKey.data)
        manager.destroy()
    }

    // MARK: mapping layer: swift model to core payload round trip

    @Test func swiftMappingRoundTripsThroughSealedBlob() throws {
        let card = Furcards.Furcard.samplePeople[1] // juniper sky
        let (common, friend) = card.sealed(
            version: 3,
            privateKey: vector("seedB"),
            crypto: crypto,
            thumbnail: thumbnail,
            fullArt: nil,
            allowRelay: true,
            allowEncounterCount: false,
            legacyId: card.id.uuidString
        )
        let verified = try #require(common.verify(crypto: crypto))
        let rebuilt = Furcards.Furcard(verified: verified)
        #expect(rebuilt.name == card.name)
        #expect(rebuilt.pronouns == card.pronouns)
        #expect(rebuilt.tags == card.tags)
        #expect(rebuilt.bio == card.bio)
        #expect(rebuilt.template == card.template)
        #expect(rebuilt.theme.pattern == card.theme.pattern)
        #expect(rebuilt.artworkData == thumbnail)
        #expect(rebuilt.socials.map(\.handle) == card.commonCard.socials.map(\.handle))

        let verifiedFriend = try #require(friend.verify(crypto: crypto))
        #expect(verifiedFriend.payload.socials.count == card.socials.count)
        #expect(verified.payload.legacyId == card.id.uuidString)

        // stable storage id: same identity gives the same collection entry
        let again = Furcards.Furcard(verified: verified)
        #expect(again.id == rebuilt.id)
    }
}

private final class BundleToken {}
