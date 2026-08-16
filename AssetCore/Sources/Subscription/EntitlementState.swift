//
//  EntitlementState.swift
//  AssetCoreSubscription
//
//  Created for Nordic Asset Suite.
//  Strict Concurrency: Complete. StoreKit 2 Ready.
//

import Foundation

/// Free tier usage limits defined in LES v3.0 Section 17.
public struct FreeTierLimits: Sendable, Codable {
    public static let maxAssets: Int = 10
    public static let maxPhotosPerAsset: Int = 5
    public static let maxOCRScansTotal: Int = 3
}

/// Represents the active subscription status and entitlements of the user.
public enum EntitlementLevel: String, Sendable, Codable {
    case free
    case pro
    case suitePro
}

/// Dynamic snapshot of user entitlements and quota consumption.
public struct UserEntitlementSnapshot: Sendable, Codable {
    public let level: EntitlementLevel
    public let expirationDate: Date?
    public let isTrial: Bool
    public let totalAssetsCount: Int
    public let totalOCRScansUsed: Int
    
    public init(
        level: EntitlementLevel,
        expirationDate: Date? = nil,
        isTrial: Bool = false,
        totalAssetsCount: Int = 0,
        totalOCRScansUsed: Int = 0
    ) {
        self.level = level
        self.expirationDate = expirationDate
        self.isTrial = isTrial
        self.totalAssetsCount = totalAssetsCount
        self.totalOCRScansUsed = totalOCRScansUsed
    }
    
    /// Evaluates whether the user can create an additional asset.
    public var canCreateAsset: Bool {
        switch level {
        case .pro, .suitePro:
            return true
        case .free:
            return totalAssetsCount < FreeTierLimits.maxAssets
        }
    }
    
    /// Evaluates whether the user can perform an OCR scan.
    public var canPerformOCRScan: Bool {
        switch level {
        case .pro, .suitePro:
            return true
        case .free:
            return totalOCRScansUsed < FreeTierLimits.maxOCRScansTotal
        }
    }
    
    /// Evaluates whether CloudKit sync & multi-device backup is unlocked.
    public var isCloudSyncEnabled: Bool {
        return level == .pro || level == .suitePro
    }
    
    /// Evaluates whether AI Diagnostic assistant is unlocked.
    public var isAIAssistantEnabled: Bool {
        return level == .pro || level == .suitePro
    }
    
    /// Evaluates whether PDF Warranty report generation is unlocked.
    public var isPDFExportEnabled: Bool {
        return level == .pro || level == .suitePro
    }
}
