//
//  AIModels.swift
//  AssetCoreAI
//
//  Created for Nordic Asset Suite.
//  Strict Concurrency: Complete. Codable Structured JSON Schemas for Omni-Identification, Manuals, Warranty & Maintenance.
//

import Foundation

/// Active third-party AI LLM backend provider.
public enum AIProvider: String, Sendable, Codable {
    case geminiFlash = "gemini-1.5-flash"
    case geminiFlash2 = "gemini-2.0-flash"
    case grok2 = "grok-2"
    case localFallback = "local-vision-regex"
}

// MARK: - Omni-Product Candidate Identification

/// Structured result of AI product recognition (via barcode, OCR label, or free-text search).
public struct ProductCandidateMatch: Sendable, Codable, Identifiable {
    public var id: String { "\(brand)_\(modelName)_\(serialNumber ?? "none")" }
    public let brand: String
    public let modelName: String
    public let fullTitle: String
    public let category: String // Appliance, CoffeeMachine, EBike, SkiGear, Electronics, AudioVisual
    public let subCategory: String? // e.g. "OLED TV", "Washing Machine", "Superautomatic Espresso"
    public let serialNumber: String?
    public let manufactureYear: Int?
    public let keySpecifications: [String: String]
    public let estimatedPrice: Decimal?
    public let currencyCode: String
    public let defaultWarrantyMonths: Int
    public let summaryDescription: String
    public let confidenceScore: Double
    public let providerUsed: AIProvider
    public let imageUrl: String?
    
    enum CodingKeys: String, CodingKey {
        case brand, modelName, fullTitle, category, subCategory, serialNumber
        case manufactureYear, keySpecifications, estimatedPrice, currencyCode
        case defaultWarrantyMonths, summaryDescription, confidenceScore, providerUsed, imageUrl
    }
    
    public init(
        brand: String,
        modelName: String,
        fullTitle: String,
        category: String,
        subCategory: String? = nil,
        serialNumber: String? = nil,
        manufactureYear: Int? = nil,
        keySpecifications: [String: String] = [:],
        estimatedPrice: Decimal? = nil,
        currencyCode: String = "CHF",
        defaultWarrantyMonths: Int = 24,
        summaryDescription: String = "",
        confidenceScore: Double = 0.95,
        providerUsed: AIProvider = .geminiFlash,
        imageUrl: String? = nil
    ) {
        self.brand = brand
        self.modelName = modelName
        self.fullTitle = fullTitle
        self.category = category
        self.subCategory = subCategory
        self.serialNumber = serialNumber
        self.manufactureYear = manufactureYear
        self.keySpecifications = keySpecifications
        self.estimatedPrice = estimatedPrice
        self.currencyCode = currencyCode
        self.defaultWarrantyMonths = defaultWarrantyMonths
        self.summaryDescription = summaryDescription
        self.confidenceScore = confidenceScore
        self.providerUsed = providerUsed
        self.imageUrl = imageUrl ?? Self.defaultImageUrl(forCategory: category, brand: brand, model: modelName, fullTitle: fullTitle)
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let brand = try container.decodeIfPresent(String.self, forKey: .brand) ?? "Generic"
        let model = try container.decodeIfPresent(String.self, forKey: .modelName) ?? "Standard Model"
        self.brand = brand
        self.modelName = model
        self.fullTitle = try container.decodeIfPresent(String.self, forKey: .fullTitle) ?? "\(brand) \(model)"
        let cat = try container.decodeIfPresent(String.self, forKey: .category) ?? "Appliance"
        self.category = cat
        self.subCategory = try container.decodeIfPresent(String.self, forKey: .subCategory)
        self.serialNumber = try container.decodeIfPresent(String.self, forKey: .serialNumber)
        self.manufactureYear = try container.decodeIfPresent(Int.self, forKey: .manufactureYear) ?? Calendar.current.component(.year, from: Date())
        self.keySpecifications = try container.decodeIfPresent([String: String].self, forKey: .keySpecifications) ?? [:]
        
        // Flexible price decoding (handles Decimal, Double, Int, or String formatted prices)
        if let dec = try? container.decodeIfPresent(Decimal.self, forKey: .estimatedPrice) {
            self.estimatedPrice = dec
        } else if let dbl = try? container.decodeIfPresent(Double.self, forKey: .estimatedPrice) {
            self.estimatedPrice = Decimal(dbl)
        } else if let intVal = try? container.decodeIfPresent(Int.self, forKey: .estimatedPrice) {
            self.estimatedPrice = Decimal(intVal)
        } else if let str = try? container.decodeIfPresent(String.self, forKey: .estimatedPrice) {
            let digits = str.components(separatedBy: CharacterSet(charactersIn: "0123456789.").inverted).joined()
            self.estimatedPrice = Decimal(string: digits)
        } else {
            self.estimatedPrice = nil
        }
        
        self.currencyCode = try container.decodeIfPresent(String.self, forKey: .currencyCode) ?? "CHF"
        self.defaultWarrantyMonths = try container.decodeIfPresent(Int.self, forKey: .defaultWarrantyMonths) ?? 24
        self.summaryDescription = try container.decodeIfPresent(String.self, forKey: .summaryDescription) ?? ""
        self.confidenceScore = try container.decodeIfPresent(Double.self, forKey: .confidenceScore) ?? 0.95
        self.providerUsed = try container.decodeIfPresent(AIProvider.self, forKey: .providerUsed) ?? .geminiFlash
        
        if let decodedImg = try? container.decodeIfPresent(String.self, forKey: .imageUrl), !decodedImg.isEmpty {
            self.imageUrl = decodedImg
        } else {
            let fullTitle = (try? container.decodeIfPresent(String.self, forKey: .fullTitle)) ?? ""
            self.imageUrl = Self.defaultImageUrl(forCategory: cat, brand: brand, model: model, fullTitle: fullTitle)
        }
    }
    
