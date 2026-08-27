//
//  MaintenanceManualCardView.swift
//  AssetCoreUIComponents
//
//  Created for Nordic Asset Suite.
//  Strict Concurrency: Complete. Dynamic AI Maintenance Manual & Step-by-Step Guide.
//

import SwiftUI
import AssetCoreAI
import AssetCoreLocalization

public struct MaintenanceManualCardView: View {
    public let manual: MaintenanceManualData
    public let theme: any AppDesignTheme
    private let lang = LanguageManager.shared
    
    @State private var completedSteps: Set<Int> = []
    @State private var expandedStep: Int? = 1
    
    public init(manual: MaintenanceManualData, theme: any AppDesignTheme) {
        self.manual = manual
        self.theme = theme
    }
    
    public var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            // Header
            HStack {
                Label(lang.t(.maintenanceProtocol), systemImage: "wrench.and.screwdriver.fill")
                    .font(.headline)
                    .foregroundColor(theme.primaryAccent)
                Spacer()
                Text(String(format: lang.t(.everyDays), manual.recommendedServiceIntervalDays))
                    .font(.caption2)
                    .fontWeight(.bold)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(Color.blue.opacity(0.12))
                    .foregroundColor(.blue)
                    .clipShape(Capsule())
            }
            
            Text(manual.generalCareSummary)
                .font(.subheadline)
                .foregroundColor(theme.textSecondary)
            
            // Step-by-step Guide
            VStack(spacing: 10) {
                ForEach(manual.maintenanceSteps) { step in
                    VStack(alignment: .leading, spacing: 8) {
                        Button(action: {
                            withAnimation(.spring(response: 0.35, dampingFraction: 0.7)) {
                                expandedStep = (expandedStep == step.stepNumber) ? nil : step.stepNumber
                            }
                        }) {
                            HStack(alignment: .center, spacing: 12) {
                                Button(action: {
                                    if completedSteps.contains(step.stepNumber) {
                                        completedSteps.remove(step.stepNumber)
                                    } else {
                                        completedSteps.insert(step.stepNumber)
                                    }
                                }) {
                                    Image(systemName: completedSteps.contains(step.stepNumber) ? "checkmark.circle.fill" : "circle")
                                        .font(.title3)
                                        .foregroundColor(completedSteps.contains(step.stepNumber) ? theme.statusSuccess : theme.textSecondary)
                                }
                                .buttonStyle(.plain)
                                
                                VStack(alignment: .leading, spacing: 2) {
                                    Text(String(format: lang.t(.stepNumber), step.stepNumber, step.title))
                                        .font(.subheadline)
                                        .fontWeight(.semibold)
                                        .foregroundColor(completedSteps.contains(step.stepNumber) ? theme.textSecondary : theme.textPrimary)
                                        .strikethrough(completedSteps.contains(step.stepNumber))
                                    
                                    Text(step.frequencyDescription)
                                        .font(.caption2)
                                        .foregroundColor(theme.textSecondary)
                                }
                                
                                Spacer()
                                
                                Image(systemName: expandedStep == step.stepNumber ? "chevron.up" : "chevron.down")
                                    .font(.caption)
                                    .foregroundColor(theme.textSecondary)
                            }
                        }
                        .buttonStyle(.plain)
                        
                        if expandedStep == step.stepNumber {
                            VStack(alignment: .leading, spacing: 8) {
                                Text(step.detail)
                                    .font(.caption)
                                    .foregroundColor(theme.textPrimary)
                                    .padding(10)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .background(theme.cardBackground.opacity(0.8))
                                    .clipShape(RoundedRectangle(cornerRadius: 8))
                                
                                if !step.toolsRequired.isEmpty {
                                    HStack(spacing: 6) {
                                        Text(lang.t(.tools))
                                            .font(.caption2)
                                            .fontWeight(.bold)
                                            .foregroundColor(theme.textSecondary)
                                        
                                        ForEach(step.toolsRequired, id: \.self) { tool in
                                            Text(tool)
                                                .font(.caption2)
                                                .padding(.horizontal, 6)
                                                .padding(.vertical, 2)
                                                .background(Color.gray.opacity(0.12))
                                                .clipShape(Capsule())
                                        }
                                    }
                                }
                            }
                            .padding(.leading, 32)
                            .transition(.opacity.combined(with: .move(edge: .top)))
                        }
                    }
                    .padding(10)
                    .background(Color(.secondarySystemBackground))
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                }
            }
            
            // Safety Precautions Box
            if !manual.safetyPrecautions.isEmpty {
                VStack(alignment: .leading, spacing: 6) {
                    Label(lang.t(.safetyWarnings), systemImage: "exclamationmark.triangle.fill")
                        .font(.caption)
                        .fontWeight(.bold)
                        .foregroundColor(theme.statusWarning)
                    
                    ForEach(manual.safetyPrecautions, id: \.self) { warning in
                        Text("• \(warning)")
                            .font(.caption2)
                            .foregroundColor(theme.textSecondary)
                    }
                }
                .padding(12)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(theme.statusWarning.opacity(0.08))
                .clipShape(RoundedRectangle(cornerRadius: 10))
            }
        }
        .padding()
        .background(theme.cardBackground)
        .clipShape(RoundedRectangle(cornerRadius: theme.cornerRadiusCard))
        .shadow(color: Color.black.opacity(0.04), radius: 6, y: 3)
    }
}
