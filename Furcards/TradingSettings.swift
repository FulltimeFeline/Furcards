//
//  TradingSettings.swift
//  Furcards
//
//  Created by Riley on 08/07/2026.
//

import Foundation
import Observation

/// User-controlled, persisted trading preferences.
@Observable
@MainActor
final class TradingSettings {
    /// Master switch for the whole nearby card-trading feature (the BLE exchange).
    var nearbyTradingEnabled: Bool { didSet { persist() } }

    /// Whether people who collected the card may relay it onward. Rides the
    /// signed payload, so changing it re-seals the card.
    var allowRelay: Bool { didSet { persist() } }

    /// Whether peers may see how many times you've crossed paths (also a
    /// signed payload flag).
    var allowEncounterCount: Bool { didSet { persist() } }

    /// Whether first-run setup has been completed.
    var hasCompletedSetup: Bool { didSet { persist() } }

    /// Debug-only: whether the demo collection (fake cards, friends, history) is on.
    var demoMode: Bool { didSet { persist() } }

    /// One-shot encounter location stamps (city when passing, exact for bumps).
    var locationStampsEnabled: Bool { didSet { persist() } }

    /// Whether the daily "walked by" summary notification is on.
    var dailyWalkedByNotification: Bool { didSet { persist() } }

    /// Hour (0–23) the daily notification is delivered.
    var notificationHour: Int { didSet { persist() } }

    /// Minute (0–59) the daily notification is delivered.
    var notificationMinute: Int { didSet { persist() } }

    init() {
        let snapshot = TradingSettings.loadSnapshot()
        self.nearbyTradingEnabled = snapshot?.nearbyTradingEnabled ?? false
        self.allowRelay = snapshot?.allowRelay ?? true
        self.allowEncounterCount = snapshot?.allowEncounterCount ?? false
        self.hasCompletedSetup = snapshot?.hasCompletedSetup ?? false
        self.demoMode = snapshot?.demoMode ?? false
        self.locationStampsEnabled = snapshot?.locationStampsEnabled ?? false
        self.dailyWalkedByNotification = snapshot?.dailyWalkedByNotification ?? false
        self.notificationHour = snapshot?.notificationHour ?? 18
        self.notificationMinute = snapshot?.notificationMinute ?? 0
    }

    // MARK: Persistence

    private struct Snapshot: Codable {
        var nearbyTradingEnabled: Bool
        var allowRelay: Bool?
        var allowEncounterCount: Bool?
        var hasCompletedSetup: Bool?
        var demoMode: Bool?
        var locationStampsEnabled: Bool?
        var dailyWalkedByNotification: Bool?
        var notificationHour: Int?
        var notificationMinute: Int?
    }

    private static let defaultsKey = "TradingSettings.v1"

    private func persist() {
        let snapshot = Snapshot(
            nearbyTradingEnabled: nearbyTradingEnabled,
            allowRelay: allowRelay,
            allowEncounterCount: allowEncounterCount,
            hasCompletedSetup: hasCompletedSetup,
            demoMode: demoMode,
            locationStampsEnabled: locationStampsEnabled,
            dailyWalkedByNotification: dailyWalkedByNotification,
            notificationHour: notificationHour,
            notificationMinute: notificationMinute
        )
        if let data = try? JSONEncoder().encode(snapshot) {
            UserDefaults.standard.set(data, forKey: Self.defaultsKey)
        }
    }

    private static func loadSnapshot() -> Snapshot? {
        guard let data = UserDefaults.standard.data(forKey: defaultsKey) else { return nil }
        return try? JSONDecoder().decode(Snapshot.self, from: data)
    }
}
