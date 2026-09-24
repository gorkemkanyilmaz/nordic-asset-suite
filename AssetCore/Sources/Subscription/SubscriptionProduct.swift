//
//  SubscriptionProduct.swift
//  AssetCoreSubscription
//
//  Created for Nordic Asset Suite.
//  Strict Concurrency: Complete. StoreKit 2 Ready.
//

import Foundation

/// Product IDs for App Store In-App Purchases across the Nordic Asset Suite.
public enum SubscriptionProductIdentifier: String, CaseIterable, Sendable {
    // 1. Appliance Warranty Manager
    case applianceProMonthly = "com.nordicassetsuite.appliance.pro.monthly"
    case applianceProAnnual = "com.nordicassetsuite.appliance.pro.annual"
    
    // 2. Ski Gear Tracker
    case skiGearProMonthly = "com.nordicassetsuite.skigear.pro.monthly"
    case skiGearProAnnual = "com.nordicassetsuite.skigear.pro.annual"
    
    // 3. E-Bike Service Tracker
    case ebikeProMonthly = "com.nordicassetsuite.ebike.pro.monthly"
    case ebikeProAnnual = "com.nordicassetsuite.ebike.pro.annual"
    
    // 4. Coffee Machine Companion
    case coffeeProMonthly = "com.nordicassetsuite.coffee.pro.monthly"
    case coffeeProAnnual = "com.nordicassetsuite.coffee.pro.annual"
    
    // Universal Suite Bundle
    case nordicSuitePassAnnual = "com.nordicassetsuite.all.pro.annual"
    
    /// Target application or suite indicator
    public var isSuiteBundle: Bool {
        return self == .nordicSuitePassAnnual
    }
}

/// Identifies each application within the Nordic Asset Suite.
public enum NordicAppType: String, CaseIterable, Sendable {
    case appliance
    case skiGear
    case ebike
    case coffee
    
    public var bundleIdentifier: String {
        switch self {
        case .appliance: return "com.nordicassetsuite.appliance"
        case .skiGear: return "com.nordicassetsuite.skigear"
        case .ebike: return "com.nordicassetsuite.ebike"
        case .coffee: return "com.nordicassetsuite.coffee"
        }
    }
    
    public var monthlyProductID: String {
        switch self {
        case .appliance: return SubscriptionProductIdentifier.applianceProMonthly.rawValue
        case .skiGear: return SubscriptionProductIdentifier.skiGearProMonthly.rawValue
        case .ebike: return SubscriptionProductIdentifier.ebikeProMonthly.rawValue
        case .coffee: return SubscriptionProductIdentifier.coffeeProMonthly.rawValue
        }
    }
    
    public var annualProductID: String {
        switch self {
        case .appliance: return SubscriptionProductIdentifier.applianceProAnnual.rawValue
        case .skiGear: return SubscriptionProductIdentifier.skiGearProAnnual.rawValue
        case .ebike: return SubscriptionProductIdentifier.ebikeProAnnual.rawValue
        case .coffee: return SubscriptionProductIdentifier.coffeeProAnnual.rawValue
        }
    }
    
    public var suiteProductID: String {
        return SubscriptionProductIdentifier.nordicSuitePassAnnual.rawValue
    }
    
    /// Returns default fallback localized price strings when offline or running in mock/preview modes.
    public static func defaultPrice(forAnnual: Bool) -> (price: String, period: String, breakdown: String) {
        let localeCode = Locale.current.language.languageCode?.identifier ?? "en"
        let isTurkish = localeCode.starts(with: "tr")
        let isGerman = localeCode.starts(with: "de")
        let isFrench = localeCode.starts(with: "fr")
        
        if isTurkish {
            if forAnnual {
                return (price: "₺499,99 / yıl", period: "7 Gün Ücretsiz Deneme, sonra ₺41,66/ay", breakdown: "Yıllık planda %37 tasarruf")
            } else {
                return (price: "₺79,99 / ay", period: "Aylık esnek ödeme, dilediğin an iptal", breakdown: "Taahhüt yok")
            }
        } else if isGerman {
            if forAnnual {
                return (price: "29,99 € / Jahr", period: "7 Tage kostenlos testen, danach 2,49 €/Monat", breakdown: "37% Ersparnis gegenüber Monatsabo")
            } else {
                return (price: "3,99 € / Monat", period: "Monatlich kündbar", breakdown: "Volle Flexibilität")
            }
        } else if isFrench {
            if forAnnual {
                return (price: "29,99 € / an", period: "7 jours d'essai gratuit, puis 2,49 €/mois", breakdown: "Économisez 37% par rapport au forfait mensuel")
            } else {
                return (price: "3,99 € / mois", period: "Facturation mensuelle sans engagement", breakdown: "Annulable à tout moment")
            }
        } else {
            // Default English (USD / Global)
            if forAnnual {
                return (price: "$29.99 / year", period: "7-Day Free Trial, then $2.49/mo", breakdown: "Save 37% • Less than a coffee per month")
            } else {
                return (price: "$3.99 / month", period: "Flexible monthly billing, cancel anytime", breakdown: "No commitment")
            }
        }
    }
    
    /// Resolves the current app from bundle ID or localized title.
    public static func current(fromBundleId bundleId: String? = Bundle.main.bundleIdentifier, orTitle title: String? = nil) -> NordicAppType {
        let bId = bundleId?.lowercased() ?? ""
        if bId.contains("appliance") { return .appliance }
        if bId.contains("skigear") || bId.contains("ski") { return .skiGear }
        if bId.contains("ebike") || bId.contains("bike") { return .ebike }
        if bId.contains("coffee") { return .coffee }
        
        let t = title?.lowercased() ?? ""
        if t.contains("appliance") || t.contains("garanti") || t.contains("cihaz") { return .appliance }
        if t.contains("ski") || t.contains("kayak") { return .skiGear }
        if t.contains("bike") || t.contains("bisiklet") { return .ebike }
        if t.contains("coffee") || t.contains("kahve") { return .coffee }
        
        return .appliance
    }
}
