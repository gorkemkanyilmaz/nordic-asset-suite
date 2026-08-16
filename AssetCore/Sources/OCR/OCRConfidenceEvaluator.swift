//
//  OCRConfidenceEvaluator.swift
//  AssetCoreOCR
//
//  Created for Nordic Asset Suite.
//  Strict Concurrency: Complete. Decision Engine for Local vs Cloud AI Fallback.
//

import Foundation

/// Decision outcome indicating whether local Vision OCR is reliable or requires cloud LLM fallback.
public struct OCREvaluationDecision: Sendable {
    public let isSufficient: Bool
    public let overallConfidence: Float
    public let missingFields: [String]
    public let recommendation: String
    
    public init(
        isSufficient: Bool,
        overallConfidence: Float,
        missingFields: [String] = [],
        recommendation: String
    ) {
        self.isSufficient = isSufficient
        self.overallConfidence = overallConfidence
        self.missingFields = missingFields
        self.recommendation = recommendation
    }
}

/// Evaluates extraction completeness and confidence thresholds.
public final class OCRConfidenceEvaluator: Sendable {
    public static let shared = OCRConfidenceEvaluator()
    
    public static let minimumAcceptableConfidence: Float = 0.85
    
    private init() {}
    
    /// Evaluates parsed receipt data.
    public func evaluateReceipt(_ data: ParsedReceiptData) -> OCREvaluationDecision {
        var missing: [String] = []
        if data.merchantName == nil { missing.append("Merchant Name") }
        if data.totalAmount == nil { missing.append("Total Amount") }
        if data.transactionDate == nil { missing.append("Date") }
        
        let isConfidenceHigh = data.confidenceScore >= Self.minimumAcceptableConfidence
        let hasCoreFields = data.totalAmount != nil && (data.merchantName != nil || data.transactionDate != nil)
        
        let isSufficient = isConfidenceHigh && hasCoreFields
        let recommendation = isSufficient
            ? "Local Apple Vision parsing succeeded with high confidence."
            : "Confidence low or core fields missing; routing to Cloud AI fallback."
        
        return OCREvaluationDecision(
            isSufficient: isSufficient,
            overallConfidence: data.confidenceScore,
            missingFields: missing,
            recommendation: recommendation
        )
    }
    
    /// Evaluates parsed hardware serial badge data.
    public func evaluateSerialBadge(_ data: ParsedSerialData) -> OCREvaluationDecision {
        var missing: [String] = []
        if data.brand == nil { missing.append("Brand") }
        if data.serialNumber == nil { missing.append("Serial Number") }
        
        let isConfidenceHigh = data.confidenceScore >= Self.minimumAcceptableConfidence
        let hasCoreFields = data.brand != nil || data.serialNumber != nil
        
        let isSufficient = isConfidenceHigh && hasCoreFields
        let recommendation = isSufficient
            ? "Hardware badge parsed successfully."
            : "Serial or brand ambiguous; routing to Cloud AI fallback."
        
        return OCREvaluationDecision(
            isSufficient: isSufficient,
            overallConfidence: data.confidenceScore,
            missingFields: missing,
            recommendation: recommendation
        )
    }
}
