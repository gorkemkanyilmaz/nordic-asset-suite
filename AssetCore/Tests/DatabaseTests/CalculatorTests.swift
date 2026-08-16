//
//  CalculatorTests.swift
//  AssetCoreDatabaseTests
//
//  Created for Nordic Asset Suite.
//  Strict Concurrency: Complete. Unit Tests for ISO 11088 DIN, Chain Wear, Water Hardness & Appliance Health.
//

import XCTest
@testable import AssetCoreDatabase

final class CalculatorTests: XCTestCase {
    
    // MARK: - Test 1: ISO 11088 Ski Binding DIN Calculation
    func testISO11088DINCalculation() {
        // Adult male: 75kg, 180cm, 30 years old, Type II (Moderate), Boot Sole Length 305mm
        let result = DINCalculator.shared.calculateDIN(
            weightKg: 75.0,
            heightCm: 180.0,
            age: 30,
            skierType: .typeII,
            bootSoleLengthMm: 305
        )
        
        // Weight 75kg -> Code H (7). Type II -> Code I (8). BSL 305 -> Bracket 3. Matrix[8][3] = 6.00
        XCTAssertEqual(result.dinValue, 6.0, "DIN value for 75kg Type II skier with 305mm BSL should be 6.0")
        XCTAssertTrue(result.disclaimerRequired, "Mandatory safety liability disclaimer must be enforced.")
        XCTAssertTrue(DINCalculator.legalSafetyDisclaimer.contains("certified ski technician"))
    }
    
    // MARK: - Test 2: E-Bike Chain Wear Elongation (0.75% Critical Threshold)
    func testChainWearThresholdEvaluation() {
        let optimal = EBikeTelemetryCalculator.shared.evaluateChainWear(elongationPercentage: 0.35)
        XCTAssertEqual(optimal, .optimal)
        
        let moderate = EBikeTelemetryCalculator.shared.evaluateChainWear(elongationPercentage: 0.60)
        XCTAssertEqual(moderate, .normalWear)
        
        let replace = EBikeTelemetryCalculator.shared.evaluateChainWear(elongationPercentage: 0.78)
        XCTAssertEqual(replace, .replaceRequired, "Chain elongation >= 0.75% must trigger immediate replacement warning.")
    }
    
    // MARK: - Test 3: E-Bike Suspension PSI Calculation
    func testSuspensionPSICalculation() {
        let recommendation = EBikeTelemetryCalculator.shared.calculateSuspensionPSI(riderWeightWithGearKg: 80.0)
        
        XCTAssertGreaterThan(recommendation.recommendedForkPSI, 80.0)
        XCTAssertGreaterThan(recommendation.recommendedRearShockPSI, 150.0)
        XCTAssertEqual(recommendation.targetSagMm, 40.0) // 160mm * 25% sag = 40mm
    }
    
    // MARK: - Test 4: Coffee Water Chemistry & Dynamic Descaling Allowance
    func testWaterHardnessAndDescalingCalculations() {
        let (fH, ppm, category) = CoffeeChemistryCalculator.shared.convertHardness(germanDegreesDH: 14.0)
        
        XCTAssertEqual(fH, 24.92, accuracy: 0.01)
        XCTAssertEqual(category, .hard)
        
        // At 14 °dH with active filter (effective 5.6 °dH), allowed liters before descale
        let allowedLitersWithFilter = CoffeeChemistryCalculator.shared.calculateLitersUntilDescale(
            germanDegreesDH: 14.0,
            isFilterCartridgeActive: true
        )
        let allowedLitersWithoutFilter = CoffeeChemistryCalculator.shared.calculateLitersUntilDescale(
            germanDegreesDH: 14.0,
            isFilterCartridgeActive: false
        )
        
        XCTAssertGreaterThan(allowedLitersWithFilter, allowedLitersWithoutFilter, "Active water filter must extend liters throughput before mandatory descaling.")
    }
    
    // MARK: - Test 5: Appliance Health Score Degradation
    func testApplianceHealthScoreCalculation() {
        let newAppliance = ApplianceHealthCalculator.shared.calculateHealth(ageMonths: 12)
        XCTAssertGreaterThanOrEqual(newAppliance.healthScore, 95)
        
        let degradedAppliance = ApplianceHealthCalculator.shared.calculateHealth(
            ageMonths: 72, // 6 years
            overdueFilterDays: 45,
            unresolvedErrorCodesCount: 1
        )
        
        XCTAssertLessThan(degradedAppliance.healthScore, 75)
        XCTAssertEqual(degradedAppliance.remainingLifespanMonths, 72)
    }
}
