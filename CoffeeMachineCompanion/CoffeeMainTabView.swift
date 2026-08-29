//
//  CoffeeMainTabView.swift
//  CoffeeMachineCompanion
//
//  Created for Nordic Asset Suite.
//  Strict Concurrency: Complete. 5-Tab Barista Navigation matching localhost.
//

import SwiftUI
import AssetCoreDatabase
import AssetCoreUIComponents
import AssetCoreLocalization

public struct CoffeeMainTabView: View {
    @Bindable public var viewModel: CoffeeViewModel
    private let theme = CoffeeTheme()
    
    @State private var selectedTab: Int = 0
    
    public init(viewModel: CoffeeViewModel) {
        self.viewModel = viewModel
    }
    
    public var body: some View {
        TabView(selection: $selectedTab) {
            BaristaDeckView(viewModel: viewModel)
                .tabItem {
                    Label("Today", systemImage: "mug.fill")
                }
                .tag(0)
            
            BrewRecipeJournalView(machine: viewModel.currentMachine)
                .tabItem {
                    Label("Recipes", systemImage: "book.pages.fill")
                }
                .tag(1)
            
            LiveBrewTimerView()
                .tabItem {
                    Label("Brew", systemImage: "play.circle.fill")
                }
                .tag(2)
            
            MachineMaintenanceView(viewModel: viewModel)
                .tabItem {
                    Label("Machine", systemImage: "gearshape.2.fill")
                }
                .tag(3)
            
            NavigationStack {
                WaterHardnessCalibrationView(viewModel: viewModel)
            }
            .tabItem {
                Label("Settings", systemImage: "slider.horizontal.3")
            }
            .tag(4)
        }
        .tint(theme.primaryAccent)
        .preferredColorScheme(.dark)
    }
}
