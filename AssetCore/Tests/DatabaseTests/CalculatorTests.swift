//
//  CalculatorTests.swift
//  AssetCoreDatabaseTests
//
//  Created for Nordic Asset Suite.
//  Strict Concurrency: Complete. Unit tests for Domain Calculators.
//

import XCTest
@testable import AssetCoreDatabase

final class CalculatorTests: XCTestCase {
    
    // MARK: - Test 1: ISO 11088 DIN Skier Release Torque Calculations
    func testISO11088DINCalculation() {
        // Adult Male: 74 kg, 178 cm, 32 yrs old, 305mm boot sole length, Type II skier
        let result = DINCalculator.shared.calculateDIN(
            weightKg: 74.0,
            heightCm: 178.0,
            age: 32,
            skierType: .typeII,
            bootSoleLengthMm: 305
        )
        
        // Weight row H (67-78 kg) / Height J -> smaller is H. Type II adds 1 row -> row I -> 4.0 DIN at 305mm.
        XCTAssertEqual(result.dinValue, 4.0, accuracy: 0.01)
        XCTAssertEqual(result.skierCode, "I")
        XCTAssertTrue(result.disclaimerRequired)
        XCTAssertFalse(DINCalculator.legalSafetyDisclaimer.isEmpty)
    }
    
    // MARK: - Test 2: ISO 11088 Age Modification (> 50 yrs old)
    func testISO11088AgeAdjustment() {
        // Senior Skier (62 yrs old): should reduce skier code by 1 row
        let result = DINCalculator.shared.calculateDIN(
            weightKg: 74.0,
            heightCm: 178.0,
            age: 62,
            skierType: .typeII,
            bootSoleLengthMm: 305
        )
        
        // Base H (Type I) + 1 (Type II) - 1 (Age > 50) -> row H -> 3.0 DIN at 305mm.
        XCTAssertEqual(result.dinValue, 3.0, accuracy: 0.01)
        XCTAssertEqual(result.skierCode, "H")
    }
    
    // MARK: - Test 3: E-Bike Chain Wear & Suspension PSI
    func testEBikeTelemetryCalculations() {
        // Chain elongation at 0.76% (Critical Threshold: 0.75%)
        let statusCritical = EBikeTelemetryCalculator.shared.evaluateChainWear(elongationPercentage: 0.76)
        XCTAssertEqual(statusCritical, .replaceRequired)
        
        let statusGood = EBikeTelemetryCalculator.shared.evaluateChainWear(elongationPercentage: 0.45)
        XCTAssertEqual(statusGood, .optimal)
        
        // Suspension PSI for 80 kg rider
        let suspension = EBikeTelemetryCalculator.shared.calculateSuspensionPSI(
            riderWeightWithGearKg: 80.0,
            forkTravelMm: 160.0,
            isEnduroAggressive: false
        )
        XCTAssertEqual(suspension.recommendedForkPSI, 90.0, accuracy: 2.0)
        XCTAssertEqual(suspension.recommendedRearShockPSI, 185.0, accuracy: 5.0)
    }
    
    // MARK: - Test 4: Coffee Water Chemistry & Dynamic Descaling Allowance
    func testWaterHardnessAndDescalingCalculations() {
        let (fH, _, category) = CoffeeChemistryCalculator.shared.convertHardness(germanDegreesDH: 14.0)
        
        XCTAssertEqual(fH, 24.92, accuracy: 0.01)
        XCTAssertEqual(category, .hard)
        
        // Descaling liters for hard water without filter cartridge (14 °dH -> factor 1.4 -> 50 / 1.4 ≈ 35.7 L)
        let allowedLiters = CoffeeChemistryCalculator.shared.calculateLitersUntilDescale(
            germanDegreesDH: 14.0,
            isFilterCartridgeActive: false
        )
        XCTAssertEqual(allowedLiters, 35.7, accuracy: 0.2)
    }
}
