//
//  DatabaseTests.swift
//  AssetCoreDatabaseTests
//
//  Created for Nordic Asset Suite.
//  Strict Concurrency: Complete. SwiftData In-Memory & Schema Integrity Tests.
//

import XCTest
import SwiftData
@testable import AssetCoreDatabase

final class DatabaseTests: XCTestCase {
    
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
    
    // MARK: - Test 1: Appliance Entity Ingestion & Append-Only Health Scores
    func testApplianceIngestionAndHealthAuditTrail() async throws {
        let applianceId = try await worker.createAndInsertAppliance(
            brand: "Miele",
            modelName: "W1 TwinDos Washing Machine",
            serialNumber: "MIELE-CH-889912",
            roomLocation: "Laundry Room",
            purchaseDate: Date(),
            purchasePrice: 2450.00,
            currencyCode: "CHF"
        )
        
        // Record 1st health score
        try await worker.recordApplianceHealthScore(
            applianceID: applianceId,
            score: 98,
            degradationRate: 1.2,
            remainingMonths: 118,
            flags: "NOMINAL"
        )
        
        // Record 2nd health score after simulated usage (append-only)
        try await worker.recordApplianceHealthScore(
            applianceID: applianceId,
            score: 91,
            degradationRate: 2.8,
            remainingMonths: 104,
            flags: "FILTER_SCALE_DETECTED"
        )
        
        let appliances = try await worker.fetchAppliances()
        XCTAssertEqual(appliances.count, 1)
        
        let dto = try XCTUnwrap(appliances.first)
        XCTAssertEqual(dto.brand, "Miele")
        XCTAssertEqual(dto.currencyCode, "CHF")
        XCTAssertEqual(dto.latestHealthScore, 91)
    }
    
    // MARK: - Test 2: Ski Gear Quiver & ISO 11088 DIN Audit
    func testSkiGearIngestionAndDINRecord() async throws {
        let skiId = try await worker.createAndInsertSkiGear(
            brand: "Stöckli",
            modelName: "Laser SL",
            serialNumber: "STK-2026-9901",
            gearCategory: "Slalom Alpine",
            skiLengthCm: 165.0,
            bootSoleLengthMm: 305
        )
        
        // Calculate DIN for moderate skier (Type II)
        try await worker.recordDINSetting(
            gearID: skiId,
            din: 6.5,
            toe: 6.5,
            heel: 6.5,
            weight: 74.0,
            height: 178.0,
            age: 32,
            skierType: "TypeII",
            bsl: 305
        )
        
        let quiver = try await worker.fetchSkiGear()
        XCTAssertEqual(quiver.count, 1)
        
        let dto = try XCTUnwrap(quiver.first)
        XCTAssertEqual(dto.brand, "Stöckli")
        XCTAssertEqual(dto.latestDIN, 6.5)
        XCTAssertFalse(dto.isArchivedForSummer)
    }
    
    // MARK: - Test 3: E-Bike Digital Twin & Battery Telemetry
    func testEBikeTelemetryIngestion() async throws {
        let ebikeId = try await worker.createAndInsertEBike(
            brand: "Scott",
            modelName: "Patron eRIDE 900",
            frameNumber: "SCOTT-CH-FRAME-7788",
            motorSystem: "Bosch Performance Line CX",
            totalOdometerKm: 1450.5
        )
        
        try await worker.recordBatteryHealth(
            ebikeID: ebikeId,
            healthPct: 97.5,
            capacityWh: 750.0,
            cycles: 42,
            cellDiffMv: 12.0,
            tempC: 22.5
        )
        
        let garage = try await worker.fetchEBikes()
        XCTAssertEqual(garage.count, 1)
        
        let dto = try XCTUnwrap(garage.first)
        XCTAssertEqual(dto.brand, "Scott")
        XCTAssertEqual(dto.totalOdometerKm, 1450.5)
        XCTAssertEqual(dto.latestBatteryHealthPercentage, 97.5)
    }
    
    // MARK: - Test 4: Coffee Machine Companion & Descaling Journal
    func testCoffeeMachineJournalAndMaintenance() async throws {
        let coffeeId = try await worker.createAndInsertCoffeeMachine(
            brand: "Jura",
            modelName: "Z10 Diamond Black",
            machineType: "Superautomatic",
            totalShotsPulled: 1250
        )
        
        try await worker.recordDescalingCycle(
            machineID: coffeeId,
            chemical: "Jura 2-Phase Descaling Tablets",
            waterLiters: 48.0,
            daysUntilNext: 45,
            notes: "Complete descaling cycle completed with Claris Smart filter exchange."
        )
        
        let coffeeMachines = try await worker.fetchCoffeeMachines()
        XCTAssertEqual(coffeeMachines.count, 1)
        
        let dto = try XCTUnwrap(coffeeMachines.first)
        XCTAssertEqual(dto.brand, "Jura")
        XCTAssertEqual(dto.totalShotsPulled, 1250)
        XCTAssertEqual(dto.daysSinceLastDescale, 0)
    }
}
