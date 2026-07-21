//
//  CardCategory.swift
//  Furcards
//
//  Created by Riley on 08/07/2026.
//

import Foundation

/// A user-created grouping of collected cards, shown as its own carousel.
struct CardCategory: Identifiable, Codable, Hashable, Sendable {
    let id: UUID
    var name: String
    /// Member card ids, newest-added first.
    var cardIDs: [UUID]

    init(id: UUID = UUID(), name: String, cardIDs: [UUID] = []) {
        self.id = id
        self.name = name
        self.cardIDs = cardIDs
    }
}
