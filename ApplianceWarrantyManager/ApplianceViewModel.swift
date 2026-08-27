//
//  ApplianceViewModel.swift
//  ApplianceWarrantyManager
//
//  Created for Nordic Asset Suite.
//  Strict Concurrency: Complete. @Observable MVVM Architecture with Gemini AI & Omni-Intake.
//

import SwiftUI
import Observation
import AssetCoreDatabase
import AssetCoreUIComponents
import AssetCoreLocalization
import AssetCoreAI
import AssetCoreOCR

@Observable
@MainActor
public final class ApplianceViewModel {
    public var appliances: [ApplianceDTO] = []
    public var selectedRoom: String = "All"
    public var isLoading: Bool = false
    public var errorMessage: String? = nil
    public var showingAddScanner: Bool = false
    public var showingOnboardingGuide: Bool = false
    public var showingConfirmationModal: Bool = false
    public var detectedCandidateMatch: ProductCandidateMatch? = nil
    
    // Cached dynamic manuals & parts per model
    public var cachedManuals: [String: MaintenanceManualData] = [:]
    public var cachedParts: [String: SparePartsScheduleData] = [:]
    
    public let theme: any AppDesignTheme = ApplianceTheme()
    
    private let databaseWorker: DatabaseWorker
    private let lang = LanguageManager.shared
    
    public init(databaseWorker: DatabaseWorker) {
        self.databaseWorker = databaseWorker
    }
    
    public var availableRooms: [String] {
        var rooms = Set(appliances.map { $0.roomLocation })
        rooms.insert("All")
        return ["All"] + rooms.filter { $0 != "All" }.sorted()
    }
    
    public var filteredAppliances: [ApplianceDTO] {
        if selectedRoom == "All" {
            return appliances
        }
        return appliances.filter { $0.roomLocation == selectedRoom }
    }
    
    public var expiringSoonCount: Int {
        let ninetyDaysFromNow = Calendar.current.date(byAdding: .day, value: 90, to: Date()) ?? Date()
        return appliances.filter { $0.isWarrantyActive && $0.warrantyEndDate <= ninetyDaysFromNow }.count
    }
    
    public var averageHealthScore: Int {
        let scores = appliances.compactMap { $0.latestHealthScore }
        guard !scores.isEmpty else { return 100 }
        return scores.reduce(0, +) / scores.count
    }
    
    public func loadAppliances() async {
        isLoading = true
        errorMessage = nil
        do {
            self.appliances = try await databaseWorker.fetchAppliances()
            // If completely empty, inject starter demo sample
            if self.appliances.isEmpty {
                await injectDemoAppliances()
            }
        } catch {
            self.errorMessage = error.localizedDescription
        }
        isLoading = false
    }
    
    public func handleOmniInput(
        queryOrText: String,
        imageData: Data? = nil,
        barcode: String? = nil
    ) async {
        isLoading = true
        let match = await AIExtractionService.shared.identifyOmniProduct(
            queryOrText: queryOrText,
            imageData: imageData,
            barcode: barcode
        )
        self.detectedCandidateMatch = match
        self.showingConfirmationModal = true
        self.isLoading = false
    }
    
    public func confirmAndSaveCandidate(match: ProductCandidateMatch, room: String = "Living Room") async {
        do {
            let applianceID = try await databaseWorker.createAndInsertAppliance(
                brand: match.brand,
                modelName: match.modelName,
                serialNumber: match.serialNumber ?? "SN-\(Int.random(in: 100000...999999))",
                roomLocation: match.category.lowercased().contains("tv") || match.fullTitle.lowercased().contains("tv") ? "Living Room" : "Kitchen",
                purchaseDate: Date(),
                purchasePrice: match.estimatedPrice ?? 1499.0,
                currencyCode: match.currencyCode,
                userNotes: match.fullTitle
            )
            
            try await databaseWorker.recordApplianceHealthScore(
                applianceID: applianceID,
                score: 100,
                degradationRate: 0.8,
                remainingMonths: 120,
                flags: "REGISTERED_AI_MATCH"
            )
            
            // Prefetch manual and parts in background
            Task {
                await prefetchManualAndParts(brand: match.brand, model: match.modelName, category: match.category)
            }
            
            await loadAppliances()
        } catch {
            self.errorMessage = String(format: lang.t(.failedToSaveAsset), error.localizedDescription)
        }
    }
    
