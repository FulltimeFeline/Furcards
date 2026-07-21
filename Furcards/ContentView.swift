//
//  ContentView.swift
//  Furcards
//
//  Created by Riley on 08/07/2026.
//

import SwiftUI
import CoreLocation
import PhotosUI
import UIKit

struct ContentView: View {
    @Environment(AppModel.self) private var model

    var body: some View {
        if #available(iOS 18.0, *) {
            modernTabs
        } else {
            legacyTabs
        }
    }

    /// Tab-based TabView with the adaptable iPad sidebar. Needs iOS 18.
    @available(iOS 18.0, *)
    private var modernTabs: some View {
        @Bindable var store = model.store
        return TabView {
            Tab("My Card", systemImage: "person.crop.rectangle.stack") {
                NavigationStack {
                    CardScreen(card: $store.myCard)
                }
            }

            Tab("Collection", systemImage: "rectangle.stack") {
                CollectionScreen()
            }

            Tab("Settings", systemImage: "gearshape") {
                SettingsScreen()
            }
        }
        .tabViewStyle(.sidebarAdaptable)
        .onAppear { model.activate() }
    }

    /// Same three tabs on the pre-18 tabItem API for the iOS 17 floor.
    private var legacyTabs: some View {
        @Bindable var store = model.store
        return TabView {
            NavigationStack {
                CardScreen(card: $store.myCard)
            }
            .tabItem { Label("My Card", systemImage: "person.crop.rectangle.stack") }

            CollectionScreen()
                .tabItem { Label("Collection", systemImage: "rectangle.stack") }

            SettingsScreen()
                .tabItem { Label("Settings", systemImage: "gearshape") }
        }
        .onAppear { model.activate() }
    }
}

// MARK: - Bump

/// Bump from this person's card. Their identity is the target, so the friend
/// exchange only completes with them, no confirmation needed. Hold the phones
/// together while both of you have the sheet open.
private struct BumpSheet: View {
    @Environment(AppModel.self) private var model
    @Environment(\.dismiss) private var dismiss
    let card: Furcard
    @State private var message = ""
    @State private var waiting = false
    @State private var timedOut = false
    @State private var result: (friend: Furcard, message: String)?

    private var displayName: String {
        card.name
    }

    /// latest bump with this person, if any (history is newest-first)
    private var lastBumpDate: Date? {
        model.store.encounters(for: card.id).first { $0.kind == .bump }?.date
    }
    /// one bump per person per 24h
    private var onCooldown: Bool {
        guard let d = lastBumpDate else { return false }
        return Date().timeIntervalSince(d) < bumpCooldown
    }
    private var hoursLeft: Int {
        guard let d = lastBumpDate else { return 0 }
        return max(1, Int((bumpCooldown - Date().timeIntervalSince(d)) / 3600) + 1)
    }

    var body: some View {
        VStack(spacing: 14) {
            if let result {
                Text("You've bumped with \(result.friend.name)!")
                    .font(.title2.weight(.bold))
                    .frame(maxWidth: .infinity, alignment: .leading)
                if !result.message.isEmpty {
                    Text("“\(result.message)”")
                        .font(.body)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                Button {
                    dismiss()
                } label: {
                    Text("Done")
                        .font(.headline.weight(.semibold))
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)
                .controlSize(.large)
            } else if onCooldown {
                Text("Already bumped \(displayName)")
                    .font(.title2.weight(.bold))
                    .frame(maxWidth: .infinity, alignment: .leading)
                Text("You can only bump someone once every 6 hours. Try again in \(hoursLeft)h.")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .frame(maxWidth: .infinity, alignment: .leading)
                Button { dismiss() } label: {
                    Text("OK").font(.headline.weight(.semibold)).frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)
                .controlSize(.large)
            } else {
                Text("Bump \(displayName)")
                    .font(.title2.weight(.bold))
                    .frame(maxWidth: .infinity, alignment: .leading)
                if !waiting {
                    Text("Both of you tap Ready, then hold your phones together. You'll swap full cards — friends-only socials included.")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    TextField("Message for them (optional)", text: Binding(
                        get: { message },
                        set: { message = String($0.prefix(200)) }
                    ))
                    .textFieldStyle(.roundedBorder)
                    Button {
                        waiting = true
                        // legacy cards have no pubkey and bump untargeted
                        model.beginBump(message: message.trimmingCharacters(in: .whitespacesAndNewlines), targetPubkeyHex: card.pubkey)
                    } label: {
                        Label("Ready — hold phones together", systemImage: "hand.wave.fill")
                            .font(.headline.weight(.semibold))
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.borderedProminent)
                    .controlSize(.large)
                } else if timedOut {
                    Text("Couldn't complete the bump. Keep both phones unlocked and held together, make sure you both tapped Ready, then try again.")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    Button {
                        timedOut = false
                        waiting = true
                        model.beginBump(message: message.trimmingCharacters(in: .whitespacesAndNewlines), targetPubkeyHex: card.pubkey)
                    } label: {
                        Label("Try Again", systemImage: "arrow.clockwise").font(.headline.weight(.semibold)).frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.borderedProminent)
                    .controlSize(.large)
                    Button("Cancel") { dismiss() }.buttonStyle(.bordered).controlSize(.large)
                } else {
                    ProgressView()
                        .controlSize(.large)
                        .padding(.top, 12)
                    Text("Waiting for \(card.name.isEmpty ? "them" : card.name) to be ready too…")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)
                    Button("Cancel") { dismiss() }
                        .buttonStyle(.bordered)
                        .controlSize(.large)
                }
            }
        }
        .padding(24)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .presentationDetents([.medium])
        .onChange(of: model.lastBumpCompletion) { _, completion in
            guard let completion else { return }
            result = (completion.friend, completion.message)
            waiting = false
        }
        .onChange(of: waiting) { _, isWaiting in
            guard isWaiting else { return }
            Task { @MainActor in
                try? await Task.sleep(nanoseconds: 25 * 1_000_000_000)
                if waiting, result == nil {
                    timedOut = true
                    waiting = false
                    model.cancelBump()
                }
            }
        }
        .onDisappear {
            // disarm when the sheet goes away
            model.cancelBump()
        }
    }
}

// MARK: - Collection

/// Collected cards in carousels. Common cards arrive automatically, friends come from bumping.
private struct CollectionScreen: View {
    @Environment(AppModel.self) private var model

    private var isEmpty: Bool {
        model.store.seen.isEmpty && model.store.friends.isEmpty
    }

    var body: some View {
        NavigationStack {
            ZStack {
                BackgroundView()
                    .ignoresSafeArea()

                if isEmpty {
                    CardsEmptyState(
                        systemImage: emptyIcon,
                        title: emptyTitle,
                        message: emptyMessage
                    )
                } else {
                    ScrollView {
                        VStack(alignment: .leading, spacing: 28) {
                            if !model.store.seen.isEmpty {
                                CardCarousel(title: "Nearby Trading", cards: model.store.seen, statusNote: walkByStatus)
                            }
                            if !model.store.friends.isEmpty {
                                CardCarousel(title: "Bumped/Shiny Cards", cards: model.store.friends)
                            }
                            ForEach(model.store.categories) { category in
                                let cards = model.store.cards(in: category)
                                if !cards.isEmpty {
                                    CardCarousel(title: category.name, cards: cards)
                                }
                            }
                        }
                        .padding(.vertical, 16)
                    }
                }
            }
            .navigationTitle("Collection")
        }
    }

    /// status shown beside the "Nearby Trading" title when passive collection is off
    private var walkByStatus: (icon: String, text: String)? {
        if !model.settings.nearbyTradingEnabled { return ("antenna.radiowaves.left.and.right.slash", "Disabled") }
        return nil
    }

    private var emptyIcon: String {
        if !model.settings.nearbyTradingEnabled { "antenna.radiowaves.left.and.right.slash" }
        else { "rectangle.stack" }
    }

    private var emptyTitle: String {
        if !model.settings.nearbyTradingEnabled { "Nearby Trading is off" }
        else { "No cards yet" }
    }

    private var emptyMessage: String {
        if !model.settings.nearbyTradingEnabled { "Turn on Nearby Trading in Settings to start collecting cards automatically." }
        else { "Walk around town — you'll automatically collect the cards of people nearby." }
    }
}

/// Horizontal row of small cards under a titled header. Friend glow is resolved
/// per card so mixed custom categories render correctly.
private struct CardCarousel: View {
    @Environment(AppModel.self) private var model
    let title: String
    let cards: [Furcard]
    /// optional status pill shown next to the title
    var statusNote: (icon: String, text: String)? = nil

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(spacing: 8) {
                Text(title)
                    .font(.title3.weight(.heavy))
                    .foregroundStyle(.white)
                Text("\(cards.count)")
                    .font(.subheadline.weight(.bold))
                    .foregroundStyle(.white.opacity(0.5))

                if let statusNote {
                    Label(statusNote.text, systemImage: statusNote.icon)
                        .font(.caption.weight(.bold))
                        .foregroundStyle(.orange)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 3)
                        .background(.orange.opacity(0.18), in: Capsule())
                }

