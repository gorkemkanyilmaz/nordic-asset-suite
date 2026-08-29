//
//  BaristaDeckView.swift
//  CoffeeMachineCompanion
//
//  Created for Nordic Asset Suite.
//  Strict Concurrency: Complete. Clean Nordic Barista Deck matching localhost structure.
//

import SwiftUI
import AssetCoreDatabase
import AssetCoreUIComponents
import AssetCoreLocalization

public struct BaristaDeckView: View {
    @Bindable var viewModel: CoffeeViewModel
    private let theme = CoffeeTheme()
    private let lang = LanguageManager.shared
    
    @State private var showingHardnessSheet: Bool = false
    @State private var showingRecipeJournal: Bool = false
    @State private var selectedTab: Int = 0
    
    public init(viewModel: CoffeeViewModel) {
        self.viewModel = viewModel
    }
    
    public var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 16) {
                    greetingSection
                    
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
                                        Text("PUMP PRESSURE")
                                            .font(.caption2)
                                            .fontWeight(.bold)
                                            .foregroundColor(theme.textSecondary)
                                        Text("\(Int(machine.pumpPressureBar)) Bar (\(machine.boilerType))")
                                            .font(.caption)
                                            .fontWeight(.semibold)
                                            .foregroundColor(theme.textPrimary)
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
                        
                        // Active Bean Freshness Card
                        VStack(alignment: .leading, spacing: 10) {
                            HStack {
                                Image(systemName: "flame.fill")
                                    .foregroundColor(theme.secondaryAccent)
                                Text("ACTIVE BEAN CELLAR")
                                    .font(.caption2)
                                    .fontWeight(.bold)
                                    .foregroundColor(theme.textSecondary)
                                Spacer()
                                Text("Day 8 Post-Roast (Peak)")
                                    .font(.caption2)
                                    .fontWeight(.bold)
                                    .padding(.horizontal, 8)
                                    .padding(.vertical, 3)
                                    .background(Color.green.opacity(0.15))
                                    .foregroundColor(.green)
                                    .clipShape(Capsule())
                            }
                            
                            HStack {
                                VStack(alignment: .leading, spacing: 2) {
                                    Text("Ethiopia Yirgacheffe Washed")
                                        .font(.subheadline)
                                        .fontWeight(.bold)
                                        .foregroundColor(theme.textPrimary)
                                    Text("Medium-Light Roast · Jasmine, Bergamot & Peach")
                                        .font(.caption2)
                                        .foregroundColor(theme.textSecondary)
                                }
                                Spacer()
                            }
                        }
                        .padding(14)
                        .background(theme.cardBackground)
                        .clipShape(RoundedRectangle(cornerRadius: 14))
                        .overlay(
                            RoundedRectangle(cornerRadius: 14)
                                .stroke(theme.borderSubtle, lineWidth: 1)
                        )
                        
                        // Municipal Water Hardness Card
                        VStack(alignment: .leading, spacing: 10) {
                            HStack {
                                Image(systemName: "drop.fill")
                                    .foregroundColor(theme.primaryAccent)
                                Text("MUNICIPAL WATER CHEMISTRY")
                                    .font(.caption2)
                                    .fontWeight(.bold)
                                    .foregroundColor(theme.textSecondary)
                                Spacer()
                                Text("Calibrated")
                                    .font(.caption2)
                                    .fontWeight(.bold)
                                    .padding(.horizontal, 8)
                                    .padding(.vertical, 3)
                                    .background(theme.primaryAccent.opacity(0.15))
                                    .foregroundColor(theme.primaryAccent)
                                    .clipShape(Capsule())
                            }
                            
                            HStack {
                                VStack(alignment: .leading, spacing: 2) {
                                    Text("Water Hardness: \(String(format: "%.1f", viewModel.waterHardnessDH)) °dH")
                                        .font(.subheadline)
                                        .fontWeight(.bold)
                                        .foregroundColor(theme.textPrimary)
                                    Text("Filter cartridge active. Protection against mineral limescale.")
                                        .font(.caption2)
                                        .foregroundColor(theme.textSecondary)
                                }
                                Spacer()
                            }
                        }
                        .padding(14)
                        .background(theme.cardBackground)
                        .clipShape(RoundedRectangle(cornerRadius: 14))
                        .overlay(
                            RoundedRectangle(cornerRadius: 14)
                                .stroke(theme.borderSubtle, lineWidth: 1)
                        )
                        
                        // Maintenance & Guide
                        MaintenanceManualCardView(manual: viewModel.getCoffeeManual(), theme: theme)
                    }
                }
                .padding()
            }
            .background(theme.backgroundGrouped.ignoresSafeArea())
            .preferredColorScheme(.dark)
            .navigationTitle(lang.t(.coffeeBrewEspressoLog))
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
            .task {
                await viewModel.loadMachines()
            }
        }
    }
    
    private var greetingSection: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("Barista Deck")
                .font(.caption)
                .fontWeight(.bold)
                .foregroundColor(theme.secondaryAccent)
            
            Text("Today's Extraction")
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(theme.textPrimary)
            
            Text("Dialed-in precision brewing & water chemistry")
                .font(.subheadline)
                .foregroundColor(theme.textSecondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}
