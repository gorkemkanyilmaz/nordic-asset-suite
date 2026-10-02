//
//  WarrantiesTimelineView.swift
//  ApplianceWarrantyManager
//
//  Created for Nordic Asset Suite.
//  Strict Concurrency: Complete. Warranty Timeline, Breakdown & Defect Rights.
//

import SwiftUI
import AssetCoreDatabase
import AssetCoreUIComponents
import AssetCoreLocalization

public struct WarrantiesTimelineView: View {
    @Bindable public var viewModel: ApplianceViewModel
    private let theme = ApplianceTheme()
    @State private var lang = LanguageManager.shared
    
    @State private var selectedApplianceForClaim: ApplianceDTO? = nil
    
    public init(viewModel: ApplianceViewModel) {
        self.viewModel = viewModel
    }
    
    private var activeCount: Int {
        viewModel.appliances.filter { $0.isWarrantyActive }.count
    }
    
    private var expiringSoonCount: Int {
        let ninetyDays = Calendar.current.date(byAdding: .day, value: 90, to: Date()) ?? Date()
        return viewModel.appliances.filter { $0.isWarrantyActive && $0.warrantyEndDate <= ninetyDays }.count
    }
    
    private var expiredCount: Int {
        viewModel.appliances.filter { !$0.isWarrantyActive }.count
    }
    
