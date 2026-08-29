//
//  GarageDashboardView.swift
//  EBikeServiceTracker
//
//  Created for Nordic Asset Suite.
//  Strict Concurrency: Complete. Clean Nordic Ride Dashboard matching localhost.
//

import SwiftUI
import AssetCoreDatabase
import AssetCoreUIComponents
import AssetCoreLocalization

public struct GarageDashboardView: View {
    @Bindable var viewModel: EBikeViewModel
    private let theme = EBikeTheme()
    private let lang = LanguageManager.shared
    
    @State private var showingLogRide: Bool = false
    
    public init(viewModel: EBikeViewModel) {
        self.viewModel = viewModel
    }
    
    public var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 16) {
                    greetingSection
                    
                    if let bike = viewModel.currentBike {
                        // Digital Twin Bike Hero Card
                        BaseCardView(theme: theme) {
                            VStack(alignment: .leading, spacing: 12) {
                                HStack(spacing: 14) {
                                    ProductThumbnailView(
                                        userImageData: nil,
                                        categoryIconName: "bicycle",
                                        variant: .medium,
                                        cornerRadius: 12,
                                        theme: theme
                                    )
                                    
                                    VStack(alignment: .leading, spacing: 2) {
                                        Text(bike.brand.uppercased())
                                            .font(.caption)
                                            .fontWeight(.bold)
                                            .foregroundColor(theme.secondaryAccent)
                                        Text(bike.modelName)
                                            .font(.title3)
                                            .fontWeight(.bold)
                                            .foregroundColor(theme.textPrimary)
                                    }
                                    Spacer()
                                    
                                    MetricBadgeView(
                                        label: "Battery",
                                        value: "\(String(format: "%.0f", bike.latestBatteryHealthPercentage ?? 98))%",
                                        status: .success,
                                        theme: theme
                                    )
                                }
                                
                                Divider()
                                
                                HStack {
                                    VStack(alignment: .leading, spacing: 2) {
                                        Text("TOTAL ODOMETER")
                                            .font(.caption2)
                                            .fontWeight(.bold)
                                            .foregroundColor(theme.textSecondary)
                                        Text(RegionalFormatter.shared.formatDistance(kilometers: bike.totalOdometerKm))
                                            .font(.headline)
                                            .fontWeight(.bold)
                                            .foregroundColor(theme.primaryAccent)
                                    }
                                    
                                    Spacer()
                                    
                                    VStack(alignment: .trailing, spacing: 2) {
                                        Text("MOTOR SYSTEM")
                                            .font(.caption2)
                                            .fontWeight(.bold)
                                            .foregroundColor(theme.textSecondary)
                                        Text(bike.motorSystem)
                                            .font(.caption)
                                            .fontWeight(.semibold)
                                            .foregroundColor(theme.textPrimary)
                                    }
                                }
                                
                                Button(action: { showingLogRide = true }) {
                                    HStack {
                                        Image(systemName: "plus.circle.fill")
                                        Text("Log Completed Ride")
                                            .fontWeight(.bold)
                                    }
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 12)
                                    .background(theme.primaryAccent)
                                    .foregroundColor(.white)
                                    .clipShape(RoundedRectangle(cornerRadius: 10))
                                }
                                .padding(.top, 4)
                            }
                        }
                        
                        // Component Health & Gauges
                        VStack(alignment: .leading, spacing: 12) {
                            Text("COMPONENT WEAR & TELEMETRY")
                                .font(.caption2)
                                .fontWeight(.bold)
                                .foregroundColor(theme.textSecondary)
                            
                            // Chain Elongation
                            VStack(alignment: .leading, spacing: 6) {
                                HStack {
                                    Text("CHAIN ELONGATION GAUGE")
                                        .font(.caption2)
                                        .foregroundColor(theme.textMuted)
                                    Spacer()
                                    Text("0.35% (Optimal)")
                                        .font(.caption)
                                        .fontWeight(.bold)
                                        .foregroundColor(theme.statusSuccess)
                                }
                                ProgressView(value: 0.35, total: 1.0)
                                    .tint(theme.statusSuccess)
                                Text("Replace chain when stretch reaches 0.75% (SRAM 12-Speed)")
                                    .font(.system(size: 10))
                                    .foregroundColor(theme.textMuted)
                            }
                            .padding(12)
                            .background(theme.surfaceElevated)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                            
                            // Suspension Sag
                            VStack(alignment: .leading, spacing: 6) {
                                HStack {
                                    Text("SUSPENSION AIR PRESSURE")
                                        .font(.caption2)
                                        .foregroundColor(theme.textMuted)
                                    Spacer()
                                    Text("165 PSI / 25% Sag")
                                        .font(.caption)
                                        .fontWeight(.bold)
                                        .foregroundColor(theme.primaryAccent)
                                }
                                Text("Calibrated for 78 kg rider weight on Fox 38 Float 160mm fork")
                                    .font(.system(size: 10))
                                    .foregroundColor(theme.textMuted)
                            }
                            .padding(12)
                            .background(theme.surfaceElevated)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                        }
                        .padding(16)
                        .background(theme.cardBackground)
                        .clipShape(RoundedRectangle(cornerRadius: 14))
                        .overlay(
                            RoundedRectangle(cornerRadius: 14)
                                .stroke(theme.borderSubtle, lineWidth: 1)
                        )
                        
                        // Recent Service Log
                        VStack(alignment: .leading, spacing: 10) {
                            Text("RECENT MAINTENANCE HISTORY")
                                .font(.caption2)
                                .fontWeight(.bold)
                                .foregroundColor(theme.textSecondary)
                            
                            HStack(spacing: 12) {
                                Image(systemName: "wrench.fill")
                                    .foregroundColor(theme.primaryAccent)
                                VStack(alignment: .leading, spacing: 2) {
                                    Text("Ceramic Chain Lubrication")
                                        .font(.subheadline)
                                        .fontWeight(.semibold)
                                        .foregroundColor(theme.textPrimary)
                                    Text("Applied at 1,300 km · Next due at 1,450 km")
                                        .font(.caption2)
                                        .foregroundColor(theme.textSecondary)
                                }
                                Spacer()
                            }
                        }
                        .padding(16)
                        .background(theme.cardBackground)
                        .clipShape(RoundedRectangle(cornerRadius: 14))
                        .overlay(
                            RoundedRectangle(cornerRadius: 14)
                                .stroke(theme.borderSubtle, lineWidth: 1)
                        )
                    }
                }
                .padding()
            }
            .background(theme.backgroundGrouped.ignoresSafeArea())
            .preferredColorScheme(.dark)
            .navigationTitle(lang.t(.ebikeServiceMaintenance))
            .navigationBarTitleDisplayMode(.inline)
            .sheet(isPresented: $showingLogRide) {
                LogRideSheet(viewModel: viewModel)
            }
            .sheet(isPresented: $viewModel.showingOnboardingGuide) {
                InteractiveOnboardingView(
                    appName: lang.t(.ebikeServiceMaintenance),
                    theme: theme,
                    onStartDemo: {
                        Task { await viewModel.injectDemoBike() }
                    }
                )
            }
            .task {
                await viewModel.loadBikes()
            }
        }
    }
    
    private var greetingSection: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("Garage Fleet")
                .font(.caption)
                .fontWeight(.bold)
                .foregroundColor(theme.secondaryAccent)
            
            Text("Scott Patron eRIDE 900")
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(theme.textPrimary)
            
            Text("Bosch Performance Line CX (85 Nm)")
                .font(.subheadline)
                .foregroundColor(theme.textSecondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}
