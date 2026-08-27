//
//  ApplianceModels.swift
//  AssetCoreDatabase
//
//  Created for Nordic Asset Suite.
//  Strict Concurrency: Complete. SwiftData & CloudKit Compliant.
//

import Foundation
import SwiftData

// MARK: - Appliance Entity (Root Asset for Appliance Warranty Manager)

@Model
public final class ApplianceEntity {
    public var id: UUID = UUID()
    public var canonicalProductId: String? = nil // References CanonicalProductEntity
    public var brand: String = ""
    public var modelName: String = ""
    public var serialNumber: String = ""
    public var roomLocation: String = "Kitchen" // e.g. Kitchen, Laundry, Basement
    public var purchaseDate: Date = Date()
    public var warrantyEndDate: Date = Date()
    public var purchasePrice: Decimal = 0.0
    public var currencyCode: String = "CHF"
    public var userNotes: String = ""
    public var ocrRawText: String? = nil
    public var receiptImageData: Data? = nil
    public var appliancePhotoData: Data? = nil
    public var purchaseCountry: String = "CH" // e.g. CH, DK, AT, NO, SE, UNKNOWN
    public var deliveryDate: Date? = nil
    public var conditionAtPurchase: String = "NEW" // NEW, USED, REFURBISHED
    public var sellerType: String = "BUSINESS" // BUSINESS, PRIVATE
    public var buyerType: String = "CONSUMER" // CONSUMER, BUSINESS
    public var sellerName: String = ""
    public var manufacturerWarrantyMonths: Int? = nil
    public var sellerGuaranteeMonths: Int? = nil
    public var extendedWarrantyMonths: Int? = nil
    public var isUserWarrantyOverridden: Bool = false
    public var createdAt: Date = Date()
    public var updatedAt: Date = Date()
    
    // Relationships (Optional & Defaulted for CloudKit)
    @Relationship(deleteRule: .cascade, inverse: \ApplianceHealthScore.appliance)
    public var healthScoreHistory: [ApplianceHealthScore]? = []
    
    @Relationship(deleteRule: .cascade, inverse: \FilterSpecs.appliance)
    public var filterSpecifications: [FilterSpecs]? = []
    
    @Relationship(deleteRule: .cascade, inverse: \EnergyEfficiencyRating.appliance)
    public var energyRating: EnergyEfficiencyRating? = nil
    
    public init(
        id: UUID = UUID(),
        canonicalProductId: String? = nil,
        brand: String,
        modelName: String,
        serialNumber: String = "",
        roomLocation: String = "Kitchen",
        purchaseDate: Date = Date(),
        deliveryDate: Date? = nil,
        purchaseCountry: String = "CH",
        manufacturerWarrantyMonths: Int? = nil,
        sellerGuaranteeMonths: Int? = nil,
        extendedWarrantyMonths: Int? = nil,
        warrantyEndDate: Date? = nil,
        purchasePrice: Decimal = 0.0,
        currencyCode: String = "CHF",
        sellerName: String = "",
        conditionAtPurchase: String = "NEW",
        sellerType: String = "BUSINESS",
        buyerType: String = "CONSUMER",
        userNotes: String = "",
        ocrRawText: String? = nil,
        receiptImageData: Data? = nil,
        appliancePhotoData: Data? = nil
    ) {
        self.id = id
        self.canonicalProductId = canonicalProductId
        self.brand = brand
        self.modelName = modelName
        self.serialNumber = serialNumber
        self.roomLocation = roomLocation
        self.purchaseDate = purchaseDate
        self.deliveryDate = deliveryDate ?? purchaseDate
        self.purchaseCountry = purchaseCountry
        self.manufacturerWarrantyMonths = manufacturerWarrantyMonths
        self.sellerGuaranteeMonths = sellerGuaranteeMonths
        self.extendedWarrantyMonths = extendedWarrantyMonths
        self.sellerName = sellerName
        self.conditionAtPurchase = conditionAtPurchase
        self.sellerType = sellerType
        self.buyerType = buyerType
        self.purchasePrice = purchasePrice
        self.currencyCode = currencyCode
        self.userNotes = userNotes
        self.ocrRawText = ocrRawText
        self.receiptImageData = receiptImageData
        self.appliancePhotoData = appliancePhotoData
        self.createdAt = Date()
        self.updatedAt = Date()
        self.healthScoreHistory = []
        self.filterSpecifications = []
        
        if let customEndDate = warrantyEndDate {
            self.warrantyEndDate = customEndDate
            self.isUserWarrantyOverridden = true
        } else if let mfr = manufacturerWarrantyMonths {
            self.warrantyEndDate = Calendar.current.date(byAdding: .month, value: mfr, to: purchaseDate) ?? purchaseDate
        } else {
            self.warrantyEndDate = purchaseDate
        }
    }
    
