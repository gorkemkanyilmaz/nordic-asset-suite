//
//  SkiGearModels.swift
//  AssetCoreDatabase
//
//  Created for Nordic Asset Suite.
//  Strict Concurrency: Complete. SwiftData & CloudKit Compliant.
//

import Foundation
import SwiftData

// MARK: - Ski Gear Entity (Root Asset for Ski Gear Tracker)

@Model
public final class SkiGearEntity {
    public var id: UUID = UUID()
    public var canonicalProductId: String? = nil // References CanonicalProductEntity
    public var brand: String = ""
    public var modelName: String = ""
    public var serialNumber: String = ""
    public var gearCategory: String = "Alpine Skis" // Alpine Skis, Touring Skis, Snowboard, Boots, Bindings
    public var skiLengthCm: Double = 175.0
    public var bootSoleLengthMm: Int = 305 // e.g. 305 mm
    public var flexIndex: Int = 110
    public var purchaseDate: Date = Date()
    public var daysSkiedCount: Int = 0
    public var currentSeason: String = "2025/2026"
    public var isArchivedForSummer: Bool = false
    public var userNotes: String = ""
    public var gearPhotoData: Data? = nil
    public var createdAt: Date = Date()
    public var updatedAt: Date = Date()
    
    // Relationships (Optional & Defaulted for CloudKit)
    @Relationship(deleteRule: .cascade, inverse: \DINSettings.skiGear)
    public var dinHistory: [DINSettings]? = []
    
    @Relationship(deleteRule: .cascade, inverse: \WaxProfile.skiGear)
    public var waxHistory: [WaxProfile]? = []
    
    @Relationship(deleteRule: .cascade, inverse: \SafetyInspectionLog.skiGear)
    public var safetyInspectionHistory: [SafetyInspectionLog]? = []
    
    public init(
        id: UUID = UUID(),
        canonicalProductId: String? = nil,
        brand: String,
        modelName: String,
        serialNumber: String = "",
        gearCategory: String = "Alpine Skis",
        skiLengthCm: Double = 175.0,
        bootSoleLengthMm: Int = 305,
        flexIndex: Int = 110,
        purchaseDate: Date = Date(),
        daysSkiedCount: Int = 0,
        currentSeason: String = "2025/2026",
        isArchivedForSummer: Bool = false,
        userNotes: String = "",
        gearPhotoData: Data? = nil
    ) {
        self.id = id
        self.canonicalProductId = canonicalProductId
        self.brand = brand
        self.modelName = modelName
        self.serialNumber = serialNumber
        self.gearCategory = gearCategory
        self.skiLengthCm = skiLengthCm
        self.bootSoleLengthMm = bootSoleLengthMm
        self.flexIndex = flexIndex
        self.purchaseDate = purchaseDate
        self.daysSkiedCount = daysSkiedCount
        self.currentSeason = currentSeason
        self.isArchivedForSummer = isArchivedForSummer
        self.userNotes = userNotes
        self.gearPhotoData = gearPhotoData
        self.createdAt = Date()
        self.updatedAt = Date()
        self.dinHistory = []
        self.waxHistory = []
        self.safetyInspectionHistory = []
    }
    
    public var latestDINSetting: DINSettings? {
        return dinHistory?.sorted(by: { $0.calculationDate > $1.calculationDate }).first
    }
    
    public var latestWaxProfile: WaxProfile? {
        return waxHistory?.sorted(by: { $0.applicationDate > $1.applicationDate }).first
    }
    
    public var latestInspection: SafetyInspectionLog? {
        return safetyInspectionHistory?.sorted(by: { $0.inspectionDate > $1.inspectionDate }).first
    }
}

// MARK: - DIN Settings (Append-Only Historical Calculation)

@Model
public final class DINSettings {
    public var id: UUID = UUID()
    public var calculatedDIN: Double = 6.5
    public var visualIndicatorSettingToe: Double = 6.5
    public var visualIndicatorSettingHeel: Double = 6.5
    public var skierWeightKg: Double = 75.0
    public var skierHeightCm: Double = 180.0
    public var skierAge: Int = 32
    public var skierTypeRaw: String = "Type II" // Type I (Cautious), Type II (Moderate), Type III (Aggressive), Type III+
    public var bootSoleLengthMm: Int = 305
    public var calculationDate: Date = Date()
    public var technicianNotes: String = ""
    
