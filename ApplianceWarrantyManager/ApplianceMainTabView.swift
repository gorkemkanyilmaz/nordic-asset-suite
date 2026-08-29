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

public struct ApplianceMainTabView: View {
    @Bindable public var viewModel: ApplianceViewModel
    private let theme = ApplianceTheme()
    private let lang = LanguageManager.shared
    
    @State private var selectedTab: Int = 0
    
    public init(viewModel: ApplianceViewModel) {
        self.viewModel = viewModel
    }
    
    public var body: some View {
        TabView(selection: $selectedTab) {
            RoomsDashboardView(viewModel: viewModel)
                .tabItem {
                    Label("Home", systemImage: "house.fill")
                }
                .tag(0)
            
            AllAppliancesListView(viewModel: viewModel)
                .tabItem {
                    Label("Appliances", systemImage: "list.bullet")
                }
                .tag(1)
            
            WarrantiesTimelineView(viewModel: viewModel)
                .tabItem {
                    Label("Warranties", systemImage: "shield.lefthalf.filled")
                }
                .badge(viewModel.appliances.filter { !$0.isWarrantyActive }.count)
                .tag(2)
            
            NavigationStack {
                InteractiveOnboardingView(
                    appName: lang.t(.applianceWarrantyManager),
                    theme: theme,
                    onStartDemo: { Task { await viewModel.injectDemoAppliances() } }
                )
                .navigationTitle("Settings")
            }
            .tabItem {
                Label("Settings", systemImage: "gearshape.fill")
            }
            .tag(3)
        }
        .tint(theme.primaryAccent)
        .preferredColorScheme(.dark)
    }
}
