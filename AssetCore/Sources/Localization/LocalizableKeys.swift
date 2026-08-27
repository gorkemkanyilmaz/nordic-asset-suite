//
//  LocalizableKeys.swift
//  AssetCoreLocalization
//
//  Created for Nordic Asset Suite.
//  Strict Concurrency: Complete. Type-Safe Localization Keys.
//

import Foundation

/// Type-safe localization keys covering all domains across the four standalone applications.
public enum LocalizableKey: String, CaseIterable, Sendable {
    // General Actions & Navigation
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
    
    // MARK: - Appliance Dashboard
    case greetingMorning = "greeting_morning"
    case greetingAfternoon = "greeting_afternoon"
    case greetingEvening = "greeting_evening"
    case yourHome = "your_home"
    case appliancesCount = "appliances_count"
    case warrantiesActive = "warranties_active"
    case warrantyExpiredCount = "warranty_expired_count"
    case warrantyExpiringCount = "warranty_expiring_count"
    case reviewCoverage = "review_coverage"
    case expiresWithin90Days = "expires_within_90_days"
    case prepareReceipts = "prepare_receipts"
    case allRooms = "all_rooms"
    case noAppliancesRegistered = "no_appliances_registered"
    case scanOrEnterModel = "scan_or_enter_model"
    case loadSampleAppliances = "load_sample_appliances"
    case appliancesTitle = "appliances_title"
    case addAppliance = "add_appliance"
    case warrantyUntil = "warranty_until"
    case warrantyExpired = "warranty_expired"
    
    // MARK: - Add Appliance Scanner
    case smartIngestion = "smart_ingestion"
    case openLiveCamera = "open_live_camera"
    case scansBarcodes = "scans_barcodes"
    case orTypeModelName = "or_type_model_name"
    case identify = "identify"
    case applianceDetails = "appliance_details"
    case brandPlaceholder = "brand_placeholder"
    case modelPlaceholder = "model_placeholder"
    case serialPlaceholder = "serial_placeholder"
    case roomLocation = "room_location"
    case purchaseAndWarranty = "purchase_and_warranty"
    case price = "price"
    case currency = "currency"
    case geminiIdentifying = "gemini_identifying"
    case addAsset = "add_asset"
    case kitchen = "kitchen"
    case livingRoom = "living_room"
    case laundryRoom = "laundry_room"
    case basement = "basement"
    case utilityCloset = "utility_closet"
    case office = "office"
    
    // MARK: - Appliance Detail
    case health = "health"
    case protocolTab = "protocol_tab"
    case spareParts = "spare_parts"
    case warranty = "warranty"
    case aiDiagnostics = "ai_diagnostics"
    case active = "active_status"
    case expired = "expired_status"
    case warrantyExpiration = "warranty_expiration"
    case remainingTime = "remaining_time"
    case purchaseValue = "purchase_value"
    case statutoryNotice = "statutory_notice"
    case statutoryNoticeText = "statutory_notice_text"
    case aiDiagnosticAssistant = "ai_diagnostic_assistant"
    case enterErrorCode = "enter_error_code"
    case diagnose = "diagnose"
    case quickTest = "quick_test"
    case probableRootCause = "probable_root_cause"
    case recommendedActionSteps = "recommended_action_steps"
    case estimatedRepairCost = "estimated_repair_cost"
    case deleteAsset = "delete_asset"
    
    // MARK: - Product Confirmation
    case productDetected = "product_detected"
    case confirmThisMatches = "confirm_this_matches"
    case specifications = "specifications"
    case monthsWarranty = "months_warranty"
    case confirmAndSaveAsset = "confirm_and_save_asset"
    case editDetailsManually = "edit_details_manually"
    case confirmAsset = "confirm_asset"
    
    // MARK: - Interactive Onboarding / Demo
    case howItWorks = "how_it_works"
    case liveCameraScanner = "live_camera_scanner"
    case liveCameraScannerDesc = "live_camera_scanner_desc"
    case geminiAIIdentification = "gemini_ai_identification"
    case geminiAIIdentificationDesc = "gemini_ai_identification_desc"
    case maintenanceManuals = "maintenance_manuals"
    case maintenanceManualsDesc = "maintenance_manuals_desc"
    case sparePartsDiagnostics = "spare_parts_diagnostics"
    case sparePartsDiagnosticsDesc = "spare_parts_diagnostics_desc"
    case tryDemo = "try_demo"
    case gotItLetsStart = "got_it_lets_start"
    case skip = "skip"
    
