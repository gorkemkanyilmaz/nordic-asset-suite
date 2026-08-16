//
//  ApplianceDetailView.swift
//  ApplianceWarrantyManager
//
//  Created for Nordic Asset Suite.
//  Strict Concurrency: Complete. Spatial Room & Appliance Detail Screen.
//

import SwiftUI
import AssetCoreDatabase
import AssetCoreUIComponents
import AssetCoreLocalization

public struct ApplianceDetailView: View {
    public let appliance: ApplianceDTO
    private let theme = ApplianceTheme()
    
    @State private var showingErrorScanner: Bool = false
    @State private var filterReplacedToday: Bool = false
    
    public init(appliance: ApplianceDTO) {
        self.appliance = appliance
    }
    
    public var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Header Health & Status Card
                BaseCardView(theme: theme) {
                    HStack {
                        VStack(alignment: .leading, spacing: 6) {
                            Text(appliance.brand)
                                .font(.subheadline)
                                .fontWeight(.semibold)
                                .foregroundColor(theme.textSecondary)
                            
                            Text(appliance.modelName)
                                .font(.title2)
                                .fontWeight(.bold)
                                .foregroundColor(theme.textPrimary)
                            
                            Text("Room: \(appliance.roomLocation)")
                                .font(.caption)
                                .foregroundColor(theme.textSecondary)
                        }
                        Spacer()
                        
                        MetricBadgeView(
                            label: "Health",
                            value: "\(appliance.latestHealthScore ?? 100)%",
                            status: (appliance.latestHealthScore ?? 100) > 80 ? .success : .warning,
                            theme: theme
                        )
                    }
                }
                
                // Warranty Information Card
                BaseCardView(theme: theme) {
                    VStack(alignment: .leading, spacing: 12) {
                        Label("Warranty Status", systemImage: "shield.checkered")
                            .font(.headline)
                            .foregroundColor(theme.primaryAccent)
                        
                        Divider()
                        
                        HStack {
                            Text("Expires:")
                                .foregroundColor(theme.textSecondary)
                            Spacer()
                            Text(RegionalFormatter.shared.formatDate(appliance.warrantyEndDate))
                                .fontWeight(.semibold)
                                .foregroundColor(appliance.isWarrantyActive ? theme.textPrimary : theme.statusCritical)
                        }
                        
                        HStack {
                            Text("Time Horizon:")
                                .foregroundColor(theme.textSecondary)
                            Spacer()
                            Text(RegionalFormatter.shared.formatRelativeTime(to: appliance.warrantyEndDate))
                                .font(.subheadline)
                                .foregroundColor(appliance.isWarrantyActive ? theme.textSecondary : theme.statusCritical)
                        }
                        
                        HStack {
                            Text("Purchase Price:")
                                .foregroundColor(theme.textSecondary)
                            Spacer()
                            Text(RegionalFormatter.shared.formatCurrency(amount: appliance.purchasePrice, currencyCode: appliance.currencyCode))
                                .font(.subheadline)
                                .fontWeight(.medium)
                        }
                    }
                }
                
                // Filter Maintenance Card
                BaseCardView(theme: theme) {
                    VStack(alignment: .leading, spacing: 12) {
                        Label("Filter Tracking", systemImage: "air.purifier")
                            .font(.headline)
                            .foregroundColor(theme.primaryAccent)
                        
                        Divider()
                        
                        Text("Active Filters: \(max(1, appliance.filterCount))")
                            .font(.subheadline)
                            .foregroundColor(theme.textSecondary)
                        
                        if filterReplacedToday {
                            Text("Filter replacement logged today! Health score updated.")
                                .font(.caption)
                                .foregroundColor(theme.statusSuccess)
                        } else {
                            PrimaryButton(title: "Log Filter Replacement", icon: "arrow.clockwise", theme: theme) {
                                filterReplacedToday = true
                            }
                        }
                    }
                }
                
                // Error Code AI Diagnostic Scanner Button
                PrimaryButton(
                    title: "Scan Appliance Error Code (AI)",
                    icon: "camera.viewfinder",
                    theme: theme
                ) {
                    showingErrorScanner = true
                }
                .sheet(isPresented: $showingErrorScanner) {
                    VStack(spacing: 20) {
                        Text("Appliance Diagnostic Scanner")
                            .font(.headline)
                        Text("Align your camera with the flashing display or error badge.")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal)
                        
                        RoundedRectangle(cornerRadius: 16)
                            .strokeBorder(style: StrokeStyle(lineWidth: 2, dash: [8]))
                            .foregroundColor(theme.primaryAccent)
                            .frame(height: 220)
                            .overlay(
                                Image(systemName: "exclamationmark.triangle")
                                    .font(.system(size: 44))
                                    .foregroundColor(theme.statusWarning)
                            )
                            .padding()
                        
                        PrimaryButton(title: "Simulate Scan E24 (Drain Error)", theme: theme) {
                            showingErrorScanner = false
                        }
                        .padding(.horizontal)
                    }
                    .padding()
                }
            }
            .padding()
        }
        .background(theme.backgroundGrouped)
        .navigationTitle(appliance.modelName)
        .navigationBarTitleDisplayMode(.inline)
    }
}
