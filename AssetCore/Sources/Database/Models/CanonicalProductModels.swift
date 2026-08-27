//
//  CanonicalProductModels.swift
//  AssetCoreDatabase
//
//  Created for Nordic Asset Suite.
//  Strict Concurrency: Complete. SwiftData & CloudKit Compliant.
//  Immutable Canonical Product vs. Mutable User Product Instance Architecture.
//

import Foundation
import SwiftData

// MARK: - Source Provenance & Field Status Enums

public enum SourceType: String, Codable, Sendable {
    case manufacturer = "MANUFACTURER"
    case manufacturerSupport = "MANUFACTURER_SUPPORT"
    case manufacturerParts = "MANUFACTURER_PARTS"
    case manual = "MANUAL"
    case barcodeDatabase = "BARCODE_DATABASE"
    case reputableRetailer = "REPUTABLE_RETAILER"
    case user = "USER"
    case aiInference = "AI_INFERENCE"
    case other = "OTHER"
}

public enum FieldStatus: String, Codable, Sendable {
    case verified = "VERIFIED"
    case supported = "SUPPORTED"
    case userProvided = "USER_PROVIDED"
    case inferred = "INFERRED"
    case unknown = "UNKNOWN"
}

public enum PartCategory: String, Codable, Sendable {
    case consumable = "CONSUMABLE"
    case replacementPart = "REPLACEMENT_PART"
    case accessory = "ACCESSORY"
}

// MARK: - Source Record Entity

@Model
public final class SourceRecordEntity {
    public var id: String = ""
    public var url: String = ""
    public var domain: String = ""
    public var sourceName: String = ""
    public var rawSourceType: String = SourceType.manufacturer.rawValue
    public var retrievedAt: Date = Date()
    public var contentHash: String? = nil
    
    public var canonicalProduct: CanonicalProductEntity? = nil
    
    public init(
        id: String = UUID().uuidString,
        url: String,
        domain: String,
        sourceName: String,
        sourceType: SourceType = .manufacturer,
        retrievedAt: Date = Date(),
        contentHash: String? = nil
    ) {
        self.id = id
        self.url = url
        self.domain = domain
        self.sourceName = sourceName
        self.rawSourceType = sourceType.rawValue
        self.retrievedAt = retrievedAt
        self.contentHash = contentHash
    }
    
    public var sourceType: SourceType {
        get { SourceType(rawValue: rawSourceType) ?? .other }
        set { rawSourceType = newValue.rawValue }
    }
}

// MARK: - Market Price Entity

@Model
public final class MarketPriceEntity {
    public var id: String = ""
    public var merchant: String = ""
    public var amount: Decimal = 0.0
    public var currencyCode: String = "CHF"
    public var countryCode: String = "CH"
    public var condition: String = "NEW"
    public var availability: String = "IN_STOCK"
    public var sourceUrl: String = ""
    public var observedAt: Date = Date()
    
    public var canonicalProduct: CanonicalProductEntity? = nil
    
    public init(
        id: String = UUID().uuidString,
        merchant: String,
        amount: Decimal,
        currencyCode: String = "CHF",
        countryCode: String = "CH",
        condition: String = "NEW",
        availability: String = "IN_STOCK",
        sourceUrl: String = "",
        observedAt: Date = Date()
    ) {
        self.id = id
        self.merchant = merchant
        self.amount = amount
        self.currencyCode = currencyCode
        self.countryCode = countryCode
        self.condition = condition
        self.availability = availability
        self.sourceUrl = sourceUrl
        self.observedAt = observedAt
    }
}

// MARK: - Maintenance Task Entity

@Model
public final class MaintenanceTaskEntity {
    public var id: String = ""
    public var title: String = ""
    public var taskDescription: String = ""
    public var triggerType: String = "TIME" // TIME, USAGE, PROMPT
    public var intervalDays: Int = 30
    public var intervalUsageUnits: Int? = nil
    public var isMandatory: Bool = true
    public var instructions: String = ""
    public var toolsRequired: [String]? = []
    public var safetyWarning: String? = nil
    public var sourceUrl: String? = nil
    
    public var canonicalProduct: CanonicalProductEntity? = nil
    
