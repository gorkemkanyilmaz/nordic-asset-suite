//
//  SecurityTests.swift
//  AssetCoreSecurityTests
//
//  Created for Nordic Asset Suite.
//  Strict Concurrency: Complete. XCTest Suite for AES-GCM, Keychain, & PII Redactor.
//

import XCTest
import CryptoKit
@testable import AssetCoreSecurity

final class SecurityTests: XCTestCase {
    
    // MARK: - Test 1: AES-GCM 256-bit Encryption & Decryption
    func testAESGCMEncryptionAndDecryption() throws {
        let masterSecret = "NORDIC_ASSET_SUITE_MASTER_KEY_2026".data(using: .utf8)!
        let salt = "CH_SWISS_SECURE_SALT".data(using: .utf8)!
        
        let symmetricKey = SecurityService.shared.deriveSymmetricKey(from: masterSecret, salt: salt)
        
        let originalPayload = "Sensitive Appliance Serial: VZUG-998812-CH".data(using: .utf8)!
        
        let encryptedData = try SecurityService.shared.encrypt(data: originalPayload, using: symmetricKey)
        XCTAssertNotEqual(encryptedData, originalPayload, "Ciphertext must not match plaintext.")
        
        let decryptedData = try SecurityService.shared.decrypt(combinedData: encryptedData, using: symmetricKey)
        XCTAssertEqual(decryptedData, originalPayload, "Decrypted data must match original plaintext.")
    }
    
    // MARK: - Test 2: Tampered Ciphertext Decryption Failure
    func testTamperedCiphertextThrowsError() {
        let masterSecret = "KEY_MATERIAL".data(using: .utf8)!
        let salt = "SALT".data(using: .utf8)!
        let key = SecurityService.shared.deriveSymmetricKey(from: masterSecret, salt: salt)
        
        let validPayload = "Plaintext".data(using: .utf8)!
        guard var encryptedData = try? SecurityService.shared.encrypt(data: validPayload, using: key) else {
            XCTFail("Encryption should succeed")
            return
        }
        
        // Tamper with the last byte of the ciphertext tag
        encryptedData[encryptedData.count - 1] ^= 0xFF
        
        XCTAssertThrowsError(try SecurityService.shared.decrypt(combinedData: encryptedData, using: key)) { error in
            XCTAssertTrue(error is SecurityError)
        }
    }
    
    // MARK: - Test 3: Complex Multi-Entity PII Redaction
    func testPIIRedactionMultiEntity() {
        let sensitiveString = """
        Payment confirmation for Hans Meier:
        Card: 5105 1051 0000 0000 (Mastercard)
        Email: hans.meier@swissonline.ch
        Phone: +41 79 123 45 67
        IBAN: CH93 0076 2011 6238 5295 7
        Appliance: Miele W1 Series 9
        """
        
        let redacted = PIIRedactor.shared.redact(text: sensitiveString)
        
        XCTAssertFalse(redacted.contains("5105 1051 0000 0000"))
        XCTAssertFalse(redacted.contains("hans.meier@swissonline.ch"))
        XCTAssertFalse(redacted.contains("+41 79 123 45 67"))
        XCTAssertFalse(redacted.contains("CH93 0076 2011 6238 5295 7"))
        XCTAssertTrue(redacted.contains("Miele W1 Series 9"), "Hardware identifiers must be preserved.")
    }
    
    // MARK: - Test 4: App Attest Hardware Enclave Check
    func testAppAttestKeyGenerationAndAssertion() async throws {
        let isHardwareAvailable = await AppAttestManager.shared.isHardwareAttestationAvailable()
        if !isHardwareAvailable {
            // Simulated / CI environment where Secure Enclave DCAppAttestService is unavailable
            return
        }
        
        let keyId = try await AppAttestManager.shared.getOrCreateKeyId()
        XCTAssertFalse(keyId.isEmpty, "App Attest Key ID must be successfully generated or retrieved.")
        
        let clientChallenge = "SERVER_NONCE_CHALLENGE_2026".data(using: .utf8)!
        let assertion = try await AppAttestManager.shared.generateAssertion(for: clientChallenge)
        XCTAssertFalse(assertion.isEmpty, "Assertion signature must be generated.")
    }
}
