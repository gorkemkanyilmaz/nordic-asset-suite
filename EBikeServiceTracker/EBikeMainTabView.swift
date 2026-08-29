//
//  EBikeMainTabView.swift
//  EBikeServiceTracker
//
//  Created for Nordic Asset Suite.
//  Strict Concurrency: Complete. Root 5-Tab Navigation matching localhost.
//

import SwiftUI
import AssetCoreDatabase
import AssetCoreUIComponents
import AssetCoreLocalization

public struct EBikeMainTabView: View {
    @Bindable public var viewModel: EBikeViewModel
    private let theme = EBikeTheme()
    private let lang = LanguageManager.shared
    
    @State private var selectedTab: Int = 0
    
    public init(viewModel: EBikeViewModel) {
        self.viewModel = viewModel
    }
    
    public var body: some View {
        TabView(selection: $selectedTab) {
            GarageDashboardView(viewModel: viewModel)
                .tabItem {
                    Label("Ride", systemImage: "bicycle")
                }
                .tag(0)
            
            BikeSpecsView(viewModel: viewModel)
                .tabItem {
                    Label("Bike", systemImage: "slider.horizontal.3")
                }
                .tag(1)
            
            EBikePartsView(viewModel: viewModel)
                .tabItem {
                    Label("Parts", systemImage: "wrench.and.screwdriver.fill")
                }
                .tag(2)
            
            NavigationStack {
                DigitalTwinTelemetryView(viewModel: viewModel)
            }
            .tabItem {
                Label("Telemetry", systemImage: "gauge.with.dots.needle.bottom.50percent")
            }
            .tag(3)
            
            NavigationStack {
                InteractiveOnboardingView(
                    appName: lang.t(.ebikeServiceMaintenance),
                    theme: theme,
                    onStartDemo: { Task { await viewModel.injectDemoBike() } }
                )
                .navigationTitle("Settings")
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
