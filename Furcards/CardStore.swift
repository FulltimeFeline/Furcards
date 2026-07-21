//
//  CardStore.swift
//  Furcards
//
//  Created by Riley on 08/07/2026.
//

import Foundation
import Observation

/// In-memory store for the user's own card, cards collected while walking
/// around (common), and friends unlocked by bumping.
@Observable
final class CardStore {
    /// User's own card, shown on My Card and shared with others.
    var myCard: Furcard { didSet { persist(myCard, forKey: key("myCard")) } }

    /// Everyone walked by. Friends stay here too.
    private(set) var seen: [Furcard] = [] { didSet { persist(seen, forKey: key("seen")) } }

    /// Friend cards unlocked by bumping. Rendered with the glow.
    private(set) var friends: [Furcard] = [] { didSet { persist(friends, forKey: key("friends")) } }

    /// Per-person interaction history (walk-bys + bumps), newest first.
    private(set) var history: [UUID: [Encounter]] = [:] { didSet { persist(history, forKey: key("history")) } }

    /// User-created categories, each shown as its own carousel.
    private(set) var categories: [CardCategory] = [] { didSet { persist(categories, forKey: key("categories")) } }

    /// Scopes persisted data to the signed-in user so one account's collection
    /// doesn't leak into another's on a shared device. Friends and walk-bys are
    /// server-backed (restored on login) so they survive across devices;
    /// history and categories are local to this device.
    private let userNamespace: String

    /// Namespace the exchange stores (blob cache, blocklist, own-card signer)
    /// scope by, kept identical to the collection's.
    var userID: String { userNamespace }

    init(userID: String? = nil, myCard: Furcard = .sample) {
        self.userNamespace = userID ?? "anon"
        // didSet doesn't fire during init, load each field explicitly
        self.myCard = Self.load(Furcard.self, forKey: Self.key("myCard", namespace: userNamespace)) ?? myCard
        self.seen = Self.load([Furcard].self, forKey: Self.key("seen", namespace: userNamespace)) ?? []
        self.friends = Self.load([Furcard].self, forKey: Self.key("friends", namespace: userNamespace)) ?? []
        self.history = Self.load([UUID: [Encounter]].self, forKey: Self.key("history", namespace: userNamespace)) ?? [:]
        self.categories = Self.load([CardCategory].self, forKey: Self.key("categories", namespace: userNamespace)) ?? []
    }

    private static func key(_ field: String, namespace: String) -> String {
        "CardStore.\(field).v1.\(namespace)"
    }

    private func key(_ field: String) -> String {
        Self.key(field, namespace: userNamespace)
    }

    private func persist<T: Encodable>(_ value: T, forKey key: String) {
        if let data = try? JSONEncoder().encode(value) {
            UserDefaults.standard.set(data, forKey: key)
        }
    }

    private static func load<T: Decodable>(_ type: T.Type, forKey key: String) -> T? {
        guard let data = UserDefaults.standard.data(forKey: key) else { return nil }
        return try? JSONDecoder().decode(T.self, from: data)
    }

    /// Records walking by someone: adds to Walked By and appends a walk-by
    /// encounter, throttled by `walkByCooldown`. Friends can be walked by too.
    func recordSeen(_ card: Furcard, event: Encounter) {
        guard card.id != myCard.id else { return }

        let lastWalkBy = history[card.id]?.first { $0.kind == .walkedBy }
        if let lastWalkBy, event.date.timeIntervalSince(lastWalkBy.date) < walkByCooldown {
            if !seen.contains(where: { $0.id == card.id }) {
                seen.insert(card, at: 0)
            }
            return
        }

        moveToFront(card, in: &seen)
        history[card.id, default: []].insert(event, at: 0)
    }

    /// Records a bump: adds/refreshes the friend (keeping them in Walked By too)
    /// and appends a bump encounter. Enforces the once-per-24h rule per person.
    /// Returns whether the bump was recorded.
    @discardableResult
    func recordBump(with card: Furcard, event: Encounter) -> Bool {
        guard card.id != myCard.id else { return false }

        let lastBump = history[card.id]?.first { $0.kind == .bump }
        if let lastBump, event.date.timeIntervalSince(lastBump.date) < bumpCooldown {
            return false
        }

        moveToFront(card, in: &friends)
        moveToFront(card, in: &seen)
        history[card.id, default: []].insert(event, at: 0)
        return true
    }