    public var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 16) {
                    // Header with Share Vault button
                    HStack {
                        VStack(alignment: .leading, spacing: 2) {
                            Text(lang.t(.warrantyTimeline))
                                .font(.title2)
                                .fontWeight(.bold)
                                .foregroundColor(theme.textPrimary)
                            Text("Multi-layer statutory & commercial coverage")
                                .font(.caption)
                                .foregroundColor(theme.textSecondary)
                        }
                        Spacer()
                        
                        ShareLink(
                            item: generateVaultReportText(),
                            subject: Text("Nordic Asset Suite — Warranty Vault"),
                            message: Text("Here is my household warranty protection summary.")
                        ) {
                            HStack(spacing: 6) {
                                Image(systemName: "square.and.arrow.up")
                                Text(lang.t(.shareVaultBtn))
                                    .fontWeight(.semibold)
                            }
                            .font(.caption)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 7)
                            .background(theme.cardBackground)
                            .foregroundColor(theme.primaryAccent)
                            .clipShape(Capsule())
                            .overlay(
                                Capsule()
                                    .stroke(theme.borderSubtle, lineWidth: 1)
                            )
                        }
                    }
                    .padding(.horizontal, 4)
                    
                    // 3-Column Overview Grid
                    HStack(spacing: 10) {
                        statCard(title: lang.t(.statusActive), count: activeCount, subtitle: lang.t(.statFullyCovered), color: theme.statusSuccess)
                        statCard(title: lang.t(.statusExpiringSoon), count: expiringSoonCount, subtitle: lang.t(.statWithin90Days), color: theme.statusWarning)
                        statCard(title: lang.t(.statusExpired), count: expiredCount, subtitle: lang.t(.statActionRequired), color: theme.statusCritical)
                    }
                    
                    // Warranty Alert Cards List
                    if viewModel.appliances.isEmpty {
                        BaseCardView(theme: theme) {
                            VStack(spacing: 12) {
                                Image(systemName: "shield.slash")
                                .font(.system(size: 36))
                                .foregroundColor(theme.primaryAccent)
                                Text(lang.t(.noAppliancesRegistered))
                                    .font(.headline)
                                    .foregroundColor(theme.textPrimary)
                                Text(lang.t(.addApplianceCtaDesc))
                                    .font(.caption)
                                    .foregroundColor(theme.textSecondary)
                                    .multilineTextAlignment(.center)
                            }
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 20)
                        }
                    } else {
                        VStack(spacing: 12) {
                            ForEach(viewModel.appliances) { appliance in
                                warrantyCard(appliance)
                            }
                        }
                    }
                }
                .padding()
            }
            .background(theme.backgroundGrouped.ignoresSafeArea())
            .preferredColorScheme(.dark)
            .navigationTitle(lang.t(.navWarranties))
            .navigationBarTitleDisplayMode(.inline)
            .sheet(item: $selectedApplianceForClaim) { appliance in
                LegalDefectNoticeModal(appliance: appliance)
            }
        }
    }
    
    private func statCard(title: String, count: Int, subtitle: String, color: Color) -> some View {
        VStack(spacing: 4) {
            Text(title)
                .font(.system(size: 10, weight: .bold))
                .foregroundColor(theme.textSecondary)
            Text("\(count)")
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(color)
            Text(subtitle)
                .font(.system(size: 10))
                .foregroundColor(theme.textMuted)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 14)
        .background(theme.cardBackground)
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(theme.borderSubtle, lineWidth: 1)
        )
    }
    
    private func warrantyCard(_ appliance: ApplianceDTO) -> some View {
        VStack(spacing: 10) {
            NavigationLink(destination: ApplianceDetailView(appliance: appliance, viewModel: viewModel)) {
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
                            
                            if appliance.isWarrantyActive {
                                Text(lang.t(.statusActive))
                                    .font(.system(size: 10, weight: .bold))
                                    .padding(.horizontal, 8)
                                    .padding(.vertical, 3)
                                    .background(theme.statusSuccess.opacity(0.15))
                                    .foregroundColor(theme.statusSuccess)
                                    .clipShape(Capsule())
                            } else {
                                Text(lang.t(.statusExpired))
                                    .font(.system(size: 10, weight: .bold))
                                    .padding(.horizontal, 8)
                                    .padding(.vertical, 3)
                                    .background(theme.statusCritical.opacity(0.15))
                                    .foregroundColor(theme.statusCritical)
                                    .clipShape(Capsule())
                            }
                        }
                        
                        Text(appliance.modelName)
                            .font(.subheadline)
                            .fontWeight(.semibold)
                            .foregroundColor(theme.textPrimary)
                        
                        HStack(spacing: 4) {
                            if appliance.isWarrantyActive {
                                Text(String(format: lang.t(.warrantyUntil), RegionalFormatter.shared.formatDate(appliance.warrantyEndDate)))
                                    .font(.caption2)
                                    .foregroundColor(theme.statusSuccess)
                            } else {
                                Text(lang.t(.warrantyExpired))
                                    .font(.caption2)
                                    .foregroundColor(theme.statusCritical)
                            }
                            
                            Text("·")
                                .foregroundColor(theme.textMuted)
                            
                            Text("\(appliance.manufacturerWarrantyMonths ?? 24) \(lang.t(.monthsWarranty))")
                                .font(.caption2)
                                .foregroundColor(theme.textMuted)
                        }
                    }
                }
            }
            .buttonStyle(.plain)
            
            if !appliance.isWarrantyActive {
                Button(action: { selectedApplianceForClaim = appliance }) {
                    HStack {
                        Image(systemName: "filemenu.and.selection")
                        Text(lang.t(.drawerLegalNoticeBtn))
                            .font(.caption)
                            .fontWeight(.bold)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 8)
                    .background(theme.primaryAccent.opacity(0.12))
                    .foregroundColor(theme.primaryAccent)
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                }
            }
        }
        .padding(14)
        .background(theme.cardBackground)
        .clipShape(RoundedRectangle(cornerRadius: 14))
        .overlay(
            RoundedRectangle(cornerRadius: 14)
                .stroke(theme.borderSubtle, lineWidth: 1)
        )
    }
    
    private func generateVaultReportText() -> String {
        var report = "Nordic Asset Suite — Appliance Warranty Vault\n"
        report += "\(activeCount) Active Warranties · \(expiredCount) Expired\n\n"
        for a in viewModel.appliances {
            let status = a.isWarrantyActive ? "ACTIVE" : "EXPIRED"
            report += "• \(a.brand) \(a.modelName) [\(status)] - Ends \(RegionalFormatter.shared.formatDate(a.warrantyEndDate))\n"
        }
        report += "\nProtected under Swiss & European statutory consumer laws."
        return report
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
