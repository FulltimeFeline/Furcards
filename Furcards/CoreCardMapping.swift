//
//  CoreCardMapping.swift
//  Furcards
//
//  Bridges the app's Furcard model to FurcardsCore's card types. The core owns
//  the wire format (CardMapping / SignedCard); this file only converts between
//  the Swift structs the UI uses and the Kotlin objects the core takes. It
//  never encodes protocol bytes itself.
//

import Foundation
import FurcardsCore

// MARK: Swift model → core model

extension Furcard {
    /// Core (Kotlin) representation of this card, fed to
    /// `CardMapping.toPayload` when sealing. Artwork travels separately as
    /// thumbnail bytes, so the core model's artwork fields stay empty here.
    var coreModel: FurcardsCore.Furcard {
        FurcardsCore.Furcard(
            id: id.uuidString,
            name: name,
            pronouns: pronouns,
            identityFlags: identityFlags,
            artworkName: "",
            // data-uri form, the cross-platform artwork encoding (android
            // stores it this way; the export bundle carries art both ways)
            artworkData: artworkData.map { "data:image/jpeg;base64," + $0.base64EncodedString() },
            originalArtworkData: nil,
            artistCredit: artistCredit,
            tags: tags,
            bio: bio,
            socials: socials.map { $0.coreModel },
            message: message,
            theme: theme.coreModel,
            template: template?.coreModel,
            walkedByCount: nil,
            bumpCount: nil,
            pubkey: nil,
            signedCardVersion: nil
        )
    }

    /// Both signed tiers of this card (migration ruling D5): the common blob
    /// walk-bys and gossip carry, and the friend blob a mutual bump unlocks.
    /// `thumbnail` must already be re-encoded to the 256×256 / ≤32 KB cap.
    /// `fullArt` (≤300 KB) is hashed here and transferred out of band.
    func sealed(
        version: UInt32,
        privateKey: Data,
        crypto: CryptoProvider,
        thumbnail: Data?,
        fullArt: Data?,
        allowRelay: Bool,
        allowEncounterCount: Bool,
        legacyId: String?,
        commonCount: Int64 = 0,
        shinyCount: Int64 = 0
    ) -> (common: SignedCard, friend: SignedCard) {
        let artHash = fullArt.map { Sha256.shared.hash(message: $0.kotlinByteArray) }
        func seal(friendTier: Bool) -> SignedCard {
            let payload = CardMapping.shared.toPayload(
                card: coreModel,
                friendTier: friendTier,
                allowRelay: allowRelay,
                allowEncounterCount: allowEncounterCount,
                thumbnail: thumbnail?.kotlinByteArray,
                fullArtHash: artHash,
                legacyId: legacyId,
                commonCount: commonCount,
                shinyCount: shinyCount
            )
            return SignedCard.companion.seal(
                payload: payload,
                cardVersion: version,
                privateKey: privateKey.kotlinByteArray,
                crypto: crypto
            )
        }
        return (common: seal(friendTier: false), friend: seal(friendTier: true))
    }
}

extension SocialLink {
    var coreModel: FurcardsCore.SocialLink {
        FurcardsCore.SocialLink(
            id: id.uuidString,
            platform: platform.coreModel,
            handle: handle,
            visibility: visibility.coreModel
        )
    }
}

extension SocialPlatform {
    var coreModel: FurcardsCore.SocialPlatform {
        switch self {
        case .bluesky: .bluesky
        case .twitter: .twitter
        case .instagram: .instagram
        case .telegram: .telegram
        case .discord: .discord
        case .barq: .barq
        case .website: .website
        case .email: .email
        }
    }

    init(_ core: FurcardsCore.SocialPlatform) {
        switch core {
        case .bluesky: self = .bluesky
        case .twitter: self = .twitter
        case .instagram: self = .instagram
        case .telegram: self = .telegram
        case .discord: self = .discord
        case .barq: self = .barq
        case .website: self = .website
        case .email: self = .email
        default: self = .website
        }
    }
}

extension SocialVisibility {
    var coreModel: FurcardsCore.SocialVisibility {
        switch self {
        case .everyone: .everyone
        case .friends: .friends
        }
    }

    init(_ core: FurcardsCore.SocialVisibility) {
        self = core == .friends ? .friends : .everyone
    }
}

extension CardTemplate {
    var coreModel: FurcardsCore.CardTemplate {
        switch self {
        case .classic: .classic
        case .fullBleed: .fullBleed
        case .portrait: .portrait
        }
    }

    init(_ core: FurcardsCore.CardTemplate) {
        switch core {
        case .fullBleed: self = .fullBleed
        case .portrait: self = .portrait
        default: self = .classic
        }
    }
}

extension CardTheme {
    var coreModel: FurcardsCore.CardTheme {
        FurcardsCore.CardTheme(
            colors: colors.map { $0.coreModel },
            pattern: pattern.coreModel,
            glowColors: glowColors.map { $0.coreModel }
        )
    }
}

