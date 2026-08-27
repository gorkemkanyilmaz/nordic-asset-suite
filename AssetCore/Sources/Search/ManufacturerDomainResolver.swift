//
//  ManufacturerDomainResolver.swift
//  AssetCoreSearch
//
//  Created for Nordic Asset Suite.
//  Strict Concurrency: Complete. Official Manufacturer Domain Resolution & Source Ranking.
//

import Foundation

/// Resolves brand names to authoritative manufacturer web domains.
public final class ManufacturerDomainResolver: Sendable {
    public static let shared = ManufacturerDomainResolver()
    
    private let domainMap: [String: [String]] = [
        "philips": ["philips.com", "philips.ch", "philips.de", "documents.philips.com"],
        "samsung": ["samsung.com", "samsung.ch", "samsung.de"],
        "miele": ["miele.ch", "miele.com", "miele.de"],
        "v-zug": ["vzug.com", "v-zug.ch"],
        "vzug": ["vzug.com", "v-zug.ch"],
        "bosch": ["bosch-home.com", "bosch-home.ch", "bosch-ebike.com"],
        "jura": ["jura.com", "ch.jura.com"],
        "delonghi": ["delonghi.com", "delonghi.ch"],
        "sage": ["sageappliances.com"],
        "scott": ["scott-sports.com"],
        "orbea": ["orbea.com"],
        "specialized": ["specialized.com"],
        "stoeckli": ["stoeckli.ch", "stockli.com"],
        "atomic": ["atomic.com"],
        "salomon": ["salomon.com"],
        "head": ["head.com"]
    ]
    
    private let reputableRetailerDomains: [String] = [
        "galaxus.ch", "digitec.ch", "fust.ch", "mediamarkt.ch", "interdiscount.ch",
        "amazon.de", "mediamarkt.de", "geizhals.de",
        "elgiganten.dk", "power.dk", "pricerunner.dk"
    ]
    
    private init() {}
    
    /// Returns authoritative domains for a given brand name.
    public func resolveDomains(for brand: String) -> [String] {
        let clean = brand.lowercased().trimmingCharacters(in: .whitespaces)
        return domainMap[clean] ?? []
    }
    
    /// Checks if a domain belongs to the official manufacturer for a brand.
    public func isManufacturerDomain(url: URL, brand: String) -> Bool {
        guard let host = url.host?.lowercased() else { return false }
        let domains = resolveDomains(for: brand)
        return domains.contains { host.hasSuffix($0) }
    }
    
    /// Checks if a domain belongs to a reputable regional retailer.
    public func isReputableRetailer(url: URL) -> Bool {
        guard let host = url.host?.lowercased() else { return false }
        return reputableRetailerDomains.contains { host.hasSuffix($0) }
    }
    
    /// Ranks an array of discovered URLs prioritizing manufacturer official pages.
    public func rankUrls(_ urls: [URL], brand: String) -> [URL] {
        return urls.sorted { a, b in
            let aIsMfg = isManufacturerDomain(url: a, brand: brand)
            let bIsMfg = isManufacturerDomain(url: b, brand: brand)
            if aIsMfg != bIsMfg { return aIsMfg && !bIsMfg }
            
            let aIsRetailer = isReputableRetailer(url: a)
            let bIsRetailer = isReputableRetailer(url: b)
            if aIsRetailer != bIsRetailer { return aIsRetailer && !bIsRetailer }
            
            return false
        }
    }
}
