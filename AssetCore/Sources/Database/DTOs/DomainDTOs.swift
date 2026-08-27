//
//  DomainDTOs.swift
//  AssetCoreDatabase
//
//  Created for Nordic Asset Suite.
//  Strict Concurrency: Complete. Sendable DTOs for safe cross-actor communication.
//

import Foundation

// MARK: - Appliance DTO
public struct ApplianceDTO: Sendable, Identifiable, Codable {
    public let id: UUID
    public let brand: String
    public let modelName: String
    public let serialNumber: String
    public let roomLocation: String
    public let purchaseDate: Date
    public let deliveryDate: Date?
    public let purchaseCountry: String
    public let conditionAtPurchase: String
    public let sellerType: String
    public let buyerType: String
    public let sellerName: String
    public let manufacturerWarrantyMonths: Int?
    public let sellerGuaranteeMonths: Int?
    public let extendedWarrantyMonths: Int?
    public let warrantyEndDate: Date
    public let purchasePrice: Decimal
    public let currencyCode: String
    public let isWarrantyActive: Bool
    public let latestHealthScore: Int?
    public let filterCount: Int
    public let category: String
    public let userNotes: String
    public let warrantySummary: WarrantySummaryDTO
    
    public init(
        id: UUID,
        brand: String,
        modelName: String,
        serialNumber: String,
        roomLocation: String,
        purchaseDate: Date,
        deliveryDate: Date? = nil,
        purchaseCountry: String = "CH",
        conditionAtPurchase: String = "NEW",
        sellerType: String = "BUSINESS",
        buyerType: String = "CONSUMER",
        sellerName: String = "",
        manufacturerWarrantyMonths: Int? = nil,
        sellerGuaranteeMonths: Int? = nil,
        extendedWarrantyMonths: Int? = nil,
        warrantyEndDate: Date? = nil,
        purchasePrice: Decimal = 0.0,
        currencyCode: String = "CHF",
        latestHealthScore: Int? = nil,
        filterCount: Int = 0,
        category: String = "Appliance",
        userNotes: String = ""
    ) {
        self.id = id
        self.brand = brand
        self.modelName = modelName
        self.serialNumber = serialNumber
        self.roomLocation = roomLocation
        self.purchaseDate = purchaseDate
        self.deliveryDate = deliveryDate ?? purchaseDate
        self.purchaseCountry = purchaseCountry
        self.conditionAtPurchase = conditionAtPurchase
        self.sellerType = sellerType
        self.buyerType = buyerType
        self.sellerName = sellerName
        self.manufacturerWarrantyMonths = manufacturerWarrantyMonths
        self.sellerGuaranteeMonths = sellerGuaranteeMonths
        self.extendedWarrantyMonths = extendedWarrantyMonths
        self.purchasePrice = purchasePrice
        self.currencyCode = currencyCode
        self.latestHealthScore = latestHealthScore
        self.filterCount = filterCount
        self.category = category
        self.userNotes = userNotes
        
        let calculatedSummary = WarrantyCalculator.shared.calculateCoverage(
            purchaseDate: purchaseDate,
            deliveryDate: deliveryDate ?? purchaseDate,
            purchaseCountry: purchaseCountry,
            brand: brand,
            category: category,
            conditionAtPurchase: conditionAtPurchase,
            sellerType: sellerType,
            buyerType: buyerType,
            manufacturerWarrantyMonths: manufacturerWarrantyMonths,
            sellerGuaranteeMonths: sellerGuaranteeMonths,
            extendedWarrantyMonths: extendedWarrantyMonths
        )
        self.warrantySummary = calculatedSummary
        self.isWarrantyActive = calculatedSummary.hasActiveProtection
        
        if let customEndDate = warrantyEndDate {
            self.warrantyEndDate = customEndDate
        } else if let mfr = manufacturerWarrantyMonths {
            self.warrantyEndDate = Calendar.current.date(byAdding: .month, value: mfr, to: purchaseDate) ?? purchaseDate
        } else {
            self.warrantyEndDate = purchaseDate
        }
    }
}

