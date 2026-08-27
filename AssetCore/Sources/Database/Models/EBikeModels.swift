//
//  EBikeModels.swift
//  AssetCoreDatabase
//
//  Created for Nordic Asset Suite.
//  Strict Concurrency: Complete. SwiftData & CloudKit Compliant.
//

import Foundation
import SwiftData

// MARK: - E-Bike Entity (Root Asset for E-Bike Service Tracker)

@Model
public final class EBikeEntity {
    public var id: UUID = UUID()
    public var canonicalProductId: String? = nil // References CanonicalProductEntity
    public var brand: String = ""
    public var modelName: String = ""
    public var frameNumber: String = ""
    public var motorSystem: String = "Bosch Performance Line CX" // Bosch, Shimano Steps, Brose, Yamaha, Specialized
    public var driveTrainType: String = "1x12 Derailleur" // Derailleur, Internal Gear Hub, Gates Carbon Belt
    public var totalOdometerKm: Double = 0.0
    public var purchaseDate: Date = Date()
    public var purchasePrice: Decimal = 0.0
    public var currencyCode: String = "CHF"
    public var userNotes: String = ""
    public var bikePhotoData: Data? = nil
    public var createdAt: Date = Date()
    public var updatedAt: Date = Date()
    
    // Relationships (Optional & Defaulted for CloudKit)
    @Relationship(deleteRule: .cascade, inverse: \BatteryHealthMetrics.ebike)
    public var batteryHealthHistory: [BatteryHealthMetrics]? = []
    
    @Relationship(deleteRule: .cascade, inverse: \ComponentMileage.ebike)
    public var componentHistory: [ComponentMileage]? = []
    
    @Relationship(deleteRule: .cascade, inverse: \SuspensionPSI.ebike)
    public var suspensionHistory: [SuspensionPSI]? = []
    
    public init(
        id: UUID = UUID(),
        canonicalProductId: String? = nil,
        brand: String,
        modelName: String,
        frameNumber: String = "",
        motorSystem: String = "Bosch Performance Line CX",
        driveTrainType: String = "1x12 Derailleur",
        totalOdometerKm: Double = 0.0,
        purchaseDate: Date = Date(),
        purchasePrice: Decimal = 0.0,
        currencyCode: String = "CHF",
        userNotes: String = "",
        bikePhotoData: Data? = nil
    ) {
        self.id = id
        self.canonicalProductId = canonicalProductId
        self.brand = brand
        self.modelName = modelName
        self.frameNumber = frameNumber
        self.motorSystem = motorSystem
        self.driveTrainType = driveTrainType
        self.totalOdometerKm = totalOdometerKm
        self.purchaseDate = purchaseDate
        self.purchasePrice = purchasePrice
        self.currencyCode = currencyCode
        self.userNotes = userNotes
        self.bikePhotoData = bikePhotoData
        self.createdAt = Date()
        self.updatedAt = Date()
        self.batteryHealthHistory = []
        self.componentHistory = []
        self.suspensionHistory = []
    }
    
    public var latestBatteryHealth: BatteryHealthMetrics? {
        return batteryHealthHistory?.sorted(by: { $0.readingDate > $1.readingDate }).first
    }
    
    public var latestSuspensionSetting: SuspensionPSI? {
        return suspensionHistory?.sorted(by: { $0.recordedDate > $1.recordedDate }).first
    }
}

// MARK: - Battery Health Metrics (Append-Only Telemetry Log)

@Model
public final class BatteryHealthMetrics {
    public var id: UUID = UUID()
    public var stateOfHealthPercentage: Double = 100.0 // 0.0 to 100.0%
    public var fullChargeCapacityWh: Double = 750.0 // Nominal/Actual Wh
    public var chargeCyclesCompleted: Int = 0
    public var cellVoltageBalanceMillivolts: Double = 5.0 // Difference across cell strings
    public var operatingTemperatureCelsius: Double = 22.0
    public var readingDate: Date = Date()
    public var notes: String = ""
    
    public var ebike: EBikeEntity? = nil
    
    public init(
        id: UUID = UUID(),
        stateOfHealthPercentage: Double = 100.0,
        fullChargeCapacityWh: Double = 750.0,
        chargeCyclesCompleted: Int = 0,
        cellVoltageBalanceMillivolts: Double = 5.0,
        operatingTemperatureCelsius: Double = 22.0,
        readingDate: Date = Date(),
        notes: String = "",
        ebike: EBikeEntity? = nil
    ) {
        self.id = id
        self.stateOfHealthPercentage = stateOfHealthPercentage
        self.fullChargeCapacityWh = fullChargeCapacityWh
        self.chargeCyclesCompleted = chargeCyclesCompleted
        self.cellVoltageBalanceMillivolts = cellVoltageBalanceMillivolts
        self.operatingTemperatureCelsius = operatingTemperatureCelsius
        self.readingDate = readingDate
        self.notes = notes
        self.ebike = ebike
    }
}

