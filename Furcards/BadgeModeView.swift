//
//  BadgeModeView.swift
//  Furcards
//
//  Nearby Trading "phone in a pocket at a con" screen. Black, dim, screen
//  kept awake so the app stays foregrounded and radios stay at full duty.
//  Taps do nothing; hold 2s to exit. Auto-exits below 20% battery.
//

import SwiftUI
import UIKit

struct BadgeModeView: View {
    @Environment(AppModel.self) private var model
    @Environment(\.dismiss) private var dismiss
    @State private var startCount = -1
    @State private var savedBrightness: CGFloat = 0.5
    @State private var position = CGPoint(x: 160, y: 300)
    /// DVD-logo drift, points/second. Not axis-aligned so it wanders the whole
    /// panel and no pixel stays lit (OLED burn-in guard).
    @State private var velocity = CGVector(dx: 38, dy: 29)
    @State private var bounceTask: Task<Void, Never>?

    /// Approximate half-extent of the label, for wall collisions.
    private let labelHalf = CGSize(width: 150, height: 14)

    var body: some View {
        let count = model.bleExchangeDiagnostics?.exchangeCount ?? 0
        let traded = max(0, count - max(0, startCount))

        GeometryReader { geo in
            ZStack {
                Color.black.ignoresSafeArea()

                Text("🐾 Don't lock your phone · \(traded) traded · Hold to exit")
                    .font(.footnote)
                    .foregroundStyle(.gray.opacity(0.5))
                    .position(position)
            }
            .contentShape(Rectangle())
            .onLongPressGesture(minimumDuration: 2.0) {
                dismiss()
            }
            .onAppear {
                startCount = model.bleExchangeDiagnostics?.exchangeCount ?? 0
                UIApplication.shared.isIdleTimerDisabled = true
                savedBrightness = UIScreen.main.brightness
                // low but not off: 0 reads as a dead screen and the label vanishes
                UIScreen.main.brightness = 0.25
                model.bleExchangeDiagnostics?.badgeMode = true
                UIDevice.current.isBatteryMonitoringEnabled = true
                position = CGPoint(x: geo.size.width / 2, y: geo.size.height / 3)
                startBouncing(in: geo.size)
            }
            .onDisappear {
                bounceTask?.cancel()
                UIApplication.shared.isIdleTimerDisabled = false
                UIScreen.main.brightness = savedBrightness
                model.bleExchangeDiagnostics?.badgeMode = false
            }
        }
        .statusBarHidden()
        .persistentSystemOverlays(.hidden)
        .onReceive(NotificationCenter.default.publisher(for: UIDevice.batteryLevelDidChangeNotification)) { _ in
            let level = UIDevice.current.batteryLevel
            if level >= 0, level < 0.2, UIDevice.current.batteryState != .charging {
                dismiss()
            }
        }
    }

    /// Straight lines wall to wall, reflecting on impact (DVD screensaver).
    /// Each segment is one linear animation, so the CPU only wakes at bounces.
    private func startBouncing(in size: CGSize) {
        bounceTask?.cancel()
        bounceTask = Task { @MainActor in
            while !Task.isCancelled {
                let minX = labelHalf.width
                let maxX = max(minX + 1, size.width - labelHalf.width)
                let minY = labelHalf.height + 60 // keep clear of notch/home areas
                let maxY = max(minY + 1, size.height - labelHalf.height - 60)

                // time until each wall along the current heading
                let tx = velocity.dx > 0
                    ? (maxX - position.x) / velocity.dx
                    : (minX - position.x) / velocity.dx
                let ty = velocity.dy > 0
                    ? (maxY - position.y) / velocity.dy
                    : (minY - position.y) / velocity.dy
                let t = max(0.05, min(tx, ty))

                let target = CGPoint(
                    x: (position.x + velocity.dx * t).clamped(to: minX...maxX),
                    y: (position.y + velocity.dy * t).clamped(to: minY...maxY)
                )
                withAnimation(.linear(duration: t)) { position = target }
                position = target
                if tx <= ty { velocity.dx.negate() }
                if ty <= tx { velocity.dy.negate() } // corner flips both

                try? await Task.sleep(nanoseconds: UInt64(t * 1_000_000_000))
                if Task.isCancelled { return }
            }
        }
    }
}

private extension CGFloat {
    func clamped(to range: ClosedRange<CGFloat>) -> CGFloat {
        Swift.min(Swift.max(self, range.lowerBound), range.upperBound)
    }
}
