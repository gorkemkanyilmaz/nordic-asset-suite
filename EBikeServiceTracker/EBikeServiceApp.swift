//
//  EBikeServiceApp.swift
//  EBikeServiceTracker
//
//  Created for Nordic Asset Suite.
//  Strict Concurrency: Complete. SwiftUI Native Entry Point.
//

import SwiftUI
import SwiftData
import AssetCoreDatabase

@main
public struct EBikeServiceApp: App {
    @State private var container: ModelContainer
    @State private var viewModel: EBikeViewModel
    
    public init() {
        let modelContainer = DatabaseContainer.shared.makeSafeContainer()
        _container = State(initialValue: modelContainer)
        let worker = DatabaseWorker(modelContainer: modelContainer)
        _viewModel = State(initialValue: EBikeViewModel(databaseWorker: worker))
    }
    
    public var body: some Scene {
        WindowGroup {
            EBikeMainTabView(viewModel: viewModel)
                .preferredColorScheme(.dark)
        }
        .modelContainer(container)
    }
}
