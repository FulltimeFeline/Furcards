//
//  BumpEvent.swift
//  Furcards
//
//  Created by Riley on 08/07/2026.
//

import Foundation

/// A recorded interaction with a person: a walk-by or a bump. Stores when and
/// where it happened, plus the messages exchanged on bumps.
struct Encounter: Identifiable, Codable, Hashable, Sendable {
    enum Kind: String, Codable, Sendable {
        case walkedBy
        case bump
    }

    let id: UUID
    var kind: Kind
    var date: Date
    var latitude: Double?
    var longitude: Double?
    /// The message you sent on this bump (empty for walk-bys).
    var myMessage: String
    /// The message they sent you on this bump (empty for walk-bys).
    var theirMessage: String

    init(
        id: UUID = UUID(),
        kind: Kind,
        date: Date,
        latitude: Double? = nil,
        longitude: Double? = nil,
        myMessage: String = "",
        theirMessage: String = ""
    ) {
        self.id = id
        self.kind = kind
        self.date = date
        self.latitude = latitude
        self.longitude = longitude
        self.myMessage = myMessage
        self.theirMessage = theirMessage
    }

    var hasLocation: Bool {
        latitude != nil && longitude != nil
    }
}

/// Minimum time between recorded bumps with the same person.
let bumpCooldown: TimeInterval = 6 * 60 * 60

/// Minimum time between recorded walk-bys with the same person.
let walkByCooldown: TimeInterval = 6 * 60 * 60
