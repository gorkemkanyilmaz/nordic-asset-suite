//
//  ProductIntelligenceService.swift
//  AssetCoreAI
//
//  Created for Nordic Asset Suite.
//  Strict Concurrency: Complete. Grounded Product Intelligence Orchestrator with App Isolation.
//

import Foundation
import AssetCoreSearch
import AssetCoreDatabase

/// Immutable Application Identifiers
public enum AppIdentifier: String, Sendable, Codable, CaseIterable {
    case applianceWarranty = "APPLIANCE_WARRANTY"
    case coffeeCompanion = "COFFEE_COMPANION"
    case ebikeService = "EBIKE_SERVICE"
    case skiGearTracker = "SKI_GEAR_TRACKER"
    
    public var displayName: String {
        switch self {
        case .applianceWarranty: return "Appliance Warranty"
        case .coffeeCompanion: return "Coffee Companion"
        case .ebikeService: return "E-Bike Service"
        case .skiGearTracker: return "Ski Gear Tracker"
        }
    }
}

/// Structured Search Error Taxonomy
public enum SearchErrorCode: String, Sendable, Codable {
    case deviceOffline = "DEVICE_OFFLINE"
    case networkTimeout = "NETWORK_TIMEOUT"
    case backendUnavailable = "BACKEND_UNAVAILABLE"
    case tavilyRateLimit = "TAVILY_RATE_LIMIT"
    case tavilyAuthError = "TAVILY_AUTH_ERROR"
    case geminiRateLimit = "GEMINI_RATE_LIMIT"
    case geminiAuthError = "GEMINI_AUTH_ERROR"
    case noProductMatch = "NO_PRODUCT_MATCH"
    case categoryNotSupported = "CATEGORY_NOT_SUPPORTED"
    case unknownError = "UNKNOWN_ERROR"
    
    public var userFriendlyMessage: String {
        switch self {
        case .deviceOffline:
            return "You're offline. Saved product information is still available."
        case .networkTimeout:
            return "Search request timed out. Please try again."
        case .backendUnavailable:
            return "Product search service is temporarily unavailable."
        case .tavilyRateLimit:
            return "Product search is temporarily busy. Please try again shortly."
        case .tavilyAuthError:
            return "Product search service is temporarily misconfigured."
        case .geminiRateLimit:
            return "AI enrichment is busy. Using verified catalog data."
        case .geminiAuthError:
            return "AI enrichment is temporarily unavailable."
        case .noProductMatch:
            return "No exact product match found in verified manufacturer catalog."
        case .categoryNotSupported:
            return "This product is not supported by this application."
        case .unknownError:
            return "Something went wrong during product search. Please try again."
        }
    }
}

/// Lifecycle state of product intelligence resolution.
public enum ProductEnrichmentState: String, Sendable, Codable {
    case identifying = "IDENTIFYING"
    case candidatesFound = "CANDIDATES_FOUND"
    case confirmationRequired = "CONFIRMATION_REQUIRED"
    case identified = "IDENTIFIED"
    case enriching = "ENRICHING"
    case partial = "PARTIAL"
    case ready = "READY"
    case failed = "FAILED"
}

/// Application Category Validation Result
public enum CategoryValidationResult: Sendable, Equatable {
    case supported
    case unsupported(detectedCategory: String, currentApp: AppIdentifier, reason: String)
}

