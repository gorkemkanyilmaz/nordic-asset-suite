//
//  DatabaseWorker.swift
//  AssetCoreDatabase
//
//  Created for Nordic Asset Suite.
//  Strict Concurrency: Complete. @ModelActor Pattern with Safe Sendable & Entity Insertion.
//

import Foundation
import SwiftData

/// Thread-safe background database worker utilizing SwiftData's @ModelActor macro.
@ModelActor
public actor DatabaseWorker {
    
    // MARK: - Appliance Warranty Operations
    
    public func fetchAppliances() throws -> [ApplianceDTO] {
        let descriptor = FetchDescriptor<ApplianceEntity>(sortBy: [SortDescriptor(\.createdAt, order: .reverse)])
        let entities = try modelContext.fetch(descriptor)
        return entities.map { entity in
            ApplianceDTO(
                id: entity.id,
                brand: entity.brand,
                modelName: entity.modelName,
                serialNumber: entity.serialNumber,
                roomLocation: entity.roomLocation,
                purchaseDate: entity.purchaseDate,
                deliveryDate: entity.deliveryDate,
                purchaseCountry: entity.purchaseCountry,
                conditionAtPurchase: entity.conditionAtPurchase,
                sellerType: entity.sellerType,
                buyerType: entity.buyerType,
                sellerName: entity.sellerName,
                manufacturerWarrantyMonths: entity.manufacturerWarrantyMonths,
                sellerGuaranteeMonths: entity.sellerGuaranteeMonths,
                extendedWarrantyMonths: entity.extendedWarrantyMonths,
                warrantyEndDate: entity.warrantyEndDate,
                purchasePrice: entity.purchasePrice,
                currencyCode: entity.currencyCode,
                latestHealthScore: entity.latestHealthScore?.score,
                filterCount: entity.filterSpecifications?.count ?? 0,
                category: "Appliance",
                userNotes: entity.userNotes
            )
        }
    }
    
    public func insertAppliance(_ appliance: ApplianceEntity) throws {
        modelContext.insert(appliance)
        try modelContext.save()
    }
    
    public func createAndInsertAppliance(
        id: UUID = UUID(),
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
        purchasePrice: Decimal = 0.0,
        currencyCode: String = "CHF",
        sellerName: String = "",
        conditionAtPurchase: String = "NEW",
        sellerType: String = "BUSINESS",
        buyerType: String = "CONSUMER",
        userNotes: String = ""
    ) throws -> UUID {
        let appliance = ApplianceEntity(
            id: id,
            brand: brand,
            modelName: modelName,
            serialNumber: serialNumber,
            roomLocation: roomLocation,
            purchaseDate: purchaseDate,
            deliveryDate: deliveryDate,
            purchaseCountry: purchaseCountry,
            manufacturerWarrantyMonths: manufacturerWarrantyMonths,
            sellerGuaranteeMonths: sellerGuaranteeMonths,
            extendedWarrantyMonths: extendedWarrantyMonths,
            purchasePrice: purchasePrice,
            currencyCode: currencyCode,
            sellerName: sellerName,
            conditionAtPurchase: conditionAtPurchase,
            sellerType: sellerType,
            buyerType: buyerType,
            userNotes: userNotes
        )
        modelContext.insert(appliance)
        try modelContext.save()
        return appliance.id
    }
    
    public func recordApplianceHealthScore(applianceID: UUID, score: Int, degradationRate: Double, remainingMonths: Int, flags: String) throws {
        let descriptor = FetchDescriptor<ApplianceEntity>(predicate: #Predicate { $0.id == applianceID })
        guard let appliance = try modelContext.fetch(descriptor).first else { return }
        
        let healthScore = ApplianceHealthScore(
            score: score,
            degradationRatePercentage: degradationRate,
            estimatedRemainingLifespanMonths: remainingMonths,
            diagnosticFlags: flags,
            calculationDate: Date(),
            appliance: appliance
        )
        modelContext.insert(healthScore)
        try modelContext.save()
    }
    
    // MARK: - Ski Gear Operations
    
    public func fetchSkiGear() throws -> [SkiGearDTO] {
        let descriptor = FetchDescriptor<SkiGearEntity>(sortBy: [SortDescriptor(\.createdAt, order: .reverse)])
        let entities = try modelContext.fetch(descriptor)
        return entities.map { entity in
            SkiGearDTO(
                id: entity.id,
                brand: entity.brand,
                modelName: entity.modelName,
                serialNumber: entity.serialNumber,
                gearCategory: entity.gearCategory,
                skiLengthCm: entity.skiLengthCm,
                bootSoleLengthMm: entity.bootSoleLengthMm,
                currentSeason: entity.currentSeason,
                isArchivedForSummer: entity.isArchivedForSummer,
                latestDIN: entity.latestDINSetting?.calculatedDIN,
                latestWaxType: entity.latestWaxProfile?.waxTypeApplied
            )
        }
    }
    
    public func insertSkiGear(_ gear: SkiGearEntity) throws {
        modelContext.insert(gear)
        try modelContext.save()
    }
    
    public func createAndInsertSkiGear(
        id: UUID = UUID(),
        brand: String,
        modelName: String,
        serialNumber: String = "",
        gearCategory: String = "Alpine Skis",
        skiLengthCm: Double = 175.0,
        bootSoleLengthMm: Int = 305
    ) throws -> UUID {
        let gear = SkiGearEntity(
            id: id,
            brand: brand,
            modelName: modelName,
            serialNumber: serialNumber,
            gearCategory: gearCategory,
            skiLengthCm: skiLengthCm,
            bootSoleLengthMm: bootSoleLengthMm
        )
        modelContext.insert(gear)
        try modelContext.save()
        return gear.id
    }
    
    public func recordDINSetting(gearID: UUID, din: Double, toe: Double, heel: Double, weight: Double, height: Double, age: Int, skierType: String, bsl: Int) throws {
        let descriptor = FetchDescriptor<SkiGearEntity>(predicate: #Predicate { $0.id == gearID })
        guard let gear = try modelContext.fetch(descriptor).first else { return }
        
        let dinSetting = DINSettings(
            calculatedDIN: din,
            visualIndicatorSettingToe: toe,
            visualIndicatorSettingHeel: heel,
            skierWeightKg: weight,
            skierHeightCm: height,
            skierAge: age,
            skierTypeRaw: skierType,
            bootSoleLengthMm: bsl,
            calculationDate: Date(),
            skiGear: gear
        )
        modelContext.insert(dinSetting)
        try modelContext.save()
    }
    
    // MARK: - E-Bike Operations
    
    public func fetchEBikes() throws -> [EBikeDTO] {
        let descriptor = FetchDescriptor<EBikeEntity>(sortBy: [SortDescriptor(\.createdAt, order: .reverse)])
        let entities = try modelContext.fetch(descriptor)
        return entities.map { entity in
            EBikeDTO(
                id: entity.id,
                brand: entity.brand,
                modelName: entity.modelName,
                frameNumber: entity.frameNumber,
                motorSystem: entity.motorSystem,
                totalOdometerKm: entity.totalOdometerKm,
                latestBatteryHealthPercentage: entity.latestBatteryHealth?.stateOfHealthPercentage,
                forkPressurePSI: entity.latestSuspensionSetting?.forkPressurePSI,
                rearShockPressurePSI: entity.latestSuspensionSetting?.rearShockPressurePSI
            )
        }
    }
    
    public func insertEBike(_ bike: EBikeEntity) throws {
        modelContext.insert(bike)
        try modelContext.save()
    }
    
    public func createAndInsertEBike(
        id: UUID = UUID(),
        brand: String,
        modelName: String,
        frameNumber: String = "",
        motorSystem: String = "Bosch Performance Line CX",
        totalOdometerKm: Double = 0.0
    ) throws -> UUID {
        let bike = EBikeEntity(
            id: id,
            brand: brand,
            modelName: modelName,
            frameNumber: frameNumber,
            motorSystem: motorSystem,
            totalOdometerKm: totalOdometerKm
        )
        modelContext.insert(bike)
        try modelContext.save()
        return bike.id
    }
    
    public func recordBatteryHealth(ebikeID: UUID, healthPct: Double, capacityWh: Double, cycles: Int, cellDiffMv: Double, tempC: Double) throws {
        let descriptor = FetchDescriptor<EBikeEntity>(predicate: #Predicate { $0.id == ebikeID })
        guard let bike = try modelContext.fetch(descriptor).first else { return }
        
        let metric = BatteryHealthMetrics(
            stateOfHealthPercentage: healthPct,
            fullChargeCapacityWh: capacityWh,
            chargeCyclesCompleted: cycles,
            cellVoltageBalanceMillivolts: cellDiffMv,
            operatingTemperatureCelsius: tempC,
            readingDate: Date(),
            ebike: bike
        )
        modelContext.insert(metric)
        try modelContext.save()
    }
    
    // MARK: - Coffee Machine Operations
    
    public func fetchCoffeeMachines() throws -> [CoffeeMachineDTO] {
        let descriptor = FetchDescriptor<CoffeeMachineEntity>(sortBy: [SortDescriptor(\.createdAt, order: .reverse)])
        let entities = try modelContext.fetch(descriptor)
        return entities.map { entity in
            let daysSinceDescale: Int? = {
                guard let lastDescale = entity.latestDescalingLog?.descalingDate else { return nil }
                return Calendar.current.dateComponents([.day], from: lastDescale, to: Date()).day
            }()
            
            return CoffeeMachineDTO(
                id: entity.id,
                brand: entity.brand,
                modelName: entity.modelName,
                machineType: entity.machineType,
                totalShotsPulled: entity.totalShotsPulled,
                latestWaterHardnessDH: entity.latestWaterHardness?.germanDegreesHardnessDH,
                burrWearPercentage: entity.burrProfiles?.first?.burrWearPercentage,
                daysSinceLastDescale: daysSinceDescale,
                pumpPressureBar: entity.pumpPressureBar,
                boilerType: entity.boilerType,
                groupheadDiameterMm: entity.groupheadDiameterMm,
                hasSteamWand: entity.hasSteamWand,
                supportedBrewMethods: entity.supportedBrewMethods,
                machinePhotoData: entity.machinePhotoData
            )
        }
    }
    
    public func insertCoffeeMachine(_ machine: CoffeeMachineEntity) throws {
        modelContext.insert(machine)
        try modelContext.save()
    }
    
    public func createAndInsertCoffeeMachine(
        id: UUID = UUID(),
        brand: String,
        modelName: String,
        machineType: String = "Superautomatic",
        totalShotsPulled: Int = 0,
        pumpPressureBar: Double = 15.0,
        boilerType: String = "Thermoblock",
        groupheadDiameterMm: Int = 0,
        hasSteamWand: Bool = true,
        supportedBrewMethods: [String] = ["Espresso", "Lungo", "Americano"]
    ) throws -> UUID {
        let machine = CoffeeMachineEntity(
            id: id,
            brand: brand,
            modelName: modelName,
            machineType: machineType,
            totalShotsPulled: totalShotsPulled,
            pumpPressureBar: pumpPressureBar,
            boilerType: boilerType,
            groupheadDiameterMm: groupheadDiameterMm,
            hasSteamWand: hasSteamWand,
            supportedBrewMethods: supportedBrewMethods
        )
        modelContext.insert(machine)
        try modelContext.save()
        return machine.id
    }
    
    public func recordDescalingCycle(machineID: UUID, chemical: String, waterLiters: Double, daysUntilNext: Int, notes: String) throws {
        let descriptor = FetchDescriptor<CoffeeMachineEntity>(predicate: #Predicate { $0.id == machineID })
        guard let machine = try modelContext.fetch(descriptor).first else { return }
        
        let log = DescalingLog(
            chemicalAgentUsed: chemical,
            waterLitersSinceLastDescale: waterLiters,
            estimatedDaysUntilNextDescale: daysUntilNext,
            isCompleteRinseConfirmed: true,
            technicianNotes: notes,
            coffeeMachine: machine
        )
        modelContext.insert(log)
        try modelContext.save()
    }
}
