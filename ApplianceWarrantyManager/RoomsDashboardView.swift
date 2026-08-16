//
//  RoomsDashboardView.swift
//  ApplianceWarrantyManager
//
//  Created for Nordic Asset Suite.
//  Strict Concurrency: Complete. Spatial Room Hierarchy & Warranty Dashboard.
//

import SwiftUI
import AssetCoreDatabase
import AssetCoreUIComponents
import AssetCoreLocalization

public struct RoomsDashboardView: View {
    @Bindable var viewModel: ApplianceViewModel
    private let theme = ApplianceTheme()
    
    public init(viewModel: ApplianceViewModel) {
        self.viewModel = viewModel
    }
    
    public var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    // Top Spatial Overview Cards
                    HStack(spacing: 12) {
                        BaseCardView(theme: theme) {
                            VStack(alignment: .leading, spacing: 4) {
                                Text("HOME HEALTH")
                                    .font(.caption2)
                                    .fontWeight(.bold)
                                    .foregroundColor(theme.textSecondary)
                                Text("\(viewModel.averageHealthScore)%")
                                    .font(.title)
                                    .fontWeight(.bold)
                                    .foregroundColor(theme.statusSuccess)
                            }
                        }
                        
                        BaseCardView(theme: theme) {
                            VStack(alignment: .leading, spacing: 4) {
                                Text("EXPIRING SOON")
                                    .font(.caption2)
                                    .fontWeight(.bold)
                                    .foregroundColor(theme.textSecondary)
                                Text("\(viewModel.expiringSoonCount)")
                                    .font(.title)
                                    .fontWeight(.bold)
                                    .foregroundColor(viewModel.expiringSoonCount > 0 ? theme.statusWarning : theme.primaryAccent)
                            }
                        }
                    }
                    
                    // Room Filter Pills (Spatial Navigation)
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 8) {
                            ForEach(viewModel.availableRooms, id: \.self) { room in
                                Button(action: { viewModel.selectedRoom = room }) {
                                    Text(room)
                                        .font(.subheadline)
                                        .fontWeight(.medium)
                                        .padding(.horizontal, 16)
                                        .padding(.vertical, 8)
                                        .background(viewModel.selectedRoom == room ? theme.primaryAccent : theme.cardBackground)
                                        .foregroundColor(viewModel.selectedRoom == room ? .white : theme.textPrimary)
                                        .clipShape(Capsule())
                                        .shadow(color: Color.black.opacity(0.03), radius: 4)
                                }
                                .accessibilityLabel("Filter by room: \(room)")
                            }
                        }
                    }
                    
                    // Appliances In Selected Room
                    if viewModel.filteredAppliances.isEmpty {
                        VStack(spacing: 12) {
                            Image(systemName: "house.and.flag")
                                .font(.system(size: 48))
                                .foregroundColor(theme.textSecondary.opacity(0.5))
                            Text("No appliances registered yet.")
                                .font(.headline)
                                .foregroundColor(theme.textSecondary)
                            Text("Tap '+' to scan an appliance rating badge or receipt.")
                                .font(.subheadline)
                                .foregroundColor(theme.textSecondary)
                                .multilineTextAlignment(.center)
                        }
                        .padding(.top, 40)
                    } else {
                        LazyVStack(spacing: 12) {
                            ForEach(viewModel.filteredAppliances) { appliance in
                                NavigationLink(destination: ApplianceDetailView(appliance: appliance)) {
                                    BaseCardView(theme: theme) {
                                        HStack {
                                            VStack(alignment: .leading, spacing: 4) {
                                                Text(appliance.brand)
                                                    .font(.caption)
                                                    .fontWeight(.semibold)
                                                    .foregroundColor(theme.textSecondary)
                                                Text(appliance.modelName)
                                                    .font(.headline)
                                                    .foregroundColor(theme.textPrimary)
                                                Text("Expires: \(RegionalFormatter.shared.formatDate(appliance.warrantyEndDate))")
                                                    .font(.caption)
                                                    .foregroundColor(appliance.isWarrantyActive ? theme.textSecondary : theme.statusCritical)
                                            }
                                            Spacer()
                                            
                                            MetricBadgeView(
                                                label: "Score",
                                                value: "\(appliance.latestHealthScore ?? 100)%",
                                                status: (appliance.latestHealthScore ?? 100) > 80 ? .success : .warning,
                                                theme: theme
                                            )
                                        }
                                    }
                                }
                                .buttonStyle(.plain)
                            }
                        }
                    }
                }
                .padding()
            }
            .background(theme.backgroundGrouped)
            .navigationTitle("Appliance Manager")
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button(action: { viewModel.showingAddScanner = true }) {
                        Image(systemName: "plus.circle.fill")
                            .font(.title3)
                            .foregroundColor(theme.primaryAccent)
                    }
                    .accessibilityLabel("Scan and add new appliance")
                }
            }
            .sheet(isPresented: $viewModel.showingAddScanner) {
                AddApplianceScannerView { brand, model, serial, room, price, currency in
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
            }
            .task {
                await viewModel.loadAppliances()
            }
        }
    }
}
