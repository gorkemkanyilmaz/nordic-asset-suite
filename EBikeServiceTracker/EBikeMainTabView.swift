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
import AssetCoreSubscription

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
                SuiteSettingsView(
                    appName: lang.t(.ebikeServiceMaintenance),
                    appIconSystemName: "bicycle",
                    theme: theme,
                    appType: .ebike,
                    onResetVault: {
                        await viewModel.resetLocalVault()
                    },
                    onStartDemo: {
                        await viewModel.injectDemoBike()
                    }
                ) {
                    BaseCardView(theme: theme) {
                        VStack(alignment: .leading, spacing: 10) {
                            Label("Rider Telemetry & Suspension", systemImage: "slider.horizontal.3")
                                .font(.subheadline)
                                .fontWeight(.bold)
                                .foregroundColor(theme.primaryAccent)
                            
                            NavigationLink(destination: DigitalTwinTelemetryView(viewModel: viewModel)) {
                                HStack {
                                    VStack(alignment: .leading, spacing: 2) {
                                        Text("Digital Twin Sensor Calibration")
                                            .font(.caption)
                                            .foregroundColor(theme.textPrimary)
                                        Text("Rider: \(Int(viewModel.riderWeightKg)) kg • Fork: \(Int(viewModel.suspensionRecommendation.forkPressurePSI)) PSI")
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
