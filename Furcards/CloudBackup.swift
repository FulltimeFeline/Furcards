//
//  CloudBackup.swift
//  Furcards
//
//  Settings + collection backup to the user's iCloud Drive app container
//  (iOS counterpart of Android's Auto Backup): a JSON mirror of the persisted
//  stores, restored automatically on a fresh install with an empty collection.
//  Not live multi-device sync. The identity never rides this (Keychain is
//  device-scoped); carrying it across devices is the encrypted export/import flow.
//

import Foundation
import UIKit

@MainActor
final class CloudBackup {
    private struct Payload: Codable {
        var myCard: Furcard
        var seen: [Furcard]
        var friends: [Furcard]
        var history: [UUID: [Encounter]]
        var categories: [CardCategory]
        var nearbyTradingEnabled: Bool
        var dailyWalkedByNotification: Bool
        var notificationHour: Int
        var notificationMinute: Int
        var savedAt: Date
    }

    private let store: CardStore
    private let settings: TradingSettings
    private var containerURL: URL?

    init(store: CardStore, settings: TradingSettings) {
        self.store = store
        self.settings = settings
        // the ubiquity URL must not be first-fetched on the main thread
        Task.detached { [weak self] in
            let url = FileManager.default.url(forUbiquityContainerIdentifier: nil)?
                .appendingPathComponent("Documents", isDirectory: true)
            await MainActor.run { [weak self] in
                self?.containerURL = url
                self?.restoreIfEmpty()
            }
        }
        // mirror whenever the app heads to the background
        NotificationCenter.default.addObserver(
            forName: UIApplication.willResignActiveNotification,
            object: nil,
            queue: .main
        ) { [weak self] _ in
            Task { @MainActor [weak self] in self?.mirror() }
        }
    }

    private var backupURL: URL? {
        containerURL?.appendingPathComponent("furcards-backup-v1.json")
    }

    /// Writes the current state to iCloud. No-op with no iCloud account.
    func mirror() {
        guard let backupURL, let containerURL else { return }
        let payload = Payload(
            myCard: store.myCard,
            seen: store.seen,
            friends: store.friends,
            history: store.history,
            categories: store.categories,
            nearbyTradingEnabled: settings.nearbyTradingEnabled,
            dailyWalkedByNotification: settings.dailyWalkedByNotification,
            notificationHour: settings.notificationHour,
            notificationMinute: settings.notificationMinute,
            savedAt: Date()
        )
        guard let data = try? JSONEncoder().encode(payload) else { return }
        try? FileManager.default.createDirectory(at: containerURL, withIntermediateDirectories: true)
        try? data.write(to: backupURL, options: .atomic)
    }

    /// Fresh install with an empty collection and no card: pull the backup in.
    /// A device with any local state is left alone; this is restore, not sync.
    private func restoreIfEmpty() {
        guard store.myCard.name.isEmpty, store.seen.isEmpty, store.friends.isEmpty,
              let backupURL,
              let data = try? Data(contentsOf: backupURL),
              let payload = try? JSONDecoder().decode(Payload.self, from: data)
        else { return }
        store.myCard = payload.myCard
        store.importCollection(
            seen: payload.seen,
            friends: payload.friends,
            history: payload.history,
            categories: payload.categories
        )
        settings.nearbyTradingEnabled = payload.nearbyTradingEnabled
        settings.dailyWalkedByNotification = payload.dailyWalkedByNotification
        settings.notificationHour = payload.notificationHour
        settings.notificationMinute = payload.notificationMinute
        if !payload.myCard.name.isEmpty {
            settings.hasCompletedSetup = true
        }
    }
}
