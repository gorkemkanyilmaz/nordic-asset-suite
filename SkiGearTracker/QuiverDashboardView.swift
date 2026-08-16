//
//  QuiverDashboardView.swift
//  SkiGearTracker
//
//  Created for Nordic Asset Suite.
//  Strict Concurrency: Complete. Season Quiver & Gear Vault Navigation.
//

import SwiftUI
import AssetCoreDatabase
import AssetCoreUIComponents

public struct QuiverDashboardView: View {
    @Bindable var viewModel: SkiGearViewModel
    private let theme = SkiGearTheme()
    
    @State private var showingWaxGuide: Bool = false
    @State private var showingAddSki: Bool = false
    
    public init(viewModel: SkiGearViewModel) {
        self.viewModel = viewModel
    }
    
    public var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
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
                                            .font(.caption)
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
                                            .font(.caption)
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
                            Text("Add your race skis, powder boards, or touring setups.")
                                .font(.caption)
                                .foregroundColor(theme.textSecondary)
                        }
                        .padding(.top, 40)
                    } else {
                        LazyVStack(spacing: 12) {
                            ForEach(displayedSkis) { ski in
                                BaseCardView(theme: theme) {
                                    HStack {
                                        VStack(alignment: .leading, spacing: 4) {
                                            Text(ski.brand)
                                                .font(.caption)
                                                .fontWeight(.bold)
                                                .foregroundColor(theme.secondaryAccent)
                                            Text(ski.modelName)
                                                .font(.headline)
                                                .foregroundColor(theme.textPrimary)
                                            Text("Length: \(Int(ski.skiLengthCm)) cm | BSL: \(ski.bootSoleLengthMm) mm")
                                                .font(.caption)
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
                    }
                }
                .padding()
            }
            .background(theme.backgroundGrouped)
            .navigationTitle("Ski Gear Tracker")
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button(action: { showingAddSki = true }) {
                        Image(systemName: "plus.circle.fill")
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
            .sheet(isPresented: $showingAddSki) {
                AddSkiQuickSheet { brand, model, serial, length, bsl, din in
                    Task {
                        await viewModel.addSkiPair(brand: brand, model: model, serial: serial, length: length, bsl: bsl, din: din)
                    }
                }
            }
            .task {
                await viewModel.loadGear()
            }
        }
    }
}

struct AddSkiQuickSheet: View {
    @Environment(\.dismiss) private var dismiss
    let onAdd: (String, String, String, Double, Int, Double) -> Void
    
    @State private var brand: String = "Stöckli"
    @State private var model: String = "Laser SL"
    @State private var serial: String = "STK-2026-99"
    @State private var length: String = "165"
    @State private var bsl: String = "305"
    @State private var din: String = "7.5"
    
    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Ski Details")) {
                    TextField("Brand", text: $brand)
                    TextField("Model", text: $model)
                    TextField("Serial Number", text: $serial)
                    TextField("Length (cm)", text: $length)
                        .keyboardType(.numberPad)
                    TextField("Boot Sole Length (mm)", text: $bsl)
                        .keyboardType(.numberPad)
                    TextField("Binding DIN Setting", text: $din)
                        .keyboardType(.decimalPad)
                }
            }
            .navigationTitle("Add Ski Pair")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) { Button("Cancel") { dismiss() } }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        let len = Double(length) ?? 170.0
                        let bslInt = Int(bsl) ?? 305
                        let dinVal = Double(din) ?? 6.0
                        onAdd(brand, model, serial, len, bslInt, dinVal)
                        dismiss()
                    }
                }
            }
        }
    }
}