                Spacer()

                NavigationLink {
                    CardListScreen(title: title, cards: cards)
                } label: {
                    Text("See All")
                        .font(.subheadline.weight(.semibold))
                }
            }
            .padding(.horizontal, 20)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 2) {
                    ForEach(cards) { card in
                        let isFriend = model.store.isFriend(card)
                        NavigationLink {
                            CardDetailScreen(card: card, isFriend: isFriend)
                        } label: {
                            MiniCard(card: card, isFriend: isFriend)
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(.horizontal, 8)
            }
        }
    }
}

/// The "See All" page for a carousel: every card in a scrollable grid.
private struct CardListScreen: View {
    @Environment(AppModel.self) private var model
    let title: String
    let cards: [Furcard]

    private let columns = [GridItem(.adaptive(minimum: 160), spacing: 8)]

    var body: some View {
        ZStack {
            BackgroundView()
                .ignoresSafeArea()

            ScrollView {
                LazyVGrid(columns: columns, spacing: 8) {
                    ForEach(cards) { card in
                        let isFriend = model.store.isFriend(card)
                        NavigationLink {
                            CardDetailScreen(card: card, isFriend: isFriend)
                        } label: {
                            MiniCard(card: card, isFriend: isFriend)
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(12)
            }
        }
        .navigationTitle(title)
        .navigationBarTitleDisplayMode(.inline)
    }
}

/// Compact carousel preview: name header and framed artwork. Friends glow.
private struct MiniCard: View {
    let card: Furcard
    let isFriend: Bool

    var body: some View {
        ZStack {
            if isFriend {
                CardGlow(colors: card.theme.glowColors, blurRadius: 10, scale: 1.0)
            }

            VStack(spacing: 6) {
                Text(card.name)
                    .font(.system(.subheadline, weight: .heavy))
                    .foregroundStyle(.white)
                    .lineLimit(1)
                    .minimumScaleFactor(0.6)
                    .frame(maxWidth: .infinity)
                    .padding(.horizontal, 10)
                    .padding(.top, 10)

                ArtworkFrame(artworkName: card.artworkName, artworkData: card.artworkData, artistCredit: card.artistCredit, showsCredit: false, fixedAspect: false)
                    .padding(.horizontal, 8)
                    .padding(.bottom, 10)
            }
            .cardSurface(card.theme)
            .overlay(alignment: .bottom) {
                if isFriend {
                    FriendBadge()
                        .scaleEffect(0.8)
                        .padding(.bottom, 6)
                }
            }
        }
        .aspectRatio(CardMetrics.aspectRatio, contentMode: .fit)
        .frame(width: 150)
        // inset so the glow blur stays inside the tile, not clipped by the carousel
        .padding(12)
        .shadow(color: .black.opacity(0.28), radius: 14, x: 0, y: 8)
    }
}

/// Full card pushed from a carousel. Common cards flip, friends glow and show
/// their bump history.
private struct CardDetailScreen: View {
    @Environment(AppModel.self) private var model
    @Environment(\.dismiss) private var dismiss
    let card: Furcard
    let isFriend: Bool
    @State private var isFlipped = false
    @State private var showingNewCategory = false
    @State private var newCategoryName = ""
    @State private var confirmingBlock = false
    @State private var confirmingRemove = false
    @State private var showingBump = false

    var body: some View {
        ZStack {
            BackgroundView()
                .ignoresSafeArea()

            ScrollView {
                VStack(spacing: 24) {
                    cardView
                        .aspectRatio(CardMetrics.aspectRatio, contentMode: .fit)
                        .frame(maxWidth: 420)
                        .padding(.horizontal, 14)
                        .shadow(color: .black.opacity(0.28), radius: 30, x: 0, y: 20)

                    // the in-person action, under the card
                    Button {
                        showingBump = true
                    } label: {
                        Label(isFriend ? "Bump again" : "Bump to unlock Shiny", systemImage: "hand.wave.fill")
                            .font(.title3.weight(.semibold))
                            .frame(maxWidth: CardMetrics.maxWidth, minHeight: 44)
                    }
                    .buttonStyle(.borderedProminent)
                    .controlSize(.large)
                    .padding(.horizontal, 22)

                    EncounterHistorySection(
                        personName: card.name,
                        encounters: model.store.encounters(for: card.id)
                    )
                    .padding(.horizontal, 20)
                }
                .padding(.vertical, 24)
            }
        }
        .navigationTitle(card.name)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Menu {
                    ForEach(model.store.categories) { category in
                        Button {
                            model.store.toggleCard(card.id, in: category.id)
                        } label: {
                            if model.store.isCard(card.id, in: category.id) {
                                Label(category.name, systemImage: "checkmark")
                            } else {
                                Text(category.name)
                            }
                        }
                    }

                    if !model.store.categories.isEmpty {
                        Divider()
                    }

                    Button {
                        newCategoryName = ""
                        showingNewCategory = true
                    } label: {
                        Label("New Category…", systemImage: "plus")
                    }
                } label: {
                    Image(systemName: "folder.badge.plus")
                }
                .accessibilityLabel("Add to Category")
            }

            ToolbarItem(placement: .topBarTrailing) {
                Menu {
                    Button {
                        showingBump = true
                    } label: {
                        Label("Bump", systemImage: "hand.wave.fill")
                    }

                    Button {
                        confirmingRemove = true
                    } label: {
                        Label("Remove from Collection", systemImage: "trash")
                    }

                    Button(role: .destructive) {
                        confirmingBlock = true
                    } label: {
                        Label("Block", systemImage: "hand.raised")
                    }
                } label: {
                    Image(systemName: "ellipsis.circle")
                }
                .accessibilityLabel("More options")
            }
        }
        .sheet(isPresented: $showingBump) {
            BumpSheet(card: card)
        }
        .alert("New Category", isPresented: $showingNewCategory) {
            TextField("Name", text: $newCategoryName)
            Button("Cancel", role: .cancel) {}
            Button("Create") {
                let name = newCategoryName.trimmingCharacters(in: .whitespacesAndNewlines)
                guard !name.isEmpty else { return }
                let category = model.store.createCategory(name: name)
                model.store.toggleCard(card.id, in: category.id)
            }
        } message: {
            Text("Create a category and add this card to it.")
        }
        .alert("Remove \(card.name)?", isPresented: $confirmingRemove) {
            Button("Remove", role: .destructive) {
                model.store.remove(cardID: card.id)
                dismiss()
            }
            Button("Cancel", role: .cancel) {}
        } message: {
            Text("This takes their card out of your collection. Unlike Block, you can collect them again next time you cross paths.")
        }
        .alert("Block \(card.name)?", isPresented: $confirmingBlock) {
            Button("Block", role: .destructive) {
                model.block(card)
                dismiss()
            }
            Button("Cancel", role: .cancel) {}
        } message: {
            Text("They'll be removed from your collection and hidden on this device forever — their card will never be shown or passed along again. Cards travel phone-to-phone, so there's no central moderation; blocking is how you deal with someone's card.")
        }
    }

    @ViewBuilder
    private var cardView: some View {
        if isFriend {
            FriendCardView(card: card)
        } else {
            CardFlipView(card: card, isFlipped: isFlipped)
                .contentShape(CardMetrics.cardShape)
                .onTapGesture {
                    withAnimation(.spring(response: 0.55, dampingFraction: 0.82)) {
                        isFlipped.toggle()
                    }
                }
        }
    }
}

/// Interaction history (walk-bys and bumps) for a person, newest first.
/// Friends show street-level locations, others show city.
private struct EncounterHistorySection: View {
    let personName: String
    let encounters: [Encounter]

