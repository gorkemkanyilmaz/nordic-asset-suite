//
//  SubscriptionProduct.swift
//  AssetCoreSubscription
//
//  Created for Nordic Asset Suite.
//  Strict Concurrency: Complete.
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
