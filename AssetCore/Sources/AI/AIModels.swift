//
//  AIModels.swift
//  AssetCoreAI
//
//  Created for Nordic Asset Suite.
//  Strict Concurrency: Complete. Codable Structured JSON Schemas for LLM Routing.
//

import Foundation

/// Active third-party AI LLM backend provider.
public enum AIProvider: String, Sendable, Codable {
    case geminiFlash = "gemini-1.5-flash"
    case grok2 = "grok-2"
    case localFallback = "local-vision-regex"
}

// MARK: - Extraction Request & Response

/// Payload dispatched to serverless AI proxy for receipt / document structured JSON extraction.
public struct AIExtractionRequest: Sendable, Codable {
    public let rawOCRText: String
    public let documentType: String // "receipt", "serial_badge", "manual_spec"
    public let targetLanguage: String // "en", "de", "fr", "it", "da", "sv", "nb"
    public let clientAttestationKeyId: String?
    
    public init(
        rawOCRText: String,
        documentType: String = "receipt",
        targetLanguage: String = "en",
        clientAttestationKeyId: String? = nil
    ) {
        self.rawOCRText = rawOCRText
        self.documentType = documentType
        self.targetLanguage = targetLanguage
        self.clientAttestationKeyId = clientAttestationKeyId
    }
}

/// Enforced structured JSON output schema returned by the LLM.
public struct AIExtractionResponse: Sendable, Codable {
    public let brand: String?
    public let modelName: String?
    public let serialNumber: String?
    public let purchaseDateISO: String? // "YYYY-MM-DD"
    public let purchasePrice: Decimal?
    public let currencyCode: String?
    public let detectedCategory: String?
    public let summaryDescription: String?
    public let confidenceScore: Double
    public let providerUsed: AIProvider
    
    public init(
        brand: String? = nil,
        modelName: String? = nil,
        serialNumber: String? = nil,
        purchaseDateISO: String? = nil,
        purchasePrice: Decimal? = nil,
        currencyCode: String? = nil,
        detectedCategory: String? = nil,
        summaryDescription: String? = nil,
        confidenceScore: Double = 0.95,
        providerUsed: AIProvider = .geminiFlash
    ) {
        self.brand = brand
        self.modelName = modelName
        self.serialNumber = serialNumber
        self.purchaseDateISO = purchaseDateISO
        self.purchasePrice = purchasePrice
        self.currencyCode = currencyCode
        self.detectedCategory = detectedCategory
        self.summaryDescription = summaryDescription
        self.confidenceScore = confidenceScore
        self.providerUsed = providerUsed
    }
}

// MARK: - Diagnostic Request & Response

/// Severity grading for AI diagnostic assessments.
public enum DiagnosticSeverity: String, Sendable, Codable {
    case low = "LOW"
    case medium = "MEDIUM"
    case high = "HIGH"
    case critical = "CRITICAL"
}

/// Payload sent to LLM for predictive maintenance and error code troubleshooting.
public struct AIDiagnosticRequest: Sendable, Codable {
    public let assetDomain: String // "Appliance", "SkiGear", "EBike", "CoffeeMachine"
    public let brand: String
    public let modelName: String
    public let errorCodeOrSymptom: String
    public let currentAgeMonths: Int
    public let historicalTelemetrySummary: String
    public let targetLanguage: String
    
    public init(
        assetDomain: String,
        brand: String,
        modelName: String,
        errorCodeOrSymptom: String,
        currentAgeMonths: Int = 0,
        historicalTelemetrySummary: String = "",
        targetLanguage: String = "en"
    ) {
        self.assetDomain = assetDomain
        self.brand = brand
        self.modelName = modelName
        self.errorCodeOrSymptom = errorCodeOrSymptom
        self.currentAgeMonths = currentAgeMonths
        self.historicalTelemetrySummary = historicalTelemetrySummary
        self.targetLanguage = targetLanguage
    }
}

/// Enforced structured JSON output schema for diagnostic assistance.
public struct AIDiagnosticResponse: Sendable, Codable {
    public let issueTitle: String
    public let probableRootCause: String
    public let severity: DiagnosticSeverity
    public let recommendedActionSteps: [String]
    public let requiresProfessionalService: Bool
    public let estimatedCostRangeCHF: String?
    public let updatedHealthScore: Int
    public let providerUsed: AIProvider
    
    public init(
        issueTitle: String,
        probableRootCause: String,
        severity: DiagnosticSeverity = .low,
        recommendedActionSteps: [String] = [],
        requiresProfessionalService: Bool = false,
        estimatedCostRangeCHF: String? = nil,
        updatedHealthScore: Int = 85,
        providerUsed: AIProvider = .geminiFlash
    ) {
        self.issueTitle = issueTitle
        self.probableRootCause = probableRootCause
        self.severity = severity
        self.recommendedActionSteps = recommendedActionSteps
        self.requiresProfessionalService = requiresProfessionalService
        self.estimatedCostRangeCHF = estimatedCostRangeCHF
        self.updatedHealthScore = updatedHealthScore
        self.providerUsed = providerUsed
    }
}
