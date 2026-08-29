//
//  DesignThemeProtocol.swift
//  AssetCoreUIComponents
//
//  Created for Nordic Asset Suite.
//  Strict Concurrency: Complete. Semantic Design Tokens & Apple Review Guideline 4.3 Differentiation.
//

import SwiftUI
#if canImport(UIKit)
import UIKit
#elseif canImport(AppKit)
import AppKit
#endif

// MARK: - Adaptive Platform Colors
public extension Color {
    static var adaptiveSecondaryBackground: Color {
        Color(red: 26/255.0, green: 34/255.0, blue: 50/255.0)
    }
    
    static var adaptiveSystemBackground: Color {
        Color(red: 16/255.0, green: 22/255.0, blue: 34/255.0)
    }
    
    static var adaptiveGroupedBackground: Color {
        Color(red: 8/255.0, green: 12/255.0, blue: 20/255.0)
    }
}

/// Defines the mandatory semantic visual token contract for all 4 Nordic Asset Suite client apps.
public protocol AppDesignTheme: Sendable {
    // Primary Actions & Identity
    var primaryAccent: Color { get }
    var secondaryAccent: Color { get }
    
    // Surfaces & Backgrounds
    var backgroundGrouped: Color { get }
    var cardBackground: Color { get }
    var surfaceElevated: Color { get }
    
    // Typography
    var textPrimary: Color { get }
    var textSecondary: Color { get }
    var textMuted: Color { get }
    
    // Semantic States
    var statusSuccess: Color { get }
    var statusWarning: Color { get }
    var statusCritical: Color { get }
    
    // Borders & Separators
    var borderSubtle: Color { get }
    var borderDefault: Color { get }
    
    // Layout Geometry
    var cornerRadiusCard: CGFloat { get }
    var cornerRadiusButton: CGFloat { get }
    var standardPadding: CGFloat { get }
}

public extension AppDesignTheme {
    var surfaceElevated: Color { cardBackground }
    var textMuted: Color { textSecondary.opacity(0.7) }
    var borderSubtle: Color { Color.white.opacity(0.08) }
    var borderDefault: Color { Color.white.opacity(0.16) }
}

// MARK: - 1. Appliance Warranty Manager (Dark Obsidian Slate & Neon Cyan)
public struct ApplianceTheme: AppDesignTheme {
    public init() {}
    public let primaryAccent = Color(red: 56/255.0, green: 189/255.0, blue: 248/255.0) // Sky Neon Cyan (#38BDF8)
    public let secondaryAccent = Color(red: 2/255.0, green: 132/255.0, blue: 199/255.0) // Alpine Cobalt (#0284C7)
    public let backgroundGrouped = Color(red: 8/255.0, green: 12/255.0, blue: 20/255.0) // Obsidian Slate (#080C14)
    public let cardBackground = Color(red: 16/255.0, green: 22/255.0, blue: 34/255.0) // Dark Surface (#101622)
    public let surfaceElevated = Color(red: 26/255.0, green: 34/255.0, blue: 50/255.0) // Elevated (#1A2232)
    public let textPrimary = Color(red: 248/255.0, green: 250/255.0, blue: 252/255.0) // Crisp White (#F8FAFC)
    public let textSecondary = Color(red: 148/255.0, green: 163/255.0, blue: 184/255.0) // Silver Muted (#94A3B8)
    public let textMuted = Color(red: 100/255.0, green: 116/255.0, blue: 139/255.0) // Deep Muted (#64748B)
    public let statusSuccess = Color(red: 16/255.0, green: 185/255.0, blue: 129/255.0) // Emerald (#10B981)
    public let statusWarning = Color(red: 245/255.0, green: 158/255.0, blue: 11/255.0) // Amber (#F59E0B)
    public let statusCritical = Color(red: 239/255.0, green: 68/255.0, blue: 68/255.0) // Rose Red (#EF4444)
    public let borderSubtle = Color.white.opacity(0.08)
    public let borderDefault = Color.white.opacity(0.16)
    
    public let cornerRadiusCard: CGFloat = 16
    public let cornerRadiusButton: CGFloat = 12
    public let standardPadding: CGFloat = 16
}