    var body: some View {
        if !encounters.isEmpty {
            VStack(alignment: .leading, spacing: 12) {
                HStack(spacing: 8) {
                    Text("History")
                        .font(.title3.weight(.heavy))
                        .foregroundStyle(.white)
                    Text("\(encounters.count)")
                        .font(.subheadline.weight(.bold))
                        .foregroundStyle(.white.opacity(0.5))
                    Spacer()
                }

                ForEach(encounters) { encounter in
                    EncounterRow(encounter: encounter, personName: personName)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
}

private struct EncounterRow: View {
    let encounter: Encounter
    let personName: String

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(spacing: 10) {
                Label(
                    encounter.kind == .bump ? "Bumped" : "Nearby Trading",
                    systemImage: encounter.kind == .bump ? "hand.wave.fill" : "figure.walk"
                )
                Text(encounter.date.formatted(date: .abbreviated, time: .shortened))
                Spacer(minLength: 0)
            }
            .font(.caption.weight(.semibold))
            .foregroundStyle(.white.opacity(0.75))

            if let latitude = encounter.latitude, let longitude = encounter.longitude {
                // walk-bys show the city, bumps show the street
                LocationLabel(latitude: latitude, longitude: longitude, detailed: encounter.kind == .bump)
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(.white.opacity(0.6))
            }

            if !encounter.myMessage.isEmpty {
                messageLine(sender: "You", text: encounter.myMessage)
            }
            if !encounter.theirMessage.isEmpty {
                messageLine(sender: personName, text: encounter.theirMessage)
            }
        }
        .padding(14)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(.white.opacity(0.08), in: RoundedRectangle(cornerRadius: 16, style: .continuous))
        .overlay {
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .strokeBorder(.white.opacity(0.1), lineWidth: 1)
        }
    }

    private func messageLine(sender: String, text: String) -> some View {
        VStack(alignment: .leading, spacing: 2) {
            Text(sender)
                .font(.caption2.weight(.heavy))
                .foregroundStyle(.white.opacity(0.6))
            Text(text)
                .font(.subheadline)
                .foregroundStyle(.white)
        }
    }
}

/// Reverse-geocodes a coordinate to a city, or a street when detailed.
private struct LocationLabel: View {
    let latitude: Double
    let longitude: Double
    let detailed: Bool
    @State private var text: String?

    var body: some View {
        Label(text ?? "Locating…", systemImage: "mappin.and.ellipse")
            .task {
                text = await LocationNamer.shared.describe(latitude: latitude, longitude: longitude, detailed: detailed)
            }
    }
}

/// Caches geocoding lookups so each coordinate resolves once.
private actor LocationNamer {
    static let shared = LocationNamer()
    private var cache: [String: String] = [:]

    func describe(latitude: Double, longitude: Double, detailed: Bool) async -> String {
        let key = "\(Int(latitude * 1000))_\(Int(longitude * 1000))_\(detailed)"
        if let cached = cache[key] { return cached }

        let location = CLLocation(latitude: latitude, longitude: longitude)
        let fallback = String(format: "%.3f, %.3f", latitude, longitude)
        let placemark = try? await CLGeocoder().reverseGeocodeLocation(location).first

        let result: String
        if let placemark {
            if detailed {
                let street = [placemark.subThoroughfare, placemark.thoroughfare]
                    .compactMap { $0 }
                    .joined(separator: " ")
                let parts = [street.isEmpty ? nil : street, placemark.locality].compactMap { $0 }
                result = parts.isEmpty ? fallback : parts.joined(separator: ", ")
            } else {
                result = placemark.locality ?? placemark.subAdministrativeArea ?? placemark.administrativeArea ?? fallback
            }
        } else {
            result = fallback
        }

        cache[key] = result
        return result
    }
}

private struct CardsEmptyState: View {
    let systemImage: String
    let title: String
    let message: String

    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: systemImage)
                .font(.system(size: 40, weight: .semibold))
                .foregroundStyle(.white.opacity(0.85))

            Text(title)
                .font(.title3.weight(.bold))
                .foregroundStyle(.white)

            Text(message)
                .font(.subheadline)
                .foregroundStyle(.white.opacity(0.7))
                .multilineTextAlignment(.center)
        }
        .padding(40)
    }
}

// MARK: - My Card

private struct CardScreen: View {
    @Environment(AppModel.self) private var model
    @Binding var card: Furcard
    @State private var isEditing = false
    @State private var isFlipped = false
    @State private var isBadgeMode = false
    @State private var socialSheet: SocialSheet?
    @State private var showingBackgroundInfo = false
    /// first-run explainer for background trading has been shown
    @AppStorage("hasSeenBackgroundTradeInfo") private var hasSeenBackgroundTradeInfo = false

    var body: some View {
        ZStack {
            BackgroundView()
                .ignoresSafeArea()

            VStack(spacing: 18) {
                CardFlipView(
                    card: card,
                    isFlipped: isFlipped,
                    onSelectSocial: { socialSheet = .edit($0) }
                )
                .aspectRatio(CardMetrics.aspectRatio, contentMode: .fit)
                .frame(maxWidth: 420)
                .padding(.horizontal, 14)
                .shadow(color: .black.opacity(0.28), radius: 30, x: 0, y: 20)
                .contentShape(CardMetrics.cardShape)
                .onTapGesture {
                    withAnimation(.spring(response: 0.55, dampingFraction: 0.82)) {
                        isFlipped.toggle()
                    }
                }

                Label(isFlipped ? "Tap card to flip back" : "Tap card to flip", systemImage: "hand.tap")
                    .font(.footnote.weight(.semibold))
                    .foregroundStyle(.white.opacity(0.6))

                Button {
                    isEditing = true
                } label: {
                    Label("Edit Card", systemImage: "pencil")
                        .font(.headline.weight(.semibold))
                        .frame(maxWidth: CardMetrics.maxWidth)
                }
                .buttonStyle(.borderedProminent)
                .controlSize(.large)
                .padding(.horizontal, 22)
                .padding(.top, 4)

                if model.settings.nearbyTradingEnabled {
                    Button {
                        if hasSeenBackgroundTradeInfo {
                            isBadgeMode = true
                        } else {
                            showingBackgroundInfo = true
                        }
                    } label: {
                        Label("Trade in the Background", systemImage: "dot.radiowaves.left.and.right")
                            .font(.headline.weight(.semibold))
                            .frame(maxWidth: CardMetrics.maxWidth)
                    }
                    .buttonStyle(.bordered)
                    .controlSize(.large)
                    .padding(.horizontal, 22)
                }
            }
        }
        .toolbar(.hidden, for: .navigationBar)
        .fullScreenCover(isPresented: $isBadgeMode) {
            BadgeModeView()
        }
        .alert("Trade in the Background", isPresented: $showingBackgroundInfo) {
            Button("Start") {
                hasSeenBackgroundTradeInfo = true
                isBadgeMode = true
            }
            Button("Cancel", role: .cancel) {}
        } message: {
            Text("This dims the screen so you can pocket your phone at a con and keep trading cards with people you pass.\n\nOne catch, because of an iPhone limitation: iOS pauses Bluetooth when the screen locks. So keep this screen on — don't lock your phone — and trading keeps running. Your battery lasts a lot longer than you'd think at this brightness.")
        }
        .sheet(isPresented: $isEditing) {
            CardEditor(card: $card)
        }
        .sheet(item: $socialSheet) { sheet in
            SocialEditor(socials: $card.socials, existing: sheet.link)
        }
    }
}

/// which social link the editor sheet is presenting
private enum SocialSheet: Identifiable {
    case add
    case edit(SocialLink)

    var id: String {
        switch self {
        case .add: "add"
        case .edit(let link): link.id.uuidString
        }
    }

    var link: SocialLink? {
        switch self {
        case .add: nil
        case .edit(let link): link
        }
    }
}

// MARK: - Flip container

/// Card front and back, rotating between them in 3D.
struct CardFlipView: View {
    let card: Furcard
    let isFlipped: Bool
    /// nil means the back's social rows are read-only (someone else's card)
    var onSelectSocial: ((SocialLink) -> Void)? = nil

    var body: some View {
        ZStack {
            TradingCard(card: card)
                .opacity(isFlipped ? 0 : 1)
                .accessibilityHidden(isFlipped)

            CardBack(card: card, onSelectSocial: onSelectSocial)
                .rotation3DEffect(.degrees(180), axis: (x: 0, y: 1, z: 0))
                .opacity(isFlipped ? 1 : 0)
                .accessibilityHidden(!isFlipped)
        }
        .rotation3DEffect(.degrees(isFlipped ? 180 : 0), axis: (x: 0, y: 1, z: 0))
    }
}

// MARK: - Friend version

private struct FriendCardView: View {
    let card: Furcard
    @State private var isFlipped = false

    var body: some View {
        ZStack {
            CardGlow(colors: card.theme.glowColors)

            CardFlipView(card: card, isFlipped: isFlipped)
                .overlay(alignment: .top) {
                    FriendBadge()
                        .offset(y: -12)
                }
        }
        .contentShape(CardMetrics.cardShape)
        .onTapGesture {
            withAnimation(.spring(response: 0.55, dampingFraction: 0.82)) {
                isFlipped.toggle()
            }
        }
    }
}

/// Animated halo behind a friend card, cycling the glow colors.
private struct CardGlow: View {
    let colors: [CardColor]
    var blurRadius: CGFloat = 38
    var scale: CGFloat = 1.04

    /// close the loop (first == last) so the ring has no seam
    private var stops: [Color] {
        let resolved = colors.map(\.color)
        guard let first = resolved.first else { return [.white] }
        return resolved + [first]
    }

    var body: some View {
        TimelineView(.animation) { timeline in
            let seconds = timeline.date.timeIntervalSinceReferenceDate
            let angle = Angle.degrees(seconds.truncatingRemainder(dividingBy: 6) / 6 * 360)

            CardMetrics.cardShape
                .fill(AngularGradient(colors: stops, center: .center, angle: angle))
                .blur(radius: blurRadius)
                .scaleEffect(scale)
        }
        .opacity(0.9)
    }
}

private struct FriendBadge: View {
    var body: some View {
        Label("Shiny", systemImage: "sparkles")
            .font(.caption.weight(.heavy))
            .foregroundStyle(.white)
            .padding(.horizontal, 12)
            .padding(.vertical, 6)
            .background(Color.accentColor, in: Capsule())
            .overlay {
                Capsule()
                    .strokeBorder(.white.opacity(0.6), lineWidth: 1)
            }
            .shadow(color: .black.opacity(0.3), radius: 6, x: 0, y: 3)
    }
}