    /// Evaluates if any active statutory, manufacturer, or seller protection is currently valid.
    public var isWarrantyActive: Bool {
        return warrantySummary.hasActiveProtection
    }
    
    /// Comprehensive multi-layer protection summary.
    public var warrantySummary: WarrantySummaryDTO {
        return WarrantyCalculator.shared.calculateCoverage(
            purchaseDate: purchaseDate,
            deliveryDate: deliveryDate,
            purchaseCountry: purchaseCountry,
            brand: brand,
            category: "Appliance",
            conditionAtPurchase: conditionAtPurchase,
            sellerType: sellerType,
            buyerType: buyerType,
            manufacturerWarrantyMonths: manufacturerWarrantyMonths,
            sellerGuaranteeMonths: sellerGuaranteeMonths,
            extendedWarrantyMonths: extendedWarrantyMonths
        )
    }
    
    /// Latest calculated health score from append-only history.
    public var latestHealthScore: ApplianceHealthScore? {
        return healthScoreHistory?.sorted(by: { $0.calculationDate > $1.calculationDate }).first
    }
}

// MARK: - Appliance Health Score (Append-Only Historical Log)

@Model
public final class ApplianceHealthScore {
    public var id: UUID = UUID()
    public var score: Int = 100 // 0 to 100
    public var degradationRatePercentage: Double = 0.0 // Annual degradation estimate
    public var estimatedRemainingLifespanMonths: Int = 120
    public var diagnosticFlags: String = "" // JSON-encoded diagnostic flags / error warnings
    public var calculationDate: Date = Date()
    
    public var appliance: ApplianceEntity? = nil
    
    public init(
        id: UUID = UUID(),
        score: Int,
        degradationRatePercentage: Double = 0.0,
        estimatedRemainingLifespanMonths: Int = 120,
        diagnosticFlags: String = "",
        calculationDate: Date = Date(),
        appliance: ApplianceEntity? = nil
    ) {
        self.id = id
        self.score = max(0, min(100, score))
        self.degradationRatePercentage = degradationRatePercentage
        self.estimatedRemainingLifespanMonths = estimatedRemainingLifespanMonths
        self.diagnosticFlags = diagnosticFlags
        self.calculationDate = calculationDate
        self.appliance = appliance
    }
}

// MARK: - Filter Specifications

@Model
public final class FilterSpecs {
    public var id: UUID = UUID()
    public var filterType: String = "HEPA" // HEPA, Carbon, Water, Lint, Grease
    public var partNumber: String = ""
    public var replacementIntervalDays: Int = 180
    public var lastReplacedDate: Date = Date()
    public var nextDueDate: Date = Date()
    
    public var appliance: ApplianceEntity? = nil
    
    public init(
        id: UUID = UUID(),
        filterType: String,
        partNumber: String = "",
        replacementIntervalDays: Int = 180,
        lastReplacedDate: Date = Date(),
        appliance: ApplianceEntity? = nil
    ) {
        self.id = id
        self.filterType = filterType
        self.partNumber = partNumber
        self.replacementIntervalDays = replacementIntervalDays
        self.lastReplacedDate = lastReplacedDate
        self.nextDueDate = Calendar.current.date(byAdding: .day, value: replacementIntervalDays, to: lastReplacedDate) ?? Date()
        self.appliance = appliance
    }
    
    public var isReplacementDue: Bool {
        return Date() >= nextDueDate
    }
}

// MARK: - Energy Efficiency Rating

@Model
public final class EnergyEfficiencyRating {
    public var id: UUID = UUID()
    public var ratingGrade: String = "A" // EU Standard: A, B, C, D, E, F, G or historical A+++
    public var annualEnergyConsumptionKWh: Double = 0.0
    public var estimatedAnnualCostCHF: Decimal = 0.0
    public var noiseLevelDecibels: Double = 0.0
    
    public var appliance: ApplianceEntity? = nil
    
    public init(
        id: UUID = UUID(),
        ratingGrade: String,
        annualEnergyConsumptionKWh: Double = 0.0,
        estimatedAnnualCostCHF: Decimal = 0.0,
        noiseLevelDecibels: Double = 0.0,
        appliance: ApplianceEntity? = nil
    ) {
        self.id = id
        self.ratingGrade = ratingGrade
        self.annualEnergyConsumptionKWh = annualEnergyConsumptionKWh
        self.estimatedAnnualCostCHF = estimatedAnnualCostCHF
        self.noiseLevelDecibels = noiseLevelDecibels
        self.appliance = appliance
    }
}
