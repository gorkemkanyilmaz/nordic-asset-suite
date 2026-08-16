//
//  CoffeeModels.swift
//  AssetCoreDatabase
//
//  Created for Nordic Asset Suite.
//  Strict Concurrency: Complete. SwiftData & CloudKit Compliant.
//

import Foundation
import SwiftData

// MARK: - Coffee Machine Entity (Root Asset for Coffee Machine Companion)

@Model
public final class CoffeeMachineEntity {
    public var id: UUID = UUID()
    public var brand: String = "" // e.g. Jura, Sage/Breville, La Marzocco, DeLonghi
    public var modelName: String = "" // e.g. E8, Barista Touch, Linea Micra, Magnifica S
    public var serialNumber: String = ""
    public var machineType: String = "Superautomatic" // Superautomatic, Dual Boiler Espresso, Single Boiler, Lever
    public var purchaseDate: Date = Date()
    public var totalShotsPulled: Int = 0
    public var totalWaterProcessedLiters: Double = 0.0
    public var purchasePrice: Decimal = 0.0
    public var currencyCode: String = "CHF"
    public var userNotes: String = ""
    public var machinePhotoData: Data? = nil
    public var createdAt: Date = Date()
    public var updatedAt: Date = Date()
    
    // Relationships (Optional & Defaulted for CloudKit)
    @Relationship(deleteRule: .cascade, inverse: \BurrProfileEntity.coffeeMachine)
    public var burrProfiles: [BurrProfileEntity]? = []
    
    @Relationship(deleteRule: .cascade, inverse: \WaterHardnessProfile.coffeeMachine)
    public var waterHardnessHistory: [WaterHardnessProfile]? = []
    
    @Relationship(deleteRule: .cascade, inverse: \BrewRecipe.coffeeMachine)
    public var brewRecipes: [BrewRecipe]? = []
    
    @Relationship(deleteRule: .cascade, inverse: \DescalingLog.coffeeMachine)
    public var descalingHistory: [DescalingLog]? = []
    
    public init(
        id: UUID = UUID(),
        brand: String,
        modelName: String,
        serialNumber: String = "",
        machineType: String = "Superautomatic",
        purchaseDate: Date = Date(),
        totalShotsPulled: Int = 0,
        totalWaterProcessedLiters: Double = 0.0,
        purchasePrice: Decimal = 0.0,
        currencyCode: String = "CHF",
        userNotes: String = "",
        machinePhotoData: Data? = nil
    ) {
        self.id = id
        self.brand = brand
        self.modelName = modelName
        self.serialNumber = serialNumber
        self.machineType = machineType
        self.purchaseDate = purchaseDate
        self.totalShotsPulled = totalShotsPulled
        self.totalWaterProcessedLiters = totalWaterProcessedLiters
        self.purchasePrice = purchasePrice
        self.currencyCode = currencyCode
        self.userNotes = userNotes
        self.machinePhotoData = machinePhotoData
        self.createdAt = Date()
        self.updatedAt = Date()
        self.burrProfiles = []
        self.waterHardnessHistory = []
        self.brewRecipes = []
        self.descalingHistory = []
    }
    
    public var latestWaterHardness: WaterHardnessProfile? {
        return waterHardnessHistory?.sorted(by: { $0.measuredDate > $1.measuredDate }).first
    }
    
    public var latestDescalingLog: DescalingLog? {
        return descalingHistory?.sorted(by: { $0.descalingDate > $1.descalingDate }).first
    }
}

// MARK: - Burr Profile & Lifespan Tracker

@Model
public final class BurrProfileEntity {
    public var id: UUID = UUID()
    public var burrGeometry: String = "Flat" // Flat, Conical
    public var burrMaterial: String = "Hardened Steel" // Steel, Ceramic, Titanium Nitride (TiN), DLC
    public var diameterMm: Double = 64.0
    public var ratedLifespanKg: Double = 500.0 // e.g. 500kg for steel, 1000kg for TiN
    public var totalKgGround: Double = 12.5
    public var installedDate: Date = Date()
    public var lastZeroPointCalibrationDate: Date = Date()
    public var notes: String = ""
    
    public var coffeeMachine: CoffeeMachineEntity? = nil
    
    public init(
        id: UUID = UUID(),
        burrGeometry: String = "Flat",
        burrMaterial: String = "Hardened Steel",
        diameterMm: Double = 64.0,
        ratedLifespanKg: Double = 500.0,
        totalKgGround: Double = 0.0,
        installedDate: Date = Date(),
        lastZeroPointCalibrationDate: Date = Date(),
        notes: String = "",
        coffeeMachine: CoffeeMachineEntity? = nil
    ) {
        self.id = id
        self.burrGeometry = burrGeometry
        self.burrMaterial = burrMaterial
        self.diameterMm = diameterMm
        self.ratedLifespanKg = ratedLifespanKg
        self.totalKgGround = totalKgGround
        self.installedDate = installedDate
        self.lastZeroPointCalibrationDate = lastZeroPointCalibrationDate
        self.notes = notes
        self.coffeeMachine = coffeeMachine
    }
    
    public var burrWearPercentage: Double {
        guard ratedLifespanKg > 0 else { return 0 }
        return min(100.0, (totalKgGround / ratedLifespanKg) * 100.0)
    }
}

