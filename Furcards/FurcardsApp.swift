//
//  FurcardsApp.swift
//  Furcards
//
//  Created by Riley on 08/07/2026.
//

import FurcardsCore
import SwiftUI

@main
struct FurcardsApp: App {
    @State private var model: AppModel

    init() {
        // FurcardsCore owns all protocol logic; the platform supplies Ed25519
        // (CryptoKit is Swift-only, unreachable from Kotlin) and the Keychain.
        // register both before anything touches the core.
        CryptoRegistry.shared.provider = CryptoKitCryptoProvider()
        SecureStorageRegistry.shared.storage = KeychainSecureStorage()

        // no accounts: the local user is a storage namespace, the card lives
        // on-device.
        let user = LocalUserStore.load()
        let store = CardStore(userID: user.userID)
        let settings = TradingSettings()
        let model = AppModel(user: user, store: store, settings: settings)

        // First run (no profile yet): run the full onboarding flow.
        let card = store.myCard
        let hasProfile = !card.name.trimmingCharacters(in: .whitespaces).isEmpty
        if !hasProfile {
            settings.hasCompletedSetup = false
            model.setNeedsWalkedBySetup(true)
        }
        _model = State(initialValue: model)
    }

    var body: some Scene {
        WindowGroup {
            Group {
                if !model.settings.hasCompletedSetup || model.needsWalkedBySetup {
                    OnboardingView()
                } else {
                    ContentView()
                }
            }
            .environment(model)
            .preferredColorScheme(.dark)
        }
    }
}
