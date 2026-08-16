//
//  BrewRecipeJournalView.swift
//  CoffeeMachineCompanion
//
//  Created for Nordic Asset Suite.
//  Strict Concurrency: Complete. Dial-In Extraction Journal.
//

import SwiftUI
import AssetCoreUIComponents

public struct BrewRecipeJournalView: View {
    @Environment(\.dismiss) private var dismiss
    private let theme = CoffeeTheme()
    
    @State private var beanOrigin: String = "Ethiopia Yirgacheffe"
    @State private var roaster: String = "Miro Coffee Zurich"
    @State private var dryDose: Double = 18.0
    @State private var liquidYield: Double = 38.0
    @State private var extractionTime: Double = 27.5
    @State private var grindSetting: Double = 4.5
    @State private var sensoryNotes: String = "Jasmine, bergamot, crisp peach acidity"
    
    public init() {}
    
    private var brewRatio: Double {
        guard dryDose > 0 else { return 2.0 }
        return round((liquidYield / dryDose) * 10.0) / 10.0
    }
    
    public var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Coffee Beans & Origin")) {
                    TextField("Origin / Variety", text: $beanOrigin)
                    TextField("Roastery", text: $roaster)
                }
                
                Section(header: Text("Extraction Parameters (Dial-In)")) {
                    VStack(alignment: .leading, spacing: 4) {
                        HStack {
                            Text("Dry Dose:")
                            Spacer()
                            Text("\(String(format: "%.1f", dryDose)) g")
                                .fontWeight(.bold)
                        }
                        Slider(value: $dryDose, in: 12...24, step: 0.5)
                            .tint(theme.secondaryAccent)
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
                }
                
                Section(header: Text("Sensory Tasting Profile")) {
                    TextField("Tasting notes", text: $sensoryNotes)
                }
            }
            .navigationTitle("Dial-In Recipe Log")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) { Button("Cancel") { dismiss() } }
                ToolbarItem(placement: .confirmationAction) { Button("Save Recipe") { dismiss() } }
            }
        }
    }
}
