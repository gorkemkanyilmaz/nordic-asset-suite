//
//  OfflineResilienceTests.swift
//  AssetCoreDatabaseTests
//
//  Created for Nordic Asset Suite.
//  Strict Concurrency: Complete. Offline Persistence & Graceful AI Degradation Tests.
//

import XCTest
import SwiftData
@testable import AssetCoreDatabase
@testable import AssetCoreOCR
@testable import AssetCoreAI

final class OfflineResilienceTests: XCTestCase {
    
    var container: ModelContainer!
    var worker: DatabaseWorker!
    
    override func setUp() async throws {
        try await super.setUp()
        container = try DatabaseContainer.shared.makeInMemoryContainer()
        worker = DatabaseWorker(modelContainer: container)
    }
    
    override func tearDown() async throws {
        worker = nil
        container = nil
        try await super.tearDown()
    }
    
    // MARK: - Test 1: Full Offline Local Storage Lifecycle
    func testOfflineCRUDOperationsWithoutNetwork() async throws {
        // Create offline appliance safely inside actor
        let applianceId = try await worker.createAndInsertAppliance(
            brand: "Bosch",
            modelName: "Serie 8 Dishwasher",
            serialNumber: "BOSCH-SN-998811",
            roomLocation: "Kitchen",
            purchasePrice: 1290.00,
            currencyCode: "CHF"
        )
        
        // Append offline telemetry
        try await worker.recordApplianceHealthScore(
            applianceID: applianceId,
            score: 95,
            degradationRate: 1.5,
            remainingMonths: 130,
            flags: "OFFLINE_RECORDED"
        )
        
        let fetched = try await worker.fetchAppliances()
        XCTAssertEqual(fetched.count, 1)
        XCTAssertEqual(fetched.first?.brand, "Bosch")
        XCTAssertEqual(fetched.first?.latestHealthScore, 95)
    }
    
    // MARK: - Test 2: Seamless Local OCR Fallback When Cloud AI is Offline
    func testOfflineGracefulDegradationOnAIServerFailure() async {
        // Simulated local scan with medium confidence
        let rawScan = OCRScanResult(
            rawText: """
            Jura Elektroapparate AG
            Type: E8 Piano Black
            Art. Nr.: 15355
            Seriennummer: JURA-2026-88120
            """,
            elements: [],
            averageConfidence: 0.80, // Below 0.85 threshold to trigger fallback attempt
            target: .serialNumberOrBarcode,
            requiresAIFallback: true
        )
        
        // Process scan: Even if proxy network is severed, AIExtractionService must not throw or crash;
        // it must gracefully return the local parser's discovered metadata.
        let response = await AIExtractionService.shared.processDocumentScan(ocrResult: rawScan)
        
        XCTAssertEqual(response.brand, "Jura")
        XCTAssertEqual(response.serialNumber, "JURA-2026-88120")
        XCTAssertEqual(response.providerUsed, .localFallback, "Must gracefully fallback to local extraction when cloud is unreachable.")
    }
}