    public static func defaultImageUrl(forCategory category: String, brand: String = "", model: String = "", fullTitle: String = "") -> String {
        let lower = "\(category) \(brand) \(model) \(fullTitle)".lowercased()
        
        // 1. Laptops, Computers & Gaming Notebooks (e.g. "Monster Abra A5", "MacBook Pro", "Asus ROG", "Lenovo Legion")
        if lower.contains("laptop") || lower.contains("notebook") || lower.contains("macbook") || lower.contains("abra") ||
           lower.contains("tulpar") || lower.contains("semruk") || lower.contains("monster") || lower.contains("gaming pc") ||
           lower.contains("thinkpad") || lower.contains("zenbook") || lower.contains("legion") || lower.contains("rog") ||
           lower.contains("alienware") || lower.contains("xps") || lower.contains("omen") || lower.contains("victus") ||
           lower.contains("predator") || lower.contains("bilgisayar") || lower.contains("dizüstü") || lower.contains("computer") {
            return "https://images.unsplash.com/photo-1603302576837-37561b2e2302?w=800&auto=format&fit=crop&q=80"
        }
        
        // 2. Smartphones & Mobile Phones (e.g. "iPhone 15", "Samsung Galaxy S24", "Google Pixel")
        if lower.contains("iphone") || lower.contains("galaxy s") || lower.contains("galaxy z") || lower.contains("pixel") ||
           lower.contains("smartphone") || lower.contains("telefon") || lower.contains("xiaomi") || lower.contains("redmi") ||
           lower.contains("oneplus") || lower.contains("huawei") || lower.contains("honor") || lower.contains("mobile") {
            return "https://images.unsplash.com/photo-1592750475338-74b7b21085ab?w=800&auto=format&fit=crop&q=80"
        }
        
        // 3. Audio, Headphones & Earbuds (e.g. "Sony WH-1000XM5", "AirPods Max", "Bose QC")
        if lower.contains("headphone") || lower.contains("earbud") || lower.contains("airpod") || lower.contains("wh-1000") ||
           lower.contains("wf-1000") || lower.contains("quietcomfort") || lower.contains("kulaklık") || lower.contains("audio") ||
           lower.contains("sennheiser") || lower.contains("beats") || lower.contains("soundbar") || lower.contains("speaker") ||
           lower.contains("sonos") || lower.contains("jbl") || lower.contains("marshall") || lower.contains("hoparlör") {
            return "https://images.unsplash.com/photo-1505740420928-5e560c06d30e?w=800&auto=format&fit=crop&q=80"
        }
        
        // 4. Tablets & E-Readers (e.g. "iPad Pro", "Galaxy Tab", "Surface Pro")
        if lower.contains("ipad") || lower.contains("tablet") || lower.contains("galaxy tab") || lower.contains("surface") || lower.contains("kindle") {
            return "https://images.unsplash.com/photo-1544244015-0df4b3ffc6b0?w=800&auto=format&fit=crop&q=80"
        }
        
        // 5. Gaming Consoles & Handhelds (e.g. "PlayStation 5", "Xbox Series X", "Nintendo Switch")
        if lower.contains("playstation") || lower.contains("ps5") || lower.contains("ps4") || lower.contains("xbox") ||
           lower.contains("nintendo") || lower.contains("switch") || lower.contains("steam deck") || lower.contains("konsol") {
            return "https://images.unsplash.com/photo-1606813907291-d86efa9b94db?w=800&auto=format&fit=crop&q=80"
        }
        
        // 6. Smartwatches & Wearables (e.g. "Apple Watch", "Garmin Fenix", "Galaxy Watch")
        if lower.contains("apple watch") || lower.contains("smartwatch") || lower.contains("garmin") || lower.contains("fenix") ||
           lower.contains("akıllı saat") || lower.contains("galaxy watch") || lower.contains("fitbit") {
            return "https://images.unsplash.com/photo-1523275335684-37898b6baf30?w=800&auto=format&fit=crop&q=80"
        }
        
        // 7. Cameras & Photography (e.g. "Sony Alpha", "Canon EOS", "GoPro")
        if lower.contains("camera") || lower.contains("canon") || lower.contains("nikon") || lower.contains("fujifilm") ||
           lower.contains("gopro") || lower.contains("kamera") || lower.contains("alpha 7") || lower.contains("eos r") {
            return "https://images.unsplash.com/photo-1516035069371-29a1b244cc32?w=800&auto=format&fit=crop&q=80"
        }
        
        // 8. Air Fryers & Countertop Kitchen Small Appliances (e.g. "Philips Airfryer XXL", "Ninja Foodi")
        if lower.contains("airfryer") || lower.contains("air fryer") || lower.contains("fritöz") || lower.contains("blender") ||
           lower.contains("mixer") || lower.contains("kettle") || lower.contains("su ısıtıcı") || lower.contains("tost") {
            return "https://images.unsplash.com/photo-1585659722983-3a675dabf23d?w=800&auto=format&fit=crop&q=80"
        }
        
        // 9. TVs, OLEDs, QLEDs, Electronics, Displays, Smart TVs (e.g. "Samsung QN85D", "LG C3", "Sony Bravia")
        if lower.contains("tv") || lower.contains("oled") || lower.contains("qled") || lower.contains("neo qled") ||
           lower.contains("qn8") || lower.contains("qn9") || lower.contains("qn7") || lower.contains("the frame") ||
           lower.contains("bravia") || lower.contains("television") || lower.contains("screen") ||
           lower.contains("display") || lower.contains("monitor") || lower.contains("televizyon") || lower.contains("fernseher") ||
           lower.contains("4k") || lower.contains("8k") ||
           ((brand.lowercased() == "samsung" || brand.lowercased() == "sony" || brand.lowercased() == "lg") && (category.lowercased().contains("electronic") || model.lowercased().contains("qn") || model.lowercased().contains("oled"))) {
            return "https://images.unsplash.com/photo-1593784991095-a205069470b6?w=800&auto=format&fit=crop&q=80"
        }
        
        // 10. Coffee & Espresso Machines (e.g. "Tchibo Cafissimo", "Jura E8", "De'Longhi Magnifica", "Nespresso")
        if lower.contains("coffee") || lower.contains("espresso") || lower.contains("cafissimo") || lower.contains("nespresso") || 
           lower.contains("barista") || lower.contains("jura") || lower.contains("delonghi") || lower.contains("krups") || 
           lower.contains("tchibo") || lower.contains("gaggia") || lower.contains("breville") || lower.contains("sage") ||
           lower.contains("kaffee") || lower.contains("kahve") {
            return "https://images.unsplash.com/photo-1510591509098-f4fdc6d0ff04?w=800&auto=format&fit=crop&q=80"
        }
        
        // 11. Washing Machines & Dryers (e.g. "Miele W1", "V-ZUG AdoraWaschen", "Bosch Serie 8")
        if lower.contains("wash") || lower.contains("laundry") || lower.contains("dryer") || lower.contains("waschmaschine") || lower.contains("adorawaschen") || lower.contains("trockner") {
            return "https://images.unsplash.com/photo-1626806787461-102c1bfaaea1?w=800&auto=format&fit=crop&q=80"
        }
        
        // 12. Dishwashers & Built-in Kitchen Appliances
        if lower.contains("dish") || lower.contains("geschirrspüler") || lower.contains("spüler") || lower.contains("microwave") || lower.contains("sharp") || lower.contains("oven") || lower.contains("backofen") {
            return "https://images.unsplash.com/photo-1585837575652-267c041d77d4?w=800&auto=format&fit=crop&q=80"
        }
        
        // 13. Refrigerators & Freezers
        if lower.contains("fridge") || lower.contains("refrigerat") || lower.contains("kühlschrank") || lower.contains("freezer") || lower.contains("gefrier") {
            return "https://images.unsplash.com/photo-1584992236310-6edddc08acff?w=800&auto=format&fit=crop&q=80"
        }
        
        // 14. Cordless Stick Vacuums (Dyson, Shark, Philips, Dreame)
        if lower.contains("dyson") || lower.contains("cordless") || lower.contains("stick vacuum") || lower.contains("v15") || lower.contains("v12") || lower.contains("v11") {
            return "https://images.unsplash.com/photo-1527515637462-cff94eecc1ac?w=800&auto=format&fit=crop&q=80"
        }
        
        // 15. Robotic Vacuums & General Cleaners
        if lower.contains("vacuum") || lower.contains("staubsauger") || lower.contains("roomba") || lower.contains("robot") || lower.contains("roborock") {
            return "https://images.unsplash.com/photo-1558317374-067fb5f30001?w=800&auto=format&fit=crop&q=80"
        }
        
        // 15. E-Bikes & Smart Bicycles
        if lower.contains("ebike") || lower.contains("bike") || lower.contains("bicycle") || lower.contains("pedelec") || lower.contains("scott") || lower.contains("specialized") {
            return "https://images.unsplash.com/photo-1576435728678-68d0fbf94e91?w=800&auto=format&fit=crop&q=80"
        }
        
        // 16. Ski Gear & Winter Equipment
        if lower.contains("ski") || lower.contains("snowboard") || lower.contains("binding") || lower.contains("boots") || lower.contains("stöckli") || lower.contains("atomic") {
            return "https://images.unsplash.com/photo-1551698618-1dfe5d97d256?w=800&auto=format&fit=crop&q=80"
        }
        
        // 17. Premium Modern Tech Hardware Fallback (Never a living room!)
        return "https://images.unsplash.com/photo-1550009158-9ebf69173e03?w=800&auto=format&fit=crop&q=80"
    }
}