    // Onboarding tips
    case tipPositionBarcode = "tip_position_barcode"
    case tipToggleTorch = "tip_toggle_torch"
    case tipImportPhotos = "tip_import_photos"
    case tipAutoCompletion = "tip_auto_completion"
    case tipConfirmationCard = "tip_confirmation_card"
    case tipStatutoryWarranty = "tip_statutory_warranty"
    case tipInteractiveChecklists = "tip_interactive_checklists"
    case tipToolRequirements = "tip_tool_requirements"
    case tipSafetyWarnings = "tip_safety_warnings"
    case tipVisualWearBars = "tip_visual_wear_bars"
    case tipLogReplacement = "tip_log_replacement"
    case tipInstantDiagnostic = "tip_instant_diagnostic"
    
    // MARK: - Interactive Demo Bar
    case sampleDevicesAvailable = "sample_devices_available"
    case loadRealisticHardware = "load_realistic_hardware"
    case help = "help"
    case loadSample = "load_sample"
    
    // MARK: - Live Scanner
    case barcodeQR = "barcode_qr"
    case ratingBadge = "rating_badge"
    case receiptInvoice = "receipt_invoice"
    case searchText = "search_text"
    case alignBarcode = "align_barcode"
    case alignRatingPlate = "align_rating_plate"
    case search = "search"
    case liveCameraReady = "live_camera_ready"
    case tapSampleAsset = "tap_sample_asset"
    
    // MARK: - Maintenance Manual
    case maintenanceProtocol = "maintenance_protocol"
    case everyDays = "every_days"
    case tools = "tools"
    case safetyWarnings = "safety_warnings"
    case stepNumber = "step_number"
    
    // MARK: - Spare Parts
    case sparePartsWearSchedule = "spare_parts_wear_schedule"
    case trackedParts = "tracked_parts"
    case estimatedCost = "estimated_cost"
    case intervalDays = "interval_days"
    case replacedToday = "replaced_today"
    case logReplacement = "log_replacement"
    case goodCondition = "good_condition"
    case serviceSoon = "service_soon"
    case overdue = "overdue"
    
    // MARK: - Room Names (for room filter pills)
    case roomAll = "room_all"
    case roomLaundryFull = "room_laundry_full"
    case roomLivingFull = "room_living_full"
    
    // MARK: - Scanner Intake Modes
    case scannerModeBarcode = "scanner_mode_barcode"
    case scannerModeRatingBadge = "scanner_mode_rating_badge"
    case scannerModeReceipt = "scanner_mode_receipt"
    case scannerModeSearch = "scanner_mode_search"
    
    // MARK: - Warranty & Statutory Rights Detail Labels
    case warrantyAndStatutory = "warranty_and_statutory"
    case warrantyPolicy = "warranty_policy"
    case statutoryStandard = "statutory_standard"
    case statutoryRights = "statutory_rights"
    case statutoryConsumerRights = "statutory_consumer_rights"
    case manufacturerWarrantyTitle = "manufacturer_warranty_title"
    case sellerGuaranteeTitle = "seller_guarantee_title"
    case extendedWarrantyTitle = "extended_warranty_title"
    case coverageOverview = "coverage_overview"
    case statutoryObligorSeller = "statutory_obligor_seller"
    case statutoryNoticeDisclaimer = "statutory_notice_disclaimer"
    case activeProtectionCount = "active_protection_count"
    case mfrExpiredStatutoryActive = "mfr_expired_statutory_active"
    case purchaseCountryLabel = "purchase_country_label"
    case deliveryDateLabel = "delivery_date_label"
    case learnMoreOfficialSource = "learn_more_official_source"
    
    // MARK: - Error / fallback
    case failedToSaveAsset = "failed_to_save_asset"
    case failedToSaveAppliance = "failed_to_save_appliance"
    
    // MARK: - Simulator camera
    case freeTextModelSearch = "free_text_model_search"
    case barcodeLabel = "barcode_label"
    case frameSerialLabel = "frame_serial_label"
    
    // MARK: - Localized App Store / UI Application Names
    case applianceWarrantyManager = "appliance_warranty_manager"
    case coffeeBrewEspressoLog = "coffee_brew_espresso_log"
    case ebikeServiceMaintenance = "ebike_service_maintenance"
    case skiSnowboardTuning = "ski_snowboard_tuning"
}
