//
//  CoffeeViewModel.swift
//  CoffeeMachineCompanion
//
//  Created for Nordic Asset Suite.
//  Strict Concurrency: Complete. @Observable Barista & Chemistry State Manager with Gemini AI.
//

import SwiftUI
import Observation
import UserNotifications
import AssetCoreDatabase
import AssetCoreUIComponents
import AssetCoreAI
import AssetCoreOCR

@Observable
@MainActor
public final class CoffeeViewModel {
    public var machines: [CoffeeMachineDTO] = []
    public var isLoading: Bool = false
    public var errorMessage: String? = nil
    public var showingOnboardingGuide: Bool = false
    public var showingLiveScanner: Bool = false
    public var detectedCandidateMatch: ProductCandidateMatch? = nil
    
    // Chemistry & Barista State
    public var waterHardnessDH: Double = 14.0 // 14 °dH
    public var hasActiveFilter: Bool = true
    
    public let theme: any AppDesignTheme = CoffeeTheme()
    
    private let databaseWorker: DatabaseWorker
    
    public init(databaseWorker: DatabaseWorker) {
        self.databaseWorker = databaseWorker
    }
    
    public var currentMachine: CoffeeMachineDTO? {
        return machines.first
    }
    
    public var allowedLitersUntilDescale: Double {
        CoffeeChemistryCalculator.shared.calculateLitersUntilDescale(
            germanDegreesDH: waterHardnessDH,
            isFilterCartridgeActive: hasActiveFilter
        )
    }
    
    public func loadMachines() async {
        isLoading = true
        errorMessage = nil
        do {
            self.machines = try await databaseWorker.fetchCoffeeMachines()
            if self.machines.isEmpty {
                await injectDemoMachine()
            }
        } catch {
            self.errorMessage = error.localizedDescription
        }
        isLoading = false
    }
    
    public func addMachine(
        brand: String,
        model: String,
        machineType: String,
        pumpPressureBar: Double = 15.0,
        boilerType: String = "Thermoblock",
        groupheadDiameterMm: Int = 0,
        hasSteamWand: Bool = true,
        supportedBrewMethods: [String] = ["Espresso", "Lungo", "Americano"]
    ) async {
        do {
            let machineID = try await databaseWorker.createAndInsertCoffeeMachine(
                brand: brand,
                modelName: model,
                machineType: machineType,
                totalShotsPulled: 342,
                pumpPressureBar: pumpPressureBar,
                boilerType: boilerType,
                groupheadDiameterMm: groupheadDiameterMm,
                hasSteamWand: hasSteamWand,
                supportedBrewMethods: supportedBrewMethods
            )
            try await databaseWorker.recordDescalingCycle(
                machineID: machineID,
                chemical: "Claris 2-Phase Descaling Tablets",
                waterLiters: 45.0,
                daysUntilNext: 60,
                notes: "Initial setup descaling baseline."
            )
            await loadMachines()
        } catch {
            self.errorMessage = "Failed to save coffee machine: \(error.localizedDescription)"
        }
    }
    
    public func injectDemoMachine() async {
        do {
            let machineID = try await databaseWorker.createAndInsertCoffeeMachine(
                brand: "Jura",
                modelName: "E8 Piano Black (Gen 3)",
                machineType: "Superautomatic Espresso",
                totalShotsPulled: 428,
                pumpPressureBar: 15.0,
                boilerType: "Thermoblock",
                groupheadDiameterMm: 0,    // Integrated brew group (superauto)
                hasSteamWand: true,
                supportedBrewMethods: ["Espresso", "Lungo", "Americano", "Ristretto", "Flat White"]
            )
            try await databaseWorker.recordDescalingCycle(
                machineID: machineID,
                chemical: "Jura 3-Phase Descaling Tablets",
                waterLiters: 35.0,
                daysUntilNext: 42,
                notes: "Claris Smart+ Filter Cartridge Installed"
            )
            self.machines = try await databaseWorker.fetchCoffeeMachines()
        } catch {
            print("Coffee demo injection error: \(error)")
        }
    }
    
