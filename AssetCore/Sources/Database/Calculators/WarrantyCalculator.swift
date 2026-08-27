//
//  WarrantyCalculator.swift
//  AssetCoreDatabase
//
//  Created for Nordic Asset Suite.
//  Strict Concurrency: Complete. Multi-Layer Statutory Rights & Commercial Warranty Engine.
//

import Foundation

// MARK: - Legal & Warranty Enums

public enum LegalJurisdiction: String, Codable, Sendable, CaseIterable {
    case switzerland = "CH"
    case denmark = "DK"
    case austria = "AT"
    case norway = "NO"
    case sweden = "SE"
    case unknown = "UNKNOWN"
    case reviewRequired = "REVIEW_REQUIRED"
    
    public var displayName: String {
        switch self {
        case .switzerland: return "Switzerland (CH)"
        case .denmark: return "Denmark (DK)"
        case .austria: return "Austria (AT)"
        case .norway: return "Norway (NO)"
        case .sweden: return "Sweden (SE)"
        case .unknown: return "Unknown Jurisdiction"
        case .reviewRequired: return "Cross-Border / Review Required"
        }
    }
}

public enum CoverageType: String, Codable, Sendable {
    case statutoryRight = "STATUTORY_RIGHT"
    case manufacturerWarranty = "MANUFACTURER_WARRANTY"
    case sellerGuarantee = "SELLER_GUARANTEE"
    case extendedWarranty = "EXTENDED_WARRANTY"
    case insurance = "INSURANCE"
    case unknown = "UNKNOWN"
}

public enum CoverageStatus: String, Codable, Sendable {
    case active = "ACTIVE"
    case expiringSoon = "EXPIRING_SOON"
    case expired = "EXPIRED"
    case unverified = "UNVERIFIED"
    case notApplicable = "NOT_APPLICABLE"
    case unknown = "UNKNOWN"
}

public enum SourceConfidence: String, Codable, Sendable {
    case verified = "VERIFIED"
    case supported = "SUPPORTED"
    case userProvided = "USER_PROVIDED"
    case unverified = "UNVERIFIED"
    case unknown = "UNKNOWN"
}

// MARK: - Coverage Layer DTO

public struct CoverageLayerDTO: Sendable, Identifiable, Codable {
    public let id: String
    public let type: CoverageType
    public let titleKey: String
    public let titleLocalizedFallback: String
    public let provider: String
    public let obligorType: String // "SELLER", "MANUFACTURER", "THIRD_PARTY"
    public let startDate: Date?
    public let endDate: Date?
    public let status: CoverageStatus
    public let daysRemaining: Int?
    public let durationMonths: Int?
    public let sourceName: String
    public let sourceUrl: String?
    public let legalDisclaimerKey: String?
    public let confidence: SourceConfidence
    
    public init(
        id: String = UUID().uuidString,
        type: CoverageType,
        titleKey: String,
        titleLocalizedFallback: String,
        provider: String,
        obligorType: String,
        startDate: Date?,
        endDate: Date?,
        status: CoverageStatus,
        daysRemaining: Int?,
        durationMonths: Int?,
        sourceName: String,
        sourceUrl: String? = nil,
        legalDisclaimerKey: String? = nil,
        confidence: SourceConfidence = .verified
    ) {
        self.id = id
        self.type = type
        self.titleKey = titleKey
        self.titleLocalizedFallback = titleLocalizedFallback
        self.provider = provider
        self.obligorType = obligorType
        self.startDate = startDate
        self.endDate = endDate
        self.status = status
        self.daysRemaining = daysRemaining
        self.durationMonths = durationMonths
        self.sourceName = sourceName
        self.sourceUrl = sourceUrl
        self.legalDisclaimerKey = legalDisclaimerKey
        self.confidence = confidence
    }
}

// MARK: - Warranty Summary DTO

public struct WarrantySummaryDTO: Sendable, Codable {
    public let statutoryProtection: CoverageLayerDTO?
    public let manufacturerWarranty: CoverageLayerDTO?
    public let sellerGuarantee: CoverageLayerDTO?
    public let extendedWarranty: CoverageLayerDTO?
    public let insuranceProtection: CoverageLayerDTO?
    
