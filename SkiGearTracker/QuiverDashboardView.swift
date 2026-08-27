//
//  QuiverDashboardView.swift
//  SkiGearTracker
//
//  Created for Nordic Asset Suite.
//  Strict Concurrency: Complete. Season Quiver & Gear Vault Navigation with Gemini AI.
//

import SwiftUI
import AssetCoreDatabase
import AssetCoreUIComponents
import AssetCoreLocalization
import AssetCoreAI
import AssetCoreOCR

public struct QuiverDashboardView: View {
    @Bindable var viewModel: SkiGearViewModel
    private let theme = SkiGearTheme()
    private let lang = LanguageManager.shared
    
    @State private var showingWaxGuide: Bool = false
    @State private var showingAddSki: Bool = false
    @State private var selectedTab: Int = 0
    
    public init(viewModel: SkiGearViewModel) {
        self.viewModel = viewModel
    }
    
    public var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 18) {
                    // Top Interactive Demo Bar
                    InteractiveDemoBar(
                        theme: theme,
                        onOpenGuide: {
                            viewModel.showingOnboardingGuide = true
                        },
                        onQuickDemoAdd: {
                            Task {
                                await viewModel.injectDemoSkiGear()
                            }
                        }
                    )
                    
                    // Season Switcher Segmented Control
                    Picker("Season", selection: $viewModel.selectedSeasonTab) {
                        Text("Active Winter Quiver").tag(0)
                        Text("Summer Vault (Stored)").tag(1)
                    }
                    .pickerStyle(.segmented)
                    
                    // Quick Action Calculation Cards
                    HStack(spacing: 12) {
                        Button(action: { viewModel.showingDINCalculator = true }) {
                            BaseCardView(theme: theme) {
                                HStack {
                                    Image(systemName: "gauge.with.needle.fill")
                                        .font(.title2)
                                        .foregroundColor(theme.secondaryAccent)
                                    VStack(alignment: .leading, spacing: 2) {
                                        Text("ISO 11088 DIN")
                                            .font(.caption2)
                                            .fontWeight(.bold)
                                            .foregroundColor(theme.textSecondary)
                                        Text("Calculate")
                                            .font(.subheadline)
                                            .fontWeight(.semibold)
                                            .foregroundColor(theme.textPrimary)
                                    }
                                }
                            }
                        }
                        .buttonStyle(.plain)
                        
                        Button(action: { showingWaxGuide = true }) {
                            BaseCardView(theme: theme) {
                                HStack {
                                    Image(systemName: "snowflake")
                                        .font(.title2)
                                        .foregroundColor(theme.primaryAccent)
                                    VStack(alignment: .leading, spacing: 2) {
                                        Text("WAX ADVISOR")
                                            .font(.caption2)
                                            .fontWeight(.bold)
                                            .foregroundColor(theme.textSecondary)
                                        Text("Snow Guide")
                                            .font(.subheadline)
                                            .fontWeight(.semibold)
                                            .foregroundColor(theme.textPrimary)
                                    }
                                }
                            }
                        }
                        .buttonStyle(.plain)
                    }
                    
                    // Active Quiver Gear List
                    let displayedSkis = viewModel.selectedSeasonTab == 0 ? viewModel.activeQuiver : viewModel.summerVault
                    
                    if displayedSkis.isEmpty {
                        VStack(spacing: 12) {
                            Image(systemName: "figure.skiing.downhill")
                                .font(.system(size: 48))
                                .foregroundColor(theme.textSecondary.opacity(0.4))
                            Text("No ski gear in this vault.")
                                .font(.headline)
                                .foregroundColor(theme.textSecondary)
                            Text("Scan bindings barcode or type your ski model to track DIN calibration and wax history.")
                                .font(.caption)
                                .foregroundColor(theme.textSecondary)
                                .multilineTextAlignment(.center)
                            
                            Button(action: { Task { await viewModel.injectDemoSkiGear() } }) {
                                Text("Load Demo Stöckli Laser SL")
                                    .font(.caption)
                                    .fontWeight(.bold)
                                    .padding(.horizontal, 16)
                                    .padding(.vertical, 8)
                                    .background(theme.primaryAccent)
                                    .foregroundColor(.white)
                                    .clipShape(Capsule())
                            }
                        }
                        .padding(.top, 30)
                    } else {
                        LazyVStack(spacing: 12) {
                            ForEach(displayedSkis) { ski in
                                BaseCardView(theme: theme) {
                                    HStack(spacing: 14) {
                                        ProductThumbnailView(
                                            userImageData: ski.gearPhotoData,
                                            categoryIconName: "figure.skiing.downhill",
                                            variant: .small,
                                            cornerRadius: 10,
                                            theme: theme
                                        )
                                        
                                        VStack(alignment: .leading, spacing: 3) {
                                            Text(ski.brand.uppercased())
                                                .font(.caption2)
                                                .fontWeight(.bold)
                                                .foregroundColor(theme.secondaryAccent)
                                            Text(ski.modelName)
                                                .font(.headline)
                                                .foregroundColor(theme.textPrimary)
                                            Text("Length: \(Int(ski.skiLengthCm)) cm | BSL: \(ski.bootSoleLengthMm) mm")
                                                .font(.caption2)
                                                .foregroundColor(theme.textSecondary)
                                        }
                                        Spacer()
                                        
                                        if let din = ski.latestDIN {
                                            MetricBadgeView(
                                                label: "DIN",
                                                value: String(format: "%.1f", din),
                                                status: .warning,
                                                theme: theme
                                            )
                                        }
                                    }
                                }
                            }
                        }
                        
                        // Tab Selector: Protocol vs Parts
                        Picker("Ski Tab", selection: $selectedTab) {
                            Text("Tuning & Wax Protocol").tag(0)
                            Text("Consumables & Waxes").tag(1)
                        }
                        .pickerStyle(.segmented)
                        
                        if selectedTab == 0 {
                            MaintenanceManualCardView(manual: viewModel.getSkiManual(), theme: theme)
                        } else {
                            SparePartsWearView(schedule: viewModel.getSkiParts(), theme: theme) { _ in }
                        }
                    }
                }
                .padding()
            }
            .background(theme.backgroundGrouped)
            .navigationTitle(lang.t(.skiSnowboardTuning))
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button(action: { viewModel.showingOnboardingGuide = true }) {
                        Image(systemName: "questionmark.circle")
                            .font(.title3)
                            .foregroundColor(theme.primaryAccent)
                    }
                }
                
                ToolbarItem(placement: .primaryAction) {
                    Button(action: { viewModel.showingLiveScanner = true }) {
                        Image(systemName: "camera.viewfinder")
                            .font(.title3)
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
            .fullScreenCover(isPresented: $viewModel.showingLiveScanner) {
                LiveScannerSwiftUIView(
                    onDetectedBarcode: { barcode in
                        Task {
                            let match = await AIExtractionService.shared.identifyOmniProduct(queryOrText: "Ski Bindings", barcode: barcode)
                            await viewModel.addSkiPair(brand: match.brand, model: match.modelName, serial: barcode, length: 165, bsl: 305, din: 8.0)
                        }
                    },
                    onCapturedPhoto: { photoData in
                        Task {
                            let match = await AIExtractionService.shared.identifyOmniProduct(queryOrText: "Skis", imageData: photoData)
                            await viewModel.addSkiPair(brand: match.brand, model: match.modelName, serial: "SN-\(Int.random(in: 10000...99999))", length: 170, bsl: 305, din: 7.5)
                        }
                    },
                    onManualSearchSubmit: { query in
                        Task {
                            let match = await AIExtractionService.shared.identifyOmniProduct(queryOrText: query)
                            await viewModel.addSkiPair(brand: match.brand, model: match.modelName, serial: "SN-\(Int.random(in: 10000...99999))", length: 170, bsl: 305, din: 7.5)
                        }
                    }
                )
            }
            .task {
                await viewModel.loadGear()
            }
        }
    }
}
