//
//  EBikeViewModel.swift
//  EBikeServiceTracker
//
//  Created for Nordic Asset Suite.
//  Strict Concurrency: Complete. @Observable Garage & Telemetry State Manager with Gemini AI.
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
public final class EBikeViewModel {
    public var bikes: [EBikeDTO] = []
    public var selectedBikeIndex: Int = 0
    public var isLoading: Bool = false
    public var errorMessage: String? = nil
    public var showingOnboardingGuide: Bool = false
    public var showingLiveScanner: Bool = false
    
    // Telemetry Interactive State
    public var riderWeightKg: Double = 80.0
    public var measuredChainWear: Double = 0.55 // 0.55%
    
    public let theme: any AppDesignTheme = EBikeTheme()
    
    private let databaseWorker: DatabaseWorker
    
    public init(databaseWorker: DatabaseWorker) {
        self.databaseWorker = databaseWorker
    }
    
    public var currentBike: EBikeDTO? {
        guard !bikes.isEmpty, selectedBikeIndex < bikes.count else { return nil }
        return bikes[selectedBikeIndex]
    }
    
    public var chainStatus: ChainWearStatus {
        EBikeTelemetryCalculator.shared.evaluateChainWear(elongationPercentage: measuredChainWear)
    }
    
    public var suspensionRecommendation: SuspensionSetupRecommendation {
        EBikeTelemetryCalculator.shared.calculateSuspensionPSI(riderWeightWithGearKg: riderWeightKg)
    }
    
    public func loadBikes() async {
        isLoading = true
        errorMessage = nil
        do {
            self.bikes = try await databaseWorker.fetchEBikes()
            if self.bikes.isEmpty {
                await injectDemoBike()
            }
        } catch {
            self.errorMessage = error.localizedDescription
        }
        isLoading = false
    }
    
    public func addBike(
        brand: String,
        model: String,
        frameNo: String,
        motor: String,
        odometer: Double
    ) async {
        do {
            let bikeID = try await databaseWorker.createAndInsertEBike(
                brand: brand,
                modelName: model,
                frameNumber: frameNo,
                motorSystem: motor,
                totalOdometerKm: odometer
            )
            try await databaseWorker.recordBatteryHealth(
                ebikeID: bikeID,
                healthPct: 98.0,
                capacityWh: 750.0,
                cycles: 12,
                cellDiffMv: 3.5,
                tempC: 22.0
            )
            await loadBikes()
        } catch {
            self.errorMessage = "Failed to save E-Bike: \(error.localizedDescription)"
        }
    }
    
    public func injectDemoBike() async {
        do {
            let bikeID = try await databaseWorker.createAndInsertEBike(
                brand: "Scott",
                modelName: "Patron eRIDE 900 (2025)",
                frameNumber: "SCOTT-PATRON-CX4-9912",
                motorSystem: "Bosch Performance Line CX (85Nm)",
                totalOdometerKm: 1420.0
            )
            try await databaseWorker.recordBatteryHealth(
                ebikeID: bikeID,
                healthPct: 96.0,
                capacityWh: 750.0,
                cycles: 28,
                cellDiffMv: 2.1,
                tempC: 21.5
            )
            self.bikes = try await databaseWorker.fetchEBikes()
        } catch {
            print("EBike demo injection error: \(error)")
        }
    }
    
    public func getEBikeManual() -> MaintenanceManualData {
        let brand = currentBike?.brand ?? "Scott"
        let model = currentBike?.modelName ?? "Patron eRIDE"
        return MaintenanceManualData(
            brand: brand,
            modelName: model,
            category: "EBike",
            generalCareSummary: "Regular chain lubrication, hydraulic brake inspection, and battery charge cycling extends motor drive efficiency.",
            recommendedServiceIntervalDays: 90,
            maintenanceSteps: [
                MaintenanceStep(
                    stepNumber: 1,
                    title: "Drivetrain Clean & Wet/Dry Lube",
                    detail: "Degrease chain and apply ceramic e-bike specific chain lubricant.",
                    frequencyDescription: "Every 150 km",
                    frequencyDays: 14,
                    toolsRequired: ["Chain Degreaser", "E-Bike Lube", "Microfiber Rag"],
                    iconName: "drop.fill"
                ),
                MaintenanceStep(
                    stepNumber: 2,
                    title: "Brake Pad & Rotor Thickness Measurement",
                    detail: "Inspect metallic brake pads for minimum 1.0mm thickness and clean rotors with isopropyl.",
                    frequencyDescription: "Monthly / Every 300 km",
                    frequencyDays: 30,
                    toolsRequired: ["Vernier Caliper", "Brake Cleaner"],
                    iconName: "wrench.and.screwdriver"
                ),
                MaintenanceStep(
                    stepNumber: 3,
                    title: "Suspension Stanchion Lubrication & PSI Check",
                    detail: "Clean fork stanchions and recharge air pressure chamber according to rider weight.",
                    frequencyDescription: "Every 50 Riding Hours",
                    frequencyDays: 60,
                    toolsRequired: ["High-Pressure Shock Pump", "Stanchion Lube"],
                    iconName: "gear"
                )
            ],
            recommendedCleanersOrLubricants: ["Muc-Off E-Bike Cleaner", "Ceramic Lube", "DOT 5.1 Brake Fluid"],
            safetyPrecautions: ["Never spray high-pressure jet directly at motor bottom bracket or display seals", "Store battery at 40-70% charge if unridden in winter"]
        )
    }
    
