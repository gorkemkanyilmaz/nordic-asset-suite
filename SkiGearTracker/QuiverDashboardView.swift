//
//  QuiverDashboardView.swift
//  SkiGearTracker
//
//  Created for Nordic Asset Suite.
//  Strict Concurrency: Complete. Clean Nordic Quiver Dashboard matching localhost.
//

import SwiftUI
import AssetCoreDatabase
import AssetCoreUIComponents
import AssetCoreLocalization

public struct QuiverDashboardView: View {
    @Bindable var viewModel: SkiGearViewModel
    private let theme = SkiGearTheme()
    private let lang = LanguageManager.shared
    
    @State private var showingWaxGuide: Bool = false
    @State private var showingAddSki: Bool = false
    @State private var checklistItems: [String: Bool] = [
        "Stöckli Laser SL Skis & Salomon Freeflex 14": true,
        "Lange RS 130 Ski Boots (305 mm Sole)": true,
        "Avalanche Transceiver & Carbon Probe": false,
        "Toko Blue Hydrocarbon Cold Wax Iron": true
    ]
    
    public init(viewModel: SkiGearViewModel) {
        self.viewModel = viewModel
    }
    
    public var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 16) {
                    greetingSection
                    
                    if let ski = viewModel.activeQuiver.first ?? viewModel.skis.first {
                        // Hero Ski Setup Card
                        BaseCardView(theme: theme) {
                            VStack(alignment: .leading, spacing: 12) {
                                HStack(spacing: 14) {
                                    ProductThumbnailView(
                                        userImageData: nil,
                                        categoryIconName: "figure.skiing.downhill",
                                        variant: .medium,
                                        cornerRadius: 12,
                                        theme: theme
                                    )
                                    
                                    VStack(alignment: .leading, spacing: 2) {
                                        Text(ski.brand.uppercased())
                                            .font(.caption)
                                            .fontWeight(.bold)
                                            .foregroundColor(theme.secondaryAccent)
                                        Text("\(ski.modelName) (\(Int(ski.skiLengthCm))cm)")
                                            .font(.title3)
                                            .fontWeight(.bold)
                                            .foregroundColor(theme.textPrimary)
                                    }
                                    Spacer()
                                    
                                    MetricBadgeView(
                                        label: "DIN",
                                        value: String(format: "%.1f", ski.latestDIN ?? 8.5),
                                        status: .warning,
                                        theme: theme
                                    )
                                }
                                
                                Divider()
                                
                                HStack {
                                    VStack(alignment: .leading, spacing: 2) {
                                        Text("ISO 11088 DIN")
                                            .font(.caption2)
                                            .fontWeight(.bold)
                                            .foregroundColor(theme.textSecondary)
                                        Text("DIN \(String(format: "%.1f", ski.latestDIN ?? 8.5)) (305mm BSL)")
                                            .font(.caption)
                                            .fontWeight(.bold)
                                            .foregroundColor(theme.primaryAccent)
                                    }
                                    
                                    Spacer()
                                    
                                    VStack(alignment: .trailing, spacing: 2) {
                                        Text("BASE WAX")
                                            .font(.caption2)
                                            .fontWeight(.bold)
                                            .foregroundColor(theme.textSecondary)
                                        Text("Toko Blue (-10°C to -30°C)")
                                            .font(.caption)
                                            .fontWeight(.bold)
                                            .foregroundColor(theme.statusSuccess)
                                    }
                                }
                                
                                Button(action: { viewModel.showingDINCalculator = true }) {
                                    HStack {
                                        Image(systemName: "gauge.with.needle.fill")
                                        Text("Recalculate Binding DIN (ISO 11088)")
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
                        
                        // Season Readiness Card
                        VStack(alignment: .leading, spacing: 12) {
                            Text("SEASON READINESS & TUNING")
                                .font(.caption2)
                                .fontWeight(.bold)
                                .foregroundColor(theme.textSecondary)
                            
                            readinessRow(label: "Ski Days This Season", value: "18 Days on Snow")
                            readinessRow(label: "Side Edge Bevel", value: "88.0° Diamond Honed (4 Days Ago)")
                            readinessRow(label: "Next Mountain Trip", value: "Zermatt (In 12 Days)", isAccent: true)
                        }
                        .padding(16)
                        .background(theme.cardBackground)
                        .clipShape(RoundedRectangle(cornerRadius: 14))
                        .overlay(
                            RoundedRectangle(cornerRadius: 14)
                                .stroke(theme.borderSubtle, lineWidth: 1)
                        )
                        
                        // Mountain Trip Checklist
                        VStack(alignment: .leading, spacing: 12) {
                            Text("TRIP PACKING CHECKLIST")
                                .font(.caption2)
                                .fontWeight(.bold)
                                .foregroundColor(theme.textSecondary)
                            
                            ForEach(Array(checklistItems.keys.sorted()), id: \.self) { item in
                                Button(action: {
                                    checklistItems[item] = !(checklistItems[item] ?? false)
                                }) {
                                    HStack(spacing: 12) {
                                        Image(systemName: (checklistItems[item] ?? false) ? "checkmark.square.fill" : "square")
                                            .foregroundColor((checklistItems[item] ?? false) ? theme.primaryAccent : theme.textSecondary)
                                            .font(.title3)
                                        
                                        Text(item)
                                            .font(.caption)
                                            .foregroundColor(theme.textPrimary)
                                        
                                        Spacer()
                                    }
                                    .padding(.vertical, 4)
                                }
                                .buttonStyle(.plain)
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
            .navigationTitle(lang.t(.skiSnowboardTuning))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button(action: { viewModel.showingOnboardingGuide = true }) {
                        Image(systemName: "questionmark.circle")
                            .font(.subheadline)
                            .foregroundColor(theme.primaryAccent)
                    }
                }
                
                ToolbarItem(placement: .primaryAction) {
                    Button(action: { viewModel.showingLiveScanner = true }) {
                        Image(systemName: "plus")
                            .font(.subheadline)
                            .fontWeight(.bold)
                            .foregroundColor(theme.primaryAccent)
                    }
                }
            }
            .sheet(isPresented: $viewModel.showingDINCalculator) {
                DINCalculatorView()
            }
            .sheet(isPresented: $showingWaxGuide) {
                WaxingGuideView()
            }
            .sheet(isPresented: $viewModel.showingOnboardingGuide) {
                InteractiveOnboardingView(
                    appName: lang.t(.skiSnowboardTuning),
                    theme: theme,
                    onStartDemo: {
                        Task { await viewModel.injectDemoSkiGear() }
                    }
                )
            }
            .task {
                await viewModel.loadGear()
            }
        }
    }
    
    private var greetingSection: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("Alpine Quiver")
                .font(.caption)
                .fontWeight(.bold)
                .foregroundColor(theme.secondaryAccent)
            
            Text("Stöckli Laser SL (165cm)")
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(theme.textPrimary)
            
            Text("Salomon Freeflex 14 Race Bindings")
                .font(.subheadline)
                .foregroundColor(theme.textSecondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    private func readinessRow(label: String, value: String, isAccent: Bool = false) -> some View {
        HStack {
            Text(label)
                .font(.caption)
                .foregroundColor(theme.textSecondary)
            Spacer()
            Text(value)
                .font(.caption)
                .fontWeight(.bold)
                .foregroundColor(isAccent ? theme.primaryAccent : theme.textPrimary)
        }
        .padding(.vertical, 2)
    }
}