// MARK: - Maintenance Manual & Step-by-Step Guides

public struct MaintenanceStep: Sendable, Codable, Identifiable {
    public var id: Int { stepNumber }
    public let stepNumber: Int
    public let title: String
    public let detail: String
    public let frequencyDescription: String // e.g. "Monthly", "Every 200 shots", "Seasonal"
    public let frequencyDays: Int?
    public let isMandatory: Bool
    public let toolsRequired: [String]
    public let iconName: String
    
    public init(
        stepNumber: Int,
        title: String,
        detail: String,
        frequencyDescription: String = "Periodic",
        frequencyDays: Int? = 90,
        isMandatory: Bool = true,
        toolsRequired: [String] = [],
        iconName: String = "wrench.and.screwdriver"
    ) {
        self.stepNumber = stepNumber
        self.title = title
        self.detail = detail
        self.frequencyDescription = frequencyDescription
        self.frequencyDays = frequencyDays
        self.isMandatory = isMandatory
        self.toolsRequired = toolsRequired
        self.iconName = iconName
    }
}

public struct MaintenanceManualData: Sendable, Codable {
    public let brand: String
    public let modelName: String
    public let category: String
    public let generalCareSummary: String
    public let recommendedServiceIntervalDays: Int
    public let maintenanceSteps: [MaintenanceStep]
    public let recommendedCleanersOrLubricants: [String]
    public let safetyPrecautions: [String]
    public let officialSupportURL: String?
    
