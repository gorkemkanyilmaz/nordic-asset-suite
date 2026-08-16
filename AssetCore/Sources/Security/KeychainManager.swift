//
//  KeychainManager.swift
//  AssetCoreSecurity
//
//  Created for Nordic Asset Suite.
//  Strict Concurrency: Complete.
//

import Foundation
import Security

/// Thread-safe wrapper for Apple Keychain Services supporting accessibility classes.
public actor KeychainManager {
    public static let shared = KeychainManager()
    
    private let serviceName: String
    private let accessGroup: String?
    
    public init(serviceName: String = "com.nordicassetsuite.keychain", accessGroup: String? = nil) {
        self.serviceName = serviceName
        self.accessGroup = accessGroup
    }
    
    /// Saves or updates data securely in the Keychain.
    public func save(key: String, data: Data, accessibility: CFString = kSecAttrAccessibleAfterFirstUnlockThisDeviceOnly) throws {
        // Delete existing item if present
        let deleteQuery: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: serviceName,
            kSecAttrAccount as String: key
        ]
        SecItemDelete(deleteQuery as CFDictionary)
        
        var query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: serviceName,
            kSecAttrAccount as String: key,
            kSecValueData as String: data,
            kSecAttrAccessible as String: accessibility
        ]
        
        if let accessGroup = accessGroup {
            query[kSecAttrAccessGroup as String] = accessGroup
        }
        
        let status = SecItemAdd(query as CFDictionary, nil)
        guard status == errSecSuccess else {
            throw SecurityError.keychainSaveFailed(status: status)
        }
    }
    
    /// Reads data from the Keychain.
    public func read(key: String) throws -> Data {
        var query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: serviceName,
            kSecAttrAccount as String: key,
            kSecReturnData as String: true,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]
        
        if let accessGroup = accessGroup {
            query[kSecAttrAccessGroup as String] = accessGroup
        }
        
        var dataTypeRef: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &dataTypeRef)
        
        guard status == errSecSuccess, let data = dataTypeRef as? Data else {
            throw SecurityError.keychainItemNotFound(key: key)
        }
        
        return data
    }
    
    /// Deletes a key from the Keychain.
    public func delete(key: String) throws {
        var query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: serviceName,
            kSecAttrAccount as String: key
        ]
        
        if let accessGroup = accessGroup {
            query[kSecAttrAccessGroup as String] = accessGroup
        }
        
        let status = SecItemDelete(query as CFDictionary)
        guard status == errSecSuccess || status == errSecItemNotFound else {
            throw SecurityError.keychainDeleteFailed(status: status)
        }
    }
    
    /// Saves a UTF-8 string securely.
    public func saveString(key: String, value: String) throws {
        guard let data = value.data(using: .utf8) else {
            throw SecurityError.invalidKeyFormat
        }
        try save(key: key, data: data)
    }
    
    /// Reads a UTF-8 string securely.
    public func readString(key: String) throws -> String {
        let data = try read(key: key)
        guard let string = String(data: data, encoding: .utf8) else {
            throw SecurityError.invalidKeyFormat
        }
        return string
    }
}
