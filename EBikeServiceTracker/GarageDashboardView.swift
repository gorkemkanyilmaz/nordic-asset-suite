//
//  GarageDashboardView.swift
//  EBikeServiceTracker
//
//  Created for Nordic Asset Suite.
//  Strict Concurrency: Complete. Garage-Centric Dashboard & Bike Selector.
//

import SwiftUI
import AssetCoreDatabase
import AssetCoreUIComponents
import AssetCoreLocalization

public struct GarageDashboardView: View {
    @Bindable var viewModel: EBikeViewModel
    private let theme = EBikeTheme()
    
    @State private var showingAddBike: Bool = false
    
    public init(viewModel: EBikeViewModel) {
        self.viewModel = viewModel
    }
    
    public var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    if let bike = viewModel.currentBike {
                        // Digital Twin Bike Hero Card
                        BaseCardView(theme: theme) {
                            VStack(alignment: .leading, spacing: 12) {
                                HStack {
                                    VStack(alignment: .leading, spacing: 2) {
                                        Text(bike.brand.uppercased())
                                            .font(.caption)
                                            .fontWeight(.bold)
                                            .foregroundColor(theme.secondaryAccent)
                                        Text(bike.modelName)
                                            .font(.title2)
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
                        
                        // Navigation Link to Telemetry & Setup
                        NavigationLink(destination: DigitalTwinTelemetryView(viewModel: viewModel)) {
                            BaseCardView(theme: theme) {
                                HStack {
                                    Image(systemName: "gauge.with.dots.needle.bottom.50percent")
                                        .font(.title2)
                                        .foregroundColor(theme.secondaryAccent)
                                    VStack(alignment: .leading, spacing: 2) {
                                        Text("DIGITAL TWIN TELEMETRY")
                                            .font(.caption)
                                            .fontWeight(.bold)
                                            .foregroundColor(theme.textSecondary)
                                        Text("Chain Wear & Suspension PSI")
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
                    } else {
                        VStack(spacing: 12) {
                            Image(systemName: "bicycle")
                                .font(.system(size: 48))
                                .foregroundColor(theme.textSecondary.opacity(0.4))
                            Text("Garage is Empty")
                                .font(.headline)
                                .foregroundColor(theme.textSecondary)
                            Text("Add your E-Bike to monitor battery cycles, chain stretch, and suspension pressures.")
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
            .navigationTitle("Garage Service")
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button(action: { showingAddBike = true }) {
                        Image(systemName: "plus.circle.fill")
                            .font(.title3)
                            .foregroundColor(theme.primaryAccent)
                    }
                }
            }
            .sheet(isPresented: $showingAddBike) {
                AddBikeQuickSheet { brand, model, frameNo, motor, odo in
                    Task {
                        await viewModel.addBike(brand: brand, model: model, frameNo: frameNo, motor: motor, odometer: odo)
                    }
                }
            }
            .task {
                await viewModel.loadBikes()
            }
        }
    }
}

struct AddBikeQuickSheet: View {
    @Environment(\.dismiss) private var dismiss
    let onAdd: (String, String, String, String, Double) -> Void
    
    @State private var brand: String = "Scott"
    @State private var model: String = "Patron eRIDE 900"
    @State private var frameNo: String = "SCOTT-PATRON-2026"
    @State private var motor: String = "Bosch Performance CX"
    @State private var odo: String = "1450"
    
    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("E-Bike Specifications")) {
                    TextField("Brand", text: $brand)
                    TextField("Model", text: $model)
                    TextField("Frame Number", text: $frameNo)
                    TextField("Motor System", text: $motor)
                    TextField("Odometer (km)", text: $odo)
                        .keyboardType(.decimalPad)
                }
            }
            .navigationTitle("Add E-Bike to Garage")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) { Button("Cancel") { dismiss() } }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        let odoVal = Double(odo) ?? 0.0
                        onAdd(brand, model, frameNo, motor, odoVal)
                        dismiss()
                    }
                }
            }
        }
    }
}