    public func getCoffeeManual() -> MaintenanceManualData {
        guard let machine = currentMachine else {
            return MaintenanceManualData(
                brand: "Jura",
                modelName: "E8 Piano Black",
                category: "CoffeeMachine",
                generalCareSummary: "Daily milk system rinsing and bi-monthly descaling ensures optimal extraction crema.",
                recommendedServiceIntervalDays: 60
            )
        }
        
        return MaintenanceManualData(
            brand: machine.brand,
            modelName: machine.modelName,
            category: "CoffeeMachine",
            generalCareSummary: "Regular water hardness calibration and milk frother descaling preserves heating block pressure.",
            recommendedServiceIntervalDays: 60,
            maintenanceSteps: [
                MaintenanceStep(
                    stepNumber: 1,
                    title: "Milk System Clean & Soak",
                    detail: "Rinse milk pipe with OEM antibacterial solution to eliminate milk fats.",
                    frequencyDescription: "Daily / After Milk Pull",
                    frequencyDays: 1,
                    toolsRequired: ["Milk Cleaning Solution", "Rinse Container"],
                    iconName: "drop.fill"
                ),
                MaintenanceStep(
                    stepNumber: 2,
                    title: "Descaling & Circuit Rinse",
                    detail: "Dissolve 3 descaling tablets in water tank and execute automatic 20-minute cycle.",
                    frequencyDescription: "Every 45 Liters / 60 Days",
                    frequencyDays: 60,
                    toolsRequired: ["Descaling Tablets", "1L Container"],
                    iconName: "sparkles"
                ),
                MaintenanceStep(
                    stepNumber: 3,
                    title: "Burr Inspection & Coffee Oil Removal",
                    detail: "Run grind cleaner pellets through hopper to dissolve rancid coffee oils.",
                    frequencyDescription: "Every 200 Shots",
                    frequencyDays: 90,
                    toolsRequired: ["Grindz Cleaner Tablets"],
                    iconName: "gear"
                )
            ],
            recommendedCleanersOrLubricants: ["Claris Smart Filter", "Milk System Cleaner", "Descaling Tablets"],
            safetyPrecautions: ["Never use vinegar as acid eats aluminum boilers", "Ensure machine cools down before removing brew group"]
        )
    }
    
    public func getCoffeeParts() -> SparePartsScheduleData {
        let brand = currentMachine?.brand ?? "Jura"
        let model = currentMachine?.modelName ?? "E8 Piano Black"
        return SparePartsScheduleData(
            brand: brand,
            modelName: model,
            parts: [
                SparePartItem(partNumber: "JUR-CLARIS-SMART", name: "Claris Smart Water Filter", category: "Filter", replacementIntervalDays: 60, estimatedCostCHF: 14, wearDegradationRateMonthly: 50.0, description: "Ion-exchange cartridge reducing limescale and chlorine for stable extraction"),
                SparePartItem(partNumber: "JUR-BREW-GASKET", name: "Brew Group O-Ring Set", category: "Gasket", replacementIntervalDays: 365, estimatedCostCHF: 12, wearDegradationRateMonthly: 8.0, description: "Silicone seals maintaining 15 bar pump pressure across the brew unit"),
                SparePartItem(partNumber: "JUR-SHOWER-SCREEN", name: "Shower Screen & Dispersion Block", category: "General", replacementIntervalDays: 540, estimatedCostCHF: 18, wearDegradationRateMonthly: 5.0, description: "Stainless diffusion screen ensuring even water distribution over the puck"),
                SparePartItem(partNumber: "JUR-MILK-SPOUT", name: "Milk System Spout & Tube Set", category: "General", replacementIntervalDays: 180, estimatedCostCHF: 22, wearDegradationRateMonthly: 16.0, description: "Hygienic milk path components preventing fat residue buildup")
            ]
        )
    }
    