// MARK: - Trading card (front)

private struct TradingCard: View {
    let card: Furcard

    var body: some View {
        switch card.effectiveTemplate {
        case .classic: ClassicCardLayout(card: card)
        case .fullBleed: FullBleedCardLayout(card: card)
        case .portrait: PortraitCardLayout(card: card)
        }
    }
}

/// Original layout: header, framed photo, tags, bio, message.
private struct ClassicCardLayout: View {
    let card: Furcard

    var body: some View {
        VStack(spacing: 8) {
            CardHeader(card: card)
                .frame(height: 68)
                .padding(.horizontal, 14)
                .padding(.top, 12)

            ArtworkFrame(artworkName: card.artworkName, artworkData: card.artworkData, artistCredit: card.artistCredit)
                .padding(.horizontal, 12)

            DetailBubbles(tags: card.tags)
                .padding(.horizontal, 12)

            CardDescription(text: card.bio)
                .padding(.horizontal, 12)

            if !card.message.isEmpty {
                CardMessageStrip(text: card.message)
                    .padding(.horizontal, 12)
            }

            Spacer(minLength: 0)
        }
        .padding(.bottom, 12)
        .cardSurface(card.theme)
    }
}

/// Photo fills the card. Name, pronouns, tags, and message sit over a dark
/// gradient at the bottom.
private struct FullBleedCardLayout: View {
    let card: Furcard

    var body: some View {
        ZStack(alignment: .bottom) {
            CardArtworkImage(card: card)

            LinearGradient(
                colors: [.clear, .black.opacity(0.15), .black.opacity(0.82)],
                startPoint: .center,
                endPoint: .bottom
            )

            VStack(alignment: .leading, spacing: 8) {
                HStack(alignment: .top, spacing: 12) {
                    VStack(alignment: .leading, spacing: 2) {
                        Text(card.name)
                            .font(.system(.title, weight: .heavy))
                            .lineLimit(1)
                            .minimumScaleFactor(0.6)
                    }
                    .cardFieldBackdrop()
                    Spacer(minLength: 8)
                    PronounBadge(pronouns: card.pronouns, flags: card.identityFlags, overPhoto: true)
                }

                if !card.tags.isEmpty {
                    DetailBubbles(tags: card.tags)
                }
                if !card.bio.isEmpty {
                    CardDescription(text: card.bio)
                }
                if !card.message.isEmpty {
                    CardMessageStrip(text: card.message)
                }
            }
            .foregroundStyle(.white)
            .padding(16)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .cardSurface(card.theme)
    }
}

/// Poster look: large photo up top, info stacked beneath.
private struct PortraitCardLayout: View {
    let card: Furcard

    var body: some View {
        GeometryReader { proxy in
            VStack(spacing: 0) {
                CardArtworkImage(card: card)
                    .frame(height: proxy.size.height * 0.56)
                    .clipped()

                VStack(alignment: .leading, spacing: 10) {
                    VStack(alignment: .leading, spacing: 2) {
                        HStack(alignment: .top, spacing: 12) {
                            Text(card.name)
                                .font(.system(.title2, weight: .heavy))
                                .lineLimit(1)
                                .minimumScaleFactor(0.7)
                            Spacer(minLength: 8)
                            PronounBadge(pronouns: card.pronouns, flags: card.identityFlags)
                        }
                    }

                    if !card.tags.isEmpty { DetailBubbles(tags: card.tags) }
                    if !card.bio.isEmpty { CardDescription(text: card.bio) }
                    if !card.message.isEmpty { CardMessageStrip(text: card.message) }

                    Spacer(minLength: 0)
                }
                .foregroundStyle(.white)
                .padding(14)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
            }
        }
        .cardSurface(card.theme)
    }
}

/// Artwork scaled to fill its container, used by the photo-forward templates.
/// Shows a placeholder when there's no image.
private struct CardArtworkImage: View {
    let card: Furcard

    private var artwork: UIImage? {
        if let artworkData = card.artworkData { return UIImage(data: artworkData) }
        return card.artworkName.isEmpty ? nil : UIImage(named: card.artworkName)
    }

    var body: some View {
        GeometryReader { proxy in
            Group {
                if let artwork {
                    Image(uiImage: artwork)
                        .resizable()
                        .scaledToFill()
                } else {
                    ZStack {
                        Color.white.opacity(0.06)
                        Image(systemName: "photo")
                            .font(.system(size: 40, weight: .regular))
                            .foregroundStyle(.white.opacity(0.35))
                    }
                }
            }
            .frame(width: proxy.size.width, height: proxy.size.height)
            .clipped()
            .overlay(alignment: .topLeading) {
                if !card.artistCredit.isEmpty {
                    Text("Art by \(card.artistCredit)")
                        .font(.caption.weight(.heavy))
                        .foregroundStyle(.white)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 6)
                        .background(.black.opacity(0.34), in: Capsule())
                        .padding(10)
                }
            }
        }
    }
}

/// message section at the bottom of a card
private struct CardMessageStrip: View {
    let text: String

    var body: some View {
        HStack(alignment: .top, spacing: 8) {
            Image(systemName: "quote.bubble.fill")
                .font(.caption2)
                .foregroundStyle(.white.opacity(0.7))
                .padding(.top, 1)

            Text(text)
                .font(.caption.weight(.bold))
                .foregroundStyle(.white)
                .lineLimit(2)
                .minimumScaleFactor(0.8)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 9)
        .background(.white.opacity(0.14), in: RoundedRectangle(cornerRadius: 16, style: .continuous))
        .hairlineBorder(RoundedRectangle(cornerRadius: 16, style: .continuous))
    }
}

// MARK: - Card back

private struct CardBack: View {
    let card: Furcard
    /// nil means rows are read-only, otherwise tapping edits the link
    var onSelectSocial: ((SocialLink) -> Void)? = nil

    var body: some View {
        VStack(spacing: 14) {
            VStack(spacing: 4) {
                Text(card.name)
                    .font(.system(.title3, weight: .heavy))
                    .lineLimit(1)
                    .minimumScaleFactor(0.72)

                Text("Find me online")
                    .font(.caption.weight(.bold))
                    .foregroundStyle(.white.opacity(0.68))
            }
            .foregroundStyle(.white)
            .padding(.top, 20)

            HStack(spacing: 10) {
                cardStat(icon: "figure.walk", value: card.walkedByCount ?? 0, label: "Nearby Trading")
                cardStat(icon: "hand.wave.fill", value: card.bumpCount ?? 0, label: "Shiny")
            }

            VStack(spacing: 10) {
                ForEach(card.socials) { social in
                    // friends-only link with a blank handle is a locked stub
                    // (redacted on the common card): show it, never tap it
                    if social.visibility == .friends, social.handle.isEmpty {
                        SocialRow(social: social)
                    } else if let onSelectSocial {
                        Button {
                            onSelectSocial(social)
                        } label: {
                            SocialRow(social: social)
                        }
                        .buttonStyle(.plain)
                    } else if let url = social.platform.profileURL(for: social.handle) {
                        Link(destination: url) {
                            SocialRow(social: social)
                        }
                        .buttonStyle(.plain)
                    } else {
                        SocialRow(social: social)
                    }
                }
            }

            Spacer(minLength: 0)
        }
        .padding(.horizontal, 16)
        .padding(.bottom, 16)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .cardSurface(card.theme)
    }

    private func cardStat(icon: String, value: Int, label: String) -> some View {
        VStack(spacing: 2) {
            Label("\(value)", systemImage: icon)
                .font(.subheadline.weight(.heavy))
            Text(label)
                .font(.caption2.weight(.bold))
                .foregroundStyle(.white.opacity(0.7))
        }
        .foregroundStyle(.white)
        .frame(maxWidth: .infinity)
        .padding(.vertical, 10)
        .background(.white.opacity(0.12), in: RoundedRectangle(cornerRadius: 14, style: .continuous))
        .hairlineBorder(RoundedRectangle(cornerRadius: 14, style: .continuous))
    }
}

private struct SocialRow: View {
    let social: SocialLink

    private var isLocked: Bool { social.visibility == .friends && social.handle.isEmpty }

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: social.platform.systemImage)
                .font(.system(.headline, weight: .semibold))
                .frame(width: 34, height: 34)
                .background(.white.opacity(0.16), in: Circle())

            VStack(alignment: .leading, spacing: 1) {
                Text(social.platform.label)
                    .font(.subheadline.weight(.heavy))
                Text(isLocked ? "Bump to unlock" : social.handle)
                    .font(.caption)
                    .foregroundStyle(.white.opacity(isLocked ? 0.5 : 0.7))
                    .lineLimit(1)
                    .minimumScaleFactor(0.7)
            }

            Spacer(minLength: 8)

            if social.visibility == .friends {
                Image(systemName: "lock.fill")
                    .font(.caption2.weight(.bold))
                    .foregroundStyle(.white.opacity(0.6))
                    .accessibilityLabel(isLocked ? "Locked — bump to unlock" : "Friends only")
            }

            if !isLocked {
                Image(systemName: "chevron.right")
                    .font(.caption.weight(.bold))
                    .foregroundStyle(.white.opacity(0.5))
            }
        }
        .foregroundStyle(.white)
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
        .background(.black.opacity(0.24), in: RoundedRectangle(cornerRadius: 14, style: .continuous))
        .hairlineBorder(RoundedRectangle(cornerRadius: 14, style: .continuous))
    }
}

