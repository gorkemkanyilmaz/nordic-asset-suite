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

@main
public struct ApplianceWarrantyApp: App {
    @State private var container: ModelContainer
    @State private var viewModel: ApplianceViewModel
    
    public init() {
        let modelContainer: ModelContainer
        do {
            modelContainer = try DatabaseContainer.shared.makeProductionContainer()
        } catch {
            modelContainer = try! DatabaseContainer.shared.makeInMemoryContainer()
        }
        
        _container = State(initialValue: modelContainer)
        let worker = DatabaseWorker(modelContainer: modelContainer)
        _viewModel = State(initialValue: ApplianceViewModel(databaseWorker: worker))
    }
    
    public var body: some Scene {
        WindowGroup {
            RoomsDashboardView(viewModel: viewModel)
        }
        .modelContainer(container)
    }
}