    /// Refreshes the collection from the server: updates each collected
    /// person's stored card to their current card (so edits propagate) and adds
    /// any the server knows about that this device hasn't seen. Local history
    /// and ordering are preserved.
    func replaceCollection(
        walkedBy: [Furcard],
        friends incomingFriends: [Furcard],
        seedLatitude: Double? = nil,
        seedLongitude: Double? = nil
    ) {
        merge(walkedBy, into: &seen)
        merge(incomingFriends, into: &friends)
        // Server response is authoritative for who you've collected, so drop
        // anyone it no longer reports (e.g. after a block removes you both from
        // each other's collection, or the other person deleted their account).
        let walkedByIDs = Set(walkedBy.map(\.id))
        let friendIDs = Set(incomingFriends.map(\.id))
        seen.removeAll { !walkedByIDs.contains($0.id) }
        friends.removeAll { !friendIDs.contains($0.id) }
        let keptIDs = walkedByIDs.union(friendIDs)
        for id in history.keys where !keptIDs.contains(id) { history[id] = nil }
        // Server sync carries no per-encounter history (that's local), so give
        // anyone without history a walk-by entry, otherwise Walked By people
        // restored from the server would show an empty timeline.
        for card in seen where (history[card.id]?.isEmpty ?? true) {
            history[card.id] = [Encounter(kind: .walkedBy, date: Date(), latitude: seedLatitude, longitude: seedLongitude, myMessage: myCard.message, theirMessage: card.message)]
        }
        sortByRecency(&seen)
        sortByRecency(&friends)
    }

    /// Overwrites matching cards with the incoming version (server content
    /// wins), keeping existing order and appending newly-known cards at the end.
    /// `message` is kept as a snapshot from the last encounter (what they were
    /// saying when you walked by / bumped, not their current message);
    /// everything else (art, name, socials) updates live.
    private func merge(_ incoming: [Furcard], into list: inout [Furcard]) {
        guard !incoming.isEmpty else { return }
        var byID = Dictionary(incoming.map { ($0.id, $0) }, uniquingKeysWith: { _, last in last })
        var result: [Furcard] = []
        for existing in list {
            if var updated = byID.removeValue(forKey: existing.id) {
                updated.message = existing.message // freeze message from the last encounter
                result.append(updated)
            } else {
                result.append(existing)
            }
        }
        for card in incoming where byID[card.id] != nil {
            result.append(card)
            byID.removeValue(forKey: card.id)
        }
        list = result
    }

    /// Sorts by most recent interaction; cards without history keep their
    /// relative order at the end.
    private func sortByRecency(_ list: inout [Furcard]) {
        let latest: (Furcard) -> Date = { self.history[$0.id]?.first?.date ?? .distantPast }
        list = list.enumerated()
            .sorted { lhs, rhs in
                let l = latest(lhs.element), r = latest(rhs.element)
                return l == r ? lhs.offset < rhs.offset : l > r
            }
            .map(\.element)
    }

    /// The combined interaction history for a person, newest first.
    func encounters(for cardID: UUID) -> [Encounter] {
        history[cardID] ?? []
    }

    /// Whether a given card has already been added as a friend.
    func isFriend(_ card: Furcard) -> Bool {
        friends.contains { $0.id == card.id }
    }

