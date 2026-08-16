//
//  BaristaDeckView.swift
//  CoffeeMachineCompanion
//
//  Created for Nordic Asset Suite.
//  Strict Concurrency: Complete. Barista Deck & Machine Companion Navigation.
//

import SwiftUI
import AssetCoreDatabase
import AssetCoreUIComponents

public struct BaristaDeckView: View {
    @Bindable var viewModel: CoffeeViewModel
    private let theme = CoffeeTheme()
    
    @State private var showingHardnessSheet: Bool = false
    @State private var showingRecipeJournal: Bool = false
    @State private var showingAddMachine: Bool = false
    
    public init(viewModel: CoffeeViewModel) {
        self.viewModel = viewModel
    }
    
    public var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    if let machine = viewModel.currentMachine {
                        // Hero Barista Machine Card
                        BaseCardView(theme: theme) {
                            VStack(alignment: .leading, spacing: 12) {
                                HStack {
                                    VStack(alignment: .leading, spacing: 2) {
                                        Text(machine.brand.uppercased())
                                            .font(.caption)
                                            .fontWeight(.bold)
                                            .foregroundColor(theme.secondaryAccent)
                                        Text(machine.modelName)
                                            .font(.title2)
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
                        
                        // Interactive Deck Action Cards
                        HStack(spacing: 12) {
                            Button(action: { showingHardnessSheet = true }) {
                                BaseCardView(theme: theme) {
                                    HStack {
                                        Image(systemName: "drop.fill")
                                            .font(.title2)
                                            .foregroundColor(theme.secondaryAccent)
                                        VStack(alignment: .leading, spacing: 2) {
                                            Text("WATER SCALE")
                                                .font(.caption)
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
                                                .font(.caption)
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
                    } else {
                        VStack(spacing: 12) {
                            Image(systemName: "cup.and.saucer")
                                .font(.system(size: 48))
                                .foregroundColor(theme.textSecondary.opacity(0.4))
                            Text("No Coffee Machine Paired")
                                .font(.headline)
                                .foregroundColor(theme.textSecondary)
                            Text("Pair your espresso machine or superautomatic to track water scale and dial in extraction recipes.")
                                .font(.caption)
                                .foregroundColor(theme.textSecondary)
                                .multilineTextAlignment(.center)
                        }
                        .padding(.top, 40)
                    }
                }
                .padding()
            }
            .background(theme.backgroundGrouped)
            .navigationTitle("Barista Companion")
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button(action: { showingAddMachine = true }) {
                        Image(systemName: "plus.circle.fill")
                            .font(.title3)
                            .foregroundColor(theme.primaryAccent)
                    }
                }
            }
            .sheet(isPresented: $showingHardnessSheet) {
                WaterHardnessCalibrationView(viewModel: viewModel)
            }
            .sheet(isPresented: $showingRecipeJournal) {
                BrewRecipeJournalView()
            }
            .sheet(isPresented: $showingAddMachine) {
                AddMachineQuickSheet { brand, model, machineType in
                    Task {
                        await viewModel.addMachine(brand: brand, model: model, machineType: machineType)
                    }
                }
            }
            .task {
                await viewModel.loadMachines()
            }
        }
    }
}

struct AddMachineQuickSheet: View {
    @Environment(\.dismiss) private var dismiss
    let onAdd: (String, String, String) -> Void
    
    @State private var brand: String = "Jura"
    @State private var model: String = "E8 Piano Black"
    @State private var machineType: String = "Superautomatic"
    
    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Espresso Machine Setup")) {
                    TextField("Brand (e.g. Jura, Sage, La Marzocco)", text: $brand)
                    TextField("Model (e.g. E8, Barista Touch)", text: $model)
                    TextField("Type", text: $machineType)
                }
            }
            .navigationTitle("Add Coffee Machine")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) { Button("Cancel") { dismiss() } }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        onAdd(brand, model, machineType)
                        dismiss()
                    }
                }
            }
        }
    }
}
