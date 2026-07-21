//
//  OnboardingView.swift
//  Furcards
//
//  Created by Riley on 08/07/2026.
//

import SwiftUI
import UserNotifications

/// First-run setup: explains the app, configures Nearby Trading, and sets up
/// the profile. No accounts, no location-always, no zones.
struct OnboardingView: View {
    @Environment(AppModel.self) private var model
    @State private var step = 0
    @State private var isEditingCard = false
    @State private var locationAsked = false
    /// Steps for this run, fixed on appear. New users get the full flow; a
    /// returning user only reconfigures Nearby Trading.
    @State private var flowSteps: [Step] = []

    private enum Step { case welcome, howItWorks, walkedByInfo, bumpInfo, nearbyTrading, notifications, profile }

    private var lastStep: Int { max(0, flowSteps.count - 1) }
    private var currentStep: Step { flowSteps.isEmpty ? .nearbyTrading : flowSteps[min(step, flowSteps.count - 1)] }

    var body: some View {
        @Bindable var store = model.store
        ZStack {
            Color.black
                .ignoresSafeArea()

            VStack(spacing: 0) {
                ScrollView {
                    VStack(spacing: 24) {
                        switch currentStep {
                        case .welcome: welcome
                        case .howItWorks: howItWorks
                        case .walkedByInfo: walkedByInfo
                        case .bumpInfo: bumpInfo
                        case .nearbyTrading: nearbyTrading()
                        case .notifications: notifications()
                        case .profile: profile()
                        }
                    }
                    .padding(28)
                    .frame(maxWidth: 460)
                    .frame(maxWidth: .infinity)
                }

                controls
            }
        }
        .onAppear {
            if flowSteps.isEmpty {
                flowSteps = model.settings.hasCompletedSetup
                    ? [.nearbyTrading]
                    : [.welcome, .howItWorks, .walkedByInfo, .bumpInfo, .nearbyTrading, .notifications, .profile]
            }
        }
        .sheet(isPresented: $isEditingCard) {
            CardEditor(card: $store.myCard)
        }
    }

    // MARK: Steps

    private var welcome: some View {
        stepScaffold(
            glyph: {
                LoopingVideoView(resource: "SetupAnimation")
                    .frame(width: 132, height: 132)
            },
            title: "Welcome to Furcards",
            subtitle: "Your furry trading card — shared phone-to-phone with the people around you. Nothing ever leaves the devices involved."
        ) {
            EmptyView()
        }
    }

    private var howItWorks: some View {
        stepScaffold(
            icon: "sparkles",
            title: "How it works",
            subtitle: "Furcards is a trading card for your fursona — meet people just by being near them."
        ) {
            VStack(alignment: .leading, spacing: 16) {
                infoRow(
                    icon: "person.text.rectangle.fill",
                    title: "Your card",
                    text: "Build a card with your photo, bio, tags, and links. It's the profile everyone around you sees."
                )
                infoRow(
                    icon: "figure.walk",
                    title: "Nearby Trading",
                    text: "Pass someone with the app and your phones quietly trade public cards over Bluetooth — no tapping needed."
                )
                infoRow(
                    icon: "hand.wave.fill",
                    title: "Bump",
                    text: "Met someone in person? Hold your phones together, tap Bump on their card, and they just accept the prompt - that unlocks each other's Shiny card."
                )
                infoRow(
                    icon: "lock.open.fill",
                    title: "Unlock Shiny cards",
                    text: "A mutual bump unlocks each other's glowing Shiny card, revealing the private links you don't share with everyone."
                )
            }
        }
    }

    private var walkedByInfo: some View {
        stepScaffold(
            icon: "figure.walk",
            title: "Nearby Trading, in detail",
            subtitle: "Collect people just by being near them — no tapping, no opening the app."
        ) {
            VStack(alignment: .leading, spacing: 16) {
                infoRow(
                    icon: "wand.and.stars",
                    title: "Automatic",
                    text: "Be near someone who also has Furcards and your phones quietly trade public cards."
                )
                infoRow(
                    icon: "arrow.left.arrow.right",
                    title: "Mutual",
                    text: "They collect your card too. Only your public card is shared — private links stay hidden until you bump."
                )
                infoRow(
                    icon: "antenna.radiowaves.left.and.right",
                    title: "Phone-to-phone",
                    text: "Cards travel directly between phones over Bluetooth. There's no server — nothing ever leaves the devices involved."
                )
                infoRow(
                    icon: "switch.2",
                    title: "You're in control",
                    text: "Turn Nearby Trading off anytime in Settings."
                )
            }
        }
    }