private struct CardBody: View {
    let theme: CardTheme

    var body: some View {
        ZStack {
            LinearGradient(
                colors: theme.colors.map(\.color),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )

            RadialGradient(
                colors: [CardPalette.highlightWarm.opacity(0.48), .clear],
                center: .topTrailing,
                startRadius: 30,
                endRadius: 260
            )

            RadialGradient(
                colors: [CardPalette.highlightCool.opacity(0.36), .clear],
                center: .bottomLeading,
                startRadius: 30,
                endRadius: 260
            )
        }
    }
}

private struct CardHeader: View {
    let card: Furcard

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            VStack(alignment: .leading, spacing: 4) {
                Text(card.name)
                    .font(.system(.title2, weight: .heavy))
                    .foregroundStyle(.white)
                    .lineLimit(1)
                    .minimumScaleFactor(0.72)

            }
            .padding(.top, 2)

            Spacer(minLength: 8)

            PronounBadge(pronouns: card.pronouns, flags: card.identityFlags)
        }
    }
}

/// Aspect ratio (width/height) of the artwork region so the cropper can match it.
private struct ArtworkAspectKey: PreferenceKey {
    static let defaultValue: CGFloat = 0
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        let next = nextValue()
        if next > 0 { value = next }
    }
}

private struct ArtworkFrame: View {
    let artworkName: String
    var artworkData: Data? = nil
    let artistCredit: String
    var showsCredit: Bool = true
    /// true keeps a fixed aspect so the artwork size is constant, false fills
    var fixedAspect: Bool = true

    private var artwork: UIImage? {
        if let artworkData { return UIImage(data: artworkData) }
        return artworkName.isEmpty ? nil : UIImage(named: artworkName)
    }

    var body: some View {
        sizedStack
            .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
            .hairlineBorder(RoundedRectangle(cornerRadius: 18, style: .continuous), opacity: 0.56, width: 1.4)
            .padding(4)
            .background(.white.opacity(0.18), in: RoundedRectangle(cornerRadius: 22, style: .continuous))
    }

    @ViewBuilder
    private var sizedStack: some View {
        if fixedAspect {
            imageStack.aspectRatio(CardMetrics.artworkAspect, contentMode: .fit)
        } else {
            imageStack.frame(maxHeight: .infinity)
        }
    }

    private var imageStack: some View {
        ZStack(alignment: .bottomLeading) {
            GeometryReader { proxy in
                Group {
                    if let artwork {
                        Image(uiImage: artwork)
                            .resizable()
                            .scaledToFill()
                            .frame(width: proxy.size.width, height: proxy.size.height)
                            .clipped()
                    } else {
                        ZStack {
                            Color.white.opacity(0.06)
                            Image(systemName: "photo")
                                .font(.system(size: 28, weight: .regular))
                                .foregroundStyle(.white.opacity(0.35))
                        }
                        .frame(width: proxy.size.width, height: proxy.size.height)
                    }
                }
                .preference(
                    key: ArtworkAspectKey.self,
                    value: proxy.size.height > 0 ? proxy.size.width / proxy.size.height : 0
                )
            }

            LinearGradient(
                colors: [.clear, .black.opacity(0.24)],
                startPoint: .center,
                endPoint: .bottom
            )

            if showsCredit && !artistCredit.isEmpty {
                Text("Art by \(artistCredit)")
                    .font(.caption.weight(.heavy))
                    .foregroundStyle(.white)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 6)
                    .background(.black.opacity(0.34), in: Capsule())
                    .padding(10)
            }
        }
    }
}

private struct PronounBadge: View {
    let pronouns: String
    let flags: String
    /// over the photo (Full Photo layout), use a dark backdrop for legibility
    var overPhoto: Bool = false

    var body: some View {
        VStack(spacing: 2) {
            Text(pronouns)
                .font(.system(.headline, weight: .heavy))
                .lineLimit(1)
                .minimumScaleFactor(0.82)

            Text(flags)
                .font(.caption.weight(.bold))
                .lineLimit(1)
        }
        .foregroundStyle(.white)
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
        .background(
            (overPhoto ? Color.black.opacity(0.24) : Color.white.opacity(0.14)),
            in: RoundedRectangle(cornerRadius: 15, style: .continuous)
        )
        .hairlineBorder(RoundedRectangle(cornerRadius: 15, style: .continuous), opacity: overPhoto ? 0.12 : 0.14)
    }
}

private struct DetailBubbles: View {
    let tags: [String]

    var body: some View {
        HStack(spacing: 8) {
            Spacer(minLength: 0)
            ForEach(tags, id: \.self) { tag in
                DetailBubble(tag)
            }
            Spacer(minLength: 0)
        }
    }
}

private struct DetailBubble: View {
    let text: String

    init(_ text: String) {
        self.text = text
    }

    var body: some View {
        Text(text)
            .font(.caption.weight(.heavy))
            .foregroundStyle(.white)
            .lineLimit(1)
            .minimumScaleFactor(0.72)
            .padding(.horizontal, 10)
            .padding(.vertical, 6)
            .background(.black.opacity(0.24), in: Capsule())
            .hairlineBorder(Capsule())
    }
}

private struct CardDescription: View {
    let text: String

    var body: some View {
        Text(text)
            .font(.caption.weight(.heavy))
            .foregroundStyle(.white)
            .lineLimit(3)
            .minimumScaleFactor(0.82)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, 12)
            .padding(.vertical, 10)
            .background(.black.opacity(0.24), in: RoundedRectangle(cornerRadius: 16, style: .continuous))
            .hairlineBorder(RoundedRectangle(cornerRadius: 16, style: .continuous))
            .padding(.top, 2)
    }
}

private struct CardFoil: View {
    var pattern: CardPattern

    var body: some View {
        ZStack {
            if pattern != .none {
                LinearGradient(
                    colors: CardPalette.foilSheen,
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )

                Canvas { context, size in
                    switch pattern {
                    case .none:
                        break
                    case .sparkles:
                        drawSparkleField(context, size: size)
                        drawHeroStars(context, size: size)
                    case .dots:
                        drawDots(context, size: size)
                    }
                }
            }
        }
        .blendMode(.screen)
        .allowsHitTesting(false)
    }

    private func drawSparkleField(_ context: GraphicsContext, size: CGSize) {
        for row in 0..<9 {
            for column in 0..<7 {
                let offset = row.isMultiple(of: 2) ? 0.0 : 0.065
                let x = (CGFloat(column) + 0.45) / 7.0 + offset
                let y = (CGFloat(row) + 0.38) / 9.0
                let radius = CGFloat(1.3 + Double((row * 3 + column * 5) % 5) * 0.7)
                let opacity = 0.065 + Double((row + column) % 4) * 0.025

                if x < 0.98 {
                    let center = CGPoint(x: size.width * x, y: size.height * y)
                    context.fill(sparklePath(center: center, radius: radius), with: .color(.white.opacity(opacity)))
                }
            }
        }
    }

    private func drawHeroStars(_ context: GraphicsContext, size: CGSize) {
        for star in heroStars {
            let center = CGPoint(x: size.width * star.x, y: size.height * star.y)
            context.fill(sparklePath(center: center, radius: star.radius), with: .color(.white.opacity(star.opacity)))
        }
    }

    private func drawDots(_ context: GraphicsContext, size: CGSize) {
        let columns = 9
        let rows = 14
        for row in 0..<rows {
            for column in 0..<columns {
                let offset = row.isMultiple(of: 2) ? 0.0 : 0.5
                let x = (CGFloat(column) + 0.5 + offset) / CGFloat(columns)
                let y = (CGFloat(row) + 0.5) / CGFloat(rows)
                guard x < 0.99 else { continue }

                // vary size and brightness per dot for a scattered look
                let seed = row * 7 + column * 3
                let radius = CGFloat(1.3 + Double(seed % 4) * 0.95)
                let opacity = 0.06 + Double((row + column) % 3) * 0.035

                let rect = CGRect(x: size.width * x - radius, y: size.height * y - radius, width: radius * 2, height: radius * 2)
                context.fill(Path(ellipseIn: rect), with: .color(.white.opacity(opacity)))
            }
        }
    }

    /// larger, brighter sparkles as focal points
    private let heroStars: [(x: CGFloat, y: CGFloat, radius: CGFloat, opacity: Double)] = [
        (0.12, 0.16, 4.4, 0.2),
        (0.42, 0.2, 3.8, 0.17),
        (0.74, 0.12, 5.2, 0.19),
        (0.2, 0.58, 4.8, 0.18),
        (0.62, 0.46, 4.2, 0.16),
        (0.84, 0.72, 5.6, 0.17),
        (0.35, 0.88, 4.0, 0.16)
    ]

