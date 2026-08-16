//
//  RegionalFormatter.swift
//  AssetCoreLocalization
//
//  Created for Nordic Asset Suite.
//  Strict Concurrency: Complete.
//

import Foundation

/// Thread-safe regional data, unit, and currency formatting engine.
public final class RegionalFormatter: Sendable {
    public static let shared = RegionalFormatter()
    
    private init() {}
    
    /// Formats monetary amounts with ISO currency codes (e.g. CHF 120.50, 1.250,00 kr).
    public func formatCurrency(amount: Decimal, currencyCode: String, locale: Locale = .current) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = currencyCode
        formatter.locale = locale
        return formatter.string(from: amount as NSDecimalNumber) ?? "\(currencyCode) \(amount)"
    }
    
    /// Formats standardized ISO/localized warranty expiration dates.
    public func formatDate(_ date: Date, style: DateFormatter.Style = .medium, locale: Locale = .current) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = style
        formatter.timeStyle = .none
        formatter.locale = locale
        return formatter.string(from: date)
    }
    
    /// Formats relative time until warranty or service expiry (e.g. "in 3 months", "expired 12 days ago").
    public func formatRelativeTime(to targetDate: Date, from currentDate: Date = Date(), locale: Locale = .current) -> String {
        let formatter = RelativeDateTimeFormatter()
        formatter.locale = locale
        formatter.unitsStyle = .full
        return formatter.localizedString(for: targetDate, relativeTo: currentDate)
    }
    
    /// Formats mileage / distance in kilometers or miles.
    public func formatDistance(kilometers: Double, locale: Locale = .current) -> String {
        let measurement = Measurement(value: kilometers, unit: UnitLength.kilometers)
        let formatter = MeasurementFormatter()
        formatter.locale = locale
        formatter.unitOptions = .naturalScale
        formatter.numberFormatter.maximumFractionDigits = 1
        return formatter.string(from: measurement)
    }
    
    /// Formats suspension or tire pressure in PSI and Bar.
    public func formatPressure(psi: Double, locale: Locale = .current) -> String {
        let formatter = NumberFormatter()
        formatter.locale = locale
        formatter.maximumFractionDigits = 1
        let psiString = formatter.string(from: NSNumber(value: psi)) ?? "\(psi)"
        let barValue = psi * 0.0689476
        let barString = formatter.string(from: NSNumber(value: barValue)) ?? "\(barValue)"
        return "\(psiString) PSI (\(barString) bar)"
    }
    
    /// Formats German water hardness (°dH) and French degrees (°fH).
    public func formatWaterHardness(germanDegrees dH: Double) -> String {
        let frenchDegrees = dH * 1.78
        return String(format: "%.1f °dH (%.1f °fH)", dH, frenchDegrees)
    }
}