    // MARK: — Coffee-Specific Gemini AI: Grind Advisor (Phase 7)
    /// Asks Gemini for a grind size recommendation based on bean origin, roast level, and local water hardness.
    /// This is Coffee Companion's exclusive AI pipeline — no other app uses this domain schema.
    public func askGeminiGrindAdvice(
        beanOrigin: String,
        roastLevel: String,
        grindTarget: GeminiClient
    ) async -> GrindAdviceResult? {
        let machineDesc: String
        if let machine = currentMachine {
            machineDesc = "\(machine.machineType) (\(machine.brand) \(machine.modelName)), \(Int(machine.pumpPressureBar)) bar pump, \(machine.boilerType) boiler"
        } else {
            machineDesc = "Superautomatic espresso (Jura E8), 15 bar pump"
        }
        
        let prompt = """
        You are a specialty coffee barista advisor. Given:
        - Bean origin: \(beanOrigin)
        - Roast level: \(roastLevel)
        - Water hardness: \(String(format: "%.1f", waterHardnessDH)) °dH (German degrees)
        - Machine: \(machineDesc)
        Return JSON: {
            "recommendedGrindSetting": number (1–10),
            "doseGrams": number,
            "yieldGrams": number,
            "extractionTimeSec": number,
            "waterTempC": number,
            "brewRationale": string (≤40 words)
        }
        Important: Only recommend parameters achievable with the given machine specifications.
        """
        guard let result: GrindAdviceResult = try? await grindTarget.generate(
            prompt: prompt,
            responseType: GrindAdviceResult.self
        ) else { return nil }
        return result
    }

    // MARK: — Descale Push Notification (Phase 8)
    /// Schedules a local UNUserNotificationRequest when descaling is due in ≤5 days.
    /// Trigger is Coffee-specific: water hardness × usage calculation, not a generic timer.
    public func scheduleDescaleNotification() async {
        let center = UNUserNotificationCenter.current()
        let _ = try? await center.requestAuthorization(options: [.alert, .badge, .sound])
        let daysUntilDescale = max(1, Int(allowedLitersUntilDescale / 1.8)) // ~1.8L/day average
        guard daysUntilDescale <= 5 else { return }

        let content = UNMutableNotificationContent()
        content.title = "Descale your Jura E8 soon"
        content.body = "Water scale builds up in \(daysUntilDescale) day\(daysUntilDescale == 1 ? "" : "s"). Run the 3-phase descaling cycle to protect the heating block."
        content.sound = .default
        content.categoryIdentifier = "COFFEE_DESCALE"
        content.userInfo = ["daysRemaining": daysUntilDescale, "waterHardnessDH": waterHardnessDH]

        let trigger = UNTimeIntervalNotificationTrigger(
            timeInterval: max(60, Double(daysUntilDescale - 1) * 86_400),
            repeats: false
        )
        let request = UNNotificationRequest(
            identifier: "coffee.descale.\(currentMachine?.id.uuidString ?? "default")",
            content: content,
            trigger: trigger
        )
        try? await center.add(request)
    }

    // MARK: — Daily Brew Session Journal (Phase 9)
    /// Appends a completed espresso shot to the brew session journal in SwiftData.
    /// Enables the Coffee Companion's retention loop: daily pull logging, dial-in history, and bean tasting notes.
    public func appendBrewSession(
        beanOrigin: String,
        doseGrams: Double,
        yieldGrams: Double,
        extractionTimeSec: Double,
        grindSetting: Double,
        tastingNotes: String
    ) async {
        guard let machineID = currentMachine?.id else { return }
        do {
            try await databaseWorker.recordBrewSession(
                machineID: machineID,
                beanOrigin: beanOrigin,
                doseGrams: doseGrams,
                yieldGrams: yieldGrams,
                extractionTimeSec: extractionTimeSec,
                grindSetting: grindSetting,
                tastingNotes: tastingNotes
            )
        } catch {
            self.errorMessage = "Brew session log failed: \(error.localizedDescription)"
        }
    }
}

// MARK: — Coffee Companion Exclusive Domain Types
public struct GrindAdviceResult: Codable, Sendable {
    public let recommendedGrindSetting: Double
    public let doseGrams: Double
    public let yieldGrams: Double
    public let extractionTimeSec: Double
    public let waterTempC: Double
    public let brewRationale: String
}
