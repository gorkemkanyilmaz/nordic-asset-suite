//
//  LanguageManager.swift
//  AssetCoreLocalization
//
//  Created for Nordic Asset Suite.
//  Strict Concurrency: Complete. Auto-detects device locale and persists language selection.
//

import Foundation
import Observation

/// Represents a selectable currency option matching the web demo standards.
public struct CurrencyOption: Identifiable, Sendable, Hashable {
    public let code: String
    public let symbol: String
    public let label: String
    public var id: String { code }
    
    public init(code: String, symbol: String, label: String) {
        self.code = code
        self.symbol = symbol
        self.label = label
    }
}

/// Represents a statutory warranty policy duration option matching the web demo.
public struct StatutoryWarrantyOption: Identifiable, Sendable, Hashable {
    public let months: Int
    public let label: String
    public var id: Int { months }
    
    public init(months: Int, label: String) {
        self.months = months
        self.label = label
    }
}

/// Manages the active language, currency, and regional statutory policy across the app.
/// Auto-detects from device locale on first launch, persists selection in UserDefaults.
@Observable
@MainActor
public final class LanguageManager: Sendable {
    public static let shared = LanguageManager()
    
    public static let supportedCurrencies: [CurrencyOption] = [
        CurrencyOption(code: "CHF", symbol: "CHF", label: "CHF (Swiss Franc)"),
        CurrencyOption(code: "EUR", symbol: "€", label: "EUR (Euro - €)"),
        CurrencyOption(code: "USD", symbol: "$", label: "USD (US Dollar - $)"),
        CurrencyOption(code: "TRY", symbol: "₺", label: "TRY (Turkish Lira - ₺)"),
        CurrencyOption(code: "GBP", symbol: "£", label: "GBP (British Pound - £)"),
        CurrencyOption(code: "SEK", symbol: "kr", label: "SEK (Swedish Krona - kr)"),
        CurrencyOption(code: "NOK", symbol: "kr", label: "NOK (Norwegian Krone - kr)"),
        CurrencyOption(code: "DKK", symbol: "kr.", label: "DKK (Dansk Krone - kr.)")
    ]
    
    public static let supportedStatutoryWarranties: [StatutoryWarrantyOption] = [
        StatutoryWarrantyOption(months: 12, label: "12 Months (1 Year Standard)"),
        StatutoryWarrantyOption(months: 24, label: "24 Months (Swiss CO / EU Standard)"),
        StatutoryWarrantyOption(months: 36, label: "36 Months (3 Years Extended)"),
        StatutoryWarrantyOption(months: 60, label: "60 Months (5 Years Long-term)")
    ]
    
    private let languageKey = "nordic_app_language"
    private let currencyKey = "nordic_app_currency"
    private let customCurrencyKey = "nordic_currency_custom"
    private let statutoryWarrantyKey = "nordic_statutory_warranty"
    private let hasSetLanguageKey = "nordic_has_set_initial_language"
    
    public var currentLanguage: LanguageCode {
        didSet {
            UserDefaults.standard.set(currentLanguage.rawValue, forKey: languageKey)
        }
    }
    
    public var currentCurrencyCode: String {
        didSet {
            UserDefaults.standard.set(currentCurrencyCode, forKey: currencyKey)
        }
    }
    
    public var statutoryWarrantyMonths: Int {
        didSet {
            UserDefaults.standard.set(statutoryWarrantyMonths, forKey: statutoryWarrantyKey)
        }
    }
    
    private init() {
        let resolvedLanguage: LanguageCode
        if let savedLang = UserDefaults.standard.string(forKey: languageKey),
           let lang = LanguageCode(rawValue: savedLang) {
            resolvedLanguage = lang
        } else {
            resolvedLanguage = LanguageManager.detectDeviceLanguage()
        }
        self.currentLanguage = resolvedLanguage
        
        if let savedCurrency = UserDefaults.standard.string(forKey: currencyKey) {
            self.currentCurrencyCode = savedCurrency
        } else {
            self.currentCurrencyCode = resolvedLanguage.defaultCurrencyCode
        }
        
        let savedMonths = UserDefaults.standard.integer(forKey: statutoryWarrantyKey)
        self.statutoryWarrantyMonths = savedMonths > 0 ? savedMonths : 24
    }
    
    /// Detects the best matching language from device locale preferences.
    public static func detectDeviceLanguage() -> LanguageCode {
        let preferred = Locale.preferredLanguages
        for langID in preferred {
            let prefix = String(langID.prefix(2)).lowercased()
            if let match = LanguageCode(rawValue: prefix) {
                return match
            }
        }
        return .english
    }
    
    /// Call on first launch to set language & currency from device locale.
    public func applyDeviceDefaultsIfNeeded() {
        guard !UserDefaults.standard.bool(forKey: hasSetLanguageKey) else { return }
        let detected = LanguageManager.detectDeviceLanguage()
        self.currentLanguage = detected
        self.currentCurrencyCode = detected.defaultCurrencyCode
        UserDefaults.standard.set(true, forKey: hasSetLanguageKey)
    }
    
    /// Changes the active language. Only changes currency if user hasn't explicitly picked a custom currency.
    public func setLanguage(_ lang: LanguageCode, forceUpdateCurrency: Bool = false) {
        self.currentLanguage = lang
        let hasCustomCurrency = UserDefaults.standard.bool(forKey: customCurrencyKey)
        if !hasCustomCurrency || forceUpdateCurrency {
            self.currentCurrencyCode = lang.defaultCurrencyCode
        }
    }
    
    /// Explicitly changes the active currency format (independently of language).
    public func setCurrency(_ code: String) {
        self.currentCurrencyCode = code
        UserDefaults.standard.set(true, forKey: customCurrencyKey)
    }
    
    /// Changes the default statutory warranty duration for new appliances.
    public func setStatutoryWarrantyMonths(_ months: Int) {
        self.statutoryWarrantyMonths = months
    }
    
    /// Returns the current Locale for formatters.
    public var currentLocale: Locale {
        Locale(identifier: currentLanguage.localeIdentifier)
    }
    
    /// Quick accessor for the localization dictionary with current language.
    public func t(_ key: LocalizableKey) -> String {
        LocalizationDictionary.shared.localizedString(for: key, language: currentLanguage)
    }
    
    /// Quick accessor with string interpolation.
    public func t(_ key: LocalizableKey, _ args: CVarArg...) -> String {
        let base = LocalizationDictionary.shared.localizedString(for: key, language: currentLanguage)
        if args.isEmpty { return base }
        return String(format: base, arguments: args)
    }
}
