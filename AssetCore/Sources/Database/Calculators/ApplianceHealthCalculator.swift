//
//  ApplianceHealthCalculator.swift
//  AssetCoreDatabase
//
//  Created for Nordic Asset Suite.
//  Strict Concurrency: Complete. Health Scoring & Predictive Lifespan Algorithm.
//

import Foundation

/// Calculated health assessment.
public struct HealthAssessment: Sendable {
    public let healthScore: Int // 0 to 100
    public let annualDegradationRate: Double
    public let remainingLifespanMonths: Int
    public let statusSummary: String
    
    public init(
        healthScore: Int,
        annualDegradationRate: Double,
        remainingLifespanMonths: Int,
        statusSummary: String
    ) {
        self.healthScore = healthScore
        self.annualDegradationRate = annualDegradationRate
        self.remainingLifespanMonths = remainingLifespanMonths
        self.statusSummary = statusSummary
    }
}

/// Computes home appliance health scores and predictive degradation curves.
public final class ApplianceHealthCalculator: Sendable {
    public static let shared = ApplianceHealthCalculator()
    
    private init() {}
    
    /// Computes health score from appliance age, overdue filter days, and active error codes.
    public func calculateHealth(
        ageMonths: Int,
        ratedLifespanMonths: Int = 144, // Default 12 years (European standard)
        overdueFilterDays: Int = 0,
        unresolvedErrorCodesCount: Int = 0
    ) -> HealthAssessment {
        var baseScore = 100.0
        
        // 1. Age degradation factor
        let ageRatio = min(1.0, Double(ageMonths) / Double(ratedLifespanMonths))
        baseScore -= (ageRatio * 40.0) // Maximum 40% loss from pure age
        
        // 2. Overdue filter penalty
        if overdueFilterDays > 0 {
            let filterPenalty = min(25.0, Double(overdueFilterDays) * 0.2)
            baseScore -= filterPenalty
        }
        
        // 3. Unresolved error codes penalty
        if unresolvedErrorCodesCount > 0 {
            let errorPenalty = min(35.0, Double(unresolvedErrorCodesCount) * 15.0)
            baseScore -= errorPenalty
        }
        
        let finalScore = max(5, min(100, Int(round(baseScore))))
        let annualDegradation = round((100.0 / Double(ratedLifespanMonths / 12)) * 10.0) / 10.0
        let remainingMonths = max(0, ratedLifespanMonths - ageMonths)
        
        let summary: String
        switch finalScore {
        case 85...100:
            summary = "Optimal Health. All maintenance up to date."
        case 70..<85:
            summary = "Good. Routine filter replacement recommended."
        case 50..<70:
            summary = "Fair. Maintenance overdue or minor error logs detected."
        default:
            summary = "Critical Attention Required. Diagnostic inspection recommended."
        }
        
        return HealthAssessment(
            healthScore: finalScore,
            annualDegradationRate: annualDegradation,
            remainingLifespanMonths: remainingMonths,
            statusSummary: summary
        )
    }
}
