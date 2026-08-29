//
//  DINCalculatorView.swift
//  SkiGearTracker
//
//  Created for Nordic Asset Suite.
//  Strict Concurrency: Complete. ISO 11088 Binding Calculator with Mandatory Safety Disclaimer.
//

import SwiftUI
import AssetCoreDatabase
import AssetCoreUIComponents

public struct DINCalculatorView: View {
    @Environment(\.dismiss) private var dismiss
    private let theme = SkiGearTheme()
    
    @State private var weightKg: Double = 75.0
    @State private var heightCm: Double = 180.0
    @State private var age: Double = 30.0
    @State private var skierType: SkierType = .typeII
    @State private var bootSoleLengthMm: Double = 305.0
    @State private var disclaimerAcknowledged: Bool = false
    
    public init() {}
    
    private var calculationResult: DINCalculationResult {
        DINCalculator.shared.calculateDIN(
            weightKg: weightKg,
            heightCm: heightCm,
            age: Int(age),
            skierType: skierType,
            bootSoleLengthMm: Int(bootSoleLengthMm)
        )
    }
    
    public var body: some View {
        NavigationStack {
            Form {
                // Section 1: Skier Biometrics
                Section(header: Text("Skier Biometrics")) {
                    VStack(alignment: .leading, spacing: 4) {
                        HStack {
                            Text("Weight")
                            Spacer()
                            Text("\(Int(weightKg)) kg (\(Int(weightKg * 2.20462)) lbs)")
                                .fontWeight(.semibold)
                        }
                        Slider(value: $weightKg, in: 25...125, step: 1)
                            .tint(theme.secondaryAccent)
                    }
                    
                    VStack(alignment: .leading, spacing: 4) {
                        HStack {
                            Text("Height")
                            Spacer()
                            Text("\(Int(heightCm)) cm")
                                .fontWeight(.semibold)
                        }
                        Slider(value: $heightCm, in: 130...210, step: 1)
                            .tint(theme.secondaryAccent)
                    }
                    
                    VStack(alignment: .leading, spacing: 4) {
                        HStack {
                            Text("Age")
                            Spacer()
                            Text("\(Int(age)) years")
                                .fontWeight(.semibold)
                        }
                        Slider(value: $age, in: 6...85, step: 1)
                            .tint(theme.secondaryAccent)
                    }
                }
                
                // Section 2: Skier Ability & Boot Specs
                Section(header: Text("Skier Classification & Boots")) {
                    Picker("Skier Type", selection: $skierType) {
                        ForEach(SkierType.allCases, id: \.self) { type in
                            Text(type.rawValue).tag(type)
                        }
                    }
                    
                    VStack(alignment: .leading, spacing: 4) {
                        HStack {
                            Text("Boot Sole Length (BSL)")
                            Spacer()
                            Text("\(Int(bootSoleLengthMm)) mm")
                                .fontWeight(.semibold)
                        }
                        Slider(value: $bootSoleLengthMm, in: 230...360, step: 1)
                            .tint(theme.secondaryAccent)
                    }
                }
                
                // Section 3: MANDATORY LEGAL & SAFETY DISCLAIMER
                Section(header: Text("Mandatory Safety Requirement")) {
                    VStack(alignment: .leading, spacing: 8) {
                        Label("Certified Technician Testing Required", systemImage: "exclamationmark.shield.fill")
                            .font(.subheadline)
                            .fontWeight(.bold)
                            .foregroundColor(theme.statusCritical)
                        
                        Text(DINCalculator.legalSafetyDisclaimer)
                            .font(.caption)
                            .foregroundColor(theme.textSecondary)
                        
                        Toggle("I acknowledge this is an estimate and bindings must be verified by a certified technician.", isOn: $disclaimerAcknowledged)
                            .font(.caption)
                            .fontWeight(.medium)
                            .tint(theme.secondaryAccent)
                    }
                    .padding(.vertical, 4)
                }
                
                // Section 4: Calculated DIN Result (Locked behind disclaimer)
                Section(header: Text("ISO 11088 Calculated Settings")) {
                    if disclaimerAcknowledged {
                        HStack {
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Skier Code: \(calculationResult.skierCode)")
                                    .font(.subheadline)
                                    .foregroundColor(theme.textSecondary)
                                Text("Toe Torque: \(String(format: "%.1f", calculationResult.toeReleaseTorqueNm)) Nm")
                                    .font(.caption)
                                    .foregroundColor(theme.textSecondary)
                                Text("Heel Torque: \(String(format: "%.1f", calculationResult.heelReleaseTorqueNm)) Nm")
                                    .font(.caption)
                                    .foregroundColor(theme.textSecondary)
                            }
                            Spacer()
                            
                            MetricBadgeView(
                                label: "DIN",
                                value: String(format: "%.2f", calculationResult.dinValue),
                                status: .warning,
                                theme: theme
                            )
                        }
                    } else {
                        HStack {
                            Image(systemName: "lock.fill")
                                .foregroundColor(theme.textSecondary)
                            Text("Acknowledge safety disclaimer above to reveal DIN value.")
                                .font(.caption)
                                .foregroundColor(theme.textSecondary)
                        }
                    }
                }
            }
            .preferredColorScheme(.dark)
            .navigationTitle("ISO 11088 DIN Calculator")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Close") { dismiss() }
                }
            }
        }
    }
}