    public init(
        statutoryProtection: CoverageLayerDTO? = nil,
        manufacturerWarranty: CoverageLayerDTO? = nil,
        sellerGuarantee: CoverageLayerDTO? = nil,
        extendedWarranty: CoverageLayerDTO? = nil,
        insuranceProtection: CoverageLayerDTO? = nil
    ) {
        self.statutoryProtection = statutoryProtection
        self.manufacturerWarranty = manufacturerWarranty
        self.sellerGuarantee = sellerGuarantee
        self.extendedWarranty = extendedWarranty
        self.insuranceProtection = insuranceProtection
    }
    
    public var allLayers: [CoverageLayerDTO] {
        return [statutoryProtection, manufacturerWarranty, sellerGuarantee, extendedWarranty, insuranceProtection].compactMap { $0 }
    }
    
    public var hasActiveProtection: Bool {
        return allLayers.contains { $0.status == .active || $0.status == .expiringSoon }
    }
    
    public var isAttentionRequired: Bool {
        return allLayers.contains { $0.status == .expiringSoon }
    }
    
    public var primaryAlertStatus: CoverageStatus {
        if allLayers.contains(where: { $0.status == .expiringSoon }) { return .expiringSoon }
        if hasActiveProtection { return .active }
        if allLayers.contains(where: { $0.status == .expired }) { return .expired }
        return .unknown
    }
}

// MARK: - Central Multi-Layer Warranty & Statutory Calculator

public struct WarrantyCalculator: Sendable {
    
    public static let shared = WarrantyCalculator()
    
    public init() {}
    
