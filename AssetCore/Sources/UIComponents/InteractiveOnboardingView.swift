//
//  InteractiveOnboardingView.swift
//  AssetCoreUIComponents
//
//  Created for Nordic Asset Suite.
//  Strict Concurrency: Complete. Interactive Demo UI & Step-by-Step Onboarding Guide.
//

import SwiftUI
import AssetCoreLocalization

public struct OnboardingFeatureStep: Identifiable {
    public let id = UUID()
    public let title: String
    public let subtitle: String
    public let iconName: String
    public let highlightColor: Color
    public let tips: [String]
}

public struct InteractiveOnboardingView: View {
    @Environment(\.dismiss) private var dismiss
    private let lang = LanguageManager.shared
    
    public let appName: String
    public let theme: any AppDesignTheme
    public let onStartDemo: () -> Void
    
    @State private var currentStepIndex: Int = 0
    
    private var steps: [OnboardingFeatureStep] {
        [
            OnboardingFeatureStep(
                title: lang.t(.liveCameraScanner),
                subtitle: lang.t(.liveCameraScannerDesc),
                iconName: "camera.viewfinder",
                highlightColor: .cyan,
                tips: [
                    lang.t(.tipPositionBarcode),
                    lang.t(.tipToggleTorch),
                    lang.t(.tipImportPhotos)
                ]
            ),
            OnboardingFeatureStep(
                title: lang.t(.geminiAIIdentification),
                subtitle: lang.t(.geminiAIIdentificationDesc),
                iconName: "sparkles",
                highlightColor: .blue,
                tips: [
                    lang.t(.tipAutoCompletion),
                    lang.t(.tipConfirmationCard),
                    lang.t(.tipStatutoryWarranty)
                ]
            ),
            OnboardingFeatureStep(
                title: lang.t(.maintenanceManuals),
                subtitle: lang.t(.maintenanceManualsDesc),
                iconName: "wrench.and.screwdriver.fill",
                highlightColor: .orange,
                tips: [
                    lang.t(.tipInteractiveChecklists),
                    lang.t(.tipToolRequirements),
                    lang.t(.tipSafetyWarnings)
                ]
            ),
            OnboardingFeatureStep(
                title: lang.t(.sparePartsDiagnostics),
                subtitle: lang.t(.sparePartsDiagnosticsDesc),
                iconName: "exclamationmark.triangle.fill",
                highlightColor: .green,
                tips: [
                    lang.t(.tipVisualWearBars),
                    lang.t(.tipLogReplacement),
                    lang.t(.tipInstantDiagnostic)
                ]
            )
        ]
    }
    
    public init(
        appName: String = "App",
        theme: any AppDesignTheme,
        onStartDemo: @escaping () -> Void
    ) {
        self.appName = appName
        self.theme = theme
        self.onStartDemo = onStartDemo
    }
    
    public var body: some View {
        NavigationStack {
            VStack(spacing: 24) {
                // Header
                VStack(spacing: 6) {
                    Text(appName)
                        .font(.headline)
                        .foregroundColor(theme.primaryAccent)
                    Text(lang.t(.howItWorks))
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(theme.textPrimary)
                }
                .padding(.top, 16)
                
                // Step Carousel / Card
                TabView(selection: $currentStepIndex) {
                    ForEach(0..<steps.count, id: \.self) { idx in
                        let step = steps[idx]
                        VStack(spacing: 16) {
                            ZStack {
                                Circle()
                                    .fill(step.highlightColor.opacity(0.12))
                                    .frame(width: 88, height: 88)
                                Image(systemName: step.iconName)
                                    .font(.system(size: 40))
                                    .foregroundColor(step.highlightColor)
                            }
                            
                            Text(step.title)
                                .font(.title3)
                                .fontWeight(.bold)
                                .foregroundColor(theme.textPrimary)
                                .multilineTextAlignment(.center)
                            
                            Text(step.subtitle)
                                .font(.subheadline)
                                .foregroundColor(theme.textSecondary)
                                .multilineTextAlignment(.center)
                                .padding(.horizontal, 16)
                            
                            VStack(alignment: .leading, spacing: 8) {
                                ForEach(step.tips, id: \.self) { tip in
                                    HStack(alignment: .top, spacing: 8) {
                                        Image(systemName: "checkmark.circle.fill")
                                            .font(.caption)
                                            .foregroundColor(step.highlightColor)
                                        Text(tip)
                                            .font(.caption)
                                            .foregroundColor(theme.textPrimary)
                                    }
                                }
                            }
                            .padding()
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background(Color.adaptiveSecondaryBackground)
                            .clipShape(RoundedRectangle(cornerRadius: 14))
                            
                            Spacer()
                        }
                        .padding(.horizontal, 20)
                        .tag(idx)
                    }
                }
                #if os(iOS)
                .tabViewStyle(.page(indexDisplayMode: .always))
                #endif
                .frame(maxHeight: 460)
                
                Spacer()
                
                // Actions
                VStack(spacing: 12) {
                    Button(action: {
                        onStartDemo()
                        dismiss()
                    }) {
                        HStack {
                            Image(systemName: "play.circle.fill")
                                .font(.headline)
                            Text(lang.t(.tryDemo))
                                .fontWeight(.bold)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(theme.primaryAccent)
                        .foregroundColor(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 14))
                    }
                    
                    Button(action: { dismiss() }) {
                        Text(lang.t(.gotItLetsStart))
                            .font(.subheadline)
                            .fontWeight(.semibold)
                            .foregroundColor(theme.textSecondary)
                    }
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 20)
            }
            .background(theme.backgroundGrouped.ignoresSafeArea())
            .preferredColorScheme(.dark)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button(lang.t(.skip)) { dismiss() }
                }
            }
        }
    }
}
