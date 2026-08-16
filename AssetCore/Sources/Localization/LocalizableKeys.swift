//
//  LocalizableKeys.swift
//  AssetCoreLocalization
//
//  Created for Nordic Asset Suite.
//  Strict Concurrency: Complete. Type-Safe Localization Keys.
//

import Foundation

/// Type-safe localization keys covering all domains across the Nordic Asset Suite.
public enum LocalizableKey: String, CaseIterable, Sendable {
    // General Actions & Navigation
    case appName = "app_name"
    case save = "action_save"
    case cancel = "action_cancel"
    case close = "action_close"
    case delete = "action_delete"
    case done = "action_done"
    case calculate = "action_calculate"
    case scan = "action_scan"
    case restorePurchases = "action_restore_purchases"
    case subscribeNow = "action_subscribe_now"
    case startTrial = "action_start_trial"
    
    // Appliance Warranty Manager
    case applianceHomeHealth = "appliance_home_health"
    case applianceExpiringSoon = "appliance_expiring_soon"
    case applianceRoomKitchen = "room_kitchen"
    case applianceRoomLaundry = "room_laundry"
    case applianceRoomBathroom = "room_bathroom"
    case applianceRoomBasement = "room_basement"
    case applianceFilterTracking = "appliance_filter_tracking"
    case applianceLogFilter = "appliance_log_filter"
    case applianceScanErrorCode = "appliance_scan_error_code"
    case applianceWarrantyExpires = "appliance_warranty_expires"
    
    // Ski Gear Tracker
    case skiActiveQuiver = "ski_active_quiver"
    case skiSummerVault = "ski_summer_vault"
    case skiISO11088DIN = "ski_iso_11088_din"
    case skiWaxAdvisor = "ski_wax_advisor"
    case skiSnowTemperature = "ski_snow_temperature"
    case skiIronTemperature = "ski_iron_temperature"
    case skiSafetyDisclaimer = "ski_safety_disclaimer"
    case skiSkierType = "ski_skier_type"
    
    // E-Bike Service Tracker
    case ebikeGarageEmpty = "ebike_garage_empty"
    case ebikeTotalOdometer = "ebike_total_odometer"
    case ebikeBatteryHealth = "ebike_battery_health"
    case ebikeChainWearGauge = "ebike_chain_wear_gauge"
    case ebikeChainOptimal = "ebike_chain_optimal"
    case ebikeChainReplace = "ebike_chain_replace"
    case ebikeSuspensionPSI = "ebike_suspension_psi"
    case ebikeRiderWeight = "ebike_rider_weight"
    
    // Coffee Machine Companion
    case coffeeBaristaDeck = "coffee_barista_deck"
    case coffeeWaterHardness = "coffee_water_hardness"
    case coffeeDescaleHorizon = "coffee_descale_horizon"
    case coffeeDialInRecipes = "coffee_dial_in_recipes"
    case coffeeDryDose = "coffee_dry_dose"
    case coffeeLiquidYield = "coffee_liquid_yield"
    case coffeeExtractionTime = "coffee_extraction_time"
    case coffeeGrindSetting = "coffee_grind_setting"
}
