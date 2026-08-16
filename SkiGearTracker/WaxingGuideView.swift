//
//  WaxingGuideView.swift
//  SkiGearTracker
//
//  Created for Nordic Asset Suite.
//  Strict Concurrency: Complete. Snow Temperature & Waxing Advisor.
//

import SwiftUI
import AssetCoreUIComponents

public struct WaxingGuideView: View {
    @Environment(\.dismiss) private var dismiss
    private let theme = SkiGearTheme()
    
    @State private var snowTemperature: Double = -4.0
    @State private var snowType: String = "Packed Powder"
    
    private let snowTypes = ["Dry Powder", "Packed Powder", "Icy Hardpack", "Wet / Spring Snow", "Glaciated / Artificial"]
    
    public init() {}
    
    private var waxRecommendation: (waxName: String, ironTemp: Int, color: Color) {
        switch snowTemperature {
        case ..<(-12):
            return ("Polar Hard Hydrocarbon / Cold Wax", 150, Color.blue)
        case -12..<(-4):
            return ("Blue Universal Cold Wax", 140, Color.teal)
        case -4..<0:
            return ("Red Mid-Temperature Wax", 135, Color.red)
        default:
            return ("Yellow Wet / Spring Fluor-Free Wax", 125, Color.yellow)
        }
    }
    
    public var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Mountain Conditions")) {
                    VStack(alignment: .leading, spacing: 4) {
                        HStack {
                            Text("Snow Temperature")
                            Spacer()
                            Text("\(String(format: "%.1f", snowTemperature)) °C")
                                .fontWeight(.semibold)
                                .foregroundColor(theme.primaryAccent)
                        }
                        Slider(value: $snowTemperature, in: -20...5, step: 0.5)
                            .tint(theme.secondaryAccent)
                    }
                    
                    Picker("Snow Structure", selection: $snowType) {
                        ForEach(snowTypes, id: \.self) { type in
                            Text(type).tag(type)
                        }
                    }
                }
                
                Section(header: Text("Recommended Wax Formulation")) {
                    VStack(alignment: .leading, spacing: 12) {
                        HStack {
                            Circle()
                                .fill(waxRecommendation.color)
                                .frame(width: 14, height: 14)
                            Text(waxRecommendation.waxName)
                                .font(.headline)
                                .foregroundColor(theme.textPrimary)
                        }
                        
                        Divider()
                        
                        HStack {
                            Text("Iron Temperature:")
                                .foregroundColor(theme.textSecondary)
                            Spacer()
                            Text("\(waxRecommendation.ironTemp) °C")
                                .fontWeight(.bold)
                                .foregroundColor(theme.primaryAccent)
                        }
                        
                        HStack {
                            Text("Edge Bevel Recommendation:")
                                .foregroundColor(theme.textSecondary)
                            Spacer()
                            Text("88° Side / 0.5° Base")
                                .fontWeight(.medium)
                        }
                    }
                    .padding(.vertical, 4)
                }
            }
            .navigationTitle("Wax & Structure Advisor")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Done") { dismiss() }
                }
            }
        }
    }
}