    public func addScannedAppliance(
        brand: String,
        model: String,
        serial: String,
        room: String,
        price: Decimal,
        currency: String
    ) async {
        do {
            let applianceID = try await databaseWorker.createAndInsertAppliance(
                brand: brand,
                modelName: model,
                serialNumber: serial,
                roomLocation: room,
                purchaseDate: Date(),
                purchasePrice: price,
                currencyCode: currency
            )
            // Initial baseline health score
            try await databaseWorker.recordApplianceHealthScore(
                applianceID: applianceID,
                score: 100,
                degradationRate: 1.0,
                remainingMonths: 144,
                flags: "NEW_REGISTERED"
            )
            await loadAppliances()
        } catch {
            self.errorMessage = String(format: lang.t(.failedToSaveAppliance), error.localizedDescription)
        }
    }
    
    public func prefetchManualAndParts(brand: String, model: String, category: String) async {
        let key = "\(brand)_\(model)"
        if cachedManuals[key] == nil {
            if let manual = try? await GeminiDirectClient.shared.fetchMaintenanceManual(brand: brand, modelName: model, category: category) {
                self.cachedManuals[key] = manual
            }
        }
        if cachedParts[key] == nil {
            if let parts = try? await GeminiDirectClient.shared.fetchSparePartsSchedule(brand: brand, modelName: model, category: category) {
                self.cachedParts[key] = parts
            }
        }
    }
    
    public func getManual(brand: String, model: String) -> MaintenanceManualData {
        let key = "\(brand)_\(model)"
        if let cached = cachedManuals[key] { return cached }
        
        // Fallback robust default manual
        return MaintenanceManualData(
            brand: brand,
            modelName: model,
            category: "Appliance",
            generalCareSummary: "Regular cleaning and component inspection ensures maximum energy efficiency and longevity.",
            recommendedServiceIntervalDays: 180,
            maintenanceSteps: [
                MaintenanceStep(
                    stepNumber: 1,
                    title: "Optical & Dust Cleaning",
                    detail: "Wipe air intake grills, display glass, or lint traps with a microfiber cloth.",
                    frequencyDescription: "Monthly",
                    frequencyDays: 30,
                    toolsRequired: ["Microfiber cloth", "Soft brush"],
                    iconName: "sparkles"
                ),
                MaintenanceStep(
                    stepNumber: 2,
                    title: "Seal & Gasket Check",
                    detail: "Inspect door seals or cable connections for signs of wear or cracking.",
                    frequencyDescription: "Every 90 Days",
                    frequencyDays: 90,
                    toolsRequired: ["Mild silicone wipe"],
                    iconName: "wrench.and.screwdriver"
                ),
                MaintenanceStep(
                    stepNumber: 3,
                    title: "Firmware & Calibration Check",
                    detail: "Check OEM app for software updates and perform diagnostic self-test.",
                    frequencyDescription: "Semi-Annually",
                    frequencyDays: 180,
                    toolsRequired: ["Smart App"],
                    iconName: "gear"
                )
            ],
            recommendedCleanersOrLubricants: ["Microfiber Screen Polish", "Neutral Dish Soap", "Silicone Gasket Spray"],
            safetyPrecautions: ["Always disconnect power before internal access", "Never use abrasive solvent sprays"]
        )
    }
    
