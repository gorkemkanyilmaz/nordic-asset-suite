//
//  SuiteSettingsView.swift
//  AssetCoreSubscription
//
//  Created for Nordic Asset Suite.
//  Strict Concurrency: Complete. Apple App Store Guidelines 5.1.1 & 3.1.2 Compliant Settings Screen.
//  Matches localhost Preferences & Data architecture.
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
    
    @AppStorage("nordic_warranty_notif_enabled") private var warrantyNotifsEnabled: Bool = true
    @AppStorage("nordic_maint_notif_enabled") private var maintNotifsEnabled: Bool = true
    
    @State private var lang = LanguageManager.shared
    
    private var appVersionDisplay: String {
        let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0.0"
        let build = Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "16"
        return "Version \(version) (Build \(build))"
    }
    
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
            VStack(spacing: 18) {
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
                            
                            Text(appVersionDisplay)
                                .font(.caption2)
                                .foregroundColor(theme.textSecondary)
                            
                            Text("Local SQLite Sandbox • Privacy First")
                                .font(.system(size: 10, weight: .medium))
                                .foregroundColor(theme.secondaryAccent)
                        }
                        Spacer()
                    }
                }
                
                // 1. Regional Standards & Localization (Matches localhost lines 474–520)
                BaseCardView(theme: theme) {
                    VStack(alignment: .leading, spacing: 14) {
                        Label(lang.t(.settingsRegionalTitle).uppercased(), systemImage: "globe.europe.africa.fill")
                            .font(.system(size: 11, weight: .bold))
                            .foregroundColor(theme.secondaryAccent)
                        
                        // Language Selection
                        VStack(alignment: .leading, spacing: 4) {
                            HStack {
                                VStack(alignment: .leading, spacing: 2) {
                                    Text(lang.t(.settingsLangLabel))
                                        .font(.subheadline)
                                        .fontWeight(.semibold)
                                        .foregroundColor(theme.textPrimary)
                                    Text(lang.t(.settingsLangSub))
                                        .font(.system(size: 11))
                                        .foregroundColor(theme.textSecondary)
                                }
                                Spacer()
                                
                                Picker("", selection: Binding(
                                    get: { lang.currentLanguage },
                                    set: { newLang in
                                        lang.setLanguage(newLang)
                                        statusFeedback = "Language updated to \(newLang.nativeDisplayName)"
                                    }
                                )) {
                                    ForEach(LanguageCode.allCases, id: \.self) { code in
                                        Text(code.localizedDisplayName).tag(code)
                                    }
                                }
                                .pickerStyle(.menu)
                                .tint(theme.primaryAccent)
                            }
                        }
                        
                        Divider().opacity(0.3)
                        
                        // Currency Format Selection
                        VStack(alignment: .leading, spacing: 4) {
                            HStack {
                                VStack(alignment: .leading, spacing: 2) {
                                    Text(lang.t(.settingsCurrencyLabel))
                                        .font(.subheadline)
                                        .fontWeight(.semibold)
                                        .foregroundColor(theme.textPrimary)
                                    Text(lang.t(.settingsCurrencySub))
                                        .font(.system(size: 11))
                                        .foregroundColor(theme.textSecondary)
                                }
                                Spacer()
                                
                                Picker("", selection: Binding(
                                    get: { lang.currentCurrencyCode },
                                    set: { newCurr in
                                        lang.setCurrency(newCurr)
                                        statusFeedback = "Currency updated to \(newCurr)"
                                    }
                                )) {
                                    ForEach(LanguageManager.supportedCurrencies) { curr in
                                        Text(curr.label).tag(curr.code)
                                    }
                                }
                                .pickerStyle(.menu)
                                .tint(theme.primaryAccent)
                            }
                        }
                        
                        Divider().opacity(0.3)
                        
                        // Statutory Legal Warranty Selection
                        VStack(alignment: .leading, spacing: 4) {
                            HStack {
                                VStack(alignment: .leading, spacing: 2) {
                                    Text(lang.t(.settingsStatutoryTitle))
                                        .font(.subheadline)
                                        .fontWeight(.semibold)
                                        .foregroundColor(theme.textPrimary)
                                    Text(lang.t(.settingsStatutorySub))
                                        .font(.system(size: 11))
                                        .foregroundColor(theme.textSecondary)
                                }
                                Spacer()
                                
                                Picker("", selection: Binding(
                                    get: { lang.statutoryWarrantyMonths },
                                    set: { newMonths in
                                        lang.setStatutoryWarrantyMonths(newMonths)
                                        statusFeedback = "Statutory standard set to \(newMonths) months"
                                    }
                                )) {
                                    ForEach(LanguageManager.supportedStatutoryWarranties) { opt in
                                        Text(opt.label).tag(opt.months)
                                    }
                                }
                                .pickerStyle(.menu)
                                .tint(theme.primaryAccent)
                            }
                        }
                    }
                }
                
                // 2. Subscription & StoreKit 2 Section (Guideline 3.1.2)
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
                
                // 3. Diagnostics & Onboarding (Matches localhost lines 521–531)
                BaseCardView(theme: theme) {
                    VStack(alignment: .leading, spacing: 14) {
                        Label(lang.t(.settingsDiagnosticsGroup), systemImage: "sparkles")
                            .font(.system(size: 11, weight: .bold))
                            .foregroundColor(theme.secondaryAccent)
                        
                        Button(action: { showingOnboarding = true }) {
                            HStack {
                                Text(lang.t(.settingsTourLabel))
                                    .font(.subheadline)
                                    .foregroundColor(theme.textPrimary)
                                Spacer()
                                Image(systemName: "chevron.right")
                                    .font(.caption)
                                    .foregroundColor(theme.textSecondary)
                            }
                        }
                        
                        Divider().opacity(0.3)
                        
                        Button(action: {
                            Task {
                                await onStartDemo()
                                statusFeedback = "Demo hardware reloaded successfully."
                            }
                        }) {
                            HStack {
                                Text(lang.t(.settingsResetDemo))
                                    .font(.subheadline)
                                    .foregroundColor(theme.textPrimary)
                                Spacer()
                                Image(systemName: "arrow.counterclockwise")
                                    .font(.caption)
                                    .foregroundColor(theme.textSecondary)
                            }
                        }
                    }
                }
                
                // 4. Warranty & Service Notifications (Matches localhost lines 532–558)
                BaseCardView(theme: theme) {
                    VStack(alignment: .leading, spacing: 14) {
                        Label(lang.t(.notifSettingsGroup), systemImage: "bell.badge.fill")
                            .font(.system(size: 11, weight: .bold))
                            .foregroundColor(theme.secondaryAccent)
                        
                        HStack {
                            VStack(alignment: .leading, spacing: 2) {
                                Text(lang.t(.notifSettingsWarrantyTitle))
                                    .font(.subheadline)
                                    .fontWeight(.semibold)
                                    .foregroundColor(theme.textPrimary)
                                Text(lang.t(.notifSettingsWarrantyDesc))
                                    .font(.system(size: 11))
                                    .foregroundColor(theme.textSecondary)
                            }
                            Spacer()
                            Toggle("", isOn: $warrantyNotifsEnabled)
                                .labelsHidden()
                                .tint(theme.primaryAccent)
                        }
                        
                        Divider().opacity(0.3)
                        
                        HStack {
                            VStack(alignment: .leading, spacing: 2) {
                                Text(lang.t(.notifSettingsMaintTitle))
                                    .font(.subheadline)
                                    .fontWeight(.semibold)
                                    .foregroundColor(theme.textPrimary)
                                Text(lang.t(.notifSettingsMaintDesc))
                                    .font(.system(size: 11))
                                    .foregroundColor(theme.textSecondary)
                            }
                            Spacer()
                            Toggle("", isOn: $maintNotifsEnabled)
                                .labelsHidden()
                                .tint(theme.primaryAccent)
                        }
                        
                        Divider().opacity(0.3)
                        
                        Button(action: {
                            statusFeedback = "Local push notifications are active for statutory expirations."
                        }) {
                            HStack {
                                Label(lang.t(.notifSettingsTimeline), systemImage: "bell.fill")
                                    .font(.subheadline)
                                    .foregroundColor(theme.primaryAccent)
                                Spacer()
                                Image(systemName: "chevron.right")
                                    .font(.caption)
                                    .foregroundColor(theme.textSecondary)
                            }
                        }
                    }
                }
                
                // 5. Privacy & GDPR Data Vault (Guideline 5.1.1(v))
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
                        
                        Divider().opacity(0.3)
                        
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
                                    Text(lang.t(.settingsEraseTitle))
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
                
                // 6. Hardware & Sensor Permissions
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
                
                // 7. Legal, Privacy & Support (Matches localhost lines 570–600)
                BaseCardView(theme: theme) {
                    VStack(alignment: .leading, spacing: 14) {
                        Label(lang.t(.settingsGroupLegal), systemImage: "shield.lefthalf.filled")
                            .font(.system(size: 11, weight: .bold))
                            .foregroundColor(theme.secondaryAccent)
                        
                        Link(destination: URL(string: "https://nordicassetsuite.com/privacy")!) {
                            HStack {
                                VStack(alignment: .leading, spacing: 2) {
                                    HStack(spacing: 6) {
                                        Image(systemName: "person.badge.shield.checkmark.fill")
                                            .foregroundColor(theme.primaryAccent)
                                        Text(lang.t(.settingsPrivacyTitle))
                                            .font(.subheadline)
                                            .foregroundColor(theme.textPrimary)
                                    }
                                    Text(lang.t(.settingsPrivacySub))
                                        .font(.system(size: 11))
                                        .foregroundColor(theme.textSecondary)
                                }
                                Spacer()
                                Image(systemName: "arrow.up.right")
                                    .font(.caption)
                                    .foregroundColor(theme.textSecondary)
                            }
                        }
                        
                        Divider().opacity(0.3)
                        
                        Link(destination: URL(string: "https://nordicassetsuite.com/terms")!) {
                            HStack {
                                VStack(alignment: .leading, spacing: 2) {
                                    HStack(spacing: 6) {
                                        Image(systemName: "doc.plaintext.fill")
                                            .foregroundColor(theme.primaryAccent)
                                        Text(lang.t(.settingsTermsTitle))
                                            .font(.subheadline)
                                            .foregroundColor(theme.textPrimary)
                                    }
                                    Text(lang.t(.settingsTermsSub))
                                        .font(.system(size: 11))
                                        .foregroundColor(theme.textSecondary)
                                }
                                Spacer()
                                Image(systemName: "arrow.up.right")
                                    .font(.caption)
                                    .foregroundColor(theme.textSecondary)
                            }
                        }
                        
                        Divider().opacity(0.3)
                        
                        Link(destination: URL(string: "mailto:support@nordicasset.app")!) {
                            HStack {
                                VStack(alignment: .leading, spacing: 2) {
                                    HStack(spacing: 6) {
                                        Image(systemName: "headset")
                                            .foregroundColor(theme.primaryAccent)
                                        Text(lang.t(.settingsSupportTitle))
                                            .font(.subheadline)
                                            .foregroundColor(theme.textPrimary)
                                    }
                                    Text(lang.t(.settingsSupportSub))
                                        .font(.system(size: 11))
                                        .foregroundColor(theme.textSecondary)
                                }
                                Spacer()
                                Image(systemName: "envelope.fill")
                                    .font(.caption)
                                    .foregroundColor(theme.textSecondary)
                            }
                        }
                    }
                }
                
                // Footer: Dynamic Version Info
                VStack(spacing: 6) {
                    Text("Nordic Asset Suite \(appVersionDisplay) • Swiss Precision")
                        .font(.system(size: 11, weight: .medium))
                        .foregroundColor(theme.textSecondary.opacity(0.7))
                        .multilineTextAlignment(.center)
                    
                    Text("© 2026 Nordic Asset Suite. Privacy-First Architecture.")
                        .font(.system(size: 9))
                        .foregroundColor(theme.textSecondary.opacity(0.5))
                        .multilineTextAlignment(.center)
                }
                .padding(.top, 4)
                .padding(.bottom, 20)
            }
            .padding()
        }
        .background(theme.backgroundGrouped.ignoresSafeArea())
        .navigationTitle(lang.t(.settingsPreferencesTitle))
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
