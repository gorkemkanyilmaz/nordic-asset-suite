//
//  BrewRecipeJournalView.swift
//  CoffeeMachineCompanion
//
//  Created for Nordic Asset Suite.
//  Strict Concurrency: Complete. Machine-Aware Dial-In Extraction Journal.
//

import SwiftUI
import AssetCoreUIComponents
import AssetCoreDatabase

public struct BrewRecipeJournalView: View {
    @Environment(\.dismiss) private var dismiss
    private let theme = CoffeeTheme()
    
    /// The currently paired machine (nil = no machine).
    let machine: CoffeeMachineDTO?
    
    @State private var beanOrigin: String = "Ethiopia Yirgacheffe"
    @State private var roaster: String = "Miro Coffee Zurich"
    @State private var dryDose: Double = 18.0
    @State private var liquidYield: Double = 38.0
    @State private var extractionTime: Double = 27.5
    @State private var grindSetting: Double = 4.5
    @State private var brewPressure: Double = 9.0
    @State private var brewMethod: String = "Espresso"
    @State private var sensoryNotes: String = "Jasmine, bergamot, crisp peach acidity"
    
    private let allBrewMethods = ["Espresso", "Ristretto", "Lungo", "Americano", "Flat White", "Pour-Over", "Aeropress", "Cold Brew", "Moka"]
    
    public init(machine: CoffeeMachineDTO? = nil) {
        self.machine = machine
    }
    
    private var brewRatio: Double {
        guard dryDose > 0 else { return 2.0 }
        return round((liquidYield / dryDose) * 10.0) / 10.0
    }
    
    /// Methods available on the current machine (or all methods if no machine).
    private var availableMethods: [String] {
        guard let m = machine, !m.supportedBrewMethods.isEmpty else { return allBrewMethods }
        return m.supportedBrewMethods
    }
    
    /// Max dose based on grouphead diameter.
    private var maxDose: Double {
        guard let m = machine, m.groupheadDiameterMm > 0 else { return 24.0 }
        switch m.groupheadDiameterMm {
        case ...50: return 14.0
        case 51...53: return 16.0
        case 54: return 20.0
        default: return 22.0
        }
    }
    
    /// Compatibility check result for the current recipe settings.
    private var compatibility: RecipeCompatibility {
        guard let m = machine else {
            return RecipeCompatibility(isCompatible: true, warnings: [])
        }
        return RecipeCompatibilityChecker.shared.quickCheck(
            recipeMethod: brewMethod,
            recipePressureBar: brewPressure,
            minimumPressureBar: brewMethod == "Espresso" ? 8.0 : 0,
            machinePressureBar: m.pumpPressureBar,
            machineBrewMethods: m.supportedBrewMethods
        )
    }
    
