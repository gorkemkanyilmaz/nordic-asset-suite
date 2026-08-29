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
    private let lang = LanguageManager.shared
    
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
                    // Header
                    HStack {
                        VStack(alignment: .leading, spacing: 2) {
                            Text("Warranty Timeline")
                                .font(.title2)
                                .fontWeight(.bold)
                                .foregroundColor(theme.textPrimary)
                            Text("Multi-layer statutory & commercial coverage")
                                .font(.caption)
                                .foregroundColor(theme.textSecondary)
                        }
                        Spacer()
                    }
                    .padding(.horizontal, 4)
                    
                    // 3-Column Overview Grid
                    HStack(spacing: 10) {
                        statCard(title: "ACTIVE", count: activeCount, subtitle: "Fully covered", color: theme.statusSuccess)
                        statCard(title: "EXPIRING", count: expiringSoonCount, subtitle: "Within 90d", color: theme.statusWarning)
                        statCard(title: "EXPIRED", count: expiredCount, subtitle: "Action req.", color: theme.statusCritical)
                    }
                    
                    // Warranty Alert Cards List
                    VStack(spacing: 12) {
                        ForEach(viewModel.appliances) { appliance in
                            warrantyCard(appliance)
                        }
                    }
                }
                .padding()
            }
            .background(theme.backgroundGrouped.ignoresSafeArea())
            .preferredColorScheme(.dark)
            .navigationTitle("Warranties")
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
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                VStack(alignment: .leading, spacing: 2) {
                    Text(appliance.brand.uppercased())
                        .font(.caption2)
                        .fontWeight(.bold)
                        .foregroundColor(theme.textMuted)
                    Text(appliance.modelName)
                        .font(.subheadline)
                        .fontWeight(.bold)
                        .foregroundColor(theme.textPrimary)
                }
                Spacer()
                
                if appliance.isWarrantyActive {
                    Text("ACTIVE")
                        .font(.caption2)
                        .fontWeight(.bold)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(theme.statusSuccess.opacity(0.15))
                        .foregroundColor(theme.statusSuccess)
                        .clipShape(Capsule())
                } else {
                    Text("EXPIRED")
                        .font(.caption2)
                        .fontWeight(.bold)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(theme.statusCritical.opacity(0.15))
                        .foregroundColor(theme.statusCritical)
                        .clipShape(Capsule())
                }
            }
            
            Divider()
            
            HStack {
                VStack(alignment: .leading, spacing: 2) {
                    Text("COVERAGE PERIOD")
                        .font(.system(size: 9, weight: .bold))
                        .foregroundColor(theme.textSecondary)
                    Text("Ends \(RegionalFormatter.shared.formatDate(appliance.warrantyEndDate))")
                        .font(.caption)
                        .fontWeight(.semibold)
                        .foregroundColor(theme.textPrimary)
                }
                Spacer()
                
                VStack(alignment: .trailing, spacing: 2) {
                    Text("CLAIM OBLIGOR")
                        .font(.system(size: 9, weight: .bold))
                        .foregroundColor(theme.textSecondary)
                    Text(appliance.purchaseCountry == "CH" ? "Swiss Retailer / Mfr" : "Authorized Seller")
                        .font(.caption)
                        .foregroundColor(theme.textSecondary)
                }
            }
            
            // Action button to claim
            Button(action: { selectedApplianceForClaim = appliance }) {
                HStack {
                    Image(systemName: "filemenu.and.selection")
                    Text("Generate Statutory Defect Notice")
                        .font(.caption)
                        .fontWeight(.bold)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 8)
                .background(theme.primaryAccent.opacity(0.15))
                .foregroundColor(theme.primaryAccent)
                .clipShape(RoundedRectangle(cornerRadius: 8))
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
}