    public func getEBikeParts() -> SparePartsScheduleData {
        let brand = currentBike?.brand ?? "Scott"
        let model = currentBike?.modelName ?? "Patron eRIDE"
        return SparePartsScheduleData(
            brand: brand,
            modelName: model,
            parts: [
                SparePartItem(partNumber: "SRAM-PAD-04", name: "SRAM Code RSC Metallic Brake Pads", category: "BrakePad", replacementIntervalDays: 120, estimatedCostCHF: 38, wearDegradationRateMonthly: 25.0, description: "Sintered compound for high-power electric descent"),
                SparePartItem(partNumber: "SHI-M8100-12", name: "Shimano XT 12-Speed E-Bike Chain", category: "Chain", replacementIntervalDays: 180, estimatedCostCHF: 48, wearDegradationRateMonthly: 16.0, description: "SIL-TEC reinforced link chain"),
                SparePartItem(partNumber: "BOS-BBP375", name: "Bosch PowerTube 750Wh Battery", category: "Battery", replacementIntervalDays: 1825, estimatedCostCHF: 890, wearDegradationRateMonthly: 1.5, description: "Integrated smart system li-ion battery")
            ]
        )
    }

    // MARK: — E-Bike Exclusive Gemini AI: Motor Error Decoder (Phase 7)
    /// Decodes Bosch, Shimano EP8, or Bafang error codes using Gemini.
    /// This is E-Bike Service's exclusive AI pipeline — no other app interprets motor controller error schemas.
    public func askGeminiMotorDiagnosis(
        errorCode: String,
        motorSystem: String,
        client: GeminiClient
    ) async -> MotorDiagnosisResult? {
        let bike = currentBike?.modelName ?? "E-Bike"
        let motor = currentBike?.motorSystem ?? motorSystem
        let prompt = """
        You are an e-bike motor technician. Diagnose error code "\(errorCode)" for a \(bike) with \(motor) drive system.
        Return JSON: {
            "errorTitle": string,
            "motorSystem": string,
            "probableCause": string,
            "severity": "LOW" | "MEDIUM" | "HIGH" | "CRITICAL",
            "immediateAction": string,
            "workshopRequired": boolean,
            "preventionTip": string
        }
        """
        guard let result: MotorDiagnosisResult = try? await client.generate(
            prompt: prompt,
            responseType: MotorDiagnosisResult.self
        ) else { return nil }
        return result
    }

    // MARK: — Chain Wear Service Notification (Phase 8)
    /// Schedules a local push notification when chain elongation approaches the 0.75% replacement threshold.
    /// Trigger is e-bike specific: measured elongation percentage — not a generic date/time timer.
    public func scheduleChainWearNotification() async {
        guard measuredChainWear >= 0.60 else { return }
        let center = UNUserNotificationCenter.current()
        let _ = try? await center.requestAuthorization(options: [.alert, .badge, .sound])

        let content = UNMutableNotificationContent()
        content.title = "Chain wear approaching limit"
        let pct = String(format: "%.2f", measuredChainWear)
        content.body = "\(currentBike?.modelName ?? "Your e-bike") chain is at \(pct)% elongation. Replace before reaching 0.75% to protect cassette and chainring."
        content.sound = .default
        content.categoryIdentifier = "EBIKE_CHAIN_WEAR"
        content.userInfo = ["elongationPct": measuredChainWear, "bikeID": currentBike?.id?.uuidString ?? ""]

        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 60, repeats: false)
        let request = UNNotificationRequest(
            identifier: "ebike.chain.\(currentBike?.id?.uuidString ?? "default")",
            content: content,
            trigger: trigger
        )
        try? await center.add(request)
    }

    // MARK: — Ride Session Persistence (Phase 9)
    /// Saves a completed ride to SwiftData, updating odometer and battery cycle count.
    /// Powers the E-Bike's core retention loop: daily ride logging → chain wear tracking → service forecasting.
    public func persistRideSession(
        distanceKm: Double,
        elevationGainM: Double,
        batteryUsedPct: Double,
        trailType: String
    ) async {
        guard let bikeID = currentBike?.id else { return }
        do {
            try await databaseWorker.recordRideSession(
                ebikeID: bikeID,
                distanceKm: distanceKm,
                elevationGainM: elevationGainM,
                batteryUsedPct: batteryUsedPct,
                trailType: trailType
            )
        } catch {
            self.errorMessage = "Ride session save failed: \(error.localizedDescription)"
        }
    }
}

// MARK: — E-Bike Service Exclusive Domain Types
public struct MotorDiagnosisResult: Codable {
    public let errorTitle: String
    public let motorSystem: String
    public let probableCause: String
    public let severity: String
    public let immediateAction: String
    public let workshopRequired: Bool
    public let preventionTip: String
}