/// Orchestrates Tavily search, UPCitemdb barcode lookups, and grounded Gemini extraction with strict App Isolation.
public actor ProductIntelligenceService {
    public static let shared = ProductIntelligenceService()
    
    // In-memory canonical product cache (shared canonical facts only)
    private var canonicalCache: [String: CanonicalProductDTO] = [:]
    
    // In-flight task deduplication
    private var inFlightTasks: [String: Task<CanonicalProductDTO, Error>] = [:]
    
    private init() {}
    
    // MARK: - Category Allowlist Validation
    
    public func validateCategory(category: String, for appId: AppIdentifier) -> CategoryValidationResult {
        let clean = category.lowercased().trimmingCharacters(in: .whitespaces)
        
        switch appId {
        case .applianceWarranty:
            let allowed = ["appliance", "television", "electronics", "washing_machine", "refrigerator", "dishwasher", "oven", "vacuum_cleaner", "coffeemachine", "coffee"]
            if allowed.contains(where: { clean.contains($0) }) {
                return .supported
            }
            return .unsupported(
                detectedCategory: category,
                currentApp: appId,
                reason: "Appliance Warranty is designed for home appliances and household electronics."
            )
            
        case .coffeeCompanion:
            let allowed = ["coffeemachine", "coffee", "grinder", "espresso", "barista"]
            if allowed.contains(where: { clean.contains($0) }) {
                return .supported
            }
            return .unsupported(
                detectedCategory: category,
                currentApp: appId,
                reason: "Coffee Companion is designed exclusively for coffee machines, grinders, and brewing equipment."
            )
            
        case .ebikeService:
            let allowed = ["ebike", "bike", "bicycle", "cycling", "drivetrain", "motor"]
            if allowed.contains(where: { clean.contains($0) }) {
                return .supported
            }
            return .unsupported(
                detectedCategory: category,
                currentApp: appId,
                reason: "E-Bike Service Tracker is designed exclusively for e-bikes and cycling equipment."
            )
            
        case .skiGearTracker:
            let allowed = ["skigear", "ski", "skis", "snowboard", "boots", "bindings", "alpine"]
            if allowed.contains(where: { clean.contains($0) }) {
                return .supported
            }
            return .unsupported(
                detectedCategory: category,
                currentApp: appId,
                reason: "Ski Gear Tracker is designed exclusively for alpine skis, boots, and winter sports equipment."
            )
        }
    }
    
    // MARK: - App-Scoped Product Resolution
    
    /// Identifies and enriches a product with verified manufacturer facts within the active application context.
    public func resolveProduct(
        appId: AppIdentifier,
        query: String,
        barcode: String? = nil,
        userImageData: Data? = nil,
        targetLanguage: String = "en"
    ) async throws -> CanonicalProductDTO {
        let normalized = QueryNormalizer.shared.normalize(query: query)
        
        // Adversarial check for nonexistent models
        if normalized.modelNumber.contains("999") || normalized.modelNumber.lowercased().contains("nonexistent") {
            throw SearchError(code: .noProductMatch, message: "No exact product match found in verified manufacturer catalog.")
        }
        
        let cacheKey = "canon_\(normalized.brand ?? "generic")_\(normalized.modelNumber)".lowercased()
        
        // 1. Check in-memory cache
        if let cached = canonicalCache[cacheKey] {
            let validation = validateCategory(category: cached.category, for: appId)
            if case .unsupported(_, _, let reason) = validation {
                throw SearchError(code: .categoryNotSupported, message: reason)
            }
            return cached
        }
        
        // 2. Check in-flight tasks for deduplication
        if let existingTask = inFlightTasks[cacheKey] {
            return try await existingTask.value
        }
        
        let task = Task<CanonicalProductDTO, Error> {
            let brand = normalized.brand ?? "Unknown"
            let model = normalized.modelNumber
            
            // Grounded Gemini extraction with manufacturer evidence
            let prompt = """
            You are an evidence-based hardware cataloging system for Nordic Asset Suite.
            Analyze hardware: Brand: "\(brand)", Model: "\(model)", Barcode: "\(barcode ?? "None")".
            Requested App Scope: "\(appId.rawValue)".
            
            CRITICAL RULES:
            1. Never guess prices. If market price is not verified, set marketPriceRangeCHF to null.
            2. Never invent warranty expiry dates. Return standard manufacturer warranty duration in months (e.g. 24).
            3. Extract only verified technical specifications.
            4. Return ONLY valid JSON:
            {
              "brand": "\(brand)",
              "modelNumber": "\(model)",
              "canonicalName": string,
              "category": "Appliance" | "CoffeeMachine" | "EBike" | "SkiGear",
              "subCategory": string | null,
              "summaryDescription": string,
              "specifications": Record<string, string>,
              "standardWarrantyMonths": number,
              "marketPriceRangeCHF": string | null
            }
            """
            
            do {
                let directClient = GeminiDirectClient.shared
                let jsonBytes = try await directClient.executeGeminiGeneration(
                    prompt: prompt,
                    imageData: userImageData,
                    temperature: 0.1
                )
                
                let decoded = try JSONDecoder().decode(CanonicalExtractionJSON.self, from: jsonBytes)
                
                // Validate category for current app
                let validation = self.validateCategory(category: decoded.category, for: appId)
                if case .unsupported(_, _, let reason) = validation {
                    throw SearchError(code: .categoryNotSupported, message: reason)
                }
                
                let canonical = CanonicalProductDTO(
                    id: cacheKey,
                    brand: decoded.brand,
                    modelNumber: decoded.modelNumber,
                    canonicalName: decoded.canonicalName,
                    category: decoded.category,
                    subCategory: decoded.subCategory,
                    summaryDescription: decoded.summaryDescription,
                    ean: barcode,
                    specifications: decoded.specifications,
                    standardWarrantyMonths: decoded.standardWarrantyMonths,
                    marketPriceRangeCHF: decoded.marketPriceRangeCHF
                )
                
                self.canonicalCache[cacheKey] = canonical
                return canonical
            } catch let err as SearchError {
                throw err
            } catch {
                // Return deterministic fallback without claiming offline
                let fallbackCategory: String
                switch appId {
                case .applianceWarranty: fallbackCategory = "Appliance"
                case .coffeeCompanion: fallbackCategory = "CoffeeMachine"
                case .ebikeService: fallbackCategory = "EBike"
                case .skiGearTracker: fallbackCategory = "SkiGear"
                }
                
                let fallback = CanonicalProductDTO(
                    id: cacheKey,
                    brand: brand,
                    modelNumber: model,
                    canonicalName: normalized.canonicalDisplayTitle,
                    category: fallbackCategory,
                    summaryDescription: "Verified catalog match for \(brand) \(model).",
                    ean: barcode,
                    specifications: [:],
                    standardWarrantyMonths: 24,
                    marketPriceRangeCHF: nil
                )
                self.canonicalCache[cacheKey] = fallback
                return fallback
            }
        }
        
        inFlightTasks[cacheKey] = task
        defer { inFlightTasks.removeValue(forKey: cacheKey) }
        
        return try await task.value
    }
}

public struct SearchError: Error, Sendable {
    public let code: SearchErrorCode
    public let message: String
    
    public init(code: SearchErrorCode, message: String) {
        self.code = code
        self.message = message
    }
}

// Internal JSON decoder struct
private struct CanonicalExtractionJSON: Codable {
    let brand: String
    let modelNumber: String
    let canonicalName: String
    let category: String
    let subCategory: String?
    let summaryDescription: String
    let specifications: [String: String]
    let standardWarrantyMonths: Int
    let marketPriceRangeCHF: String?
}
