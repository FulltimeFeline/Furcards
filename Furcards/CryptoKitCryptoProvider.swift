//
//  CryptoKitCryptoProvider.swift
//  Furcards
//
//  iOS half of the core's CryptoProvider: Ed25519 via CryptoKit. CryptoKit is
//  Swift-only (Kotlin/Native can't import it), so the core exposes the
//  interface and this class is injected into CryptoRegistry at startup (see
//  FurcardsApp). The Android half is Tink; both must cross-verify, pinned by
//  the golden-vector test suites on each platform.
//

import CryptoKit
import Foundation
import FurcardsCore

final class CryptoKitCryptoProvider: NSObject, CryptoProvider {
    func generatePrivateKey() -> KotlinByteArray {
        Curve25519.Signing.PrivateKey().rawRepresentation.kotlinByteArray
    }

    func publicKey(privateKey: KotlinByteArray) -> KotlinByteArray {
        key(privateKey).publicKey.rawRepresentation.kotlinByteArray
    }

    func sign(privateKey: KotlinByteArray, message: KotlinByteArray) -> KotlinByteArray {
        // CryptoKit's Ed25519 signatures are randomized (Apple hardens the
        // nonce), so unlike Tink the exact signature bytes differ per call.
        // They still verify everywhere (RFC 8032 verification is unchanged),
        // which is what the cross-platform vectors assert.
        try! key(privateKey).signature(for: message.data).kotlinByteArray
    }

    func verify(publicKey: KotlinByteArray, message: KotlinByteArray, signature: KotlinByteArray) -> Bool {
        guard let key = try? Curve25519.Signing.PublicKey(rawRepresentation: publicKey.data) else {
            return false
        }
        return key.isValidSignature(signature.data, for: message.data)
    }

    /// A 32-byte seed always round-trips into a CryptoKit key; anything else
    /// is a bug upstream in the core.
    private func key(_ privateKey: KotlinByteArray) -> Curve25519.Signing.PrivateKey {
        try! Curve25519.Signing.PrivateKey(rawRepresentation: privateKey.data)
    }

    // MARK: AES-256-GCM (export bundle; must interoperate with javax.crypto)

    func aesGcmSeal(key: KotlinByteArray, nonce: KotlinByteArray, plaintext: KotlinByteArray) -> KotlinByteArray {
        let sealed = try! AES.GCM.seal(
            plaintext.data,
            using: SymmetricKey(data: key.data),
            nonce: AES.GCM.Nonce(data: nonce.data)
        )
        // core layout = ciphertext ++ 16-byte tag (javax.crypto's doFinal shape)
        return (sealed.ciphertext + sealed.tag).kotlinByteArray
    }

    func aesGcmOpen(key: KotlinByteArray, nonce: KotlinByteArray, ciphertext: KotlinByteArray) -> KotlinByteArray? {
        let bytes = ciphertext.data
        guard bytes.count >= 16 else { return nil }
        let ct = bytes.prefix(bytes.count - 16)
        let tag = bytes.suffix(16)
        guard let box = try? AES.GCM.SealedBox(
            nonce: AES.GCM.Nonce(data: nonce.data),
            ciphertext: ct,
            tag: tag
        ), let plain = try? AES.GCM.open(box, using: SymmetricKey(data: key.data)) else {
            return nil
        }
        return plain.kotlinByteArray
    }
}