    public init(
        id: String = UUID().uuidString,
        title: String,
        taskDescription: String = "",
        triggerType: String = "TIME",
        intervalDays: Int = 30,
        intervalUsageUnits: Int? = nil,
        isMandatory: Bool = true,
        instructions: String = "",
        toolsRequired: [String]? = [],
        safetyWarning: String? = nil,
        sourceUrl: String? = nil
    ) {
        self.id = id
        self.title = title
        self.taskDescription = taskDescription
        self.triggerType = triggerType
        self.intervalDays = intervalDays
        self.intervalUsageUnits = intervalUsageUnits
        self.isMandatory = isMandatory
        self.instructions = instructions
        self.toolsRequired = toolsRequired
        self.safetyWarning = safetyWarning
        self.sourceUrl = sourceUrl
    }
}

// MARK: - Part Item Entity

@Model
public final class PartItemEntity {
    public var id: String = ""
    public var partNumber: String = ""
    public var name: String = ""
    public var rawCategory: String = PartCategory.consumable.rawValue
    public var isConsumable: Bool = true
    public var replacementIntervalDays: Int? = nil
    public var estimatedCostCHF: Decimal? = nil
    public var sourceUrl: String? = nil
    public var imageUrl: String? = nil
    
    public var canonicalProduct: CanonicalProductEntity? = nil
    
    public init(
        id: String = UUID().uuidString,
        partNumber: String,
        name: String,
        category: PartCategory = .consumable,
        isConsumable: Bool = true,
        replacementIntervalDays: Int? = nil,
        estimatedCostCHF: Decimal? = nil,
        sourceUrl: String? = nil,
        imageUrl: String? = nil
    ) {
        self.id = id
        self.partNumber = partNumber
        self.name = name
        self.rawCategory = category.rawValue
        self.isConsumable = isConsumable
        self.replacementIntervalDays = replacementIntervalDays
        self.estimatedCostCHF = estimatedCostCHF
        self.sourceUrl = sourceUrl
        self.imageUrl = imageUrl
    }
    
    public var category: PartCategory {
        get { PartCategory(rawValue: rawCategory) ?? .consumable }
        set { rawCategory = newValue.rawValue }
    }
}

// MARK: - Canonical Product Entity (Immutable Physical Hardware Model)

@Model
public final class CanonicalProductEntity {
    public var id: String = "" // e.g. "canon-philips-ep3347-90"
    public var brand: String = ""
    public var manufacturer: String = ""
    public var family: String = ""
    public var series: String = ""
    public var modelNumber: String = ""
    public var variant: String = ""
    public var canonicalName: String = ""
    public var category: String = "Appliance"
    public var subCategory: String? = nil
    public var summaryDescription: String = ""
    
    // Identifiers
    public var ean: String? = nil
    public var upc: String? = nil
    public var gtin: String? = nil
    public var asin: String? = nil
    
    // Media & URLs
    public var primaryImageUrl: String? = nil
    public var additionalImageUrls: [String]? = []
    public var officialProductUrl: String? = nil
    public var officialSupportUrl: String? = nil
    public var officialManualPdfUrl: String? = nil
    
    // JSON-encoded Technical Specifications Map
    public var specificationsJSON: String = "{}"
    
    // Manufacturer Warranty Policy Baseline
    public var standardWarrantyMonths: Int = 24
    public var extendedRegistrationMonths: Int? = nil
    public var warrantyTerritory: String = "Europe / Switzerland"
    
    // Timestamps
    public var createdAt: Date = Date()
    public var updatedAt: Date = Date()
    
    // Relationships
    @Relationship(deleteRule: .cascade, inverse: \SourceRecordEntity.canonicalProduct)
    public var sourceRecords: [SourceRecordEntity]? = []
    
    @Relationship(deleteRule: .cascade, inverse: \MarketPriceEntity.canonicalProduct)
    public var marketPrices: [MarketPriceEntity]? = []
    
    @Relationship(deleteRule: .cascade, inverse: \MaintenanceTaskEntity.canonicalProduct)
    public var maintenanceTasks: [MaintenanceTaskEntity]? = []
    
    @Relationship(deleteRule: .cascade, inverse: \PartItemEntity.canonicalProduct)
    public var spareParts: [PartItemEntity]? = []
    
