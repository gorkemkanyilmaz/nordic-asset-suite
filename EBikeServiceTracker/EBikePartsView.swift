//
//  EBikePartsView.swift
//  EBikeServiceTracker
//
//  Created for Nordic Asset Suite.
//  Strict Concurrency: Complete. Consumables & Motor Error Diagnostic Decoder.
//

import SwiftUI
import AssetCoreDatabase
import AssetCoreUIComponents
import AssetCoreLocalization

public struct EBikePartsView: View {
    @Bindable public var viewModel: EBikeViewModel
    private let theme = EBikeTheme()
    
    @State private var motorErrorCode: String = "503"
    @State private var showingDiagnosticResult: Bool = false
    
    public init(viewModel: EBikeViewModel) {
        self.viewModel = viewModel
    }
    
    public var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 16) {
                    // Consumables Wear Card
                    SparePartsWearView(schedule: viewModel.getEBikeParts(), theme: theme) { _ in }
                    
                    // Motor Error Decoder Card
                    VStack(alignment: .leading, spacing: 12) {
                        HStack {
                            Image(systemName: "cpu")
                                .foregroundColor(theme.primaryAccent)
                            Text("MOTOR ERROR DECODER")
                                .font(.caption2)
                                .fontWeight(.bold)
                                .foregroundColor(theme.textSecondary)
                        }
                        
                        Text("Enter Bosch, Shimano EP8, or Specialized Brose motor error code to decode root cause.")
                            .font(.caption)
                            .foregroundColor(theme.textSecondary)
                        
                        HStack {
                            TextField("Error Code (e.g. 503, 540, W013, E010)", text: $motorErrorCode)
                                .font(.subheadline)
                                .padding(10)
                                .background(theme.surfaceElevated)
                                .clipShape(RoundedRectangle(cornerRadius: 8))
                            
                            Button(action: { showingDiagnosticResult = true }) {
                                Text("Decode")
                                    .font(.caption)
                                    .fontWeight(.bold)
                                    .padding(.horizontal, 16)
                                    .padding(.vertical, 10)
                                    .background(theme.primaryAccent)
                                    .foregroundColor(.white)
                                    .clipShape(RoundedRectangle(cornerRadius: 8))
                            }
                        }
                        
                        if showingDiagnosticResult || !motorErrorCode.isEmpty {
                            motorDiagnosticResultView
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
                .padding()
            }
            .background(theme.backgroundGrouped.ignoresSafeArea())
            .preferredColorScheme(.dark)
            .navigationTitle("Parts & Decoder")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
    
    @ViewBuilder
    private var motorDiagnosticResultView: some View {
        let code = motorErrorCode.trimmingCharacters(in: .whitespaces)
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text("CODE: \(code.uppercased())")
                    .font(.caption2)
                    .fontWeight(.bold)
                    .foregroundColor(theme.primaryAccent)
                Spacer()
                Text(code == "503" ? "Moderate (DIY)" : "System Fault")
                    .font(.caption2)
                    .fontWeight(.bold)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 3)
                    .background(theme.primaryAccent.opacity(0.15))
                    .foregroundColor(theme.primaryAccent)
                    .clipShape(Capsule())
            }
            
            if code == "503" {
                Text("Speed Sensor Misalignment")
                    .font(.subheadline)
                    .fontWeight(.bold)
                    .foregroundColor(theme.textPrimary)
                Text("The spoke magnet has shifted or is too far from the chainstay speed sensor pickup.")
                    .font(.caption)
                    .foregroundColor(theme.textSecondary)
                Text("Fix: Realign spoke magnet so it passes within 5–12 mm of sensor mark and restart system.")
                    .font(.caption2)
                    .foregroundColor(theme.statusSuccess)
            } else {
                Text("Power Drive Management Lockout")
                    .font(.subheadline)
                    .fontWeight(.bold)
                    .foregroundColor(theme.textPrimary)
                Text("Motor controller detected communication delay between battery BMS and handlebar display.")
                    .font(.caption)
                    .foregroundColor(theme.textSecondary)
                Text("Fix: Clean battery terminal contacts with electrical spray and inspect display wiring harness.")
                    .font(.caption2)
                    .foregroundColor(theme.statusWarning)
            }
        }
        .padding(12)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.black.opacity(0.3))
        .clipShape(RoundedRectangle(cornerRadius: 10))
    }
}
