//
//  Furcard.swift
//  Furcards
//
//  Created by Riley on 08/07/2026.
//

import Foundation

/// A social platform a card can link to.
enum SocialPlatform: String, CaseIterable, Identifiable, Hashable, Codable, Sendable {
    case bluesky
    case twitter
    case instagram
    case telegram
    case discord
    case barq
    case website
    case email

    var id: String { rawValue }

    var label: String {
        switch self {
        case .bluesky: "Bluesky"
        case .twitter: "Twitter"
        case .instagram: "Instagram"
        case .telegram: "Telegram"
        case .discord: "Discord"
        case .barq: "Barq"
        case .website: "Website"
        case .email: "Email"
        }
    }

    /// SF Symbol used to represent the platform.
    var systemImage: String {
        switch self {
        case .bluesky: "cloud.fill"
        case .twitter: "at"
        case .instagram: "camera.fill"
        case .telegram: "paperplane.fill"
        case .discord: "message.fill"
        case .barq: "pawprint.fill"
        case .website: "globe"
        case .email: "envelope.fill"
        }
    }

    /// The URL that opens this profile in the browser or a mail composer.
    /// Returns nil for platforms whose handles aren't directly addressable.
    func profileURL(for handle: String) -> URL? {
        let trimmed = handle.trimmingCharacters(in: .whitespaces)
        guard !trimmed.isEmpty else { return nil }
        let username = trimmed.hasPrefix("@") ? String(trimmed.dropFirst()) : trimmed
        let encoded = username.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? username

        switch self {
        case .bluesky: return URL(string: "https://bsky.app/profile/\(encoded)")
        case .twitter: return URL(string: "https://x.com/\(encoded)")
        case .instagram: return URL(string: "https://instagram.com/\(encoded)")
        case .telegram: return URL(string: "https://t.me/\(encoded)")
        case .discord, .barq:
            // handles here aren't web-addressable
            return nil
        case .website:
            if trimmed.hasPrefix("http://") || trimmed.hasPrefix("https://") {
                return URL(string: trimmed)
            }
            return URL(string: "https://\(trimmed)")
        case .email:
            return URL(string: "mailto:\(trimmed)")
        }
    }
}

/// Who can see a given social link.
enum SocialVisibility: String, CaseIterable, Identifiable, Hashable, Codable, Sendable {
    /// Shown on the common card everyone collects.
    case everyone
    /// Only revealed after a mutual bump (on the friend card).
    case friends

    var id: String { rawValue }

    var label: String {
        switch self {
        case .everyone: "Everyone"
        case .friends: "Friends only"
        }
    }

    var systemImage: String {
        switch self {
        case .everyone: "globe"
        case .friends: "lock.fill"
        }
    }
}

/// A single social link shown on the back of a card.
struct SocialLink: Identifiable, Hashable, Codable, Sendable {
    let id: UUID
    var platform: SocialPlatform
    var handle: String
    /// Whether this link appears on the common card or only after friending.
    var visibility: SocialVisibility

    init(
        id: UUID = UUID(),
        platform: SocialPlatform,
        handle: String,
        visibility: SocialVisibility = .everyone
    ) {
        self.id = id
        self.platform = platform
        self.handle = handle
        self.visibility = visibility
    }
}

/// Layout template for the card front: how the photo and info are arranged.
enum CardTemplate: String, Codable, CaseIterable, Identifiable, Sendable {
    /// Header, framed photo, tags, bio, message (the original layout).
    case classic
    /// Photo fills the whole card, with name and message overlaid at the bottom.
    case fullBleed
    /// Large photo up top, info stacked beneath (poster look).
    case portrait

    var id: String { rawValue }

    var label: String {
        switch self {
        case .classic: "Classic"
        case .fullBleed: "Full Photo"
        case .portrait: "Portrait"
        }
    }

    var icon: String {
        switch self {
        case .classic: "rectangle.split.1x2"
        case .fullBleed: "photo.fill"
        case .portrait: "rectangle.portrait"
        }
    }
}

struct Furcard: Identifiable, Hashable, Codable, Sendable {
    let id: UUID
    var name: String
    var pronouns: String
    /// Identity flags rendered beneath the pronouns, e.g. "🏳️‍⚧️ 🏳️‍🌈".
    var identityFlags: String
    /// Name of the artwork image in the asset catalog (fallback when no photo).
    var artworkName: String
    /// A user-chosen, card-cropped artwork photo. Takes priority over `artworkName`.
    var artworkData: Data?
    /// The full, uncropped photo the crop was made from, so changing layouts can
    /// re-crop from the original. Stored server-side but only returned to the
    /// owner; everyone else gets just the cropped `artworkData`.
    var originalArtworkData: Data? = nil
    /// Credited artist, shown as "Art by …".
    var artistCredit: String
    var tags: [String]
    var bio: String
    /// Social links shown on the back of the card.
    var socials: [SocialLink]
    /// The message shown at the bottom of the card. On a common card this is
    /// the owner's global card message; on a friend card it's the custom
    /// message they attached when bumping.
    var message: String
    /// The card's visual style: background, pattern, and friend glow.
    var theme: CardTheme
    /// The front layout template. Optional for backward compatibility with cards
    /// saved before templates existed (nil is treated as `.classic`).
    var template: CardTemplate?

    /// Lifetime stats computed by the backend and shown on the card back:
    /// walk-by count and bump count. Read-only here; the server recomputes them.
    var walkedByCount: Int? = nil
    var bumpCount: Int? = nil

