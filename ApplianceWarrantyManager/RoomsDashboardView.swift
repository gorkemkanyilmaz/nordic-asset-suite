//
//  RoomsDashboardView.swift
//  ApplianceWarrantyManager
//
//  Created for Nordic Asset Suite.
//  Strict Concurrency: Complete. Clean Nordic Home Dashboard matching localhost.
//

import SwiftUI
import AssetCoreDatabase
import AssetCoreUIComponents
import AssetCoreLocalization

public struct RoomsDashboardView: View {
    @Bindable public var viewModel: ApplianceViewModel
    private let theme = ApplianceTheme()
    private let lang = LanguageManager.shared
    
    public init(viewModel: ApplianceViewModel) {
        self.viewModel = viewModel
    }
    
    public var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 18) {
                    greetingSection
                    
                    attentionCallout
                    
                    // My Appliances Header
                    HStack {
                        Text("My Appliances")
                            .font(.headline)
                            .fontWeight(.bold)
                            .foregroundColor(theme.textPrimary)
                        Spacer()
                    }
                    .padding(.top, 4)
                    
                    applianceSection
                    
                    addApplianceBanner
                }
                .padding()
            }
            .background(theme.backgroundGrouped.ignoresSafeArea())
            .preferredColorScheme(.dark)
            .navigationTitle(lang.t(.applianceWarrantyManager))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button(action: { viewModel.showingOnboardingGuide = true }) {
                        Image(systemName: "questionmark.circle")
                            .font(.subheadline)
                            .foregroundColor(theme.primaryAccent)
                    }
                }
                
                ToolbarItem(placement: .primaryAction) {
                    Button(action: { viewModel.showingAddScanner = true }) {
                        Image(systemName: "plus")
                            .font(.subheadline)
                            .fontWeight(.bold)
                            .foregroundColor(theme.primaryAccent)
                    }
                }
            }
            .sheet(isPresented: $viewModel.showingAddScanner) {
                addScannerSheet
            }
            .sheet(isPresented: $viewModel.showingOnboardingGuide) {
                onboardingSheet
            }
            .task {
                await viewModel.loadAppliances()
            }
        }
    }
    
    private var greetingSection: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(greetingText)
                .font(.caption)
                .fontWeight(.medium)
                .foregroundColor(theme.textSecondary)
            
            Text(lang.t(.yourHome))
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(theme.textPrimary)
            
            Text("\(viewModel.appliances.count) appliances · \(viewModel.appliances.filter { $0.isWarrantyActive }.count) covered by warranty")
                .font(.subheadline)
                .foregroundColor(theme.textSecondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.top, 4)
    }
    
    @ViewBuilder
    private var attentionCallout: some View {
        let expiredCount = viewModel.appliances.filter { !$0.isWarrantyActive }.count
        let expiringSoonCount = viewModel.expiringSoonCount
        
        if expiredCount > 0 {
            HStack(spacing: 12) {
                Image(systemName: "exclamationmark.triangle.fill")
                    .font(.title3)
                    .foregroundColor(theme.statusCritical)
                
                VStack(alignment: .leading, spacing: 2) {
                    Text("\(expiredCount) warranty has expired")
                        .font(.subheadline)
                        .fontWeight(.bold)
                        .foregroundColor(theme.textPrimary)
                    Text("Statutory defect rights may still apply. Review coverage.")
                        .font(.caption2)
                        .foregroundColor(theme.textSecondary)
                }
                Spacer()
                Image(systemName: "chevron.right")
                    .font(.caption)
                    .foregroundColor(theme.textSecondary)
            }
            .padding(14)
            .background(theme.statusCritical.opacity(0.1))
            .clipShape(RoundedRectangle(cornerRadius: theme.cornerRadiusCard))
        } else if expiringSoonCount > 0 {
            HStack(spacing: 12) {
                Image(systemName: "clock.badge.exclamationmark.fill")
                    .font(.title3)
                    .foregroundColor(theme.statusWarning)
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(String(format: lang.t(.warrantyExpiringCount), expiringSoonCount))
                        .font(.subheadline)
                        .fontWeight(.bold)
                        .foregroundColor(theme.textPrimary)
                    Text(lang.t(.expiresWithin90Days))
                        .font(.caption2)
                        .foregroundColor(theme.textSecondary)
                }
                Spacer()
                Image(systemName: "chevron.right")
                    .font(.caption)
                    .foregroundColor(theme.textSecondary)
            }
            .padding(14)
            .background(theme.statusWarning.opacity(0.1))
            .clipShape(RoundedRectangle(cornerRadius: theme.cornerRadiusCard))
        }
    }
    
    @ViewBuilder
    private var applianceSection: some View {
        LazyVStack(spacing: 10) {
            ForEach(viewModel.appliances) { appliance in
                applianceRow(appliance)
            }
        }
    }
    
    private func applianceRow(_ appliance: ApplianceDTO) -> some View {
        NavigationLink(destination: ApplianceDetailView(appliance: appliance, viewModel: viewModel)) {
            HStack(spacing: 14) {
                ProductThumbnailView(
                    userImageData: nil,
                    categoryIconName: iconForCategory(appliance.category),
                    variant: .small,
                    cornerRadius: 10,
                    theme: theme
                )
                
                VStack(alignment: .leading, spacing: 3) {
                    HStack {
                        Text(appliance.brand.uppercased())
                            .font(.caption2)
                            .fontWeight(.bold)
                            .foregroundColor(theme.textMuted)
                        Spacer()
                        Text(LocalizedCurrencyFormatter.shared.format(amount: appliance.purchasePrice, currencyCode: appliance.currencyCode))
                            .font(.caption)
                            .fontWeight(.bold)
                            .foregroundColor(theme.textPrimary)
                    }
                    
                    Text(appliance.modelName)
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundColor(theme.textPrimary)
                    
                    HStack(spacing: 6) {
                        Text(translateRoom(appliance.roomLocation))
                            .font(.caption2)
                            .foregroundColor(theme.textSecondary)
                        
                        Text("·")
                            .foregroundColor(theme.textMuted)
                        
                        if appliance.isWarrantyActive {
                            Text(String(format: lang.t(.warrantyUntil), RegionalFormatter.shared.formatDate(appliance.warrantyEndDate)))
                                .font(.caption2)
                                .foregroundColor(theme.statusSuccess)
                        } else {
                            Text(lang.t(.warrantyExpired))
                                .font(.caption2)
                                .foregroundColor(theme.statusCritical)
                        }
                    }
                }
            }
            .padding(14)
            .background(theme.cardBackground)
            .clipShape(RoundedRectangle(cornerRadius: theme.cornerRadiusCard))
            .overlay(
                RoundedRectangle(cornerRadius: theme.cornerRadiusCard)
                    .stroke(theme.borderSubtle, lineWidth: 1)
            )
        }
        .buttonStyle(.plain)
    }
    
    private var addApplianceBanner: some View {
        Button(action: { viewModel.showingAddScanner = true }) {
            HStack(spacing: 14) {
                ZStack {
                    Circle()
                        .fill(theme.primaryAccent.opacity(0.15))
                        .frame(width: 42, height: 42)
                    Image(systemName: "plus")
                        .foregroundColor(theme.primaryAccent)
                        .fontWeight(.bold)
                }
                
                VStack(alignment: .leading, spacing: 2) {
                    Text("Add an appliance")
                        .font(.subheadline)
                        .fontWeight(.bold)
                        .foregroundColor(theme.textPrimary)
                    Text("Scan barcode, photograph rating plate or search model")
                        .font(.caption2)
                        .foregroundColor(theme.textSecondary)
                }
                Spacer()
            }
            .padding(14)
            .background(theme.cardBackground)
            .clipShape(RoundedRectangle(cornerRadius: 14))
            .overlay(
                RoundedRectangle(cornerRadius: 14)
                    .strokeBorder(style: StrokeStyle(lineWidth: 1, dash: [4, 4]))
                    .foregroundColor(theme.primaryAccent.opacity(0.4))
            )
        }
        .buttonStyle(.plain)
    }
    
    private var greetingText: String {
        let hour = Calendar.current.component(.hour, from: Date())
        switch hour {
        case 5..<12: return lang.t(.greetingMorning)
        case 12..<17: return lang.t(.greetingAfternoon)
        default: return lang.t(.greetingEvening)
        }
    }
    
    private var addScannerSheet: some View {
        AddApplianceScannerView(
            onConfirmMatch: { match in
                Task { await viewModel.confirmAndSaveCandidate(match: match) }
            },
            onManualAdd: { brand, model, serial, room, price, currency in
                Task {
                    await viewModel.addScannedAppliance(
                        brand: brand,
                        model: model,
                        serial: serial,
                        room: room,
                        price: price,
                        currency: currency
                    )
                }
            }
        )
    }
    
    private var onboardingSheet: some View {
        InteractiveOnboardingView(
            appName: lang.t(.applianceWarrantyManager),
            theme: theme,
            onStartDemo: { Task { await viewModel.injectDemoAppliances() } }
        )
    }
    
    private func translateRoom(_ room: String) -> String {
        switch room.lowercased() {
        case "all": return lang.t(.roomAll)
        case "kitchen": return lang.t(.kitchen)
        case "living room": return lang.t(.roomLivingFull)
        case "laundry room": return lang.t(.roomLaundryFull)
        case "bathroom": return lang.t(.applianceRoomBathroom)
        case "basement": return lang.t(.basement)
        case "utility closet": return lang.t(.utilityCloset)
        case "office": return lang.t(.office)
        default: return room
        }
    }
    
    private func iconForCategory(_ category: String) -> String {
        switch category.lowercased() {
        case "television", "electronics", "audiovisual": return "tv"
        case "refrigerator", "fridge": return "refrigerator"
        case "oven", "stove": return "oven"
        default: return "washer"
        }
    }
}

@MainActor
private struct LocalizedCurrencyFormatter {
    static let shared = LocalizedCurrencyFormatter()
    func format(amount: Decimal, currencyCode: String) -> String {
        RegionalFormatter.shared.formatCurrency(amount: amount, currencyCode: currencyCode, locale: LanguageManager.shared.currentLocale)
    }
}