    /// Merges an imported/restored collection in: incoming entries win on
    /// conflicts, local extras survive, per-person history is unioned by
    /// encounter id. Used by the export/import flow and the iCloud restore.
    func importCollection(
        seen incomingSeen: [Furcard],
        friends incomingFriends: [Furcard],
        history incomingHistory: [UUID: [Encounter]],
        categories incomingCategories: [CardCategory]
    ) {
        func merge(_ incoming: [Furcard], into existing: [Furcard]) -> [Furcard] {
            var byID = [UUID: Furcard]()
            var order = [UUID]()
            for card in incoming where byID[card.id] == nil {
                byID[card.id] = card
                order.append(card.id)
            }
            for card in existing where byID[card.id] == nil {
                byID[card.id] = card
                order.append(card.id)
            }
            return order.compactMap { byID[$0] }
        }
        seen = merge(incomingSeen, into: seen)
        friends = merge(incomingFriends, into: friends)

        var mergedHistory = history
        for (cardID, encounters) in incomingHistory {
            var union = mergedHistory[cardID] ?? []
            let known = Set(union.map(\.id))
            union.append(contentsOf: encounters.filter { !known.contains($0.id) })
            mergedHistory[cardID] = union.sorted { $0.date > $1.date }
        }
        history = mergedHistory

        var categoryByID = [UUID: CardCategory]()
        var categoryOrder = [UUID]()
        for category in incomingCategories where categoryByID[category.id] == nil {
            categoryByID[category.id] = category
            categoryOrder.append(category.id)
        }
        for category in categories where categoryByID[category.id] == nil {
            categoryByID[category.id] = category
            categoryOrder.append(category.id)
        }
        categories = categoryOrder.compactMap { categoryByID[$0] }
    }

    /// Swaps a server-era (unsigned) entry for the signed identity that
    /// superseded it in person (PROTOCOL.md §8): the signed card takes the
    /// legacy card's place in Walked By (and Friends, if they were one), and
    /// its encounter history and category memberships move with it.
    func upgradeLegacy(legacyID: UUID, signed: Furcard) {
        let wasFriend = friends.contains { $0.id == legacyID }
        seen.removeAll { $0.id == legacyID || $0.id == signed.id }
        seen.insert(signed.commonCard, at: 0)
        if wasFriend {
            friends.removeAll { $0.id == legacyID || $0.id == signed.id }
            friends.insert(signed, at: 0)
        }
        if let moved = history[legacyID], !moved.isEmpty {
            var union = history[signed.id] ?? []
            let known = Set(union.map(\.id))
            union.append(contentsOf: moved.filter { !known.contains($0.id) })
            history[legacyID] = nil
            history[signed.id] = union.sorted { $0.date > $1.date }
        }
        for index in categories.indices where categories[index].cardIDs.contains(legacyID) {
            var kept = Set<UUID>()
            categories[index].cardIDs = categories[index].cardIDs
                .map { $0 == legacyID ? signed.id : $0 }
                .filter { kept.insert($0).inserted }
        }
    }

    func remove(cardID: UUID) {
        seen.removeAll { $0.id == cardID }
        friends.removeAll { $0.id == cardID }
        history[cardID] = nil
        for index in categories.indices {
            categories[index].cardIDs.removeAll { $0 == cardID }
        }
    }

    /// Clears all collected data and resets the user's card (used on logout).
    func reset() {
        seen = []
        friends = []
        history = [:]
        categories = []
        myCard = .sample
    }

    /// Clears everything collected (Walked By, Friends, history, categories) but
    /// keeps the user's own card. Used by the debug "Clear Test Data" action.
    func clearCollected() {
        seen = []
        friends = []
        history = [:]
        categories = []
    }

    private func moveToFront(_ card: Furcard, in list: inout [Furcard]) {
        list.removeAll { $0.id == card.id }
        list.insert(card, at: 0)
    }

    // MARK: Categories

    /// Resolves a card id to a collected card (friend or walked-by).
    func card(for id: UUID) -> Furcard? {
        friends.first { $0.id == id } ?? seen.first { $0.id == id }
    }

    /// Creates a new empty category and returns it.
    @discardableResult
    func createCategory(name: String) -> CardCategory {
        let category = CardCategory(name: name)
        categories.insert(category, at: 0)
        return category
    }

    func deleteCategory(_ id: UUID) {
        categories.removeAll { $0.id == id }
    }

    /// Adds or removes a card from a category (newest-added first).
    func toggleCard(_ cardID: UUID, in categoryID: UUID) {
        guard let index = categories.firstIndex(where: { $0.id == categoryID }) else { return }
        if let cardIndex = categories[index].cardIDs.firstIndex(of: cardID) {
            categories[index].cardIDs.remove(at: cardIndex)
        } else {
            categories[index].cardIDs.insert(cardID, at: 0)
        }
    }

