//
//  SecurityService.swift
//  AssetCoreSecurity
//
//  Created for Nordic Asset Suite.
//  Strict Concurrency: Complete. GDPR & Swiss FADP Compliant.
//

import Foundation
import CryptoKit
import Security

/// Errors encountered within the Security and Cryptographic subsystem.
public enum SecurityError: Error, LocalizedError, Sendable {
    case keychainItemNotFound(key: String)
    case keychainSaveFailed(status: OSStatus)
    case keychainDeleteFailed(status: OSStatus)
    case encryptionFailed
    case decryptionFailed
    case attestationFailed(reason: String)
    case invalidKeyFormat
    
    public var errorDescription: String? {
        switch self {
        case .keychainItemNotFound(let key):
            return "Item with key '\(key)' was not found in the secure Keychain."
        case .keychainSaveFailed(let status):
            return "Failed to save secure item to Keychain with OSStatus: \(status)."
        case .keychainDeleteFailed(let status):
            return "Failed to delete secure item from Keychain with OSStatus: \(status)."
        case .encryptionFailed:
            return "Cryptographic encryption operation failed."
        case .decryptionFailed:
            return "Cryptographic decryption operation failed. Ciphertext may be corrupted or key mismatch."
        case .attestationFailed(let reason):
            return "Apple App Attest verification failed: \(reason)"
        case .invalidKeyFormat:
            return "Provided key data format is invalid."
        }
    }
}

/// Thread-safe security and cryptographic provider.
public final class SecurityService: Sendable {
    public static let shared = SecurityService()
    
    private init() {}
    
    /// Derives a symmetric encryption key from a master secret.
    public func deriveSymmetricKey(from secretData: Data, salt: Data) -> SymmetricKey {
        return HKDF<SHA256>.deriveKey(
            inputKeyMaterial: SymmetricKey(data: secretData),
            salt: salt,
            outputByteCount: 32
        )
    }
    
    /// Encrypts sensitive payload using AES-GCM (256-bit).
    public func encrypt(data: Data, using key: SymmetricKey) throws -> Data {
        do {
            let sealedBox = try AES.GCM.seal(data, using: key)
            guard let combined = sealedBox.combined else {
                throw SecurityError.encryptionFailed
            }
            return combined
        } catch {
            throw SecurityError.encryptionFailed
        }
    }
    
    /// Decrypts AES-GCM ciphertext.
    public func decrypt(combinedData: Data, using key: SymmetricKey) throws -> Data {
        do {
            let sealedBox = try AES.GCM.SealedBox(combined: combinedData)
            return try AES.GCM.open(sealedBox, using: key)
        } catch {
            throw SecurityError.decryptionFailed
        }
    }
}
