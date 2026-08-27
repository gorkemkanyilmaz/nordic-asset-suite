//
//  QueryNormalizer.swift
//  AssetCoreSearch
//
//  Created for Nordic Asset Suite.
//  Strict Concurrency: Complete. Deterministic Query & Title Normalization Engine.
//

import Foundation

/// Normalized representation of user input or barcode search query.
public struct NormalizedProductQuery: Sendable, Codable {
    public let rawInput: String
    public let brand: String?
    public let modelNumber: String
    public let variant: String?
    public let seriesOrFamily: String?
    public let cleanedQueryString: String
    public let canonicalDisplayTitle: String
    
    public init(
        rawInput: String,
        brand: String?,
        modelNumber: String,
        variant: String? = nil,
        seriesOrFamily: String? = nil,
        cleanedQueryString: String,
        canonicalDisplayTitle: String
    ) {
        self.rawInput = rawInput
        self.brand = brand
        self.modelNumber = modelNumber
        self.variant = variant
        self.seriesOrFamily = seriesOrFamily
        self.cleanedQueryString = cleanedQueryString
        self.canonicalDisplayTitle = canonicalDisplayTitle
    }
}

/// Deterministic parser and query builder for hardware models.
public final class QueryNormalizer: Sendable {
    public static let shared = QueryNormalizer()
    
    private let knownBrands: [String: String] = [
        "philips": "Philips",
        "samsung": "Samsung",
        "miele": "Miele",
        "v-zug": "V-ZUG",
        "vzug": "V-ZUG",
        "bosch": "Bosch",
        "siemens": "Siemens",
        "jura": "Jura",
        "delonghi": "De'Longhi",
        "de'longhi": "De'Longhi",
        "sage": "Sage",
        "breville": "Breville",
        "la marzocco": "La Marzocco",
        "lamarzocco": "La Marzocco",
        "scott": "Scott",
        "orbea": "Orbea",
        "specialized": "Specialized",
        "stoeckli": "Stöckli",
        "stockli": "Stöckli",
        "atomic": "Atomic",
        "salomon": "Salomon",
        "head": "Head",
        "fischer": "Fischer",
        "volkl": "Völkl",
        "voelkl": "Völkl"
    ]
    
    private init() {}
    
    /// Normalizes raw input string into a structured query representation.
    public func normalize(query: String) -> NormalizedProductQuery {
        let trimmed = query.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else {
            return NormalizedProductQuery(
                rawInput: query,
                brand: nil,
                modelNumber: "",
                cleanedQueryString: "",
                canonicalDisplayTitle: ""
            )
        }
        
        let lower = trimmed.lowercased()
        var detectedBrand: String? = nil
        var remaining = trimmed
        
        // 1. Detect and strip brand prefix if present
        for (key, canonicalBrand) in knownBrands {
            if lower.hasPrefix(key) {
                detectedBrand = canonicalBrand
                let index = trimmed.index(trimmed.startIndex, offsetBy: key.count)
                remaining = String(trimmed[index...]).trimmingCharacters(in: .whitespacesAndNewlines)
                break
            }
        }
        
        // 2. Clean remaining model text
        remaining = remaining.replacingOccurrences(of: "  +", with: " ", options: .regularExpression)
        
        // 3. Extract variant if pattern like /90 or /50 exists
        var variant: String? = nil
        var modelNumber = remaining
        if let slashIndex = remaining.firstIndex(of: "/") {
            variant = String(remaining[slashIndex...]).trimmingCharacters(in: .whitespaces)
        }
        
        // 4. Build canonical display title without duplication
        let brandName = detectedBrand ?? ""
        let displayTitle: String
        if brandName.isEmpty {
            displayTitle = modelNumber
        } else if modelNumber.lowercased().contains(brandName.lowercased()) {
            displayTitle = modelNumber
        } else {
            displayTitle = "\(brandName) \(modelNumber)"
        }
        
        return NormalizedProductQuery(
            rawInput: query,
            brand: detectedBrand,
            modelNumber: modelNumber,
            variant: variant,
            seriesOrFamily: nil,
            cleanedQueryString: "\(brandName) \(modelNumber)".trimmingCharacters(in: .whitespaces),
            canonicalDisplayTitle: displayTitle
        )
    }
    
    /// Builds progressive search query tiers for Tavily API.
    public func buildSearchQueries(for query: NormalizedProductQuery) -> [String] {
        var queries: [String] = []
        let brand = query.brand ?? ""
        let model = query.modelNumber
        
        if !brand.isEmpty && !model.isEmpty {
            // Tier 1: Exact quoted query
            queries.append("\"\(brand) \(model)\"")
            queries.append("\"\(model)\" \(brand)")
            queries.append("\"\(brand) \(model)\" specifications")
        } else {
            queries.append("\"\(query.cleanedQueryString)\"")
        }
        
        return queries
    }
}
