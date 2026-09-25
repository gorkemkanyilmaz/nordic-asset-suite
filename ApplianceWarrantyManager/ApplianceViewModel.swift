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
import AssetCoreSubscription

@Observable
@MainActor
public final class ApplianceViewModel {
    public var appliances: [ApplianceDTO] = []
    public var selectedRoom: String = "All"
    public var isLoading: Bool = false
    public var errorMessage: String? = nil
    public var showingAddScanner: Bool = false
    public var showingPaywall: Bool = false
    public var showingOnboardingGuide: Bool = false
    public var showingConfirmationModal: Bool = false
    public var detectedCandidateMatch: ProductCandidateMatch? = nil
    
    public func triggerAddFlow() {
        Task { @MainActor in
            let entitlements = await SubscriptionManager.shared.getCachedEntitlements()
            if !entitlements.canCreateAsset && self.appliances.count >= FreeTierLimits.maxAssets {
                self.showingPaywall = true
            } else {
                self.showingAddScanner = true
            }
        }
    }
    
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
            let isLivingRoom = match.category.lowercased().contains("tv") ||
                               match.category.lowercased().contains("electronic") ||
                               match.fullTitle.lowercased().contains("tv") ||
                               match.modelName.lowercased().contains("qn")
            let resolvedRoom = isLivingRoom ? "Living Room" : room
            let applianceID = try await databaseWorker.createAndInsertAppliance(
                brand: match.brand,
                modelName: match.modelName,
                serialNumber: match.serialNumber ?? "SN-\(Int.random(in: 100000...999999))",
                category: match.category,
                roomLocation: resolvedRoom,
                purchaseDate: Date(),
                manufacturerWarrantyMonths: match.defaultWarrantyMonths,
                purchasePrice: match.estimatedPrice ?? 1499.0,
                currencyCode: match.currencyCode,
                userNotes: match.fullTitle,
                imageUrl: match.imageUrl
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
            let category = room.lowercased().contains("living") ? "Electronics" : "Appliance"
            let img = ProductCandidateMatch.defaultImageUrl(forCategory: category, brand: brand, model: model)
            let applianceID = try await databaseWorker.createAndInsertAppliance(
                brand: brand,
                modelName: model,
                serialNumber: serial,
                category: category,
                roomLocation: room,
                purchaseDate: Date(),
                manufacturerWarrantyMonths: 24,
                purchasePrice: price,
                currencyCode: currency,
                imageUrl: img
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
        
        let lower = "\(brand) \(model)".lowercased()
        let isTV = lower.contains("qn") || lower.contains("oled") || lower.contains("qled") || lower.contains("tv") || lower.contains("television") || lower.contains("bravia") || lower.contains("frame") || lower.contains("monitor") || lower.contains("display")
        let isCoffee = lower.contains("coffee") || lower.contains("espresso") || lower.contains("cafissimo") || lower.contains("nespresso") || lower.contains("jura") || lower.contains("delonghi") || lower.contains("krups") || lower.contains("tchibo")
        
        // 1. Domain Protocol: Smart TVs, Displays & Home Electronics
        if isTV {
            return MaintenanceManualData(
                brand: brand,
                modelName: model,
                category: "Electronics",
                generalCareSummary: "Proper anti-reflective screen maintenance, ventilation clearing, and firmware updates safeguard panel longevity and prevent image retention.",
                recommendedServiceIntervalDays: 90,
                maintenanceSteps: [
                    MaintenanceStep(
                        stepNumber: 1,
                        title: "Screen & Anti-Reflective Coating Care",
                        detail: "Gently wipe the display panel using a clean, dry microfiber cloth in circular motions. Never apply chemical cleaners or window spray directly onto the screen.",
                        frequencyDescription: "Bi-Weekly",
                        frequencyDays: 14,
                        toolsRequired: ["Dry Microfiber Cloth", "Optical Lens Blower"],
                        iconName: "sparkles"
                    ),
                    MaintenanceStep(
                        stepNumber: 2,
                        title: "Ventilation Ports & Cable Integrity",
                        detail: "Clear dust buildup from rear chassis cooling vents and HDMI / One Connect connection ports using a soft anti-static brush to prevent thermal stress.",
                        frequencyDescription: "Every 90 Days",
                        frequencyDays: 90,
                        toolsRequired: ["Anti-Static Brush", "Air Duster"],
                        iconName: "air.purifier"
                    ),
                    MaintenanceStep(
                        stepNumber: 3,
                        title: "Firmware Update & Diagnostic Self-Test",
                        detail: "Run the onboard Smart TV self-diagnosis routine and check for operating system updates to ensure optimal picture processing and HDMI eARC sync.",
                        frequencyDescription: "Semi-Annually",
                        frequencyDays: 180,
                        toolsRequired: ["OEM Smart App", "Settings Diagnostic"],
                        iconName: "gear"
                    )
                ],
                recommendedCleanersOrLubricants: ["Optical Microfiber Cloth", "Anti-Static Cable Ties", "Screen-Safe Optical Wipe"],
                safetyPrecautions: ["Always disconnect power before cleaning rear connection ports", "Never apply liquid glass cleaners to the display panel", "Verify stand or wall mount stability periodically"]
            )
        }
        
        // 2. Domain Protocol: Coffee & Espresso Machines
        if isCoffee {
            return MaintenanceManualData(
                brand: brand,
                modelName: model,
                category: "CoffeeMachine",
                generalCareSummary: "Regular descaling, brew chamber flushing, and water filter renewal preserve extraction pressure and optimal coffee flavor.",
                recommendedServiceIntervalDays: 60,
                maintenanceSteps: [
                    MaintenanceStep(
                        stepNumber: 1,
                        title: "Brew Group & Drip Tray Rinse",
                        detail: "Flush the extraction chamber after brewing and clean the drip tray and grounds container to prevent mold and stale coffee oils.",
                        frequencyDescription: "Daily / Weekly",
                        frequencyDays: 7,
                        toolsRequired: ["Soft Cleaning Brush", "Warm Water"],
                        iconName: "drop.fill"
                    ),
                    MaintenanceStep(
                        stepNumber: 2,
                        title: "Thermoblock Descaling Cycle",
                        detail: "Run certified descaling solution through the water circuit to dissolve calcium deposits and maintain consistent pump pressure.",
                        frequencyDescription: "Every 60-90 Days",
                        frequencyDays: 60,
                        toolsRequired: ["Organic Descaling Solution", "Measuring Container"],
                        iconName: "sparkles"
                    ),
                    MaintenanceStep(
                        stepNumber: 3,
                        title: "Water Tank Filter Renewal",
                        detail: "Replace the internal water softener cartridge to protect internal valves from hard water scale.",
                        frequencyDescription: "Every 60 Days",
                        frequencyDays: 60,
                        toolsRequired: ["OEM Water Filter Cartridge"],
                        iconName: "gear"
                    )
                ],
                recommendedCleanersOrLubricants: ["Organic Descaling Fluid", "Coffee Degreasing Tablets", "Food-Grade Silicone Lubricant"],
                safetyPrecautions: ["Allow heating thermoblock to cool down before opening internal parts", "Rinse water reservoir thoroughly after descaling cycle"]
            )
        }
        
        // 3. Domain Protocol: Large Household Appliances (Washers, Dryers, Dishwashers)
        return MaintenanceManualData(
            brand: brand,
            modelName: model,
            category: "Appliance",
            generalCareSummary: "Periodic drum sterilization, gasket inspection, and filter maintenance ensure hygiene and leak prevention.",
            recommendedServiceIntervalDays: 90,
            maintenanceSteps: [
                MaintenanceStep(
                    stepNumber: 1,
                    title: "Lint & Coin Trap Drainage Filter",
                    detail: "Open the front service flap, drain residual water, and clean the pump impeller from foreign objects and lint.",
                    frequencyDescription: "Monthly",
                    frequencyDays: 30,
                    toolsRequired: ["Drain Tray", "Microfiber Towel"],
                    iconName: "sparkles"
                ),
                MaintenanceStep(
                    stepNumber: 2,
                    title: "Door Seal & Rubber Gasket Check",
                    detail: "Inspect the silicone door perimeter gasket for residue, moisture pooling, or signs of wear, and wipe dry with a mild cleaner.",
                    frequencyDescription: "Every 60 Days",
                    frequencyDays: 60,
                    toolsRequired: ["Mild Cleaning Wipe", "Silicone Protectant"],
                    iconName: "wrench.and.screwdriver"
                ),
                MaintenanceStep(
                    stepNumber: 3,
                    title: "High-Temperature Tub Clean Cycle",
                    detail: "Run a 90°C maintenance wash program with oxygen-based drum cleaner to eliminate limescale and biofilm.",
                    frequencyDescription: "Every 90 Days",
                    frequencyDays: 90,
                    toolsRequired: ["Appliance Drum Cleaner"],
                    iconName: "gear"
                )
            ],
            recommendedCleanersOrLubricants: ["Drum Descaler", "Silicone Gasket Seal Wipe", "Appliance Cleaner"],
            safetyPrecautions: ["Always disconnect power before accessing the drain filter", "Never use abrasive wire brushes on door seals"]
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
            let tvImg = ProductCandidateMatch.defaultImageUrl(forCategory: "Electronics", brand: "Samsung", model: "QN85D", fullTitle: "Samsung QN85D Neo QLED 4K TV")
            let tvId = try await databaseWorker.createAndInsertAppliance(
                brand: "Samsung",
                modelName: "QN85D Neo QLED 4K TV (2024)",
                serialNumber: "SN-SAM-QN85D-9912",
                category: "Electronics",
                roomLocation: "Living Room",
                purchaseDate: Calendar.current.date(byAdding: .month, value: -3, to: Date()) ?? Date(),
                manufacturerWarrantyMonths: 24,
                purchasePrice: 1899.0,
                currencyCode: "CHF",
                userNotes: "65\" Neo QLED 4K Smart TV with NQ4 AI Gen2 Processor.",
                imageUrl: tvImg
            )
            try await databaseWorker.recordApplianceHealthScore(
                applianceID: tvId,
                score: 98,
                degradationRate: 0.5,
                remainingMonths: 120,
                flags: "EXCELLENT_PANEL_HEALTH"
            )
            
            // 2. Miele W1 Washing Machine
            let washerImg = ProductCandidateMatch.defaultImageUrl(forCategory: "Appliance", brand: "Miele", model: "W1")
            let washerId = try await databaseWorker.createAndInsertAppliance(
                brand: "Miele",
                modelName: "W1 TwinDos Washing Machine",
                serialNumber: "SN-MIELE-W1-4002",
                category: "Appliance",
                roomLocation: "Laundry Room",
                purchaseDate: Calendar.current.date(byAdding: .month, value: -14, to: Date()) ?? Date(),
                manufacturerWarrantyMonths: 24,
                purchasePrice: 2150.0,
                currencyCode: "CHF",
                userNotes: "TwinDos automatic detergent dispensing system.",
                imageUrl: washerImg
            )
            try await databaseWorker.recordApplianceHealthScore(
                applianceID: washerId,
                score: 92,
                degradationRate: 1.2,
                remainingMonths: 100,
                flags: "TWINDOS_ACTIVE"
            )
            
            // 3. V-ZUG AdoraWaschen V4000
            let vzugImg = ProductCandidateMatch.defaultImageUrl(forCategory: "Appliance", brand: "V-ZUG", model: "AdoraWaschen")
            let vzugId = try await databaseWorker.createAndInsertAppliance(
                brand: "V-ZUG",
                modelName: "AdoraWaschen V4000",
                serialNumber: "SN-VZUG-2304891",
                category: "Appliance",
                roomLocation: "Laundry Room",
                purchaseDate: Calendar.current.date(byAdding: .month, value: -6, to: Date()) ?? Date(),
                manufacturerWarrantyMonths: 24,
                purchasePrice: 2450.0,
                currencyCode: "CHF",
                userNotes: "Swiss-engineered precision vibration absorbing system.",
                imageUrl: vzugImg
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
    
    // MARK: - Deletion & Vault Reset (Apple Guideline 5.1.1)
    
    public func deleteAppliance(id: UUID) async {
        do {
            try await databaseWorker.deleteAppliance(id: id)
            await loadAppliances()
        } catch {
            self.errorMessage = "Failed to delete appliance: \(error.localizedDescription)"
        }
    }
    
    public func resetLocalVault() async {
        do {
            try await databaseWorker.resetAllData()
            self.appliances = []
            self.cachedManuals = [:]
            self.cachedParts = [:]
        } catch {
            self.errorMessage = "Failed to reset local vault: \(error.localizedDescription)"
        }
    }
}