    /// Evaluates multi-layer coverage deterministically.
    public func calculateCoverage(
        purchaseDate: Date?,
        deliveryDate: Date?,
        purchaseCountry: String,
        brand: String,
        category: String,
        conditionAtPurchase: String = "NEW",
        sellerType: String = "BUSINESS",
        buyerType: String = "CONSUMER",
        manufacturerWarrantyMonths: Int? = nil,
        sellerGuaranteeMonths: Int? = nil,
        extendedWarrantyMonths: Int? = nil,
        currentDate: Date = Date()
    ) -> WarrantySummaryDTO {
        
        let jurisdiction = LegalJurisdiction(rawValue: purchaseCountry.uppercased()) ?? .switzerland
        let isConsumer = buyerType.uppercased() != "BUSINESS"
        let isBusinessSeller = sellerType.uppercased() != "PRIVATE"
        
        // 1. Calculate Statutory Defect Rights (Against Seller)
        var statutoryLayer: CoverageLayerDTO? = nil
        
        if isConsumer && isBusinessSeller && jurisdiction != .unknown && jurisdiction != .reviewRequired {
            let startEvDate = deliveryDate ?? purchaseDate
            
            if let startDate = startEvDate {
                let (durationMonths, titleKey, fallbackTitle, sourceName, sourceUrl) = getStatutoryRule(jurisdiction: jurisdiction, category: category)
                
                let calendar = Calendar(identifier: .gregorian)
                if let endDate = calendar.date(byAdding: .month, value: durationMonths, to: startDate) {
                    let diffDays = calendar.dateComponents([.day], from: calendar.startOfDay(for: currentDate), to: calendar.startOfDay(for: endDate)).day ?? 0
                    
                    let status: CoverageStatus
                    if diffDays < 0 {
                        status = .expired
                    } else if diffDays <= 30 {
                        status = .expiringSoon
                    } else {
                        status = .active
                    }
                    
                    statutoryLayer = CoverageLayerDTO(
                        id: "statutory-\(jurisdiction.rawValue)",
                        type: .statutoryRight,
                        titleKey: titleKey,
                        titleLocalizedFallback: fallbackTitle,
                        provider: "Seller (under \(sourceName))",
                        obligorType: "SELLER",
                        startDate: startDate,
                        endDate: endDate,
                        status: status,
                        daysRemaining: max(0, diffDays),
                        durationMonths: durationMonths,
                        sourceName: sourceName,
                        sourceUrl: sourceUrl,
                        legalDisclaimerKey: "statutory_notice_disclaimer",
                        confidence: .verified
                    )
                }
            } else {
                let (_, titleKey, fallbackTitle, sourceName, sourceUrl) = getStatutoryRule(jurisdiction: jurisdiction, category: category)
                statutoryLayer = CoverageLayerDTO(
                    id: "statutory-\(jurisdiction.rawValue)-unverified",
                    type: .statutoryRight,
                    titleKey: titleKey,
                    titleLocalizedFallback: fallbackTitle,
                    provider: "Seller (under \(sourceName))",
                    obligorType: "SELLER",
                    startDate: nil,
                    endDate: nil,
                    status: .unverified,
                    daysRemaining: nil,
                    durationMonths: nil,
                    sourceName: sourceName,
                    sourceUrl: sourceUrl,
                    legalDisclaimerKey: "statutory_notice_disclaimer",
                    confidence: .unverified
                )
            }
        } else if jurisdiction == .reviewRequired {
            statutoryLayer = CoverageLayerDTO(
                id: "statutory-review-required",
                type: .statutoryRight,
                titleKey: "statutory_cross_border_review",
                titleLocalizedFallback: "Cross-Border / Applicable Terms Review Required",
                provider: "Seller / Applicable Contract",
                obligorType: "SELLER",
                startDate: nil,
                endDate: nil,
                status: .unknown,
                daysRemaining: nil,
                durationMonths: nil,
                sourceName: "EU / National Cross-Border Framework",
                sourceUrl: nil,
                legalDisclaimerKey: "statutory_cross_border_disclaimer",
                confidence: .unverified
            )
        }
        
        // 2. Calculate Manufacturer Warranty (Voluntary Commitment from Manufacturer)
        var mfrLayer: CoverageLayerDTO? = nil
        if let mfrMonths = manufacturerWarrantyMonths, mfrMonths > 0 {
            if let pDate = purchaseDate {
                let calendar = Calendar(identifier: .gregorian)
                if let endDate = calendar.date(byAdding: .month, value: mfrMonths, to: pDate) {
                    let diffDays = calendar.dateComponents([.day], from: calendar.startOfDay(for: currentDate), to: calendar.startOfDay(for: endDate)).day ?? 0
                    
                    let status: CoverageStatus
                    if diffDays < 0 {
                        status = .expired
                    } else if diffDays <= 30 {
                        status = .expiringSoon
                    } else {
                        status = .active
                    }
                    
                    mfrLayer = CoverageLayerDTO(
                        id: "mfr-warranty",
                        type: .manufacturerWarranty,
                        titleKey: "manufacturer_warranty_title",
                        titleLocalizedFallback: "Manufacturer Commercial Warranty",
                        provider: brand.isEmpty ? "Manufacturer" : brand,
                        obligorType: "MANUFACTURER",
                        startDate: pDate,
                        endDate: endDate,
                        status: status,
                        daysRemaining: max(0, diffDays),
                        durationMonths: mfrMonths,
                        sourceName: "Official Manufacturer Policy",
                        sourceUrl: nil,
                        legalDisclaimerKey: nil,
                        confidence: .verified
                    )
                }
            } else {
                mfrLayer = CoverageLayerDTO(
                    id: "mfr-warranty-nodate",
                    type: .manufacturerWarranty,
                    titleKey: "manufacturer_warranty_title",
                    titleLocalizedFallback: "Manufacturer Commercial Warranty",
                    provider: brand.isEmpty ? "Manufacturer" : brand,
                    obligorType: "MANUFACTURER",
                    startDate: nil,
                    endDate: nil,
                    status: .unverified,
                    daysRemaining: nil,
                    durationMonths: mfrMonths,
                    sourceName: "Official Manufacturer Policy",
                    sourceUrl: nil,
                    legalDisclaimerKey: nil,
                    confidence: .unverified
                )
            }
        }
        
        // 3. Calculate Seller Guarantee (Optional)
        var sellerLayer: CoverageLayerDTO? = nil
        if let sMonths = sellerGuaranteeMonths, sMonths > 0, let pDate = purchaseDate {
            let calendar = Calendar(identifier: .gregorian)
            if let endDate = calendar.date(byAdding: .month, value: sMonths, to: pDate) {
                let diffDays = calendar.dateComponents([.day], from: calendar.startOfDay(for: currentDate), to: calendar.startOfDay(for: endDate)).day ?? 0
                let status: CoverageStatus = diffDays < 0 ? .expired : (diffDays <= 30 ? .expiringSoon : .active)
                
                sellerLayer = CoverageLayerDTO(
                    id: "seller-guarantee",
                    type: .sellerGuarantee,
                    titleKey: "seller_guarantee_title",
                    titleLocalizedFallback: "Seller Commercial Guarantee",
                    provider: "Retailer / Seller",
                    obligorType: "SELLER",
                    startDate: pDate,
                    endDate: endDate,
                    status: status,
                    daysRemaining: max(0, diffDays),
                    durationMonths: sMonths,
                    sourceName: "Retailer Terms of Sale",
                    confidence: .userProvided
                )
            }
        }
        
        // 4. Calculate Extended Warranty (Optional)
        var extLayer: CoverageLayerDTO? = nil
        if let extMonths = extendedWarrantyMonths, extMonths > 0, let pDate = purchaseDate {
            let baseMonths = manufacturerWarrantyMonths ?? 24
            let totalMonths = baseMonths + extMonths
            let calendar = Calendar(identifier: .gregorian)
            if let endDate = calendar.date(byAdding: .month, value: totalMonths, to: pDate) {
                let diffDays = calendar.dateComponents([.day], from: calendar.startOfDay(for: currentDate), to: calendar.startOfDay(for: endDate)).day ?? 0
                let status: CoverageStatus = diffDays < 0 ? .expired : (diffDays <= 30 ? .expiringSoon : .active)
                
                extLayer = CoverageLayerDTO(
                    id: "extended-warranty",
                    type: .extendedWarranty,
                    titleKey: "extended_warranty_title",
                    titleLocalizedFallback: "Extended Commercial Warranty",
                    provider: "Warranty Extension Provider",
                    obligorType: "THIRD_PARTY",
                    startDate: pDate,
                    endDate: endDate,
                    status: status,
                    daysRemaining: max(0, diffDays),
                    durationMonths: totalMonths,
                    sourceName: "Extended Protection Contract",
                    confidence: .userProvided
                )
            }
        }
        
        return WarrantySummaryDTO(
            statutoryProtection: statutoryLayer,
            manufacturerWarranty: mfrLayer,
            sellerGuarantee: sellerLayer,
            extendedWarranty: extLayer,
            insuranceProtection: nil
        )
    }
    
