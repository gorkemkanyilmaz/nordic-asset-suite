//
//  KnowledgeBaseManager.swift
//  AssetCoreKnowledgeBase
//
//  Created for Nordic Asset Suite.
//  Strict Concurrency: Complete. Seed JSON Repository & Offline Catalog Synchronizer.
//

import Foundation
import AssetCoreDatabase

/// Technical specification item loaded from local seed or CloudKit Public Database.
public struct ManufacturerSpecItem: Sendable, Identifiable, Codable {
    public let id: String
    public let brand: String
    public let model: String
    public let category: String
    public let recommendedServiceIntervalDays: Int
    public let commonErrorCodes: [String: String]
    public let standardSpareParts: [String]
    
    public init(
        id: String,
        brand: String,
        model: String,
        category: String,
        recommendedServiceIntervalDays: Int = 180,
        commonErrorCodes: [String: String] = [:],
        standardSpareParts: [String] = []
    ) {
        self.id = id
        self.brand = brand
        self.model = model
        self.category = category
        self.recommendedServiceIntervalDays = recommendedServiceIntervalDays
        self.commonErrorCodes = commonErrorCodes
        self.standardSpareParts = standardSpareParts
    }
}

/// Actor managing local pre-bundled manufacturer specifications and cloud updates.
public actor KnowledgeBaseManager {
    public static let shared = KnowledgeBaseManager()
    
    private var cachedSpecs: [String: ManufacturerSpecItem]
    
    private init() {
        self.cachedSpecs = Self.makeDefaultSeedSpecs()
    }
    
    private static func makeDefaultSeedSpecs() -> [String: ManufacturerSpecItem] {
        let defaultSpecs: [ManufacturerSpecItem] = [
            ManufacturerSpecItem(
                id: "SAMSUNG_QN85D",
                brand: "Samsung",
                model: "QN85D Neo QLED 4K",
                category: "Appliance",
                recommendedServiceIntervalDays: 365,
                commonErrorCodes: [
                    "Error 001": "HDMI Handshake timeout / HDCP failure",
                    "Error 107": "Smart Hub network connectivity failure",
                    "Error 102": "One Connect Cable disconnect or power drop"
                ],
                standardSpareParts: ["SolarCell Remote BN59", "One Connect Cable 5m", "Wall Mount Bracket VESA 400x400"]
            ),
            ManufacturerSpecItem(
                id: "MIELE_W1",
                brand: "Miele",
                model: "W1 Washing Machine",
                category: "Appliance",
                recommendedServiceIntervalDays: 180,
                commonErrorCodes: [
                    "F10": "Water intake fault - Check inlet valve or aquastop",
                    "F20": "Heating fault - NTC temperature sensor",
                    "F51": "Speed sensor / Tachogenerator fault"
                ],
                standardSpareParts: ["TwinDos Cartridges 1 & 2", "Door Gasket Seal", "Lint Filter Insert"]
            ),
            ManufacturerSpecItem(
                id: "VZUG_ADORA",
                brand: "V-ZUG",
                model: "AdoraWaschen V4000",
                category: "Appliance",
                recommendedServiceIntervalDays: 180,
                commonErrorCodes: [
                    "A2": "Drain pump blocked - Clean coin trap",
                    "A9": "Water pressure low",
                    "F6": "Motor communication bus error"
                ],
                standardSpareParts: ["Drain Pump Assembly", "Door Lock Interlock", "OptiDos Detergent Drawer"]
            ),
            ManufacturerSpecItem(
                id: "BOSCH_CX4",
                brand: "Bosch",
                model: "Performance Line CX Gen4",
                category: "EBike",
                recommendedServiceIntervalDays: 90,
                commonErrorCodes: [
                    "500": "Internal motor sensor error",
                    "510": "Temperature limit exceeded",
                    "530": "Battery communication error"
                ],
                standardSpareParts: ["Bosch PowerTube 750Wh", "Chainring 34T Direct Mount", "Shimano 12-Speed Chain"]
            ),
            ManufacturerSpecItem(
                id: "SCOTT_PATRON",
                brand: "Scott",
                model: "Patron eRIDE 900",
                category: "EBike",
                recommendedServiceIntervalDays: 90,
                commonErrorCodes: [
                    "E01": "Speed sensor misaligned with spoke magnet",
                    "E05": "Suspension TwinLoc cable tension drop"
                ],
                standardSpareParts: ["SRAM Code RSC Brake Pads", "Fox Nude T Shock Seal Kit", "Schwalbe Magic Mary 29x2.6"]
            ),
            ManufacturerSpecItem(
                id: "JURA_E8",
                brand: "Jura",
                model: "E8 Piano Black",
                category: "CoffeeMachine",
                recommendedServiceIntervalDays: 60,
                commonErrorCodes: [
                    "Error 2": "Temperature sensor NTC open loop",
                    "Error 8": "Brew group initialization resistance",
                    "Error 4": "Ceramic valve position fault"
                ],
                standardSpareParts: ["Claris Smart Filter", "Milk System Cleaner 1000ml", "Brew Group O-Ring Gaskets"]
            ),
            ManufacturerSpecItem(
                id: "STOCKLI_LASER",
                brand: "Stöckli",
                model: "Laser SL Racing",
                category: "SkiGear",
                recommendedServiceIntervalDays: 30,
                commonErrorCodes: [
                    "DIN-OUT": "Spring tension out of ISO 11088 calibration range",
                    "BASE-DRY": "Base dehydration detected - Wax saturation needed"
                ],
                standardSpareParts: ["Toko LF Blue HydroCarbon Wax", "Salomon Freeflex 14 Bindings", "Diamond Edge Stone 600G"]
            )
        ]
        
        var dict: [String: ManufacturerSpecItem] = [:]
        for spec in defaultSpecs {
            dict[spec.id] = spec
        }
        return dict
    }
    
    /// Searches for technical specifications and error code mappings.
    public func findSpec(brand: String, model: String) -> ManufacturerSpecItem? {
        let cleanBrand = brand.lowercased()
        let cleanModel = model.lowercased()
        
        return cachedSpecs.values.first { spec in
            spec.brand.lowercased().contains(cleanBrand) || cleanModel.contains(spec.model.lowercased().prefix(4))
        }
    }
    
    /// Retrieves all seed catalog specs.
    public func allSpecs() -> [ManufacturerSpecItem] {
        return Array(cachedSpecs.values)
    }
}
