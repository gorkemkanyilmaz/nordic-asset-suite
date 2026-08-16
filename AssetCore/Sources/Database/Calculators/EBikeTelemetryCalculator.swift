//
//  EBikeTelemetryCalculator.swift
//  AssetCoreDatabase
//
//  Created for Nordic Asset Suite.
//  Strict Concurrency: Complete. Drivetrain Wear, Battery Health, & Suspension Sag.
//

import Foundation

/// Chain wear alert status.
public enum ChainWearStatus: String, Sendable {
    case optimal = "Optimal (< 0.5% elongation)"
    case normalWear = "Moderate Wear (0.5% - 0.74%)"
    case replaceRequired = "REPLACE IMMEDIATELY (>= 0.75% elongation)"
}

/// Suspension setup recommendation.
public struct SuspensionSetupRecommendation: Sendable {
    public let recommendedForkPSI: Double
    public let recommendedRearShockPSI: Double
    public let targetSagMm: Double
    public let reboundClicksFromClosed: Int
    
    public init(
        recommendedForkPSI: Double,
        recommendedRearShockPSI: Double,
        targetSagMm: Double,
        reboundClicksFromClosed: Int
    ) {
        self.recommendedForkPSI = recommendedForkPSI
        self.recommendedRearShockPSI = recommendedRearShockPSI
        self.targetSagMm = targetSagMm
        self.reboundClicksFromClosed = reboundClicksFromClosed
    }
}

/// Computes e-bike maintenance tolerances and suspension telemetry.
public final class EBikeTelemetryCalculator: Sendable {
    public static let shared = EBikeTelemetryCalculator()
    
    private init() {}
    
    /// Evaluates chain elongation percentage against the 0.75% threshold.
    public func evaluateChainWear(elongationPercentage: Double) -> ChainWearStatus {
        if elongationPercentage < 0.50 {
            return .optimal
        } else if elongationPercentage < 0.75 {
            return .normalWear
        } else {
            return .replaceRequired
        }
    }
    
    /// Calculates recommended suspension air pressures and rebound damping based on rider weight and style.
    public func calculateSuspensionPSI(
        riderWeightWithGearKg: Double,
        forkTravelMm: Double = 160.0,
        isEnduroAggressive: Bool = false
    ) -> SuspensionSetupRecommendation {
        let weightLbs = riderWeightWithGearKg * 2.20462
        
        // Baseline air spring formulas:
        // Fork: ~1.15 PSI per kg for 160mm air fork (adjusting for aggressive sag)
        let forkPSI = round((riderWeightWithGearKg * 1.12) + (isEnduroAggressive ? 5.0 : 0.0))
        
        // Rear Shock (standard 2.5:1 leverage ratio): ~2.2 PSI per lb of rider weight
        let targetSagPercentage = isEnduroAggressive ? 0.30 : 0.25
        let rearPSI = round((weightLbs * 1.05) * (targetSagPercentage == 0.30 ? 0.95 : 1.0))
        let sagMm = forkTravelMm * targetSagPercentage
        
        // Rebound recommendation: heavier riders require slower rebound (more clicks from open)
        let reboundClicks = max(4, min(14, Int(round(riderWeightWithGearKg / 8.0))))
        
        return SuspensionSetupRecommendation(
            recommendedForkPSI: forkPSI,
            recommendedRearShockPSI: rearPSI,
            targetSagMm: sagMm,
            reboundClicksFromClosed: reboundClicks
        )
    }
    
    /// Evaluates battery state of health percentage and cycle degradation.
    public func calculateBatteryHealth(
        nominalCapacityWh: Double,
        actualMeasuredCapacityWh: Double,
        completedChargeCycles: Int
    ) -> Double {
        guard nominalCapacityWh > 0 else { return 100.0 }
        let measuredHealth = (actualMeasuredCapacityWh / nominalCapacityWh) * 100.0
        
        // Factor in expected Li-Ion cycle degradation (~0.05% per cycle)
        let cycleDegradationPenalty = Double(completedChargeCycles) * 0.04
        let estimatedHealth = max(0.0, min(100.0, measuredHealth - (cycleDegradationPenalty * 0.1)))
        
        return round(estimatedHealth * 10.0) / 10.0
    }
}