    public var skiGear: SkiGearEntity? = nil
    
    public init(
        id: UUID = UUID(),
        calculatedDIN: Double,
        visualIndicatorSettingToe: Double,
        visualIndicatorSettingHeel: Double,
        skierWeightKg: Double,
        skierHeightCm: Double,
        skierAge: Int,
        skierTypeRaw: String = "Type II",
        bootSoleLengthMm: Int,
        calculationDate: Date = Date(),
        technicianNotes: String = "",
        skiGear: SkiGearEntity? = nil
    ) {
        self.id = id
        self.calculatedDIN = calculatedDIN
        self.visualIndicatorSettingToe = visualIndicatorSettingToe
        self.visualIndicatorSettingHeel = visualIndicatorSettingHeel
        self.skierWeightKg = skierWeightKg
        self.skierHeightCm = skierHeightCm
        self.skierAge = skierAge
        self.skierTypeRaw = skierTypeRaw
        self.bootSoleLengthMm = bootSoleLengthMm
        self.calculationDate = calculationDate
        self.technicianNotes = technicianNotes
        self.skiGear = skiGear
    }
}

// MARK: - Wax Profile (Append-Only Application Record)

@Model
public final class WaxProfile {
    public var id: UUID = UUID()
    public var snowTemperatureCelsius: Double = -4.0
    public var snowType: String = "Packed Powder" // Powder, Wet Spring, Icy Hardpack, Glaciated
    public var waxTypeApplied: String = "Hydrocarbon All-Temp"
    public var ironTemperatureCelsius: Int = 135
    public var edgeSharpeningAngleDegrees: Double = 88.0
    public var baseStructurePattern: String = "Linear Medium"
    public var applicationDate: Date = Date()
    public var technicianNotes: String = ""
    
    public var skiGear: SkiGearEntity? = nil
    
    public init(
        id: UUID = UUID(),
        snowTemperatureCelsius: Double = -4.0,
        snowType: String = "Packed Powder",
        waxTypeApplied: String,
        ironTemperatureCelsius: Int = 135,
        edgeSharpeningAngleDegrees: Double = 88.0,
        baseStructurePattern: String = "Linear Medium",
        applicationDate: Date = Date(),
        technicianNotes: String = "",
        skiGear: SkiGearEntity? = nil
    ) {
        self.id = id
        self.snowTemperatureCelsius = snowTemperatureCelsius
        self.snowType = snowType
        self.waxTypeApplied = waxTypeApplied
        self.ironTemperatureCelsius = ironTemperatureCelsius
        self.edgeSharpeningAngleDegrees = edgeSharpeningAngleDegrees
        self.baseStructurePattern = baseStructurePattern
        self.applicationDate = applicationDate
        self.technicianNotes = technicianNotes
        self.skiGear = skiGear
    }
}

// MARK: - Safety Inspection Log (Append-Only Torque Machine Audit)

@Model
public final class SafetyInspectionLog {
    public var id: UUID = UUID()
    public var inspectionDate: Date = Date()
    public var releaseTorqueToeNm: Double = 52.0
    public var releaseTorqueHeelNm: Double = 180.0
    public var isPassed: Bool = true
    public var certifiedTechnicianName: String = ""
    public var calibrationMachineModel: String = "Montana Max 4"
    public var inspectionNotes: String = ""
    
    public var skiGear: SkiGearEntity? = nil
    
    public init(
        id: UUID = UUID(),
        inspectionDate: Date = Date(),
        releaseTorqueToeNm: Double,
        releaseTorqueHeelNm: Double,
        isPassed: Bool = true,
        certifiedTechnicianName: String = "",
        calibrationMachineModel: String = "",
        inspectionNotes: String = "",
        skiGear: SkiGearEntity? = nil
    ) {
        self.id = id
        self.inspectionDate = inspectionDate
        self.releaseTorqueToeNm = releaseTorqueToeNm
        self.releaseTorqueHeelNm = releaseTorqueHeelNm
        self.isPassed = isPassed
        self.certifiedTechnicianName = certifiedTechnicianName
        self.calibrationMachineModel = calibrationMachineModel
        self.inspectionNotes = inspectionNotes
        self.skiGear = skiGear
    }
}