    /// four-pointed sparkle centred on `center`
    private func sparklePath(center: CGPoint, radius: CGFloat) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: center.x, y: center.y - radius * 2.2))
        path.addQuadCurve(to: CGPoint(x: center.x + radius * 0.48, y: center.y - radius * 0.48), control: CGPoint(x: center.x + radius * 0.2, y: center.y - radius * 0.95))
        path.addQuadCurve(to: CGPoint(x: center.x + radius * 2.2, y: center.y), control: CGPoint(x: center.x + radius * 0.95, y: center.y - radius * 0.2))
        path.addQuadCurve(to: CGPoint(x: center.x + radius * 0.48, y: center.y + radius * 0.48), control: CGPoint(x: center.x + radius * 0.95, y: center.y + radius * 0.2))
        path.addQuadCurve(to: CGPoint(x: center.x, y: center.y + radius * 2.2), control: CGPoint(x: center.x + radius * 0.2, y: center.y + radius * 0.95))
        path.addQuadCurve(to: CGPoint(x: center.x - radius * 0.48, y: center.y + radius * 0.48), control: CGPoint(x: center.x - radius * 0.2, y: center.y + radius * 0.95))
        path.addQuadCurve(to: CGPoint(x: center.x - radius * 2.2, y: center.y), control: CGPoint(x: center.x - radius * 0.95, y: center.y + radius * 0.2))
        path.addQuadCurve(to: CGPoint(x: center.x - radius * 0.48, y: center.y - radius * 0.48), control: CGPoint(x: center.x - radius * 0.95, y: center.y - radius * 0.2))
        path.addQuadCurve(to: CGPoint(x: center.x, y: center.y - radius * 2.2), control: CGPoint(x: center.x - radius * 0.2, y: center.y - radius * 0.95))
        return path
    }
}

private struct BackgroundView: View {
    var body: some View {
        Color.black
    }
}

// MARK: - Card editor

struct CardEditor: View {
    @Environment(AppModel.self) private var model
    @Binding var card: Furcard
    @Environment(\.dismiss) private var dismiss

    /// working copy so edits can be cancelled without touching the live card
    @State private var draft: Furcard
    @State private var socialSheet: SocialSheet?
    @State private var photoItem: PhotosPickerItem?
    @State private var cropping: CroppableImage?
    /// set when the layout changes with a photo set, prompting a re-crop
    @State private var offerRecrop = false
    @State private var isFlipped = false

    init(card: Binding<Furcard>) {
        self._card = card
        self._draft = State(initialValue: card.wrappedValue)
    }

    var body: some View {
        NavigationStack {
            Form {
                Section {
                    CardFlipView(card: draft, isFlipped: isFlipped)
                        .aspectRatio(CardMetrics.aspectRatio, contentMode: .fit)
                        .frame(maxWidth: CardMetrics.maxWidth)
                        .frame(maxWidth: .infinity)
                        .padding(.horizontal, 22)
                        .padding(.vertical, 28)
                        .shadow(color: .black.opacity(0.3), radius: 24, x: 0, y: 14)
                        .contentShape(CardMetrics.cardShape)
                        .onTapGesture {
                            withAnimation(.spring(response: 0.55, dampingFraction: 0.82)) {
                                isFlipped.toggle()
                            }
                        }
                }
                .listRowInsets(EdgeInsets())
                .listRowBackground(Color(red: 0.06, green: 0.03, blue: 0.08))

                Section("Layout") {
                    Picker("Layout", selection: Binding(
                        get: { draft.effectiveTemplate },
                        set: { newValue in
                            let previous = draft.effectiveTemplate
                            draft.template = newValue
                            // new layout frames the photo differently, offer a re-crop
                            if newValue != previous && draft.artworkData != nil {
                                offerRecrop = true
                            }
                        }
                    )) {
                        ForEach(CardTemplate.allCases) { template in
                            Label(template.label, systemImage: template.icon).tag(template)
                        }
                    }
                    .pickerStyle(.inline)
                    .labelsHidden()
                }

                Section("Identity") {
                    TextField("Name", text: $draft.name)
                    TextField("Pronouns", text: $draft.pronouns)
                    TextField("Identity flags", text: $draft.identityFlags)
                }

                Section("Artwork") {
                    PhotosPicker(selection: $photoItem, matching: .images) {
                        Label(draft.artworkData == nil ? "Choose Photo" : "Change Photo", systemImage: "photo")
                    }
                    if draft.artworkData != nil {
                        Button("Remove Photo", role: .destructive) {
                            draft.artworkData = nil
                        }
                    }
                    TextField("Artist credit", text: $draft.artistCredit)
                }

                Section {
                    TextField("Tags", text: tagsText, axis: .vertical)
                } header: {
                    Text("Tags")
                } footer: {
                    Text("Separate tags with commas.")
                }

                Section("Bio") {
                    TextField("Bio", text: $draft.bio, axis: .vertical)
                        .lineLimit(3...6)
                }

                Section {
                    TextField("Card message", text: $draft.message, axis: .vertical)
                        .lineLimit(2...4)
                } header: {
                    Text("Message")
                } footer: {
                    Text("Shown at the bottom of your card to everyone who walks by you.")
                }

                Section("Socials") {
                    ForEach(draft.socials) { social in
                        Button {
                            socialSheet = .edit(social)
                        } label: {
                            HStack(spacing: 12) {
                                Image(systemName: social.platform.systemImage)
                                    .frame(width: 24)
                                VStack(alignment: .leading, spacing: 2) {
                                    Text(social.platform.label)
                                    Text(social.handle)
                                        .font(.caption)
                                        .foregroundStyle(.secondary)
                                        .lineLimit(1)
                                }
                            }
                        }
                        .tint(.primary)
                    }
                    .onDelete { draft.socials.remove(atOffsets: $0) }

                    Button {
                        socialSheet = .add
                    } label: {
                        Label("Add Social", systemImage: "plus")
                    }
                }

                Section {
                    ForEach($draft.theme.colors) { $entry in
                        ColorPicker("Color", selection: colorBinding($entry), supportsOpacity: false)
                    }
                    .onDelete { offsets in
                        if draft.theme.colors.count > 2 { draft.theme.colors.remove(atOffsets: offsets) }
                    }
                    Button {
                        draft.theme.colors.append(CardColor(.white))
                    } label: {
                        Label("Add Color", systemImage: "plus")
                    }
                    Button {
                        matchArtwork(into: \.colors, count: 4)
                    } label: {
                        Label("Match Artwork", systemImage: "photo")
                    }
                    .disabled(!hasArtwork)
                } header: {
                    Text("Background Gradient")
                }

                Section("Pattern") {
                    Picker("Pattern", selection: $draft.theme.pattern) {
                        ForEach(CardPattern.allCases) { pattern in
                            Text(pattern.label).tag(pattern)
                        }
                    }
                    .pickerStyle(.menu)
                }

                Section {
                    ForEach($draft.theme.glowColors) { $entry in
                        ColorPicker("Color", selection: colorBinding($entry), supportsOpacity: false)
                    }
                    .onDelete { offsets in
                        if draft.theme.glowColors.count > 2 { draft.theme.glowColors.remove(atOffsets: offsets) }
                    }
                    Button {
                        draft.theme.glowColors.append(CardColor(.white))
                    } label: {
                        Label("Add Color", systemImage: "plus")
                    }
                    Button {
                        matchArtwork(into: \.glowColors, count: 5)
                    } label: {
                        Label("Match Artwork", systemImage: "photo")
                    }
                    .disabled(!hasArtwork)
                } header: {
                    Text("Shiny Glow")
                } footer: {
                    Text("The animated halo shown around your Shiny card once someone unlocks it.")
                }
            }
            .navigationTitle("Edit Card")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") { save() }
                }
            }
            .sheet(item: $socialSheet) { sheet in
                SocialEditor(socials: $draft.socials, existing: sheet.link)
            }
            .sheet(item: $cropping) { item in
                ImageCropper(image: item.image, aspect: artworkAspect) { data in
                    draft.artworkData = data
                    // keep a size-capped original so re-cropping survives device switches
                    draft.originalArtworkData = downscaledJPEG(item.image) ?? item.originalData
                }
            }
            .confirmationDialog("Adjust your photo?", isPresented: $offerRecrop, titleVisibility: .visible) {
                Button("Adjust Photo") {
                    // re-crop from the original, falling back to the cropped
                    // artwork for photos saved before we kept the original
                    if let data = draft.originalArtworkData ?? draft.artworkData,
                       let image = UIImage(data: data) {
                        cropping = CroppableImage(image: image, originalData: data)
                    }
                }
                Button("Keep As Is", role: .cancel) {}
            } message: {
                Text("This layout frames your photo differently. Re-crop it to fit the new shape.")
            }
            .onChange(of: photoItem) { _, newItem in
                guard let newItem else { return }
                Task {
                    if let data = try? await newItem.loadTransferable(type: Data.self),
                       let image = UIImage(data: data) {
                        cropping = CroppableImage(image: image, originalData: data)
                    }
                    photoItem = nil
                }
            }
        }
    }

    /// saves the card locally, everything is on-device so this can't fail
    private func save() {
        model.saveCard(draft)
        card = draft
        dismiss()
    }

    /// bridges the `[String]` tags to a comma-separated field
    private var tagsText: Binding<String> {
        Binding(
            get: { draft.tags.joined(separator: ", ") },
            set: { newValue in
                draft.tags = newValue
                    .split(separator: ",")
                    .map { $0.trimmingCharacters(in: .whitespaces) }
                    .filter { !$0.isEmpty }
            }
        )
    }

    /// bridges a `CardColor` binding to the `Color` a `ColorPicker` expects,
    /// keeping the entry's identity across edits
    private func colorBinding(_ entry: Binding<CardColor>) -> Binding<Color> {
        Binding(
            get: { entry.wrappedValue.color },
            set: { entry.wrappedValue.update(from: $0) }
        )
    }

    /// whether the draft has artwork to sample colors from
    private var hasArtwork: Bool {
        draft.artworkData != nil || !draft.artworkName.isEmpty
    }

    /// Re-encodes an image capped to a maximum dimension as JPEG. The original
    /// is kept for re-cropping, but full-res camera photos are too large to
    /// persist, so we shrink them while keeping enough detail to re-frame.
    private func downscaledJPEG(_ image: UIImage, maxDimension: CGFloat = 2048, quality: CGFloat = 0.85) -> Data? {
        let longest = max(image.size.width, image.size.height)
        let factor = longest > maxDimension ? maxDimension / longest : 1
        let target = CGSize(width: image.size.width * factor, height: image.size.height * factor)
        let format = UIGraphicsImageRendererFormat.default()
        format.scale = 1
        let resized = UIGraphicsImageRenderer(size: target, format: format).image { _ in
            image.draw(in: CGRect(origin: .zero, size: target))
        }
        return resized.jpegData(compressionQuality: quality)
    }

    /// crop aspect for the current layout, matching how each template frames the artwork
    private var artworkAspect: CGFloat {
        switch draft.effectiveTemplate {
        case .classic: CardMetrics.artworkAspect          // fixed framed photo
        case .fullBleed: CardMetrics.aspectRatio          // fills the card
        case .portrait: CardMetrics.aspectRatio / 0.56    // top 56% of the card
        }
    }

    private func matchArtwork(into keyPath: WritableKeyPath<CardTheme, [CardColor]>, count: Int) {
        let palette = ArtworkColors.palette(imageData: draft.artworkData, imageName: draft.artworkName, count: count)
        if !palette.isEmpty {
            draft.theme[keyPath: keyPath] = palette
        }
    }
}