    public init(
        brand: String,
        modelName: String,
        category: String,
        generalCareSummary: String,
        recommendedServiceIntervalDays: Int = 180,
        maintenanceSteps: [MaintenanceStep] = [],
        recommendedCleanersOrLubricants: [String] = [],
        safetyPrecautions: [String] = [],
        officialSupportURL: String? = nil
    ) {
        self.brand = brand
        self.modelName = modelName
        self.category = category
        self.generalCareSummary = generalCareSummary
        self.recommendedServiceIntervalDays = recommendedServiceIntervalDays
        self.maintenanceSteps = maintenanceSteps
        self.recommendedCleanersOrLubricants = recommendedCleanersOrLubricants
        self.safetyPrecautions = safetyPrecautions
        self.officialSupportURL = officialSupportURL
    }
}

// MARK: - Spare Parts & Wear Schedule

public struct SparePartItem: Sendable, Codable, Identifiable {
    public var id: String { partNumber.isEmpty ? name : partNumber }
    public let partNumber: String
    public let name: String
    public let category: String // Filter, Gasket, Chain, BrakePad, Burr, HeatingElement, Screen, Battery
    public let replacementIntervalDays: Int
    public let estimatedCostCHF: Decimal
    public let wearDegradationRateMonthly: Double // 0.0 to 100.0%
    public let description: String
    public let isCriticalForOperation: Bool
    
