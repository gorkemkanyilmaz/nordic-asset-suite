//
//  WaterHardnessCalibrationView.swift
//  CoffeeMachineCompanion
//
//  Created for Nordic Asset Suite.
//  Strict Concurrency: Complete. Water Chemistry & Dynamic Descaling Calculation.
//

import SwiftUI
import AssetCoreDatabase
import AssetCoreUIComponents
import AssetCoreLocalization

public struct WaterHardnessCalibrationView: View {
    @Bindable var viewModel: CoffeeViewModel
    @Environment(\.dismiss) private var dismiss
    private let theme = CoffeeTheme()
    
    public init(viewModel: CoffeeViewModel) {
        self.viewModel = viewModel
    }
    
    private var chemistry: (frenchDegreesFH: Double, ppmTDS: Double, category: WaterHardnessCategory) {
        CoffeeChemistryCalculator.shared.convertHardness(germanDegreesDH: viewModel.waterHardnessDH)
    }
    
    public var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Water Hardness Calibration (°dH)")) {
                    VStack(alignment: .leading, spacing: 6) {
                        HStack {
                            Text("German Hardness (°dH)")
                            Spacer()
                            Text("\(String(format: "%.1f", viewModel.waterHardnessDH)) °dH")
                                .fontWeight(.bold)
                                .foregroundColor(theme.primaryAccent)
                        }
                        Slider(value: $viewModel.waterHardnessDH, in: 2...28, step: 0.5)
                            .tint(theme.secondaryAccent)
                        
                        Text(RegionalFormatter.shared.formatWaterHardness(germanDegrees: viewModel.waterHardnessDH))
                            .font(.caption)
                            .foregroundColor(theme.textSecondary)
                    }
                    
                    Toggle("Active Claris / BWT Filter Cartridge", isOn: $viewModel.hasActiveFilter)
                        .tint(theme.secondaryAccent)
                }
                
                Section(header: Text("Water Chemistry Classification")) {
                    HStack {
                        Text("Category:")
                            .foregroundColor(theme.textSecondary)
                        Spacer()
                        Text(chemistry.category.rawValue)
                            .fontWeight(.semibold)
                    }
                    
                    HStack {
                        Text("Calculated TDS:")
                            .foregroundColor(theme.textSecondary)
                        Spacer()
                        Text("\(Int(chemistry.ppmTDS)) PPM")
                            .fontWeight(.medium)
                    }
                }
                
                Section(header: Text("Dynamic Descaling Cycle Allowance")) {
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            VStack(alignment: .leading, spacing: 2) {
                                Text("ALLOWED WATER THROUGHPUT")
                                    .font(.caption2)
                                    .fontWeight(.bold)
                                    .foregroundColor(theme.textSecondary)
                                Text("\(String(format: "%.1f", viewModel.allowedLitersUntilDescale)) Liters")
                                    .font(.title2)
                                    .fontWeight(.bold)
                                    .foregroundColor(theme.secondaryAccent)
                            }
                            Spacer()
                            
                            MetricBadgeView(
                                label: "Cycle",
                                value: "\(Int(viewModel.allowedLitersUntilDescale / 1.5)) Cups",
                                status: .success,
                                theme: theme
                            )
                        }
                        
                        Text("Calculated dynamically from chemical hardness factor. Hard water accelerates mineral scaling.")
                            .font(.caption)
                            .foregroundColor(theme.textSecondary)
                    }
                    .padding(.vertical, 4)
                }
            }
            .preferredColorScheme(.dark)
            .navigationTitle("Water Chemistry & Scale")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Done") { dismiss() }
                }
            }
        }
    }
}
