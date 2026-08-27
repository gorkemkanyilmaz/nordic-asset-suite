//
//  SparePartsWearView.swift
//  AssetCoreUIComponents
//
//  Created for Nordic Asset Suite.
//  Strict Concurrency: Complete. Spare Parts & Wear Schedule Progress Tracker.
//

import SwiftUI
import AssetCoreAI
import AssetCoreLocalization

public struct SparePartsWearView: View {
    public let schedule: SparePartsScheduleData
    public let theme: any AppDesignTheme
    public let onLogPartReplaced: (SparePartItem) -> Void
    private let lang = LanguageManager.shared
    
    @State private var replacedPartIds: Set<String> = []
    
    public init(
        schedule: SparePartsScheduleData,
        theme: any AppDesignTheme,
        onLogPartReplaced: @escaping (SparePartItem) -> Void
    ) {
        self.schedule = schedule
        self.theme = theme
        self.onLogPartReplaced = onLogPartReplaced
    }
    
    public var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            // Header
            HStack {
                Label(lang.t(.sparePartsWearSchedule), systemImage: "gearshape.2.fill")
                    .font(.headline)
                    .foregroundColor(theme.primaryAccent)
                Spacer()
                Text(String(format: lang.t(.trackedParts), schedule.parts.count))
                    .font(.caption2)
                    .fontWeight(.bold)
                    .foregroundColor(theme.textSecondary)
            }
            
            VStack(spacing: 12) {
                ForEach(schedule.parts) { part in
                    let isReplaced = replacedPartIds.contains(part.id)
                    let effectiveWear: Double = isReplaced ? 5.0 : min(100.0, max(15.0, part.wearDegradationRateMonthly * 7.5))
                    
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            VStack(alignment: .leading, spacing: 2) {
                                Text(part.name)
                                    .font(.subheadline)
                                    .fontWeight(.bold)
                                    .foregroundColor(theme.textPrimary)
                                
                                if !part.partNumber.isEmpty {
                                    Text("P/N: \(part.partNumber) • Category: \(part.category)")
                                        .font(.caption2)
                                        .foregroundColor(theme.textSecondary)
                                }
                            }
                            
                            Spacer()
                            
                            VStack(alignment: .trailing, spacing: 2) {
                                Text(wearStatusText(wear: effectiveWear))
                                    .font(.caption2)
                                    .fontWeight(.bold)
                                    .foregroundColor(wearStatusColor(wear: effectiveWear))
                                
                                Text(String(format: lang.t(.estimatedCost), "\(part.estimatedCostCHF)"))
                                    .font(.caption2)
                                    .foregroundColor(theme.textSecondary)
                            }
                        }
                        
                        // Wear Bar
                        GeometryReader { proxy in
                            ZStack(alignment: .leading) {
                                RoundedRectangle(cornerRadius: 6)
                                    .fill(Color.gray.opacity(0.15))
                                    .frame(height: 8)
                                
                                RoundedRectangle(cornerRadius: 6)
                                    .fill(wearStatusColor(wear: effectiveWear))
                                    .frame(width: max(10, proxy.size.width * CGFloat(effectiveWear / 100.0)), height: 8)
                            }
                        }
                        .frame(height: 8)
                        
                        // Action Bar
                        HStack {
                            Text(String(format: lang.t(.intervalDays), part.replacementIntervalDays))
                                .font(.caption2)
                                .foregroundColor(theme.textSecondary)
                            
                            Spacer()
                            
                            if isReplaced {
                                Label(lang.t(.replacedToday), systemImage: "checkmark.circle.fill")
                                    .font(.caption2)
                                    .fontWeight(.semibold)
                                    .foregroundColor(theme.statusSuccess)
                            } else {
                                Button(action: {
                                    replacedPartIds.insert(part.id)
                                    onLogPartReplaced(part)
                                }) {
                                    Text(lang.t(.logReplacement))
                                        .font(.caption2)
                                        .fontWeight(.bold)
                                        .padding(.horizontal, 10)
                                        .padding(.vertical, 4)
                                        .background(theme.primaryAccent.opacity(0.1))
                                        .foregroundColor(theme.primaryAccent)
                                        .clipShape(Capsule())
                                }
                            }
                        }
                    }
                    .padding(12)
                    .background(Color(.secondarySystemBackground))
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                }
            }
        }
        .padding()
        .background(theme.cardBackground)
        .clipShape(RoundedRectangle(cornerRadius: theme.cornerRadiusCard))
        .shadow(color: Color.black.opacity(0.04), radius: 6, y: 3)
    }
    
    private func wearStatusText(wear: Double) -> String {
        if wear < 50 { return String(format: lang.t(.goodCondition), Int(wear)) }
        if wear < 85 { return String(format: lang.t(.serviceSoon), Int(wear)) }
        return String(format: lang.t(.overdue), Int(wear))
    }
    
    private func wearStatusColor(wear: Double) -> Color {
        if wear < 50 { return theme.statusSuccess }
        if wear < 85 { return theme.statusWarning }
        return theme.statusCritical
    }
}
