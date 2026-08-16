//
//  MetricBadgeView.swift
//  AssetCoreUIComponents
//
//  Created for Nordic Asset Suite.
//  Strict Concurrency: Complete. Dynamic Type Support.
//

import SwiftUI

/// Status severity for domain telemetry badges.
public enum MetricBadgeStatus: Sendable {
    case normal
    case success
    case warning
    case critical
}

/// Compact metric badge component for displaying health scores, DIN, PSI, hardness, etc.
public struct MetricBadgeView: View {
    private let label: String
    private let value: String
    private let status: MetricBadgeStatus
    private let theme: any AppDesignTheme
    
    public init(
        label: String,
        value: String,
        status: MetricBadgeStatus = .normal,
        theme: any AppDesignTheme
    ) {
        self.label = label
        self.value = value
        self.status = status
        self.theme = theme
    }
    
    private var badgeColor: Color {
        switch status {
        case .normal: return theme.primaryAccent
        case .success: return theme.statusSuccess
        case .warning: return theme.statusWarning
        case .critical: return theme.statusCritical
        }
    }
    
    public var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(label.uppercased())
                .font(.caption2)
                .fontWeight(.bold)
                .foregroundColor(theme.textSecondary)
                .tracking(0.5)
            
            Text(value)
                .font(.title3)
                .fontWeight(.bold)
                .foregroundColor(badgeColor)
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
        .background(badgeColor.opacity(0.1))
        .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
        .accessibilityElement(children: .combine)
        .accessibilityLabel("\(label): \(value)")
    }
}
