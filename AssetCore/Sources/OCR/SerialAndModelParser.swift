//
//  SerialAndModelParser.swift
//  AssetCoreOCR
//
//  Created for Nordic Asset Suite.
//  Strict Concurrency: Complete. Hardware Badge & Serial Number Pattern Matcher.
//

import Foundation

/// High-accuracy rule-based parser for hardware rating plates, frame serials, and equipment labels.
public final class SerialAndModelParser: Sendable {
    public static let shared = SerialAndModelParser()
    
    private init() {}
    
    // Known Brands Database
    private let knownBrands: [String: String] = [
        // Appliances
        "v-zug": "V-ZUG", "vzug": "V-ZUG", "miele": "Miele", "bosch": "Bosch",
        "siemens": "Siemens", "electrolux": "Electrolux", "liebherr": "Liebherr",
        "aeg": "AEG", "bauknecht": "Bauknecht", "smeg": "Smeg", "gaggenau": "Gaggenau",
        
        // Ski Gear
        "stöckli": "Stöckli", "stoeckli": "Stöckli", "atomic": "Atomic", "salomon": "Salomon",
        "head": "Head", "rossignol": "Rossignol", "völkl": "Völkl", "voelkl": "Völkl",
        "fischer": "Fischer", "marker": "Marker", "look": "Look", "tyrolia": "Tyrolia",
        
        // E-Bikes
        "scott": "Scott", "specialized": "Specialized", "trek": "Trek", "cube": "Cube",
        "canyon": "Canyon", "bmc": "BMC Switzerland", "cannondale": "Cannondale",
        "giant": "Giant", "orbea": "Orbea", "flyer": "Flyer", "focus": "Focus",
        
        // Coffee Machines
        "jura": "Jura", "sage": "Sage", "breville": "Breville", "delonghi": "DeLonghi",
        "la marzocco": "La Marzocco", "rocket": "Rocket Espresso", "ecm": "ECM",
        "profitec": "Profitec", "gaggia": "Gaggia", "lelit": "Lelit"
    ]
    
    // Serial Number Regex Patterns (prioritizes explicit serial keywords)
    private let serialRegex = try? NSRegularExpression(
        pattern: #"(?:Seriennummer|Serien-Nr|Serial(?:\s*No|\s*Number)?|S\/N|SN|Frame\s*No)\s*[:.\-]?\s*([A-Z0-9\-_]{5,24})"#,
        options: [.caseInsensitive]
    )
    
    // Model Number Regex Patterns
    private let modelRegex = try? NSRegularExpression(
        pattern: #"(?:Mod(?:el)?|Type|Typ|Modell)\s*[:.\-]?\s*([A-Z0-9\-_]{3,20})"#,
        options: [.caseInsensitive]
    )
    
    /// Parses raw OCR text lines from a rating badge into structured serial data.
    public func parseBadge(from ocrText: String, confidenceScore: Float) -> ParsedSerialData {
        let detectedBrand = detectBrand(from: ocrText)
        let detectedSerial = extractSerial(from: ocrText)
        let detectedModel = extractModel(from: ocrText)
        let category = inferCategory(from: ocrText, brand: detectedBrand)
        
        return ParsedSerialData(
            brand: detectedBrand,
            modelName: detectedModel,
            serialNumber: detectedSerial,
            category: category,
            confidenceScore: confidenceScore
        )
    }
    
    private func detectBrand(from text: String) -> String? {
        let lower = text.lowercased()
        var earliestIndex = Int.max
        var foundBrand: String? = nil
        
        for (key, officialName) in knownBrands {
            if let range = lower.range(of: key) {
                let index = lower.distance(from: lower.startIndex, to: range.lowerBound)
                if index < earliestIndex {
                    earliestIndex = index
                    foundBrand = officialName
                }
            }
        }
        return foundBrand
    }
    
    private func extractSerial(from text: String) -> String? {
        guard let regex = serialRegex else { return nil }
        let range = NSRange(location: 0, length: text.utf16.count)
        if let match = regex.firstMatch(in: text, options: [], range: range), match.numberOfRanges > 1 {
            let nsText = text as NSString
            return nsText.substring(with: match.range(at: 1)).trimmingCharacters(in: .whitespaces)
        }
        
        // Fallback: look for standalone alphanumeric strings (7-18 chars with both letters and digits)
        let words = text.components(separatedBy: .whitespacesAndNewlines)
        for word in words {
            let cleaned = word.trimmingCharacters(in: .punctuationCharacters)
            if cleaned.count >= 7 && cleaned.count <= 18 {
                let hasLetters = cleaned.rangeOfCharacter(from: .letters) != nil
                let hasDigits = cleaned.rangeOfCharacter(from: .decimalDigits) != nil
                if hasLetters && hasDigits {
                    return cleaned
                }
            }
        }
        
        return nil
    }
    
    private func extractModel(from text: String) -> String? {
        guard let regex = modelRegex else { return nil }
        let range = NSRange(location: 0, length: text.utf16.count)
        if let match = regex.firstMatch(in: text, options: [], range: range), match.numberOfRanges > 1 {
            let nsText = text as NSString
            return nsText.substring(with: match.range(at: 1)).trimmingCharacters(in: .whitespaces)
        }
        return nil
    }
    
    private func inferCategory(from text: String, brand: String?) -> String? {
        let lower = text.lowercased()
        if lower.contains("dishwasher") || lower.contains("geschirrspüler") || lower.contains("waschmaschine") || lower.contains("adorawaschen") || lower.contains("waschen") || lower.contains("oven") || lower.contains("backofen") || lower.contains("v-zug") || lower.contains("miele") {
            return "Appliance"
        }
        if lower.contains("ski") || lower.contains("binding") || lower.contains("din") || lower.contains("sole") || lower.contains("stöckli") || lower.contains("atomic") {
            return "SkiGear"
        }
        if lower.contains("ebike") || lower.contains("e-bike") || lower.contains("pedelec") || lower.contains("frame") || lower.contains("motor") || lower.contains("drive unit") || lower.contains("scott") {
            return "EBike"
        }
        if lower.contains("espresso") || lower.contains("coffee") || lower.contains("barista") || lower.contains("jura") || lower.contains("descaling") {
            return "CoffeeMachine"
        }
        return nil
    }
}