// MARK: - Water Hardness Profile (Append-Only Calibration)

@Model
public final class WaterHardnessProfile {
    public var id: UUID = UUID()
    public var germanDegreesHardnessDH: Double = 14.0 // °dH (German Hardness scale)
    public var frenchDegreesHardnessFH: Double = 25.0 // °fH
    public var totalDissolvedSolidsPPM: Double = 220.0
    public var testStripColorMatchIndex: Int = 3 // 1 to 4 squares on Aquadur strip
    public var filterTypeInstalled: String = "Claris Smart+" // Jura Claris, BWT Bestsave, Brita
    public var measuredDate: Date = Date()
    
    public var coffeeMachine: CoffeeMachineEntity? = nil
    
    public init(
        id: UUID = UUID(),
        germanDegreesHardnessDH: Double = 14.0,
        frenchDegreesHardnessFH: Double = 25.0,
        totalDissolvedSolidsPPM: Double = 220.0,
        testStripColorMatchIndex: Int = 3,
        filterTypeInstalled: String = "Claris Smart+",
        measuredDate: Date = Date(),
        coffeeMachine: CoffeeMachineEntity? = nil
    ) {
        self.id = id
        self.germanDegreesHardnessDH = germanDegreesHardnessDH
        self.frenchDegreesHardnessFH = frenchDegreesHardnessFH
        self.totalDissolvedSolidsPPM = totalDissolvedSolidsPPM
        self.testStripColorMatchIndex = testStripColorMatchIndex
        self.filterTypeInstalled = filterTypeInstalled
        self.measuredDate = measuredDate
        self.coffeeMachine = coffeeMachine
    }
}

// MARK: - Brew Recipe & Extraction Journal

@Model
public final class BrewRecipe {
    public var id: UUID = UUID()
    public var beanOrigin: String = "Ethiopia Yirgacheffe"
    public var roasterName: String = "Miro Coffee Zurich"
    public var roastProfile: String = "Light-Medium"
    public var dryDoseGrams: Double = 18.0
    public var liquidYieldGrams: Double = 38.0
    public var extractionTimeSeconds: Double = 27.5
    public var grindSettingNumber: Double = 4.2
    public var waterTemperatureCelsius: Double = 93.5
    public var tasteRatingStars: Int = 5 // 1 to 5
    public var sensoryNotes: String = "Jasmine, bergamot, bright citrus acidity"
    public var createdAt: Date = Date()
    
    public var coffeeMachine: CoffeeMachineEntity? = nil
    
    public init(
        id: UUID = UUID(),
        beanOrigin: String,
        roasterName: String = "",
        roastProfile: String = "Medium",
        dryDoseGrams: Double = 18.0,
        liquidYieldGrams: Double = 36.0,
        extractionTimeSeconds: Double = 28.0,
        grindSettingNumber: Double = 4.0,
        waterTemperatureCelsius: Double = 93.0,
        tasteRatingStars: Int = 5,
        sensoryNotes: String = "",
        coffeeMachine: CoffeeMachineEntity? = nil
    ) {
        self.id = id
        self.beanOrigin = beanOrigin
        self.roasterName = roasterName
        self.roastProfile = roastProfile
        self.dryDoseGrams = dryDoseGrams
        self.liquidYieldGrams = liquidYieldGrams
        self.extractionTimeSeconds = extractionTimeSeconds
        self.grindSettingNumber = grindSettingNumber
        self.waterTemperatureCelsius = waterTemperatureCelsius
        self.tasteRatingStars = max(1, min(5, tasteRatingStars))
        self.sensoryNotes = sensoryNotes
        self.createdAt = Date()
        self.coffeeMachine = coffeeMachine
    }
}

// MARK: - Descaling Log (Append-Only Cycle History)

@Model
public final class DescalingLog {
    public var id: UUID = UUID()
    public var descalingDate: Date = Date()
    public var chemicalAgentUsed: String = "Citric Acid / Sulfamic Acid Solution"
    public var waterLitersSinceLastDescale: Double = 45.0
    public var nextScheduledDescaleDate: Date = Date()
    public var isCompleteRinseConfirmed: Bool = true
    public var technicianNotes: String = ""
    
    public var coffeeMachine: CoffeeMachineEntity? = nil
    
    public init(
        id: UUID = UUID(),
        descalingDate: Date = Date(),
        chemicalAgentUsed: String = "OEM Descaling Tablets",
        waterLitersSinceLastDescale: Double = 45.0,
        estimatedDaysUntilNextDescale: Int = 90,
        isCompleteRinseConfirmed: Bool = true,
        technicianNotes: String = "",
        coffeeMachine: CoffeeMachineEntity? = nil
    ) {
        self.id = id
        self.descalingDate = descalingDate
        self.chemicalAgentUsed = chemicalAgentUsed
        self.waterLitersSinceLastDescale = waterLitersSinceLastDescale
        self.nextScheduledDescaleDate = Calendar.current.date(byAdding: .day, value: estimatedDaysUntilNextDescale, to: descalingDate) ?? Date()
        self.isCompleteRinseConfirmed = isCompleteRinseConfirmed
        self.technicianNotes = technicianNotes
        self.coffeeMachine = coffeeMachine
    }
}
