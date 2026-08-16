//
//  LanguageCode.swift
//  AssetCoreLocalization
//
//  Created for Nordic Asset Suite.
//  Strict Concurrency: Complete. Target Markets: CH, DK, AT, NO, SE.
//

import Foundation

/// Supported target languages across the DACH and Nordic markets.
public enum LanguageCode: String, CaseIterable, Sendable, Codable {
    case english = "en"
    case german = "de"
    case french = "fr"
    case italian = "it"
    case danish = "da"
    case swedish = "sv"
    case norwegian = "nb"
    
    public var localeIdentifier: String {
        switch self {
        case .english: return "en_US"
        case .german: return "de_CH" // Default to Swiss German for DACH prioritization
        case .french: return "fr_CH"
        case .italian: return "it_CH"
        case .danish: return "da_DK"
        case .swedish: return "sv_SE"
        case .norwegian: return "nb_NO"
        }
    }
    
    public var nativeDisplayName: String {
        switch self {
        case .english: return "English"
        case .german: return "Deutsch"
        case .french: return "Français"
        case .italian: return "Italiano"
        case .danish: return "Dansk"
        case .swedish: return "Svenska"
        case .norwegian: return "Norsk"
        }
    }
    
    /// Default primary currency code associated with the market.
    public var defaultCurrencyCode: String {
        switch self {
        case .english: return "USD"
        case .german: return "CHF"
        case .french: return "CHF"
        case .italian: return "CHF"
        case .danish: return "DKK"
        case .swedish: return "SEK"
        case .norwegian: return "NOK"
        }
    }
}
