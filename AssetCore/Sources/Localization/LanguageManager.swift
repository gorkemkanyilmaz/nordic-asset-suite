//
//  LanguageManager.swift
//  AssetCoreLocalization
//
//  Created for Nordic Asset Suite.
//  Strict Concurrency: Complete. Auto-detects device locale and persists language selection.
//

import Foundation
import Observation

/// Manages the active language and currency across the app.
/// Auto-detects from device locale on first launch, persists selection in UserDefaults.
@Observable
@MainActor
public final class LanguageManager: Sendable {
    public static let shared = LanguageManager()
    
    private let languageKey = "nordic_app_language"
    private let currencyKey = "nordic_app_currency"
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
    
    /// Changes the active language and updates currency to its default.
    public func setLanguage(_ lang: LanguageCode) {
        self.currentLanguage = lang
        self.currentCurrencyCode = lang.defaultCurrencyCode
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
