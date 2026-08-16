//
//  PrimaryButton.swift
//  AssetCoreUIComponents
//
//  Created for Nordic Asset Suite.
//  Strict Concurrency: Complete. Haptic Feedback & Accessible.
//

import SwiftUI

/// Standardized high-contrast accessible button with haptic feedback.
public struct PrimaryButton: View {
    private let title: String
    private let icon: String?
    private let theme: any AppDesignTheme
    private let action: () -> Void
    
    public init(
        title: String,
        icon: String? = nil,
        theme: any AppDesignTheme,
        action: @escaping () -> Void
    ) {
        self.title = title
        self.icon = icon
        self.theme = theme
        self.action = action
    }
    
    public var body: some View {
        Button(action: {
            #if os(iOS)
            UIImpactFeedbackGenerator(style: .medium).impactOccurred()
            #endif
            action()
        }) {
            HStack(spacing: 8) {
                if let icon = icon {
                    Image(systemName: icon)
                        .font(.headline)
                }
                Text(title)
                    .font(.headline)
                    .fontWeight(.semibold)
            }
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 14)
            .background(theme.primaryAccent)
            .clipShape(RoundedRectangle(cornerRadius: theme.cornerRadiusButton, style: .continuous))
        }
        .buttonStyle(.plain)
        .accessibilityLabel(title)
    }
}