    /// Hex Ed25519 public key when this entry came from a verified signed blob
    /// (BLE exchange). Nil for server-era cards and the owner's own card; that
    /// absence is the legacy marker, see `isLegacy`.
    var pubkey: String? = nil
    /// cardVersion of the signed blob this entry was built from.
    var signedCardVersion: Int? = nil

    /// Server-era card that predates signing. Derived, not stored: pubkey-less
    /// cards are legacy. They stay displayable, are never relayed, and upgrade
    /// in place on the next in-person exchange.
    var isLegacy: Bool { pubkey == nil }

    init(
        id: UUID = UUID(),
        name: String,
        pronouns: String,
        identityFlags: String,
        artworkName: String,
        artworkData: Data? = nil,
        artistCredit: String,
        tags: [String],
        bio: String,
        socials: [SocialLink] = [],
        message: String = "",
        theme: CardTheme = .default,
        template: CardTemplate? = nil
    ) {
        self.id = id
        self.name = name
        self.pronouns = pronouns
        self.identityFlags = identityFlags
        self.artworkName = artworkName
        self.artworkData = artworkData
        self.artistCredit = artistCredit
        self.tags = tags
        self.bio = bio
        self.socials = socials
        self.message = message
        self.theme = theme
        self.template = template
    }

    /// The layout to render, treating a missing template as `.classic`.
    var effectiveTemplate: CardTemplate { template ?? .classic }

    /// The public version collected by passing someone: friends-only socials
    /// stripped out. Bumping reveals the full card.
    var commonCard: Furcard {
        var copy = self
        copy.socials = socials.filter { $0.visibility == .everyone }
        return copy
    }
}

extension Furcard {
    /// A blank card, the starting point for a new account, filled in during setup.
    static let sample = Furcard(
        name: "",
        pronouns: "",
        identityFlags: "",
        artworkName: "",
        artistCredit: "",
        tags: [],
        bio: "",
        socials: [],
        message: ""
    )

    /// Stand-in cards for other people (simulator, previews, test data). No
    /// artwork and their own distinct colors so they never look like the user's
    /// own card.
    static let samplePeople: [Furcard] = [
        Furcard(
            name: "Rowan Emberpaw",
            pronouns: "He/Him",
            identityFlags: "🏳️‍🌈",
            artworkName: "",
            artistCredit: "",
            tags: ["Fox", "Gay", "Coffee gremlin"],
            bio: "Red fox running on espresso and spite. Will draw your fursona for snacks.",
            socials: [
                SocialLink(platform: .bluesky, handle: "@rowanfox.bsky.social"),
                SocialLink(platform: .website, handle: "rowanfox.art"),
                SocialLink(platform: .discord, handle: "rowanfox", visibility: .friends)
            ],
            message: "Commission slots open — trade art with me?",
            theme: CardTheme.presets[0]
        ),
        Furcard(
            name: "Juniper Sky",
            pronouns: "They/Them",
            identityFlags: "🏳️‍⚧️ 🏳️‍🌈",
            artworkName: "CardArtwork",
            artistCredit: "Juniper Sky",
            tags: ["Winged wolf", "Agender", "Synth nerd"],
            bio: "Making squishy synth sounds at 2am. Ask me about modular.",
            socials: [
                SocialLink(platform: .instagram, handle: "@junisky"),
                SocialLink(platform: .discord, handle: "junisky", visibility: .friends)
            ],
            message: "Ask me about modular synths!",
            theme: CardTheme.presets[1],
            template: .portrait
        ),
        Furcard(
            name: "Mikko Tundra",
            pronouns: "She/Her",
            identityFlags: "🏳️‍⚧️",
            artworkName: "CardArtwork",
            artistCredit: "Mikko Tundra",
            tags: ["Arctic hare", "Trans woman", "Runner"],
            bio: "Cold weather, warm heart. Marathon training and too many carrots.",
            socials: [
                SocialLink(platform: .twitter, handle: "@tundrabun"),
                SocialLink(platform: .telegram, handle: "@mikko", visibility: .friends)
            ],
            message: "Looking for a running buddy 🏃‍♀️",
            theme: CardTheme.presets[2],
            template: .fullBleed
        ),
        Furcard(
            name: "Cypress Vale",
            pronouns: "It/Its",
            identityFlags: "🏳️‍🌈",
            artworkName: "",
            artistCredit: "",
            tags: ["Cyber-deer", "Queer", "Hacker"],
            bio: "Chrome antlers and a soldering iron. Breaks things so you don't have to.",
            socials: [
                SocialLink(platform: .website, handle: "cyberdeer.dev"),
                SocialLink(platform: .email, handle: "hi@cyberdeer.dev", visibility: .friends)
            ],
            message: "Let's build something weird.",
            theme: CardTheme.presets[3]
        ),
        Furcard(
            name: "Pip Marigold",
            pronouns: "She/They",
            identityFlags: "🏳️‍⚧️ 🏳️‍🌈",
            artworkName: "CardArtwork",
            artistCredit: "Pip Marigold",
            tags: ["Honey badger", "Bi", "Baker"],
            bio: "Small, fierce, covered in flour. Sourdough is a personality.",
            socials: [
                SocialLink(platform: .instagram, handle: "@pipbakes"),
                SocialLink(platform: .telegram, handle: "@pip", visibility: .friends)
            ],
            message: "Say hi and I'll bring you cookies 🍪",
            theme: CardTheme.presets[4],
            template: .fullBleed
        )
    ]
}