    public var body: some View {
        NavigationStack {
            Form {
                // ── Compatibility Banner ──
                if !compatibility.isCompatible {
                    Section {
                        ForEach(compatibility.warnings.filter({ $0.severity == .critical })) { warning in
                            HStack(spacing: 10) {
                                Image(systemName: warning.iconName)
                                    .font(.title3)
                                    .foregroundColor(.red)
                                Text(warning.message)
                                    .font(.caption)
                                    .foregroundColor(.red)
                            }
                            .padding(.vertical, 4)
                        }
                    } header: {
                        Text("⚠️ Machine Compatibility")
                    }
                }
                
                Section(header: Text("Coffee Beans & Origin")) {
                    TextField("Origin / Variety", text: $beanOrigin)
                    TextField("Roastery", text: $roaster)
                }
                
                // ── Brew Method Selection (machine-filtered) ──
                Section(header: Text("Brew Method")) {
                    Picker("Method", selection: $brewMethod) {
                        ForEach(availableMethods, id: \.self) { method in
                            Text(method).tag(method)
                        }
                    }
                    .pickerStyle(.menu)
                    
                    if let m = machine, !m.supportedBrewMethods.contains(brewMethod) {
                        HStack(spacing: 6) {
                            Image(systemName: "xmark.octagon.fill")
                                .foregroundColor(.red)
                                .font(.caption)
                            Text("This method is not supported by your \(m.brand) \(m.modelName).")
                                .font(.caption2)
                                .foregroundColor(.red)
                        }
                    }
                }
                
                Section(header: Text("Extraction Parameters (Dial-In)")) {
                    // Dose slider — max limited by grouphead
                    VStack(alignment: .leading, spacing: 4) {
                        HStack {
                            Text("Dry Dose:")
                            Spacer()
                            Text("\(String(format: "%.1f", dryDose)) g")
                                .fontWeight(.bold)
                        }
                        Slider(value: $dryDose, in: 12...maxDose, step: 0.5)
                            .tint(theme.secondaryAccent)
                        if let m = machine, m.groupheadDiameterMm > 0 {
                            Text("Max \(String(format: "%.0f", maxDose))g for \(m.groupheadDiameterMm)mm basket")
                                .font(.caption2)
                                .foregroundColor(theme.textSecondary)
                        }
                    }
                    
                    VStack(alignment: .leading, spacing: 4) {
                        HStack {
                            Text("Liquid Yield:")
                            Spacer()
                            Text("\(String(format: "%.1f", liquidYield)) g (Ratio 1:\(String(format: "%.1f", brewRatio)))")
                                .fontWeight(.bold)
                        }
                        Slider(value: $liquidYield, in: 20...60, step: 1)
                            .tint(theme.secondaryAccent)
                    }
                    
                    VStack(alignment: .leading, spacing: 4) {
                        HStack {
                            Text("Extraction Time:")
                            Spacer()
                            Text("\(String(format: "%.1f", extractionTime)) seconds")
                                .fontWeight(.bold)
                        }
                        Slider(value: $extractionTime, in: 15...45, step: 0.5)
                            .tint(theme.secondaryAccent)
                    }
                    
                    VStack(alignment: .leading, spacing: 4) {
                        HStack {
                            Text("Grind Setting Number:")
                            Spacer()
                            Text("\(String(format: "%.1f", grindSetting))")
                                .fontWeight(.bold)
                        }
                        Slider(value: $grindSetting, in: 1...15, step: 0.1)
                            .tint(theme.secondaryAccent)
                    }
                    
                    // Brew pressure — limited to machine's max
                    VStack(alignment: .leading, spacing: 4) {
                        HStack {
                            Text("Brew Pressure:")
                            Spacer()
                            Text("\(String(format: "%.1f", brewPressure)) bar")
                                .fontWeight(.bold)
                        }
                        let maxPressure = machine?.pumpPressureBar ?? 20.0
                        Slider(value: $brewPressure, in: 0...min(maxPressure, 20.0), step: 0.5)
                            .tint(theme.secondaryAccent)
                        if let m = machine {
                            Text("Machine max: \(Int(m.pumpPressureBar)) bar (\(m.boilerType))")
                                .font(.caption2)
                                .foregroundColor(theme.textSecondary)
                        }
                    }
                }
                
                Section(header: Text("Sensory Tasting Profile")) {
                    TextField("Tasting notes", text: $sensoryNotes)
                }
                
                // Machine info footer
                if let m = machine {
                    Section(header: Text("Paired Machine")) {
                        HStack {
                            Image(systemName: "mug.fill")
                                .foregroundColor(theme.primaryAccent)
                            VStack(alignment: .leading, spacing: 2) {
                                Text("\(m.brand) \(m.modelName)")
                                    .font(.subheadline)
                                    .fontWeight(.semibold)
                                Text("\(m.machineType) · \(Int(m.pumpPressureBar)) bar · \(m.boilerType)")
                                    .font(.caption2)
                                    .foregroundColor(theme.textSecondary)
                            }
                        }
                    }
                }
            }
            .preferredColorScheme(.dark)
            .navigationTitle("Dial-In Recipe Log")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) { Button("Cancel") { dismiss() } }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save Recipe") { dismiss() }
                        .disabled(!compatibility.isCompatible)
                }
            }
        }
    }
}

