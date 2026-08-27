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
        #if canImport(UIKit)
        Color(uiColor: .secondarySystemBackground)
        #elseif canImport(AppKit)
        Color(nsColor: .underPageBackgroundColor)
        #else
        Color.gray.opacity(0.12)
        #endif
    }
    
    static var adaptiveSystemBackground: Color {
        #if canImport(UIKit)
        Color(uiColor: .systemBackground)
        #elseif canImport(AppKit)
        Color(nsColor: .windowBackgroundColor)
        #else
        Color.white
        #endif
    }
    
    static var adaptiveGroupedBackground: Color {
        #if canImport(UIKit)
        Color(uiColor: .systemGroupedBackground)
        #elseif canImport(AppKit)
        Color(nsColor: .windowBackgroundColor)
        #else
        Color.gray.opacity(0.06)
        #endif
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
    var borderSubtle: Color { Color.black.opacity(0.06) }
    var borderDefault: Color { Color.black.opacity(0.12) }
}

// MARK: - 1. Appliance Warranty Manager (Clean Swiss Minimalist Slate)
public struct ApplianceTheme: AppDesignTheme {
    public init() {}
    public let primaryAccent = Color(red: 0.15, green: 0.22, blue: 0.32) // Swiss Slate
    public let secondaryAccent = Color(red: 0.25, green: 0.45, blue: 0.70) // Alpine Cobalt
    public let backgroundGrouped = Color(red: 0.96, green: 0.97, blue: 0.98)
    public let cardBackground = Color.white
    public let surfaceElevated = Color(red: 0.98, green: 0.99, blue: 1.0)
    public let textPrimary = Color(red: 0.08, green: 0.12, blue: 0.17)
    public let textSecondary = Color(red: 0.40, green: 0.46, blue: 0.54)
    public let textMuted = Color(red: 0.60, green: 0.65, blue: 0.72)
    public let statusSuccess = Color(red: 0.12, green: 0.68, blue: 0.38)
    public let statusWarning = Color(red: 0.92, green: 0.55, blue: 0.05)
    public let statusCritical = Color(red: 0.88, green: 0.25, blue: 0.20)
    public let borderSubtle = Color(red: 0.90, green: 0.92, blue: 0.94)
    public let borderDefault = Color(red: 0.82, green: 0.85, blue: 0.88)
    
    public let cornerRadiusCard: CGFloat = 14
    public let cornerRadiusButton: CGFloat = 10
    public let standardPadding: CGFloat = 16
}

// MARK: - 2. Ski Gear Tracker (High-Vis Alpine Navy & Orange)
public struct SkiGearTheme: AppDesignTheme {
    public init() {}
    public let primaryAccent = Color(red: 0.06, green: 0.18, blue: 0.30) // Deep Glacier Navy
    public let secondaryAccent = Color(red: 0.96, green: 0.45, blue: 0.10) // Alpine High-Vis Orange
    public let backgroundGrouped = Color(red: 0.94, green: 0.96, blue: 0.98)
    public let cardBackground = Color.white
    public let surfaceElevated = Color(red: 0.97, green: 0.98, blue: 1.0)
    public let textPrimary = Color(red: 0.05, green: 0.10, blue: 0.16)
    public let textSecondary = Color(red: 0.35, green: 0.44, blue: 0.52)
    public let textMuted = Color(red: 0.55, green: 0.62, blue: 0.70)
    public let statusSuccess = Color(red: 0.10, green: 0.65, blue: 0.50)
    public let statusWarning = Color(red: 0.95, green: 0.55, blue: 0.10)
    public let statusCritical = Color(red: 0.85, green: 0.20, blue: 0.25)
    public let borderSubtle = Color(red: 0.88, green: 0.91, blue: 0.95)
    public let borderDefault = Color(red: 0.80, green: 0.84, blue: 0.90)
    
    public let cornerRadiusCard: CGFloat = 12
    public let cornerRadiusButton: CGFloat = 8
    public let standardPadding: CGFloat = 16
}

// MARK: - 3. E-Bike Service Tracker (Industrial Graphite & Electric Teal)
public struct EBikeTheme: AppDesignTheme {
    public init() {}
    public let primaryAccent = Color(red: 0.10, green: 0.12, blue: 0.15) // Stealth Graphite
    public let secondaryAccent = Color(red: 0.08, green: 0.65, blue: 0.60) // Electric Teal
    public let backgroundGrouped = Color(red: 0.93, green: 0.95, blue: 0.96)
    public let cardBackground = Color.white
    public let surfaceElevated = Color(red: 0.97, green: 0.98, blue: 0.99)
    public let textPrimary = Color(red: 0.08, green: 0.10, blue: 0.12)
    public let textSecondary = Color(red: 0.38, green: 0.44, blue: 0.48)
    public let textMuted = Color(red: 0.58, green: 0.64, blue: 0.68)
    public let statusSuccess = Color(red: 0.12, green: 0.68, blue: 0.40)
    public let statusWarning = Color(red: 0.94, green: 0.60, blue: 0.12)
    public let statusCritical = Color(red: 0.90, green: 0.22, blue: 0.18)
    public let borderSubtle = Color(red: 0.88, green: 0.90, blue: 0.92)
    public let borderDefault = Color(red: 0.80, green: 0.83, blue: 0.86)
    
    public let cornerRadiusCard: CGFloat = 12
    public let cornerRadiusButton: CGFloat = 8
    public let standardPadding: CGFloat = 16
}

// MARK: - 4. Coffee Machine Companion (Specialty Espresso Bronze & Crema Amber)
public struct CoffeeTheme: AppDesignTheme {
    public init() {}
    public let primaryAccent = Color(red: 0.24, green: 0.15, blue: 0.08) // Roast Espresso
    public let secondaryAccent = Color(red: 0.75, green: 0.48, blue: 0.22) // Crema Amber
    public let backgroundGrouped = Color(red: 0.97, green: 0.95, blue: 0.92)
    public let cardBackground = Color.white
    public let surfaceElevated = Color(red: 0.99, green: 0.98, blue: 0.96)
    public let textPrimary = Color(red: 0.16, green: 0.10, blue: 0.06)
    public let textSecondary = Color(red: 0.48, green: 0.40, blue: 0.34)
    public let textMuted = Color(red: 0.68, green: 0.60, blue: 0.54)
    public let statusSuccess = Color(red: 0.24, green: 0.58, blue: 0.35)
    public let statusWarning = Color(red: 0.85, green: 0.50, blue: 0.12)
    public let statusCritical = Color(red: 0.78, green: 0.22, blue: 0.18)
    public let borderSubtle = Color(red: 0.91, green: 0.88, blue: 0.84)
    public let borderDefault = Color(red: 0.84, green: 0.80, blue: 0.75)
    
    public let cornerRadiusCard: CGFloat = 16
    public let cornerRadiusButton: CGFloat = 12
    public let standardPadding: CGFloat = 18
}
