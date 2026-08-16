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
    public let warrantyEndDate: Date
    public let purchasePrice: Decimal
    public let currencyCode: String
    public let isWarrantyActive: Bool
    public let latestHealthScore: Int?
    public let filterCount: Int
    
    public init(
        id: UUID,
        brand: String,
        modelName: String,
        serialNumber: String,
        roomLocation: String,
        purchaseDate: Date,
        warrantyEndDate: Date,
        purchasePrice: Decimal,
        currencyCode: String,
        latestHealthScore: Int? = nil,
        filterCount: Int = 0
    ) {
        self.id = id
        self.brand = brand
        self.modelName = modelName
        self.serialNumber = serialNumber
        self.roomLocation = roomLocation
        self.purchaseDate = purchaseDate
        self.warrantyEndDate = warrantyEndDate
        self.purchasePrice = purchasePrice
        self.currencyCode = currencyCode
        self.isWarrantyActive = warrantyEndDate >= Date()
        self.latestHealthScore = latestHealthScore
        self.filterCount = filterCount
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
    
    public init(
        id: UUID,
        brand: String,
        modelName: String,
        machineType: String,
        totalShotsPulled: Int,
        latestWaterHardnessDH: Double? = nil,
        burrWearPercentage: Double? = nil,
        daysSinceLastDescale: Int? = nil
    ) {
        self.id = id
        self.brand = brand
        self.modelName = modelName
        self.machineType = machineType
        self.totalShotsPulled = totalShotsPulled
        self.latestWaterHardnessDH = latestWaterHardnessDH
        self.burrWearPercentage = burrWearPercentage
        self.daysSinceLastDescale = daysSinceLastDescale
    }
}
