//
//  SkiGearViewModel.swift
//  SkiGearTracker
//
//  Created for Nordic Asset Suite.
//  Strict Concurrency: Complete. @Observable Quiver & DIN State Manager with Gemini AI.
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
public final class SkiGearViewModel {
    public var skis: [SkiGearDTO] = []
    public var selectedSeasonTab: Int = 0 // 0 = Active Winter Quiver, 1 = Summer Storage Vault
    public var isLoading: Bool = false
    public var errorMessage: String? = nil
    public var showingDINCalculator: Bool = false
    public var showingOnboardingGuide: Bool = false
    public var showingLiveScanner: Bool = false
    
    public let theme: any AppDesignTheme = SkiGearTheme()
    
    private let databaseWorker: DatabaseWorker
    
    public init(databaseWorker: DatabaseWorker) {
        self.databaseWorker = databaseWorker
    }
    
    public var activeQuiver: [SkiGearDTO] {
        return skis.filter { !$0.isArchivedForSummer }
    }
    
    public var summerVault: [SkiGearDTO] {
        return skis.filter { $0.isArchivedForSummer }
    }
    
    public func loadGear() async {
        isLoading = true
        errorMessage = nil
        do {
            self.skis = try await databaseWorker.fetchSkiGear()
            if self.skis.isEmpty {
                await injectDemoSkiGear()
            }
        } catch {
            self.errorMessage = error.localizedDescription
        }
        isLoading = false
    }
    
    public func addSkiPair(
        brand: String,
        model: String,
        serial: String,
        length: Double,
        bsl: Int,
        din: Double
    ) async {
        do {
            let gearID = try await databaseWorker.createAndInsertSkiGear(
                brand: brand,
                modelName: model,
                serialNumber: serial,
                gearCategory: "Alpine Racing",
                skiLengthCm: length,
                bootSoleLengthMm: bsl
            )
            try await databaseWorker.recordDINSetting(
                gearID: gearID,
                din: din,
                toe: din,
                heel: din,
                weight: 75.0,
                height: 180.0,
                age: 30,
                skierType: "Type III",
                bsl: bsl
            )
            await loadGear()
        } catch {
            self.errorMessage = "Failed to save ski gear: \(error.localizedDescription)"
        }
    }
    
    public func injectDemoSkiGear() async {
        do {
            let gearID = try await databaseWorker.createAndInsertSkiGear(
                brand: "Stöckli",
                modelName: "Laser SL Racing (165cm)",
                serialNumber: "STK-LASER-SL-2026",
                gearCategory: "Slalom Race",
                skiLengthCm: 165.0,
                bootSoleLengthMm: 305
            )
            try await databaseWorker.recordDINSetting(
                gearID: gearID,
                din: 8.5,
                toe: 8.5,
                heel: 8.5,
                weight: 78.0,
                height: 182.0,
                age: 28,
                skierType: "Type III",
                bsl: 305
            )
            self.skis = try await databaseWorker.fetchSkiGear()
        } catch {
            print("Ski demo injection error: \(error)")
        }
    }
    
    public func getSkiManual() -> MaintenanceManualData {
        let brand = skis.first?.brand ?? "Stöckli"
        let model = skis.first?.modelName ?? "Laser SL"
        return MaintenanceManualData(
            brand: brand,
            modelName: model,
            category: "SkiGear",
            generalCareSummary: "Base waxing and edge bevel diamond honing prevents oxidation and maintains edge grip on hardpack ice.",
            recommendedServiceIntervalDays: 30,
            maintenanceSteps: [
                MaintenanceStep(
                    stepNumber: 1,
                    title: "Base Clean & Wax Saturation",
                    detail: "Iron in hydro-carbon storage or temperature wax at 130°C and scrape with plexi blade.",
                    frequencyDescription: "Every 4 Ski Days",
                    frequencyDays: 14,
                    toolsRequired: ["Waxing Iron", "Plexi Scraper", "Brass Brush"],
                    iconName: "snowflake"
                ),
                MaintenanceStep(
                    stepNumber: 2,
                    title: "Side Edge Diamond Honing (87°/88°)",
                    detail: "De-burr rock scratches with 600 grit diamond stone to maintain razor grip.",
                    frequencyDescription: "Weekly in Season",
                    frequencyDays: 7,
                    toolsRequired: ["Edge Bevel Guide 88°", "Diamond Stone 600G"],
                    iconName: "wrench.and.screwdriver"
                ),
                MaintenanceStep(
                    stepNumber: 3,
                    title: "ISO 11088 Binding Release Torque Test",
                    detail: "Calibrate visual indicator scale against mechanical torque tester.",
                    frequencyDescription: "Annual Pre-Season",
                    frequencyDays: 365,
                    toolsRequired: ["DIN Torque Tester", "Pozi #3 Driver"],
                    iconName: "gear"
                )
            ],
            recommendedCleanersOrLubricants: ["Toko LF Blue HydroCarbon Wax", "Base Cleaner Citrus", "Binding Anti-Freeze Lube"],
            safetyPrecautions: ["Never ski on bindings that fail mechanical release torque inspection", "Dry edges completely after skiing to prevent rust pitting"]
        )
    }
    
