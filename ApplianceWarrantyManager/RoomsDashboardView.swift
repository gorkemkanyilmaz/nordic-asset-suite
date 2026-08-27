//
//  RoomsDashboardView.swift
//  ApplianceWarrantyManager
//
//  Created for Nordic Asset Suite.
//  Strict Concurrency: Complete. Swiss & Nordic Consumer Utility Warranty Dashboard.
//

import SwiftUI
import AssetCoreDatabase
import AssetCoreUIComponents
import AssetCoreLocalization

public struct RoomsDashboardView: View {
    @Bindable var viewModel: ApplianceViewModel
    private let theme = ApplianceTheme()
    private let lang = LanguageManager.shared
    
    public init(viewModel: ApplianceViewModel) {
        self.viewModel = viewModel
    }
    
    private var greetingText: String {
        let hour = Calendar.current.component(.hour, from: Date())
        switch hour {
        case 5..<12: return lang.t(.greetingMorning)
        case 12..<17: return lang.t(.greetingAfternoon)
        default: return lang.t(.greetingEvening)
        }
    }
    
    public var body: some View {
        NavigationStack {
            ScrollView {
                dashboardContent
            }
            .background(theme.backgroundGrouped)
            .navigationTitle(lang.t(.applianceWarrantyManager))
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
                    .accessibilityLabel(lang.t(.addAppliance))
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
    
    private var dashboardContent: some View {
        VStack(spacing: 18) {
            InteractiveDemoBar(
                theme: theme,
                onOpenGuide: { viewModel.showingOnboardingGuide = true },
                onQuickDemoAdd: { Task { await viewModel.injectDemoAppliances() } }
            )
            
            greetingSection
            
            attentionCallout
            
            roomFilterPills
            
            applianceSection
        }
        .padding()
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
            
            Text(String(format: lang.t(.activeProtectionCount), viewModel.appliances.count, viewModel.appliances.filter { $0.isWarrantyActive }.count))
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
                    Text(String(format: lang.t(.warrantyExpiredCount), expiredCount))
                        .font(.subheadline)
                        .fontWeight(.bold)
                        .foregroundColor(theme.textPrimary)
                    Text(lang.t(.reviewCoverage))
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
    
    private var roomFilterPills: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                ForEach(viewModel.availableRooms, id: \.self) { room in
                    Button(action: { viewModel.selectedRoom = room }) {
                        Text(translateRoom(room))
                            .font(.caption)
                            .fontWeight(.semibold)
                            .padding(.horizontal, 14)
                            .padding(.vertical, 7)
                            .background(viewModel.selectedRoom == room ? theme.primaryAccent : theme.cardBackground)
                            .foregroundColor(viewModel.selectedRoom == room ? .white : theme.textPrimary)
                            .clipShape(Capsule())
                            .overlay(
                                Capsule()
                                    .stroke(theme.borderSubtle, lineWidth: 1)
                            )
                    }
                }
            }
        }
    }
    
    @ViewBuilder
    private var applianceSection: some View {
        if viewModel.filteredAppliances.isEmpty {
            emptyState
        } else {
            applianceList
        }
    }
    
    private var emptyState: some View {
        VStack(spacing: 12) {
            Image(systemName: "house")
                .font(.system(size: 44))
                .foregroundColor(theme.textSecondary.opacity(0.4))
            Text(lang.t(.noAppliancesRegistered))
                .font(.headline)
                .foregroundColor(theme.textPrimary)
            Text(lang.t(.scanOrEnterModel))
                .font(.caption)
                .foregroundColor(theme.textSecondary)
                .multilineTextAlignment(.center)
            
            Button(action: { Task { await viewModel.injectDemoAppliances() } }) {
                Text(lang.t(.loadSampleAppliances))
                    .font(.caption)
                    .fontWeight(.semibold)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 8)
                    .background(theme.primaryAccent)
                    .foregroundColor(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 8))
            }
            .padding(.top, 4)
        }
        .padding(.vertical, 32)
    }
    
    private var applianceList: some View {
        LazyVStack(spacing: 10) {
            ForEach(viewModel.filteredAppliances) { appliance in
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

/// Formats currency using the device locale.
@MainActor
private struct LocalizedCurrencyFormatter {
    static let shared = LocalizedCurrencyFormatter()
    func format(amount: Decimal, currencyCode: String) -> String {
        RegionalFormatter.shared.formatCurrency(amount: amount, currencyCode: currencyCode, locale: LanguageManager.shared.currentLocale)
    }
}
