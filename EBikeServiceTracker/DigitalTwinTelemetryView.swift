//
//  DigitalTwinTelemetryView.swift
//  EBikeServiceTracker
//
//  Created for Nordic Asset Suite.
//  Strict Concurrency: Complete. Digital Twin Gauges, Chain Wear, & Suspension PSI Setup.
//

import SwiftUI
import AssetCoreDatabase
import AssetCoreUIComponents

public struct DigitalTwinTelemetryView: View {
    @Bindable var viewModel: EBikeViewModel
    private let theme = EBikeTheme()
    
    public init(viewModel: EBikeViewModel) {
        self.viewModel = viewModel
    }
    
    public var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Digital Twin Wear Gauges
                BaseCardView(theme: theme) {
                    VStack(alignment: .leading, spacing: 14) {
                        Label("Drivetrain Chain Wear Gauge", systemImage: "link")
                            .font(.headline)
                            .foregroundColor(theme.primaryAccent)
                        
                        Divider()
                        
                        HStack {
                            Text("Measured Elongation:")
                                .font(.subheadline)
                                .foregroundColor(theme.textSecondary)
                            Spacer()
                            Text(String(format: "%.2f%%", viewModel.measuredChainWear))
                                .font(.title3)
                                .fontWeight(.bold)
                                .foregroundColor(viewModel.measuredChainWear >= 0.75 ? theme.statusCritical : (viewModel.measuredChainWear >= 0.50 ? theme.statusWarning : theme.statusSuccess))
                        }
                        
                        Slider(value: $viewModel.measuredChainWear, in: 0.2...1.2, step: 0.05)
                            .tint(theme.secondaryAccent)
                        
                        HStack {
                            Image(systemName: viewModel.measuredChainWear >= 0.75 ? "exclamationmark.octagon.fill" : "checkmark.seal.fill")
                                .foregroundColor(viewModel.measuredChainWear >= 0.75 ? theme.statusCritical : theme.statusSuccess)
                            Text(viewModel.chainStatus.rawValue)
                                .font(.caption)
                                .fontWeight(.semibold)
                                .foregroundColor(viewModel.measuredChainWear >= 0.75 ? theme.statusCritical : theme.textPrimary)
                        }
                    }
                }
                
                // Suspension PSI Setup Card
                BaseCardView(theme: theme) {
                    VStack(alignment: .leading, spacing: 14) {
                        Label("Suspension Sag & Pressure Setup", systemImage: "waveform.path.ecg")
                            .font(.headline)
                            .foregroundColor(theme.primaryAccent)
                        
                        Divider()
                        
                        VStack(alignment: .leading, spacing: 4) {
                            HStack {
                                Text("Rider Weight (with gear):")
                                    .font(.subheadline)
                                    .foregroundColor(theme.textSecondary)
                                Spacer()
                                Text("\(Int(viewModel.riderWeightKg)) kg")
                                    .fontWeight(.bold)
                                    .foregroundColor(theme.primaryAccent)
                            }
                            Slider(value: $viewModel.riderWeightKg, in: 50...130, step: 1)
                                .tint(theme.secondaryAccent)
                        }
                        
                        HStack(spacing: 12) {
                            VStack(alignment: .leading, spacing: 4) {
                                Text("FORK PRESSURE")
                                    .font(.caption2)
                                    .fontWeight(.bold)
                                    .foregroundColor(theme.textSecondary)
                                Text("\(Int(viewModel.suspensionRecommendation.recommendedForkPSI)) PSI")
                                    .font(.title3)
                                    .fontWeight(.bold)
                                    .foregroundColor(theme.secondaryAccent)
                            }
                            
                            Spacer()
                            
                            VStack(alignment: .leading, spacing: 4) {
                                Text("REAR SHOCK")
                                    .font(.caption2)
                                    .fontWeight(.bold)
                                    .foregroundColor(theme.textSecondary)
                                Text("\(Int(viewModel.suspensionRecommendation.recommendedRearShockPSI)) PSI")
                                    .font(.title3)
                                    .fontWeight(.bold)
                                    .foregroundColor(theme.secondaryAccent)
                            }
                            
                            Spacer()
                            
                            VStack(alignment: .leading, spacing: 4) {
                                Text("REBOUND")
                                    .font(.caption2)
                                    .fontWeight(.bold)
                                    .foregroundColor(theme.textSecondary)
                                Text("\(viewModel.suspensionRecommendation.reboundClicksFromClosed) Clicks")
                                    .font(.title3)
                                    .fontWeight(.bold)
                                    .foregroundColor(theme.primaryAccent)
                            }
                        }
                        .padding(.top, 4)
                    }
                }
            }
            .padding()
        }
        .background(theme.backgroundGrouped.ignoresSafeArea())
        .navigationTitle("Telemetry & Setup")
    }
}
