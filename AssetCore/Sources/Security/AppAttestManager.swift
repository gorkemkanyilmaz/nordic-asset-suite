//
//  AppAttestManager.swift
//  AssetCoreSecurity
//
//  Created for Nordic Asset Suite.
//  Strict Concurrency: Complete. Hardware Key Generation & Assertion.
//

import Foundation
import DeviceCheck
import CryptoKit

/// Errors encountered during App Attest token generation and validation.
public enum AppAttestError: Error, LocalizedError, Sendable {
    case featureUnsupported
    case keyGenerationFailed
    case attestationFailed
    case assertionFailed
    case invalidChallenge
    
    public var errorDescription: String? {
        switch self {
        case .featureUnsupported:
            return "DCAppAttestService is not supported on this device architecture."
        case .keyGenerationFailed:
            return "Failed to generate Secure Enclave hardware key pair."
        case .attestationFailed:
            return "Apple App Attest certificate validation failed."
        case .assertionFailed:
            return "Failed to generate assertion signature for client request."
        case .invalidChallenge:
            return "Server challenge nonce is invalid or expired."
        }
    }
}

/// Actor managing Apple App Attest key generation, attestation, and assertion signing.
public actor AppAttestManager {
    public static let shared = AppAttestManager()
    
    private let service = DCAppAttestService.shared
    private var cachedKeyId: String? = nil
    
    private init() {}
    
    /// Checks if App Attest hardware service is available on current runtime.
    public func isHardwareAttestationAvailable() -> Bool {
        #if targetEnvironment(simulator) || os(macOS)
        return false
        #else
        return service.isSupported
        #endif
    }
    
    /// Retrieves existing hardware key ID or generates a new key in the Secure Enclave.
    public func getOrCreateKeyId() async throws -> String {
        if let existing = cachedKeyId {
            return existing
        }
        
        guard isHardwareAttestationAvailable() else {
            throw AppAttestError.featureUnsupported
        }
        
        do {
            let keyId = try await service.generateKey()
            self.cachedKeyId = keyId
            return keyId
        } catch {
            throw AppAttestError.keyGenerationFailed
        }
    }
    
    /// Generates an assertion signature for a request payload hash using the hardware key.
    public func generateAssertion(for challengeData: Data) async throws -> Data {
        let keyId = try await getOrCreateKeyId()
        let clientDataHash = Data(SHA256.hash(data: challengeData))
        
        do {
            return try await service.generateAssertion(keyId, clientDataHash: clientDataHash)
        } catch {
            throw AppAttestError.assertionFailed
        }
    }
}