    private var bumpInfo: some View {
        stepScaffold(
            icon: "hand.wave.fill",
            title: "Bumps, in detail",
            subtitle: "Meeting someone in person? Bump phones to unlock each other's Shiny card."
        ) {
            VStack(alignment: .leading, spacing: 16) {
                infoRow(
                    icon: "iphone.gen3.radiowaves.left.and.right",
                    title: "Hold phones together",
                    text: "Tap Bump on their card; their phone pops an accept prompt - no digging through menus on their side."
                )
                infoRow(
                    icon: "sparkles",
                    title: "Unlock their Shiny card",
                    text: "A mutual bump unlocks each other's glowing Shiny card, revealing the private links you don't share with everyone."
                )
                infoRow(
                    icon: "quote.bubble.fill",
                    title: "Send a custom message",
                    text: "Attach a personal note to each bump — they'll see it on your card when you connect."
                )
                infoRow(
                    icon: "mappin.and.ellipse",
                    title: "Remember the moment",
                    text: "With location allowed, each bump remembers where it happened — walk-bys just remember the city."
                )
            }
        }
    }

    private func nearbyTrading() -> some View {
        @Bindable var settings = model.settings
        return stepScaffold(
            icon: "antenna.radiowaves.left.and.right",
            title: "Nearby Trading",
            subtitle: "Trade cards with people around you over Bluetooth. You can change this anytime in Settings."
        ) {
            VStack(spacing: 16) {
                Toggle("Turn on Nearby Trading", isOn: Binding(
                    get: { settings.nearbyTradingEnabled },
                    set: { on in
                        settings.nearbyTradingEnabled = on
                        model.reconcileBleExchange()
                    }
                ))
                .tint(Color.accentColor)
                .padding(14)
                .background(.white.opacity(0.08), in: RoundedRectangle(cornerRadius: 14, style: .continuous))

                VStack(alignment: .leading, spacing: 8) {
                    Text("Remember where you met")
                        .font(.subheadline.weight(.bold))
                    Text("Optional. Encounters remember where they happened — just the city when you pass someone, the exact spot for bumps. Location is only checked at that moment and never shared.")
                        .font(.footnote)
                        .foregroundStyle(.white.opacity(0.7))

                    Toggle("Location stamps", isOn: Binding(
                        get: { settings.locationStampsEnabled },
                        set: { on in
                            settings.locationStampsEnabled = on
                            if on { model.requestLocationPermission() }
                        }
                    ))
                    .tint(Color.accentColor)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(14)
                .background(.white.opacity(0.08), in: RoundedRectangle(cornerRadius: 14, style: .continuous))
            }
            .foregroundStyle(.white)
        }
    }

    private func notifications() -> some View {
        @Bindable var settings = model.settings
        return stepScaffold(
            icon: "bell.badge.fill",
            title: "Daily recap",
            subtitle: "Get a once-a-day heads-up of how many cards you traded. Pick a time that suits you."
        ) {
            VStack(spacing: 16) {
                Toggle("Daily recap notification", isOn: Binding(
                    get: { settings.dailyWalkedByNotification },
                    set: { on in
                        if on {
                            Task { _ = await model.enableDailyWalkedByNotification() }
                        } else {
                            settings.dailyWalkedByNotification = false
                            model.rescheduleWalkedByNotification()
                        }
                    }
                ))
                .tint(Color.accentColor)
                .padding(14)
                .background(.white.opacity(0.08), in: RoundedRectangle(cornerRadius: 14, style: .continuous))

                DatePicker(
                    "Time",
                    selection: notificationTime,
                    displayedComponents: .hourAndMinute
                )
                .datePickerStyle(.compact)
                .tint(.white)
                .padding(14)
                .background(.white.opacity(0.08), in: RoundedRectangle(cornerRadius: 14, style: .continuous))
                .opacity(settings.dailyWalkedByNotification ? 1 : 0.4)
                .disabled(!settings.dailyWalkedByNotification)
            }
            .foregroundStyle(.white)
        }
        // ask for notification permission when this step appears. granting
        // doesn't auto-enable the recap.
        .task {
            _ = try? await UNUserNotificationCenter.current()
                .requestAuthorization(options: [.alert, .sound, .badge])
        }
    }

    /// Bridges the stored hour/minute to a `Date` for the `DatePicker`.
    private var notificationTime: Binding<Date> {
        Binding(
            get: {
                var comps = DateComponents()
                comps.hour = model.settings.notificationHour
                comps.minute = model.settings.notificationMinute
                return Calendar.current.date(from: comps) ?? Date()
            },
            set: { date in
                let comps = Calendar.current.dateComponents([.hour, .minute], from: date)
                model.settings.notificationHour = comps.hour ?? 18
                model.settings.notificationMinute = comps.minute ?? 0
                model.rescheduleWalkedByNotification()
            }
        )
    }

    private func profile() -> some View {
        @Bindable var store = model.store
        return stepScaffold(
            icon: "person.text.rectangle.fill",
            title: "Set up your card",
            subtitle: "This is what people see when they collect you."
        ) {
            VStack(spacing: 12) {
                TextField("Name", text: $store.myCard.name)
                    .textContentType(.name)
                    .fieldBox()
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled()
                    .fieldBox()
                TextField("Pronouns (e.g. She/They)", text: $store.myCard.pronouns)
                    .fieldBox()
                TextField("Identity flags 🏳️‍🌈", text: $store.myCard.identityFlags)
                    .fieldBox()
                TextField("Bio", text: $store.myCard.bio, axis: .vertical)
                    .lineLimit(2...4)
                    .fieldBox()
                TextField("Card message", text: $store.myCard.message, axis: .vertical)
                    .lineLimit(2...3)
                    .fieldBox()
                TextField("Tags (comma separated)", text: tagsText, axis: .vertical)
                    .fieldBox()

                Button {
                    isEditingCard = true
                } label: {
                    Label("Photo, socials & colors", systemImage: "slider.horizontal.3")
                        .font(.subheadline.weight(.semibold))
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.bordered)
                .controlSize(.large)
                .tint(.white)
            }
        }
    }

    /// Bridges the `[String]` tags to a comma-separated field.
    private var tagsText: Binding<String> {
        Binding(
            get: { model.store.myCard.tags.joined(separator: ", ") },
            set: { newValue in
                model.store.myCard.tags = newValue
                    .split(separator: ",")
                    .map { $0.trimmingCharacters(in: .whitespaces) }
                    .filter { !$0.isEmpty }
            }
        )
    }

    // MARK: Chrome

    private var controls: some View {
        HStack(spacing: 12) {
            if step > 0 {
                Button("Back") {
                    withAnimation { step -= 1 }
                }
                .font(.headline.weight(.semibold))
                .tint(.white)
            }

            Button {
                advance()
            } label: {
                Text(step == lastStep ? "Get Started" : "Continue")
                    .font(.headline.weight(.semibold))
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)
            .controlSize(.large)
            .disabled(!canContinue)
        }
        .padding(20)
        .background(.ultraThinMaterial)
    }

    private var canContinue: Bool {
        guard currentStep == .profile else { return true }
        let name = model.store.myCard.name.trimmingCharacters(in: .whitespaces)
        return !name.isEmpty
    }

    private func advance() {
        guard step == lastStep else {
            withAnimation { step += 1 }
            return
        }
        // done. everything is local, so this can't fail.
        if flowSteps.contains(.profile) {
            model.saveCard(model.store.myCard)
        }
        model.settings.hasCompletedSetup = true
        model.clearWalkedBySetup()
    }

    // MARK: Building blocks

    private func stepScaffold<Content: View>(
        icon: String,
        title: String,
        subtitle: String,
        @ViewBuilder content: () -> Content
    ) -> some View {
        stepScaffold(
            glyph: {
                Image(systemName: icon)
                    .font(.system(size: 46, weight: .semibold))
                    .foregroundStyle(.white)
            },
            title: title,
            subtitle: subtitle,
            content: content
        )
    }

    @ViewBuilder
    private func stepScaffold<Glyph: View, Content: View>(
        @ViewBuilder glyph: () -> Glyph,
        title: String,
        subtitle: String,
        @ViewBuilder content: () -> Content
    ) -> some View {
        VStack(spacing: 16) {
            glyph()
                .padding(.top, 16)

            Text(title)
                .font(.system(.title, weight: .heavy))
                .foregroundStyle(.white)
                .multilineTextAlignment(.center)

            Text(subtitle)
                .font(.subheadline)
                .foregroundStyle(.white.opacity(0.75))
                .multilineTextAlignment(.center)

            content()
                .padding(.top, 8)
        }
    }

    private func infoRow(icon: String, title: String, text: String) -> some View {
        HStack(alignment: .top, spacing: 14) {
            Image(systemName: icon)
                .font(.title3.weight(.semibold))
                .foregroundStyle(.white)
                .frame(width: 40, height: 40)
                .background(.white.opacity(0.12), in: Circle())

            VStack(alignment: .leading, spacing: 3) {
                Text(title)
                    .font(.headline)
                    .foregroundStyle(.white)
                Text(text)
                    .font(.subheadline)
                    .foregroundStyle(.white.opacity(0.75))
            }
            Spacer(minLength: 0)
        }
    }
}

private extension View {
    func fieldBox() -> some View {
        padding(14)
            .background(.white.opacity(0.1), in: RoundedRectangle(cornerRadius: 14, style: .continuous))
            .foregroundStyle(.white)
            .tint(.white)
    }
}

/// App mark: a trading card with a paw inside (matches the app icon).
struct PawCardGlyph: View {
    var size: CGFloat = 88

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: size * 0.2, style: .continuous)
                .fill(
                    LinearGradient(
                        colors: [Color(red: 0.98, green: 0.50, blue: 0.72),
                                 Color(red: 0.60, green: 0.40, blue: 0.86)],
                        startPoint: .topLeading, endPoint: .bottomTrailing
                    )
                )
                .overlay(
                    RoundedRectangle(cornerRadius: size * 0.2, style: .continuous)
                        .strokeBorder(.white.opacity(0.35), lineWidth: 1.5)
                )
                .frame(width: size, height: size * 1.26)

            Image(systemName: "pawprint.fill")
                .font(.system(size: size * 0.52, weight: .bold))
                .foregroundStyle(.white)
        }
        .shadow(color: .black.opacity(0.3), radius: size * 0.12, x: 0, y: size * 0.07)
    }
}
