//
//  EBikeViewModel.swift
//  EBikeServiceTracker
//
//  Created for Nordic Asset Suite.
//  Strict Concurrency: Complete. @Observable Garage & Telemetry State Manager.
//

import SwiftUI
import Observation
import AssetCoreDatabase
import AssetCoreUIComponents

@Observable
@MainActor
public final class EBikeViewModel {
    public var bikes: [EBikeDTO] = []
    public var selectedBikeIndex: Int = 0
    public var isLoading: Bool = false
    public var errorMessage: String? = nil
    
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
        let bike = EBikeEntity(
            brand: brand,
            modelName: model,
            frameNumber: frameNo,
            motorSystem: motor,
            totalOdometerKm: odometer
        )
        
        do {
            try await databaseWorker.insertEBike(bike)
            try await databaseWorker.recordBatteryHealth(
                ebikeID: bike.id,
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
}