    public func getPartsSchedule(brand: String, model: String) -> SparePartsScheduleData {
        let key = "\(brand)_\(model)"
        if let cached = cachedParts[key] { return cached }
        
        let isTV = model.lowercased().contains("qn85d") || model.lowercased().contains("oled") || model.lowercased().contains("tv")
        
        if isTV {
            return SparePartsScheduleData(
                brand: brand,
                modelName: model,
                parts: [
                    SparePartItem(partNumber: "BN59-01432A", name: "SolarCell Smart Remote", category: "Electronics", replacementIntervalDays: 730, estimatedCostCHF: 65, wearDegradationRateMonthly: 4.0, description: "Rechargeable solar remote control"),
                    SparePartItem(partNumber: "SOC1001-5M", name: "One Connect Fiber Cable", category: "Cable", replacementIntervalDays: 1095, estimatedCostCHF: 120, wearDegradationRateMonthly: 2.5, description: "5-meter high-bandwidth invisible connection cable"),
                    SparePartItem(partNumber: "WMN-B50EB", name: "Slim Fit Wall Mount Kit", category: "Hardware", replacementIntervalDays: 1825, estimatedCostCHF: 95, wearDegradationRateMonthly: 1.0, description: "Flush wall mounting bracket")
                ]
            )
        }
        
        return SparePartsScheduleData(
            brand: brand,
            modelName: model,
            parts: [
                SparePartItem(partNumber: "FLT-HEPA-98", name: "HEPA Intake Filter Cartridge", category: "Filter", replacementIntervalDays: 180, estimatedCostCHF: 45, wearDegradationRateMonthly: 16.0, description: "High-efficiency particulate air filter"),
                SparePartItem(partNumber: "GSK-DOOR-04", name: "Door Perimeter Gasket Seal", category: "Gasket", replacementIntervalDays: 730, estimatedCostCHF: 55, wearDegradationRateMonthly: 4.0, description: "Reinforced silicone watertight door seal"),
                SparePartItem(partNumber: "PMP-DRN-22", name: "Magnetic Drain Pump Impeller", category: "General", replacementIntervalDays: 1095, estimatedCostCHF: 85, wearDegradationRateMonthly: 3.0, description: "Quiet drainage pump assembly")
            ]
        )
    }
    
    public func injectDemoAppliances() async {
        do {
            // 1. Samsung QN85D Neo QLED Smart TV
            let tvId = try await databaseWorker.createAndInsertAppliance(
                brand: "Samsung",
                modelName: "QN85D Neo QLED 4K TV (2024)",
                serialNumber: "SN-SAM-QN85D-9912",
                roomLocation: "Living Room",
                purchaseDate: Calendar.current.date(byAdding: .month, value: -3, to: Date()) ?? Date(),
                purchasePrice: 1899.0,
                currencyCode: "CHF",
                userNotes: "65\" Neo QLED 4K Smart TV with NQ4 AI Gen2 Processor."
            )
            try await databaseWorker.recordApplianceHealthScore(
                applianceID: tvId,
                score: 98,
                degradationRate: 0.5,
                remainingMonths: 120,
                flags: "EXCELLENT_PANEL_HEALTH"
            )
            
            // 2. Miele W1 Washing Machine
            let washerId = try await databaseWorker.createAndInsertAppliance(
                brand: "Miele",
                modelName: "W1 TwinDos Washing Machine",
                serialNumber: "SN-MIELE-W1-4002",
                roomLocation: "Laundry Room",
                purchaseDate: Calendar.current.date(byAdding: .month, value: -14, to: Date()) ?? Date(),
                purchasePrice: 2150.0,
                currencyCode: "CHF",
                userNotes: "TwinDos automatic detergent dispensing system."
            )
            try await databaseWorker.recordApplianceHealthScore(
                applianceID: washerId,
                score: 92,
                degradationRate: 1.2,
                remainingMonths: 100,
                flags: "TWINDOS_ACTIVE"
            )
            
            // 3. V-ZUG AdoraWaschen V4000
            let vzugId = try await databaseWorker.createAndInsertAppliance(
                brand: "V-ZUG",
                modelName: "AdoraWaschen V4000",
                serialNumber: "SN-VZUG-2304891",
                roomLocation: "Laundry Room",
                purchaseDate: Calendar.current.date(byAdding: .month, value: -6, to: Date()) ?? Date(),
                purchasePrice: 2450.0,
                currencyCode: "CHF",
                userNotes: "Swiss-engineered precision vibration absorbing system."
            )
            try await databaseWorker.recordApplianceHealthScore(
                applianceID: vzugId,
                score: 96,
                degradationRate: 0.9,
                remainingMonths: 130,
                flags: "OPTIMAL_BALANCING"
            )
            
            self.appliances = try await databaseWorker.fetchAppliances()
        } catch {
            print("Demo injection error: \(error)")
        }
    }
}