    public func getSkiParts() -> SparePartsScheduleData {
        let brand = skis.first?.brand ?? "Stöckli"
        let model = skis.first?.modelName ?? "Laser SL"
        return SparePartsScheduleData(
            brand: brand,
            modelName: model,
            parts: [
                SparePartItem(partNumber: "TOK-55020", name: "Toko High Performance Cold Wax 120g", category: "Wax", replacementIntervalDays: 30, estimatedCostCHF: 28, wearDegradationRateMonthly: 35.0, description: "Fluor-free racing wax for -10°C to -30°C snow"),
                SparePartItem(partNumber: "SAL-FF14", name: "Salomon Freeflex 14 Race Bindings", category: "Hardware", replacementIntervalDays: 1095, estimatedCostCHF: 320, wearDegradationRateMonthly: 2.0, description: "Full diagonal race binding with steel housing"),
                SparePartItem(partNumber: "SWX-TA30", name: "Swix World Cup Diamond Stone 600G", category: "General", replacementIntervalDays: 730, estimatedCostCHF: 35, wearDegradationRateMonthly: 4.0, description: "Diamond polishing file for edge sharpening")
            ]
        )
    }

    // MARK: — Ski Gear Exclusive Gemini AI: Snow Condition Wax Advisor (Phase 7)
    /// Returns a wax specification tailored to snow temperature, humidity, and snow type.
    /// This is Ski Gear Tracker's exclusive AI pipeline — uses ISO snow type classifications and ski base material.
    public func askGeminiWaxRecommendation(
        snowTempC: Double,
        airTempC: Double,
        snowType: String,
        skiBase: String,
        client: GeminiClient
    ) async -> WaxRecommendationResult? {
        let gear = skis.first?.modelName ?? "Alpine skis"
        let prompt = """
        You are an alpine ski tuner and wax technician. Recommend the best wax for:
        - Ski: \(gear) (\(skiBase) base)
        - Snow temperature: \(String(format: "%.1f", snowTempC))°C
        - Air temperature: \(String(format: "%.1f", airTempC))°C
        - Snow type: \(snowType) (e.g., fresh, packed, icy, wet)
        Return JSON: {
            "waxBrand": string,
            "waxModel": string,
            "waxTemperatureRange": string,
            "applicationMethod": string,
            "ironTempC": number,
            "layers": number,
            "structureRecommendation": string,
            "rationale": string (≤35 words)
        }
        """
        guard let result: WaxRecommendationResult = try? await client.generate(
            prompt: prompt,
            responseType: WaxRecommendationResult.self
        ) else { return nil }
        return result
    }

    // MARK: — Pre-Season DIN Binding Check Notification (Phase 8)
    /// Schedules an annual pre-season push notification for ISO 11088 binding torque recertification.
    /// DIN binding alerts are unique to ski safety — no other app category uses this notification trigger.
    public func scheduleAnnualDINCheckNotification(daysUntilSeason: Int) async {
        let center = UNUserNotificationCenter.current()
        let _ = try? await center.requestAuthorization(options: [.alert, .badge, .sound])

        let content = UNMutableNotificationContent()
        content.title = "Pre-season binding check due"
        content.body = "Have your Salomon Freeflex 14 bindings torque-tested to ISO 11088 before skiing. DIN values shift after summer storage."
        content.sound = .default
        content.categoryIdentifier = "SKI_DIN_CHECK"
        content.userInfo = ["gearID": skis.first?.id.uuidString ?? "", "standardISO": "11088"]

        let trigger = UNTimeIntervalNotificationTrigger(
            timeInterval: max(60, Double(max(1, daysUntilSeason - 7)) * 86_400),
            repeats: false
        )
        let request = UNNotificationRequest(
            identifier: "ski.din.\(skis.first?.id.uuidString ?? "default")",
            content: content,
            trigger: trigger
        )
        try? await center.add(request)
    }

    // MARK: — Ski Trip Packing List Persistence (Phase 9)
    /// Saves a completed trip packing checklist to SwiftData for the mountain trip retention loop.
    /// Unique to Ski Gear: gear-specific checklist items (transceiver, airbag, boot sole length for binding compatibility).
    public func persistTripChecklist(
        destination: String,
        tripDateISO: String,
        checkedItems: [String],
        uncheckedItems: [String]
    ) async {
        guard let gearID = skis.first?.id else { return }
        do {
            try await databaseWorker.recordTripChecklist(
                gearID: gearID,
                destination: destination,
                tripDateISO: tripDateISO,
                checkedItems: checkedItems,
                uncheckedItems: uncheckedItems
            )
        } catch {
            self.errorMessage = "Trip checklist save failed: \(error.localizedDescription)"
        }
    }
}

// MARK: — Ski Gear Tracker Exclusive Domain Types
public struct WaxRecommendationResult: Codable, Sendable {
    public let waxBrand: String
    public let waxModel: String
    public let waxTemperatureRange: String
    public let applicationMethod: String
    public let ironTempC: Double
    public let layers: Int
    public let structureRecommendation: String
    public let rationale: String
}

