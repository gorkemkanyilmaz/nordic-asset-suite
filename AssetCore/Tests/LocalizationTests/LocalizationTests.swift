//
//  LocalizationTests.swift
//  AssetCoreLocalizationTests
//
//  Created for Nordic Asset Suite.
//  Strict Concurrency: Complete. Complete 7-Language & Regional Formatter Test Suite.
//

import XCTest
@testable import AssetCoreLocalization

final class LocalizationTests: XCTestCase {
    
    // MARK: - Test 1: Translation Dictionary Completeness Across 7 Languages
    func testTranslationCompleteness() {
        let allLanguages = LanguageCode.allCases
        let allKeys = LocalizableKey.allCases
        
        for language in allLanguages {
            for key in allKeys {
                let localized = LocalizationDictionary.shared.localizedString(for: key, language: language)
                XCTAssertFalse(localized.isEmpty, "Missing translation for key '\(key.rawValue)' in language '\(language.rawValue)'")
                XCTAssertNotEqual(localized, key.rawValue, "Translation should not fallback to raw key for '\(key.rawValue)' in '\(language.rawValue)'")
            }
        }
    }
    
    // MARK: - Test 2: Swiss Market Currency & Date Formatting
    func testSwissFormatting() {
        let swissLocale = Locale(identifier: "de_CH")
        let formattedCurrency = RegionalFormatter.shared.formatCurrency(
            amount: 1250.50,
            currencyCode: "CHF",
            locale: swissLocale
        )
        
        XCTAssertTrue(formattedCurrency.contains("CHF") || formattedCurrency.contains("1’250") || formattedCurrency.contains("1'250") || formattedCurrency.contains("1.250"))
        
        let testDate = Date(timeIntervalSince1970: 1768819200) // Jan 19, 2026
        let formattedDate = RegionalFormatter.shared.formatDate(testDate, locale: swissLocale)
        XCTAssertFalse(formattedDate.isEmpty)
    }
    
    // MARK: - Test 3: Nordic Markets Currency Formats (DKK, NOK, SEK)
    func testNordicCurrencyFormatting() {
        let dkkFormatted = RegionalFormatter.shared.formatCurrency(amount: 5499.00, currencyCode: "DKK", locale: Locale(identifier: "da_DK"))
        XCTAssertTrue(dkkFormatted.contains("DKK") || dkkFormatted.contains("kr"))
        
        let nokFormatted = RegionalFormatter.shared.formatCurrency(amount: 8900.00, currencyCode: "NOK", locale: Locale(identifier: "nb_NO"))
        XCTAssertTrue(nokFormatted.contains("NOK") || nokFormatted.contains("kr"))
        
        let sekFormatted = RegionalFormatter.shared.formatCurrency(amount: 12400.00, currencyCode: "SEK", locale: Locale(identifier: "sv_SE"))
        XCTAssertTrue(sekFormatted.contains("SEK") || sekFormatted.contains("kr"))
    }
    
    // MARK: - Test 4: Distance & Water Hardness Formatting
    func testUnitFormatting() {
        let distance = RegionalFormatter.shared.formatDistance(kilometers: 1450.5, locale: Locale(identifier: "de_CH"))
        XCTAssertTrue(distance.contains("km"))
        
        let waterHardness = RegionalFormatter.shared.formatWaterHardness(germanDegrees: 14.0)
        XCTAssertEqual(waterHardness, "14.0 °dH (24.9 °fH)")
        
        let pressure = RegionalFormatter.shared.formatPressure(psi: 85.0)
        XCTAssertTrue(pressure.contains("85 PSI") || pressure.contains("85.0 PSI"))
        XCTAssertTrue(pressure.contains("bar"))
    }
}
