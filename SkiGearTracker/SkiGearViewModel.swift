//
//  SkiGearViewModel.swift
//  SkiGearTracker
//
//  Created for Nordic Asset Suite.
//  Strict Concurrency: Complete. @Observable Quiver & DIN State Manager.
//

import SwiftUI
import Observation
import AssetCoreDatabase
import AssetCoreUIComponents

@Observable
@MainActor
public final class SkiGearViewModel {
    public var skis: [SkiGearDTO] = []
    public var selectedSeasonTab: Int = 0 // 0 = Active Winter Quiver, 1 = Summer Storage Vault
    public var isLoading: Bool = false
    public var errorMessage: String? = nil
    public var showingDINCalculator: Bool = false
    
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
        let gear = SkiGearEntity(
            brand: brand,
            modelName: model,
            serialNumber: serial,
            gearCategory: "Alpine Skis",
            skiLengthCm: length,
            bootSoleLengthMm: bsl
        )
        
        do {
            try await databaseWorker.insertSkiGear(gear)
            try await databaseWorker.recordDINSetting(
                gearID: gear.id,
                din: din,
                toe: din,
                heel: din,
                weight: 75.0,
                height: 180.0,
                age: 30,
                skierType: "Type II",
                bsl: bsl
            )
            await loadGear()
        } catch {
            self.errorMessage = "Failed to save ski gear: \(error.localizedDescription)"
        }
    }
}
