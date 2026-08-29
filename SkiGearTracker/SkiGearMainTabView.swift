//
//  SkiGearMainTabView.swift
//  SkiGearTracker
//
//  Created for Nordic Asset Suite.
//  Strict Concurrency: Complete. Root 5-Tab Alpine Navigation matching localhost.
//

import SwiftUI
import AssetCoreDatabase
import AssetCoreUIComponents
import AssetCoreLocalization

public struct SkiGearMainTabView: View {
    @Bindable public var viewModel: SkiGearViewModel
    private let theme = SkiGearTheme()
    private let lang = LanguageManager.shared
    
    @State private var selectedTab: Int = 0
    
    public init(viewModel: SkiGearViewModel) {
        self.viewModel = viewModel
    }
    
    public var body: some View {
        TabView(selection: $selectedTab) {
            QuiverDashboardView(viewModel: viewModel)
                .tabItem {
                    Label("Quiver", systemImage: "figure.skiing.downhill")
                }
                .tag(0)
            
            DINCalculatorView()
                .tabItem {
                    Label("Setup", systemImage: "gauge.with.needle.fill")
                }
                .tag(1)
            
            WaxingGuideView()
                .tabItem {
                    Label("Tuning", systemImage: "snowflake")
                }
                .tag(2)
            
            NavigationStack {
                InteractiveOnboardingView(
                    appName: lang.t(.skiSnowboardTuning),
                    theme: theme,
                    onStartDemo: { Task { await viewModel.injectDemoSkiGear() } }
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
