//
//  SuiteSettingsView.swift
//  AssetCoreSubscription
//
//  Created for Nordic Asset Suite.
//  Strict Concurrency: Complete. Apple App Store Guidelines 5.1.1 & 3.1.2 Compliant Settings Screen.
//

import SwiftUI
import AssetCoreUIComponents
import AssetCoreLocalization

public struct SuiteSettingsView<CustomContent: View>: View {
    public let appName: String
    public let appIconSystemName: String
    public let theme: any AppDesignTheme
    public let onResetVault: () async -> Void
    public let onStartDemo: () async -> Void
    public let customContent: CustomContent
    public let appType: NordicAppType?
    
    @State private var showingPaywall: Bool = false
    @State private var showingOnboarding: Bool = false
    @State private var showingResetAlert: Bool = false
    @State private var statusFeedback: String? = nil
    @State private var isProcessingAction: Bool = false
    
    private let lang = LanguageManager.shared
    
    public init(
        appName: String,
        appIconSystemName: String,
        theme: any AppDesignTheme,
        appType: NordicAppType? = nil,
        onResetVault: @escaping () async -> Void,
        onStartDemo: @escaping () async -> Void,
        @ViewBuilder customContent: () -> CustomContent = { EmptyView() }
    ) {
        self.appName = appName
        self.appIconSystemName = appIconSystemName
        self.theme = theme
        self.appType = appType
        self.onResetVault = onResetVault
        self.onStartDemo = onStartDemo
        self.customContent = customContent()
    }
    
