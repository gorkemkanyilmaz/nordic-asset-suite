//
//  BaristaDeckView.swift
//  CoffeeMachineCompanion
//
//  Created for Nordic Asset Suite.
//  Strict Concurrency: Complete. Barista Deck & Machine Companion Navigation with Gemini AI.
//

import SwiftUI
import AssetCoreDatabase
import AssetCoreUIComponents
import AssetCoreLocalization
import AssetCoreAI
import AssetCoreOCR

public struct BaristaDeckView: View {
    @Bindable var viewModel: CoffeeViewModel
    private let theme = CoffeeTheme()
    private let lang = LanguageManager.shared
    
    @State private var showingHardnessSheet: Bool = false
    @State private var showingRecipeJournal: Bool = false
    @State private var showingAddMachine: Bool = false
    @State private var selectedTab: Int = 0
    
    public init(viewModel: CoffeeViewModel) {
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
                                await viewModel.injectDemoMachine()
                            }
                        }
                    )
                    
                    if let machine = viewModel.currentMachine {
                        // Hero Barista Machine Card
                        BaseCardView(theme: theme) {
                            VStack(alignment: .leading, spacing: 12) {
                                HStack(spacing: 14) {
                                    ProductThumbnailView(
                                        userImageData: machine.machinePhotoData,
                                        categoryIconName: "mug.fill",
                                        variant: .medium,
                                        cornerRadius: 12,
                                        theme: theme
                                    )
                                    
                                    VStack(alignment: .leading, spacing: 2) {
                                        Text(machine.brand.uppercased())
                                            .font(.caption)
                                            .fontWeight(.bold)
                                            .foregroundColor(theme.secondaryAccent)
                                        Text(machine.modelName)
                                            .font(.title3)
                                            .fontWeight(.bold)
                                            .foregroundColor(theme.textPrimary)
                                    }
                                    Spacer()
                                    
                                    MetricBadgeView(
                                        label: "Shots",
                                        value: "\(machine.totalShotsPulled)",
                                        status: .normal,
                                        theme: theme
                                    )
                                }
                                
                                Divider()
                                
                                HStack {
                                    VStack(alignment: .leading, spacing: 2) {
                                        Text("WATER CHEMISTRY")
                                            .font(.caption2)
                                            .fontWeight(.bold)
                                            .foregroundColor(theme.textSecondary)
                                        Text("\(String(format: "%.1f", viewModel.waterHardnessDH)) °dH")
                                            .font(.headline)
                                            .fontWeight(.bold)
                                            .foregroundColor(theme.primaryAccent)
                                    }
                                    
                                    Spacer()
                                    
                                    VStack(alignment: .trailing, spacing: 2) {
                                        Text("DESCALE HORIZON")
                                            .font(.caption2)
                                            .fontWeight(.bold)
                                            .foregroundColor(theme.textSecondary)
                                        Text("\(Int(viewModel.allowedLitersUntilDescale)) L Remaining")
                                            .font(.caption)
                                            .fontWeight(.bold)
                                            .foregroundColor(theme.statusSuccess)
                                    }
                                }
                            }
                        }
                        
                        // Interactive Quick Actions
                        HStack(spacing: 12) {
                            Button(action: { showingHardnessSheet = true }) {
                                BaseCardView(theme: theme) {
                                    HStack {
                                        Image(systemName: "drop.fill")
                                            .font(.title2)
                                            .foregroundColor(theme.secondaryAccent)
                                        VStack(alignment: .leading, spacing: 2) {
                                            Text("WATER SCALE")
                                                .font(.caption2)
                                                .fontWeight(.bold)
                                                .foregroundColor(theme.textSecondary)
                                            Text("Calibrate")
                                                .font(.subheadline)
                                                .fontWeight(.semibold)
                                                .foregroundColor(theme.textPrimary)
                                        }
                                    }
                                }
                            }
                            .buttonStyle(.plain)
                            
                            Button(action: { showingRecipeJournal = true }) {
                                BaseCardView(theme: theme) {
                                    HStack {
                                        Image(systemName: "cup.and.saucer.fill")
                                            .font(.title2)
                                            .foregroundColor(theme.primaryAccent)
                                        VStack(alignment: .leading, spacing: 2) {
                                            Text("RECIPES")
                                                .font(.caption2)
                                                .fontWeight(.bold)
                                                .foregroundColor(theme.textSecondary)
                                            Text("Dial-In")
                                                .font(.subheadline)
                                                .fontWeight(.semibold)
                                                .foregroundColor(theme.textPrimary)
                                        }
                                    }
                                }
                            }
                            .buttonStyle(.plain)
                        }
                        
                        // Segmented View: Protocol vs Parts
                        Picker("Companion Tab", selection: $selectedTab) {
                            Text("Maintenance Guide").tag(0)
                            Text("Filters & Gaskets").tag(1)
                        }
                        .pickerStyle(.segmented)
                        
                        if selectedTab == 0 {
                            MaintenanceManualCardView(manual: viewModel.getCoffeeManual(), theme: theme)
                        } else {
                            SparePartsWearView(schedule: viewModel.getCoffeeParts(), theme: theme) { _ in }
                        }
                    } else {
                        VStack(spacing: 12) {
                            Image(systemName: "cup.and.saucer")
                                .font(.system(size: 48))
                                .foregroundColor(theme.textSecondary.opacity(0.4))
                            Text("No Coffee Machine Paired")
                                .font(.headline)
                                .foregroundColor(theme.textSecondary)
                            Text("Scan barcode or type your espresso machine to track water scale and maintenance.")
                                .font(.caption)
                                .foregroundColor(theme.textSecondary)
                                .multilineTextAlignment(.center)
                            
                            Button(action: { Task { await viewModel.injectDemoMachine() } }) {
                                Text("Load Demo Jura E8")
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
            .navigationTitle(lang.t(.coffeeBrewEspressoLog))
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
            .sheet(isPresented: $showingHardnessSheet) {
                WaterHardnessCalibrationView(viewModel: viewModel)
            }
            .sheet(isPresented: $showingRecipeJournal) {
                BrewRecipeJournalView(machine: viewModel.currentMachine)
            }
            .sheet(isPresented: $viewModel.showingOnboardingGuide) {
                InteractiveOnboardingView(
                    appName: lang.t(.coffeeBrewEspressoLog),
                    theme: theme,
                    onStartDemo: {
                        Task { await viewModel.injectDemoMachine() }
                    }
                )
            }
            .fullScreenCover(isPresented: $viewModel.showingLiveScanner) {
                LiveScannerSwiftUIView(
                    onDetectedBarcode: { barcode in
                        Task {
                            let match = await AIExtractionService.shared.identifyOmniProduct(queryOrText: "Espresso Machine", barcode: barcode)
                            await viewModel.addMachine(brand: match.brand, model: match.modelName, machineType: match.subCategory ?? "Superautomatic")
                        }
                    },
                    onCapturedPhoto: { photoData in
                        Task {
                            let match = await AIExtractionService.shared.identifyOmniProduct(queryOrText: "Coffee Machine", imageData: photoData)
                            await viewModel.addMachine(brand: match.brand, model: match.modelName, machineType: match.subCategory ?? "Espresso")
                        }
                    },
                    onManualSearchSubmit: { query in
                        Task {
                            let match = await AIExtractionService.shared.identifyOmniProduct(queryOrText: query)
                            await viewModel.addMachine(brand: match.brand, model: match.modelName, machineType: match.subCategory ?? "Espresso")
                        }
                    }
                )
            }
            .task {
                await viewModel.loadMachines()
            }
        }
    }
}
