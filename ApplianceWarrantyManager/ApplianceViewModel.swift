//
//  ApplianceViewModel.swift
//  ApplianceWarrantyManager
//
//  Created for Nordic Asset Suite.
//  Strict Concurrency: Complete. @Observable MVVM Architecture.
//

import SwiftUI
import Observation
import AssetCoreDatabase
import AssetCoreUIComponents
import AssetCoreLocalization

@Observable
@MainActor
public final class ApplianceViewModel {
    public var appliances: [ApplianceDTO] = []
    public var selectedRoom: String = "All"
    public var isLoading: Bool = false
    public var errorMessage: String? = nil
    public var showingAddScanner: Bool = false
    
    public let theme: any AppDesignTheme = ApplianceTheme()
    
    private let databaseWorker: DatabaseWorker
    
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
        } catch {
            self.errorMessage = error.localizedDescription
        }
        isLoading = false
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
            self.errorMessage = "Failed to save appliance: \(error.localizedDescription)"
        }
    }
}
