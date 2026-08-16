//
//  CoffeeViewModel.swift
//  CoffeeMachineCompanion
//
//  Created for Nordic Asset Suite.
//  Strict Concurrency: Complete. @Observable Barista & Chemistry State Manager.
//

import SwiftUI
import Observation
import AssetCoreDatabase
import AssetCoreUIComponents

@Observable
@MainActor
public final class CoffeeViewModel {
    public var machines: [CoffeeMachineDTO] = []
    public var isLoading: Bool = false
    public var errorMessage: String? = nil
    
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
        } catch {
            self.errorMessage = error.localizedDescription
        }
        isLoading = false
    }
    
    public func addMachine(
        brand: String,
        model: String,
        machineType: String
    ) async {
        let machine = CoffeeMachineEntity(
            brand: brand,
            modelName: model,
            machineType: machineType,
            totalShotsPulled: 0
        )
        
        do {
            try await databaseWorker.insertCoffeeMachine(machine)
            try await databaseWorker.recordDescalingCycle(
                machineID: machine.id,
                chemical: "OEM Descaling Tablets",
                waterLiters: 45.0,
                daysUntilNext: 60,
                notes: "Initial setup descaling baseline."
            )
            await loadMachines()
        } catch {
            self.errorMessage = "Failed to save coffee machine: \(error.localizedDescription)"
        }
    }
}
