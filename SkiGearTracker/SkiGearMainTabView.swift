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
import AssetCoreSubscription

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
                SuiteSettingsView(
                    appName: lang.t(.skiSnowboardTuning),
                    appIconSystemName: "figure.skiing.downhill",
                    theme: theme,
                    appType: .skiGear,
                    onResetVault: {
                        await viewModel.resetLocalVault()
                    },
                    onStartDemo: {
                        await viewModel.injectDemoSkiGear()
                    }
                ) {
                    BaseCardView(theme: theme) {
                        VStack(alignment: .leading, spacing: 10) {
                            Label("ISO 11088 DIN & Safety Setup", systemImage: "gauge.with.needle.fill")
                                .font(.subheadline)
                                .fontWeight(.bold)
                                .foregroundColor(theme.primaryAccent)
                            
                            NavigationLink(destination: DINCalculatorView()) {
                                HStack {
                                    VStack(alignment: .leading, spacing: 2) {
                                        Text("Binding Release Torque Calculator")
                                            .font(.caption)
                                            .foregroundColor(theme.textPrimary)
                                        Text("Certified ISO 11088 / ASTM F939 algorithm")
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
            .tag(3)
        }
        .tint(theme.primaryAccent)
        .preferredColorScheme(.dark)
    }
}
