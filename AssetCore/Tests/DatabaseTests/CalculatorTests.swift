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
        
        // Weight row J (67-78 kg) -> 6.0 DIN at 305mm. Type II adds 1 row -> row K -> 6.5 DIN.
        XCTAssertEqual(result.calculatedDIN, 6.5, accuracy: 0.01)
        XCTAssertEqual(result.skierCodeRow, "K")
        XCTAssertFalse(result.safetyDisclaimerText.isEmpty)
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
        
        // Base K (Type II) - 1 (Age > 50) -> row J -> 5.5 DIN at 305mm.
        XCTAssertEqual(result.calculatedDIN, 5.5, accuracy: 0.01)
        XCTAssertEqual(result.skierCodeRow, "J")
    }
    
    // MARK: - Test 3: E-Bike Chain Wear & Suspension PSI
    func testEBikeTelemetryCalculations() {
        // Chain elongation at 0.76% (Critical Threshold: 0.75%)
        let statusCritical = EBikeTelemetryCalculator.shared.evaluateChainWear(chainElongationPercentage: 0.76)
        XCTAssertEqual(statusCritical, .criticalReplaceImmediately)
        
        let statusGood = EBikeTelemetryCalculator.shared.evaluateChainWear(chainElongationPercentage: 0.45)
        XCTAssertEqual(statusGood, .optimal)
        
        // Suspension PSI for 80 kg rider
        let suspension = EBikeTelemetryCalculator.shared.calculateSuspensionPSI(riderWeightKg: 80.0, ridingStyle: .enduroTrail)
        XCTAssertEqual(suspension.forkPressurePSI, 80.0, accuracy: 0.5)
        XCTAssertEqual(suspension.rearShockPressurePSI, 160.0, accuracy: 0.5)
    }
    
    // MARK: - Test 4: Coffee Water Chemistry & Dynamic Descaling Allowance
    func testWaterHardnessAndDescalingCalculations() {
        let (fH, _, _) = CoffeeChemistryCalculator.shared.convertHardness(germanDegreesDH: 14.0)
        
        XCTAssertEqual(fH, 24.92, accuracy: 0.01)
        
        // Descaling liters for hard water (14 °dH -> factor 1.4 -> 50 / 1.4 ≈ 35.7 L)
        let allowance = CoffeeChemistryCalculator.shared.calculateLitersUntilDescale(
            germanDegreesDH: 14.0,
            hasWaterFilterInstalled: false
        )
        XCTAssertEqual(allowance.recommendedLitersBeforeDescale, 35.7, accuracy: 0.2)
    }
}
