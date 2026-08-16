//
//  CoffeeChemistryCalculator.swift
//  AssetCoreDatabase
//
//  Created for Nordic Asset Suite.
//  Strict Concurrency: Complete. Water Hardness Conversion & Descaling Intervals.
//

import Foundation

/// Water hardness classification.
public enum WaterHardnessCategory: String, Sendable {
    case soft = "Soft (0 - 7 °dH)"
    case medium = "Medium Hard (7 - 14 °dH)"
    case hard = "Hard (14 - 21 °dH)"
    case veryHard = "Very Hard (> 21 °dH)"
}

/// Chemical conversion and dynamic descaling interval calculator.
public final class CoffeeChemistryCalculator: Sendable {
    public static let shared = CoffeeChemistryCalculator()
    
    private init() {}
    
    /// Converts German degrees hardness (°dH) to French degrees (°fH) and PPM TDS.
    public func convertHardness(germanDegreesDH: Double) -> (frenchDegreesFH: Double, ppmTDS: Double, category: WaterHardnessCategory) {
        let fH = germanDegreesDH * 1.78
        let ppm = germanDegreesDH * 17.848
        
        let category: WaterHardnessCategory
        switch germanDegreesDH {
        case ..<7.0:
            category = .soft
        case 7.0..<14.0:
            category = .medium
        case 14.0..<21.0:
            category = .hard
        default:
            category = .veryHard
        }
        
        return (fH, ppm, category)
    }
    
    /// Calculates dynamic liters of water throughput allowed before next mandatory descaling cycle.
    /// Formula: Liters = Baseline (50L) / (Hardness °dH / 10.0)
    public func calculateLitersUntilDescale(
        germanDegreesDH: Double,
        isFilterCartridgeActive: Bool = true
    ) -> Double {
        // If filter cartridge (Claris Smart / BWT) is active, effective hardness is reduced by ~60%
        let effectiveDH = isFilterCartridgeActive ? max(3.0, germanDegreesDH * 0.4) : germanDegreesDH
        let hardnessFactor = max(0.3, effectiveDH / 10.0)
        let baselineLiters = 50.0
        
        let allowedLiters = baselineLiters / hardnessFactor
        return round(allowedLiters * 10.0) / 10.0
    }
    
    /// Calculates coffee grinder burr wear percentage.
    public func calculateBurrWear(totalKgGround: Double, ratedLifespanKg: Double) -> Double {
        guard ratedLifespanKg > 0 else { return 0.0 }
        let wear = (totalKgGround / ratedLifespanKg) * 100.0
        return min(100.0, round(wear * 10.0) / 10.0)
    }
}
