//
//  LocalUser.swift
//  Furcards
//
//  Stable storage namespace for the local user. No accounts: identity is the
//  Ed25519 keypair, and this id only scopes local persistence.
//

import CoreLocation
import Foundation

struct LocalUser {
    let userID: String
}

/// Loads the local user, reusing the server-era session's userId if one was
/// stored (same UserDefaults key the old SessionStore wrote) so existing users
/// keep their `CardStore.*.v1.<userId>` collections. Fresh installs mint a
/// random id once.
enum LocalUserStore {
    private static let legacyKey = "furcards.userId" // the old SessionStore's key
    private static let mintedKey = "furcards.localUserId"

    static func load() -> LocalUser {
        if let legacy = UserDefaults.standard.string(forKey: legacyKey) {
            return LocalUser(userID: legacy)
        }
        if let minted = UserDefaults.standard.string(forKey: mintedKey) {
            return LocalUser(userID: minted)
        }
        let fresh = UUID().uuidString
        UserDefaults.standard.set(fresh, forKey: mintedKey)
        return LocalUser(userID: fresh)
    }
}

/// One-shot location fix for stamping a just-recorded encounter, the only
/// location use left in the app. City-level for walk-bys (coordinates rounded
/// to ~1 km), precise for bumps. No permission or no fix means nil, so the
/// encounter is timestamp-only.
@MainActor
final class EncounterStamper: NSObject, CLLocationManagerDelegate {
    private let manager = CLLocationManager()
    private var waiters: [(CLLocation?) -> Void] = []

    override init() {
        super.init()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyHundredMeters
    }

    /// Asks for when-in-use permission (settings/onboarding path).
    func requestPermission() {
        manager.requestWhenInUseAuthorization()
    }

    func stamp(precise: Bool) async -> (Double, Double)? {
        let status = manager.authorizationStatus
        guard status == .authorizedWhenInUse || status == .authorizedAlways else { return nil }
        let location = await withCheckedContinuation { (continuation: CheckedContinuation<CLLocation?, Never>) in
            waiters.append { continuation.resume(returning: $0) }
            manager.requestLocation()
        }
        guard let location else { return nil }
        let lat = location.coordinate.latitude
        let lon = location.coordinate.longitude
        return precise
            ? (lat, lon)
            : ((lat * 100).rounded() / 100, (lon * 100).rounded() / 100)
    }

    nonisolated func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations.last
        Task { @MainActor in
            waiters.forEach { $0(location) }
            waiters.removeAll()
        }
    }

    nonisolated func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        Task { @MainActor in
            waiters.forEach { $0(nil) }
            waiters.removeAll()
        }
    }
}