// MARK: - Image cropper

/// A picked image awaiting cropping. Carries the original data so it can be
/// re-cropped later.
private struct CroppableImage: Identifiable {
    let id = UUID()
    let image: UIImage
    let originalData: Data
}

/// Lets the user pan/zoom a photo within a card-shaped frame, then exports the
/// cropped result as image data sized to the card.
private struct ImageCropper: View {
    let image: UIImage
    /// crop frame aspect (width / height), matches the card's artwork slot
    var aspect: CGFloat
    let onCrop: (Data) -> Void
    @Environment(\.dismiss) private var dismiss

    @State private var scale: CGFloat = 1
    @GestureState private var gestureScale: CGFloat = 1
    @State private var offset: CGSize = .zero
    @GestureState private var gestureOffset: CGSize = .zero

    private let cropWidth: CGFloat = 320
    private var cropHeight: CGFloat { cropWidth / max(aspect, 0.1) }

    var body: some View {
        NavigationStack {
            ZStack {
                Color.black.ignoresSafeArea()

                cropContent
                    .overlay {
                        RoundedRectangle(cornerRadius: 18, style: .continuous)
                            .strokeBorder(.white.opacity(0.85), lineWidth: 2)
                    }
                    .gesture(
                        DragGesture()
                            .updating($gestureOffset) { value, state, _ in state = value.translation }
                            .onEnded { value in
                                offset.width += value.translation.width
                                offset.height += value.translation.height
                            }
                            .simultaneously(with:
                                MagnificationGesture()
                                    .updating($gestureScale) { value, state, _ in state = value }
                                    .onEnded { value in scale = max(1, scale * value) }
                            )
                    )

                VStack {
                    Spacer()
                    Text("Drag and pinch to frame your photo")
                        .font(.footnote.weight(.semibold))
                        .foregroundStyle(.white.opacity(0.7))
                        .padding(.bottom, 24)
                }
            }
            .navigationTitle("Crop Photo")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Use") { exportCrop() }
                }
            }
        }
    }

    /// image framed and clipped to the card crop, shown live and rendered on export
    private var cropContent: some View {
        Image(uiImage: image)
            .resizable()
            .scaledToFill()
            .frame(width: cropWidth, height: cropHeight)
            .scaleEffect(scale * gestureScale)
            .offset(x: offset.width + gestureOffset.width, y: offset.height + gestureOffset.height)
            .frame(width: cropWidth, height: cropHeight)
            .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
    }

    @MainActor
    private func exportCrop() {
        let renderer = ImageRenderer(content: cropContent)
        renderer.scale = 3
        if let rendered = renderer.uiImage, let data = rendered.jpegData(compressionQuality: 0.85) {
            onCrop(data)
        }
        dismiss()
    }
}

// MARK: - Social editor

/// Adds a new social link or edits an existing one on the card's back.
private struct SocialEditor: View {
    @Binding var socials: [SocialLink]
    /// the link being edited, or nil when adding a new one
    let existing: SocialLink?
    @Environment(\.dismiss) private var dismiss

    @State private var platform: SocialPlatform
    @State private var handle: String
    @State private var visibility: SocialVisibility

    init(socials: Binding<[SocialLink]>, existing: SocialLink?) {
        self._socials = socials
        self.existing = existing
        self._platform = State(initialValue: existing?.platform ?? .bluesky)
        self._handle = State(initialValue: existing?.handle ?? "")
        self._visibility = State(initialValue: existing?.visibility ?? .everyone)
    }

    private var isEditing: Bool { existing != nil }

    private var trimmedHandle: String {
        handle.trimmingCharacters(in: .whitespaces)
    }

    var body: some View {
        NavigationStack {
            Form {
                Section {
                    Picker("Platform", selection: $platform) {
                        ForEach(SocialPlatform.allCases) { platform in
                            Label(platform.label, systemImage: platform.systemImage)
                                .tag(platform)
                        }
                    }

                    TextField("Handle or URL", text: $handle)
                        .textInputAutocapitalization(.never)
                        .autocorrectionDisabled()
                }

                Section {
                    Picker("Visibility", selection: $visibility) {
                        ForEach(SocialVisibility.allCases) { visibility in
                            Label(visibility.label, systemImage: visibility.systemImage)
                                .tag(visibility)
                        }
                    }
                } footer: {
                    Text(visibility == .friends
                        ? "Only shown once someone unlocks your Shiny card by bumping phones with you."
                        : "Shown on your card to everyone who passes you.")
                }

                if isEditing {
                    Section {
                        Button("Remove Link", role: .destructive, action: remove)
                    }
                }
            }
            .navigationTitle(isEditing ? "Edit Social" : "Add Social")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save", action: save)
                        .disabled(trimmedHandle.isEmpty)
                }
            }
        }
    }

    private func save() {
        if let existing, let index = socials.firstIndex(where: { $0.id == existing.id }) {
            socials[index].platform = platform
            socials[index].handle = trimmedHandle
            socials[index].visibility = visibility
        } else {
            socials.append(SocialLink(platform: platform, handle: trimmedHandle, visibility: visibility))
        }
        dismiss()
    }

    private func remove() {
        if let existing {
            socials.removeAll { $0.id == existing.id }
        }
        dismiss()
    }
}

// MARK: - Settings

private struct SettingsScreen: View {
    @Environment(AppModel.self) private var model

    var body: some View {
        NavigationStack {
            Form {
                Section {
                    VStack(spacing: 6) {
                        LoopingVideoView(resource: "SetupAnimation")
                            .frame(width: 96, height: 96)
                        Text("Furcards")
                            .font(.system(.title2, weight: .heavy))
                            .foregroundStyle(.white)
                        Text("alpha 2.0")
                            .font(.footnote)
                            .foregroundStyle(.secondary)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.top, 16)
                    .listRowBackground(Color.clear)
                }

                Section {
                    NavigationLink {
                        AboutSettingsView()
                    } label: {
                        Label("About", systemImage: "info.circle")
                    }
                    NavigationLink {
                        WalkedBySettingsView()
                    } label: {
                        Label("Nearby Trading", systemImage: "figure.walk")
                    }
                    NavigationLink {
                        NotificationSettingsView()
                    } label: {
                        Label("Notifications", systemImage: "bell.badge")
                    }
                    NavigationLink {
                        TransferView()
                    } label: {
                        Label("Export & Transfer", systemImage: "arrow.left.arrow.right")
                    }
#if DEBUG
                    NavigationLink {
                        DebugSettingsView()
                    } label: {
                        Label("Debug", systemImage: "ladybug")
                    }
#endif
                }

                Section {
                    Button(role: .destructive) {
                        confirmingReset = true
                    } label: {
                        Label("Reset App Data", systemImage: "trash")
                    }
                }
            }
            .scrollContentBackground(.hidden)
            .background(Color.black.ignoresSafeArea())
            .toolbar(.hidden, for: .navigationBar)
            .alert("Reset all app data?", isPresented: $confirmingReset) {
                Button("Erase Everything", role: .destructive) { model.resetAllData() }
                Button("Cancel", role: .cancel) {}
            } message: {
                Text("This erases everything on this device — your card, your whole collection, your identity, and all settings — and returns you to setup. It cannot be undone. Cards other people already collected from you are not affected.")
            }
        }
    }

