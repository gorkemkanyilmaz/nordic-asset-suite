//
//  DatabaseTests.swift
//  AssetCoreDatabaseTests
//
//  Created for Nordic Asset Suite.
//  Strict Concurrency: Complete. XCTest Suite for SwiftData & DatabaseWorker.
//

import XCTest
import SwiftData
@testable import AssetCoreDatabase

final class DatabaseTests: XCTestCase {
    
    var container: ModelContainer!
    var worker: DatabaseWorker!
    
    override func setUp() async throws {
        try await super.setUp()
        // Instantiate isolated in-memory container for each test
        container = try DatabaseContainer.shared.makeInMemoryContainer()
        worker = DatabaseWorker(modelContainer: container)
    }
    
    override func tearDown() async throws {
        worker = nil
        container = nil
        try await super.tearDown()
    }
    
    // MARK: - Test 1: Appliance & Health Score Append-Only Log
    func testApplianceCreationAndAppendOnlyHealthScore() async throws {
        let appliance = ApplianceEntity(
            brand: "Miele",
            modelName: "W1 Washing Machine",
            serialNumber: "SN-981244",
            roomLocation: "Laundry Room",
            purchasePrice: 1850.00,
            currencyCode: "CHF"
        )
        
        try await worker.insertAppliance(appliance)
        
        // Record 1st health score
        try await worker.recordApplianceHealthScore(
            applianceID: appliance.id,
            score: 98,
            degradationRate: 1.2,
            remainingMonths: 140,
            flags: "NORMAL_OPERATION"
        )
        
        // Record 2nd health score (degradation simulation)
        try await worker.recordApplianceHealthScore(
            applianceID: appliance.id,
            score: 91,
            degradationRate: 2.5,
            remainingMonths: 120,
            flags: "FILTER_REPLACEMENT_RECOMMENDED"
        )
        
        let fetchedAppliances = try await worker.fetchAppliances()
        XCTAssertEqual(fetchedAppliances.count, 1)
        XCTAssertEqual(fetchedAppliances.first?.brand, "Miele")
        XCTAssertEqual(fetchedAppliances.first?.latestHealthScore, 91)
    }
    
    // MARK: - Test 2: Ski Gear & DIN Binding Audit Trail
    func testSkiGearCreationAndDINCalculationLog() async throws {
        let ski = SkiGearEntity(
            brand: "Stöckli",
            modelName: "Laser SL",
            serialNumber: "STK-2026-789",
            gearCategory: "Alpine Skis",
            skiLengthCm: 165.0,
            bootSoleLengthMm: 310
        )
        
        try await worker.insertSkiGear(ski)
        
        // Calculate DIN for moderate skier (Type II)
        try await worker.recordDINSetting(
            gearID: ski.id,
            din: 6.5,
            toe: 6.5,
            heel: 6.5,
            weight: 76.0,
            height: 182.0,
            age: 34,
            skierType: "Type II",
            bsl: 310
        )
        
        // Recalculate for aggressive season upgrade (Type III)
        try await worker.recordDINSetting(
            gearID: ski.id,
            din: 8.0,
            toe: 8.0,
            heel: 8.0,
            weight: 76.0,
            height: 182.0,
            age: 34,
            skierType: "Type III",
            bsl: 310
        )
        
        let fetchedSkis = try await worker.fetchSkiGear()
        XCTAssertEqual(fetchedSkis.count, 1)
        XCTAssertEqual(fetchedSkis.first?.brand, "Stöckli")
        XCTAssertEqual(fetchedSkis.first?.latestDIN, 8.0)
    }
    
    // MARK: - Test 3: E-Bike & Battery Telemetry Append-Only
    func testEBikeCreationAndBatteryHealthLog() async throws {
        let ebike = EBikeEntity(
            brand: "Scott",
            modelName: "Patron eRIDE 900",
            frameNumber: "SCOTT-PATRON-2026",
            motorSystem: "Bosch Performance Line CX",
            totalOdometerKm: 1450.0
        )
        
        try await worker.insertEBike(ebike)
        
        try await worker.recordBatteryHealth(
            ebikeID: ebike.id,
            healthPct: 97.5,
            capacityWh: 750.0,
            cycles: 34,
            cellDiffMv: 4.2,
            tempC: 21.0
        )
        
        let fetchedBikes = try await worker.fetchEBikes()
        XCTAssertEqual(fetchedBikes.count, 1)
        XCTAssertEqual(fetchedBikes.first?.brand, "Scott")
        XCTAssertEqual(fetchedBikes.first?.latestBatteryHealthPercentage, 97.5)
    }
    
    // MARK: - Test 4: Coffee Machine & Descaling Cycle Log
    func testCoffeeMachineCreationAndDescalingLog() async throws {
        let coffee = CoffeeMachineEntity(
            brand: "Jura",
            modelName: "E8 Piano Black",
            serialNumber: "JURA-E8-9081",
            machineType: "Superautomatic",
            totalShotsPulled: 420
        )
        
        try await worker.insertCoffeeMachine(coffee)
        
        try await worker.recordDescalingCycle(
            machineID: coffee.id,
            chemical: "Jura 2-Phase Descaling Tablets",
            waterLiters: 48.0,
            daysUntilNext: 60,
            notes: "Claris Smart filter replaced simultaneously."
        )
        
        let fetchedMachines = try await worker.fetchCoffeeMachines()
        XCTAssertEqual(fetchedMachines.count, 1)
        XCTAssertEqual(fetchedMachines.first?.brand, "Jura")
        XCTAssertEqual(fetchedMachines.first?.totalShotsPulled, 420)
    }
}