// MARK: - Component Mileage & Wear Tracker (Append-Only Maintenance Log)

@Model
public final class ComponentMileage {
    public var id: UUID = UUID()
    public var componentType: String = "Chain" // Chain, BrakePadFront, BrakePadRear, Cassette, Tires, ForkOil
    public var componentBrandModel: String = "Shimano CN-M8100"
    public var installedAtOdometerKm: Double = 0.0
    public var currentWearPercentage: Double = 0.0 // e.g. 0.5% (good) vs 0.75% (replace)
    public var maxLifespanKm: Double = 2500.0
    public var isReplaced: Bool = false
    public var replacementCost: Decimal = 0.0
    public var recordedDate: Date = Date()
    public var serviceNotes: String = ""
    
    public var ebike: EBikeEntity? = nil
    
    public init(
        id: UUID = UUID(),
        componentType: String,
        componentBrandModel: String = "",
        installedAtOdometerKm: Double = 0.0,
        currentWearPercentage: Double = 0.0,
        maxLifespanKm: Double = 2500.0,
        isReplaced: Bool = false,
        replacementCost: Decimal = 0.0,
        recordedDate: Date = Date(),
        serviceNotes: String = "",
        ebike: EBikeEntity? = nil
    ) {
        self.id = id
        self.componentType = componentType
        self.componentBrandModel = componentBrandModel
        self.installedAtOdometerKm = installedAtOdometerKm
        self.currentWearPercentage = currentWearPercentage
        self.maxLifespanKm = maxLifespanKm
        self.isReplaced = isReplaced
        self.replacementCost = replacementCost
        self.recordedDate = recordedDate
        self.serviceNotes = serviceNotes
        self.ebike = ebike
    }
}

// MARK: - Suspension PSI Settings (Append-Only Gauge Calibration)

@Model
public final class SuspensionPSI {
    public var id: UUID = UUID()
    public var forkPressurePSI: Double = 85.0
    public var rearShockPressurePSI: Double = 160.0
    public var riderWeightWithGearKg: Double = 80.0
    public var forkReboundClicksFromClosed: Int = 8
    public var rearReboundClicksFromClosed: Int = 6
    public var measuredSagPercentage: Double = 25.0 // 20% to 30%
    public var recordedDate: Date = Date()
    public var terrainNotes: String = "" // Enduro, Alpine Trail, Commute
    
    public var ebike: EBikeEntity? = nil
    
    public init(
        id: UUID = UUID(),
        forkPressurePSI: Double = 85.0,
        rearShockPressurePSI: Double = 160.0,
        riderWeightWithGearKg: Double = 80.0,
        forkReboundClicksFromClosed: Int = 8,
        rearReboundClicksFromClosed: Int = 6,
        measuredSagPercentage: Double = 25.0,
        recordedDate: Date = Date(),
        terrainNotes: String = "",
        ebike: EBikeEntity? = nil
    ) {
        self.id = id
        self.forkPressurePSI = forkPressurePSI
        self.rearShockPressurePSI = rearShockPressurePSI
        self.riderWeightWithGearKg = riderWeightWithGearKg
        self.forkReboundClicksFromClosed = forkReboundClicksFromClosed
        self.rearReboundClicksFromClosed = rearReboundClicksFromClosed
        self.measuredSagPercentage = measuredSagPercentage
        self.recordedDate = recordedDate
        self.terrainNotes = terrainNotes
        self.ebike = ebike
    }
}

// MARK: - Ride Session (Append-Only Ride Journal)

@Model
public final class RideSessionEntity {
    public var id: UUID = UUID()
    public var rideDate: Date = Date()
    public var distanceKm: Double = 0.0
    public var elevationGainM: Double = 0.0
    public var batteryUsedPct: Double = 0.0
    public var trailType: String = "" // Commute, Enduro, Alpine Trail, Gravel
    
    public var ebike: EBikeEntity? = nil
    
    public init(
        id: UUID = UUID(),
        rideDate: Date = Date(),
        distanceKm: Double,
        elevationGainM: Double,
        batteryUsedPct: Double,
        trailType: String = "",
        ebike: EBikeEntity? = nil
    ) {
        self.id = id
        self.rideDate = rideDate
        self.distanceKm = distanceKm
        self.elevationGainM = elevationGainM
        self.batteryUsedPct = batteryUsedPct
        self.trailType = trailType
        self.ebike = ebike
    }
}
