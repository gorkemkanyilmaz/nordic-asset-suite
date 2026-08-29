//
//  CoffeeMachineApp.swift
//  CoffeeMachineCompanion
//
//  Created for Nordic Asset Suite.
//  Strict Concurrency: Complete. SwiftUI Native Entry Point.
//

import SwiftUI
import SwiftData
import AssetCoreDatabase

@main
public struct CoffeeMachineApp: App {
    @State private var container: ModelContainer
    @State private var viewModel: CoffeeViewModel
    
    public init() {
        let modelContainer = DatabaseContainer.shared.makeSafeContainer()
        _container = State(initialValue: modelContainer)
        let worker = DatabaseWorker(modelContainer: modelContainer)
        _viewModel = State(initialValue: CoffeeViewModel(databaseWorker: worker))
    }
    
    public var body: some Scene {
        WindowGroup {
            BaristaDeckView(viewModel: viewModel)
                .preferredColorScheme(.dark)
        }
        .modelContainer(container)
    }
}
