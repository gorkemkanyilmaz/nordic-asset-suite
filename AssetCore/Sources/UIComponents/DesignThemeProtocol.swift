//
//  DesignThemeProtocol.swift
//  AssetCoreUIComponents
//
//  Created for Nordic Asset Suite.
//  Strict Concurrency: Complete. Apple HIG & Guideline 4.3 Compliant.
//

import SwiftUI

/// Defines the mandatory visual token contract that every client app must implement uniquely.
public protocol AppDesignTheme: Sendable {
    var primaryAccent: Color { get }
    var secondaryAccent: Color { get }
    var backgroundGrouped: Color { get }
    var cardBackground: Color { get }
    var textPrimary: Color { get }
    var textSecondary: Color { get }
    var statusSuccess: Color { get }
    var statusWarning: Color { get }
    var statusCritical: Color { get }
    
    var cornerRadiusCard: CGFloat { get }
    var cornerRadiusButton: CGFloat { get }
    var standardPadding: CGFloat { get }
}

/// Appliance Warranty Manager: Clean, Modern, Warm Minimalist
public struct ApplianceTheme: AppDesignTheme {
    public init() {}
    public let primaryAccent = Color(red: 0.17, green: 0.24, blue: 0.31) // Slate Blue
    public let secondaryAccent = Color(red: 0.93, green: 0.94, blue: 0.95)
    public let backgroundGrouped = Color(red: 0.97, green: 0.98, blue: 0.99)
    public let cardBackground = Color.white
    public let textPrimary = Color(red: 0.11, green: 0.15, blue: 0.19)
    public let textSecondary = Color(red: 0.45, green: 0.50, blue: 0.55)
    public let statusSuccess = Color(red: 0.18, green: 0.80, blue: 0.44)
    public let statusWarning = Color(red: 0.95, green: 0.61, blue: 0.07)
    public let statusCritical = Color(red: 0.91, green: 0.30, blue: 0.24)
    
    public let cornerRadiusCard: CGFloat = 16
    public let cornerRadiusButton: CGFloat = 12
    public let standardPadding: CGFloat = 16
}

/// Ski Gear Tracker: High-Visibility Alpine, Technical Contrast
public struct SkiGearTheme: AppDesignTheme {
    public init() {}
    public let primaryAccent = Color(red: 0.04, green: 0.24, blue: 0.38) // Glacier Navy
    public let secondaryAccent = Color(red: 0.98, green: 0.60, blue: 0.23) // High-Vis Alpine Orange
    public let backgroundGrouped = Color(red: 0.94, green: 0.96, blue: 0.98)
    public let cardBackground = Color.white
    public let textPrimary = Color(red: 0.05, green: 0.12, blue: 0.18)
    public let textSecondary = Color(red: 0.38, green: 0.48, blue: 0.56)
    public let statusSuccess = Color(red: 0.10, green: 0.74, blue: 0.61)
    public let statusWarning = Color(red: 0.95, green: 0.61, blue: 0.07)
    public let statusCritical = Color(red: 0.86, green: 0.21, blue: 0.27)
    
    public let cornerRadiusCard: CGFloat = 12 // Sharper, technical edges
    public let cornerRadiusButton: CGFloat = 10
    public let standardPadding: CGFloat = 16
}

/// E-Bike Service Tracker: Industrial Stealth, Electric Telemetry
public struct EBikeTheme: AppDesignTheme {
    public init() {}
    public let primaryAccent = Color(red: 0.12, green: 0.15, blue: 0.17) // Stealth Graphite
    public let secondaryAccent = Color(red: 0.00, green: 0.82, blue: 0.83) // Electric Cyan
    public let backgroundGrouped = Color(red: 0.93, green: 0.94, blue: 0.96)
    public let cardBackground = Color.white
    public let textPrimary = Color(red: 0.08, green: 0.10, blue: 0.12)
    public let textSecondary = Color(red: 0.40, green: 0.45, blue: 0.50)
    public let statusSuccess = Color(red: 0.13, green: 0.75, blue: 0.42)
    public let statusWarning = Color(red: 0.96, green: 0.65, blue: 0.14)
    public let statusCritical = Color(red: 0.92, green: 0.26, blue: 0.21)
    
    public let cornerRadiusCard: CGFloat = 14
    public let cornerRadiusButton: CGFloat = 8
    public let standardPadding: CGFloat = 16
}

/// Coffee Machine Companion: Rich Espresso Bronze, Warm Specialty Cafe
public struct CoffeeTheme: AppDesignTheme {
    public init() {}
    public let primaryAccent = Color(red: 0.29, green: 0.18, blue: 0.09) // Roast Espresso
    public let secondaryAccent = Color(red: 0.78, green: 0.56, blue: 0.36) // Crema Amber
    public let backgroundGrouped = Color(red: 0.96, green: 0.94, blue: 0.91)
    public let cardBackground = Color.white
    public let textPrimary = Color(red: 0.18, green: 0.12, blue: 0.08)
    public let textSecondary = Color(red: 0.52, green: 0.44, blue: 0.38)
    public let statusSuccess = Color(red: 0.27, green: 0.62, blue: 0.39)
    public let statusWarning = Color(red: 0.88, green: 0.53, blue: 0.15)
    public let statusCritical = Color(red: 0.80, green: 0.24, blue: 0.20)
    
    public let cornerRadiusCard: CGFloat = 20 // Soft, organic cafe feel
    public let cornerRadiusButton: CGFloat = 16
    public let standardPadding: CGFloat = 18
}
