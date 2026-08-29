//
//  BikeSpecsView.swift
//  EBikeServiceTracker
//
//  Created for Nordic Asset Suite.
//  Strict Concurrency: Complete. Digital Twin Fleet Specifications.
//

import SwiftUI
import AssetCoreDatabase
import AssetCoreUIComponents
import AssetCoreLocalization

public struct BikeSpecsView: View {
    @Bindable public var viewModel: EBikeViewModel
    private let theme = EBikeTheme()
    
    public init(viewModel: EBikeViewModel) {
        self.viewModel = viewModel
    }
    
    public var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 16) {
                    if let bike = viewModel.currentBike {
                        // Digital Twin Card
                        VStack(alignment: .leading, spacing: 14) {
                            HStack {
                                Text("DIGITAL TWIN SPECIFICATIONS")
                                    .font(.caption2)
                                    .fontWeight(.bold)
                                    .foregroundColor(theme.primaryAccent)
                                Spacer()
                                Text("Carbon Frame")
                                    .font(.caption2)
                                    .fontWeight(.bold)
                                    .padding(.horizontal, 8)
                                    .padding(.vertical, 3)
                                    .background(theme.primaryAccent.opacity(0.15))
                                    .foregroundColor(theme.primaryAccent)
                                    .clipShape(Capsule())
                            }
                            
                            specRow(label: "Brand & Model", value: "\(bike.brand) \(bike.modelName)")
                            specRow(label: "Drive Unit", value: bike.motorSystem)
                            specRow(label: "Battery Pack", value: "Bosch PowerTube 750 Wh (36V 20.1Ah)")
                            specRow(label: "Fork Suspension", value: "Fox 38 Float Factory 160mm GRIP2")
                            specRow(label: "Rear Shock", value: "Fox Nude T eRIDE EVOL 160mm")
                            specRow(label: "Drivetrain", value: "SRAM GX Eagle AXS 12-Speed Wireless")
                            specRow(label: "Braking System", value: "Shimano XT BR-M8120 4-Piston (203mm Rotors)")
                            specRow(label: "Tires", value: "Maxxis Dissector 29x2.6\" EXO+ 3C")
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
            .navigationTitle("Bike Specs")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
    
    private func specRow(label: String, value: String) -> some View {
        VStack(alignment: .leading, spacing: 2) {
            Text(label)
                .font(.caption2)
                .foregroundColor(theme.textSecondary)
            Text(value)
                .font(.subheadline)
                .fontWeight(.semibold)
                .foregroundColor(theme.textPrimary)
            Divider()
                .padding(.top, 4)
        }
    }
}
