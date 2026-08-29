//
//  MachineMaintenanceView.swift
//  CoffeeMachineCompanion
//
//  Created for Nordic Asset Suite.
//  Strict Concurrency: Complete. Machine Hardware Specs & Maintenance Protocols.
//

import SwiftUI
import AssetCoreDatabase
import AssetCoreUIComponents
import AssetCoreLocalization

public struct MachineMaintenanceView: View {
    @Bindable public var viewModel: CoffeeViewModel
    private let theme = CoffeeTheme()
    
    public init(viewModel: CoffeeViewModel) {
        self.viewModel = viewModel
    }
    
    public var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 16) {
                    if let machine = viewModel.currentMachine {
                        // Hardware Specs Card
                        VStack(alignment: .leading, spacing: 12) {
                            HStack {
                                Text("HARDWARE SPECIFICATIONS")
                                    .font(.caption2)
                                    .fontWeight(.bold)
                                    .foregroundColor(theme.secondaryAccent)
                                Spacer()
                                Text(machine.machineType)
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
                                    Text("Pump Pressure")
                                        .font(.caption)
                                        .foregroundColor(theme.textSecondary)
                                    Text("\(Int(machine.pumpPressureBar)) Bar (Ulka / Rotary)")
                                        .font(.subheadline)
                                        .fontWeight(.semibold)
                                        .foregroundColor(theme.textPrimary)
                                }
                                Spacer()
                                VStack(alignment: .trailing, spacing: 2) {
                                    Text("Boiler Type")
                                        .font(.caption)
                                        .foregroundColor(theme.textSecondary)
                                    Text(machine.boilerType)
                                        .font(.subheadline)
                                        .fontWeight(.semibold)
                                        .foregroundColor(theme.textPrimary)
                                }
                            }
                            
                            Divider()
                            
                            HStack {
                                VStack(alignment: .leading, spacing: 2) {
                                    Text("Grouphead")
                                        .font(.caption)
                                        .foregroundColor(theme.textSecondary)
                                    Text(machine.groupheadDiameterMm > 0 ? "\(machine.groupheadDiameterMm)mm (E61 Standard)" : "Precision Integrated Chamber")
                                        .font(.subheadline)
                                        .fontWeight(.semibold)
                                        .foregroundColor(theme.textPrimary)
                                }
                                Spacer()
                                VStack(alignment: .trailing, spacing: 2) {
                                    Text("Total Extractions")
                                        .font(.caption)
                                        .foregroundColor(theme.textSecondary)
                                    Text("\(machine.totalShotsPulled) Shots")
                                        .font(.subheadline)
                                        .fontWeight(.bold)
                                        .foregroundColor(theme.primaryAccent)
                                }
                            }
                        }
                        .padding(16)
                        .background(theme.cardBackground)
                        .clipShape(RoundedRectangle(cornerRadius: 14))
                        .overlay(
                            RoundedRectangle(cornerRadius: 14)
                                .stroke(theme.borderSubtle, lineWidth: 1)
                        )
                        
                        // Descaling Protocol Card
                        VStack(alignment: .leading, spacing: 12) {
                            HStack {
                                Image(systemName: "drop.triangle.fill")
                                    .foregroundColor(theme.statusWarning)
                                Text("DESCALING & HYGIENE PROTOCOL")
                                    .font(.caption2)
                                    .fontWeight(.bold)
                                    .foregroundColor(theme.textSecondary)
                            }
                            
                            Text("Automatic calculation based on \(String(format: "%.1f", viewModel.waterHardnessDH)) °dH municipal water hardness.")
                                .font(.caption)
                                .foregroundColor(theme.textSecondary)
                            
                            HStack {
                                Text("Remaining Water Capacity:")
                                    .font(.caption)
                                    .foregroundColor(theme.textSecondary)
                                Spacer()
                                Text("\(Int(viewModel.allowedLitersUntilDescale)) Liters")
                                    .font(.caption)
                                    .fontWeight(.bold)
                                    .foregroundColor(theme.statusSuccess)
                            }
                            
                            Button(action: {
                                Task {
                                    try? await viewModel.recordDescaling()
                                }
                            }) {
                                HStack {
                                    Image(systemName: "checkmark.circle.fill")
                                    Text("Log Descaling Cycle Complete")
                                        .font(.caption)
                                        .fontWeight(.bold)
                                }
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 10)
                                .background(theme.primaryAccent.opacity(0.15))
                                .foregroundColor(theme.primaryAccent)
                                .clipShape(RoundedRectangle(cornerRadius: 8))
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
            .navigationTitle("Machine Care")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}
