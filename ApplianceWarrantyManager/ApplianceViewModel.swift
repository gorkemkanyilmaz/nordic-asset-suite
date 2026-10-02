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
    public var selectedTab: Int = 0
    public var isLoading: Bool = false
    public var errorMessage: String? = nil
    public var showingAddScanner: Bool = false
    public var showingPaywall: Bool = false
    public var showingOnboardingGuide: Bool = false
    public var showingConfirmationModal: Bool = false
    public var detectedCandidateMatch: ProductCandidateMatch? = nil
    
    public func switchToTab(_ tab: Int) {
        self.selectedTab = tab
    }
    
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
    
    public var expiredAppliances: [ApplianceDTO] {
        appliances.filter { !$0.isWarrantyActive }
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
            
            let syncKey = "has_synced_localhost_demo_v5"
            let hasSynced = UserDefaults.standard.bool(forKey: syncKey)
            
            // If empty, or if outdated demo data detected on TestFlight, sync with localhost
            if self.appliances.isEmpty {
                await injectDemoAppliances()
                UserDefaults.standard.set(true, forKey: syncKey)
            } else if !hasSynced {
                // If the user has old demo appliances (e.g. missing iPhone or Miele not expired)
                let hasOldDemo = self.appliances.contains { $0.serialNumber.hasPrefix("SN-SAM-QN85D-9912") || $0.serialNumber.hasPrefix("SN-VZUG-2304891") }
                if hasOldDemo && self.appliances.count <= 5 {
                    await resetLocalVault()
                    await injectDemoAppliances()
                }
                UserDefaults.standard.set(true, forKey: syncKey)
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
    
    public func updateApplianceDetails(
        id: UUID,
        purchaseDate: Date? = nil,
        deliveryDate: Date? = nil,
        purchaseCountry: String? = nil,
        roomLocation: String? = nil,
        warrantyMonths: Int? = nil,
        purchasePrice: Decimal? = nil
    ) async {
        do {
            try await databaseWorker.updateAppliance(
                id: id,
                purchaseDate: purchaseDate,
                deliveryDate: deliveryDate,
                purchaseCountry: purchaseCountry,
                roomLocation: roomLocation,
                manufacturerWarrantyMonths: warrantyMonths,
                purchasePrice: purchasePrice
            )
            self.appliances = try await databaseWorker.fetchAppliances()
        } catch {
            self.errorMessage = "Failed to update appliance: \(error.localizedDescription)"
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
    
    // MARK: - Specifications & Market Valuations
    
    public func getSpecs(brand: String, model: String) -> (specs: [(String, String)], marketRange: String) {
        let lower = "\(brand) \(model)".lowercased()
        
        // 1. Apple iPhone 16 Pro Max
        if lower.contains("iphone") {
            return (
                specs: [
                    ("Display", "6.9\" Super Retina XDR OLED ProMotion"),
                    ("Processor", "A18 Pro (3nm 6-core GPU)"),
                    ("Storage", "256GB NVMe High-Speed"),
                    ("Finish", "Grade 5 Natural Titanium")
                ],
                marketRange: "CHF 1,299 – 1,399"
            )
        }
        
        // 2. Dyson V15 Detect Absolute
        if lower.contains("dyson") || lower.contains("v15") {
            return (
                specs: [
                    ("Suction Power", "240 AW Hyperdymium Motor"),
                    ("Runtime", "Up to 60 Minutes (Eco Mode)"),
                    ("Filtration", "HEPA Filtration (99.99% to 0.1μm)"),
                    ("Weight", "3.0 kg Lightweight Cordless")
                ],
                marketRange: "CHF 699 – 799"
            )
        }
        
        // 3. Samsung QN85D Neo QLED TV
        if lower.contains("qn") || lower.contains("tv") || lower.contains("samsung") && lower.contains("85") {
            return (
                specs: [
                    ("Display", "65\" Neo QLED 4K (3840 x 2160)"),
                    ("Processor", "NQ4 AI Gen2 Processor"),
                    ("Audio", "Dolby Atmos 2.2CH 40W OTS Lite"),
                    ("Refresh Rate", "120Hz (Up to 144Hz VRR)")
                ],
                marketRange: "CHF 1,799 – 1,899"
            )
        }
        
        // 4. Miele W1 TwinDos Washing Machine
        if lower.contains("miele") || lower.contains("w1") || lower.contains("twindos") {
            return (
                specs: [
                    ("Capacity", "9.0 kg Honeycomb Drum"),
                    ("Spin Speed", "1600 RPM (A Class Spin)"),
                    ("Dispensing", "TwinDos Automatic 2-Phase"),
                    ("Motor", "ProfiEco Brushless Inverter (10-Yr)")
                ],
                marketRange: "CHF 2,050 – 2,150"
            )
        }
        
        // 5. Siemens EQ.900 Espresso System
        if lower.contains("siemens") || lower.contains("eq.900") || lower.contains("eq900") {
            return (
                specs: [
                    ("Grinder", "Dual SilentCeram Electronic"),
                    ("Pump Pressure", "19 Bar High-Extraction"),
                    ("Display", "6.8-inch iSelect TFT Color"),
                    ("Connectivity", "Home Connect WiFi Ready")
                ],
                marketRange: "CHF 2,190 – 2,450"
            )
        }
        
        // 6. Sony PlayStation 5 Pro
        if lower.contains("playstation") || lower.contains("ps5") || lower.contains("sony") {
            return (
                specs: [
                    ("GPU", "Upgraded RDNA with PSSR AI Upscaling"),
                    ("Storage", "2TB Custom NVMe High-Speed SSD"),
                    ("Video Output", "4K 120Hz / 8K Support / Ray Tracing"),
                    ("Audio", "Tempest 3D AudioTech Engine")
                ],
                marketRange: "CHF 779 – 799"
            )
        }
        
        // Default generic specifications
        return (
            specs: [
                ("Power Rating", "220-240V / 50Hz European Standard"),
                ("Connectivity", "Integrated Smart Diagnostics"),
                ("Build Quality", "Commercial-Grade Household Standard")
            ],
            marketRange: "CHF 499 – 999"
        )
    }
    
    // MARK: - Dynamic Manuals & Maintenance Protocols
    
    public func getManual(brand: String, model: String) -> MaintenanceManualData {
        let key = "\(brand)_\(model)"
        if let cached = cachedManuals[key] { return cached }
        
        let lower = "\(brand) \(model)".lowercased()
        
        // 1. Apple iPhone / Smartphones
        if lower.contains("iphone") || lower.contains("smartphone") || lower.contains("phone") {
            return MaintenanceManualData(
                brand: brand,
                modelName: model,
                category: "Electronics",
                generalCareSummary: "MagSafe wireless charging hygiene, 80% battery health protection, and Ceramic Shield inspection preserve peak performance and residual market value.",
                recommendedServiceIntervalDays: 60,
                maintenanceSteps: [
                    MaintenanceStep(
                        stepNumber: 1,
                        title: "Battery Health Optimization & Limiting",
                        detail: "Keep 80% charging limit enabled in Settings > Battery for maximum chemical cell longevity.",
                        frequencyDescription: "Always Active",
                        frequencyDays: 30,
                        toolsRequired: ["iOS Settings"],
                        iconName: "battery.100.bolt"
                    ),
                    MaintenanceStep(
                        stepNumber: 2,
                        title: "USB-C & Speaker Grille Clearing",
                        detail: "Carefully inspect and clear lint buildup from the bottom USB-C port and stereo speaker grilles using an anti-static brush.",
                        frequencyDescription: "Every 60 Days",
                        frequencyDays: 60,
                        toolsRequired: ["Anti-Static Brush", "Optical Air Blower"],
                        iconName: "sparkles"
                    ),
                    MaintenanceStep(
                        stepNumber: 3,
                        title: "Ceramic Shield & Oleophobic Conditioning",
                        detail: "Clean display glass with optical microfiber to preserve smudge-resistant oleophobic coating.",
                        frequencyDescription: "Weekly",
                        frequencyDays: 7,
                        toolsRequired: ["Dry Optical Microfiber"],
                        iconName: "iphone"
                    )
                ],
                recommendedCleanersOrLubricants: ["Optical Microfiber Towel", "Screen Cleaning Fluid (Alcohol-Free)"],
                safetyPrecautions: ["Never submerge in saltwater or hot spring water", "Avoid charging immediately after moisture exposure"]
            )
        }
        
        // 2. Dyson / Cordless Vacuums
        if lower.contains("dyson") || lower.contains("vacuum") || lower.contains("v15") {
            return MaintenanceManualData(
                brand: brand,
                modelName: model,
                category: "Cleaning Appliance",
                generalCareSummary: "Monthly HEPA filter washing under cold water, bin emptying after heavy use, and brush roller de-tangling maintain full 240 AW suction power.",
                recommendedServiceIntervalDays: 30,
                maintenanceSteps: [
                    MaintenanceStep(
                        stepNumber: 1,
                        title: "Washable Post-Motor HEPA Filter Rinse",
                        detail: "Rinse pleated filter under cold running tap water until runoff is clear; air dry for 24 hours before refit.",
                        frequencyDescription: "Monthly",
                        frequencyDays: 30,
                        toolsRequired: ["Cold Tap Water", "Drying Rack"],
                        iconName: "drop.fill"
                    ),
                    MaintenanceStep(
                        stepNumber: 2,
                        title: "Digital Motorhead Brush De-Tangling",
                        detail: "Remove end-cap coin latch and clear hair or thread wrapped around the high-torque roller bar.",
                        frequencyDescription: "Bi-Weekly",
                        frequencyDays: 14,
                        toolsRequired: ["Coin Tool", "Scissors"],
                        iconName: "wrench.and.screwdriver"
                    ),
                    MaintenanceStep(
                        stepNumber: 3,
                        title: "Acoustic Piezo Dust Sensor Inspection",
                        detail: "Wipe interior bin inlet sensor lens with a dry cloth to prevent false particulate count readings.",
                        frequencyDescription: "Every 60 Days",
                        frequencyDays: 60,
                        toolsRequired: ["Microfiber Cloth"],
                        iconName: "sparkles"
                    )
                ],
                recommendedCleanersOrLubricants: ["Cold Water Only (No Soap)", "Dry Lint-Free Microfiber"],
                safetyPrecautions: ["Never wash filter in a dishwasher or clothes washer", "Do not operate machine without filter fully dry"]
            )
        }
        
        // 3. PlayStation 5 Pro / Consoles
        if lower.contains("playstation") || lower.contains("ps5") || lower.contains("console") {
            return MaintenanceManualData(
                brand: brand,
                modelName: model,
                category: "Electronics",
                generalCareSummary: "Chassis side-plate dust catcher vacuuming, HDMI 2.1 port clearing, and DualSense joystick calibration preserve ultra-quiet thermal cooling.",
                recommendedServiceIntervalDays: 90,
                maintenanceSteps: [
                    MaintenanceStep(
                        stepNumber: 1,
                        title: "Side Faceplate Dust Catchers Vacuuming",
                        detail: "Slide off white side panels and vacuum trapped lint from the dedicated triangular dust collection ports.",
                        frequencyDescription: "Every 90 Days",
                        frequencyDays: 90,
                        toolsRequired: ["Low-Power Vacuum", "Microfiber Cloth"],
                        iconName: "air.purifier"
                    ),
                    MaintenanceStep(
                        stepNumber: 2,
                        title: "HDMI 2.1 & Rear Vent Inspection",
                        detail: "Clear exhaust heat fins behind the console to ensure unimpeded airflow and prevent thermal throttling.",
                        frequencyDescription: "Every 90 Days",
                        frequencyDays: 90,
                        toolsRequired: ["Anti-Static Brush"],
                        iconName: "fanblades"
                    ),
                    MaintenanceStep(
                        stepNumber: 3,
                        title: "DualSense Stick Centering & Cleaning",
                        detail: "Clean controller thumbstick perimeter ring from skin oils to prevent analog drift.",
                        frequencyDescription: "Monthly",
                        frequencyDays: 30,
                        toolsRequired: ["Dry Microfiber Cloth"],
                        iconName: "gamecontroller"
                    )
                ],
                recommendedCleanersOrLubricants: ["Optical Anti-Static Wipe", "Low-Pressure Air Blower"],
                safetyPrecautions: ["Always shut down completely and unplug power cable before opening faceplates", "Never use liquids inside console vents"]
            )
        }
        
        // 4. Smart TVs & Electronics
        let isTV = lower.contains("qn") || lower.contains("oled") || lower.contains("qled") || lower.contains("tv") || lower.contains("television") || lower.contains("bravia") || lower.contains("screen")
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
                        detail: "Gently wipe the display panel using a clean, dry optical microfiber cloth in gentle circular motions.",
                        frequencyDescription: "Bi-Weekly",
                        frequencyDays: 14,
                        toolsRequired: ["Dry Optical Microfiber"],
                        iconName: "sparkles"
                    ),
                    MaintenanceStep(
                        stepNumber: 2,
                        title: "Rear Chassis Vents & Cable Ports",
                        detail: "Clear dust from rear cooling vents and One Connect / HDMI ports using a soft anti-static brush.",
                        frequencyDescription: "Every 90 Days",
                        frequencyDays: 90,
                        toolsRequired: ["Anti-Static Brush", "Air Blower"],
                        iconName: "air.purifier"
                    ),
                    MaintenanceStep(
                        stepNumber: 3,
                        title: "Self-Diagnosis & Firmware Updates",
                        detail: "Run the onboard Smart TV picture & sound self-test routine to ensure optimal HDR processing.",
                        frequencyDescription: "Semi-Annually",
                        frequencyDays: 180,
                        toolsRequired: ["Settings Diagnostic"],
                        iconName: "gear"
                    )
                ],
                recommendedCleanersOrLubricants: ["Optical Microfiber Towel", "Screen-Safe Optical Cloth"],
                safetyPrecautions: ["Never apply chemical window sprays directly to the screen", "Verify wall mount tightness annually"]
            )
        }
        
        // 5. Coffee & Espresso Machines
        let isCoffee = lower.contains("coffee") || lower.contains("espresso") || lower.contains("siemens") || lower.contains("eq") || lower.contains("jura")
        if isCoffee {
            return MaintenanceManualData(
                brand: brand,
                modelName: model,
                category: "Coffee Machine",
                generalCareSummary: "Daily milk nozzle rinse, weekly brew group flushing, and descaling as prompted protect thermoblock pressure and coffee flavor.",
                recommendedServiceIntervalDays: 60,
                maintenanceSteps: [
                    MaintenanceStep(
                        stepNumber: 1,
                        title: "Brew Group Extraction Chamber Rinse",
                        detail: "Remove brewing unit and rinse under warm running tap water to dissolve accumulated coffee oils.",
                        frequencyDescription: "Weekly",
                        frequencyDays: 7,
                        toolsRequired: ["Warm Water", "Cleaning Brush"],
                        iconName: "drop.fill"
                    ),
                    MaintenanceStep(
                        stepNumber: 2,
                        title: "Automatic Milk Pipe Auto-Rinse",
                        detail: "Flush the milk aspiration tube with clean water immediately after preparing flat whites or lattes.",
                        frequencyDescription: "Daily",
                        frequencyDays: 1,
                        toolsRequired: ["Fresh Water"],
                        iconName: "cup.and.saucer.fill"
                    ),
                    MaintenanceStep(
                        stepNumber: 3,
                        title: "Calc'n Clean Organic Descale Cycle",
                        detail: "Run certified descaling solution through the water circuit when prompted by the display.",
                        frequencyDescription: "Every 60-90 Days",
                        frequencyDays: 60,
                        toolsRequired: ["Descaling Tablets", "Container"],
                        iconName: "sparkles"
                    )
                ],
                recommendedCleanersOrLubricants: ["Organic Descaling Tablets", "Degreasing Cleaning Pods"],
                safetyPrecautions: ["Never place the removable brew unit in a dishwasher", "Allow machine to cool before cleaning"]
            )
        }
        
        // 6. Large Household Appliances (Washers, Dryers)
        return MaintenanceManualData(
            brand: brand,
            modelName: model,
            category: "Appliance",
            generalCareSummary: "90°C hygiene drum sanitization, TwinDos care line flushing, and coin trap drainage prevent odor, mold, and water leaks.",
            recommendedServiceIntervalDays: 60,
            maintenanceSteps: [
                MaintenanceStep(
                    stepNumber: 1,
                    title: "TwinDos Care Cleaning Line Flush",
                    detail: "Insert TwinDos Care flushing cartridge and run the maintenance program to prevent detergent crystallization.",
                    frequencyDescription: "Every 60 Days",
                    frequencyDays: 60,
                    toolsRequired: ["TwinDos Care Cartridge"],
                    iconName: "sparkles"
                ),
                MaintenanceStep(
                    stepNumber: 2,
                    title: "Lint & Coin Trap Drainage Filter",
                    detail: "Open the front service flap, drain residual water, and clean the pump impeller from coins and lint.",
                    frequencyDescription: "Monthly",
                    frequencyDays: 30,
                    toolsRequired: ["Drain Tray", "Towel"],
                    iconName: "wrench.and.screwdriver"
                ),
                MaintenanceStep(
                    stepNumber: 3,
                    title: "High-Temperature 90°C Tub Clean",
                    detail: "Run a 90°C wash cycle with oxygen-based drum cleaner to eliminate limescale and biofilm.",
                    frequencyDescription: "Every 60 Days",
                    frequencyDays: 60,
                    toolsRequired: ["Appliance Drum Cleaner"],
                    iconName: "gear"
                )
            ],
            recommendedCleanersOrLubricants: ["Appliance Drum Cleaner", "Silicone Gasket Seal Wipe"],
            safetyPrecautions: ["Disconnect power before inspecting drainage pump filter", "Never use wire brushes on door seals"]
        )
    }
    
    // MARK: - Spare Parts Schedules
    
    public func getPartsSchedule(brand: String, model: String) -> SparePartsScheduleData {
        let key = "\(brand)_\(model)"
        if let cached = cachedParts[key] { return cached }
        
        let lower = "\(brand) \(model)".lowercased()
        
        // 1. Apple iPhone
        if lower.contains("iphone") {
            return SparePartsScheduleData(
                brand: brand,
                modelName: model,
                parts: [
                    SparePartItem(partNumber: "MT4G3ZM/A", name: "FineWoven MagSafe Wallet Case", category: "Accessory", replacementIntervalDays: 365, estimatedCostCHF: 69, wearDegradationRateMonthly: 8.0, description: "Official Apple MagSafe protective case"),
                    SparePartItem(partNumber: "APL-SCR-16P", name: "Ceramic Shield Glass Protector", category: "Accessory", replacementIntervalDays: 180, estimatedCostCHF: 39, wearDegradationRateMonthly: 12.0, description: "High-impact edge-to-edge optical protector"),
                    SparePartItem(partNumber: "A3296", name: "Apple Genuine Battery Assembly", category: "Battery", replacementIntervalDays: 1095, estimatedCostCHF: 119, wearDegradationRateMonthly: 2.5, description: "Official replacement battery module")
                ]
            )
        }
        
        // 2. Dyson V15 Detect
        if lower.contains("dyson") || lower.contains("v15") {
            return SparePartsScheduleData(
                brand: brand,
                modelName: model,
                parts: [
                    SparePartItem(partNumber: "DYS-970013-02", name: "Washable Post-Motor HEPA Filter", category: "Consumable", replacementIntervalDays: 180, estimatedCostCHF: 35, wearDegradationRateMonthly: 15.0, description: "Official 99.99% HEPA filtration cartridge"),
                    SparePartItem(partNumber: "DYS-971360-01", name: "Fluffy Optic Cleaner Roller Bar", category: "Roller", replacementIntervalDays: 365, estimatedCostCHF: 49, wearDegradationRateMonthly: 7.0, description: "Illuminated soft roller brush head"),
                    SparePartItem(partNumber: "DYS-BAT-V15", name: "Click-in 7-Cell Battery Pack", category: "Battery", replacementIntervalDays: 730, estimatedCostCHF: 139, wearDegradationRateMonthly: 3.5, description: "Fade-free high-density power cell")
                ]
            )
        }
        
        // 3. Samsung TV
        if lower.contains("qn") || lower.contains("tv") || lower.contains("samsung") {
            return SparePartsScheduleData(
                brand: brand,
                modelName: model,
                parts: [
                    SparePartItem(partNumber: "BN59-01432A", name: "SolarCell Smart Remote Control", category: "Accessory", replacementIntervalDays: 730, estimatedCostCHF: 65, wearDegradationRateMonthly: 4.0, description: "Solar-charging Bluetooth voice remote"),
                    SparePartItem(partNumber: "SOC1001-5M", name: "One Connect Invisible Cable", category: "Cable", replacementIntervalDays: 1095, estimatedCostCHF: 120, wearDegradationRateMonthly: 2.5, description: "5-meter high-bandwidth fiber connection"),
                    SparePartItem(partNumber: "WMN-B50EB", name: "Slim Fit Flush Wall Mount Kit", category: "Hardware", replacementIntervalDays: 1825, estimatedCostCHF: 95, wearDegradationRateMonthly: 1.0, description: "Ultra-flush mounting bracket")
                ]
            )
        }
        
        // 4. Miele Washer
        if lower.contains("miele") || lower.contains("w1") {
            return SparePartsScheduleData(
                brand: brand,
                modelName: model,
                parts: [
                    SparePartItem(partNumber: "ML-TWIN-01", name: "TwinDos Care Cleaning Cartridge", category: "Consumable", replacementIntervalDays: 90, estimatedCostCHF: 34, wearDegradationRateMonthly: 33.0, description: "Flushing agent for TwinDos dispensing lines"),
                    SparePartItem(partNumber: "ML-UPH-12", name: "UltraPhase 1 & 2 Detergent Set", category: "Consumable", replacementIntervalDays: 60, estimatedCostCHF: 45, wearDegradationRateMonthly: 50.0, description: "2-phase enzyme detergent set"),
                    SparePartItem(partNumber: "ML-DRN-FLT", name: "Pump Impeller Coin Trap Filter", category: "Filter", replacementIntervalDays: 730, estimatedCostCHF: 48, wearDegradationRateMonthly: 3.0, description: "Replacement drainage pump filter basket")
                ]
            )
        }
        
        // 5. Siemens EQ.900
        if lower.contains("siemens") || lower.contains("eq") {
            return SparePartsScheduleData(
                brand: brand,
                modelName: model,
                parts: [
                    SparePartItem(partNumber: "TZ70033", name: "Intenzia Water Filter Cartridge", category: "Consumable", replacementIntervalDays: 60, estimatedCostCHF: 16.50, wearDegradationRateMonthly: 45.0, description: "Protects thermoblock from hard water scale"),
                    SparePartItem(partNumber: "TZ80002A", name: "2-in-1 Calc'n Clean Descaling Tabs", category: "Consumable", replacementIntervalDays: 90, estimatedCostCHF: 18, wearDegradationRateMonthly: 30.0, description: "Fast-dissolving organic descaling formula"),
                    SparePartItem(partNumber: "TZ80004A", name: "Milk Pipe & Nozzle Silicone Tube Set", category: "Accessory", replacementIntervalDays: 180, estimatedCostCHF: 24, wearDegradationRateMonthly: 15.0, description: "Food-grade milk system delivery hose")
                ]
            )
        }
        
        // 6. PlayStation 5 Pro
        if lower.contains("playstation") || lower.contains("ps5") {
            return SparePartsScheduleData(
                brand: brand,
                modelName: model,
                parts: [
                    SparePartItem(partNumber: "CFI-ZCT1W", name: "Sony DualSense Wireless Controller", category: "Accessory", replacementIntervalDays: 730, estimatedCostCHF: 79, wearDegradationRateMonthly: 5.0, description: "Haptic feedback precision controller"),
                    SparePartItem(partNumber: "CFI-ZCS2", name: "Vertical Stand & Secure Mount", category: "Hardware", replacementIntervalDays: 1825, estimatedCostCHF: 35, wearDegradationRateMonthly: 1.0, description: "Brushed aluminum vertical stabilizer"),
                    SparePartItem(partNumber: "SNY-HDMI-21", name: "Ultra High Speed HDMI 2.1 Cable", category: "Cable", replacementIntervalDays: 1095, estimatedCostCHF: 32, wearDegradationRateMonthly: 2.0, description: "48 Gbps 4K 120Hz / 8K certified cable")
                ]
            )
        }
        
        // Fallback generic parts
        return SparePartsScheduleData(
            brand: brand,
            modelName: model,
            parts: [
                SparePartItem(partNumber: "FLT-HEPA-98", name: "HEPA Intake Filter Cartridge", category: "Filter", replacementIntervalDays: 180, estimatedCostCHF: 45, wearDegradationRateMonthly: 16.0, description: "High-efficiency particulate air filter"),
                SparePartItem(partNumber: "GSK-DOOR-04", name: "Door Perimeter Gasket Seal", category: "Gasket", replacementIntervalDays: 730, estimatedCostCHF: 55, wearDegradationRateMonthly: 4.0, description: "Watertight perimeter seal"),
                SparePartItem(partNumber: "PMP-DRN-22", name: "Magnetic Drain Pump Impeller", category: "General", replacementIntervalDays: 1095, estimatedCostCHF: 85, wearDegradationRateMonthly: 3.0, description: "Quiet drainage pump assembly")
            ]
        )
    }
    
    // MARK: - Initial Demo Injection (Mirrors Localhost Exactly)
    
    public func injectDemoAppliances() async {
        do {
            // 1. Apple iPhone 16 Pro Max (Active)
            let phoneImg = "https://images.unsplash.com/photo-1592750475338-74b7b21085ab?w=800&auto=format&fit=crop&q=80"
            let phoneId = try await databaseWorker.createAndInsertAppliance(
                brand: "Apple",
                modelName: "iPhone 16 Pro Max",
                serialNumber: "SN-APL-9281720",
                category: "Smartphone",
                roomLocation: "Personal / Pocket",
                purchaseDate: Calendar.current.date(from: DateComponents(year: 2025, month: 9, day: 20)) ?? Date(),
                deliveryDate: Calendar.current.date(from: DateComponents(year: 2025, month: 9, day: 22)),
                purchaseCountry: "CH",
                manufacturerWarrantyMonths: 12,
                purchasePrice: 1349.0,
                currencyCode: "CHF",
                sellerName: "Apple Store Bahnhofstrasse",
                userNotes: "Apple iPhone 16 Pro Max (256GB Natural Titanium)",
                imageUrl: phoneImg
            )
            try await databaseWorker.recordApplianceHealthScore(
                applianceID: phoneId,
                score: 99,
                degradationRate: 0.3,
                remainingMonths: 150,
                flags: "BATTERY_CYCLE_OPTIMAL"
            )
            
            // 2. Dyson V15 Detect Absolute (Active)
            let dysonImg = "https://images.unsplash.com/photo-1527515637462-cff94eecc1ac?w=800&auto=format&fit=crop&q=80"
            let dysonId = try await databaseWorker.createAndInsertAppliance(
                brand: "Dyson",
                modelName: "V15 Detect Absolute",
                serialNumber: "SN-DYS-719302",
                category: "Cleaning Appliance",
                roomLocation: "Hallway Closet",
                purchaseDate: Calendar.current.date(from: DateComponents(year: 2026, month: 2, day: 15)) ?? Date(),
                deliveryDate: Calendar.current.date(from: DateComponents(year: 2026, month: 2, day: 18)),
                purchaseCountry: "CH",
                manufacturerWarrantyMonths: 24,
                purchasePrice: 749.0,
                currencyCode: "CHF",
                sellerName: "Fust AG",
                userNotes: "Dyson V15 Detect Cordless Vacuum Cleaner",
                imageUrl: dysonImg
            )
            try await databaseWorker.recordApplianceHealthScore(
                applianceID: dysonId,
                score: 99,
                degradationRate: 0.4,
                remainingMonths: 140,
                flags: "PIEZO_SENSOR_CALIBRATED"
            )
            
            // 3. Samsung QN85D Neo QLED Smart TV (Active)
            let tvImg = "https://images.unsplash.com/photo-1593784991095-a205069470b6?w=800&auto=format&fit=crop&q=80"
            let tvId = try await databaseWorker.createAndInsertAppliance(
                brand: "Samsung",
                modelName: "65\" QN85D Neo QLED 4K TV",
                serialNumber: "SN-SAM-982143",
                category: "Electronics",
                roomLocation: "Living Room",
                purchaseDate: Calendar.current.date(from: DateComponents(year: 2025, month: 6, day: 15)) ?? Date(),
                deliveryDate: Calendar.current.date(from: DateComponents(year: 2025, month: 6, day: 18)),
                purchaseCountry: "CH",
                manufacturerWarrantyMonths: 24,
                purchasePrice: 1899.0,
                currencyCode: "CHF",
                sellerName: "Digitec Galaxus AG",
                userNotes: "Samsung 65\" QN85D Neo QLED 4K Smart TV",
                imageUrl: tvImg
            )
            try await databaseWorker.recordApplianceHealthScore(
                applianceID: tvId,
                score: 98,
                degradationRate: 0.5,
                remainingMonths: 120,
                flags: "EXCELLENT_PANEL_HEALTH"
            )
            
            // 4. Miele W1 TwinDos Washing Machine (EXPIRED! Exactly as on localhost)
            // Purchased 2023-08-15 -> 24 Months Warranty ended on 2025-08-15!
            let washerImg = "https://images.unsplash.com/photo-1626806787461-102c1bfaaea1?w=800&auto=format&fit=crop&q=80"
            let washerId = try await databaseWorker.createAndInsertAppliance(
                brand: "Miele",
                modelName: "W1 TwinDos (WCR870 WPS)",
                serialNumber: "SN-MIE-441920",
                category: "Appliance",
                roomLocation: "Laundry Room",
                purchaseDate: Calendar.current.date(from: DateComponents(year: 2023, month: 8, day: 15)) ?? Date(),
                deliveryDate: Calendar.current.date(from: DateComponents(year: 2023, month: 8, day: 18)),
                purchaseCountry: "CH",
                manufacturerWarrantyMonths: 24,
                purchasePrice: 2099.0,
                currencyCode: "CHF",
                sellerName: "Fust AG",
                userNotes: "Miele W1 ChromeEdition Washing Machine",
                imageUrl: washerImg
            )
            try await databaseWorker.recordApplianceHealthScore(
                applianceID: washerId,
                score: 92,
                degradationRate: 1.2,
                remainingMonths: 90,
                flags: "TWINDOS_ACTIVE"
            )
            
            // 5. Siemens EQ.900 Plus Espresso System (Active)
            let siemensImg = "https://images.unsplash.com/photo-1510591509098-f4fdc6d0ff04?w=800&auto=format&fit=crop&q=80"
            let siemensId = try await databaseWorker.createAndInsertAppliance(
                brand: "Siemens",
                modelName: "EQ.900 Plus (TI9553X9RW)",
                serialNumber: "SN-SIE-984210",
                category: "Coffee Machine",
                roomLocation: "Kitchen Counter",
                purchaseDate: Calendar.current.date(from: DateComponents(year: 2025, month: 1, day: 15)) ?? Date(),
                deliveryDate: Calendar.current.date(from: DateComponents(year: 2025, month: 1, day: 18)),
                purchaseCountry: "CH",
                manufacturerWarrantyMonths: 24,
                purchasePrice: 2299.0,
                currencyCode: "CHF",
                sellerName: "MediaMarkt Schweiz AG",
                userNotes: "Siemens EQ.900 Plus Automatic Espresso System",
                imageUrl: siemensImg
            )
            try await databaseWorker.recordApplianceHealthScore(
                applianceID: siemensId,
                score: 95,
                degradationRate: 0.7,
                remainingMonths: 110,
                flags: "DUAL_GRINDER_OPTIMAL"
            )
            
            // 6. Sony PlayStation 5 Pro (Active)
            let ps5Img = "https://images.unsplash.com/photo-1606813907291-d86efa9b94db?w=800&auto=format&fit=crop&q=80"
            let ps5Id = try await databaseWorker.createAndInsertAppliance(
                brand: "Sony",
                modelName: "PlayStation 5 Pro",
                serialNumber: "SN-SNY-884029",
                category: "Electronics",
                roomLocation: "Living Room",
                purchaseDate: Calendar.current.date(from: DateComponents(year: 2024, month: 11, day: 7)) ?? Date(),
                deliveryDate: Calendar.current.date(from: DateComponents(year: 2024, month: 11, day: 10)),
                purchaseCountry: "CH",
                manufacturerWarrantyMonths: 12,
                purchasePrice: 799.0,
                currencyCode: "CHF",
                sellerName: "Digitec Galaxus AG",
                userNotes: "Sony PlayStation 5 Pro 2TB Console",
                imageUrl: ps5Img
            )
            try await databaseWorker.recordApplianceHealthScore(
                applianceID: ps5Id,
                score: 98,
                degradationRate: 0.4,
                remainingMonths: 130,
                flags: "RDNA_GPU_CALIBRATED"
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