    @State private var confirmingReset = false
}

/// About: app info, developer, support, and legal links.
private struct AboutSettingsView: View {
    private var appVersion: String {
        Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0"
    }

    var body: some View {
        Form {
            Section {
                LabeledContent("App", value: "Furcards")
                LabeledContent("Version", value: appVersion)
                Link(destination: URL(string: "https://furcards.app")!) {
                    LabeledContent {
                        Text("furcards.app")
                    } label: {
                        Label("Website", systemImage: "globe")
                    }
                }
                Link(destination: URL(string: "https://bsky.app/profile/furcards.app")!) {
                    LabeledContent {
                        Text("@furcards.app")
                    } label: {
                        Label("Contact the team", systemImage: "bubble.left.and.bubble.right.fill")
                    }
                }
                NavigationLink {
                    DonationView()
                } label: {
                    Label("Support Furcards", systemImage: "heart.fill")
                }
            } footer: {
                Text("Furcards is free. Questions, feedback, or a small tip to support development are all welcome.")
            }

            Section {
                Link(destination: LegalLinks.privacyPolicy) {
                    Label("Privacy Policy", systemImage: "hand.raised")
                }
                Link(destination: LegalLinks.termsOfService) {
                    Label("Terms of Use", systemImage: "doc.text")
                }
            } header: {
                Text("Legal")
            } footer: {
                Text("Cards travel phone-to-phone over Bluetooth. Nothing ever leaves the devices involved.")
            }
        }
        .navigationTitle("About")
        .navigationBarTitleDisplayMode(.inline)
    }
}

/// Nearby Trading: master toggle for the phone-to-phone exchange, plus the
/// optional location permission for encounter stamps. iOS prompts for Bluetooth
/// permission when the radios start.
private struct WalkedBySettingsView: View {
    @Environment(AppModel.self) private var model

    var body: some View {
        @Bindable var settings = model.settings
        Form {
            Section {
                Toggle("Enabled", isOn: $settings.nearbyTradingEnabled)
            } footer: {
                Text("Trade cards with the people around you, phone-to-phone over Bluetooth. You'll automatically collect the cards of people you walk by, and they'll collect yours.")
            }

            Section {
                Toggle("Share encounter counts", isOn: $settings.allowEncounterCount)
            } header: {
                Text("Sharing")
            } footer: {
                Text("When on, people you meet may see how many times you've crossed paths.")
            }

            Section {
                Toggle("Location stamps", isOn: Binding(
                    get: { settings.locationStampsEnabled },
                    set: { on in
                        settings.locationStampsEnabled = on
                        if on { model.requestLocationPermission() }
                    }
                ))
            } footer: {
                Text("Optional. Encounters remember where they happened — just the city when you pass someone, the exact spot for bumps. Location is only checked at that moment and never shared.")
            }
        }
        .navigationTitle("Nearby Trading")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#if DEBUG
/// Debug-only testing tools.
private struct DebugSettingsView: View {
    @Environment(AppModel.self) private var model

    var body: some View {
        Form {
            Section {
                Toggle(isOn: Binding(
                    get: { model.settings.demoMode },
                    set: { model.setDemoMode($0) }
                )) {
                    Label("Demo Mode", systemImage: "wand.and.stars")
                }
            } footer: {
                Text("Fills your collection with fake Nearby Trading and Friend cards, history, and a category. Turning it off empties the collection.")
            }

            Section {
                Button {
                    model.replayOnboarding()
                } label: {
                    Label("Show Onboarding", systemImage: "sparkles")
                }
            } footer: {
                Text("Replays the first-run setup flow from the welcome screen.")
            }

            if model.settings.nearbyTradingEnabled, let exchange = model.bleExchangeDiagnostics {
                Section("BLE diagnostics") {
                    Text("""
                    running: \(exchange.isRunning ? "yes" : "no")  advertising: \(exchange.isAdvertising ? "yes" : "no")  scanning: \(exchange.isScanning ? "yes" : "no")
                    ephemeral id: \(exchange.currentEphemeralId)
                    """)
                    .font(.caption.monospaced())
                    ForEach(exchange.recentPeers) { peer in
                        Text("\(peer.ephemeralId)  \(peer.rssi) dBm")
                            .font(.caption.monospaced())
                    }
                    ForEach(exchange.sessionLog.suffix(20), id: \.self) { line in
                        Text(line).font(.caption2.monospaced()).foregroundStyle(.secondary)
                    }
                }
            }
        }
        .navigationTitle("Debug")
        .navigationBarTitleDisplayMode(.inline)
    }
}
#endif

/// Notifications: daily recap toggle and delivery time.
private struct NotificationSettingsView: View {
    @Environment(AppModel.self) private var model

    var body: some View {
        @Bindable var settings = model.settings
        Form {
            Section {
                Toggle(isOn: Binding(
                    get: { settings.dailyWalkedByNotification },
                    set: { on in
                        if on {
                            Task { _ = await model.enableDailyWalkedByNotification() }
                        } else {
                            settings.dailyWalkedByNotification = false
                            model.rescheduleWalkedByNotification()
                        }
                    }
                )) {
                    Label("Daily recap", systemImage: "bell.badge")
                }

                DatePicker(
                    "Time",
                    selection: Binding(
                        get: {
                            var comps = DateComponents()
                            comps.hour = settings.notificationHour
                            comps.minute = settings.notificationMinute
                            return Calendar.current.date(from: comps) ?? Date()
                        },
                        set: { date in
                            let comps = Calendar.current.dateComponents([.hour, .minute], from: date)
                            settings.notificationHour = comps.hour ?? 18
                            settings.notificationMinute = comps.minute ?? 0
                            model.rescheduleWalkedByNotification()
                        }
                    ),
                    displayedComponents: .hourAndMinute
                )
                .disabled(!settings.dailyWalkedByNotification)
            } footer: {
                Text("A once-a-day heads-up of how many cards you traded, delivered at your chosen time.")
            }
        }
        .navigationTitle("Notifications")
        .navigationBarTitleDisplayMode(.inline)
    }
}

// MARK: - Theme

/// Shared layout constants for the trading card.
enum CardMetrics {
    static let aspectRatio: CGFloat = 2.5 / 3.5
    static let maxWidth: CGFloat = 350
    static let cornerRadius: CGFloat = 26
    /// fixed aspect of the artwork slot, same size on every card
    static let artworkAspect: CGFloat = 1.5

    static var cardShape: RoundedRectangle {
        RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
    }
}

/// The card's colour palette.
private enum CardPalette {
    static let highlightWarm = Color(red: 1.0, green: 0.76, blue: 0.78)
    static let highlightCool = Color(red: 0.55, green: 0.34, blue: 0.7)

    static let foilSheen: [Color] = [
        .clear,
        Color(red: 1.0, green: 0.9, blue: 0.94).opacity(0.2),
        .clear,
        Color(red: 0.78, green: 0.5, blue: 0.92).opacity(0.12),
        .clear
    ]
}

private extension View {
    /// thin white inset border in the given shape
    func hairlineBorder<S: InsettableShape>(_ shape: S, opacity: Double = 0.12, width: CGFloat = 1) -> some View {
        overlay {
            shape.strokeBorder(.white.opacity(opacity), lineWidth: width)
        }
    }

    /// dark rounded backdrop for text over the photo on the Full Photo layout,
    /// keeping name and pronouns legible
    func cardFieldBackdrop(cornerRadius: CGFloat = 15) -> some View {
        let shape = RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
        return self
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .background(.black.opacity(0.24), in: shape)
            .hairlineBorder(shape)
    }

    /// shared card look: background fill, a rim from the card's colors, and the overlay pattern
    func cardSurface(_ theme: CardTheme) -> some View {
        self
            .background(CardBody(theme: theme))
            .clipShape(CardMetrics.cardShape)
            .overlay {
                CardMetrics.cardShape
                    .strokeBorder(
                        LinearGradient(
                            colors: theme.borderColors,
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        lineWidth: 2
                    )
            }
            .overlay(CardFoil(pattern: theme.pattern).clipShape(CardMetrics.cardShape))
    }
}

#Preview {
    ContentView()
        .environment(AppModel(user: LocalUser(userID: "preview"), store: CardStore(userID: "preview"), settings: TradingSettings()))
}
