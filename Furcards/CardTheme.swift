//
//  CardTheme.swift
//  Furcards
//
//  Created by Riley on 08/07/2026.
//

import SwiftUI
import UIKit

/// Codable RGB color, since SwiftUI `Color` isn't Codable.
struct CardColor: Codable, Hashable, Sendable, Identifiable {
    var id: UUID
    var red: Double
    var green: Double
    var blue: Double

    init(id: UUID = UUID(), red: Double, green: Double, blue: Double) {
        self.id = id
        self.red = red
        self.green = green
        self.blue = blue
    }

    /// Builds a `CardColor` from a SwiftUI `Color`.
    init(_ color: Color) {
        let ui = UIColor(color)
        var r: CGFloat = 0, g: CGFloat = 0, b: CGFloat = 0, a: CGFloat = 0
        ui.getRed(&r, green: &g, blue: &b, alpha: &a)
        self.init(red: Double(r), green: Double(g), blue: Double(b))
    }

    var color: Color {
        Color(red: red, green: green, blue: blue)
    }

    /// Replaces this color's components from a SwiftUI `Color`, keeping `id`.
    mutating func update(from color: Color) {
        let replacement = CardColor(color)
        red = replacement.red
        green = replacement.green
        blue = replacement.blue
    }
}

/// The decorative overlay pattern on a card.
enum CardPattern: String, Codable, CaseIterable, Identifiable, Sendable {
    case none
    case sparkles
    case dots

    var id: String { rawValue }

    var label: String {
        switch self {
        case .none: "None"
        case .sparkles: "Sparkles"
        case .dots: "Dots"
        }
    }
}

/// The full visual style of a card: background gradient, overlay pattern, and friend glow.
struct CardTheme: Codable, Hashable, Sendable {
    /// Background gradient colors, top-leading to bottom-trailing.
    var colors: [CardColor]
    var pattern: CardPattern
    /// Colors cycled through the animated friend-card glow.
    var glowColors: [CardColor]

    /// Rim gradient: background colors lightened so they read as an outline.
    var borderColors: [Color] {
        colors.map { c in
            Color(
                red: min(c.red * 0.55 + 0.45, 1),
                green: min(c.green * 0.55 + 0.45, 1),
                blue: min(c.blue * 0.55 + 0.45, 1)
            )
        }
    }

    /// The plain starting look: a neutral gray gradient with no pattern.
    static let `default` = CardTheme(
        colors: [
            CardColor(red: 0.16, green: 0.16, blue: 0.18),
            CardColor(red: 0.34, green: 0.34, blue: 0.38),
            CardColor(red: 0.72, green: 0.72, blue: 0.76)
        ],
        pattern: .none,
        glowColors: [
            CardColor(red: 1.00, green: 0.20, blue: 0.50),
            CardColor(red: 0.60, green: 0.20, blue: 0.85),
            CardColor(red: 0.20, green: 0.40, blue: 1.00),
            CardColor(red: 0.20, green: 0.80, blue: 0.90),
            CardColor(red: 0.30, green: 0.85, blue: 0.40),
            CardColor(red: 1.00, green: 0.85, blue: 0.20),
            CardColor(red: 1.00, green: 0.60, blue: 0.20)
        ]
    )

    /// Distinct looks for stand-in people so they never resemble the user's card.
    static let presets: [CardTheme] = [
        CardTheme(
            colors: [CardColor(red: 0.10, green: 0.08, blue: 0.04), CardColor(red: 0.55, green: 0.28, blue: 0.08), CardColor(red: 0.95, green: 0.62, blue: 0.24)],
            pattern: .sparkles,
            glowColors: [CardColor(red: 1.00, green: 0.55, blue: 0.15), CardColor(red: 0.95, green: 0.30, blue: 0.10), CardColor(red: 1.00, green: 0.80, blue: 0.30)]
        ),
        CardTheme(
            colors: [CardColor(red: 0.03, green: 0.12, blue: 0.13), CardColor(red: 0.06, green: 0.38, blue: 0.42), CardColor(red: 0.40, green: 0.82, blue: 0.80)],
            pattern: .dots,
            glowColors: [CardColor(red: 0.20, green: 0.90, blue: 0.85), CardColor(red: 0.20, green: 0.55, blue: 0.95), CardColor(red: 0.55, green: 0.95, blue: 0.70)]
        ),
        CardTheme(
            colors: [CardColor(red: 0.06, green: 0.07, blue: 0.16), CardColor(red: 0.20, green: 0.28, blue: 0.55), CardColor(red: 0.75, green: 0.82, blue: 0.95)],
            pattern: .sparkles,
            glowColors: [CardColor(red: 0.45, green: 0.60, blue: 1.00), CardColor(red: 0.75, green: 0.85, blue: 1.00), CardColor(red: 0.30, green: 0.45, blue: 0.90)]
        ),
        CardTheme(
            colors: [CardColor(red: 0.04, green: 0.12, blue: 0.07), CardColor(red: 0.12, green: 0.42, blue: 0.24), CardColor(red: 0.55, green: 0.88, blue: 0.55)],
            pattern: .dots,
            glowColors: [CardColor(red: 0.35, green: 0.95, blue: 0.45), CardColor(red: 0.65, green: 1.00, blue: 0.40), CardColor(red: 0.20, green: 0.80, blue: 0.60)]
        ),
        CardTheme(
            colors: [CardColor(red: 0.16, green: 0.06, blue: 0.12), CardColor(red: 0.52, green: 0.16, blue: 0.36), CardColor(red: 0.95, green: 0.55, blue: 0.72)],
            pattern: .sparkles,
            glowColors: [CardColor(red: 1.00, green: 0.35, blue: 0.65), CardColor(red: 0.85, green: 0.25, blue: 0.55), CardColor(red: 1.00, green: 0.65, blue: 0.80)]
        )
    ]
}

/// Pulls a small palette from an artwork image by averaging horizontal bands
/// top to bottom. Used for the "Match Artwork" options.
enum ArtworkColors {
    /// Extracts a palette from a card's artwork. Prefers a user-uploaded photo
    /// (`imageData`), falls back to a bundled asset (`imageName`).
    static func palette(imageData: Data?, imageName: String, count: Int) -> [CardColor] {
        let image: UIImage?
        if let imageData, let decoded = UIImage(data: imageData) {
            image = decoded
        } else if !imageName.isEmpty {
            image = UIImage(named: imageName)
        } else {
            image = nil
        }
        return palette(from: image, count: count)
    }

    static func palette(from image: UIImage?, count: Int) -> [CardColor] {
        guard count > 0,
              let cgImage = image?.cgImage
        else { return [] }

        let width = 1
        let height = count
        var pixels = [UInt8](repeating: 0, count: width * height * 4)
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let bitmapInfo = CGImageAlphaInfo.premultipliedLast.rawValue

        guard let context = CGContext(
            data: &pixels,
            width: width,
            height: height,
            bitsPerComponent: 8,
            bytesPerRow: width * 4,
            space: colorSpace,
            bitmapInfo: bitmapInfo
        ) else { return [] }

        context.interpolationQuality = .medium
        context.draw(cgImage, in: CGRect(x: 0, y: 0, width: width, height: height))

        return (0..<height).map { row in
            let offset = row * 4
            return CardColor(
                red: Double(pixels[offset]) / 255,
                green: Double(pixels[offset + 1]) / 255,
                blue: Double(pixels[offset + 2]) / 255
            )
        }
    }
}
