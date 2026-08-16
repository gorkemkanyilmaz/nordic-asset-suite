//
//  SubscriptionManager.swift
//  AssetCoreSubscription
//
//  Created for Nordic Asset Suite.
//  Strict Concurrency: Complete. StoreKit 2 Native Engine.
//

import Foundation
import StoreKit

/// Actor-isolated StoreKit 2 subscription, entitlement, and quota manager.
public actor SubscriptionManager {
    public static let shared = SubscriptionManager()
    
    private var transactionListenerTask: Task<Void, Never>?
    private var cachedEntitlement: UserEntitlementSnapshot = UserEntitlementSnapshot(level: .free)
    
    public init() {
        self.transactionListenerTask = Task.detached {
            for await result in Transaction.updates {
                do {
                    let transaction: Transaction
                    switch result {
                    case .unverified(_, let error):
                        throw error
                    case .verified(let safe):
                        transaction = safe
                    }
                    await SubscriptionManager.shared.updateEntitlementsFromTransaction(transaction)
                    await transaction.finish()
                } catch {
                    // Verification failure or revoked transaction
                }
            }
        }
    }
    
    deinit {
        transactionListenerTask?.cancel()
    }
    
    /// Verifies JWS cryptographic signature from Apple StoreKit.
    public nonisolated func checkVerified<T>(_ result: VerificationResult<T>) throws -> T {
        switch result {
        case .unverified(_, let error):
            throw error
        case .verified(let safe):
            return safe
        }
    }
    
    /// Checks current entitlements against StoreKit 2 active subscriptions.
    public func refreshEntitlements(for currentAppProductPrefix: String = "com.nordicassetsuite") async -> UserEntitlementSnapshot {
        var highestLevel: EntitlementLevel = .free
        var latestExpiration: Date? = nil
        var isTrialActive = false
        
        for await result in Transaction.currentEntitlements {
            guard let transaction = try? checkVerified(result) else { continue }
            
            let productID = transaction.productID
            
            // Check if user owns the Universal Suite Pass
            if productID == SubscriptionProductIdentifier.nordicSuitePassAnnual.rawValue {
                highestLevel = .suitePro
                latestExpiration = transaction.expirationDate
                isTrialActive = (transaction.offerType == .introductory)
                break
            }
            
            // Check if user owns the Pro tier for this specific app
            if productID.hasPrefix(currentAppProductPrefix) {
                highestLevel = .pro
                latestExpiration = transaction.expirationDate
                isTrialActive = (transaction.offerType == .introductory)
            }
        }
        
        cachedEntitlement = UserEntitlementSnapshot(
            level: highestLevel,
            expirationDate: latestExpiration,
            isTrial: isTrialActive,
            totalAssetsCount: cachedEntitlement.totalAssetsCount,
            totalOCRScansUsed: cachedEntitlement.totalOCRScansUsed
        )
        
        return cachedEntitlement
    }
    
    /// Returns the cached entitlement snapshot for zero-latency UI checks.
    public func getCachedEntitlements() -> UserEntitlementSnapshot {
        return cachedEntitlement
    }
    
    /// Checks if adding a new asset is permitted under current entitlement quotas.
    public func canCreateNewAsset(currentCount: Int) -> Bool {
        if cachedEntitlement.level == .pro || cachedEntitlement.level == .suitePro {
            return true
        }
        return currentCount < FreeTierLimits.maxAssets
    }
    
    /// Checks if performing an OCR scan is permitted under current entitlement quotas.
    public func canPerformOCRScan(currentScansUsed: Int) -> Bool {
        if cachedEntitlement.level == .pro || cachedEntitlement.level == .suitePro {
            return true
        }
        return currentScansUsed < FreeTierLimits.maxOCRScansTotal
    }
    
    /// Manually sets mock entitlement level for unit tests and UI previews.
    public func setMockEntitlement(level: EntitlementLevel, assetCount: Int = 0, ocrScansUsed: Int = 0) {
        cachedEntitlement = UserEntitlementSnapshot(
            level: level,
            expirationDate: level == .free ? nil : Date().addingTimeInterval(86400 * 365),
            isTrial: false,
            totalAssetsCount: assetCount,
            totalOCRScansUsed: ocrScansUsed
        )
    }
    
    /// Updates local asset and scan counters.
    public func updateUsage(assetCount: Int, ocrScansUsed: Int) {
        cachedEntitlement = UserEntitlementSnapshot(
            level: cachedEntitlement.level,
            expirationDate: cachedEntitlement.expirationDate,
            isTrial: cachedEntitlement.isTrial,
            totalAssetsCount: assetCount,
            totalOCRScansUsed: ocrScansUsed
        )
    }
    
    private func updateEntitlementsFromTransaction(_ transaction: Transaction) {
        let isSuite = transaction.productID == SubscriptionProductIdentifier.nordicSuitePassAnnual.rawValue
        let level: EntitlementLevel = isSuite ? .suitePro : .pro
        
        cachedEntitlement = UserEntitlementSnapshot(
            level: level,
            expirationDate: transaction.expirationDate,
            isTrial: transaction.offerType == .introductory,
            totalAssetsCount: cachedEntitlement.totalAssetsCount,
            totalOCRScansUsed: cachedEntitlement.totalOCRScansUsed
        )
    }
}