    public init(
        id: String,
        brand: String,
        manufacturer: String = "",
        family: String = "",
        series: String = "",
        modelNumber: String,
        variant: String = "",
        canonicalName: String,
        category: String = "Appliance",
        subCategory: String? = nil,
        summaryDescription: String = "",
        ean: String? = nil,
        upc: String? = nil,
        gtin: String? = nil,
        asin: String? = nil,
        primaryImageUrl: String? = nil,
        additionalImageUrls: [String]? = [],
        officialProductUrl: String? = nil,
        officialSupportUrl: String? = nil,
        officialManualPdfUrl: String? = nil,
        specificationsJSON: String = "{}",
        standardWarrantyMonths: Int = 24,
        extendedRegistrationMonths: Int? = nil,
        warrantyTerritory: String = "Europe / Switzerland"
    ) {
        self.id = id
        self.brand = brand
        self.manufacturer = manufacturer
        self.family = family
        self.series = series
        self.modelNumber = modelNumber
        self.variant = variant
        self.canonicalName = canonicalName
        self.category = category
        self.subCategory = subCategory
        self.summaryDescription = summaryDescription
        self.ean = ean
        self.upc = upc
        self.gtin = gtin
        self.asin = asin
        self.primaryImageUrl = primaryImageUrl
        self.additionalImageUrls = additionalImageUrls
        self.officialProductUrl = officialProductUrl
        self.officialSupportUrl = officialSupportUrl
        self.officialManualPdfUrl = officialManualPdfUrl
        self.specificationsJSON = specificationsJSON
        self.standardWarrantyMonths = standardWarrantyMonths
        self.extendedRegistrationMonths = extendedRegistrationMonths
        self.warrantyTerritory = warrantyTerritory
        self.createdAt = Date()
        self.updatedAt = Date()
        self.sourceRecords = []
        self.marketPrices = []
        self.maintenanceTasks = []
        self.spareParts = []
    }
}

// MARK: - Sendable Data Transfer Objects (DTOs)

public struct CanonicalProductDTO: Sendable, Identifiable, Codable {
    public let id: String
    public let brand: String
    public let manufacturer: String
    public let family: String
    public let series: String
    public let modelNumber: String
    public let variant: String
    public let canonicalName: String
    public let category: String
    public let subCategory: String?
    public let summaryDescription: String
    public let ean: String?
    public let upc: String?
    public let gtin: String?
    public let asin: String?
    public let primaryImageUrl: String?
    public let additionalImageUrls: [String]
    public let officialProductUrl: String?
    public let officialSupportUrl: String?
    public let officialManualPdfUrl: String?
    public let specifications: [String: String]
    public let standardWarrantyMonths: Int
    public let extendedRegistrationMonths: Int?
    public let warrantyTerritory: String
    public let marketPriceRangeCHF: String?
    
    public init(
        id: String,
        brand: String,
        manufacturer: String = "",
        family: String = "",
        series: String = "",
        modelNumber: String,
        variant: String = "",
        canonicalName: String,
        category: String = "Appliance",
        subCategory: String? = nil,
        summaryDescription: String = "",
        ean: String? = nil,
        upc: String? = nil,
        gtin: String? = nil,
        asin: String? = nil,
        primaryImageUrl: String? = nil,
        additionalImageUrls: [String] = [],
        officialProductUrl: String? = nil,
        officialSupportUrl: String? = nil,
        officialManualPdfUrl: String? = nil,
        specifications: [String: String] = [:],
        standardWarrantyMonths: Int = 24,
        extendedRegistrationMonths: Int? = nil,
        warrantyTerritory: String = "Europe / Switzerland",
        marketPriceRangeCHF: String? = nil
    ) {
        self.id = id
        self.brand = brand
        self.manufacturer = manufacturer
        self.family = family
        self.series = series
        self.modelNumber = modelNumber
        self.variant = variant
        self.canonicalName = canonicalName
        self.category = category
        self.subCategory = subCategory
        self.summaryDescription = summaryDescription
        self.ean = ean
        self.upc = upc
        self.gtin = gtin
        self.asin = asin
        self.primaryImageUrl = primaryImageUrl
        self.additionalImageUrls = additionalImageUrls
        self.officialProductUrl = officialProductUrl
        self.officialSupportUrl = officialSupportUrl
        self.officialManualPdfUrl = officialManualPdfUrl
        self.specifications = specifications
        self.standardWarrantyMonths = standardWarrantyMonths
        self.extendedRegistrationMonths = extendedRegistrationMonths
        self.warrantyTerritory = warrantyTerritory
        self.marketPriceRangeCHF = marketPriceRangeCHF
    }
}
