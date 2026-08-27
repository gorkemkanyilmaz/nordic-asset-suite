//
//  InteractiveDemoBar.swift
//  AssetCoreUIComponents
//
//  Created for Nordic Asset Suite.
//  Strict Concurrency: Complete. Quiet Contextual Sample Injector.
//

import SwiftUI
import AssetCoreLocalization

public struct InteractiveDemoBar: View {
    public let theme: any AppDesignTheme
    public let onOpenGuide: () -> Void
    public let onQuickDemoAdd: () -> Void
    private let lang = LanguageManager.shared
    
    public init(
        theme: any AppDesignTheme,
        onOpenGuide: @escaping () -> Void,
        onQuickDemoAdd: @escaping () -> Void
    ) {
        self.theme = theme
        self.onOpenGuide = onOpenGuide
        self.onQuickDemoAdd = onQuickDemoAdd
    }
    
    public var body: some View {
        HStack(spacing: 12) {
            VStack(alignment: .leading, spacing: 2) {
                Text(lang.t(.sampleDevicesAvailable))
                    .font(.caption)
                    .fontWeight(.semibold)
                    .foregroundColor(theme.textPrimary)
                Text(lang.t(.loadRealisticHardware))
                    .font(.caption2)
                    .foregroundColor(theme.textSecondary)
            }
            
            Spacer()
            
            Button(action: onOpenGuide) {
                Text(lang.t(.help))
                    .font(.caption2)
                    .fontWeight(.semibold)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 5)
                    .background(Color(.secondarySystemBackground))
                    .foregroundColor(theme.textPrimary)
                    .clipShape(RoundedRectangle(cornerRadius: 6))
            }
            
            Button(action: onQuickDemoAdd) {
                Text(lang.t(.loadSample))
                    .font(.caption2)
                    .fontWeight(.semibold)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 5)
                    .background(theme.primaryAccent)
                    .foregroundColor(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 6))
            }
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 10)
        .background(theme.cardBackground)
        .clipShape(RoundedRectangle(cornerRadius: theme.cornerRadiusCard))
        .overlay(
            RoundedRectangle(cornerRadius: theme.cornerRadiusCard)
                .stroke(theme.borderSubtle, lineWidth: 1)
        )
    }
}
