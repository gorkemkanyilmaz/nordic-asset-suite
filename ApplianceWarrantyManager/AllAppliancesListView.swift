//
//  AllAppliancesListView.swift
//  ApplianceWarrantyManager
//
//  Created for Nordic Asset Suite.
//  Strict Concurrency: Complete. Full Filterable List of Appliances.
//

import SwiftUI
import AssetCoreDatabase
import AssetCoreUIComponents
import AssetCoreLocalization
import AssetCoreSubscription

public struct AllAppliancesListView: View {
    @Bindable public var viewModel: ApplianceViewModel
    private let theme = ApplianceTheme()
    @State private var lang = LanguageManager.shared
    
    public init(viewModel: ApplianceViewModel) {
        self.viewModel = viewModel
    }
    
    public var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 16) {
                    // Header with count
                    HStack {
                        VStack(alignment: .leading, spacing: 2) {
                            Text(lang.t(.allAppliances))
                                .font(.title2)
                                .fontWeight(.bold)
                                .foregroundColor(theme.textPrimary)
                            Text("\(viewModel.filteredAppliances.count) \(lang.t(.appliancesTitle).lowercased())")
                                .font(.caption)
                                .foregroundColor(theme.textSecondary)
                        }
                        Spacer()
                    }
                    .padding(.horizontal, 4)
                    
                    // Room Filter Pills
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
                    
                    // Appliance List
                    if viewModel.filteredAppliances.isEmpty {
                        VStack(spacing: 12) {
                            Image(systemName: "house")
                                .font(.system(size: 44))
                                .foregroundColor(theme.textSecondary.opacity(0.4))
                            Text(lang.t(.noAppliancesRegistered))
                                .font(.headline)
                                .foregroundColor(theme.textPrimary)
                        }
                        .padding(.vertical, 40)
                    } else {
                        LazyVStack(spacing: 10) {
                            ForEach(viewModel.filteredAppliances) { appliance in
                                NavigationLink(destination: ApplianceDetailView(appliance: appliance, viewModel: viewModel)) {
                                    applianceRow(appliance)
                                }
                                .buttonStyle(.plain)
                            }
                        }
                    }
                }
                .padding()
            }
            .background(theme.backgroundGrouped.ignoresSafeArea())
            .preferredColorScheme(.dark)
            .navigationTitle(lang.t(.allAppliances))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button(action: { viewModel.triggerAddFlow() }) {
                        Image(systemName: "plus")
                            .font(.body)
                            .fontWeight(.bold)
                            .foregroundColor(theme.primaryAccent)
                    }
                }
            }
            .sheet(isPresented: $viewModel.showingPaywall) {
                PaywallView(
                    theme: theme,
                    appTitle: lang.t(.applianceWarrantyManager),
                    triggerReason: "You've reached the free tier limit of \(FreeTierLimits.maxAssets) appliances. Upgrade to Pro for unlimited items, AI diagnostics, and multi-device sync.",
                    appType: .appliance
                )
            }
            .sheet(isPresented: $viewModel.showingAddScanner) {
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
        }
    }
    
    private func applianceRow(_ appliance: ApplianceDTO) -> some View {
        HStack(spacing: 14) {
            ProductThumbnailView(
                userImageData: appliance.appliancePhotoData,
                verifiedImageUrl: (appliance.imageUrl != nil && !appliance.imageUrl!.isEmpty) ? URL(string: appliance.imageUrl!) : nil,
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
    
    private func translateRoom(_ room: String) -> String {
        switch room.lowercased() {
        case "all": return lang.t(.roomAll)
        case "kitchen", "kitchen counter": return lang.t(.roomKitchen)
        case "living room": return lang.t(.roomLiving)
        case "laundry room": return lang.t(.roomLaundry)
        case "bathroom": return lang.t(.roomBathroom)
        case "bedroom": return lang.t(.roomBedroom)
        case "basement": return lang.t(.roomBasement)
        case "hallway closet", "personal / pocket": return lang.t(.roomLiving)
        default: return room
        }
    }
    
    private func iconForCategory(_ category: String) -> String {
        switch category.lowercased() {
        case "television", "electronics", "audiovisual": return "tv"
        case "smartphone", "phone": return "iphone"
        case "cleaning appliance", "vacuum_cleaner": return "fanblades"
        case "refrigerator", "fridge": return "refrigerator"
        case "coffee", "coffeemachine", "coffee machine": return "mug.fill"
        case "oven", "stove": return "oven"
        default: return "washer"
        }
    }
}

@MainActor
private struct LocalizedCurrencyFormatter {
    static let shared = LocalizedCurrencyFormatter()
    func format(amount: Decimal, currencyCode: String) -> String {
        RegionalFormatter.shared.convertAndFormat(
            amountInCHF: amount,
            targetCurrency: LanguageManager.shared.currentCurrencyCode,
            locale: LanguageManager.shared.currentLocale
        )
    }
}
