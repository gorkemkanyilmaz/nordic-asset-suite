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
            .tabItem {
                Label("Settings", systemImage: "gearshape.fill")
            }
            .tag(4)
        }
        .tint(theme.primaryAccent)
        .preferredColorScheme(.dark)
    }
}
