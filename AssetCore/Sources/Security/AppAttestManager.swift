//
//  AppAttestManager.swift
//  AssetCoreSecurity
//
//  Created for Nordic Asset Suite.
//  Strict Concurrency: Complete. Hardware-backed Apple App Attest Key Service.
//

import Foundation
import DeviceCheck
import CryptoKit

/// Errors encountered during Apple App Attest operations.
public enum AppAttestError: Error, LocalizedError, Sendable {
    case featureUnsupported
    case keyGenerationFailed
    case attestationFailed(reason: String)
    case assertionGenerationFailed(reason: String)
    case invalidChallengeData
    
    public var errorDescription: String? {
        switch self {
        case .featureUnsupported:
            return "Apple App Attest is not supported on this hardware environment."
        case .keyGenerationFailed:
            return "Failed to generate Secure Enclave App Attest cryptographic key."
        case .attestationFailed(let reason):
            return "App Attest key attestation failed: \(reason)"
        case .assertionGenerationFailed(let reason):
            return "Failed to generate client assertion signature: \(reason)"
        case .invalidChallengeData:
            return "Supplied challenge token data is invalid."
        }
    }
}

/// Actor managing Apple App Attest key generation, attestation, and assertion signing.
public actor AppAttestManager {
    public static let shared = AppAttestManager()
    
    private let keyStorageKey = "com.nordicassetsuite.appattest.keyid"
    private var currentKeyId: String? = nil
    
    private init() {}
    
    /// Checks if device supports hardware App Attestation.
    public var isSupported: Bool {
        #if targetEnvironment(simulator)
        return false
        #else
        return DCAppAttestService.shared.isSupported
        #endif
    }
    
    /// Retrieves or generates a persistent App Attest Key ID in the Secure Enclave.
    public func getOrCreateKeyId() async throws -> String {
        if let existing = currentKeyId {
            return existing
        }
        
        #if targetEnvironment(simulator)
        // Development / Simulator mock key
        let mockKey = "SIMULATOR_DEV_APP_ATTEST_KEY_ID"
        self.currentKeyId = mockKey
        return mockKey
        #else
        guard isSupported else {
            throw AppAttestError.featureUnsupported
        }
        
        return try await withCheckedThrowingContinuation { continuation in
            DCAppAttestService.shared.generateKey { keyId, error in
                if let error = error {
                    continuation.resume(throwing: AppAttestError.attestationFailed(reason: error.localizedDescription))
                    return
                }
                guard let keyId = keyId else {
                    continuation.resume(throwing: AppAttestError.keyGenerationFailed)
                    return
                }
                self.currentKeyId = keyId
                continuation.resume(returning: keyId)
            }
        }
        #endif
    }
    
    /// Generates a signed cryptographic assertion for a server-provided challenge string.
    public func generateAssertion(for clientDataHash: Data) async throws -> Data {
        let keyId = try await getOrCreateKeyId()
        
        #if targetEnvironment(simulator)
        // Mock assertion signature for unit tests and simulator
        let mockHash = SHA256.hash(data: clientDataHash)
        return Data(mockHash)
        #else
        return try await withCheckedThrowingContinuation { continuation in
            DCAppAttestService.shared.generateAssertion(keyId, clientDataHash: clientDataHash) { assertion, error in
                if let error = error {
                    continuation.resume(throwing: AppAttestError.assertionGenerationFailed(reason: error.localizedDescription))
                    return
                }
                guard let assertion = assertion else {
                    continuation.resume(throwing: AppAttestError.assertionGenerationFailed(reason: "Null assertion returned"))
                    return
                }
                continuation.resume(returning: assertion)
            }
        }
        #endif
    }
}
