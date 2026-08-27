//
//  AIModels.swift
//  AssetCoreAI
//
//  Created for Nordic Asset Suite.
//  Strict Concurrency: Complete. Codable Structured JSON Schemas for Omni-Identification, Manuals, Warranty & Maintenance.
//

import Foundation

/// Active third-party AI LLM backend provider.
public enum AIProvider: String, Sendable, Codable {
    case geminiFlash = "gemini-1.5-flash"
    case geminiFlash2 = "gemini-2.0-flash"
    case grok2 = "grok-2"
    case localFallback = "local-vision-regex"
}

// MARK: - Omni-Product Candidate Identification

/// Structured result of AI product recognition (via barcode, OCR label, or free-text search).
public struct ProductCandidateMatch: Sendable, Codable, Identifiable {
    public var id: String { "\(brand)_\(modelName)_\(serialNumber ?? "none")" }
    public let brand: String
    public let modelName: String
    public let fullTitle: String
    public let category: String // Appliance, CoffeeMachine, EBike, SkiGear, Electronics, AudioVisual
    public let subCategory: String? // e.g. "OLED TV", "Washing Machine", "Superautomatic Espresso"
    public let serialNumber: String?
    public let manufactureYear: Int?
    public let keySpecifications: [String: String]
    public let estimatedPrice: Decimal?
    public let currencyCode: String
    public let defaultWarrantyMonths: Int
    public let summaryDescription: String
    public let confidenceScore: Double
    public let providerUsed: AIProvider
    
    public init(
        brand: String,
        modelName: String,
        fullTitle: String,
        category: String,
        subCategory: String? = nil,
        serialNumber: String? = nil,
        manufactureYear: Int? = nil,
        keySpecifications: [String: String] = [:],
        estimatedPrice: Decimal? = nil,
        currencyCode: String = "CHF",
        defaultWarrantyMonths: Int = 24,
        summaryDescription: String = "",
        confidenceScore: Double = 0.95,
        providerUsed: AIProvider = .geminiFlash
    ) {
        self.brand = brand
        self.modelName = modelName
        self.fullTitle = fullTitle
        self.category = category
        self.subCategory = subCategory
        self.serialNumber = serialNumber
        self.manufactureYear = manufactureYear
        self.keySpecifications = keySpecifications
        self.estimatedPrice = estimatedPrice
        self.currencyCode = currencyCode
        self.defaultWarrantyMonths = defaultWarrantyMonths
        self.summaryDescription = summaryDescription
        self.confidenceScore = confidenceScore
        self.providerUsed = providerUsed
    }
}

// MARK: - Maintenance Manual & Step-by-Step Guides

public struct MaintenanceStep: Sendable, Codable, Identifiable {
    public var id: Int { stepNumber }
    public let stepNumber: Int
    public let title: String
    public let detail: String
    public let frequencyDescription: String // e.g. "Monthly", "Every 200 shots", "Seasonal"
    public let frequencyDays: Int?
    public let isMandatory: Bool
    public let toolsRequired: [String]
    public let iconName: String
    
    public init(
        stepNumber: Int,
        title: String,
        detail: String,
        frequencyDescription: String = "Periodic",
        frequencyDays: Int? = 90,
        isMandatory: Bool = true,
        toolsRequired: [String] = [],
        iconName: String = "wrench.and.screwdriver"
    ) {
        self.stepNumber = stepNumber
        self.title = title
        self.detail = detail
        self.frequencyDescription = frequencyDescription
        self.frequencyDays = frequencyDays
        self.isMandatory = isMandatory
        self.toolsRequired = toolsRequired
        self.iconName = iconName
    }
}

public struct MaintenanceManualData: Sendable, Codable {
    public let brand: String
    public let modelName: String
    public let category: String
    public let generalCareSummary: String
    public let recommendedServiceIntervalDays: Int
    public let maintenanceSteps: [MaintenanceStep]
    public let recommendedCleanersOrLubricants: [String]
    public let safetyPrecautions: [String]
    public let officialSupportURL: String?
    
