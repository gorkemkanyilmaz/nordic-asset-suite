//
//  BaseCardView.swift
//  AssetCoreUIComponents
//
//  Created for Nordic Asset Suite.
//  Strict Concurrency: Complete. Dynamic Type & VoiceOver Accessible.
//

import SwiftUI

/// Standardized accessible card container adapting to the active theme.
public struct BaseCardView<Content: View>: View {
    private let theme: any AppDesignTheme
    private let content: Content
    
    public init(theme: any AppDesignTheme, @ViewBuilder content: () -> Content) {
        self.theme = theme
        self.content = content()
    }
    
    public var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            content
        }
        .padding(theme.standardPadding)
        .background(theme.cardBackground)
        .clipShape(RoundedRectangle(cornerRadius: theme.cornerRadiusCard, style: .continuous))
        .shadow(color: Color.black.opacity(0.04), radius: 8, x: 0, y: 3)
        .overlay(
            RoundedRectangle(cornerRadius: theme.cornerRadiusCard, style: .continuous)
                .stroke(Color.black.opacity(0.04), lineWidth: 1)
        )
    }
}
