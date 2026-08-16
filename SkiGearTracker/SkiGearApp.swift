//
//  SkiGearApp.swift
//  SkiGearTracker
//
//  Created for Nordic Asset Suite.
//  Strict Concurrency: Complete. SwiftUI Native Entry Point.
//

import SwiftUI
import SwiftData
import AssetCoreDatabase

@main
public struct SkiGearApp: App {
    @State private var container: ModelContainer
    @State private var viewModel: SkiGearViewModel
    
    public init() {
        let modelContainer = DatabaseContainer.shared.makeSafeContainer()
        _container = State(initialValue: modelContainer)
        let worker = DatabaseWorker(modelContainer: modelContainer)
        _viewModel = State(initialValue: SkiGearViewModel(databaseWorker: worker))
    }
    
    public var body: some Scene {
        WindowGroup {
            QuiverDashboardView(viewModel: viewModel)
        }
        .modelContainer(container)
    }
}
