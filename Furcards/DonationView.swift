//
//  DonationView.swift
//  Furcards
//
//  Created by Riley on 09/07/2026.
//

import SwiftUI
import StoreKit

/// Donation page: pick a $1, $5, or $10 tip.
struct DonationView: View {
    @State private var store = DonationStore()
    @State private var showingThanks = false
    @State private var purchaseFailed = false
    @State private var purchasing: Product.ID?

    var body: some View {
        Form {
            Section {
                VStack(spacing: 10) {
                    Image(systemName: "heart.fill")
                        .font(.system(size: 40))
                        .foregroundStyle(Color.accentColor)
                    Text("Support Furcards")
                        .font(.title2.weight(.bold))
                    Text("Furcards is free to use. If you're enjoying it, a small tip helps keep it going — thank you!")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 8)
            }
            .listRowBackground(Color.clear)

            Section("Leave a tip") {
                if store.isLoading {
                    HStack {
                        Spacer()
                        ProgressView()
                        Spacer()
                    }
                } else if store.products.isEmpty {
                    Text("Donation options are unavailable right now. Please try again later.")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                } else {
                    ForEach(store.products) { product in
                        Button {
                            tip(product)
                        } label: {
                            HStack {
                                Label(title(for: product), systemImage: icon(for: product))
                                Spacer()
                                if purchasing == product.id {
                                    ProgressView()
                                } else {
                                    Text(product.displayPrice)
                                        .foregroundStyle(.secondary)
                                }
                            }
                        }
                        .disabled(purchasing != nil)
                    }
                }
            }
        }
        .navigationTitle("Support Furcards")
        .navigationBarTitleDisplayMode(.inline)
        .task { await store.load() }
        .alert("Thank you! 💛", isPresented: $showingThanks) {
            Button("You're welcome") {}
        } message: {
            Text("Your support means a lot and helps keep Furcards going.")
        }
        .alert("Purchase failed", isPresented: $purchaseFailed) {
            Button("OK", role: .cancel) {}
        } message: {
            Text("Something went wrong and you weren't charged. Please try again.")
        }
    }

    private func tip(_ product: Product) {
        purchasing = product.id
        Task {
            defer { purchasing = nil }
            switch await store.purchase(product) {
            case .thanks: showingThanks = true
            case .failed: purchaseFailed = true
            case .cancelled, .pending: break
            }
        }
    }

    // label per tier, falls back to the product's own name
    private func title(for product: Product) -> String {
        switch product.id {
        case "furcards.tip.1": "Small tip"
        case "furcards.tip.5": "Generous tip"
        case "furcards.tip.10": "Big tip"
        default: product.displayName.isEmpty ? "Tip" : product.displayName
        }
    }

    private func icon(for product: Product) -> String {
        switch product.id {
        case "furcards.tip.1": "cup.and.saucer.fill"
        case "furcards.tip.5": "gift.fill"
        case "furcards.tip.10": "star.fill"
        default: "heart.fill"
        }
    }
}