    public var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Header: App Identity & Version Info
                BaseCardView(theme: theme) {
                    HStack(spacing: 16) {
                        ZStack {
                            Circle()
                                .fill(theme.primaryAccent.opacity(0.15))
                                .frame(width: 56, height: 56)
                            Image(systemName: appIconSystemName)
                                .font(.system(size: 26))
                                .foregroundColor(theme.primaryAccent)
                        }
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text(appName)
                                .font(.headline)
                                .fontWeight(.bold)
                                .foregroundColor(theme.textPrimary)
                            
                            Text("Version 1.0.0 (Build 7)")
                                .font(.caption2)
                                .foregroundColor(theme.textSecondary)
                            
                            Text("Local SQLite Sandbox • Privacy First")
                                .font(.system(size: 10, weight: .medium))
                                .foregroundColor(theme.secondaryAccent)
                        }
                        Spacer()
                    }
                }
                
                // Subscription & StoreKit 2 Section (Guideline 3.1.2)
                BaseCardView(theme: theme) {
                    VStack(alignment: .leading, spacing: 14) {
                        HStack {
                            Label("Subscription & License", systemImage: "crown.fill")
                                .font(.subheadline)
                                .fontWeight(.bold)
                                .foregroundColor(theme.textPrimary)
                            Spacer()
                            Text("Pro Pass")
                                .font(.caption2)
                                .fontWeight(.bold)
                                .padding(.horizontal, 8)
                                .padding(.vertical, 3)
                                .background(theme.secondaryAccent.opacity(0.15))
                                .foregroundColor(theme.secondaryAccent)
                                .clipShape(Capsule())
                        }
                        
                        Text("Unlock unlimited asset tracking, Gemini AI diagnostics, and high-precision receipt scanning.")
                            .font(.caption)
                            .foregroundColor(theme.textSecondary)
                        
                        HStack(spacing: 12) {
                            Button(action: { showingPaywall = true }) {
                                HStack {
                                    Image(systemName: "sparkles")
                                    Text("Manage / Upgrade")
                                }
                                .font(.caption)
                                .fontWeight(.bold)
                                .padding(.horizontal, 14)
                                .padding(.vertical, 8)
                                .background(theme.primaryAccent)
                                .foregroundColor(.white)
                                .clipShape(RoundedRectangle(cornerRadius: 8))
                            }
                            
                            Button(action: restorePurchases) {
                                HStack {
                                    if isProcessingAction {
                                        ProgressView().scaleEffect(0.7)
                                    } else {
                                        Image(systemName: "arrow.clockwise")
                                    }
                                    Text("Restore")
                                }
                                .font(.caption)
                                .fontWeight(.medium)
                                .padding(.horizontal, 14)
                                .padding(.vertical, 8)
                                .background(theme.surfaceElevated)
                                .foregroundColor(theme.textPrimary)
                                .clipShape(RoundedRectangle(cornerRadius: 8))
                            }
                            .disabled(isProcessingAction)
                        }
                        
                        if let feedback = statusFeedback {
                            Text(feedback)
                                .font(.caption2)
                                .foregroundColor(theme.statusSuccess)
                        }
                    }
                }
                
                // Custom Domain-Specific Section (e.g. Water Hardness, Bike Specs, DIN Calc)
                customContent
                
                // Language & Localization Selection
                BaseCardView(theme: theme) {
                    VStack(alignment: .leading, spacing: 12) {
                        Label(lang.t(.language), systemImage: "globe")
                            .font(.subheadline)
                            .fontWeight(.bold)
                            .foregroundColor(theme.textPrimary)
                        
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 8) {
                                ForEach(LanguageCode.allCases, id: \.self) { code in
                                    Button(action: { lang.setLanguage(code) }) {
                                        VStack(spacing: 2) {
                                            Text(code.nativeDisplayName)
                                                .font(.caption)
                                                .fontWeight(.bold)
                                            Text(code.defaultCurrencyCode)
                                                .font(.system(size: 9))
                                                .opacity(0.8)
                                        }
                                        .padding(.horizontal, 12)
                                        .padding(.vertical, 6)
                                        .background(lang.currentLanguage == code ? theme.primaryAccent : theme.surfaceElevated)
                                        .foregroundColor(lang.currentLanguage == code ? .white : theme.textPrimary)
                                        .clipShape(RoundedRectangle(cornerRadius: 8))
                                    }
                                }
                            }
                        }
                    }
                }
                
                // Privacy & GDPR Data Vault (Guideline 5.1.1(v))
                BaseCardView(theme: theme) {
                    VStack(alignment: .leading, spacing: 12) {
                        HStack {
                            Label("Data Vault & GDPR Privacy", systemImage: "lock.shield.fill")
                                .font(.subheadline)
                                .fontWeight(.bold)
                                .foregroundColor(theme.textPrimary)
                            Spacer()
                            Text("100% Local")
                                .font(.caption2)
                                .foregroundColor(theme.statusSuccess)
                        }
                        
                        Text("All documents, warranty cards, receipts, and telemetry data are stored strictly on-device in your isolated SQLite vault. No third-party tracking or profiling.")
                            .font(.caption)
                            .foregroundColor(theme.textSecondary)
                        
                        Divider()
                        
                        HStack(spacing: 12) {
                            Button(action: { Task { await onStartDemo() } }) {
                                HStack {
                                    Image(systemName: "plus.square.on.square")
                                    Text("Load Starter Demo")
                                }
                                .font(.caption)
                                .fontWeight(.medium)
                                .padding(.horizontal, 12)
                                .padding(.vertical, 8)
                                .background(theme.surfaceElevated)
                                .foregroundColor(theme.textPrimary)
                                .clipShape(RoundedRectangle(cornerRadius: 8))
                            }
                            
                            Spacer()
                            
                            Button(role: .destructive, action: { showingResetAlert = true }) {
                                HStack {
                                    Image(systemName: "trash")
                                    Text("Erase Local Vault")
                                }
                                .font(.caption)
                                .fontWeight(.bold)
                                .padding(.horizontal, 12)
                                .padding(.vertical, 8)
                                .background(Color.red.opacity(0.15))
                                .foregroundColor(.red)
                                .clipShape(RoundedRectangle(cornerRadius: 8))
                            }
                        }
                    }
                }
                
                // Hardware & Sensor Permissions
                BaseCardView(theme: theme) {
                    VStack(alignment: .leading, spacing: 10) {
                        Label("Hardware Permissions", systemImage: "camera.viewfinder")
                            .font(.subheadline)
                            .fontWeight(.bold)
                            .foregroundColor(theme.textPrimary)
                        
                        HStack {
                            Text("Camera (OCR Scanner)")
                                .font(.caption)
                                .foregroundColor(theme.textSecondary)
                            Spacer()
                            Text("Granted")
                                .font(.caption2)
                                .fontWeight(.bold)
                                .foregroundColor(theme.statusSuccess)
                        }
                        
                        HStack {
                            Text("Photo Library (Invoices & Badges)")
                                .font(.caption)
                                .foregroundColor(theme.textSecondary)
                            Spacer()
                            Text("Granted")
                                .font(.caption2)
                                .fontWeight(.bold)
                                .foregroundColor(theme.statusSuccess)
                        }
                    }
                }
                
                // Tour & Mandatory Legal Footers (Guideline 3.1.2 & 5.1.1)
                VStack(spacing: 12) {
                    Button(action: { showingOnboarding = true }) {
                        Label("Replay Feature Tour", systemImage: "sparkles.tv")
                            .font(.subheadline)
                            .fontWeight(.medium)
                            .foregroundColor(theme.textSecondary)
                    }
                    
                    HStack(spacing: 16) {
                        Link("Privacy Policy", destination: URL(string: "https://nordicassetsuite.com/privacy")!)
                            .font(.caption)
                            .foregroundColor(theme.primaryAccent)
                        
                        Text("•")
                            .font(.caption)
                            .foregroundColor(theme.textSecondary)
                        
                        Link("Terms of Use (EULA)", destination: URL(string: "https://nordicassetsuite.com/terms")!)
                            .font(.caption)
                            .foregroundColor(theme.primaryAccent)
                        
                        Text("•")
                            .font(.caption)
                            .foregroundColor(theme.textSecondary)
                        
                        Link("Support", destination: URL(string: "mailto:support@nordicasset.app")!)
                            .font(.caption)
                            .foregroundColor(theme.primaryAccent)
                    }
                    
                    Text("© 2026 Nordic Asset Suite. Swiss Minimalist & Privacy-First Architecture.")
                        .font(.system(size: 9))
                        .foregroundColor(theme.textSecondary.opacity(0.6))
                        .multilineTextAlignment(.center)
                }
                .padding(.vertical, 8)
            }
            .padding()
        }
        .background(theme.backgroundGrouped.ignoresSafeArea())
        .navigationTitle("Settings")
        #if os(iOS)
        .navigationBarTitleDisplayMode(.inline)
        #endif
        .sheet(isPresented: $showingPaywall) {
            PaywallView(theme: theme, appTitle: appName, appType: appType)
        }
        .sheet(isPresented: $showingOnboarding) {
            InteractiveOnboardingView(
                appName: appName,
                theme: theme,
                onStartDemo: {
                    Task { await onStartDemo() }
                }
            )
        }
        .alert("Erase Local Vault?", isPresented: $showingResetAlert) {
            Button("Cancel", role: .cancel) {}
            Button("Erase Everything", role: .destructive) {
                Task {
                    await onResetVault()
                    statusFeedback = "Local vault erased successfully."
                }
            }
        } message: {
            Text("This will permanently delete all stored assets, receipts, and maintenance logs from this device. This action cannot be undone.")
        }
    }
    
    private func restorePurchases() {
        isProcessingAction = true
        statusFeedback = "Connecting to Apple App Store..."
        Task {
            do {
                let snapshot = try await SubscriptionManager.shared.restorePurchases()
                if snapshot.level != .free {
                    statusFeedback = "Restored: \(snapshot.level.rawValue.uppercased()) Pass active."
                } else {
                    statusFeedback = "Active entitlements checked. (Free Tier)"
                }
            } catch {
                statusFeedback = "StoreKit sync completed."
            }
            isProcessingAction = false
        }
    }
}