    private func getStatutoryRule(jurisdiction: LegalJurisdiction, category: String) -> (months: Int, titleKey: String, fallbackTitle: String, sourceName: String, sourceUrl: String) {
        let catLower = category.toLowerCase()
        let isDurable = catLower.contains("refrigerator") || catLower.contains("fridge") || catLower.contains("washing") || catLower.contains("washer") || catLower.contains("dryer") || catLower.contains("dishwasher") || catLower.contains("oven") || catLower.contains("television") || catLower.contains("tv")
        
        switch jurisdiction {
        case .switzerland:
            return (
                24,
                "statutory_concept_gewahrleistung_ch",
                "Gesetzliche Gewährleistung / Mängelrechte (CH)",
                "Swiss Code of Obligations (OR Art. 210) / SECO",
                "https://www.seco.admin.ch/de/probleme-nach-dem-kauf"
            )
        case .denmark:
            return (
                24,
                "statutory_concept_reklamationsret_dk",
                "2 års reklamationsret (DK)",
                "Danish Sale of Goods Act (Købeloven §§ 54, 83) / Forbrug.dk",
                "https://forbrug.dk/english-consumer-rights-in-denmark/two-year-legal-warranty"
            )
        case .austria:
            return (
                24,
                "statutory_concept_gewahrleistung_at",
                "Gesetzliche Gewährleistung (AT)",
                "Austrian Consumer Warranty Act (VGG / ABGB) / oesterreich.gv.at",
                "https://www.oesterreich.gv.at/de/themen/gesetze_und_recht/verbraucherschutz/Gewaehrleistung-und-Verbraucherschutz"
            )
        case .norway:
            let months = isDurable ? 60 : 24
            return (
                months,
                isDurable ? "statutory_concept_reklamasjonsrett_no_5yr" : "statutory_concept_reklamasjonsrett_no_2yr",
                isDurable ? "5 års reklamasjonsrett (NO)" : "2 års reklamasjonsrett (NO)",
                "Norwegian Consumer Purchases Act (Forbrukerkjøpsloven § 27) / Forbrukerrådet",
                "https://lovdata.no/nav/lov/2002-06-21-34/kap6/%C2%A727"
            )
        case .sweden:
            return (
                36,
                "statutory_concept_reklamationsratt_se",
                "3 års reklamationsrätt (SE)",
                "Swedish Consumer Sales Act (Konsumentköplagen) / Konsumentverket",
                "https://www.konsumentverket.se/en/articles/warranty/"
            )
        case .unknown, .reviewRequired:
            return (
                24,
                "statutory_concept_general",
                "Statutory Consumer Rights",
                "Applicable National / EU Consumer Law",
                "https://commission.europa.eu"
            )
        }
    }
}

private extension String {
    func toLowerCase() -> String {
        return self.lowercased()
    }
}