    public init(
        partNumber: String,
        name: String,
        category: String,
        replacementIntervalDays: Int = 180,
        estimatedCostCHF: Decimal = 45.0,
        wearDegradationRateMonthly: Double = 5.0,
        description: String = "",
        isCriticalForOperation: Bool = true
    ) {
        self.partNumber = partNumber
        self.name = name
        self.category = category
        self.replacementIntervalDays = replacementIntervalDays
        self.estimatedCostCHF = estimatedCostCHF
        self.wearDegradationRateMonthly = wearDegradationRateMonthly
        self.description = description
        self.isCriticalForOperation = isCriticalForOperation
    }
}

public struct SparePartsScheduleData: Sendable, Codable {
    public let brand: String
    public let modelName: String
    public let parts: [SparePartItem]
    
    public init(brand: String, modelName: String, parts: [SparePartItem]) {
        self.brand = brand
        self.modelName = modelName
        self.parts = parts
    }
}

// MARK: - Warranty Details

public struct WarrantyDetailsResponse: Sendable, Codable {
    public let standardCoverageMonths: Int
    public let extendedAvailableMonths: Int
    public let termsSummary: String
    public let coveredComponents: [String]
    public let excludedComponents: [String]
    public let claimsProcedure: String
    public let officialContact: String
    
    public init(
        standardCoverageMonths: Int = 24,
        extendedAvailableMonths: Int = 36,
        termsSummary: String = "2-Year European & Swiss statutory manufacturer warranty.",
        coveredComponents: [String] = ["Motor", "Electronics", "Compressor", "Heating Coil", "Frame"],
        excludedComponents: [String] = ["Cosmetic scratches", "Consumable wear", "Accidental drops"],
        claimsProcedure: String = "Register with serial number on OEM portal or contact certified dealer.",
        officialContact: String = "support@nordicassetsuite.ch"
    ) {
        self.standardCoverageMonths = standardCoverageMonths
        self.extendedAvailableMonths = extendedAvailableMonths
        self.termsSummary = termsSummary
        self.coveredComponents = coveredComponents
        self.excludedComponents = excludedComponents
        self.claimsProcedure = claimsProcedure
        self.officialContact = officialContact
    }
}

// MARK: - Extraction Request & Response

/// Payload dispatched for receipt / rating badge / document structured JSON extraction.
public struct AIExtractionRequest: Sendable, Codable {
    public let rawOCRText: String
    public let documentType: String // "receipt", "serial_badge", "manual_spec", "omni_query"
    public let targetLanguage: String // "en", "de", "fr", "it", "da", "sv", "nb", "tr"
    public let clientAttestationKeyId: String?
    