// MARK: - Ski Gear DTO
public struct SkiGearDTO: Sendable, Identifiable, Codable {
    public let id: UUID
    public let brand: String
    public let modelName: String
    public let serialNumber: String
    public let gearCategory: String
    public let skiLengthCm: Double
    public let bootSoleLengthMm: Int
    public let currentSeason: String
    public let isArchivedForSummer: Bool
    public let latestDIN: Double?
    public let latestWaxType: String?
    
    public init(
        id: UUID,
        brand: String,
        modelName: String,
        serialNumber: String,
        gearCategory: String,
        skiLengthCm: Double,
        bootSoleLengthMm: Int,
        currentSeason: String,
        isArchivedForSummer: Bool,
        latestDIN: Double? = nil,
        latestWaxType: String? = nil
    ) {
        self.id = id
        self.brand = brand
        self.modelName = modelName
        self.serialNumber = serialNumber
        self.gearCategory = gearCategory
        self.skiLengthCm = skiLengthCm
        self.bootSoleLengthMm = bootSoleLengthMm
        self.currentSeason = currentSeason
        self.isArchivedForSummer = isArchivedForSummer
        self.latestDIN = latestDIN
        self.latestWaxType = latestWaxType
    }
}

// MARK: - E-Bike DTO
public struct EBikeDTO: Sendable, Identifiable, Codable {
    public let id: UUID
    public let brand: String
    public let modelName: String
    public let frameNumber: String
    public let motorSystem: String
    public let totalOdometerKm: Double
    public let latestBatteryHealthPercentage: Double?
    public let forkPressurePSI: Double?
    public let rearShockPressurePSI: Double?
    
    public init(
        id: UUID,
        brand: String,
        modelName: String,
        frameNumber: String,
        motorSystem: String,
        totalOdometerKm: Double,
        latestBatteryHealthPercentage: Double? = nil,
        forkPressurePSI: Double? = nil,
        rearShockPressurePSI: Double? = nil
    ) {
        self.id = id
        self.brand = brand
        self.modelName = modelName
        self.frameNumber = frameNumber
        self.motorSystem = motorSystem
        self.totalOdometerKm = totalOdometerKm
        self.latestBatteryHealthPercentage = latestBatteryHealthPercentage
        self.forkPressurePSI = forkPressurePSI
        self.rearShockPressurePSI = rearShockPressurePSI
    }
}

// MARK: - Coffee Machine DTO
public struct CoffeeMachineDTO: Sendable, Identifiable, Codable {
    public let id: UUID
    public let brand: String
    public let modelName: String
    public let machineType: String
    public let totalShotsPulled: Int
    public let latestWaterHardnessDH: Double?
    public let burrWearPercentage: Double?
    public let daysSinceLastDescale: Int?
    
    // Machine Specifications
    public let pumpPressureBar: Double
    public let boilerType: String
    public let groupheadDiameterMm: Int
    public let hasSteamWand: Bool
    public let supportedBrewMethods: [String]
    public var machinePhotoData: Data? = nil
    
    public init(
        id: UUID,
        brand: String,
        modelName: String,
        machineType: String,
        totalShotsPulled: Int,
        latestWaterHardnessDH: Double? = nil,
        burrWearPercentage: Double? = nil,
        daysSinceLastDescale: Int? = nil,
        pumpPressureBar: Double = 15.0,
        boilerType: String = "Thermoblock",
        groupheadDiameterMm: Int = 0,
        hasSteamWand: Bool = true,
        supportedBrewMethods: [String] = ["Espresso", "Lungo", "Americano"],
        machinePhotoData: Data? = nil
    ) {
        self.id = id
        self.brand = brand
        self.modelName = modelName
        self.machineType = machineType
        self.totalShotsPulled = totalShotsPulled
        self.latestWaterHardnessDH = latestWaterHardnessDH
        self.burrWearPercentage = burrWearPercentage
        self.daysSinceLastDescale = daysSinceLastDescale
        self.pumpPressureBar = pumpPressureBar
        self.boilerType = boilerType
        self.groupheadDiameterMm = groupheadDiameterMm
        self.hasSteamWand = hasSteamWand
        self.supportedBrewMethods = supportedBrewMethods
        self.machinePhotoData = machinePhotoData
    }
}