extension CardColor {
    var coreModel: FurcardsCore.CardColor {
        FurcardsCore.CardColor(id: id.uuidString, red: red, green: green, blue: blue)
    }
}

extension CardPattern {
    var coreModel: FurcardsCore.CardPattern {
        switch self {
        case .none: .none
        case .sparkles: .sparkles
        case .dots: .dots
        }
    }

    init(_ core: FurcardsCore.CardPattern) {
        switch core {
        case .sparkles: self = .sparkles
        case .dots: self = .dots
        default: self = .none
        }
    }
}

// MARK: core model ↔ Swift model (export/import + restore paths)

extension Furcard {
    /// Inverse of `coreModel`, used when a bundle written by either platform
    /// is imported here.
    static func from(core: FurcardsCore.Furcard) -> Furcard {
        var card = Furcard(
            id: UUID(uuidString: core.id) ?? UUID(),
            name: core.name,
            pronouns: core.pronouns,
            identityFlags: core.identityFlags,
            artworkName: "",
            artworkData: core.artworkData.flatMap { uri in
                guard let base64 = uri.components(separatedBy: "base64,").last else { return nil }
                return Data(base64Encoded: base64)
            },
            artistCredit: core.artistCredit,
            tags: core.tags,
            bio: core.bio,
            socials: core.socials.map {
                SocialLink(
                    id: UUID(uuidString: $0.id) ?? UUID(),
                    platform: SocialPlatform($0.platform),
                    handle: $0.handle,
                    visibility: SocialVisibility($0.visibility)
                )
            },
            message: core.message,
            theme: CardTheme(
                colors: core.theme.colors.map { CardColor(red: $0.red, green: $0.green, blue: $0.blue) },
                pattern: CardPattern(core.theme.pattern),
                glowColors: core.theme.glowColors.map { CardColor(red: $0.red, green: $0.green, blue: $0.blue) }
            ),
            template: core.template_.map(CardTemplate.init)
        )
        card.pubkey = core.pubkey
        card.signedCardVersion = core.signedCardVersion?.intValue
        return card
    }
}

extension Encounter {
    var coreModel: FurcardsCore.Encounter {
        FurcardsCore.Encounter(
            id: id.uuidString,
            kind: kind == .bump ? .bump : .walkedBy,
            date: Int64(date.timeIntervalSince1970 * 1000),
            latitude: latitude.map { KotlinDouble(value: $0) },
            longitude: longitude.map { KotlinDouble(value: $0) },
            myMessage: myMessage,
            theirMessage: theirMessage
        )
    }

    static func from(core: FurcardsCore.Encounter) -> Encounter {
        Encounter(
            id: UUID(uuidString: core.id) ?? UUID(),
            kind: core.kind == .bump ? .bump : .walkedBy,
            date: Date(timeIntervalSince1970: Double(core.date) / 1000),
            latitude: core.latitude?.doubleValue,
            longitude: core.longitude?.doubleValue,
            myMessage: core.myMessage,
            theirMessage: core.theirMessage
        )
    }
}

// MARK: core (verified) → Swift model

extension Furcard {
    /// Rebuilds a displayable card from a verified signed blob. The stable
    /// storage id comes from the sender's public key (CardMapping.storageId),
    /// so every re-receipt lands on the same collection entry.
    init(verified: VerifiedCard) {
        let payload = verified.payload
        var built = Furcard(
            id: UUID(uuidString: CardMapping.shared.storageId(publicKey: verified.publicKey)) ?? UUID(),
            name: payload.name,
            pronouns: payload.pronouns,
            identityFlags: payload.identityFlags,
            artworkName: "",
            artworkData: payload.thumbnail.map { Data($0) },
            artistCredit: payload.artistCredit,
            tags: payload.tags,
            bio: payload.bio,
            socials: payload.socials.map {
                SocialLink(
                    platform: SocialPlatform($0.platform),
                    handle: $0.handle,
                    visibility: SocialVisibility($0.visibility)
                )
            },
            message: payload.message,
            theme: CardTheme(
                colors: payload.theme.colors.map { CardColor(red: $0.red, green: $0.green, blue: $0.blue) },
                pattern: CardPattern(payload.theme.pattern),
                glowColors: payload.theme.glowColors.map { CardColor(red: $0.red, green: $0.green, blue: $0.blue) }
            ),
            // `template` is a c++ keyword, so kotlin exposes it as `template_`
            template: payload.template_.map(CardTemplate.init)
        )
        built.pubkey = verified.publicKeyHex
        built.signedCardVersion = Int(verified.cardVersion)
        // owner's collection sizes, shown on the back, only when they shared
        if verified.allowsEncounterCount {
            built.walkedByCount = Int(payload.commonCount)
            built.bumpCount = Int(payload.shinyCount)
        }
        self = built
    }
}