    public init(
        rawOCRText: String,
        documentType: String = "receipt",
        targetLanguage: String = "en",
        clientAttestationKeyId: String? = nil
    ) {
        self.rawOCRText = rawOCRText
        self.documentType = documentType
        self.targetLanguage = targetLanguage
        self.clientAttestationKeyId = clientAttestationKeyId
    }
}

/// Enforced structured JSON output schema returned by the LLM.
public struct AIExtractionResponse: Sendable, Codable {
    public let brand: String?
    public let modelName: String?
    public let serialNumber: String?
    public let purchaseDateISO: String? // "YYYY-MM-DD"
    public let purchasePrice: Decimal?
    public let currencyCode: String?
    public let detectedCategory: String?
    public let summaryDescription: String?
    public let confidenceScore: Double
    public let providerUsed: AIProvider
    
    public init(
        brand: String? = nil,
        modelName: String? = nil,
        serialNumber: String? = nil,
        purchaseDateISO: String? = nil,
        purchasePrice: Decimal? = nil,
        currencyCode: String? = nil,
        detectedCategory: String? = nil,
        summaryDescription: String? = nil,
        confidenceScore: Double = 0.95,
        providerUsed: AIProvider = .geminiFlash
    ) {
        self.brand = brand
        self.modelName = modelName
        self.serialNumber = serialNumber
        self.purchaseDateISO = purchaseDateISO
        self.purchasePrice = purchasePrice
        self.currencyCode = currencyCode
        self.detectedCategory = detectedCategory
        self.summaryDescription = summaryDescription
        self.confidenceScore = confidenceScore
        self.providerUsed = providerUsed
    }
}

// MARK: - Diagnostic Request & Response

/// Severity grading for AI diagnostic assessments.
public enum DiagnosticSeverity: String, Sendable, Codable {
    case low = "LOW"
    case medium = "MEDIUM"
    case high = "HIGH"
    case critical = "CRITICAL"
}

/// Payload sent to LLM for predictive maintenance and error code troubleshooting.
public struct AIDiagnosticRequest: Sendable, Codable {
    public let assetDomain: String // "Appliance", "SkiGear", "EBike", "CoffeeMachine"
    public let brand: String
    public let modelName: String
    public let errorCodeOrSymptom: String
    public let currentAgeMonths: Int
    public let historicalTelemetrySummary: String
    public let targetLanguage: String
    
    public init(
        assetDomain: String,
        brand: String,
        modelName: String,
        errorCodeOrSymptom: String,
        currentAgeMonths: Int = 0,
        historicalTelemetrySummary: String = "",
        targetLanguage: String = "en"
    ) {
        self.assetDomain = assetDomain
        self.brand = brand
        self.modelName = modelName
        self.errorCodeOrSymptom = errorCodeOrSymptom
        self.currentAgeMonths = currentAgeMonths
        self.historicalTelemetrySummary = historicalTelemetrySummary
        self.targetLanguage = targetLanguage
    }
}

/// Enforced structured JSON output schema for diagnostic assistance.
public struct AIDiagnosticResponse: Sendable, Codable {
    public let issueTitle: String
    public let probableRootCause: String
    public let severity: DiagnosticSeverity
    public let recommendedActionSteps: [String]
    public let requiresProfessionalService: Bool
    public let estimatedCostRangeCHF: String?
    public let updatedHealthScore: Int
    public let providerUsed: AIProvider
    
    public init(
        issueTitle: String,
        probableRootCause: String,
        severity: DiagnosticSeverity = .low,
        recommendedActionSteps: [String] = [],
        requiresProfessionalService: Bool = false,
        estimatedCostRangeCHF: String? = nil,
        updatedHealthScore: Int = 85,
        providerUsed: AIProvider = .geminiFlash
    ) {
        self.issueTitle = issueTitle
        self.probableRootCause = probableRootCause
        self.severity = severity
        self.recommendedActionSteps = recommendedActionSteps
        self.requiresProfessionalService = requiresProfessionalService
        self.estimatedCostRangeCHF = estimatedCostRangeCHF
        self.updatedHealthScore = updatedHealthScore
        self.providerUsed = providerUsed
    }
}