    public init(
        brand: String,
        modelName: String,
        category: String,
        generalCareSummary: String,
        recommendedServiceIntervalDays: Int = 180,
        maintenanceSteps: [MaintenanceStep] = [],
        recommendedCleanersOrLubricants: [String] = [],
        safetyPrecautions: [String] = [],
        officialSupportURL: String? = nil
    ) {
        self.brand = brand
        self.modelName = modelName
        self.category = category
        self.generalCareSummary = generalCareSummary
        self.recommendedServiceIntervalDays = recommendedServiceIntervalDays
        self.maintenanceSteps = maintenanceSteps
        self.recommendedCleanersOrLubricants = recommendedCleanersOrLubricants
        self.safetyPrecautions = safetyPrecautions
        self.officialSupportURL = officialSupportURL
    }
}

// MARK: - Spare Parts & Wear Schedule

public struct SparePartItem: Sendable, Codable, Identifiable {
    public var id: String { partNumber.isEmpty ? name : partNumber }
    public let partNumber: String
    public let name: String
    public let category: String // Filter, Gasket, Chain, BrakePad, Burr, HeatingElement, Screen, Battery
    public let replacementIntervalDays: Int
    public let estimatedCostCHF: Decimal
    public let wearDegradationRateMonthly: Double // 0.0 to 100.0%
    public let description: String
    public let isCriticalForOperation: Bool
    
    public init(
        partNumber: String,
        name: String,
        category: String,
        replacementIntervalDays: Int = 180,
        estimatedCostCHF: Decimal = 45.0,
        wearDegradationRateMonthly: Double = 5.0,
        description: String = "",
        isCriticalForOperation: Bool = true
    ) {
        self.partNumber = partNumber
        self.name = name
        self.category = category
        self.replacementIntervalDays = replacementIntervalDays
        self.estimatedCostCHF = estimatedCostCHF
        self.wearDegradationRateMonthly = wearDegradationRateMonthly
        self.description = description
        self.isCriticalForOperation = isCriticalForOperation
    }
}

public struct SparePartsScheduleData: Sendable, Codable {
    public let brand: String
    public let modelName: String
    public let parts: [SparePartItem]
    
    public init(brand: String, modelName: String, parts: [SparePartItem]) {
        self.brand = brand
        self.modelName = modelName
        self.parts = parts
    }
}

// MARK: - Warranty Details

public struct WarrantyDetailsResponse: Sendable, Codable {
    public let standardCoverageMonths: Int
    public let extendedAvailableMonths: Int
    public let termsSummary: String
    public let coveredComponents: [String]
    public let excludedComponents: [String]
    public let claimsProcedure: String
    public let officialContact: String
    
    public init(
        standardCoverageMonths: Int = 24,
        extendedAvailableMonths: Int = 36,
        termsSummary: String = "2-Year European & Swiss statutory manufacturer warranty.",
        coveredComponents: [String] = ["Motor", "Electronics", "Compressor", "Heating Coil", "Frame"],
        excludedComponents: [String] = ["Cosmetic scratches", "Consumable wear", "Accidental drops"],
        claimsProcedure: String = "Register with serial number on OEM portal or contact certified dealer.",
        officialContact: String = "support@nordicassetsuite.ch"
    ) {
        self.standardCoverageMonths = standardCoverageMonths
        self.extendedAvailableMonths = extendedAvailableMonths
        self.termsSummary = termsSummary
        self.coveredComponents = coveredComponents
        self.excludedComponents = excludedComponents
        self.claimsProcedure = claimsProcedure
        self.officialContact = officialContact
    }
}

// MARK: - Extraction Request & Response

/// Payload dispatched for receipt / rating badge / document structured JSON extraction.
public struct AIExtractionRequest: Sendable, Codable {
    public let rawOCRText: String
    public let documentType: String // "receipt", "serial_badge", "manual_spec", "omni_query"
    public let targetLanguage: String // "en", "de", "fr", "it", "da", "sv", "nb", "tr"
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
