//
//  GarageDashboardView.swift
//  EBikeServiceTracker
//
//  Created for Nordic Asset Suite.
//  Strict Concurrency: Complete. Garage-Centric Dashboard & Bike Selector with Gemini AI.
//

import SwiftUI
import AssetCoreDatabase
import AssetCoreUIComponents
import AssetCoreLocalization
import AssetCoreAI
import AssetCoreOCR

public struct GarageDashboardView: View {
    @Bindable var viewModel: EBikeViewModel
    private let theme = EBikeTheme()
    private let lang = LanguageManager.shared
    
    @State private var showingAddBike: Bool = false
    @State private var selectedTab: Int = 0
    
    public init(viewModel: EBikeViewModel) {
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
                                await viewModel.injectDemoBike()
                            }
                        }
                    )
                    
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
                                        value: "\(String(format: "%.0f", bike.latestBatteryHealthPercentage ?? 100))%",
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
                            }
                        }
                        
                        // Navigation Link to Bike Health & Components
                        NavigationLink(destination: DigitalTwinTelemetryView(viewModel: viewModel)) {
                            BaseCardView(theme: theme) {
                                HStack {
                                    Image(systemName: "gauge.with.dots.needle.bottom.50percent")
                                        .font(.title2)
                                        .foregroundColor(theme.secondaryAccent)
                                    VStack(alignment: .leading, spacing: 2) {
                                        Text("BIKE HEALTH & WEAR GAUGES")
                                            .font(.caption2)
                                            .fontWeight(.bold)
                                            .foregroundColor(theme.textSecondary)
                                        Text("Chain Stretch & Suspension PSI")
                                            .font(.subheadline)
                                            .fontWeight(.semibold)
                                            .foregroundColor(theme.textPrimary)
                                    }
                                    Spacer()
                                    Image(systemName: "chevron.right")
                                        .foregroundColor(theme.textSecondary)
                                }
                            }
                        }
                        .buttonStyle(.plain)
                        
                        // Tab Selector: Protocol vs Parts
                        Picker("EBike Tab", selection: $selectedTab) {
                            Text("Service Protocol").tag(0)
                            Text("Wear Parts").tag(1)
                        }
                        .pickerStyle(.segmented)
                        
                        if selectedTab == 0 {
                            MaintenanceManualCardView(manual: viewModel.getEBikeManual(), theme: theme)
                        } else {
                            SparePartsWearView(schedule: viewModel.getEBikeParts(), theme: theme) { _ in }
                        }
                    } else {
                        VStack(spacing: 12) {
                            Image(systemName: "bicycle")
                                .font(.system(size: 48))
                                .foregroundColor(theme.textSecondary.opacity(0.4))
                            Text("Garage is Empty")
                                .font(.headline)
                                .foregroundColor(theme.textSecondary)
                            Text("Scan frame serial or type your model to track battery telemetry and maintenance.")
                                .font(.caption)
                                .foregroundColor(theme.textSecondary)
                                .multilineTextAlignment(.center)
                            
                            Button(action: { Task { await viewModel.injectDemoBike() } }) {
                                Text("Load Demo Scott Patron eRIDE")
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
                    }
                }
                .padding()
            }
            .background(theme.backgroundGrouped)
            .navigationTitle(lang.t(.ebikeServiceMaintenance))
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
            .sheet(isPresented: $viewModel.showingOnboardingGuide) {
                InteractiveOnboardingView(
                    appName: lang.t(.ebikeServiceMaintenance),
                    theme: theme,
                    onStartDemo: {
                        Task { await viewModel.injectDemoBike() }
                    }
                )
            }
            .fullScreenCover(isPresented: $viewModel.showingLiveScanner) {
                LiveScannerSwiftUIView(
                    onDetectedBarcode: { barcode in
                        Task {
                            let match = await AIExtractionService.shared.identifyOmniProduct(queryOrText: "E-Bike Frame", barcode: barcode)
                            await viewModel.addBike(brand: match.brand, model: match.modelName, frameNo: barcode, motor: "Bosch Performance Line CX", odometer: 1200)
                        }
                    },
                    onCapturedPhoto: { photoData in
                        Task {
                            let match = await AIExtractionService.shared.identifyOmniProduct(queryOrText: "E-Bike", imageData: photoData)
                            await viewModel.addBike(brand: match.brand, model: match.modelName, frameNo: "SN-\(Int.random(in: 10000...99999))", motor: "Bosch CX", odometer: 800)
                        }
                    },
                    onManualSearchSubmit: { query in
                        Task {
                            let match = await AIExtractionService.shared.identifyOmniProduct(queryOrText: query)
                            await viewModel.addBike(brand: match.brand, model: match.modelName, frameNo: "SN-\(Int.random(in: 10000...99999))", motor: "Bosch CX", odometer: 800)
                        }
                    }
                )
            }
            .task {
                await viewModel.loadBikes()
            }
        }
    }
}
