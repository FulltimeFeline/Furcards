//
//  KeychainSecureStorage.swift
//  Furcards
//
//  iOS half of the core's SecureStorage: identity key material in the
//  Keychain. Injected into SecureStorageRegistry at startup (see FurcardsApp).
//

import Foundation
import FurcardsCore
import Security

final class KeychainSecureStorage: NSObject, SecureStorage {
    private let service = "com.fulltimefeline.furcards.securestorage"

    func load(key: String) -> KotlinByteArray? {
        var query = baseQuery(key: key)
        query[kSecReturnData as String] = true
        query[kSecMatchLimit as String] = kSecMatchLimitOne
        var result: CFTypeRef?
        guard SecItemCopyMatching(query as CFDictionary, &result) == errSecSuccess,
              let data = result as? Data
        else { return nil }
        return data.kotlinByteArray
    }

    func store(key: String, value: KotlinByteArray) {
        let data = value.data
        var query = baseQuery(key: key)
        let update: [String: Any] = [kSecValueData as String: data]
        let status = SecItemUpdate(query as CFDictionary, update as CFDictionary)
        if status == errSecItemNotFound {
            query[kSecValueData as String] = data
            // the identity key must survive without unlock-gating (background
            // exchanges), but must never leave this device via backups
            query[kSecAttrAccessible as String] = kSecAttrAccessibleAfterFirstUnlockThisDeviceOnly
            SecItemAdd(query as CFDictionary, nil)
        }
    }

    func delete(key: String) {
        SecItemDelete(baseQuery(key: key) as CFDictionary)
    }

    private func baseQuery(key: String) -> [String: Any] {
        [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: key,
        ]
    }
}
