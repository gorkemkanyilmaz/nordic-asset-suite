//
//  ApplianceMainTabView.swift
//  ApplianceWarrantyManager
//
//  Created for Nordic Asset Suite.
//  Strict Concurrency: Complete. Root 5-Tab Navigation matching localhost structure.
//

import SwiftUI
import AssetCoreDatabase
import AssetCoreUIComponents
import AssetCoreLocalization
import AssetCoreSubscription

public struct ApplianceMainTabView: View {
    @Bindable public var viewModel: ApplianceViewModel
    private let theme = ApplianceTheme()
    @State private var lang = LanguageManager.shared
    
    public init(viewModel: ApplianceViewModel) {
        self.viewModel = viewModel
    }
    
    public var body: some View {
        TabView(selection: $viewModel.selectedTab) {
            RoomsDashboardView(viewModel: viewModel)
                .tabItem {
                    Label(lang.t(.navHome), systemImage: "house.fill")
                }
                .tag(0)
            
            AllAppliancesListView(viewModel: viewModel)
                .tabItem {
                    Label(lang.t(.navAppliances), systemImage: "list.bullet")
                }
                .tag(1)
            
            WarrantiesTimelineView(viewModel: viewModel)
                .tabItem {
                    Label(lang.t(.navWarranties), systemImage: "shield.lefthalf.filled")
                }
                .badge(viewModel.appliances.filter { !$0.isWarrantyActive }.count)
                .tag(2)
            
            NavigationStack {
                SuiteSettingsView(
                    appName: lang.t(.applianceWarrantyManager),
                    appIconSystemName: "shield.lefthalf.filled",
                    theme: theme,
                    appType: .appliance,
                    onResetVault: {
                        await viewModel.resetLocalVault()
                    },
                    onStartDemo: {
                        await viewModel.injectDemoAppliances()
                    }
                )
            }
            .tabItem {
                Label(lang.t(.navSettings), systemImage: "gearshape.fill")
            }
            .tag(3)
        }
        .tint(theme.primaryAccent)
        .preferredColorScheme(.dark)
    }
}
