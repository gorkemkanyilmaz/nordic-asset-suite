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
import AssetCoreSubscription

public struct CoffeeMainTabView: View {
    @Bindable public var viewModel: CoffeeViewModel
    private let theme = CoffeeTheme()
    
    @State private var selectedTab: Int = 0
    
    public init(viewModel: CoffeeViewModel) {
        self.viewModel = viewModel
    }
    
    public var body: some View {
        TabView(selection: $selectedTab) {
            todayTab
            recipesTab
            brewTab
            machineTab
            settingsTab
        }
        .tint(theme.primaryAccent)
        .preferredColorScheme(.dark)
    }
    
    @ViewBuilder
    private var todayTab: some View {
        BaristaDeckView(viewModel: viewModel)
            .tabItem {
                Label("Today", systemImage: "mug.fill")
            }
            .tag(0)
    }
    
    @ViewBuilder
    private var recipesTab: some View {
        BrewRecipeJournalView(machine: viewModel.currentMachine)
            .tabItem {
                Label("Recipes", systemImage: "book.pages.fill")
            }
            .tag(1)
    }
    
    @ViewBuilder
    private var brewTab: some View {
        LiveBrewTimerView()
            .tabItem {
                Label("Brew", systemImage: "play.circle.fill")
            }
            .tag(2)
    }
    
    @ViewBuilder
    private var machineTab: some View {
        MachineMaintenanceView(viewModel: viewModel)
            .tabItem {
                Label("Machine", systemImage: "gearshape.2.fill")
            }
            .tag(3)
    }
    
    @ViewBuilder
    private var settingsTab: some View {
        NavigationStack {
            SuiteSettingsView(
                appName: "Coffee Brew & Espresso Log",
                appIconSystemName: "cup.and.saucer.fill",
                theme: theme,
                appType: .coffee,
                onResetVault: {
                    await viewModel.resetLocalVault()
                },
                onStartDemo: {
                    await viewModel.injectDemoMachine()
                }
            ) {
                waterHardnessSettingsCard
            }
        }
        .tabItem {
            Label("Settings", systemImage: "gearshape.fill")
        }
        .tag(4)
    }
    
    @ViewBuilder
    private var waterHardnessSettingsCard: some View {
        BaseCardView(theme: theme) {
            VStack(alignment: .leading, spacing: 10) {
                Label("Water Hardness & Chemistry", systemImage: "drop.triangle.fill")
                    .font(.subheadline)
                    .fontWeight(.bold)
                    .foregroundColor(theme.primaryAccent)
                
                NavigationLink(destination: WaterHardnessCalibrationView(viewModel: viewModel)) {
                    HStack {
                        VStack(alignment: .leading, spacing: 2) {
                            Text("Water Hardness Calibration")
                                .font(.caption)
                                .foregroundColor(theme.textPrimary)
                            Text("\(Int(viewModel.waterHardnessDH)) °dH • Descale every \(Int(viewModel.allowedLitersUntilDescale))L")
                                .font(.caption2)
                                .foregroundColor(theme.textSecondary)
                        }
                        Spacer()
                        Image(systemName: "chevron.right")
                            .font(.caption)
                            .foregroundColor(theme.textSecondary)
                    }
                    .padding(10)
                    .background(theme.surfaceElevated)
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                }
            }
        }
    }
}
