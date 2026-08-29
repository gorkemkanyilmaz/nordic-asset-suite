//
//  LogRideSheet.swift
//  EBikeServiceTracker
//
//  Created for Nordic Asset Suite.
//  Strict Concurrency: Complete. Quick Ride Logging & Odometer Tracking.
//

import SwiftUI
import AssetCoreDatabase
import AssetCoreUIComponents
import AssetCoreLocalization

public struct LogRideSheet: View {
    @Environment(\.dismiss) private var dismiss
    @Bindable var viewModel: EBikeViewModel
    private let theme = EBikeTheme()
    
    @State private var distanceKm: Double = 35.0
    @State private var elevationMeters: Double = 650.0
    @State private var batteryUsedPct: Double = 32.0
    @State private var terrain: String = "Alpine Singletrack / Trail"
    
    public init(viewModel: EBikeViewModel) {
        self.viewModel = viewModel
    }
    
    public var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Ride Metrics")) {
                    HStack {
                        Text("Distance")
                        Spacer()
                        Text("\(String(format: "%.1f", distanceKm)) km")
                            .fontWeight(.bold)
                            .foregroundColor(theme.primaryAccent)
                    }
                    Slider(value: $distanceKm, in: 1...150, step: 0.5)
                        .tint(theme.primaryAccent)
                    
                    HStack {
                        Text("Elevation Gain")
                        Spacer()
                        Text("\(Int(elevationMeters)) m")
                            .fontWeight(.bold)
                            .foregroundColor(theme.secondaryAccent)
                    }
                    Slider(value: $elevationMeters, in: 0...3000, step: 50)
                        .tint(theme.secondaryAccent)
                    
                    HStack {
                        Text("Battery Consumed")
                        Spacer()
                        Text("\(Int(batteryUsedPct))%")
                            .fontWeight(.bold)
                            .foregroundColor(theme.statusSuccess)
                    }
                    Slider(value: $batteryUsedPct, in: 5...100, step: 1)
                        .tint(theme.statusSuccess)
                }
                
                Section(header: Text("Terrain & Conditions")) {
                    Picker("Terrain", selection: $terrain) {
                        Text("Alpine Trail / Singletrack").tag("Alpine Singletrack / Trail")
                        Text("Gravel & Fire Road").tag("Gravel & Fire Road")
                        Text("Paved Commute").tag("Paved Commute")
                        Text("Wet / Muddy Enduro").tag("Wet / Muddy Enduro")
                    }
                }
            }
            .preferredColorScheme(.dark)
            .navigationTitle("Log Completed Ride")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save Ride") {
                        Task {
                            if let bike = viewModel.currentBike {
                                try? await viewModel.recordRide(
                                    ebikeID: bike.id,
                                    distanceKm: distanceKm,
                                    elevationMeters: elevationMeters,
                                    batteryUsedPct: batteryUsedPct,
                                    terrain: terrain
                                )
                            }
                            dismiss()
                        }
                    }
                    .fontWeight(.bold)
                }
            }
        }
    }
}