    func isCard(_ cardID: UUID, in categoryID: UUID) -> Bool {
        categories.first { $0.id == categoryID }?.cardIDs.contains(cardID) ?? false
    }

    /// The resolved cards in a category, member order preserved.
    func cards(in category: CardCategory) -> [Furcard] {
        category.cardIDs.compactMap { card(for: $0) }
    }

#if DEBUG
    /// Fills the store with fabricated cards, friends, history, and a category
    /// for testing UI without real proximity hardware. Debug builds only.
    func populateTestData() {
        let people = Furcard.samplePeople
        guard !people.isEmpty else { return }

        let now = Date()
        let hour: TimeInterval = 3600
        let day: TimeInterval = 86400
        let places: [(lat: Double, lon: Double)] = [
            (40.7580, -73.9855),   // Times Square
            (37.8058, -122.4229),  // Ghirardelli Square
            (35.6595, 139.7005),   // Shibuya
            (51.5390, -0.1426),    // Camden
            (48.8590, 2.3610)      // Le Marais
        ]

        seen = []
        friends = []
        history = [:]
        categories = []
        var favoriteIDs: [UUID] = []

        for (index, person) in people.enumerated() {
            let place = places[index % places.count]
            let isFriend = index >= max(0, people.count - 2)

            // fresh id (so the running simulator can't overwrite it) and random
            // colors, never the user's theme. keeps the sample's artwork and
            // template so demo cards show off the different templates.
            let card = Furcard(
                name: person.name,
                pronouns: person.pronouns,
                identityFlags: person.identityFlags,
                artworkName: person.artworkName,
                artistCredit: person.artistCredit,
                tags: person.tags,
                bio: person.bio,
                socials: person.socials,
                message: person.message,
                theme: Self.randomTheme(),
                template: person.template
            )

            var events: [Encounter] = [
                Encounter(kind: .walkedBy, date: now.addingTimeInterval(-Double(index + 1) * hour), latitude: place.lat, longitude: place.lon),
                Encounter(kind: .walkedBy, date: now.addingTimeInterval(-Double(index + 2) * day), latitude: place.lat + 0.002, longitude: place.lon - 0.002)
            ]

            if isFriend {
                events.append(Encounter(kind: .bump, date: now.addingTimeInterval(-Double(index) * hour - hour), latitude: place.lat, longitude: place.lon, myMessage: "Great to finally meet!", theirMessage: card.message))
                events.append(Encounter(kind: .bump, date: now.addingTimeInterval(-3 * day), latitude: place.lat, longitude: place.lon, myMessage: "Fun bumping again 🎉", theirMessage: "Likewise!"))
                friends.append(card)
            }

            seen.append(card)
            history[card.id] = events.sorted { $0.date > $1.date }
            if index < 3 { favoriteIDs.append(card.id) }
        }

        let latestDate: (Furcard) -> Date = { self.history[$0.id]?.first?.date ?? .distantPast }
        seen.sort { latestDate($0) > latestDate($1) }
        friends.sort { latestDate($0) > latestDate($1) }

        categories = [CardCategory(name: "Favorites", cardIDs: favoriteIDs)]
    }

    /// A random gradient + glow for fabricated test cards.
    private static func randomTheme() -> CardTheme {
        let background = [
            CardColor(red: .random(in: 0.05...0.22), green: .random(in: 0.05...0.22), blue: .random(in: 0.10...0.30)),
            CardColor(red: .random(in: 0.30...0.60), green: .random(in: 0.20...0.55), blue: .random(in: 0.30...0.65)),
            CardColor(red: .random(in: 0.60...0.95), green: .random(in: 0.50...0.90), blue: .random(in: 0.60...0.95))
        ]
        let glow = (0..<5).map { _ in
            CardColor(red: .random(in: 0.35...1), green: .random(in: 0.35...1), blue: .random(in: 0.35...1))
        }
        return CardTheme(colors: background, pattern: Bool.random() ? .sparkles : .dots, glowColors: glow)
    }
#endif
}