// MARK: - 2. Ski Gear Tracker (Glacier Deep Navy & Alpine Orange)
public struct SkiGearTheme: AppDesignTheme {
    public init() {}
    public let primaryAccent = Color(red: 249/255.0, green: 115/255.0, blue: 22/255.0) // Alpine Orange (#F97316)
    public let secondaryAccent = Color(red: 56/255.0, green: 189/255.0, blue: 248/255.0) // Glacier Cyan (#38BDF8)
    public let backgroundGrouped = Color(red: 7/255.0, green: 12/255.0, blue: 20/255.0) // Glacier Deep Navy (#070C14)
    public let cardBackground = Color(red: 15/255.0, green: 24/255.0, blue: 38/255.0) // Glacier Surface (#0F1826)
    public let surfaceElevated = Color(red: 23/255.0, green: 36/255.0, blue: 56/255.0) // Elevated (#172438)
    public let textPrimary = Color(red: 248/255.0, green: 250/255.0, blue: 252/255.0) // Crisp White (#F8FAFC)
    public let textSecondary = Color(red: 148/255.0, green: 163/255.0, blue: 184/255.0) // Silver (#94A3B8)
    public let textMuted = Color(red: 100/255.0, green: 116/255.0, blue: 139/255.0) // Muted (#64748B)
    public let statusSuccess = Color(red: 16/255.0, green: 185/255.0, blue: 129/255.0)
    public let statusWarning = Color(red: 245/255.0, green: 158/255.0, blue: 11/255.0)
    public let statusCritical = Color(red: 239/255.0, green: 68/255.0, blue: 68/255.0)
    public let borderSubtle = Color.white.opacity(0.08)
    public let borderDefault = Color.white.opacity(0.16)
    
    public let cornerRadiusCard: CGFloat = 16
    public let cornerRadiusButton: CGFloat = 12
    public let standardPadding: CGFloat = 16
}

// MARK: - 3. E-Bike Service Tracker (Carbon Graphite & Electric Teal)
public struct EBikeTheme: AppDesignTheme {
    public init() {}
    public let primaryAccent = Color(red: 20/255.0, green: 184/255.0, blue: 166/255.0) // Electric Teal (#14B8A6)
    public let secondaryAccent = Color(red: 13/255.0, green: 148/255.0, blue: 136/255.0) // Dark Teal (#0D9488)
    public let backgroundGrouped = Color(red: 9/255.0, green: 12/255.0, blue: 14/255.0) // Carbon Black (#090C0E)
    public let cardBackground = Color(red: 18/255.0, green: 24/255.0, blue: 28/255.0) // Graphite Surface (#12181C)
    public let surfaceElevated = Color(red: 26/255.0, green: 34/255.0, blue: 40/255.0) // Elevated (#1A2228)
    public let textPrimary = Color(red: 248/255.0, green: 250/255.0, blue: 252/255.0)
    public let textSecondary = Color(red: 148/255.0, green: 163/255.0, blue: 184/255.0)
    public let textMuted = Color(red: 100/255.0, green: 116/255.0, blue: 139/255.0)
    public let statusSuccess = Color(red: 16/255.0, green: 185/255.0, blue: 129/255.0)
    public let statusWarning = Color(red: 245/255.0, green: 158/255.0, blue: 11/255.0)
    public let statusCritical = Color(red: 239/255.0, green: 68/255.0, blue: 68/255.0)
    public let borderSubtle = Color.white.opacity(0.08)
    public let borderDefault = Color.white.opacity(0.16)
    
    public let cornerRadiusCard: CGFloat = 16
    public let cornerRadiusButton: CGFloat = 12
    public let standardPadding: CGFloat = 16
}

// MARK: - 4. Coffee Machine Companion (Dark Roast Charcoal & Golden Crema)
public struct CoffeeTheme: AppDesignTheme {
    public init() {}
    public let primaryAccent = Color(red: 217/255.0, green: 119/255.0, blue: 6/255.0) // Amber Bronze (#D97706)
    public let secondaryAccent = Color(red: 245/255.0, green: 158/255.0, blue: 11/255.0) // Golden Crema (#F59E0B)
    public let backgroundGrouped = Color(red: 18/255.0, green: 13/255.0, blue: 9/255.0) // Dark Roast Charcoal (#120D09)
    public let cardBackground = Color(red: 26/255.0, green: 19/255.0, blue: 14/255.0) // Roast Surface (#1A130E)
    public let surfaceElevated = Color(red: 40/255.0, green: 29/255.0, blue: 22/255.0) // Elevated (#281D16)
    public let textPrimary = Color(red: 248/255.0, green: 250/255.0, blue: 252/255.0) // Clean White (#F8FAFC)
    public let textSecondary = Color(red: 214/255.0, green: 194/255.0, blue: 180/255.0) // Warm Crema Silver (#D6C2B4)
    public let textMuted = Color(red: 140/255.0, green: 119/255.0, blue: 104/255.0) // Warm Muted (#8C7768)
    public let statusSuccess = Color(red: 16/255.0, green: 185/255.0, blue: 129/255.0)
    public let statusWarning = Color(red: 245/255.0, green: 158/255.0, blue: 11/255.0)
    public let statusCritical = Color(red: 239/255.0, green: 68/255.0, blue: 68/255.0)
    public let borderSubtle = Color.white.opacity(0.08)
    public let borderDefault = Color.white.opacity(0.16)
    
    public let cornerRadiusCard: CGFloat = 16
    public let cornerRadiusButton: CGFloat = 12
    public let standardPadding: CGFloat = 16
}
