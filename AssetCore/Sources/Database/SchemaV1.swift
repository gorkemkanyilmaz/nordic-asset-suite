//
//  SchemaV1.swift
//  AssetCoreDatabase
//
//  Created for Nordic Asset Suite.
//  Strict Concurrency: Complete. SwiftData VersionedSchema with CloudKit compatibility.
//

import Foundation
import SwiftData

/// Schema Version 1 encompassing the complete domain entities for all four Nordic Asset Suite applications.
public enum SchemaV1: VersionedSchema {
    public static var versionIdentifier: Schema.Version {
        Schema.Version(1, 0, 0)
    }
    
    public static var models: [any PersistentModel.Type] {
        [
            // Appliance Warranty Manager
            ApplianceEntity.self,
            ApplianceHealthScore.self,
            FilterSpecs.self,
            EnergyEfficiencyRating.self,
            
            // Ski Gear Tracker
            SkiGearEntity.self,
            DINSettings.self,
            WaxProfile.self,
            SafetyInspectionLog.self,
            
            // E-Bike Service Tracker
            EBikeEntity.self,
            BatteryHealthMetrics.self,
            ComponentMileage.self,
            SuspensionPSI.self,
            
            // Coffee Machine Companion
            CoffeeMachineEntity.self,
            BurrProfileEntity.self,
            WaterHardnessProfile.self,
            BrewRecipe.self,
            DescalingLog.self
        ]
    }
}
