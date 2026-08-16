//
//  KnowledgeBaseManager.swift
//  AssetCoreKnowledgeBase
//
//  Created for Nordic Asset Suite.
//  Strict Concurrency: Complete. Seed JSON Repository & Public CloudKit Spec Synchronizer.
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
    
    public init(
        id: String,
        brand: String,
        model: String,
        category: String,
        recommendedServiceIntervalDays: Int = 180,
        commonErrorCodes: [String: String] = [:]
    ) {
        self.id = id
        self.brand = brand
        self.model = model
        self.category = category
        self.recommendedServiceIntervalDays = recommendedServiceIntervalDays
        self.commonErrorCodes = commonErrorCodes
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
        // Pre-bundled baseline specs for top European manufacturers
        let defaultSpecs: [ManufacturerSpecItem] = [
            ManufacturerSpecItem(
                id: "MIELE_W1",
                brand: "Miele",
                model: "W1 Washing Machine",
                category: "Appliance",
                recommendedServiceIntervalDays: 180,
                commonErrorCodes: ["F10": "Water intake fault", "F20": "Heating fault", "F51": "Speed sensor fault"]
            ),
            ManufacturerSpecItem(
                id: "VZUG_ADORA",
                brand: "V-ZUG",
                model: "AdoraWaschen V4000",
                category: "Appliance",
                recommendedServiceIntervalDays: 180,
                commonErrorCodes: ["A2": "Drain pump blocked", "A9": "Water pressure low", "F6": "Motor communication error"]
            ),
            ManufacturerSpecItem(
                id: "BOSCH_CX4",
                brand: "Bosch",
                model: "Performance Line CX Gen4",
                category: "EBike",
                recommendedServiceIntervalDays: 90,
                commonErrorCodes: ["500": "Internal motor sensor error", "510": "Temperature limit exceeded"]
            ),
            ManufacturerSpecItem(
                id: "JURA_E8",
                brand: "Jura",
                model: "E8 Piano Black",
                category: "CoffeeMachine",
                recommendedServiceIntervalDays: 60,
                commonErrorCodes: ["Error 2": "Temperature sensor fault", "Error 8": "Brew group initialization failure"]
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
            spec.brand.lowercased().contains(cleanBrand) && cleanModel.contains(spec.model.lowercased().prefix(4))
        }
    }
}
