//
//  DonationStore.swift
//  Furcards
//
//  Created by Riley on 09/07/2026.
//

import Foundation
import Observation
import StoreKit

/// Loads and purchases the in-app "tip" products on the donation page.
/// StoreKit 2. The three consumables must be created in App Store Connect with
/// the matching product ids, and can be tried locally via the
/// `Furcards.storekit` configuration file selected in the run scheme.
@Observable
@MainActor
final class DonationStore {
    /// Product identifiers for the $1 / $5 / $10 tips.
    static let productIDs = [
        "furcards.tip.1",
        "furcards.tip.5",
        "furcards.tip.10"
    ]

    /// The result of attempting a purchase, surfaced to the view.
    enum Outcome {
        case thanks
        case cancelled
        case pending
        case failed
    }

    /// Loaded products, cheapest first. Empty until `load()` succeeds.
    private(set) var products: [Product] = []
    private(set) var isLoading = false

    /// Fetches the tip products from the App Store.
    func load() async {
        guard products.isEmpty else { return }
        isLoading = true
        defer { isLoading = false }
        do {
            let loaded = try await Product.products(for: Self.productIDs)
            products = loaded.sorted { $0.price < $1.price }
        } catch {
            products = []
        }
    }

    /// Runs the purchase flow for a tip and reports the outcome.
    func purchase(_ product: Product) async -> Outcome {
        do {
            switch try await product.purchase() {
            case .success(let verification):
                if case .verified(let transaction) = verification {
                    await transaction.finish()
                    return .thanks
                }
                return .failed
            case .userCancelled:
                return .cancelled
            case .pending:
                return .pending
            @unknown default:
                return .failed
            }
        } catch {
            return .failed
        }
    }
}
