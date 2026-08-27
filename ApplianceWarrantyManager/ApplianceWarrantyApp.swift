//
//  ApplianceWarrantyApp.swift
//  ApplianceWarrantyManager
//
//  Created for Nordic Asset Suite.
//  Strict Concurrency: Complete. SwiftUI Native Entry Point.
//

import SwiftUI
import SwiftData
import AssetCoreDatabase
import AssetCoreLocalization

@main
public struct ApplianceWarrantyApp: App {
    @State private var container: ModelContainer
    @State private var viewModel: ApplianceViewModel
    
    public init() {
        let modelContainer = DatabaseContainer.shared.makeSafeContainer()
        _container = State(initialValue: modelContainer)
        let worker = DatabaseWorker(modelContainer: modelContainer)
        _viewModel = State(initialValue: ApplianceViewModel(databaseWorker: worker))
        
        // Auto-detect device language and currency on first launch
        Task { @MainActor in
            LanguageManager.shared.applyDeviceDefaultsIfNeeded()
        }
    }
    
    public var body: some Scene {
        WindowGroup {
            RoomsDashboardView(viewModel: viewModel)
        }
        .modelContainer(container)
    }
}
