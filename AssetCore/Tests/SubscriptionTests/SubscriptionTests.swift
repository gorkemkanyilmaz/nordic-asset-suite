//
//  SubscriptionTests.swift
//  AssetCoreSubscriptionTests
//
//  Created for Nordic Asset Suite.
//  Strict Concurrency: Complete. XCTest Suite for StoreKit 2 & Quota Management.
//

import XCTest
@testable import AssetCoreSubscription

final class SubscriptionTests: XCTestCase {
    
    var manager: SubscriptionManager!
    
    override func setUp() async throws {
        try await super.setUp()
        manager = SubscriptionManager()
    }
    
    override func tearDown() async throws {
        manager = nil
        try await super.tearDown()
    }
    
    // MARK: - Test 1: Free Tier Quota Limits Enforced
    func testFreeTierQuotaCeilings() async {
        await manager.setMockEntitlement(level: .free, assetCount: 0, ocrScansUsed: 0)
        
        // Asset creation quota
        let canCreateUnderLimit = await manager.canCreateNewAsset(currentCount: 9)
        XCTAssertTrue(canCreateUnderLimit, "Free tier must allow up to 10 assets.")
        
        let canCreateAtLimit = await manager.canCreateNewAsset(currentCount: 10)
        XCTAssertFalse(canCreateAtLimit, "Free tier must block the 11th asset (at limit 10).")
        
        let canCreateOverLimit = await manager.canCreateNewAsset(currentCount: 15)
        XCTAssertFalse(canCreateOverLimit)
        
        // OCR scan quota
        let canScanUnderLimit = await manager.canPerformOCRScan(currentScansUsed: 2)
        XCTAssertTrue(canScanUnderLimit, "Free tier must allow up to 3 OCR scans.")
        
        let canScanAtLimit = await manager.canPerformOCRScan(currentScansUsed: 3)
        XCTAssertFalse(canScanAtLimit, "Free tier must block the 4th OCR scan (at limit 3).")
    }
    
    // MARK: - Test 2: Pro Tier Unlimited Unlocks
    func testProTierUnlimitedCapabilities() async {
        await manager.setMockEntitlement(level: .pro)
        
        let snapshot = await manager.getCachedEntitlements()
        XCTAssertTrue(snapshot.canCreateAsset)
        XCTAssertTrue(snapshot.canPerformOCRScan)
        XCTAssertTrue(snapshot.isCloudSyncEnabled, "CloudKit multi-device sync must be unlocked for Pro tier.")
        XCTAssertTrue(snapshot.isAIAssistantEnabled, "AI diagnostic assistant must be unlocked for Pro tier.")
        XCTAssertTrue(snapshot.isPDFExportEnabled, "PDF warranty export must be unlocked for Pro tier.")
        
        let canAdd100Assets = await manager.canCreateNewAsset(currentCount: 100)
        XCTAssertTrue(canAdd100Assets, "Pro tier must have unlimited assets.")
        
        let canScan50Times = await manager.canPerformOCRScan(currentScansUsed: 50)
        XCTAssertTrue(canScan50Times, "Pro tier must have unlimited OCR scans.")
    }
    
    // MARK: - Test 3: Nordic Suite Pass Entitlement
    func testSuitePassEntitlement() async {
        await manager.setMockEntitlement(level: .suitePro)
        
        let snapshot = await manager.getCachedEntitlements()
        XCTAssertEqual(snapshot.level, .suitePro)
        XCTAssertTrue(snapshot.canCreateAsset)
        XCTAssertTrue(snapshot.isCloudSyncEnabled)
    }
    
    // MARK: - Test 4: Product Identifier Resolution
    func testProductIdentifiers() {
        let allProducts = SubscriptionProductIdentifier.allCases
        XCTAssertEqual(allProducts.count, 9, "Should have 4 apps x 2 tiers (monthly/annual) + 1 Suite Pass = 9 products.")
        
        let suitePass = SubscriptionProductIdentifier.nordicSuitePassAnnual
        XCTAssertTrue(suitePass.isSuiteBundle)
        
        let applianceMonthly = SubscriptionProductIdentifier.applianceProMonthly
        XCTAssertFalse(applianceMonthly.isSuiteBundle)
    }
}
