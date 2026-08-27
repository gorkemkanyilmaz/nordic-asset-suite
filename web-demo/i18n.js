// ==============================================================================
// NORDIC ASSET SUITE - 8-LANGUAGE INTERNATIONALIZATION (i18n) ENGINE
// Supported: Dansk (da), Svenska (sv), Norsk (no), Deutsch (de), Français (fr),
//            Italiano (it), English (en), Türkçe (tr)
// ==============================================================================

export const SUPPORTED_LANGUAGES = {
  da: { code: 'da', flag: '🇩🇰', name: 'Dansk', region: 'Danmark', defaultCurrency: 'EUR' },
  sv: { code: 'sv', flag: '🇸🇪', name: 'Svenska', region: 'Sverige', defaultCurrency: 'SEK' },
  no: { code: 'no', flag: '🇳🇴', name: 'Norsk', region: 'Norge', defaultCurrency: 'NOK' },
  de: { code: 'de', flag: '🇩🇪', name: 'Deutsch', region: 'DACH (CH/DE/AT)', defaultCurrency: 'EUR' },
  fr: { code: 'fr', flag: '🇫🇷', name: 'Français', region: 'Suisse / France / Belgique', defaultCurrency: 'CHF' },
  it: { code: 'it', flag: '🇮🇹', name: 'Italiano', region: 'Svizzera / Italia', defaultCurrency: 'CHF' },
  en: { code: 'en', flag: '🇬🇧', name: 'English', region: 'Global / UK / US', defaultCurrency: 'USD' },
  tr: { code: 'tr', flag: '🇹🇷', name: 'Türkçe', region: 'Türkiye', defaultCurrency: 'TRY' }
};

export const I18N_DICTIONARY = {
  // ==================== 1. ENGLISH (en) ====================
  en: {
    settings_group_legal: 'LEGAL, PRIVACY & SUPPORT',
    settings_privacy_title: 'Privacy Policy',
    settings_privacy_sub: 'On-device storage, zero tracking, GDPR & Swiss FADP compliance',
    settings_terms_title: 'Terms of Use (EULA)',
    settings_terms_sub: 'Warranty disclaimers, safety guidelines & Apple standard EULA',
    settings_support_title: 'Contact Support & Diagnostics',
    settings_support_sub: 'Email help desk, system telemetry & hardware FAQ',
    settings_erase_title: 'Erase All Local Data & Reset',
    settings_erase_sub: 'Permanently delete all stored portfolio assets and custom settings',
    legal_privacy_modal_title: 'Privacy Policy & Data Transparency',
    legal_privacy_intro: 'Nordic Asset Suite is built on a strict local-first privacy architecture. We believe your household and hardware records belong solely to you.',
    legal_privacy_sec1_title: '1. Local-First On-Device Storage',
    legal_privacy_sec1_body: 'All your appliance data, serial numbers, purchase dates, warranty policies, and coffee/bike/ski maintenance records are stored locally on your device. We do not sell, rent, monetize, or broker your personal data to any third party or advertiser.',
    legal_privacy_sec2_title: '2. Camera, Photos & Rating Plate OCR',
    legal_privacy_sec2_body: 'When you use our camera or photo scanner to identify model numbers and serials, images are analyzed on-demand for text extraction and clean product identification. Raw photos are not permanently stored on external tracking servers.',
    legal_privacy_sec3_title: '3. Third-Party Search & AI Services',
    legal_privacy_sec3_body: 'When researching unknown hardware specs, queries are routed through encrypted API endpoints (Gemini Vision and Tavily Search) to retrieve verified manufacturer specifications. No personally identifiable information (PII) is transmitted.',
    legal_privacy_sec4_title: '4. GDPR, CCPA & Swiss FADP Rights',
    legal_privacy_sec4_body: 'You have full rights to inspect, export, or permanently erase all your data at any time using the Erase Data option in Settings. Deleting the application also removes all local database records.',
    legal_privacy_sec5_title: '5. Privacy Contact',
    legal_privacy_sec5_body: 'For questions regarding data practices or privacy compliance, contact our Data Protection Officer at privacy@nordicasset.app.',
    legal_terms_modal_title: 'Terms of Use & Standard EULA',
    legal_terms_intro: 'Please review these Terms of Use and End User License Agreement (EULA) before using Nordic Asset Suite.',
    legal_terms_sec1_title: '1. Standard Apple Licensed Application EULA',
    legal_terms_sec1_body: 'Your license to use this application is governed by Apple\'s Standard EULA terms (available at apple.com/legal/internet-services/itunes/dev/stdeula/) and these supplemental provisions.',
    legal_terms_sec2_title: '2. Informational Warranty Tracking Disclaimer',
    legal_terms_sec2_body: 'Warranty expiration dates and statutory coverage periods (such as Swiss CO Art. 210, EU Directive 2019/771, or manufacturer policies) are calculated based on user input and public records. They serve strictly as informational aids and do not constitute an insurance contract, financial guarantee, or legal representation.',
    legal_terms_sec3_title: '3. Maintenance & DIY Safety Disclaimer',
    legal_terms_sec3_body: 'Cleaning protocols, part replacement schedules, e-bike tuning, and ski DIN calculator outputs are recommendations based on industry guidelines. Users assume sole responsibility for physical hardware servicing, electrical safety, and sports equipment adjustments.',
    legal_terms_sec4_title: '4. Trademarks & Intellectual Property',
    legal_terms_sec4_body: 'All brand names, trademarks, and model identifiers (including Siemens, Miele, Jura, DeLonghi, Bosch, Scott, Specialized, Stöckli, and others) are the property of their respective trademark holders. Nordic Asset Suite is an independent utility.',
    legal_terms_sec5_title: '5. Governing Law & Jurisdiction',
    legal_terms_sec5_body: 'These terms are governed by the laws of Switzerland, with jurisdiction in Zurich, Switzerland.',
    legal_support_modal_title: 'Customer Support & System Diagnostics',
    legal_support_intro: 'Need assistance or have technical feedback? Our Swiss engineering team is here to help.',
    legal_support_email_label: 'Direct Support Email',
    legal_support_version_label: 'Application Build',
    legal_support_diag_btn: 'Copy System Diagnostic Report',
    legal_support_faq_title: 'Frequently Asked Questions',
    legal_support_faq1_q: 'How are warranty expiration dates calculated?',
    legal_support_faq1_a: 'By combining your entered purchase date with the verified manufacturer warranty duration or statutory legal framework (e.g. 24 months standard).',
    legal_support_faq2_q: 'Are rating plate photos saved to the cloud?',
    legal_support_faq2_a: 'No. OCR model and serial number detection is ephemeral and evaluated on-demand without persistent external storage.',
    legal_support_faq3_q: 'Can I export or transfer my portfolio?',
    legal_support_faq3_a: 'Yes, your data is stored in standard structured format and can be backed up or transferred via iCloud backup.',
    legal_erase_confirm_prompt: 'Are you sure you want to permanently erase all portfolio assets, warranty logs, and custom settings? This action cannot be undone.',
    legal_erase_toast_success: 'All local data and portfolio assets have been completely erased.',

    notif_log_title: 'Scheduled Warranty & Service Alerts',
    notif_log_desc: 'All notifications are evaluated locally on-device. Below is your active warranty protection schedule:',
    notif_empty_desc: 'No active hardware found. Add assets to populate scheduled warranty alerts.',
    notif_asset_label: 'Asset',
    notif_settings_group: 'WARRANTY & SERVICE NOTIFICATIONS',
    notif_settings_warranty_title: 'Warranty Expiry Reminders',
    notif_settings_warranty_desc: 'Notify 30 days, 7 days, and 1 day before statutory warranty cutoff',
    notif_settings_maint_title: 'Maintenance & Service Reminders',
    notif_settings_maint_desc: 'Descaling, filter replacements, and tuning intervals',
    notif_settings_timeline: 'View Scheduled Alert Timeline',
    notif_prompt_title: 'Enable Warranty Protection Alerts',
    notif_prompt_desc: 'Nordic Asset Suite protects your household investment by delivering timely local alerts before coverage terminates:',
    notif_prompt_30d: '30 Days Before Expiry: Early notification to schedule inspections or file repair claims.',
    notif_prompt_7d: '7 Days Before Expiry: Urgent final claim window alert.',
    notif_prompt_1d: '24 Hours Before Expiry: Final expiration notice.',
    notif_prompt_maint: 'Routine Maintenance: Descaling, filter cleaning, and service prompts.',
    notif_btn_allow: 'Allow Notifications',
    notif_btn_later: 'Maybe Later',
    notif_toast_warranty_enabled: 'Warranty expiry reminders enabled (30d, 7d, 1d).',
    notif_toast_warranty_disabled: 'Warranty expiry reminders disabled.',
    notif_toast_maint_enabled: 'Maintenance service reminders enabled.',
    notif_toast_maint_disabled: 'Maintenance service reminders disabled.',
    notif_toast_permission_granted: 'Local notification alerts enabled!',
    notif_toast_permission_denied: 'Notification permission not granted.',
    notif_warranty_30d_title: '30-Day Warranty Expiry Notice',
    notif_warranty_30d_msg: 'Statutory legal warranty for {asset} expires on {date}. Review hardware condition to submit claims in time.',
    notif_warranty_7d_title: '7-Day Critical Expiry Deadline',
    notif_warranty_7d_msg: 'Only 7 days remaining before statutory coverage ends for {asset}. Final service inspection recommended.',
    notif_warranty_1d_title: '24-Hour Final Expiration Notice',
    notif_warranty_1d_msg: 'Statutory warranty for {asset} terminates tomorrow ({date}).',
    notif_part_renewal_title: 'Part Renewal ({percent}% Wear): {part}',
    notif_part_renewal_msg: 'OEM {pno} scheduled service interval: {interval}. Target replacement date: {date}.',
    notif_maintenance_title: 'Service Due: {step}',
    notif_maintenance_msg: '{detail} (Scheduled Frequency: {freq})',
    notif_test_triggered: 'Triggered test notification for {asset}!',

    status_expiring_soon: 'Expiring Soon',
    status_no_date: 'No Date Set',
    stat_within_90_days: 'Within 90 Days',
    attention_expired_one: '1 warranty has expired',
    attention_expired_plural: '{count} warranties have expired',
    attention_expiring_one: '1 warranty expiring soon',
    attention_expiring_plural: '{count} warranties expiring soon',
    attention_combined_alert: '{expired} expired · {expiring} expiring soon',
    drawer_expiring_soon: 'Expiring Soon',
    drawer_user_purchase_price: 'User Purchase Price',
    drawer_estimated_market_value: 'Estimated Market Value',
    not_specified: 'Not specified',
    statutory_protection_title: 'Statutory Legal Protection',
    statutory_rights_title: 'Statutory Consumer Rights',
    statutory_consumer_rights: 'Statutory Defect Rights (Legal)',
    manufacturer_warranty_title: 'Manufacturer Commercial Warranty',
    seller_guarantee_title: 'Seller Commercial Guarantee',
    extended_warranty_title: 'Extended Commercial Warranty',
    coverage_overview: 'Protection & Coverage Overview',
    statutory_obligor_seller: 'Claim Obligor: Seller / Retailer',
    statutory_notice_disclaimer: 'General consumer-rights summary. Actual claims depend on seller terms and defect circumstances.',
    active_protection_count: '{total} appliances · {active} with active protection',
    mfr_expired_statutory_active: 'Manufacturer warranty expired · Statutory defect rights may still apply',
    purchase_country_label: 'Purchase Country / Jurisdiction',
    delivery_date_label: 'Delivery / Handover Date',
    learn_more_official_source: 'Official Legal Source',
    jurisdiction_ch: 'Switzerland (CH - OR Art. 210)',
    jurisdiction_dk: 'Denmark (DK - 2 års reklamationsret)',
    jurisdiction_at: 'Austria (AT - Gewährleistung VGG)',
    jurisdiction_no: 'Norway (NO - 5/2 års reklamasjonsrett)',
    jurisdiction_se: 'Sweden (SE - 3 års reklamationsrätt)',
    jurisdiction_eu: 'EU / Other (Review Required)',
    jurisdiction_unknown: 'Unknown / Not Specified',
    user_coverage_title: 'Your Active Coverage',

    drawer_warranty_status_label: 'PROTECTION OVERVIEW',
    drawer_warranty_desc: 'Statutory consumer defect rights and manufacturer commercial warranties evaluated independently.',
    drawer_purchase_date_label_short: 'Purchase Date',
    drawer_delivery_date_label_short: 'Delivery Date',
    drawer_warranty_policy_label_short: 'Mfr. Warranty Policy',
    drawer_purchase_price_label_short: 'Purchase Price',
    detail_nav_title: 'Asset Details',
    detail_manual_summary: 'Maintenance protocol recommended by manufacturer.',
    drawer_diag_prompt: 'Hardware error code / symptom:',
    drawer_diag_placeholder: 'e.g. E24, F10, Error 107...',
    drawer_diag_btn: 'Diagnose',
    confirm_serial_badge: 'Serial',

    add_placeholder_appliance: 'e.g. Siemens KG86PFIC0N, Miele W1, Dyson V15, DeLonghi Toaster...',
    add_placeholder_coffee: 'e.g. DeLonghi Magnifica Plus, Sage Barista Touch, Jura E8, Philips LatteGo...',
    add_placeholder_ebike: 'e.g. Scott Patron eRIDE, Specialized Turbo Levo, Trek Rail 9.8...',
    add_placeholder_skigear: 'e.g. Stöckli Laser SL, Atomic Redster S9, Head Worldcup Rebels...',
    promo_line1: 'Protect your household assets with statutory warranty tracking.',
    promo_line2: 'Scan rating plates for instant error codes and maintenance schedules.',
    mo_policy: 'mo. policy',
    statutory_standard: 'Statutory Standard',
    coffee_btn_brew_log: 'Taste Journal & Dial-in',
    coffee_btn_brew_again: 'Dial In Recipe',
    coffee_ratio_label: 'Brew Ratio',
    coffee_btn_start_timer: 'Extraction Timer',
    coffee_extraction_notes_fallback: 'Balanced & sweet extraction profile',
    coffee_grinder_step: 'Grind Setting: Step {step}',
    ebike_empty_title: 'No E-Bike Paired',
    ebike_empty_desc: 'Add your electric bicycle or drivetrain to track battery health, motor telemetry, and chain wear.',
    ebike_btn_add: 'Add E-Bike',
    ski_empty_title: 'No Alpine Skis in Quiver',
    ski_empty_desc: 'Add your alpine skis or snowboards to calculate ISO 11088 DIN release and track edge wax cycles.',
    ski_btn_add: 'Add Ski Gear',
    tour_step_prefix: 'Step {current} of {total}',
    tour_btn_back: 'Back',
    tour_btn_skip: 'Skip Tour',
    tour_btn_start: 'Get Started',
    tour_btn_next: 'Next',
    brand_appliance: 'Appliance Warranty',
    brand_coffee: 'Coffee Companion',
    brand_ebike: 'E-Bike Service',
    brand_skigear: 'Ski Gear Tracker',
    nav_home: 'Home',
    nav_appliances: 'Appliances',
    nav_add: 'Add',
    nav_warranties: 'Warranties',
    nav_settings: 'Settings',
    nav_today: 'Today',
    nav_recipes: 'Recipes',
    nav_machine: 'Machine',
    nav_ride: 'Ride',
    nav_bike: 'Bike',
    nav_parts: 'Parts',
    nav_quiver: 'Quiver',
    nav_setup: 'Setup',
    nav_tuning: 'Tuning',
    rooms_all: 'All',
    rooms_kitchen: 'Kitchen',
    rooms_living: 'Living Room',
    rooms_laundry: 'Laundry Room',
    rooms_bedroom: 'Bedroom',
    rooms_bathroom: 'Bathroom',
    rooms_office: 'Home Office',
    rooms_dining: 'Dining Room',
    rooms_hallway: 'Hallway Closet',
    rooms_garage: 'Garage',
    rooms_skilocker: 'Ski Locker',
    rooms_basement: 'Basement',
    rooms_balcony: 'Balcony / Garden',
    status_active: 'ACTIVE',
    status_expired: 'EXPIRED',
    status_expiring_soon: 'EXPIRING SOON',
    stat_items: 'Items Registered',
    stat_protected: 'Active Warranties',
    stat_expiring: 'Expiring Soon',
    stat_expired: 'Expired',
    attention_expired_one: '1 warranty expired',
    attention_all_ok: 'All {count} appliances protected under warranty',
    empty_appliance_title: 'No Appliances Registered',
    empty_appliance_desc: 'Add your first home appliance to track warranty, maintenance, and serial records.',
    btn_add_appliance: 'Add Appliance',
    expires_on: 'Expires: {date}',
    add_purchase_date: 'Add purchase date',
    drawer_tab_specs: 'Technical Specs',
    drawer_tab_maintenance: 'Maintenance & Care',
    drawer_tab_parts: 'Spare Parts & Wear',
    drawer_tab_diagnostics: 'Diagnostics',
    drawer_purchase_date_label: 'Purchase Date (Auto-calculates warranty cutoff):',
    drawer_policy_label: 'Statutory / Manufacturer Warranty Duration:',
    drawer_price_label: 'Purchase Price (Replacement Asset Valuation):',
    drawer_est_oem_cost: 'Est. OEM Cost:',
    drawer_btn_replace: 'Log Replacement',
    drawer_btn_delete: 'Delete Asset from Portfolio',
    drawer_delete_confirm: 'Are you sure you want to delete "{name}"? This action cannot be undone.',
    wear_optimal: 'Optimal Condition',
    wear_moderate: 'Moderate Wear',
    wear_due_soon: 'Replacement Due Soon',
    wear_overdue: 'Replacement Overdue',
    freq_daily: 'Daily',
    freq_weekly: 'Weekly',
    freq_monthly: 'Monthly',
    freq_every_60: 'Every 60 Days',
    freq_every_90: 'Every 90 Days',
    freq_every_150km: 'Every 150 km',
    freq_every_4skidays: 'Every 4 Ski Days',
    settings_header: 'Preferences & Regional Data',
    settings_lang_label: 'Language / Sprache / Sprog / Språk',
    settings_lang_sub: 'Nordic & European native interface translation',
    settings_currency_label: 'Currency Format',
    settings_currency_sub: 'Applied across asset values, parts & market prices',
    settings_statutory_label: 'Statutory Legal Warranty',
    settings_statutory_sub: 'Default policy duration for standard appliances',
    settings_tour_label: 'Guided Onboarding Tour',
    settings_reset_demo: 'Reset Demo Hardware',
    settings_notif_warranty: 'Warranty Expiry Reminders',
    settings_notif_maintenance: 'Maintenance & Service Reminders',
    settings_timeline_btn: 'View Scheduled Alert Timeline',
    toast_lang_changed: 'Language updated to {name}!',
    greeting_morning: 'Good morning',
    greeting_afternoon: 'Good afternoon',
    greeting_evening: 'Good evening',
    home_title: 'Your Home',
    my_appliances: 'My Appliances',
    see_all: 'See all →',
    add_appliance_cta_title: 'Add an appliance',
    add_appliance_cta_desc: 'Scan barcode, photograph rating plate or search model',
    all_appliances: 'All Appliances',
    warranty_timeline: 'Warranty Timeline',
    stat_fully_covered: 'Fully covered',
    stat_within_90_days: 'Within 90 days',
    stat_action_required: 'Action required',
    drawer_active: 'Active',
    drawer_expired: 'Expired',
    drawer_step: 'Step',
    drawer_wear: 'Wear',
    drawer_interval: 'Interval:',
    drawer_in_use: 'in use',
    toast_purchase_date_updated: 'Purchase date updated! Warranty active until {date}',
    toast_purchase_date_cleared: 'Purchase date cleared.',
    toast_warranty_policy_updated: 'Warranty policy updated to {months} months!',
    toast_purchase_price_updated: 'Purchase price updated!',
    toast_replacement_logged: 'Replacement logged for {name}! Wear reset to 0%.',
    toast_currency_changed: 'Currency format updated to {label}',
    toast_statutory_changed: 'Statutory warranty standard updated to {val} months',
    add_modal_title_appliance: 'Add Home Appliance',
    add_modal_title_coffee: 'Add Coffee Machine',
    add_modal_title_ebike: 'Add E-Bike & Fleet Hardware',
    add_modal_title_skigear: 'Add Alpine Ski Equipment',
    add_modal_scan_title: 'Scan Barcode',
    add_modal_scan_desc: 'EAN-13, UPC, packaging or frame barcode',
    add_modal_photo_title: 'Photograph Label / Plate',
    add_modal_photo_desc: 'Extract model specs from rating badge',
    add_modal_manual_label: 'Or enter exact product / model number:',
    add_modal_quick_test: 'Quick test:',
    add_modal_identify_btn: 'Identify',
    add_modal_camera_instruction: 'Align barcode or serial plate in reticle',
    add_modal_test_fixtures: 'Test barcode detection fixtures:',
    confirm_badge: 'VERIFIED PRODUCT',
    confirm_source_badge: 'Manufacturer Sourced',
    confirm_add_btn: 'Add to Portfolio',
    confirm_searching: 'Searching product databases…',
    confirm_verified_title: 'Product Identified',
    confirm_specs_header: 'MANUFACTURER SPECIFICATIONS',
    confirm_policy_header: 'MANUFACTURER POLICY / WARRANTY',
    confirm_market_header: 'REGIONAL MARKET VALUE',
    confirm_ownership_header: 'YOUR PRODUCT OWNERSHIP (OPTIONAL)',
    confirm_purchase_date: 'Purchase Date:',
    confirm_purchase_price: 'Purchase Price ({currency}):',
    confirm_warranty_duration: 'Warranty Duration:',
    confirm_room_location: 'Room / Location:',
    confirm_save_btn: 'Save to My Products',
    confirm_cancel_btn: 'Cancel',
    confirm_warranty_months: '{val} Months',
    confirm_warranty_text: '{val} Months ({source})',
    confirm_standard_policy: 'Standard Policy',
    confirm_market_unavailable: 'Market price unavailable',
    confirm_years: 'Years',
    confirm_months_short: 'Months',
    camera_title: 'Live Barcode & Label Scanner',
    toast_offline: 'You are offline. Saved product details are still available.',
    toast_search_busy: 'Product search is temporarily busy. Please try again shortly.',
    toast_search_auth_error: 'Product search service is temporarily misconfigured.',
    toast_search_timeout: 'Search request timed out. Please check your connection and retry.',
    toast_search_unavailable: 'Product search is temporarily unavailable. You can enter details manually.',
    coffee_barista_deck: 'Barista Deck',
    coffee_todays_extraction: "Today's Extraction",
    coffee_no_machine_paired: 'No Coffee Machine Paired',
    coffee_add_machine_title: '+ Add Your Coffee Machine',
    coffee_add_machine_desc: 'Pair your espresso machine to track water chemistry, descaling, and dial-in memory.',
    coffee_easy_mode_badge: 'EASY MODE · BEAN TO CUP',
    coffee_15bar_pump: '15-Bar Thermoblock',
    coffee_select_beverage: 'SELECT BEVERAGE',
    coffee_aroma_strength: 'AROMA STRENGTH',
    coffee_strength_level: 'Level {n} of 5',
    coffee_repeat_brew_label: '1-Tap Repeat Previous Brew',
    coffee_active_recipe_badge: 'ACTIVE TARGET RECIPE',
    coffee_metric_dose_in: 'DOSE IN',
    coffee_metric_yield_out: 'YIELD OUT',
    coffee_metric_target_time: 'TARGET TIME',
    coffee_metric_grinder_step: 'GRIND STEP',
    coffee_active_bean_title: 'Active Bean in Hopper',
    coffee_bean_cellar_link: 'Bean Cellar ({count}) →',
    coffee_bag_inventory: 'BAG INVENTORY',
    coffee_roaster_notes: 'Roaster Notes:',
    coffee_water_care_title: 'Water Chemistry & Care',
    coffee_equipment_care_link: 'Equipment Care →',
    coffee_water_source_label: 'MUNICIPAL WATER SOURCE',
    coffee_scale_risk_label: 'SCALE RISK',
    coffee_local_hardness: 'Local Hardness',
    coffee_next_descale: 'Next Descale',
    coffee_descale_in_days: 'In {days} days',
    coffee_filter_life: 'Filter: {percent}%',
    coffee_filtration_label: 'Filtration:',
    coffee_dial_in_memory_title: 'Dial-In Memory',
    coffee_attempt_number: 'Attempt #{n}',
    coffee_grind_label: 'Grind',
    coffee_total_shots: 'Total Shots:',
    coffee_my_grinder_fleet: 'MY GRINDERS',
    coffee_oem_maintenance: 'OEM Maintenance Protocol',
    coffee_descale_cycle_title: 'Thermoblock Descaling Cycle',
    coffee_descale_cycle_detail: 'Due in {days} days · Citric Acid / EcoDecalk',
    coffee_btn_log_done: 'Log Completed',
    coffee_filter_cartridge_title: 'Water Softener Cartridge',
    coffee_filter_lifespan_detail: '{percent}% lifespan remaining',
    coffee_btn_replaced: 'Replaced',
    coffee_freshness_unknown: 'Freshness Unknown',
    coffee_roast_date_not_specified: 'Roast date not specified',
    coffee_freshness_degas: 'Degassing ({days}d post-roast)',
    coffee_freshness_peak: 'Peak Window ★ ({days}d post-roast)',
    coffee_freshness_mature: 'Mature ({days}d post-roast)',
    coffee_freshness_past_peak: 'Past Peak ({days}d post-roast)',
    toast_water_source_changed: 'Water source set to {city} ({dh} °dH)',
    toast_brew_logged: 'Brewed {drink}! Logged to Coffee Memory.',
    toast_brew_loaded: 'Loaded previous brew: {bean} ({dose}g → {yield}g)',
    brew_timer_target_info: 'Target: {time} for {yield} yield ({ratio})',
    brew_btn_resume: 'Resume Timer',
    brew_btn_pause_evaluate: 'Pause & Evaluate',
    brew_btn_start: 'Start Timer',
    coffee_under_extracted: 'Under-extracted:',
    coffee_under_extracted_advice: 'Try grinding 1 step finer or increasing brew water temperature by 1°C.',
    coffee_over_extracted: 'Over-extracted:',
    coffee_over_extracted_advice: 'Try grinding 1 step coarser or stopping extraction 2 seconds earlier.',
    coffee_optimal_extraction: 'Optimal Extraction!',
    coffee_optimal_extraction_desc: 'Balanced sweetness and acidity. Saved to bean dial-in memory.',
    toast_brew_saved: 'Brew saved to Personal Coffee Memory!',
    coffee_bean_remaining: 'Remaining:',
    coffee_bean_roast_date: 'Roast Date:',
    coffee_bean_finished: 'Finished',
    coffee_bean_mark_finished: 'Mark Finished',
    toast_bean_name_required: 'Please enter a coffee bean name',
    toast_bean_added: 'Added {name} to Bean Cellar!',
    toast_scanning_bean_bag: 'Reading coffee bag label…',
    toast_bean_bag_scanned: 'Bag scanned! Roaster, origin, and roast date extracted.',
    toast_bean_finished: 'Marked {name} as finished.',
    toast_coffee_maintenance_logged: '{task} cycle logged successfully! Timers reset.',
    coffee_recipe_label: 'RECIPE:',
    coffee_metric_dose: 'DOSE',
    coffee_metric_yield: 'YIELD',
    coffee_metric_time: 'TIME',
    coffee_metric_temp: 'TEMP',
    coffee_bean_origin_label: 'Bean Origin:',
    coffee_tasting_notes_label: 'Tasting Notes:',
    coffee_extraction_steps: 'EXTRACTION STEPS:',
    coffee_step_1_dose: 'Dose freshly ground coffee into basket.',
    coffee_step_2_tamp: 'Tamp evenly and level.',
    coffee_step_3_extract: 'Extract until target yield is reached.',
    toast_recipe_loaded: 'Loaded: {name}',
    coffee_advisor_loading: 'Consulting Barista AI for dial-in ratio & grind parameters…',
    coffee_grind_advisor_title: 'DIAL-IN ADVISOR',
    coffee_advisor_grind: 'GRIND',
    coffee_advisor_dose: 'DOSE',
    coffee_advisor_yield: 'YIELD',
    coffee_advisor_temp: 'TEMP',
    coffee_sensory_profile: 'Sensory Profile:',
    coffee_advisor_calculated_for: 'Calculated for {roast} roast with {hardness} water hardness.',
    coffee_recipes_title: 'Dial-In Recipes & Brew Lab',
    coffee_bean_cellar: 'Bean Cellar ({count})',
    coffee_filter_all: 'All Methods',
    coffee_filter_espresso: 'Espresso',
    coffee_filter_pour_over: 'Pour-Over (V60)',
    coffee_filter_aeropress: 'Aeropress',
    coffee_filter_cold_brew: 'Cold Brew',
    coffee_filter_cafe_creme: 'Café Crème',
    coffee_advisor_section_title: 'AI BARISTA DIAL-IN ADVISOR',
    coffee_advisor_badge: 'Specialty Standards',
    coffee_advisor_desc: 'Calculate exact grind steps, brew ratios, water temperatures, and flow timings calibrated to your coffee origin and local water hardness.',
    coffee_brew_method_label: 'BREW METHOD',
    coffee_roast_level_label: 'ROAST LEVEL',
    coffee_bean_origin_placeholder: 'e.g. Ethiopia Yirgacheffe, Colombia Huila, Kenya AA…',
    coffee_quick_pick: 'Quick pick:',
    coffee_water_hardness_label: 'LOCAL WATER HARDNESS',
    coffee_calculate_btn: 'Calculate Dial-In & Grind Setting',
    coffee_brew_library_title: 'Specialty Brew Library',
    coffee_machine_maintenance_title: 'Machine Maintenance & Equipment',
    ebike_garage_fleet: 'Garage Fleet',
    ebike_stat_battery: 'BATTERY HEALTH',
    ebike_stat_odometer: 'TOTAL ODOMETER',
    ebike_next_service: 'Next service: {km} km',
    ebike_component_wear_title: 'Component Wear & Telemetry',
    ebike_all_parts_link: 'All parts →',
    ebike_chain_gauge: 'CHAIN ELONGATION GAUGE',
    ebike_chain_optimal: '{pct}% (Optimal)',
    ebike_chain_hint: 'Replace chain at 0.75% (SRAM Eagle 12-Speed)',
    ebike_suspension_gauge: 'SUSPENSION AIR PRESSURE',
    ebike_suspension_hint: 'Calibrated for 78 kg rider weight on Fox 38 Float 160mm fork',
    ebike_maintenance_history: 'Recent Maintenance History',
    ebike_chain_lubrication: 'Ceramic Chain Lubrication',
    ebike_applied_next_due: 'Applied at {applied} km · Next due at {due} km',
    ebike_bike_specs_title: 'Bike Specifications',
    ebike_consumables_title: 'Consumables & Wear Parts',
    ebike_motor_error_decoder: 'MOTOR ERROR DECODER',
    ebike_motor_diag_desc: 'Enter a Bosch, Shimano EP8, or Bafang error code to get an AI diagnosis.',
    ebike_motor_diag_placeholder: 'Error code (e.g. 503, 540, 0x04)',
    ebike_btn_decode_error: 'Decode Motor Error with AI',
    ebike_frame_serial: 'Frame Serial: •••• 9912',
    toast_ride_recorded: 'Ride of {km} km recorded! Odometer updated.',
    ebike_diag_empty_toast: 'Enter a motor error code (e.g. 503, 540, 0x04)',
    ebike_diag_decoding: 'Decoding error {code} with Gemini…',
    ebike_diag_fallback_title: 'Motor System Alert',
    ebike_diag_cause_label: 'Cause:',
    ebike_diag_fallback_cause: 'Sensor fault or communication interruption.',
    ebike_diag_action_label: 'Action:',
    ebike_diag_fallback_action: 'Power cycle and check magnetic spoke sensor alignment.',
    ski_alpine_quiver: 'Alpine Quiver',
    ski_metric_din: 'ISO 11088 DIN',
    ski_metric_bsl: '{bsl}mm BSL · {weight}kg Skier',
    ski_base_wax: 'BASE WAX',
    ski_snow_range: '{low}°C to {high}°C Cold Snow',
    ski_btn_recalc_din: 'Recalculate Binding DIN (ISO 11088)',
    ski_section_readiness: 'Season Readiness & Service',
    ski_btn_tuning_log: 'Tuning log →',
    ski_readiness_ski_days: 'Ski Days This Season',
    ski_readiness_ski_days_val: '{n} Days on Snow',
    ski_readiness_edge: 'Side Edge Bevel',
    ski_readiness_edge_val: '{angle}° Diamond Honed ({days} Days Ago)',
    ski_readiness_trip: 'Next Mountain Trip',
    ski_readiness_trip_val: '{place} (In {days} Days)',
    ski_checklist_title: 'Trip Checklist',
    ski_safety_notice: 'Mandatory Safety Requirement:',
    ski_safety_notice_desc: 'ISO 11088 DIN values are informational estimates. Ski binding release torques must be physically calibrated on a certified torque test bench by a qualified ski technician.',
    ski_base_wax_applied: 'Base Wax Applied',
    ski_days_on_snow: 'Days on Snow',
    ski_days_unit: 'Days',
    ski_wax_advisor_section: 'AI WAX ADVISOR',
    ski_snow_temp_placeholder: 'Snow °C (e.g. -12)',
    ski_snow_type_packed: 'Packed Powder',
    ski_snow_type_fresh: 'Fresh Snow',
    ski_snow_type_icy: 'Icy / Hard',
    ski_snow_type_wet: 'Wet Spring',
    ski_btn_get_ai_wax: 'Get AI Wax Recommendation',
    toast_din_applied: 'DIN {value} applied to {binding}!',
    ski_wax_calculating: 'Calculating wax recommendation for {temp}°C…',
    ski_wax_result_wax: 'RECOMMENDED WAX',
    ski_wax_result_iron: 'IRON TEMP',
    ski_wax_fallback: 'Toko LF Blue recommended for {temp}°C packed powder.',
    ski_setup_title: 'Binding & Boot Sole Setup',
    ski_tuning_title: 'Edge & Base Tuning Log',
    ski_domain_subtitle: 'Quiver, DIN Release & Waxing'
  },

  // ==================== 2. TÜRKÇE (tr) ====================
  tr: {
    settings_group_legal: 'YASAL BİLGİLER, GİZLİLİK & DESTEK',
    settings_privacy_title: 'Gizlilik Politikası',
    settings_privacy_sub: 'Cihaz içi depolama, sıfır takip, KVKK, GDPR ve İsviçre FADP uyumu',
    settings_terms_title: 'Kullanım Koşulları (EULA)',
    settings_terms_sub: 'Garanti sorumluluk reddi, güvenlik kuralları ve Apple standart EULA',
    settings_support_title: 'Müşteri Desteği & Tanılama',
    settings_support_sub: 'E-posta destek masası, sistem tanılaması ve cihaz SSS',
    settings_erase_title: 'Tüm Yerel Verileri Sil ve Sıfırla',
    settings_erase_sub: 'Kayıtlı tüm cihazları, garanti geçmişini ve özel ayarları kalıcı olarak siler',
    legal_privacy_modal_title: 'Gizlilik Politikası & Veri Şeffaflığı',
    legal_privacy_intro: 'Nordic Asset Suite, katı bir yerel-öncelikli (local-first) gizlilik mimarisi üzerine kuruludur. Ev ve cihaz kayıtlarınızın yalnızca size ait olduğuna inanıyoruz.',
    legal_privacy_sec1_title: '1. Yerel Öncelikli Cihaz İçi Depolama',
    legal_privacy_sec1_body: 'Tüm ev aletleriniz, seri numaraları, fatura tarihleri, garanti poliçeleri ve kahve/bisiklet/kayak bakım kayıtları cihazınızda güvenli yerel depolamada saklanır. Kişisel verileriniz hiçbir üçüncü tarafa veya reklamcıya satılmaz, kiralanmaz veya aktarılmaz.',
    legal_privacy_sec2_title: '2. Kamera, Fotoğraflar ve Derecelendirme Plakası OCR',
    legal_privacy_sec2_body: 'Model ve seri numaralarını tespit etmek için kamera veya fotoğraf tarayıcımızı kullandığınızda, görüntüler yalnızca metin çıkarma ve temiz ürün tanımlama amacıyla anlık olarak işlenir. Ham fotoğraflar harici sunucularda kalıcı olarak saklanmaz.',
    legal_privacy_sec3_title: '3. Üçüncü Taraf Arama ve Yapay Zeka Hizmetleri',
    legal_privacy_sec3_body: 'Bilinmeyen cihaz özellikleri araştırılırken, doğrulanmış üretici teknik verilerini getirmek için şifreli API uç noktaları (Gemini Vision ve Tavily Search) kullanılır. Hiçbir kişisel tanımlanabilir bilgi (PII) iletilmez.',
    legal_privacy_sec4_title: '4. KVKK, GDPR ve İsviçre FADP Hakları',
    legal_privacy_sec4_body: 'Ayarlar menüsündeki Verileri Sil seçeneğini kullanarak verilerinizi istediğiniz zaman inceleme, dışa aktarma veya kalıcı olarak silme hakkına sahipsiniz. Uygulamayı silmek tüm yerel veritabanı kayıtlarını da temizler.',
    legal_privacy_sec5_title: '5. Gizlilik İletişim',
    legal_privacy_sec5_body: 'Veri uygulamaları veya gizlilik uyumluluğu ile ilgili sorularınız için privacy@nordicasset.app adresinden Veri Koruma Görevlimizle iletişime geçebilirsiniz.',
    legal_terms_modal_title: 'Kullanım Koşulları & Standart EULA',
    legal_terms_intro: 'Lütfen Nordic Asset Suite uygulamasını kullanmadan önce bu Kullanım Koşullarını ve Son Kullanıcı Lisans Sözleşmesini (EULA) inceleyin.',
    legal_terms_sec1_title: '1. Standart Apple Lisanslı Uygulama EULA Sözleşmesi',
    legal_terms_sec1_body: 'Bu uygulamayı kullanma lisansınız Apple Standart EULA koşullarına (apple.com/legal/internet-services/itunes/dev/stdeula/) ve buradaki tamamlayıcı hükümlere tabidir.',
    legal_terms_sec2_title: '2. Bilgilendirme Amaçlı Garanti Takip Sorumluluk Reddi',
    legal_terms_sec2_body: 'Garanti bitiş tarihleri ve yasal koruma süreleri (örneğin 6502 sayılı Kanun, İsviçre CO Md. 210, AB Direktifi 2019/771), kullanıcı girdilerine ve üretici verilerine göre hesaplanır. Bunlar yalnızca bilgilendirme amaçlıdır; bir sigorta poliçesi veya yasal taahhüt teşkil etmez.',
    legal_terms_sec3_title: '3. Bakım & Kendin-Yap (DIY) Güvenlik Uyarısı',
    legal_terms_sec3_body: 'Temizlik protokolleri, parça değişim takvimleri, e-bisiklet bakımı ve kayak DIN hesaplama çıktıları genel endüstri standartlarına dayalı tavsiyelerdir. Kullanıcılar fiziksel servis, elektrik güvenliği ve spor ekipmanı ayarlarının tüm sorumluluğunu üstlenir.',
    legal_terms_sec4_title: '4. Ticari Markalar ve Fikri Mülkiyet',
    legal_terms_sec4_body: 'Tüm marka isimleri, ticari markalar ve model tanımlayıcıları (Siemens, Miele, Jura, DeLonghi, Bosch, Scott, Specialized, Stöckli vb.) ilgili hak sahiplerine aittir. Nordic Asset Suite bağımsız bir yardımcı araçtır.',
    legal_terms_sec5_title: '5. Geçerli Hukuk ve Yetki',
    legal_terms_sec5_body: 'Bu koşullar İsviçre yasalarına tabidir ve Zürih (İsviçre) mahkemeleri yetkilidir.',
    legal_support_modal_title: 'Müşteri Desteği & Sistem Tanılaması',
    legal_support_intro: 'Yardıma mı ihtiyacınız var veya teknik geri bildiriminiz mi var? İsviçre mühendislik ekibimiz yardıma hazır.',
    legal_support_email_label: 'Doğrudan Destek E-postası',
    legal_support_version_label: 'Uygulama Sürümü',
    legal_support_diag_btn: 'Sistem Tanılama Raporunu Kopyala',
    legal_support_faq_title: 'Sıkça Sorulan Sorular',
    legal_support_faq1_q: 'Garanti bitiş tarihleri nasıl hesaplanır?',
    legal_support_faq1_a: 'Girdiğiniz fatura tarihi ile üreticinin doğrulanmış garanti süresi veya yasal koruma standardı birleştirilerek hesaplanır.',
    legal_support_faq2_q: 'Derecelendirme plakası fotoğrafları bulutta saklanır mı?',
    legal_support_faq2_a: 'Hayır. OCR model ve seri numarası tespiti anlıktır ve harici sunucularda kalıcı olarak depolanmaz.',
    legal_support_faq3_q: 'Portföyümü dışa aktarabilir veya aktarabilir miyim?',
    legal_support_faq3_a: 'Evet, verileriniz standart yapılandırılmış formatta saklanır ve cihaz yedeğiyle korunabilir.',
    legal_erase_confirm_prompt: 'Kayıtlı tüm cihazları, garanti kayıtlarını ve özel ayarları kalıcı olarak silmek istediğinizden emin misiniz? Bu işlem geri alınamaz.',
    legal_erase_toast_success: 'Tüm yerel veriler ve cihaz kayıtları başarıyla silindi.',

    notif_log_title: 'Planlanan Garanti & Bakım Bildirimleri',
    notif_log_desc: 'Tüm bildirimler cihaz üzerinde yerel olarak değerlendirilir. Aktif garanti takviminiz aşağıdadır:',
    notif_empty_desc: 'Aktif cihaz bulunamadı. Planlanan uyarıları görmek için cihaz ekleyin.',
    notif_asset_label: 'Cihaz',
    notif_settings_group: 'GARANTİ & BAKIM BİLDİRİMLERİ',
    notif_settings_warranty_title: 'Garanti Bitiş Hatırlatıcıları',
    notif_settings_warranty_desc: 'Yasal garanti bitişinden 30 gün, 7 gün ve 1 gün önce bildirim gönderir',
    notif_settings_maint_title: 'Bakım & Servis Hatırlatıcıları',
    notif_settings_maint_desc: 'Kireç temizleme, filtre değişimi ve periyodik bakım aralıkları',
    notif_settings_timeline: 'Planlanan Bildirim Zaman Çizelgesini Gör',
    notif_prompt_title: 'Garanti Koruma Bildirimlerini Aç',
    notif_prompt_desc: 'Nordic Asset Suite, garanti süresi dolmadan önce zamanında bildirim göndererek ev yatırımlarınızı korur:',
    notif_prompt_30d: 'Bitişe 30 Gün Kala: Kontrol planlamak veya onarım talebi açmak için erken bildirim.',
    notif_prompt_7d: 'Bitişe 7 Gün Kala: Son hak arama penceresi için kritik uyarı.',
    notif_prompt_1d: 'Bitişe 24 Saat Kala: Son garanti bitiş bildirimi.',
    notif_prompt_maint: 'Rutin Bakım: Kireç temizliği, filtre yıkama ve servis uyarıları.',
    notif_btn_allow: 'Bildirimlere İzin Ver',
    notif_btn_later: 'Daha Sonra',
    notif_toast_warranty_enabled: 'Garanti bitiş hatırlatıcıları açıldı (30g, 7g, 1g).',
    notif_toast_warranty_disabled: 'Garanti bitiş hatırlatıcıları kapatıldı.',
    notif_toast_maint_enabled: 'Bakım ve servis hatırlatıcıları açıldı.',
    notif_toast_maint_disabled: 'Bakım ve servis hatırlatıcıları kapatıldı.',
    notif_toast_permission_granted: 'Yerel bildirim uyarıları etkinleştirildi!',
    notif_toast_permission_denied: 'Bildirim izni verilmedi.',
    notif_warranty_30d_title: '30 Günlük Garanti Bitiş Bildirimi',
    notif_warranty_30d_msg: '{asset} için yasal garanti süresi {date} tarihinde sona eriyor. Taleplerinizi zamanında iletmek için cihaz durumunu inceleyin.',
    notif_warranty_7d_title: '7 Günlük Kritik Garanti Bitişi',
    notif_warranty_7d_msg: '{asset} için yasal garanti kapsamının bitmesine sadece 7 gün kaldı. Son servis kontrolü önerilir.',
    notif_warranty_1d_title: '24 Saatlik Son Garanti Bildirimi',
    notif_warranty_1d_msg: '{asset} yasal garantisi yarın ({date}) sona eriyor.',
    notif_part_renewal_title: 'Parça Yenileme (%{percent} Aşınma): {part}',
    notif_part_renewal_msg: 'Orijinal OEM {pno} servis aralığı: {interval}. Hedef değişim tarihi: {date}.',
    notif_maintenance_title: 'Bakım Zamanı: {step}',
    notif_maintenance_msg: '{detail} (Planlanan Periyot: {freq})',
    notif_test_triggered: '{asset} için test bildirimi gönderildi!',

    status_expiring_soon: 'Süresi Yaklaşan',
    status_no_date: 'Tarih Belirtilmemiş',
    stat_within_90_days: '90 Gün İçinde',
    attention_expired_one: '1 cihazın garantisi bitti',
    attention_expired_plural: '{count} cihazın garantisi bitti',
    attention_expiring_one: '1 cihazın garantisi yakında bitiyor',
    attention_expiring_plural: '{count} cihazın garantisi yakında bitiyor',
    attention_combined_alert: '{expired} bitti · {expiring} yakında bitiyor',
    drawer_expiring_soon: 'Süresi Yaklaşan',
    drawer_user_purchase_price: 'Kullanıcı Satın Alma Fiyatı',
    drawer_estimated_market_value: 'Tahmini Piyasa Değeri',
    not_specified: 'Belirtilmedi',
    statutory_protection_title: 'Yasal Tüketici Koruması',
    manufacturer_warranty_title: 'Üretici Ticari Garantisi',
    user_coverage_title: 'Aktif Garanti Kapsamınız',

    drawer_warranty_status_label: 'GARANTİ DURUMU',
    drawer_warranty_desc: 'İsviçre Borçlar Kanunu Md. 210 Yasal Koruma.',
    drawer_purchase_date_label_short: 'Satın Alma Tarihi',
    drawer_warranty_policy_label_short: 'Garanti Politikası',
    drawer_purchase_price_label_short: 'Satın Alma Fiyatı',
    detail_nav_title: 'Varlık Detayları',
    detail_manual_summary: 'Üretici tarafından önerilen bakım protokolü.',
    drawer_diag_prompt: 'Donanım hata kodu / belirtisi:',
    drawer_diag_placeholder: 'örn. E24, F10, Hata 107...',
    drawer_diag_btn: 'Teşhis Et',
    confirm_serial_badge: 'Seri No',

    add_placeholder_appliance: 'örn. Siemens KG86PFIC0N, Miele W1, Dyson V15, DeLonghi Ekmek Kızartma...',
    add_placeholder_coffee: 'örn. DeLonghi Magnifica Plus, Sage Barista Touch, Jura E8, Philips LatteGo...',
    add_placeholder_ebike: 'örn. Scott Patron eRIDE, Specialized Turbo Levo, Trek Rail 9.8...',
    add_placeholder_skigear: 'örn. Stöckli Laser SL, Atomic Redster S9, Head Worldcup Rebels...',
    promo_line1: 'Ev ekipmanlarınızı yasal garanti takibi ile koruyun.',
    promo_line2: 'Anında arıza kodları ve bakım takvimleri için etiket fotoğraflayın.',
    mo_policy: 'ay garanti',
    statutory_standard: 'Yasal Standart',
    coffee_btn_brew_log: 'Demleme Günlüğü & Ayar',
    coffee_btn_brew_again: 'Tarifi Uygula',
    coffee_ratio_label: 'Demleme Oranı',
    coffee_btn_start_timer: 'Süreç Sayacı',
    coffee_extraction_notes_fallback: 'Dengeli ve tatlı ekstraksiyon profili',
    coffee_grinder_step: 'Öğütme Ayarı: Kademe {step}',
    ebike_empty_title: 'Kayıtlı E-Bike Bulunamadı',
    ebike_empty_desc: 'Batarya sağlığı, motor telemetrisi ve zincir aşınmasını takip etmek için elektrikli bisikletinizi ekleyin.',
    ebike_btn_add: 'E-Bike Ekle',
    ski_empty_title: 'Kayıtlı Kayak Ekipmanı Bulunamadı',
    ski_empty_desc: 'ISO 11088 DIN ayarını hesaplamak ve kenar/vaks bakım döngülerini izlemek için kayaklarınızı ekleyin.',
    ski_btn_add: 'Kayak Ekipmanı Ekle',
    tour_step_prefix: 'Adım {current} / {total}',
    tour_btn_back: 'Geri',
    tour_btn_skip: 'Turu Geç',
    tour_btn_start: 'Başla',
    tour_btn_next: 'İleri',
    brand_appliance: 'Cihaz Garanti Takibi',
    brand_coffee: 'Kahve Asistanı',
    brand_ebike: 'E-Bisiklet Servis',
    brand_skigear: 'Kayak Ekipmanı Takibi',
    nav_home: 'Ana Sayfa',
    nav_appliances: 'Cihazlar',
    nav_add: 'Ekle',
    nav_warranties: 'Garantiler',
    nav_settings: 'Ayarlar',
    nav_today: 'Bugün',
    nav_recipes: 'Tarifler',
    nav_machine: 'Makine',
    nav_ride: 'Sürüş',
    nav_bike: 'Bisiklet',
    nav_parts: 'Parçalar',
    nav_quiver: 'Ekipman',
    nav_setup: 'Ayarlar',
    nav_tuning: 'Bakım',
    rooms_all: 'Tümü',
    rooms_kitchen: 'Mutfak',
    rooms_living: 'Salon',
    rooms_laundry: 'Çamaşır Odası',
    rooms_bedroom: 'Yatak Odası',
    rooms_bathroom: 'Banyo',
    rooms_office: 'Çalışma Odası',
    rooms_dining: 'Yemek Odası',
    rooms_hallway: 'Antre',
    rooms_garage: 'Garaj',
    rooms_skilocker: 'Kayak Dolabı',
    rooms_basement: 'Bodrum',
    rooms_balcony: 'Balkon / Bahçe',
    status_active: 'AKTİF',
    status_expired: 'SÜRESİ DOLDU',
    status_expiring_soon: 'YAKINDA BİTİYOR',
    stat_items: 'Kayıtlı Cihazlar',
    stat_protected: 'Aktif Garantiler',
    stat_expiring: 'Yakında Bitiyor',
    stat_expired: 'Süresi Doldu',
    attention_expired_one: '1 cihazın garantisi doldu',
    attention_all_ok: 'Tüm {count} cihazınız yasal garanti koruması altında',
    empty_appliance_title: 'Kayıtlı Cihaz Bulunmuyor',
    empty_appliance_desc: 'Garanti sürelerini, faturaları ve periyodik bakımları takip etmek için ilk cihazınızı ekleyin.',
    btn_add_appliance: 'Cihaz Ekle',
    expires_on: 'Bitiş Tarihi: {date}',
    add_purchase_date: 'Satın alma tarihi ekle',
    drawer_tab_specs: 'Teknik Özellikler',
    drawer_tab_maintenance: 'Bakım & Temizlik',
    drawer_tab_parts: 'Yedek Parça & Aşınma',
    drawer_tab_diagnostics: 'Arıza Teşhis',
    drawer_purchase_date_label: 'Satın Alma / Fatura Tarihi:',
    drawer_policy_label: 'Yasal / Üretici Garanti Süresi:',
    drawer_price_label: 'Satın Alma Fiyatı (Varlık Değeri):',
    drawer_est_oem_cost: 'Tahmini Orijinal Parça:',
    drawer_btn_replace: 'Değişimi Kaydet',
    drawer_btn_delete: 'Cihazı Portföyden Sil',
    drawer_delete_confirm: '"{name}" adlı cihazı portföyden silmek istediğinize emin misiniz? Bu işlem geri alınamaz.',
    wear_optimal: 'Kusursuz Durum',
    wear_moderate: 'Orta Düzey Aşınma',
    wear_due_soon: 'Yakında Değiştirilmeli',
    wear_overdue: 'Acil Değişim Gerekli',
    freq_daily: 'Günlük',
    freq_weekly: 'Haftalık',
    freq_monthly: 'Aylık',
    freq_every_60: 'Her 60 Günde Bir',
    freq_every_90: 'Her 90 Günde Bir',
    freq_every_150km: 'Her 150 km\'de',
    freq_every_4skidays: 'Her 4 Kayak Gününde Bir',
    settings_header: 'Tercihler & Bölgesel Veriler',
    settings_lang_label: 'Uygulama Dili',
    settings_lang_sub: 'Bölgesel ana dil yerelleştirmesi',
    settings_currency_label: 'Para Birimi Formatı',
    settings_currency_sub: 'Cihaz değerleri, parçalar ve piyasa fiyatlarına uygulanır',
    settings_statutory_label: 'Yasal Garanti Süresi',
    settings_statutory_sub: 'Standart beyaz eşyalar için varsayılan garanti süresi',
    settings_tour_label: 'Rehberli Tanıtım Turu',
    settings_reset_demo: 'Demo Donanımlarını Sıfırla',
    settings_notif_warranty: 'Garanti Bitiş Hatırlatıcıları',
    settings_notif_maintenance: 'Bakım ve Servis Hatırlatıcıları',
    settings_timeline_btn: 'Zamanlanmış Bildirim Takvimini Gör',
    toast_lang_changed: 'Uygulama dili {name} olarak güncellendi!',
    greeting_morning: 'Günaydın',
    greeting_afternoon: 'Tünaydın',
    greeting_evening: 'İyi Akşamlar',
    home_title: 'Eviniz',
    my_appliances: 'Cihazlarım',
    see_all: 'Tümünü Gör →',
    add_appliance_cta_title: '+ Cihaz Ekle',
    add_appliance_cta_desc: 'Barkod tarayın, tip etiketini fotoğraflayın veya model arayın',
    all_appliances: 'Tüm Cihazlar',
    warranty_timeline: 'Garanti Zaman Çizelgesi',
    stat_fully_covered: 'Tam Korumalı',
    stat_within_90_days: '90 Gün İçinde',
    stat_action_required: 'İşlem Gerekiyor',
    drawer_active: 'Aktif',
    drawer_expired: 'Süresi Doldu',
    drawer_step: 'Adım',
    drawer_wear: 'Aşınma',
    drawer_interval: 'Aralık:',
    drawer_in_use: 'kullanımda',
    toast_purchase_date_updated: 'Satın alma tarihi güncellendi! Garanti {date} tarihine kadar aktif',
    toast_purchase_date_cleared: 'Satın alma tarihi temizlendi.',
    toast_warranty_policy_updated: 'Garanti süresi {months} ay olarak güncellendi!',
    toast_purchase_price_updated: 'Satın alma fiyatı güncellendi!',
    toast_replacement_logged: '{name} parça değişimi kaydedildi! Aşınma %0\'a sıfırlandı.',
    toast_currency_changed: 'Para birimi {label} olarak ayarlandı',
    toast_statutory_changed: 'Yasal garanti standardı {val} ay olarak ayarlandı',
    add_modal_title_appliance: 'Ev Cihazı Ekle',
    add_modal_title_coffee: 'Kahve Makinesi Ekle',
    add_modal_title_ebike: 'E-Bisiklet Ekle',
    add_modal_title_skigear: 'Kayak Ekipmanı Ekle',
    add_modal_scan_title: 'Barkod / QR Kod Tarayın',
    add_modal_scan_desc: 'EAN-13, UPC veya ürün ambalaj barkodu',
    add_modal_photo_title: 'Cihaz Etiketini Fotoğraflayın',
    add_modal_photo_desc: 'Metal tip etiketinden model ve teknik özellikleri çıkarın',
    add_modal_manual_label: 'Veya tam ürün / model adını girin:',
    add_modal_quick_test: 'Hızlı Test:',
    add_modal_identify_btn: 'Tanımla',
    add_modal_camera_instruction: 'Barkodu veya tip etiketini vizöre hizalayın',
    add_modal_test_fixtures: 'Örnek test barkodları:',
    confirm_badge: 'DOĞRULANMIŞ ÜRÜN',
    confirm_source_badge: 'Üretici Resmi Verisi',
    confirm_add_btn: 'Portföye Kaydet',
    confirm_searching: 'Üretici veri tabanlarında aranıyor…',
    confirm_verified_title: 'Ürün Tanımlandı',
    confirm_specs_header: 'ÜRETİCİ TEKNİK ÖZELLİKLERİ',
    confirm_policy_header: 'ÜRETİCİ GARANTİ POLİTİKASI',
    confirm_market_header: 'BÖLGESEL PİYASA DEĞERİ',
    confirm_ownership_header: 'ÜRÜN SAHİPLİK BİLGİLERİNİZ (İSTEĞE BAĞLI)',
    confirm_purchase_date: 'Satın Alma Tarihi:',
    confirm_purchase_price: 'Satın Alma Fiyatı ({currency}):',
    confirm_warranty_duration: 'Garanti Süresi:',
    confirm_room_location: 'Oda / Konum:',
    confirm_save_btn: 'Portföye Kaydet',
    confirm_cancel_btn: 'İptal',
    confirm_warranty_months: '{val} Ay',
    confirm_warranty_text: '{val} Ay ({source})',
    confirm_standard_policy: 'Standart Yasal Politika',
    confirm_market_unavailable: 'Piyasa değeri hesaplanamadı',
    confirm_years: 'Yıl',
    confirm_months_short: 'Ay',
    camera_title: 'Canlı Barkod & Etiket Tarayıcı',
    toast_offline: 'Çevrimdışısınız. Kayıtlı cihaz bilgilerinize erişebilirsiniz.',
    toast_search_busy: 'Ürün arama servisi şu anda meşgul. Lütfen birazdan tekrar deneyin.',
    toast_search_auth_error: 'Arama servisi yapılandırma hatası.',
    toast_search_timeout: 'Arama isteği zaman aşımına uğradı. Bağlantınızı kontrol edin.',
    toast_search_unavailable: 'Ürün tanımlama servisi geçici olarak kullanılamıyor.',
    coffee_barista_deck: 'Barista Masası',
    coffee_todays_extraction: "Bugünün Ekstraksiyonu",
    coffee_no_machine_paired: 'Eşleştirilmiş Kahve Makinesi Yok',
    coffee_add_machine_title: '+ Kahve Makinenizi Ekleyin',
    coffee_add_machine_desc: 'Su sertliği, kireç temizliği ve dial-in hafızası için makinenizi bağlayın.',
    coffee_easy_mode_badge: 'KOLAY MOD · ÇEKİRDEKTEN FİNCANA',
    coffee_15bar_pump: '15-Bar Termoblok',
    coffee_select_beverage: 'İÇECEK SEÇİN',
    coffee_aroma_strength: 'AROMA YOĞUNLUĞU',
    coffee_strength_level: 'Seviye {n} / 5',
    coffee_repeat_brew_label: '1-Dokunuşla Önceki Demlemeyi Tekrarla',
    coffee_active_recipe_badge: 'AKTİF HEDEF REÇETE',
    coffee_metric_dose_in: 'KAHVE DOZU',
    coffee_metric_yield_out: 'ÇIKTI (GRAM)',
    coffee_metric_target_time: 'HEDEF SÜRE',
    coffee_metric_grinder_step: 'ÖĞÜTÜM DERECESİ',
    coffee_active_bean_title: 'Haznedeki Aktif Çekirdek',
    coffee_bean_cellar_link: 'Çekirdek Mahzeni ({count}) →',
    coffee_bag_inventory: 'PAKET STOĞU',
    coffee_roaster_notes: 'Kavurucu Notları:',
    coffee_water_care_title: 'Su Kimyası & Bakım',
    coffee_equipment_care_link: 'Ekipman Bakımı →',
    coffee_water_source_label: 'ŞEBEKE SUYU KAYNAĞI',
    coffee_scale_risk_label: 'KİREÇ RİSKİ',
    coffee_local_hardness: 'Yerel Sertlik',
    coffee_next_descale: 'Sonraki Kireç Temizliği',
    coffee_descale_in_days: '{days} gün içinde',
    coffee_filter_life: 'Filtre Ömrü: %{percent}',
    coffee_filtration_label: 'Filtreleme:',
    coffee_dial_in_memory_title: 'Dial-In Reçete Hafızası',
    coffee_attempt_number: 'Deneme #{n}',
    coffee_grind_label: 'Öğütüm',
    coffee_total_shots: 'Toplam Shot:',
    coffee_my_grinder_fleet: 'DEĞİRMENLERİM',
    coffee_oem_maintenance: 'Orijinal Bakım Protokolü',
    coffee_descale_cycle_title: 'Termoblok Kireç Çözme Döngüsü',
    coffee_descale_cycle_detail: '{days} gün içinde · Sıvı Kireç Çözücü',
    coffee_btn_log_done: 'Tamamlandı Olarak Kaydet',
    coffee_filter_cartridge_title: 'Su Yumuşatıcı Filtre Kartuşu',
    coffee_filter_lifespan_detail: '%{percent} kullanım ömrü kaldı',
    coffee_btn_replaced: 'Değiştirildi',
    coffee_freshness_unknown: 'Tazelik Bilinmiyor',
    coffee_roast_date_not_specified: 'Kavurma tarihi belirtilmedi',
    coffee_freshness_degas: 'Gaz Salınımı (Kavurmadan {days} gün sonra)',
    coffee_freshness_peak: 'Zirve Lezzet Penceresi ★ ({days} gün)',
    coffee_freshness_mature: 'Olgun ({days} gün)',
    coffee_freshness_past_peak: 'Zirveyi Geçmiş ({days} gün)',
    toast_water_source_changed: 'Su kaynağı {city} ({dh} °dH) olarak ayarlandı',
    toast_brew_logged: '{drink} demlendi ve Kahve Hafızasına kaydedildi!',
    toast_brew_loaded: 'Önceki reçete yüklendi: {bean} ({dose}g → {yield}g)',
    brew_timer_target_info: 'Hedef: {yield} çıktı için {time} ({ratio})',
    brew_btn_resume: 'Sayacı Sürdür',
    brew_btn_pause_evaluate: 'Duraklat & Değerlendir',
    brew_btn_start: 'Sayacı Başlat',
    coffee_under_extracted: 'Yetersiz Ekstraksiyon (Ekşi):',
    coffee_under_extracted_advice: 'Öğütümü 1 kademe inceltin veya su sıcaklığını 1°C artırın.',
    coffee_over_extracted: 'Aşırı Ekstraksiyon (Acı):',
    coffee_over_extracted_advice: 'Öğütümü 1 kademe kalınlaştırın veya akışı 2 saniye erken durdurun.',
    coffee_optimal_extraction: 'Kusursuz Ekstraksiyon!',
    coffee_optimal_extraction_desc: 'Dengeli tatlılık ve gövde. Çekirdek hafızasına kaydedildi.',
    toast_brew_saved: 'Demleme Kişisel Kahve Hafızasına kaydedildi!',
    coffee_bean_remaining: 'Kalan Miktar:',
    coffee_bean_roast_date: 'Kavurma Tarihi:',
    coffee_bean_finished: 'Bitti',
    coffee_bean_mark_finished: 'Bitti Olarak İşaretle',
    toast_bean_name_required: 'Lütfen bir kahve çekirdeği adı girin',
    toast_bean_added: '{name} Çekirdek Mahzenine eklendi!',
    toast_scanning_bean_bag: 'Kahve paketi etiketi okunuyor…',
    toast_bean_bag_scanned: 'Paket tarandı! Kavurucu, orijin ve kavurma tarihi çıkarıldı.',
    toast_bean_finished: '{name} bitti olarak işaretlendi.',
    toast_coffee_maintenance_logged: '{task} bakımı kaydedildi! Sayaçlar sıfırlandı.',
    coffee_recipe_label: 'REÇETE:',
    coffee_metric_dose: 'DOZ',
    coffee_metric_yield: 'ÇIKTI',
    coffee_metric_time: 'SÜRE',
    coffee_metric_temp: 'SICAKLIK',
    coffee_bean_origin_label: 'Çekirdek Orijini:',
    coffee_tasting_notes_label: 'Tadım Notaları:',
    coffee_extraction_steps: 'EKSTRAKSİYON ADIMLARI:',
    coffee_step_1_dose: 'Taze öğütülmüş kahveyi sepete doldurun.',
    coffee_step_2_tamp: 'Düz ve eşit şekilde tamperleyin.',
    coffee_step_3_extract: 'Hedef çıktı gramajına ulaşana kadar demleyin.',
    toast_recipe_loaded: 'Yüklendi: {name}',
    coffee_advisor_loading: 'Barista AI ideal oran ve öğütüm parametrelerini hesaplıyor…',
    coffee_grind_advisor_title: 'BARİSTA DİAL-IN DANIŞMANI',
    coffee_advisor_grind: 'ÖĞÜTÜM',
    coffee_advisor_dose: 'DOZ',
    coffee_advisor_yield: 'ÇIKTI',
    coffee_advisor_temp: 'SICAKLIK',
    coffee_sensory_profile: 'Duyusal Profil:',
    coffee_advisor_calculated_for: '{roast} kavrum ve {hardness} su sertliği için hesaplandı.',
    coffee_recipes_title: 'Demleme Reçeteleri & Laboratuvar',
    coffee_bean_cellar: 'Çekirdek Mahzeni ({count})',
    coffee_filter_all: 'Tüm Yöntemler',
    coffee_filter_espresso: 'Espresso',
    coffee_filter_pour_over: 'V60 / Pour-Over',
    coffee_filter_aeropress: 'Aeropress',
    coffee_filter_cold_brew: 'Cold Brew',
    coffee_filter_cafe_creme: 'Caffè Crema',
    coffee_advisor_section_title: 'YAPAY ZEKA BARİSTA DİAL-IN REHBERİ',
    coffee_advisor_badge: 'Nitelikli Kahve Standartları',
    coffee_advisor_desc: 'Çekirdek türüne ve suyunuzun sertliğine göre mikron öğütüm derecesini, demleme oranını ve su sıcaklığını hesaplayın.',
    coffee_brew_method_label: 'DEMLEME YÖNTEMİ',
    coffee_roast_level_label: 'KAVRUM DERECESİ',
    coffee_bean_origin_placeholder: 'ör. Etiyopya Yirgacheffe, Kolombiya Huila, Kenya AA…',
    coffee_quick_pick: 'Hızlı seçim:',
    coffee_water_hardness_label: 'YEREL SU SERTLİĞİ',
    coffee_calculate_btn: 'İdeal Öğütüm & Reçeteyi Hesapla',
    coffee_brew_library_title: 'Özel Reçete Kütüphanesi',
    coffee_machine_maintenance_title: 'Makine Bakımı & Donanım',
    ebike_garage_fleet: 'Garaj Filosu',
    ebike_stat_battery: 'BATARYA SAĞLIĞI',
    ebike_stat_odometer: 'TOPLAM KİLOMETRE',
    ebike_next_service: 'Sonraki Servis: {km} km',
    ebike_component_wear_title: 'Bileşen Aşınması & Telemetri',
    ebike_all_parts_link: 'Tüm Parçalar →',
    ebike_chain_gauge: 'ZİNCİR UZAMA & AŞINMA GÖSTERGESİ',
    ebike_chain_optimal: '%{pct} (Kusursuz)',
    ebike_chain_hint: '%0.75 uzamada zinciri değiştirin (SRAM Eagle 12-Speed)',
    ebike_suspension_gauge: 'SÜSPANSİYON HAVA BASINCI',
    ebike_suspension_hint: '78 kg sürücü için Fox 38 Float 160mm maşada kalibre edildi',
    ebike_maintenance_history: 'Son Bakım Geçmişi',
    ebike_chain_lubrication: 'Seramik Zincir Yağlaması',
    ebike_applied_next_due: '{applied} km\'de uygulandı · Sonraki {due} km\'de',
    ebike_bike_specs_title: 'Bisiklet Teknik Özellikleri',
    ebike_consumables_title: 'Sarf Malzemeleri & Aşınma Parçaları',
    ebike_motor_error_decoder: 'MOTOR ARIZA KODU ÇÖZÜCÜ',
    ebike_motor_diag_desc: 'Bosch, Shimano EP8 veya Bafang arıza kodunu girerek yapay zeka arıza analizi alın.',
    ebike_motor_diag_placeholder: 'Arıza kodu (ör. 503, 540, 0x04)',
    ebike_btn_decode_error: 'Arıza Kodunu AI ile Çöz',
    ebike_frame_serial: 'Şasi Seri No: •••• 9912',
    toast_ride_recorded: '{km} km sürüş kaydedildi! Kilometre sayacı güncellendi.',
    ebike_diag_empty_toast: 'Lütfen bir motor arıza kodu girin (ör. 503, 540)',
    ebike_diag_decoding: '{code} arıza kodu Gemini ile çözümleniyor…',
    ebike_diag_fallback_title: 'Motor Sistemi Uyarısı',
    ebike_diag_cause_label: 'Olası Neden:',
    ebike_diag_fallback_cause: 'Jant hız sensörü veya manyetik okuyucu hizalama hatası.',
    ebike_diag_action_label: 'Çözüm Önerisi:',
    ebike_diag_fallback_action: 'Jant teline takılı mıknatısın sensöre olan mesafesini kontrol edin.',
    ski_alpine_quiver: 'Aktif Kayak Takımı',
    ski_metric_din: 'ISO 11088 DIN DEĞERİ',
    ski_metric_bsl: '{bsl}mm Taban · {weight}kg Kayakçı',
    ski_base_wax: 'TABAN VAKSI',
    ski_snow_range: '{low}°C ila {high}°C Soğuk Kar',
    ski_btn_recalc_din: 'DIN Bağlama Değerini Yeniden Hesapla',
    ski_section_readiness: 'Sezon Hazırlığı & Servis Durumu',
    ski_btn_tuning_log: 'Bakım Kayıtları →',
    ski_readiness_ski_days: 'Bu Sezondaki Kayak Günü',
    ski_readiness_ski_days_val: '{n} Gün Kayıldı',
    ski_readiness_edge: 'Yan Kenar Açısı',
    ski_readiness_edge_val: '{angle}° Elmas Taşlanmış ({days} gün önce)',
    ski_readiness_trip: 'Sonraki Dağ Gezisi',
    ski_readiness_trip_val: '{place} ({days} gün sonra)',
    ski_checklist_title: 'Dağ Hazırlık Kontrol Listesi',
    ski_safety_notice: 'Zorunlu Güvenlik Uyarısı:',
    ski_safety_notice_desc: 'ISO 11088 DIN hesaplamaları bilgilendirme amaçlıdır. Kayak bağlama bırakma torku sertifikalı bir teknisyen tarafından kalibreli tork test cihazında test edilmelidir.',
    ski_base_wax_applied: 'Uygulanan Taban Vaksı',
    ski_days_on_snow: 'Karda Geçen Gün',
    ski_days_unit: 'Gün',
    ski_wax_advisor_section: 'YAPAY ZEKA VAKS DANIŞMANI',
    ski_snow_temp_placeholder: 'Kar Sıcaklığı °C (ör. -12)',
    ski_snow_type_packed: 'Sıkıştırılmış Pist Karı',
    ski_snow_type_fresh: 'Taze Toz Kar',
    ski_snow_type_icy: 'Buzlu / Sert Zemin',
    ski_snow_type_wet: 'Islak Bahar Karı',
    ski_btn_get_ai_wax: 'Yapay Zeka Vaks Tavsiyesi Al',
    toast_din_applied: 'DIN {value} değeri {binding} bağlamasına uygulandı!',
    ski_wax_calculating: '{temp}°C için en ideal vaks formülü hesaplanıyor…',
    ski_wax_result_wax: 'ÖNERİLEN VAKS',
    ski_wax_result_iron: 'ÜTÜ SICAKLIĞI',
    ski_wax_fallback: '{temp}°C kar için Toko LF Blue flor-içermeyen soğuk pist vaksı önerilir.',
    ski_setup_title: 'Bağlama & Bot Tabanı Kurulumu',
    ski_tuning_title: 'Kenar Açısı & Vakslama Geçmişi',
    ski_domain_subtitle: 'Ekipman, DIN Bağlama & Vaks Takibi'
  },

  // ==================== 3. DANSK (da) ====================
  da: {
    settings_group_legal: 'JURIDISK, PERSONLIGE OPLYSNINGER OG SUPPORT',
    settings_privacy_title: 'Privatlivspolitik',
    settings_privacy_sub: 'Lokal lagring, nul sporing, GDPR og schweizisk FADP-overholdelse',
    settings_terms_title: 'Brugsvilkår (EULA)',
    settings_terms_sub: 'Garantifraskrivelser, sikkerhedsretningslinjer og Apple standard EULA',
    settings_support_title: 'Kundesupport og systemdiagnostik',
    settings_support_sub: 'E-mail support, systemtelemetri og hardware-FAQ',
    settings_erase_title: 'Slet alle lokale data og nulstil',
    settings_erase_sub: 'Slet alle gemte enheder, garantilogger og indstillinger permanent',
    legal_privacy_modal_title: 'Privatlivspolitik og datagennemsigtighed',
    legal_privacy_intro: 'Nordic Asset Suite er bygget på en streng lokal-først arkitektur. Dine husholdningsdata tilhører udelukkende dig.',
    legal_privacy_sec1_title: '1. Lokal lagring på enheden',
    legal_privacy_sec1_body: 'Alle dine apparater, serienumre, købsdatoer og vedligeholdelseslogger gemmes lokalt på din enhed. Vi sælger eller deler aldrig dine data med tredjeparter.',
    legal_privacy_sec2_title: '2. Kamera, fotos og OCR af typeskilt',
    legal_privacy_sec2_body: 'Billeder behandles øjeblikkeligt til tekstgenkendelse og gemmes aldrig permanent på eksterne servere.',
    legal_privacy_sec3_title: '3. Tredjepartstjenester til specifikationer',
    legal_privacy_sec3_body: 'Specifikationssøgninger foretages via krypterede API-forbindelser uden overførsel af personhenførbare data.',
    legal_privacy_sec4_title: '4. GDPR og sletningsrettigheder',
    legal_privacy_sec4_body: 'Du kan til enhver tid slette alle data via indstillingerne. Sletning af appen fjerner alle lokale data.',
    legal_privacy_sec5_title: '5. Kontakt',
    legal_privacy_sec5_body: 'Kontakt os på privacy@nordicasset.app for spørgsmål om databeskyttelse.',
    legal_terms_modal_title: 'Brugsvilkår og standard EULA',
    legal_terms_intro: 'Læs venligst disse vilkår grundigt igennem før brug af Nordic Asset Suite.',
    legal_terms_sec1_title: '1. Apples standard EULA-licensaftale',
    legal_terms_sec1_body: 'Brug af appen er underlagt Apples standard EULA-betingelser og disse supplerende vilkår.',
    legal_terms_sec2_title: '2. Ansvarsfraskrivelse for garanti',
    legal_terms_sec2_body: 'Beregninger af garantiudløb er vejledende og udgør ikke en forsikringspolice eller juridisk garanti.',
    legal_terms_sec3_title: '3. Sikkerhedsfraskrivelse',
    legal_terms_sec3_body: 'Brugere bærer det fulde ansvar for fysisk vedligeholdelse og elektrisk sikkerhed.',
    legal_terms_sec4_title: '4. Varemærker',
    legal_terms_sec4_body: 'Alle varemærker tilhører deres respektive ejere. Nordic Asset Suite er et uafhængigt værktøj.',
    legal_terms_sec5_title: '5. Lovvalg',
    legal_terms_sec5_body: 'Vilkårene er underlagt schweizisk lovgivning med værneting i Zürich.',
    legal_support_modal_title: 'Kundesupport og diagnostik',
    legal_support_intro: 'Vores schweiziske ingeniørteam står klar til at hjælpe dig.',
    legal_support_email_label: 'Direkte support-e-mail',
    legal_support_version_label: 'Applikationsversion',
    legal_support_diag_btn: 'Kopiér systemdiagnostikrapport',
    legal_support_faq_title: 'Ofte stillede spørgsmål',
    legal_support_faq1_q: 'Hvordan beregnes garantiudløbet?',
    legal_support_faq1_a: 'Ved at kombinere din købsdato med verificerede producentgarantier eller lovpligtige frister.',
    legal_support_faq2_q: 'Gemmes typeskiltfotos i skyen?',
    legal_support_faq2_a: 'Nej. OCR-behandling sker øjeblikkeligt uden permanent ekstern lagring.',
    legal_support_faq3_q: 'Kan jeg eksportere mine data?',
    legal_support_faq3_a: 'Ja, dine data bevares i struktureret format via din enhedssikkerhedskopi.',
    legal_erase_confirm_prompt: 'Er du sikker på, at du vil slette alle gemte enheder og indstillinger permanent?',
    legal_erase_toast_success: 'Alle lokale data er blevet slettet.',

    notif_log_title: 'Planlagte garanti- og serviceadvarsler',
    notif_log_desc: 'Alle notifikationer evalueres lokalt på enheden. Nedenfor er din aktive garantibeskyttelsesplan:',
    notif_empty_desc: 'Ingen aktive enheder fundet. Tilføj aktiver for at se planlagte garantiadvarsler.',
    notif_asset_label: 'Enhed',
    notif_settings_group: 'GARANTI- OG SERVICENOTIFIKATIONER',
    notif_settings_warranty_title: 'Påmindelser om garantiudløb',
    notif_settings_warranty_desc: 'Giv besked 30 dage, 7 dage og 1 dag før lovpligtig garantidato',
    notif_settings_maint_title: 'Påmindelser om vedligeholdelse og service',
    notif_settings_maint_desc: 'Afkalkning, filterskift og periodiske serviceintervaller',
    notif_settings_timeline: 'Se tidslinje for planlagte advarsler',
    notif_prompt_title: 'Aktivér notifikationer om garantibeskyttelse',
    notif_prompt_desc: 'Nordic Asset Suite beskytter dine husholdningsinvesteringer ved rettidigt at give lokale advarsler før dækningen udløber:',
    notif_prompt_30d: '30 dage før udløb: Tidlig notifikation for at planlægge inspektion eller oprette reklamationskrav.',
    notif_prompt_7d: '7 dage før udløb: Kritisk advarsel inden reklamationsfristen udløber.',
    notif_prompt_1d: '24 timer før udløb: Sidste garantiudløbsmeddelelse.',
    notif_prompt_maint: 'Rutinevedligeholdelse: Afkalkning, filterrensning og servicepåmindelser.',
    notif_btn_allow: 'Tillad notifikationer',
    notif_btn_later: 'Måske senere',
    notif_toast_warranty_enabled: 'Påmindelser om garantiudløb aktiveret (30d, 7d, 1d).',
    notif_toast_warranty_disabled: 'Påmindelser om garantiudløb deaktiveret.',
    notif_toast_maint_enabled: 'Vedligeholdelsespåmindelser aktiveret.',
    notif_toast_maint_disabled: 'Vedligeholdelsespåmindelser deaktiveret.',
    notif_toast_permission_granted: 'Lokale notifikationsadvarsler aktiveret!',
    notif_toast_permission_denied: 'Notifikationstilladelse ikke givet.',
    notif_warranty_30d_title: '30-dages meddelelse om garantiudløb',
    notif_warranty_30d_msg: 'Lovpligtig garanti for {asset} udløber {date}. Kontroller enheden for at fremsætte krav i tide.',
    notif_warranty_7d_title: '7-dages kritisk garantiudløb',
    notif_warranty_7d_msg: 'Kun 7 dage tilbage før lovpligtig dækning ophører for {asset}. Slutinspektion anbefales.',
    notif_warranty_1d_title: '24-timers sidste garantimeddelelse',
    notif_warranty_1d_msg: 'Lovpligtig garanti for {asset} udløber i morgen ({date}).',
    notif_part_renewal_title: 'Fornyelse af del ({percent} % slid): {part}',
    notif_part_renewal_msg: 'OEM {pno} planlagt serviceinterval: {interval}. Måldato for udskiftning: {date}.',
    notif_maintenance_title: 'Vedligeholdelse forfalder: {step}',
    notif_maintenance_msg: '{detail} (Planlagt frekvens: {freq})',
    notif_test_triggered: 'Testadvarsel udløst for {asset}!',

    status_expiring_soon: 'Udløber snart',
    status_no_date: 'Ingen dato angivet',
    stat_within_90_days: 'Inden for 90 dage',
    attention_expired_one: '1 garanti er udløbet',
    attention_expired_plural: '{count} garantier er udløbet',
    attention_expiring_one: '1 garanti udløber snart',
    attention_expiring_plural: '{count} garantier udløber snart',
    attention_combined_alert: '{expired} udløbet · {expiring} udløber snart',
    drawer_expiring_soon: 'Udløber snart',
    drawer_user_purchase_price: 'Brugerens købspris',
    drawer_estimated_market_value: 'Estimeret markedsværdi',
    not_specified: 'Ikke angivet',
    statutory_protection_title: 'Lovpligtig forbrugerbeskyttelse',
    manufacturer_warranty_title: 'Producentens fabriksgaranti',
    user_coverage_title: 'Din aktive garantidækning',

    drawer_warranty_status_label: 'GARANTISTATUS',
    drawer_warranty_desc: 'Lovpligtig beskyttelse efter Schweizisk CO Art. 210.',
    drawer_purchase_date_label_short: 'Købsdato',
    drawer_warranty_policy_label_short: 'Garantipolitik',
    drawer_purchase_price_label_short: 'Købspris',
    detail_nav_title: 'Aktivdetaljer',
    detail_manual_summary: 'Vedligeholdelsesprotokol anbefalet af producenten.',
    drawer_diag_prompt: 'Hardware fejlkode / symptom:',
    drawer_diag_placeholder: 'f.eks. E24, F10, Fejl 107...',
    drawer_diag_btn: 'Diagnosticer',
    confirm_serial_badge: 'Serienr.',

    add_placeholder_appliance: 'f.eks. Siemens KG86PFIC0N, Miele W1, Dyson V15, DeLonghi Brødrister...',
    add_placeholder_coffee: 'f.eks. DeLonghi Magnifica Plus, Sage Barista Touch, Jura E8...',
    add_placeholder_ebike: 'f.eks. Scott Patron eRIDE, Specialized Turbo Levo, Trek Rail 9.8...',
    add_placeholder_skigear: 'f.eks. Stöckli Laser SL, Atomic Redster S9, Head Worldcup Rebels...',
    promo_line1: 'Beskyt dine husholdningsapparater med lovpligtig garantisporing.',
    promo_line2: 'Scan typeskilte for øjeblikkelige fejlkoder og vedligeholdelsesplaner.',
    mo_policy: 'mdr. garanti',
    statutory_standard: 'Lovpligtig standard',
    coffee_btn_brew_log: 'Bryggedagbog & Justering',
    coffee_btn_brew_again: 'Bryg opskrift',
    coffee_ratio_label: 'Bryggeforhold',
    coffee_btn_start_timer: 'Ekstraktionstimer',
    coffee_extraction_notes_fallback: 'Balanceret og sød ekstraktionsprofil',
    coffee_grinder_step: 'Kværnindstilling: Trin {step}',
    ebike_empty_title: 'Ingen elcykel tilknyttet',
    ebike_empty_desc: 'Tilføj din elcykel for at spore batteritilstand, motortelemetri og kædeslid.',
    ebike_btn_add: 'Tilføj elcykel',
    ski_empty_title: 'Ingen alpinski i samlingen',
    ski_empty_desc: 'Tilføj dine ski for at beregne ISO 11088 DIN-udløsning og spore voksintervaller.',
    ski_btn_add: 'Tilføj skiudstyr',
    tour_step_prefix: 'Trin {current} af {total}',
    tour_btn_back: 'Tilbage',
    tour_btn_skip: 'Spring over',
    tour_btn_start: 'Kom i gang',
    tour_btn_next: 'Næste',
    brand_appliance: 'Hvidevarer Garanti',
    brand_coffee: 'Kaffe Ledsager',
    brand_ebike: 'Elcykel Service',
    brand_skigear: 'Skiservice Sporing',
    nav_home: 'Hjem',
    nav_appliances: 'Hvidevarer',
    nav_add: 'Tilføj',
    nav_warranties: 'Garantier',
    nav_settings: 'Indstillinger',
    nav_today: 'I dag',
    nav_recipes: 'Opskrifter',
    nav_machine: 'Maskine',
    nav_ride: 'Kørsel',
    nav_bike: 'Cykel',
    nav_parts: 'Dele',
    nav_quiver: 'Skiudstyr',
    nav_setup: 'Opsætning',
    nav_tuning: 'Service',
    rooms_all: 'Alle',
    rooms_kitchen: 'Køkken',
    rooms_living: 'Stue',
    rooms_laundry: 'Bryggers',
    rooms_bedroom: 'Soveværelse',
    rooms_bathroom: 'Badeværelse',
    rooms_office: 'Hjemmekontor',
    rooms_dining: 'Spisestue',
    rooms_hallway: 'Gang / Entré',
    rooms_garage: 'Garage',
    rooms_skilocker: 'Skirum',
    rooms_basement: 'Kælder',
    rooms_balcony: 'Altan / Have',
    status_active: 'AKTIV',
    status_expired: 'UDLØBET',
    status_expiring_soon: 'UDLØBER SNART',
    stat_items: 'Registrerede genstande',
    stat_protected: 'Aktive garantier',
    stat_expiring: 'Udløber snart',
    stat_expired: 'Udløbet',
    attention_expired_one: '1 garanti er udløbet',
    attention_all_ok: 'Alle {count} hvidevarer er dækket af garanti',
    empty_appliance_title: 'Ingen hvidevarer registreret',
    empty_appliance_desc: 'Tilføj din første hvidevare for at spore garanti, service og serienumre.',
    btn_add_appliance: 'Tilføj hvidevare',
    expires_on: 'Udløber: {date}',
    add_purchase_date: 'Tilføj købsdato',
    drawer_tab_specs: 'Tekniske specifikationer',
    drawer_tab_maintenance: 'Pleje & Vedligeholdelse',
    drawer_tab_parts: 'Reservedele & Slitage',
    drawer_tab_diagnostics: 'Fejlfinding',
    drawer_purchase_date_label: 'Købsdato (Beregner automatisk garanti):',
    drawer_policy_label: 'Lovpligtig / Producentgaranti:',
    drawer_price_label: 'Købspris (Genanskaffelsesværdi):',
    drawer_est_oem_cost: 'Est. OEM Pris:',
    drawer_btn_replace: 'Registrer udskiftning',
    drawer_btn_delete: 'Slet genstand fra portefølje',
    drawer_delete_confirm: 'Er du sikker på, at du vil slette "{name}"? Dette kan ikke fortrydes.',
    wear_optimal: 'Optimal stand',
    wear_moderate: 'Moderat slitage',
    wear_due_soon: 'Udskiftning snart påkrævet',
    wear_overdue: 'Udskiftning forfalden',
    freq_daily: 'Dagligt',
    freq_weekly: 'Ugentligt',
    freq_monthly: 'Månedligt',
    freq_every_60: 'Hver 60. dag',
    freq_every_90: 'Hver 90. dag',
    freq_every_150km: 'Hver 150 km',
    freq_every_4skidays: 'Hver 4. skidag',
    settings_header: 'Præferencer & Regionale Data',
    settings_lang_label: 'Sprog / Language',
    settings_lang_sub: 'Nordisk og europæisk oversættelse',
    settings_currency_label: 'Valutaformat',
    settings_currency_sub: 'Anvendes på aktivværdier, reservedele og markedspriser',
    settings_statutory_label: 'Lovpligtig reklamationsret',
    settings_statutory_sub: 'Standard garantiperiode for hvidevarer',
    settings_tour_label: 'Guidet introduktionstur',
    settings_reset_demo: 'Nulstil demo-data',
    settings_notif_warranty: 'Garantiudløb påmindelser',
    settings_notif_maintenance: 'Service & Pleje påmindelser',
    settings_timeline_btn: 'Se tidslinje over planlagte notifikationer',
    toast_lang_changed: 'Sprog opdateret til {name}!',
    greeting_morning: 'Godmorgen',
    greeting_afternoon: 'God eftermiddag',
    greeting_evening: 'Godaften',
    home_title: 'Dit Hjem',
    my_appliances: 'Mine Hvidevarer',
    see_all: 'Se alle →',
    add_appliance_cta_title: '+ Tilføj hvidevare',
    add_appliance_cta_desc: 'Scan stregkode, affotografer typeskilt eller søg model',
    all_appliances: 'Alle Hvidevarer',
    warranty_timeline: 'Garantitidslinje',
    stat_fully_covered: 'Fuldt dækket',
    stat_within_90_days: 'Inden for 90 dage',
    stat_action_required: 'Handling påkrævet',
    drawer_active: 'Aktiv',
    drawer_expired: 'Udløbet',
    drawer_step: 'Trin',
    drawer_wear: 'Slitage',
    drawer_interval: 'Interval:',
    drawer_in_use: 'i brug',
    toast_purchase_date_updated: 'Købsdato opdateret! Garanti aktiv til {date}',
    toast_purchase_date_cleared: 'Købsdato ryddet.',
    toast_warranty_policy_updated: 'Garantipolitik opdateret til {months} måneder!',
    toast_purchase_price_updated: 'Købspris opdateret!',
    toast_replacement_logged: 'Udskiftning registreret for {name}! Slitage nulstillet til 0%.',
    toast_currency_changed: 'Valuta opdateret til {label}',
    toast_statutory_changed: 'Lovpligtig standard opdateret til {val} måneder',
    add_modal_title_appliance: 'Tilføj Hvidevare',
    add_modal_title_coffee: 'Tilføj Kaffemaskine',
    add_modal_title_ebike: 'Tilføj Elcykel',
    add_modal_title_skigear: 'Tilføj Skiudstyr',
    add_modal_scan_title: 'Scan Stregkode / QR',
    add_modal_scan_desc: 'EAN-13, UPC eller emballagestregkode',
    add_modal_photo_title: 'Affotografer Typeskilt',
    add_modal_photo_desc: 'Udtræk modelspecifikationer fra typeskiltet',
    add_modal_manual_label: 'Eller indtast præcist produkt / modelnummer:',
    add_modal_quick_test: 'Hurtig test:',
    add_modal_identify_btn: 'Identificer',
    add_modal_camera_instruction: 'Juster stregkode eller typeskilt i søgeren',
    add_modal_test_fixtures: 'Test-stregkoder:',
    confirm_badge: 'VERIFICERET PRODUKT',
    confirm_source_badge: 'Officiel Producentkilde',
    confirm_add_btn: 'Gem i portefølje',
    confirm_searching: 'Søger i produktdatabaser…',
    confirm_verified_title: 'Produkt Identificeret',
    confirm_specs_header: 'PRODUCENT SPECIFIKATIONER',
    confirm_policy_header: 'PRODUCENTGARANTI / POLITIK',
    confirm_market_header: 'REGIONAL MARKEDSVÆRDI',
    confirm_ownership_header: 'DIT EJERSKAB (VALGFRIT)',
    confirm_purchase_date: 'Købsdato:',
    confirm_purchase_price: 'Købspris ({currency}):',
    confirm_warranty_duration: 'Garantiperiode:',
    confirm_room_location: 'Rum / Placering:',
    confirm_save_btn: 'Gem i portefølje',
    confirm_cancel_btn: 'Annuller',
    confirm_warranty_months: '{val} Måneder',
    confirm_warranty_text: '{val} Måneder ({source})',
    confirm_standard_policy: 'Standard Købelovsgaranti',
    confirm_market_unavailable: 'Markedsværdi utilgængelig',
    confirm_years: 'År',
    confirm_months_short: 'Mdr',
    camera_title: 'Live Stregkode- & Typeskiltscanner',
    toast_offline: 'Du er offline. Gemte produktoplysninger er stadig tilgængelige.',
    toast_search_busy: 'Produktsøgning er midlertidigt optaget. Prøv venligst igen om et øjeblik.',
    toast_search_auth_error: 'Produktsøgningstjenesten er forkert konfigureret.',
    toast_search_timeout: 'Søgningen fik timeout. Tjek venligst din internetforbindelse.',
    toast_search_unavailable: 'Produktsøgning er midlertidigt utilgængelig.',
    coffee_barista_deck: 'Barista Bord',
    coffee_todays_extraction: "Dagens Ekstraktion",
    coffee_no_machine_paired: 'Ingen Kaffemaskine Forbundet',
    coffee_add_machine_title: '+ Tilføj Din Kaffemaskine',
    coffee_add_machine_desc: 'Tilslut din espressomaskine for vandkemi, afkalkning og dial-in hukommelse.',
    coffee_easy_mode_badge: 'NEM TILSTAND · BØNNE TIL KOP',
    coffee_15bar_pump: '15-Bar Termoblok',
    coffee_select_beverage: 'VÆLG DRIK',
    coffee_aroma_strength: 'AROMA STYRKE',
    coffee_strength_level: 'Niveau {n} af 5',
    coffee_repeat_brew_label: '1-Tryk Gentag Forrige Bryg',
    coffee_active_recipe_badge: 'AKTIV OPSKRIFT',
    coffee_metric_dose_in: 'DOSERING',
    coffee_metric_yield_out: 'UDBYTTE',
    coffee_metric_target_time: 'MÅLTID',
    coffee_metric_grinder_step: 'KVÆRNINGSTRIN',
    coffee_active_bean_title: 'Aktiv Bønne i Beholderen',
    coffee_bean_cellar_link: 'Bønnekælder ({count}) →',
    coffee_bag_inventory: 'LAGERBEHOLDNING',
    coffee_roaster_notes: 'Ristningsnoter:',
    coffee_water_care_title: 'Vandkemi & Pleje',
    coffee_equipment_care_link: 'Udstyrspleje →',
    coffee_water_source_label: 'KOMMUNAL VANDKILDE',
    coffee_scale_risk_label: 'KALKRISIKO',
    coffee_local_hardness: 'Lokal Hårdhed',
    coffee_next_descale: 'Næste Afkalkning',
    coffee_descale_in_days: 'Om {days} dage',
    coffee_filter_life: 'Filter: {percent}%',
    coffee_filtration_label: 'Filtrering:',
    coffee_dial_in_memory_title: 'Dial-In Hukommelse',
    coffee_attempt_number: 'Forsøg #{n}',
    coffee_grind_label: 'Kværn',
    coffee_total_shots: 'Samlede skud:',
    coffee_my_grinder_fleet: 'MINE KVÆRNE',
    coffee_oem_maintenance: 'OEM Vedligeholdelsesprotokol',
    coffee_descale_cycle_title: 'Thermoblock Afkalkningscyklus',
    coffee_descale_cycle_detail: 'Forfalder om {days} dage · Citronsyre / EcoDecalk',
    coffee_btn_log_done: 'Registrer Udført',
    coffee_filter_cartridge_title: 'Vandfilterpatron',
    coffee_filter_lifespan_detail: '{percent}% levetid tilbage',
    coffee_btn_replaced: 'Udskiftet',
    coffee_freshness_unknown: 'Friskhed ukendt',
    coffee_roast_date_not_specified: 'Ristedato ikke angivet',
    coffee_freshness_degas: 'Afgasning ({days}d efter ristning)',
    coffee_freshness_peak: 'Optimalt Vindue ★ ({days}d)',
    coffee_freshness_mature: 'Moden ({days}d)',
    coffee_freshness_past_peak: 'Efter Topform ({days}d)',
    toast_water_source_changed: 'Vandkilde sat til {city} ({dh} °dH)',
    toast_brew_logged: 'Bryggede {drink}! Gemt i Kaffehukommelsen.',
    toast_brew_loaded: 'Indlæste forrige bryg: {bean} ({dose}g → {yield}g)',
    brew_timer_target_info: 'Mål: {time} for {yield} udbytte ({ratio})',
    brew_btn_resume: 'Genoptag Timer',
    brew_btn_pause_evaluate: 'Pause & Evaluer',
    brew_btn_start: 'Start Timer',
    coffee_under_extracted: 'Under-ekstraheret (Sur):',
    coffee_under_extracted_advice: 'Prøv at male 1 trin finere eller hæv bryggetemperaturen 1°C.',
    coffee_over_extracted: 'Over-ekstraheret (Bitter):',
    coffee_over_extracted_advice: 'Prøv at male 1 trin grovere eller stop ekstraktionen 2 sekunder tidligere.',
    coffee_optimal_extraction: 'Optimal Ekstraktion!',
    coffee_optimal_extraction_desc: 'Afbalanceret sødme og syrlighed. Gemt i bønnehukommelsen.',
    toast_brew_saved: 'Bryg gemt i Personlig Kaffehukommelse!',
    coffee_bean_remaining: 'Tilbageværende:',
    coffee_bean_roast_date: 'Ristedato:',
    coffee_bean_finished: 'Brugt op',
    coffee_bean_mark_finished: 'Marker som opbrugt',
    toast_bean_name_required: 'Indtast venligst et kaffebønnenavn',
    toast_bean_added: '{name} tilføjet til Bønnekælderen!',
    toast_scanning_bean_bag: 'Læser kaffepose-etiket…',
    toast_bean_bag_scanned: 'Pose scannet! Risteri, oprindelse og ristedato udtrukket.',
    toast_bean_finished: 'Markerede {name} som opbrugt.',
    toast_coffee_maintenance_logged: '{task} vedligeholdelse registreret! Timere nulstillet.',
    coffee_recipe_label: 'OPSKRIFT:',
    coffee_metric_dose: 'DOSIS',
    coffee_metric_yield: 'UDBYTTE',
    coffee_metric_time: 'TID',
    coffee_metric_temp: 'TEMPERATUR',
    coffee_bean_origin_label: 'Bønneoprindelse:',
    coffee_tasting_notes_label: 'Smagsnoter:',
    coffee_extraction_steps: 'EKSTRAKTIONSTRIN:',
    coffee_step_1_dose: 'Doser friskkværnet kaffe i filterkurven.',
    coffee_step_2_tamp: 'Tamp jævnt og plant.',
    coffee_step_3_extract: 'Ekstraher indtil måludbytte er nået.',
    toast_recipe_loaded: 'Indlæst: {name}',
    coffee_advisor_loading: 'Rådfører Barista AI for dial-in parametre…',
    coffee_grind_advisor_title: 'BARISTA DIAL-IN RÅDGIVER',
    coffee_advisor_grind: 'KVÆRN',
    coffee_advisor_dose: 'DOSIS',
    coffee_advisor_yield: 'UDBYTTE',
    coffee_advisor_temp: 'TEMPERATUR',
    coffee_sensory_profile: 'Sensorisk Profil:',
    coffee_advisor_calculated_for: 'Beregnet til {roast} ristning med {hardness} vandhårdhed.',
    coffee_recipes_title: 'Opskrifter & Bryglab',
    coffee_bean_cellar: 'Bønnekælder ({count})',
    coffee_filter_all: 'Alle Metoder',
    coffee_filter_espresso: 'Espresso',
    coffee_filter_pour_over: 'Pour-Over (V60)',
    coffee_filter_aeropress: 'Aeropress',
    coffee_filter_cold_brew: 'Cold Brew',
    coffee_filter_cafe_creme: 'Café Crème',
    coffee_advisor_section_title: 'AI BARISTA DIAL-IN RÅDGIVER',
    coffee_advisor_badge: 'Specialkaffe Standarder',
    coffee_advisor_desc: 'Beregn præcise kværntrin, brygforhold, vandtemperaturer og ekstraktionstid kalibreret til din kaffe.',
    coffee_brew_method_label: 'BRYGMETODE',
    coffee_roast_level_label: 'RISTNINGSGRAD',
    coffee_bean_origin_placeholder: 'f.eks. Etiopien Yirgacheffe, Colombia Huila, Kenya AA…',
    coffee_quick_pick: 'Hurtigvalg:',
    coffee_water_hardness_label: 'LOKAL VANDHÅRDHED',
    coffee_calculate_btn: 'Beregn Dial-In & Kværnindstilling',
    coffee_brew_library_title: 'Specialkaffe Bibliotek',
    coffee_machine_maintenance_title: 'Maskinvedligeholdelse & Udstyr',
    ebike_garage_fleet: 'Garageflåde',
    ebike_stat_battery: 'BATTERITILSTAND',
    ebike_stat_odometer: 'TOTAL KILOMETER',
    ebike_next_service: 'Næste service: {km} km',
    ebike_component_wear_title: 'Komponentslitage & Telemetri',
    ebike_all_parts_link: 'Alle dele →',
    ebike_chain_gauge: 'KÆDESLITAGEMÅLER',
    ebike_chain_optimal: '{pct}% (Optimal)',
    ebike_chain_hint: 'Udskift kæde ved 0.75% (SRAM Eagle 12-Speed)',
    ebike_suspension_gauge: 'AFFJEDRING LUFTTRYK',
    ebike_suspension_hint: 'Kalibreret til 78 kg ryttervægt på Fox 38 Float 160mm forgaffel',
    ebike_maintenance_history: 'Seneste Servicehistorik',
    ebike_chain_lubrication: 'Keramisk Kædesmøring',
    ebike_applied_next_due: 'Udført ved {applied} km · Næste ved {due} km',
    ebike_bike_specs_title: 'Cykel Specifikationer',
    ebike_consumables_title: 'Sliddele & Forbrugsstoffer',
    ebike_motor_error_decoder: 'MOTORFEJL AFKODER',
    ebike_motor_diag_desc: 'Indtast en Bosch, Shimano EP8 eller Bafang fejlkode for at få en AI-diagnose.',
    ebike_motor_diag_placeholder: 'Fejlkode (f.eks. 503, 540, 0x04)',
    ebike_btn_decode_error: 'Afkod Motorfejl med AI',
    ebike_frame_serial: 'Stelnummer: •••• 9912',
    toast_ride_recorded: '{km} km tur registreret! Kilometertæller opdateret.',
    ebike_diag_empty_toast: 'Indtast venligst en motorfejlkode (f.eks. 503, 540)',
    ebike_diag_decoding: 'Afkoder fejl {code} med Gemini…',
    ebike_diag_fallback_title: 'Motorsystem Advarsel',
    ebike_diag_cause_label: 'Årsag:',
    ebike_diag_fallback_cause: 'Hastighedssensor eller magnetfejl på eger.',
    ebike_diag_action_label: 'Handling:',
    ebike_diag_fallback_action: 'Kontroller at egermagneten passerer sensoren præcist.',
    ski_alpine_quiver: 'Alpint Skiudstyr',
    ski_metric_din: 'ISO 11088 DIN',
    ski_metric_bsl: '{bsl}mm Sål · {weight}kg Skiløber',
    ski_base_wax: 'GRUNDVOKS',
    ski_snow_range: '{low}°C til {high}°C Kold Sne',
    ski_btn_recalc_din: 'Genberegn Binding DIN (ISO 11088)',
    ski_section_readiness: 'Sæson Klargøring & Service',
    ski_btn_tuning_log: 'Serviceliste →',
    ski_readiness_ski_days: 'Skidage denne sæson',
    ski_readiness_ski_days_val: '{n} Dage på Sne',
    ski_readiness_edge: 'Sidekant Vinkel',
    ski_readiness_edge_val: '{angle}° Diamantslebet ({days} dage siden)',
    ski_readiness_trip: 'Næste Skiferie',
    ski_readiness_trip_val: '{place} (Om {days} dage)',
    ski_checklist_title: 'Pakkeliste & Tjekliste',
    ski_safety_notice: 'Obligatorisk Sikkerhedskrav:',
    ski_safety_notice_desc: 'ISO 11088 DIN-beregninger er vejledende estimater. Skibindingers udløsermoment skal kalibreres fysisk på en certificeret momenttestbænk af en faguddannet skitekniker.',
    ski_base_wax_applied: 'Grundvoks Påført',
    ski_days_on_snow: 'Dage på Sne',
    ski_days_unit: 'Dage',
    ski_wax_advisor_section: 'AI VOKSRÅDGIVER',
    ski_snow_temp_placeholder: 'Snetemperatur °C (f.eks. -12)',
    ski_snow_type_packed: 'Pistepræpareret Sne',
    ski_snow_type_fresh: 'Nysne / Puddersne',
    ski_snow_type_icy: 'Is / Hård Piste',
    ski_snow_type_wet: 'Våd Forårssne',
    ski_btn_get_ai_wax: 'Hent AI Voksanbefaling',
    toast_din_applied: 'DIN {value} anvendt på {binding}!',
    ski_wax_calculating: 'Beregner voksanbefaling til {temp}°C…',
    ski_wax_result_wax: 'ANBEFALET VOKS',
    ski_wax_result_iron: 'STRYGELJERNSTEMP',
    ski_wax_fallback: 'Toko LF Blue fluor-fri voks anbefales til {temp}°C præpareret sne.',
    ski_setup_title: 'Binding & Skistøvle Opsætning',
    ski_tuning_title: 'Kant- & Vokshistorik',
    ski_domain_subtitle: 'Udstyr, DIN Udløsning & Voks'
  },

  // ==================== 4. SVENSKA (sv) ====================
  sv: {
    settings_group_legal: 'JURIDIK, INTEGRITET OCH SUPPORT',
    settings_privacy_title: 'Integritetspolicy',
    settings_privacy_sub: 'Lokal lagring, noll spårning, GDPR och schweizisk FADP-efterlevnad',
    settings_terms_title: 'Användarvillkor (EULA)',
    settings_terms_sub: 'Garantifriskrivningar, säkerhetsregler och Apples standard EULA',
    settings_support_title: 'Kundsupport och systemdiagnostik',
    settings_support_sub: 'E-postsupport, systemtelemetri och hårdvaru-FAQ',
    settings_erase_title: 'Radera alla lokala data och återställ',
    settings_erase_sub: 'Radera alla sparade enheter, garantiloggar och inställningar permanent',
    legal_privacy_modal_title: 'Integritetspolicy och datatransparens',
    legal_privacy_intro: 'Nordic Asset Suite bygger på en strikt lokal integritetsarkitektur. Dina hushållsdata tillhör uteslutande dig.',
    legal_privacy_sec1_title: '1. Lokal lagring på enheten',
    legal_privacy_sec1_body: 'Alla dina vitvaror, serienummer, inköpsdatum och underhållsloggar sparas lokalt på din enhet. Vi säljer eller delar aldrig dina uppgifter med tredje part.',
    legal_privacy_sec2_title: '2. Kamera, foton och OCR av typskylt',
    legal_privacy_sec2_body: 'Foton analyseras i realtid för textigenkänning och sparas aldrig permanent på externa servrar.',
    legal_privacy_sec3_title: '3. Tredjepartstjänster för specifikationer',
    legal_privacy_sec3_body: 'Specifikationssökningar görs via krypterade API-anslutningar utan överföring av personuppgifter.',
    legal_privacy_sec4_title: '4. GDPR och raderingsrättigheter',
    legal_privacy_sec4_body: 'Du kan när som helst radera alla data via inställningarna. Avinstallation av appen tar bort alla lokala register.',
    legal_privacy_sec5_title: '5. Kontakt',
    legal_privacy_sec5_body: 'Kontakta oss på privacy@nordicasset.app vid frågor om dataskydd.',
    legal_terms_modal_title: 'Användarvillkor och standard EULA',
    legal_terms_intro: 'Läs igenom dessa användarvillkor och EULA innan du använder Nordic Asset Suite.',
    legal_terms_sec1_title: '1. Apples standard EULA-avtal',
    legal_terms_sec1_body: 'Användning regleras av Apples standard EULA-villkor och dessa tilläggsvillkor.',
    legal_terms_sec2_title: '2. Ansvarsfriskrivning för garanti',
    legal_terms_sec2_body: 'Beräkningar av garantiutgång är vägledande och utgör inte en försäkringspolicy eller juridisk garanti.',
    legal_terms_sec3_title: '3. Säkerhetsfriskrivning',
    legal_terms_sec3_body: 'Användaren bär det fulla ansvaret för fysiskt underhåll och elsäkerhet.',
    legal_terms_sec4_title: '4. Varumärken',
    legal_terms_sec4_body: 'Alla varumärken tillhör sina respektive ägare. Nordic Asset Suite är ett oberoende verktyg.',
    legal_terms_sec5_title: '5. Tillämplig lag',
    legal_terms_sec5_body: 'Villkoren styrs av schweizisk lag med jurisdiktion i Zürich.',
    legal_support_modal_title: 'Kundsupport och diagnostik',
    legal_support_intro: 'Vårt schweiziska ingenjörsteam är redo att hjälpa dig.',
    legal_support_email_label: 'Direkt support-e-post',
    legal_support_version_label: 'Applikationsversion',
    legal_support_diag_btn: 'Kopiera systemdiagnostikrapport',
    legal_support_faq_title: 'Vanliga frågor',
    legal_support_faq1_q: 'Hur beräknas garantiutgången?',
    legal_support_faq1_a: 'Genom att kombinera ditt inköpsdatum med bekräftade tillverkargarantier eller lagstadgade frister.',
    legal_support_faq2_q: 'Sparas typskyltsfoton i molnet?',
    legal_support_faq2_a: 'Nej. OCR-identifiering sker direkt utan permanent extern lagring.',
    legal_support_faq3_q: 'Kan jag exportera mina data?',
    legal_support_faq3_a: 'Ja, dina data sparas i strukturerat format via din enhetskopia.',
    legal_erase_confirm_prompt: 'Är du säker på att du vill radera alla sparade enheter och inställningar permanent?',
    legal_erase_toast_success: 'Alla lokala data har raderats.',

    notif_log_title: 'Schemalagda garanti- och servicevarningar',
    notif_log_desc: 'Alla aviseringar utvärderas lokalt på enheten. Nedan visas ditt aktiva garantiskyddsschema:',
    notif_empty_desc: 'Inga aktiva enheter hittades. Lägg till produkter för att se schemalagda garanti- och serviceaviseringar.',
    notif_asset_label: 'Enhet',
    notif_settings_group: 'GARANTI- OCH SERVICEAVISERINGAR',
    notif_settings_warranty_title: 'Påminnelser om garantiutgång',
    notif_settings_warranty_desc: 'Avisera 30 dagar, 7 dagar och 1 dag före lagstadgat garantislut',
    notif_settings_maint_title: 'Påminnelser om underhåll och service',
    notif_settings_maint_desc: 'Avkalkning, filterbyten och serviceintervaller',
    notif_settings_timeline: 'Visa tidslinje för schemalagda aviseringar',
    notif_prompt_title: 'Aktivera aviseringar om garantiskydd',
    notif_prompt_desc: 'Nordic Asset Suite skyddar din hushållsinvestering genom att leverera lokala aviseringar i god tid innan skyddet upphör:',
    notif_prompt_30d: '30 dagar före utgång: Tidig avisering för att boka kontroll eller göra garantianspråk.',
    notif_prompt_7d: '7 dagar före utgång: Kritisk sista påminnelse inför reklamationsfristens slut.',
    notif_prompt_1d: '24 timmar före utgång: Slutgiltig avisering om garantiutgång.',
    notif_prompt_maint: 'Rutinunderhåll: Avkalkning, filterrengöring och serviceuppmaningar.',
    notif_btn_allow: 'Tillåt aviseringar',
    notif_btn_later: 'Kanske senare',
    notif_toast_warranty_enabled: 'Påminnelser om garantiutgång aktiverade (30d, 7d, 1d).',
    notif_toast_warranty_disabled: 'Påminnelser om garantiutgång inaktiverade.',
    notif_toast_maint_enabled: 'Underhållspåminnelser aktiverade.',
    notif_toast_maint_disabled: 'Underhållspåminnelser inaktiverade.',
    notif_toast_permission_granted: 'Lokala aviseringar aktiverade!',
    notif_toast_permission_denied: 'Aviseringstillstånd beviljades inte.',
    notif_warranty_30d_title: '30-dagars meddelande om garantiutgång',
    notif_warranty_30d_msg: 'Lagstadgad garanti för {asset} löper ut {date}. Granska skicket för att lämna in anspråk i tid.',
    notif_warranty_7d_title: '7-dagars kritisk garantitidsfrist',
    notif_warranty_7d_msg: 'Endast 7 dagar återstår innan lagstadgat skydd upphör för {asset}. Slutbesiktning rekommenderas.',
    notif_warranty_1d_title: '24-timmars sista garantimeddelande',
    notif_warranty_1d_msg: 'Lagstadgad garanti för {asset} upphör imorgon ({date}).',
    notif_part_renewal_title: 'Förnyelse av del ({percent} % slitage): {part}',
    notif_part_renewal_msg: 'OEM {pno} schemalagt serviceintervall: {interval}. Måldatum för byte: {date}.',
    notif_maintenance_title: 'Service förfaller: {step}',
    notif_maintenance_msg: '{detail} (Schemalagd frekvens: {freq})',
    notif_test_triggered: 'Testavisering utlöst för {asset}!',

    status_expiring_soon: 'Löper ut snart',
    status_no_date: 'Inget datum angivet',
    stat_within_90_days: 'Inom 90 dagar',
    attention_expired_one: '1 garanti har löpt ut',
    attention_expired_plural: '{count} garantier har löpt ut',
    attention_expiring_one: '1 garanti löper ut snart',
    attention_expiring_plural: '{count} garantier löper ut snart',
    attention_combined_alert: '{expired} utgången · {expiring} löper ut snart',
    drawer_expiring_soon: 'Löper ut snart',
    drawer_user_purchase_price: 'Användarens inköpspris',
    drawer_estimated_market_value: 'Uppskattat marknadsvärde',
    not_specified: 'Ej angivet',
    statutory_protection_title: 'Lagstadgat konsumentskydd',
    manufacturer_warranty_title: 'Tillverkarens fabriksgaranti',
    user_coverage_title: 'Ditt aktiva garantiskydd',

    drawer_warranty_status_label: 'GARANTISTATUS',
    drawer_warranty_desc: 'Lagstadgat skydd enligt Schweizisk CO Art. 210.',
    drawer_purchase_date_label_short: 'Inköpsdatum',
    drawer_warranty_policy_label_short: 'Garantipolicy',
    drawer_purchase_price_label_short: 'Inköpspris',
    detail_nav_title: 'Tillgångsdetaljer',
    detail_manual_summary: 'Underhållsprotokoll rekommenderat av tillverkaren.',
    drawer_diag_prompt: 'Hårdvarufelkod / symptom:',
    drawer_diag_placeholder: 't.ex. E24, F10, Fel 107...',
    drawer_diag_btn: 'Diagnostisera',
    confirm_serial_badge: 'Serienummer',

    add_placeholder_appliance: 't.ex. Siemens KG86PFIC0N, Miele W1, Dyson V15, DeLonghi Brödrost...',
    add_placeholder_coffee: 't.ex. DeLonghi Magnifica Plus, Sage Barista Touch, Jura E8...',
    add_placeholder_ebike: 't.ex. Scott Patron eRIDE, Specialized Turbo Levo, Trek Rail 9.8...',
    add_placeholder_skigear: 't.ex. Stöckli Laser SL, Atomic Redster S9, Head Worldcup Rebels...',
    promo_line1: 'Skydda dina hushållsapparater med lagstadgad garantispårning.',
    promo_line2: 'Skanna typskyltar för omedelbara felkoder och underhållsscheman.',
    mo_policy: 'mån. garanti',
    statutory_standard: 'Lagstadgad standard',
    coffee_btn_brew_log: 'Brygglogg & Inställning',
    coffee_btn_brew_again: 'Brygg recept',
    coffee_ratio_label: 'Bryggförhållande',
    coffee_btn_start_timer: 'Extraktionstimer',
    coffee_extraction_notes_fallback: 'Balanserad och söt extraktionsprofil',
    coffee_grinder_step: 'Malningsgrad: Steg {step}',
    ebike_empty_title: 'Ingen elcykel kopplad',
    ebike_empty_desc: 'Lägg till din elcykel för att övervaka batterihälsa, motortelemetri och kedjeslitage.',
    ebike_btn_add: 'Lägg till elcykel',
    ski_empty_title: 'Inga alpinskidor i samlingen',
    ski_empty_desc: 'Lägg till dina skidor för att beräkna ISO 11088 DIN-utlösning och följa vallaintervall.',
    ski_btn_add: 'Lägg till skidor',
    tour_step_prefix: 'Steg {current} av {total}',
    tour_btn_back: 'Tillbaka',
    tour_btn_skip: 'Hoppa över',
    tour_btn_start: 'Kom igång',
    tour_btn_next: 'Nästa',
    brand_appliance: 'Vitvaror Garanti',
    brand_coffee: 'Kaffe Följeslagare',
    brand_ebike: 'Elcykel Service',
    brand_skigear: 'Skidutrustning Spårning',
    nav_home: 'Hem',
    nav_appliances: 'Vitvaror',
    nav_add: 'Lägg till',
    nav_warranties: 'Garantier',
    nav_settings: 'Inställningar',
    nav_today: 'Idag',
    nav_recipes: 'Recept',
    nav_machine: 'Maskin',
    nav_ride: 'Tur',
    nav_bike: 'Cykel',
    nav_parts: 'Delar',
    nav_quiver: 'Skidor',
    nav_setup: 'Inställning',
    nav_tuning: 'Service',
    rooms_all: 'Alla',
    rooms_kitchen: 'Kök',
    rooms_living: 'Vardagsrum',
    rooms_laundry: 'Tvättstuga',
    rooms_bedroom: 'Sovrum',
    rooms_bathroom: 'Badrum',
    rooms_office: 'Hemmakontor',
    rooms_dining: 'Matsal',
    rooms_hallway: 'Hall / Garderob',
    rooms_garage: 'Garage',
    rooms_skilocker: 'Skidförråd',
    rooms_basement: 'Källare',
    rooms_balcony: 'Balkong / Trädgård',
    status_active: 'AKTIV',
    status_expired: 'UTGÅNGEN',
    status_expiring_soon: 'GÅR UT SNART',
    stat_items: 'Registrerade enheter',
    stat_protected: 'Aktiva garantier',
    stat_expiring: 'Går ut snart',
    stat_expired: 'Utgången',
    attention_expired_one: '1 garanti har gått ut',
    attention_all_ok: 'Alla {count} vitvaror skyddas av garanti',
    empty_appliance_title: 'Inga vitvaror registrerade',
    empty_appliance_desc: 'Lägg till din första vitvara för att hålla koll på garantier, underhåll och serienummer.',
    btn_add_appliance: 'Lägg till vitvara',
    expires_on: 'Går ut: {date}',
    add_purchase_date: 'Lägg till inköpsdatum',
    drawer_tab_specs: 'Tekniska specifikationer',
    drawer_tab_maintenance: 'Skötsel & Underhåll',
    drawer_tab_parts: 'Reservdelar & Slitage',
    drawer_tab_diagnostics: 'Felsökning',
    drawer_purchase_date_label: 'Inköpsdatum (Beräknar garanti automatiskt):',
    drawer_policy_label: 'Lagstadgad / Tillverkargaranti:',
    drawer_price_label: 'Inköpspris (Återanskaffningsvärde):',
    drawer_est_oem_cost: 'Beräknat OEM-pris:',
    drawer_btn_replace: 'Registrera byte',
    drawer_btn_delete: 'Ta bort enhet från portfölj',
    drawer_delete_confirm: 'Är du säker på att du vill ta bort "{name}"? Detta går inte att ångra.',
    wear_optimal: 'Perfekt skick',
    wear_moderate: 'Måttligt slitage',
    wear_due_soon: 'Byte krävs snart',
    wear_overdue: 'Byte förfallet',
    freq_daily: 'Dagligen',
    freq_weekly: 'Varje vecka',
    freq_monthly: 'Varje månad',
    freq_every_60: 'Var 60:e dag',
    freq_every_90: 'Var 90:e dag',
    freq_every_150km: 'Var 150:e km',
    freq_every_4skidays: 'Var 4:e skiddag',
    settings_header: 'Inställningar & Regionala Data',
    settings_lang_label: 'Språk / Language',
    settings_lang_sub: 'Nordisk och europeisk översättning',
    settings_currency_label: 'Valutaformat',
    settings_currency_sub: 'Tillämpas på tillgångsvärden, reservdelar och marknadspriser',
    settings_statutory_label: 'Lagstadgad reklamationsrätt',
    settings_statutory_sub: 'Standard garantiperiod för vitvaror',
    settings_tour_label: 'Guidad introduktionstur',
    settings_reset_demo: 'Återställ demodata',
    settings_notif_warranty: 'Påminnelser om garantiutgång',
    settings_notif_maintenance: 'Underhålls- och servicepåminnelser',
    settings_timeline_btn: 'Visa tidslinje för schemalagda aviseringar',
    toast_lang_changed: 'Språk uppdaterat till {name}!',
    greeting_morning: 'God morgon',
    greeting_afternoon: 'God eftermiddag',
    greeting_evening: 'God kväll',
    home_title: 'Ditt Hem',
    my_appliances: 'Mina Vitvaror',
    see_all: 'Visa alla →',
    add_appliance_cta_title: '+ Lägg till vitvara',
    add_appliance_cta_desc: 'Skanna streckkod, fotografera typskylt eller sök modell',
    all_appliances: 'Alla Vitvaror',
    warranty_timeline: 'Garantitidslinje',
    stat_fully_covered: 'Helt täckt',
    stat_within_90_days: 'Inom 90 dagar',
    stat_action_required: 'Åtgärd krävs',
    drawer_active: 'Aktiv',
    drawer_expired: 'Utgången',
    drawer_step: 'Steg',
    drawer_wear: 'Slitage',
    drawer_interval: 'Intervall:',
    drawer_in_use: 'i bruk',
    toast_purchase_date_updated: 'Inköpsdatum uppdaterat! Garanti aktiv till {date}',
    toast_purchase_date_cleared: 'Inköpsdatum rensat.',
    toast_warranty_policy_updated: 'Garantipolicy uppdaterad till {months} månader!',
    toast_purchase_price_updated: 'Inköpspris uppdaterat!',
    toast_replacement_logged: 'Byte registrerat för {name}! Slitage nollställt till 0%.',
    toast_currency_changed: 'Valuta uppdaterad till {label}',
    toast_statutory_changed: 'Lagstadgad standard uppdaterad till {val} månader',
    add_modal_title_appliance: 'Lägg till Vitvara',
    add_modal_title_coffee: 'Lägg till Kaffemaskin',
    add_modal_title_ebike: 'Lägg till Elcykel',
    add_modal_title_skigear: 'Lägg till Skidutrustning',
    add_modal_scan_title: 'Skanna Streckkod / QR',
    add_modal_scan_desc: 'EAN-13, UPC eller förpackningsstreckkod',
    add_modal_photo_title: 'Fotografera Typskylt',
    add_modal_photo_desc: 'Extrahera modellspecifikationer från typskylten',
    add_modal_manual_label: 'Eller ange exakt produkt / modellnummer:',
    add_modal_quick_test: 'Snabbtest:',
    add_modal_identify_btn: 'Identifiera',
    add_modal_camera_instruction: 'Rikta in streckkod eller typskylt i sökaren',
    add_modal_test_fixtures: 'Teststreckkoder:',
    confirm_badge: 'VERIFIERAD PRODUKT',
    confirm_source_badge: 'Officiell Tillverkarkälla',
    confirm_add_btn: 'Spara till portfölj',
    confirm_searching: 'Söker i produktdatabaser…',
    confirm_verified_title: 'Produkt Identifierad',
    confirm_specs_header: 'TILLVERKARSPECIFIKATIONER',
    confirm_policy_header: 'TILLVERKARGARANTI / POLICY',
    confirm_market_header: 'REGIONAL MARKNADSVÄRDE',
    confirm_ownership_header: 'DITT ÄGANDE (VALFRITT)',
    confirm_purchase_date: 'Inköpsdatum:',
    confirm_purchase_price: 'Inköpspris ({currency}):',
    confirm_warranty_duration: 'Garantitid:',
    confirm_room_location: 'Rum / Plats:',
    confirm_save_btn: 'Spara till portfölj',
    confirm_cancel_btn: 'Avbryt',
    confirm_warranty_months: '{val} Månader',
    confirm_warranty_text: '{val} Månader ({source})',
    confirm_standard_policy: 'Standard Konsumentköplag',
    confirm_market_unavailable: 'Marknadsvärde ej tillgängligt',
    confirm_years: 'År',
    confirm_months_short: 'Mån',
    camera_title: 'Live Streckkods- och Typskyltläsare',
    toast_offline: 'Du är offline. Sparade produktuppgifter är fortfarande tillgängliga.',
    toast_search_busy: 'Produktsökningen är tillfälligt upptagen. Försök igen om en stund.',
    toast_search_auth_error: 'Produktsökningstjänsten är felkonfigurerad.',
    toast_search_timeout: 'Sökförfrågan nådde timeout. Kontrollera din anslutning.',
    toast_search_unavailable: 'Produktsökning är tillfälligt otillgänglig.',
    coffee_barista_deck: 'Baristabänk',
    coffee_todays_extraction: "Dagens Extraktion",
    coffee_no_machine_paired: 'Ingen Kaffemaskin Ansluten',
    coffee_add_machine_title: '+ Lägg till Din Kaffemaskin',
    coffee_add_machine_desc: 'Anslut din espressomaskin för vattenkemi, avkalkning och receptminne.',
    coffee_easy_mode_badge: 'ENKELT LÄGE · BÖNA TILL KOPP',
    coffee_15bar_pump: '15-Bar Termoblock',
    coffee_select_beverage: 'VÄLJ DRYCK',
    coffee_aroma_strength: 'AROMAINTENSITET',
    coffee_strength_level: 'Nivå {n} av 5',
    coffee_repeat_brew_label: '1-Klick Upprepa Förra Bryggningen',
    coffee_active_recipe_badge: 'AKTIVT MÅLRECEPT',
    coffee_metric_dose_in: 'DOSERING',
    coffee_metric_yield_out: 'UTBYTE',
    coffee_metric_target_time: 'MÅLTID',
    coffee_metric_grinder_step: 'MALNINGSGRAD',
    coffee_active_bean_title: 'Aktiv Böna i Behållaren',
    coffee_bean_cellar_link: 'Bönkällare ({count}) →',
    coffee_bag_inventory: 'LAGERBEHÅLLNING',
    coffee_roaster_notes: 'Rostningsnoter:',
    coffee_water_care_title: 'Vattenkemi & Skötsel',
    coffee_equipment_care_link: 'Utrustningsskötsel →',
    coffee_water_source_label: 'KOMMUNAL VATTENKÄLLA',
    coffee_scale_risk_label: 'KALKRISK',
    coffee_local_hardness: 'Lokal Hårdhet',
    coffee_next_descale: 'Nästa Avkalkning',
    coffee_descale_in_days: 'Om {days} dagar',
    coffee_filter_life: 'Filter: {percent}%',
    coffee_filtration_label: 'Filtrering:',
    coffee_dial_in_memory_title: 'Dial-In Minne',
    coffee_attempt_number: 'Försök #{n}',
    coffee_grind_label: 'Kvarn',
    coffee_total_shots: 'Totalt antal shots:',
    coffee_my_grinder_fleet: 'MINA KVARNAR',
    coffee_oem_maintenance: 'OEM Underhållsprotokoll',
    coffee_descale_cycle_title: 'Thermoblock Avkalkningscykel',
    coffee_descale_cycle_detail: 'Förfaller om {days} dagar · Citronsyra / EcoDecalk',
    coffee_btn_log_done: 'Registrera Utförd',
    coffee_filter_cartridge_title: 'Vattenfilterpatron',
    coffee_filter_lifespan_detail: '{percent}% livslängd kvar',
    coffee_btn_replaced: 'Bytt',
    coffee_freshness_unknown: 'Färskhet okänd',
    coffee_roast_date_not_specified: 'Rostdatum ej angivet',
    coffee_freshness_degas: 'Avgasning ({days}d efter rostning)',
    coffee_freshness_peak: 'Optimalt Fönster ★ ({days}d)',
    coffee_freshness_mature: 'Mogen ({days}d)',
    coffee_freshness_past_peak: 'Efter Topp ({days}d)',
    toast_water_source_changed: 'Vattenkälla inställd på {city} ({dh} °dH)',
    toast_brew_logged: 'Bryggde {drink}! Sparad i Kaffeminnet.',
    toast_brew_loaded: 'Laddade tidigare bryggning: {bean} ({dose}g → {yield}g)',
    brew_timer_target_info: 'Mål: {time} för {yield} utbyte ({ratio})',
    brew_btn_resume: 'Återuppta Timer',
    brew_btn_pause_evaluate: 'Pausa & Utvärdera',
    brew_btn_start: 'Starta Timer',
    coffee_under_extracted: 'Underextraherad (Sur):',
    coffee_under_extracted_advice: 'Prova att mala 1 steg finare eller höj temperaturen 1°C.',
    coffee_over_extracted: 'Överextraherad (Bitter):',
    coffee_over_extracted_advice: 'Prova att mala 1 steg grövre eller stoppa 2 sekunder tidigare.',
    coffee_optimal_extraction: 'Optimal Extraktion!',
    coffee_optimal_extraction_desc: 'Balanserad sötma och syra. Sparad i bönminnet.',
    toast_brew_saved: 'Bryggning sparad i Personligt Kaffeminne!',
    coffee_bean_remaining: 'Kvarvarande:',
    coffee_bean_roast_date: 'Rostdatum:',
    coffee_bean_finished: 'Slut',
    coffee_bean_mark_finished: 'Markera som slut',
    toast_bean_name_required: 'Ange ett kaffebönnamn',
    toast_bean_added: '{name} lades till i Bönkällaren!',
    toast_scanning_bean_bag: 'Läser kaffepåsens etikett…',
    toast_bean_bag_scanned: 'Påse skannad! Rosteri, ursprung och rostdatum extraherade.',
    toast_bean_finished: 'Markerade {name} som slut.',
    toast_coffee_maintenance_logged: '{task} underhåll registrerat! Timers nollställda.',
    coffee_recipe_label: 'RECEPT:',
    coffee_metric_dose: 'DOS',
    coffee_metric_yield: 'UTBYTE',
    coffee_metric_time: 'TID',
    coffee_metric_temp: 'TEMPERATUR',
    coffee_bean_origin_label: 'Bönans Ursprung:',
    coffee_tasting_notes_label: 'Smaknoter:',
    coffee_extraction_steps: 'EXTRAKTIONSSTEG:',
    coffee_step_1_dose: 'Dosera nymalet kaffe i filterkorgen.',
    coffee_step_2_tamp: 'Tampa jämnt och vågrätt.',
    coffee_step_3_extract: 'Extrahera tills målutbyte uppnås.',
    toast_recipe_loaded: 'Laddat: {name}',
    coffee_advisor_loading: 'Rådfrågar Barista AI för dial-in parametrar…',
    coffee_grind_advisor_title: 'BARISTA DIAL-IN RÅDGIVARE',
    coffee_advisor_grind: 'MALNING',
    coffee_advisor_dose: 'DOS',
    coffee_advisor_yield: 'UTBYTE',
    coffee_advisor_temp: 'TEMPERATUR',
    coffee_sensory_profile: 'Sensorisk Profil:',
    coffee_advisor_calculated_for: 'Beräknat för {roast} rostning med {hardness} vattenhårdhet.',
    coffee_recipes_title: 'Recept & Brygglabb',
    coffee_bean_cellar: 'Bönkällare ({count})',
    coffee_filter_all: 'Alla Metoder',
    coffee_filter_espresso: 'Espresso',
    coffee_filter_pour_over: 'Pour-Over (V60)',
    coffee_filter_aeropress: 'Aeropress',
    coffee_filter_cold_brew: 'Cold Brew',
    coffee_filter_cafe_creme: 'Café Crème',
    coffee_advisor_section_title: 'AI BARISTA DIAL-IN RÅDGIVARE',
    coffee_advisor_badge: 'Specialkaffestandarder',
    coffee_advisor_desc: 'Beräkna exakta malningssteg, bryggförhållanden, vattentemperaturer och flödestider.',
    coffee_brew_method_label: 'BRYGGMETOD',
    coffee_roast_level_label: 'ROSTNINGSGRAD',
    coffee_bean_origin_placeholder: 't.ex. Etiopien Yirgacheffe, Colombia Huila, Kenya AA…',
    coffee_quick_pick: 'Snabbval:',
    coffee_water_hardness_label: 'LOKAL VATTENHÅRDHET',
    coffee_calculate_btn: 'Beräkna Dial-In & Malningsgrad',
    coffee_brew_library_title: 'Specialkaffebibliotek',
    coffee_machine_maintenance_title: 'Maskinunderhåll & Utrustning',
    ebike_garage_fleet: 'Garageflotta',
    ebike_stat_battery: 'BATTERIHÄLSA',
    ebike_stat_odometer: 'TOTAL KILOMETER',
    ebike_next_service: 'Nästa service: {km} km',
    ebike_component_wear_title: 'Komponentslitage & Telemetri',
    ebike_all_parts_link: 'Alla delar →',
    ebike_chain_gauge: 'KEDJESLITAGEMÄTARE',
    ebike_chain_optimal: '{pct}% (Optimal)',
    ebike_chain_hint: 'Byt kedja vid 0.75% (SRAM Eagle 12-Speed)',
    ebike_suspension_gauge: 'DÄMPARTRYCK',
    ebike_suspension_hint: 'Kalibrerat för 78 kg åkarvikt på Fox 38 Float 160mm gaffel',
    ebike_maintenance_history: 'Senaste Servicehistorik',
    ebike_chain_lubrication: 'Keramisk Kedjesmörjning',
    ebike_applied_next_due: 'Utfört vid {applied} km · Nästa vid {due} km',
    ebike_bike_specs_title: 'Cykel Specifikationer',
    ebike_consumables_title: 'Slitdelar & Förbrukningsartiklar',
    ebike_motor_error_decoder: 'MOTORFEL AVKODARE',
    ebike_motor_diag_desc: 'Ange en Bosch, Shimano EP8 eller Bafang felkod för att få en AI-diagnos.',
    ebike_motor_diag_placeholder: 'Felkod (t.ex. 503, 540, 0x04)',
    ebike_btn_decode_error: 'Avkoda Motorfel med AI',
    ebike_frame_serial: 'Ramnummer: •••• 9912',
    toast_ride_recorded: '{km} km tur registrerad! Vägmätare uppdaterad.',
    ebike_diag_empty_toast: 'Ange en motorfelkod (t.ex. 503, 540)',
    ebike_diag_decoding: 'Avkodar fel {code} med Gemini…',
    ebike_diag_fallback_title: 'Motorsystem Varning',
    ebike_diag_cause_label: 'Orsak:',
    ebike_diag_fallback_cause: 'Hastighetssensor eller ekermagnetfel.',
    ebike_diag_action_label: 'Åtgärd:',
    ebike_diag_fallback_action: 'Kontrollera att magneten på ekern passerar sensorn korrekt.',
    ski_alpine_quiver: 'Alpin Skidutrustning',
    ski_metric_din: 'ISO 11088 DIN',
    ski_metric_bsl: '{bsl}mm Sula · {weight}kg Skidåkare',
    ski_base_wax: 'GRUNDVALLA',
    ski_snow_range: '{low}°C till {high}°C Kall Snö',
    ski_btn_recalc_din: 'Omberäkna Bindning DIN (ISO 11088)',
    ski_section_readiness: 'Säsongsklargöring & Service',
    ski_btn_tuning_log: 'Servicelogg →',
    ski_readiness_ski_days: 'Skiddagar denna säsong',
    ski_readiness_ski_days_val: '{n} Dagar på Snö',
    ski_readiness_edge: 'Sidokant Vinkel',
    ski_readiness_edge_val: '{angle}° Diamantslipad ({days} dagar sedan)',
    ski_readiness_trip: 'Nästa Skidresa',
    ski_readiness_trip_val: '{place} (Om {days} dagar)',
    ski_checklist_title: 'Packlista & Resechecklista',
    ski_safety_notice: 'Obligatoriskt Säkerhetskrav:',
    ski_safety_notice_desc: 'ISO 11088 DIN-beräkningar är informativa uppskattningar. Skidbindningens utlösningsmoment måste kalibreras fysiskt på en certifierad testbänk av en fackutbildad tekniker.',
    ski_base_wax_applied: 'Grundvalla Applicerad',
    ski_days_on_snow: 'Dagar på Snö',
    ski_days_unit: 'Dagar',
    ski_wax_advisor_section: 'AI VALLARÅDGIVARE',
    ski_snow_temp_placeholder: 'Snötemperatur °C (t.ex. -12)',
    ski_snow_type_packed: 'Pistpreparerad Snö',
    ski_snow_type_fresh: 'Nysnö / Pudersnö',
    ski_snow_type_icy: 'Isig / Hård Pist',
    ski_snow_type_wet: 'Våt Vårsnö',
    ski_btn_get_ai_wax: 'Hämta AI Vallarekommendation',
    toast_din_applied: 'DIN {value} applicerades på {binding}!',
    ski_wax_calculating: 'Beräknar vallarekommendation för {temp}°C…',
    ski_wax_result_wax: 'REKOMMENDERAD VALLA',
    ski_wax_result_iron: 'VALLAJÄRNSTEMP',
    ski_wax_fallback: 'Toko LF Blue fluorfri valla rekommenderas för {temp}°C preparerad snö.',
    ski_setup_title: 'Bindning & Skidpjäxa Inställning',
    ski_tuning_title: 'Kant- & Vallningshistorik',
    ski_domain_subtitle: 'Utrustning, DIN Utlösning & Valla'
  },

  // ==================== 5. NORSK (no) ====================
  no: {
    settings_group_legal: 'JURIDISK, PERSONVERN OG STØTTE',
    settings_privacy_title: 'Personvernerklæring',
    settings_privacy_sub: 'Lokal lagring, null sporing, GDPR og sveitsisk FADP-samsvar',
    settings_terms_title: 'Bruksvilkår (EULA)',
    settings_terms_sub: 'Garantifraskrivelser, sikkerhetsregler og Apples standard EULA',
    settings_support_title: 'Kundestøtte og systemdiagnostikk',
    settings_support_sub: 'E-posthjelp, systemtelemetri og maskinvare-FAQ',
    settings_erase_title: 'Slett alle lokale data og tilbakestill',
    settings_erase_sub: 'Slett alle lagrede enheter, garantilogger og innstillinger permanent',
    legal_privacy_modal_title: 'Personvernerklæring og datainnsyn',
    legal_privacy_intro: 'Nordic Asset Suite er bygget på en streng personvernarkitektur med lokal lagring. Vi mener dine husholdningsdata kun tilhører deg.',
    legal_privacy_sec1_title: '1. Lokal lagring på enheten',
    legal_privacy_sec1_body: 'Alle dine hvitevarer, serienumre, kjøpsdatoer, garantipoliser og vedlikeholdslogger lagres lokalt på din enhet. Vi selger, leier eller deler aldri dine personopplysninger med tredjeparter eller annonsører.',
    legal_privacy_sec2_title: '2. Kamera, bilder og OCR av typeskilt',
    legal_privacy_sec2_body: 'Når du bruker kameraet til å identifisere modellnummer og serienummer, behandles bildene umiddelbart for tekstgjenkjenning. Råbilder lagres aldri permanent på eksterne sporingsservere.',
    legal_privacy_sec3_title: '3. Tredjepartstjenester for spesifikasjoner',
    legal_privacy_sec3_body: 'Ved søk etter ukjente produktspesifikasjoner rutes forespørsler gjennom krypterte API-er (Gemini Vision og Tavily Search) for å hente produsentdata. Ingen personidentifiserbare data overføres.',
    legal_privacy_sec4_title: '4. GDPR og rettigheter for sletting',
    legal_privacy_sec4_body: 'Du har full rett til å inspisere, eksportere eller permanent slette alle data via innstillingene når som helst. Sletting av appen fjerner også alle lokale databaseregistre.',
    legal_privacy_sec5_title: '5. Personvernkontakt',
    legal_privacy_sec5_body: 'For spørsmål om personvern, kontakt vårt personvernombud på privacy@nordicasset.app.',
    legal_terms_modal_title: 'Bruksvilkår og standard EULA',
    legal_terms_intro: 'Vennligst les gjennom disse bruksvilkårene og sluttbrukeravtalen (EULA) før du tar i bruk Nordic Asset Suite.',
    legal_terms_sec1_title: '1. Apples standard EULA-lisensavtale',
    legal_terms_sec1_body: 'Din lisens til å bruke applikasjonen reguleres av Apples standard EULA-vilkår (apple.com/legal/internet-services/itunes/dev/stdeula/) og disse tilleggsbestemmelsene.',
    legal_terms_sec2_title: '2. Ansvarsfraskrivelse for garantiinformasjon',
    legal_terms_sec2_body: 'Beregning av garantiutløp og lovfestet reklamasjonsfrist (som sveitsisk CO Art. 210, forbrukerkjøpsloven eller produsentgarantier) er kun ment som veiledende informasjon og utgjør ikke en forsikringspolise eller juridisk garanti.',
    legal_terms_sec3_title: '3. Sikkerhetsfraskrivelse for vedlikehold',
    legal_terms_sec3_body: 'Rengjøringsprotokoller, deleskift og DIN-kalkulatorer er anbefalinger basert på bransjestandarder. Brukeren bærer selv ansvar for fysisk service og elsikkerhet.',
    legal_terms_sec4_title: '4. Varemerker og immaterielle rettigheter',
    legal_terms_sec4_body: 'Alle varemerker og merkenavn (Siemens, Miele, Jura, DeLonghi, Bosch, Scott osv.) tilhører sine respektive eiere. Nordic Asset Suite er et uavhengig verktøy.',
    legal_terms_sec5_title: '5. Lovvalg og verneting',
    legal_terms_sec5_body: 'Disse vilkårene reguleres av sveitsisk rett med verneting i Zürich, Sveits.',
    legal_support_modal_title: 'Kundestøtte og systemdiagnostikk',
    legal_support_intro: 'Trenger du hjelp eller har tilbakemeldinger? Vårt sveitsiske ingeniørteam står klart til å hjelpe deg.',
    legal_support_email_label: 'Direkte e-poststøtte',
    legal_support_version_label: 'Applikasjonsversjon',
    legal_support_diag_btn: 'Kopier systemdiagnostikkrapport',
    legal_support_faq_title: 'Ofte stilte spørsmål',
    legal_support_faq1_q: 'Hvordan beregnes garantiutløpet?',
    legal_support_faq1_a: 'Ved å kombinere registrert kjøpsdato med bekreftet produsentgaranti eller lovfestet reklamasjonsfrist.',
    legal_support_faq2_q: 'Lagres bilder av typeskilt i skyen?',
    legal_support_faq2_a: 'Nei. OCR-gjenkjenning skjer umiddelbart uten permanent lagring på eksterne servere.',
    legal_support_faq3_q: 'Kan jeg eksportere mine data?',
    legal_support_faq3_a: 'Ja, dine data er strukturert og tas vare på via din vanlige enhets- og iCloud-sikkerhetskopi.',
    legal_erase_confirm_prompt: 'Er du sikker på at du vil slette alle registrerte enheter, garantilogger og innstillinger permanent? Denne handlingen kan ikke angres.',
    legal_erase_toast_success: 'Alle lokale data og eiendeler er slettet.',

    notif_log_title: 'Planlagte garanti- og servicevarsler',
    notif_log_desc: 'Alle varsler evalueres lokalt på enheten. Nedenfor er din aktive tidsplan for garantibeskyttelse:',
    notif_empty_desc: 'Ingen aktive enheter funnet. Legg til eiendeler for å se planlagte garantiadvarsler.',
    notif_asset_label: 'Enhet',
    notif_settings_group: 'GARANTI- OG SERVICEVARSLER',
    notif_settings_warranty_title: 'Påminnelser om garantiutløp',
    notif_settings_warranty_desc: 'Varsle 30 dager, 7 dager og 1 dag før lovbestemt garantifrist',
    notif_settings_maint_title: 'Påminnelser om vedlikehold og service',
    notif_settings_maint_desc: 'Avkalking, filterbytte og periodiske serviceintervaller',
    notif_settings_timeline: 'Vis tidslinje for planlagte varsler',
    notif_prompt_title: 'Aktiver varsler om garantibeskyttelse',
    notif_prompt_desc: 'Nordic Asset Suite beskytter husholdningsinvesteringen din ved å gi rettidige lokale varsler før dekningen utløper:',
    notif_prompt_30d: '30 dager før utløp: Tidlig varsling for å bestille inspeksjon eller fremme reklamasjonskrav.',
    notif_prompt_7d: '7 dager før utløp: Kritisk varsel før reklamasjonsfristen stenges.',
    notif_prompt_1d: '24 timer før utløp: Siste påminnelse om garantiutløp.',
    notif_prompt_maint: 'Rutinemessig vedlikehold: Avkalking, filterrengjøring og servicepåminnelser.',
    notif_btn_allow: 'Tillat varsler',
    notif_btn_later: 'Kanskje senere',
    notif_toast_warranty_enabled: 'Påminnelser om garantiutløp aktivert (30d, 7d, 1d).',
    notif_toast_warranty_disabled: 'Påminnelser om garantiutløp deaktivert.',
    notif_toast_maint_enabled: 'Vedlikeholdspåminnelser aktivert.',
    notif_toast_maint_disabled: 'Vedlikeholdspåminnelser deaktivert.',
    notif_toast_permission_granted: 'Lokale varsler er aktivert!',
    notif_toast_permission_denied: 'Varseltillatelse ble ikke innvilget.',
    notif_warranty_30d_title: '30-dagers varsel om garantiutløp',
    notif_warranty_30d_msg: 'Lovfestet garanti for {asset} utløper {date}. Sjekk enheten for å melde eventuelle krav i tide.',
    notif_warranty_7d_title: '7-dagers kritisk garantiutløp',
    notif_warranty_7d_msg: 'Kun 7 dager gjenstår før lovfestet dekning opphører for {asset}. Sluttinspeksjon anbefales.',
    notif_warranty_1d_title: '24-timers siste garantivarsel',
    notif_warranty_1d_msg: 'Lovfestet garanti for {asset} opphører i morgen ({date}).',
    notif_part_renewal_title: 'Fornyelse av del ({percent} % slitasje): {part}',
    notif_part_renewal_msg: 'OEM {pno} planlagt serviceintervall: {interval}. Måldato for bytte: {date}.',
    notif_maintenance_title: 'Vedlikehold forfaller: {step}',
    notif_maintenance_msg: '{detail} (Planlagt frekvens: {freq})',
    notif_test_triggered: 'Testvarsel utløst for {asset}!',

    status_expiring_soon: 'Utløper snart',
    status_no_date: 'Ingen dato satt',
    stat_within_90_days: 'Innen 90 dager',
    attention_expired_one: '1 garanti er utløpt',
    attention_expired_plural: '{count} garantier er utløpt',
    attention_expiring_one: '1 garanti utløper snart',
    attention_expiring_plural: '{count} garantier utløper snart',
    attention_combined_alert: '{expired} utløpt · {expiring} utløper snart',
    drawer_expiring_soon: 'Utløper snart',
    drawer_user_purchase_price: 'Brukerens kjøpspris',
    drawer_estimated_market_value: 'Estimert markedsverdi',
    not_specified: 'Ikke oppgitt',
    statutory_protection_title: 'Lovfestet forbrukerbeskyttelse',
    manufacturer_warranty_title: 'Produsentens fabrikkgaranti',
    user_coverage_title: 'Din aktive garantidekning',

    drawer_warranty_status_label: 'GARANTISTATUS',
    drawer_warranty_desc: 'Lovfestet beskyttelse i henhold til sveitsisk CO Art. 210.',
    drawer_purchase_date_label_short: 'Kjøpsdato',
    drawer_warranty_policy_label_short: 'Garantipolise',
    drawer_purchase_price_label_short: 'Kjøpspris',
    detail_nav_title: 'Eiendelsdetaljer',
    detail_manual_summary: 'Vedlikeholdsprotokoll anbefalt av produsenten.',
    drawer_diag_prompt: 'Maskinvare feilkode / symptom:',
    drawer_diag_placeholder: 'f.eks. E24, F10, Feil 107...',
    drawer_diag_btn: 'Diagnostiser',
    confirm_serial_badge: 'Serienummer',

    add_placeholder_appliance: 'f.eks. Siemens KG86PFIC0N, Miele W1, Dyson V15, DeLonghi Brødrister...',
    add_placeholder_coffee: 'f.eks. DeLonghi Magnifica Plus, Sage Barista Touch, Jura E8...',
    add_placeholder_ebike: 'f.eks. Scott Patron eRIDE, Specialized Turbo Levo, Trek Rail 9.8...',
    add_placeholder_skigear: 'f.eks. Stöckli Laser SL, Atomic Redster S9, Head Worldcup Rebels...',
    promo_line1: 'Beskytt husholdningsapparatene dine med lovfestet garantisporing.',
    promo_line2: 'Skann typeskilt for umiddelbare feilkoder og vedlikeholdsplaner.',
    mo_policy: 'mnd. garanti',
    statutory_standard: 'Lovfestet standard',
    coffee_btn_brew_log: 'Bryggedagbok & Justering',
    coffee_btn_brew_again: 'Brygg oppskrift',
    coffee_ratio_label: 'Bryggeforhold',
    coffee_btn_start_timer: 'Ekstraksjonstidtaker',
    coffee_extraction_notes_fallback: 'Balansert og søt ekstraksjonsprofil',
    coffee_grinder_step: 'Kvernnivå: Trinn {step}',
    ebike_empty_title: 'Ingen elsykkel tilkoblet',
    ebike_empty_desc: 'Legg til elsykkelen din for å spore batterihelse, motortelemetri og kjedeslitasje.',
    ebike_btn_add: 'Legg til elsykkel',
    ski_empty_title: 'Ingen alpinski i samlingen',
    ski_empty_desc: 'Legg til skiene dine for å beregne ISO 11088 DIN-utløser og følge smøreintervaller.',
    ski_btn_add: 'Legg til skiutstyr',
    tour_step_prefix: 'Trinn {current} av {total}',
    tour_btn_back: 'Tilbake',
    tour_btn_skip: 'Hopp over',
    tour_btn_start: 'Kom i gang',
    tour_btn_next: 'Neste',
    brand_appliance: 'Hvitevarer Garanti',
    brand_coffee: 'Kaffe Ledsager',
    brand_ebike: 'Elsykel Service',
    brand_skigear: 'Skiutstyr Sporing',
    nav_home: 'Hjem',
    nav_appliances: 'Hvitevarer',
    nav_add: 'Legg til',
    nav_warranties: 'Garantier',
    nav_settings: 'Innstillinger',
    nav_today: 'I dag',
    nav_recipes: 'Oppskrifter',
    nav_machine: 'Maskin',
    nav_ride: 'Tur',
    nav_bike: 'Sykkel',
    nav_parts: 'Deler',
    nav_quiver: 'Skiutstyr',
    nav_setup: 'Oppsett',
    nav_tuning: 'Service',
    rooms_all: 'Alle',
    rooms_kitchen: 'Kjøkken',
    rooms_living: 'Stue',
    rooms_laundry: 'Vaskerom',
    rooms_bedroom: 'Soverom',
    rooms_bathroom: 'Baderom',
    rooms_office: 'Hjemmekontor',
    rooms_dining: 'Spisestue',
    rooms_hallway: 'Gang / Entré',
    rooms_garage: 'Garasje',
    rooms_skilocker: 'Skibod',
    rooms_basement: 'Kjeller',
    rooms_balcony: 'Balkong / Hage',
    status_active: 'AKTIV',
    status_expired: 'UTLØPT',
    status_expiring_soon: 'UTLØPER SNART',
    stat_items: 'Registrerte enheter',
    stat_protected: 'Aktive garantier',
    stat_expiring: 'Utløper snart',
    stat_expired: 'Utløpt',
    attention_expired_one: '1 garanti er utløpt',
    attention_all_ok: 'Alle {count} hvitevarer er dekket av garanti',
    empty_appliance_title: 'Ingen hvitevarer registrert',
    empty_appliance_desc: 'Legg til din første hvitevare for å spore garanti, vedlikehold og serienumre.',
    btn_add_appliance: 'Legg til hvitevare',
    expires_on: 'Utløper: {date}',
    add_purchase_date: 'Legg til kjøpsdato',
    drawer_tab_specs: 'Tekniske spesifikasjoner',
    drawer_tab_maintenance: 'Pleie & Vedlikehold',
    drawer_tab_parts: 'Reservedeler & Slitasje',
    drawer_tab_diagnostics: 'Feilsøking',
    drawer_purchase_date_label: 'Kjøpsdato (Beregner automatisk garanti):',
    drawer_policy_label: 'Lovpålagt / Produsentgaranti:',
    drawer_price_label: 'Kjøpspris (Gjenanskaffelsesverdi):',
    drawer_est_oem_cost: 'Estimert OEM-pris:',
    drawer_btn_replace: 'Registrer utskifting',
    drawer_btn_delete: 'Slett enhet fra portefølje',
    drawer_delete_confirm: 'Er du sikker på at du vil slette "{name}"? Dette kan ikke angres.',
    wear_optimal: 'Optimal tilstand',
    wear_moderate: 'Moderat slitasje',
    wear_due_soon: 'Utskifting påkrevd snart',
    wear_overdue: 'Utskifting forfalt',
    freq_daily: 'Daglig',
    freq_weekly: 'Ukentlig',
    freq_monthly: 'Månedlig',
    freq_every_60: 'Hver 60. dag',
    freq_every_90: 'Hver 90. dag',
    freq_every_150km: 'Hver 150. km',
    freq_every_4skidays: 'Hver 4. skidag',
    settings_header: 'Innstillinger & Regionale Data',
    settings_lang_label: 'Språk / Language',
    settings_lang_sub: 'Nordisk og europeisk oversettelse',
    settings_currency_label: 'Valutaformat',
    settings_currency_sub: 'Brukes på aktivverdier, reservedeler og markedspriser',
    settings_statutory_label: 'Lovfestet reklamasjonsrett',
    settings_statutory_sub: 'Standard garantiperiode for hvitevarer',
    settings_tour_label: 'Guidet introduksjonstur',
    settings_reset_demo: 'Tilbakestill demodata',
    settings_notif_warranty: 'Garantiutløp påminnelser',
    settings_notif_maintenance: 'Vedlikeholds- og servicepåminnelser',
    settings_timeline_btn: 'Vis tidslinje for planlagte varsler',
    toast_lang_changed: 'Språk oppdatert til {name}!',
    greeting_morning: 'God morgen',
    greeting_afternoon: 'God ettermiddag',
    greeting_evening: 'God kveld',
    home_title: 'Ditt Hjem',
    my_appliances: 'Mine Hvitevarer',
    see_all: 'Se alle →',
    add_appliance_cta_title: '+ Legg til hvitevare',
    add_appliance_cta_desc: 'Skann strekkode, ta bilde av typeskilt eller søk modell',
    all_appliances: 'Alle Hvitevarer',
    warranty_timeline: 'Garantitidslinje',
    stat_fully_covered: 'Fullt dekket',
    stat_within_90_days: 'Innen 90 dager',
    stat_action_required: 'Handling kreves',
    drawer_active: 'Aktiv',
    drawer_expired: 'Utløpt',
    drawer_step: 'Trinn',
    drawer_wear: 'Slitasje',
    drawer_interval: 'Intervall:',
    drawer_in_use: 'i bruk',
    toast_purchase_date_updated: 'Kjøpsdato oppdatert! Garanti aktiv til {date}',
    toast_purchase_date_cleared: 'Kjøpsdato slettet.',
    toast_warranty_policy_updated: 'Garantipolise oppdatert til {months} måneder!',
    toast_purchase_price_updated: 'Kjøpspris oppdatert!',
    toast_replacement_logged: 'Utskifting registrert for {name}! Slitasje nullstilt til 0%.',
    toast_currency_changed: 'Valuta oppdatert til {label}',
    toast_statutory_changed: 'Lovfestet standard oppdatert til {val} måneder',
    add_modal_title_appliance: 'Legg til Hvitevare',
    add_modal_title_coffee: 'Legg til Kaffemaskin',
    add_modal_title_ebike: 'Legg til Elsykkel',
    add_modal_title_skigear: 'Legg til Skiutstyr',
    add_modal_scan_title: 'Skann Strekkode / QR',
    add_modal_scan_desc: 'EAN-13, UPC eller emballasjestrekkode',
    add_modal_photo_title: 'Ta Bilde av Typeskilt',
    add_modal_photo_desc: 'Hent modellspesifikasjoner fra typeskiltet',
    add_modal_manual_label: 'Eller skriv inn nøyaktig produkt / modellnummer:',
    add_modal_quick_test: 'Hurtigtest:',
    add_modal_identify_btn: 'Identifiser',
    add_modal_camera_instruction: 'Juster strekkode eller typeskilt i søkeren',
    add_modal_test_fixtures: 'Teststrekkoder:',
    confirm_badge: 'VERIFISERT PRODUKT',
    confirm_source_badge: 'Offisiell Produsentkilde',
    confirm_add_btn: 'Lagre i portefølje',
    confirm_searching: 'Søker i produktdatabaser…',
    confirm_verified_title: 'Produkt Identifisert',
    confirm_specs_header: 'PRODUSENTSPESIFIKASJONER',
    confirm_policy_header: 'PRODUSENTGARANTI / POLISE',
    confirm_market_header: 'REGIONAL MARKEDSVERDI',
    confirm_ownership_header: 'DITT EIERSKAP (VALGFRITT)',
    confirm_purchase_date: 'Kjøpsdato:',
    confirm_purchase_price: 'Kjøpspris ({currency}):',
    confirm_warranty_duration: 'Garantitid:',
    confirm_room_location: 'Rom / Plassering:',
    confirm_save_btn: 'Lagre i portefølje',
    confirm_cancel_btn: 'Avbryt',
    confirm_warranty_months: '{val} Måneder',
    confirm_warranty_text: '{val} Måneder ({source})',
    confirm_standard_policy: 'Standard Forbrukerkjøpslov',
    confirm_market_unavailable: 'Markedsverdi utilgjengelig',
    confirm_years: 'År',
    confirm_months_short: 'Mnd',
    camera_title: 'Live Strekkode- og Typeskiltleser',
    toast_offline: 'Du er frakoblet. Lagrede produktopplysninger er fortsatt tilgjengelige.',
    toast_search_busy: 'Produktsøket er midlertidig opptatt. Vennligst prøv igjen om et øyeblikk.',
    toast_search_auth_error: 'Produktsøktjenesten er feilkonfigurert.',
    toast_search_timeout: 'Søkeforespørselen ble tidsavbrutt. Sjekk internettforbindelsen.',
    toast_search_unavailable: 'Produktsøk er midlertidig utilgjengelig.',
    coffee_barista_deck: 'Baristabenk',
    coffee_todays_extraction: "Dagens Ekstraksjon",
    coffee_no_machine_paired: 'Ingen Kaffemaskin Tilkoblet',
    coffee_add_machine_title: '+ Legg til Kaffemaskinen Din',
    coffee_add_machine_desc: 'Koble til espressomaskinen for vannkjemi, avkalking og oppskriftsminne.',
    coffee_easy_mode_badge: 'ENKEL MODUS · BØNNE TIL KOPP',
    coffee_15bar_pump: '15-Bar Termoblokk',
    coffee_select_beverage: 'VELG DRIKK',
    coffee_aroma_strength: 'AROMASTYRKE',
    coffee_strength_level: 'Nivå {n} av 5',
    coffee_repeat_brew_label: '1-Trykk Gjenta Forrige Brygg',
    coffee_active_recipe_badge: 'AKTIVT MÅLOPPSKRIFT',
    coffee_metric_dose_in: 'DOSERING',
    coffee_metric_yield_out: 'UTBYTTE',
    coffee_metric_target_time: 'MÅLTID',
    coffee_metric_grinder_step: 'KVERNINGSTRINN',
    coffee_active_bean_title: 'Aktiv Bønne i Beholderen',
    coffee_bean_cellar_link: 'Bønnekjeller ({count}) →',
    coffee_bag_inventory: 'LAGERBEHOLDNING',
    coffee_roaster_notes: 'Brennerinotater:',
    coffee_water_care_title: 'Vannkjemi & Pleie',
    coffee_equipment_care_link: 'Utstyrspleie →',
    coffee_water_source_label: 'KOMMUNAL VANNKILDE',
    coffee_scale_risk_label: 'KALKRISIKO',
    coffee_local_hardness: 'Lokal Hardhet',
    coffee_next_descale: 'Neste Avkalking',
    coffee_descale_in_days: 'Om {days} dager',
    coffee_filter_life: 'Filter: {percent}%',
    coffee_filtration_label: 'Filtrering:',
    coffee_dial_in_memory_title: 'Dial-In Minne',
    coffee_attempt_number: 'Forsøk #{n}',
    coffee_grind_label: 'Kvern',
    coffee_total_shots: 'Totale shots:',
    coffee_my_grinder_fleet: 'MINE KVERNER',
    coffee_oem_maintenance: 'OEM Vedlikeholdsprotokoll',
    coffee_descale_cycle_title: 'Thermoblock Avkalkingssyklus',
    coffee_descale_cycle_detail: 'Forfaller om {days} dager · Sitronsyre / EcoDecalk',
    coffee_btn_log_done: 'Logg Fullført',
    coffee_filter_cartridge_title: 'Vannfilterpatron',
    coffee_filter_lifespan_detail: '{percent}% levetid igjen',
    coffee_btn_replaced: 'Erstattet',
    coffee_freshness_unknown: 'Friskhet ukjent',
    coffee_roast_date_not_specified: 'Brenneregistrering ikke oppgitt',
    coffee_freshness_degas: 'Avgassing ({days}d etter brenning)',
    coffee_freshness_peak: 'Optimalt Vindu ★ ({days}d)',
    coffee_freshness_mature: 'Moden ({days}d)',
    coffee_freshness_past_peak: 'Etter Topp ({days}d)',
    toast_water_source_changed: 'Vannkilde satt til {city} ({dh} °dH)',
    toast_brew_logged: 'Brygget {drink}! Lagret i Kaffeminnet.',
    toast_brew_loaded: 'Lastet forrige brygg: {bean} ({dose}g → {yield}g)',
    brew_timer_target_info: 'Mål: {time} for {yield} utbytte ({ratio})',
    brew_btn_resume: 'Gjenoppta Timer',
    brew_btn_pause_evaluate: 'Pause & Evaluer',
    brew_btn_start: 'Start Timer',
    coffee_under_extracted: 'Underekstrahert (Sur):',
    coffee_under_extracted_advice: 'Prøv å male 1 trinn finere eller øk temperaturen 1°C.',
    coffee_over_extracted: 'Overekstrahert (Bitter):',
    coffee_over_extracted_advice: 'Prøv å male 1 trinn grovere eller stopp 2 sekunder tidligere.',
    coffee_optimal_extraction: 'Optimal Ekstraksjon!',
    coffee_optimal_extraction_desc: 'Balansert sødme og syre. Lagret i bønneminnet.',
    toast_brew_saved: 'Brygg lagret i Personlig Kaffeminne!',
    coffee_bean_remaining: 'Gjenværende:',
    coffee_bean_roast_date: 'Brennedato:',
    coffee_bean_finished: 'Oppbrukt',
    coffee_bean_mark_finished: 'Marker som oppbrukt',
    toast_bean_name_required: 'Vennligst skriv inn et kaffebønnenavn',
    toast_bean_added: '{name} lagt til i Bønnekjelleren!',
    toast_scanning_bean_bag: 'Leser kaffeposens etikett…',
    toast_bean_bag_scanned: 'Pose skannet! Brenneri, opprinnelse og brennedato udtrukket.',
    toast_bean_finished: 'Markerte {name} som oppbrukt.',
    toast_coffee_maintenance_logged: '{task} vedlikehold registrert! Timere nullstilt.',
    coffee_recipe_label: 'OPPSKRIFT:',
    coffee_metric_dose: 'DOSE',
    coffee_metric_yield: 'UTBYTTE',
    coffee_metric_time: 'TID',
    coffee_metric_temp: 'TEMPERATUR',
    coffee_bean_origin_label: 'Bønneopprinnelse:',
    coffee_tasting_notes_label: 'Smaksnotater:',
    coffee_extraction_steps: 'EKSTRAKSJONSTRINN:',
    coffee_step_1_dose: 'Doser ferskmalt kaffe i filterkurven.',
    coffee_step_2_tamp: 'Tamp jevnt og vannrett.',
    coffee_step_3_extract: 'Ekstraher til målutbyttet er nådd.',
    toast_recipe_loaded: 'Lastet: {name}',
    coffee_advisor_loading: 'Rådfører Barista AI for dial-in parametere…',
    coffee_grind_advisor_title: 'BARISTA DIAL-IN RÅDGIVER',
    coffee_advisor_grind: 'KVERN',
    coffee_advisor_dose: 'DOSE',
    coffee_advisor_yield: 'UTBYTTE',
    coffee_advisor_temp: 'TEMPERATUR',
    coffee_sensory_profile: 'Sensorisk Profil:',
    coffee_advisor_calculated_for: 'Beregnet for {roast} brenning med {hardness} vannhardhet.',
    coffee_recipes_title: 'Oppskrifter & Bryggelab',
    coffee_bean_cellar: 'Bønnekjeller ({count})',
    coffee_filter_all: 'Alle Metoder',
    coffee_filter_espresso: 'Espresso',
    coffee_filter_pour_over: 'Pour-Over (V60)',
    coffee_filter_aeropress: 'Aeropress',
    coffee_filter_cold_brew: 'Cold Brew',
    coffee_filter_cafe_creme: 'Café Crème',
    coffee_advisor_section_title: 'AI BARISTA DIAL-IN RÅDGIVER',
    coffee_advisor_badge: 'Spesialkaffe Standarder',
    coffee_advisor_desc: 'Beregn nøyaktige kverntrinn, bryggforhold, vanntemperaturer og flyttider.',
    coffee_brew_method_label: 'BRYGGMETODE',
    coffee_roast_level_label: 'BRENNINGSGRAD',
    coffee_bean_origin_placeholder: 'f.eks. Etiopia Yirgacheffe, Colombia Huila, Kenya AA…',
    coffee_quick_pick: 'Hurtigvalg:',
    coffee_water_hardness_label: 'LOKAL VANNHARDHET',
    coffee_calculate_btn: 'Beregn Dial-In & Kverninnstilling',
    coffee_brew_library_title: 'Spesialkaffe Bibliotek',
    coffee_machine_maintenance_title: 'Maskinvedlikehold & Utstyr',
    ebike_garage_fleet: 'Garasjeflåte',
    ebike_stat_battery: 'BATTERIHELSE',
    ebike_stat_odometer: 'TOTAL KILOMETER',
    ebike_next_service: 'Neste service: {km} km',
    ebike_component_wear_title: 'Komponentslitasje & Telemetri',
    ebike_all_parts_link: 'Alle deler →',
    ebike_chain_gauge: 'KJEDESLITASJEMÅLER',
    ebike_chain_optimal: '{pct}% (Optimal)',
    ebike_chain_hint: 'Bytt kjede ved 0.75% (SRAM Eagle 12-Speed)',
    ebike_suspension_gauge: 'DEMPER LUFTTRYKK',
    ebike_suspension_hint: 'Kalibrert for 78 kg ryttervekt på Fox 38 Float 160mm gaffel',
    ebike_maintenance_history: 'Nylig Servicehistorikk',
    ebike_chain_lubrication: 'Keramisk Kjedesmøring',
    ebike_applied_next_due: 'Utført ved {applied} km · Neste ved {due} km',
    ebike_bike_specs_title: 'Sykkelspesifikasjoner',
    ebike_consumables_title: 'Slitedeler & Forbruksartikler',
    ebike_motor_error_decoder: 'MOTORFEIL DEKODER',
    ebike_motor_diag_desc: 'Skriv inn en Bosch, Shimano EP8 eller Bafang feilkode for å få en AI-diagnose.',
    ebike_motor_diag_placeholder: 'Feilkode (f.eks. 503, 540, 0x04)',
    ebike_btn_decode_error: 'Avkod Motorfeil med AI',
    ebike_frame_serial: 'Rammenummer: •••• 9912',
    toast_ride_recorded: '{km} km tur registrert! Kilometerteller oppdatert.',
    ebike_diag_empty_toast: 'Skriv inn en motorfeilkode (f.eks. 503, 540)',
    ebike_diag_decoding: 'Avkoder feil {code} med Gemini…',
    ebike_diag_fallback_title: 'Motorsystem Advarsel',
    ebike_diag_cause_label: 'Årsak:',
    ebike_diag_fallback_cause: 'Hastighetssensor eller magnetfeil på eike.',
    ebike_diag_action_label: 'Handling:',
    ebike_diag_fallback_action: 'Sjekk at magneten på eiken passerer sensoren nøyaktig.',
    ski_alpine_quiver: 'Alpint Skiutstyr',
    ski_metric_din: 'ISO 11088 DIN',
    ski_metric_bsl: '{bsl}mm Såle · {weight}kg Skiløper',
    ski_base_wax: 'GRUNNVOKS',
    ski_snow_range: '{low}°C til {high}°C Kald Snø',
    ski_btn_recalc_din: 'Gjenberegn Binding DIN (ISO 11088)',
    ski_section_readiness: 'Sesong Klargjøring & Service',
    ski_btn_tuning_log: 'Servicelogg →',
    ski_readiness_ski_days: 'Skidager denne sesongen',
    ski_readiness_ski_days_val: '{n} Dager på Snø',
    ski_readiness_edge: 'Sidekant Vinkel',
    ski_readiness_edge_val: '{angle}° Diamantslipt ({days} dager siden)',
    ski_readiness_trip: 'Neste Skitur',
    ski_readiness_trip_val: '{place} (Om {days} dager)',
    ski_checklist_title: 'Pakkeliste & Turliste',
    ski_safety_notice: 'Obligatorisk Sikkerhetskrav:',
    ski_safety_notice_desc: 'ISO 11088 DIN-beregninger er veiledende estimater. Skibindingers utløsermoment må kalibreres fysisk på en sertifisert testbenk av en fagutdannet tekniker.',
    ski_base_wax_applied: 'Grunnvoks Påført',
    ski_days_on_snow: 'Dager på Snø',
    ski_days_unit: 'Dager',
    ski_wax_advisor_section: 'AI VOKSRÅDGIVER',
    ski_snow_temp_placeholder: 'Snøtemperatur °C (f.eks. -12)',
    ski_snow_type_packed: 'Preparert Snø',
    ski_snow_type_fresh: 'Nysnø / Puddersnø',
    ski_snow_type_icy: 'Is / Hard Løype',
    ski_snow_type_wet: 'Våt Vårsnø',
    ski_btn_get_ai_wax: 'Hent AI Voksanbefaling',
    toast_din_applied: 'DIN {value} ble brukt på {binding}!',
    ski_wax_calculating: 'Beregner voksanbefaling for {temp}°C…',
    ski_wax_result_wax: 'ANBEFALT VOKS',
    ski_wax_result_iron: 'STRYKEJERNSTEMP',
    ski_wax_fallback: 'Toko LF Blue fluorfri voks anbefales for {temp}°C preparert snø.',
    ski_setup_title: 'Binding & Skistøvel Oppsett',
    ski_tuning_title: 'Kant- & Vokshistorikk',
    ski_domain_subtitle: 'Utstyr, DIN Utløsning & Voks'
  },

  // ==================== 6. DEUTSCH (de) ====================
  de: {
    settings_group_legal: 'RECHTLICHES, DATENSCHUTZ & SUPPORT',
    settings_privacy_title: 'Datenschutzerklärung',
    settings_privacy_sub: 'Lokale Speicherung, kein Tracking, DSGVO- und Schweizer FADP-konform',
    settings_terms_title: 'Nutzungsbedingungen (EULA)',
    settings_terms_sub: 'Garantie-Haftungsausschluss, Sicherheitsregeln & Apple Standard-EULA',
    settings_support_title: 'Kundensupport & Systemdiagnose',
    settings_support_sub: 'E-Mail-Helpdesk, Systemtelemetrie & Hardware-FAQ',
    settings_erase_title: 'Alle lokalen Daten löschen & zurücksetzen',
    settings_erase_sub: 'Dauerhaftes Löschen aller gespeicherten Geräte, Garantien und Einstellungen',
    legal_privacy_modal_title: 'Datenschutzerklärung & Transparenz',
    legal_privacy_intro: 'Nordic Asset Suite basiert auf einer strengen lokalen Datenschutzarchitektur. Ihre Haushaltsdaten gehören ausschließlich Ihnen.',
    legal_privacy_sec1_title: '1. Lokale Speicherung auf dem Gerät',
    legal_privacy_sec1_body: 'Alle Haushaltsgeräte, Seriennummern, Kaufdaten und Wartungsaufzeichnungen werden lokal auf Ihrem Gerät gespeichert. Wir verkaufen, vermieten oder teilen Ihre Daten niemals mit Dritten oder Werbetreibenden.',
    legal_privacy_sec2_title: '2. Kamera, Fotos & Typenschild-OCR',
    legal_privacy_sec2_body: 'Fotos von Typenschildern werden ausschließlich zur sofortigen Textextraktion verarbeitet und niemals dauerhaft auf externen Servern gespeichert.',
    legal_privacy_sec3_title: '3. Drittanbieter-Dienste für Produktdaten',
    legal_privacy_sec3_body: 'Bei Spezifikationsabfragen werden verschlüsselte API-Schnittstellen (Gemini Vision und Tavily Search) genutzt. Es werden keine personenbezogenen Daten übermittelt.',
    legal_privacy_sec4_title: '4. DSGVO, Schweizer FADP & Löschungsrechte',
    legal_privacy_sec4_body: 'Sie haben das Recht, Ihre Daten jederzeit über die Einstellungen einzusehen, zu exportieren oder dauerhaft zu löschen.',
    legal_privacy_sec5_title: '5. Datenschutz-Kontakt',
    legal_privacy_sec5_body: 'Bei Fragen zum Datenschutz wenden Sie sich an privacy@nordicasset.app.',
    legal_terms_modal_title: 'Nutzungsbedingungen & Standard-EULA',
    legal_terms_intro: 'Bitte lesen Sie diese Nutzungsbedingungen und die EULA vor der Nutzung von Nordic Asset Suite.',
    legal_terms_sec1_title: '1. Standard-EULA von Apple',
    legal_terms_sec1_body: 'Die Nutzung unterliegt den Standard-EULA-Bedingungen von Apple und diesen ergänzenden Bestimmungen.',
    legal_terms_sec2_title: '2. Garantie-Haftungsausschluss',
    legal_terms_sec2_body: 'Berechnete Garantiefristen (wie Schweizer OR Art. 210 oder Herstellerrichtlinien) dienen ausschließlich Informationszwecken und stellen keine Versicherungspolice dar.',
    legal_terms_sec3_title: '3. Sicherheits- und Wartungshinweise',
    legal_terms_sec3_body: 'Wartungsempfehlungen und DIN-Rechner basieren auf Branchenstandards. Nutzer tragen die alleinige Verantwortung für physische Wartung und elektrische Sicherheit.',
    legal_terms_sec4_title: '4. Marken & Urheberrechte',
    legal_terms_sec4_body: 'Alle Markennamen (Siemens, Miele, Jura, DeLonghi, Bosch, Scott usw.) gehören ihren jeweiligen Inhabern. Nordic Asset Suite ist eine unabhängige Anwendung.',
    legal_terms_sec5_title: '5. Anwendbares Recht',
    legal_terms_sec5_body: 'Es gilt schweizerisches Recht mit Gerichtsstand in Zürich, Schweiz.',
    legal_support_modal_title: 'Kundensupport & Diagnose',
    legal_support_intro: 'Unser Schweizer Entwicklungsteam hilft Ihnen gerne weiter.',
    legal_support_email_label: 'Direkte Support-E-Mail',
    legal_support_version_label: 'Anwendungsversion',
    legal_support_diag_btn: 'Diagnosebericht kopieren',
    legal_support_faq_title: 'Häufig gestellte Fragen (FAQ)',
    legal_support_faq1_q: 'Wie wird das Garantieende berechnet?',
    legal_support_faq1_a: 'Durch Kombination Ihres Kaufdatums mit verifizierten Herstellergarantien oder gesetzlichen Fristen.',
    legal_support_faq2_q: 'Werden Typenschildfotos in der Cloud gespeichert?',
    legal_support_faq2_a: 'Nein. Die Texterkennung erfolgt flüchtig ohne dauerhafte externe Speicherung.',
    legal_support_faq3_q: 'Kann ich meine Daten exportieren?',
    legal_support_faq3_a: 'Ja, Ihre Daten sind strukturiert und über Geräte-Backups gesichert.',
    legal_erase_confirm_prompt: 'Möchten Sie wirklich alle gespeicherten Geräte und Einstellungen dauerhaft löschen?',
    legal_erase_toast_success: 'Alle lokalen Daten wurden erfolgreich gelöscht.',

    notif_log_title: 'Geplante Garantie- & Service-Erinnerungen',
    notif_log_desc: 'Alle Benachrichtigungen werden lokal auf dem Gerät ausgewertet. Nachfolgend finden Sie Ihren aktiven Garantieplan:',
    notif_empty_desc: 'Keine aktiven Geräte gefunden. Fügen Sie Geräte hinzu, um Benachrichtigungen zu erhalten.',
    notif_asset_label: 'Gerät',
    notif_settings_group: 'GARANTIE- & SERVICE-BENACHRICHTIGUNGEN',
    notif_settings_warranty_title: 'Garantieablauf-Erinnerungen',
    notif_settings_warranty_desc: 'Benachrichtigung 30 Tage, 7 Tage und 1 Tag vor Ablauf der gesetzlichen Gewährleistung',
    notif_settings_maint_title: 'Wartungs- & Service-Erinnerungen',
    notif_settings_maint_desc: 'Entkalkung, Filterwechsel und regelmäßige Wartungsintervalle',
    notif_settings_timeline: 'Zeitplan für geplante Erinnerungen anzeigen',
    notif_prompt_title: 'Garantieschutz-Benachrichtigungen aktivieren',
    notif_prompt_desc: 'Nordic Asset Suite schützt Ihre Haushaltsinvestitionen durch rechtzeitige lokale Benachrichtigungen vor Ablauf der Garantie:',
    notif_prompt_30d: '30 Tage vor Ablauf: Frühzeitige Erinnerung zur Inspektion oder Geltendmachung von Gewährleistungsansprüchen.',
    notif_prompt_7d: '7 Tage vor Ablauf: Dringende Fristwarnung vor Ablauf der Reklamationsfrist.',
    notif_prompt_1d: '24 Stunden vor Ablauf: Letzte Benachrichtigung vor Garantieende.',
    notif_prompt_maint: 'Routinewartung: Entkalkung, Filterreinigung und Pflegehinweise.',
    notif_btn_allow: 'Benachrichtigungen erlauben',
    notif_btn_later: 'Vielleicht später',
    notif_toast_warranty_enabled: 'Garantieablauf-Erinnerungen aktiviert (30d, 7d, 1d).',
    notif_toast_warranty_disabled: 'Garantieablauf-Erinnerungen deaktiviert.',
    notif_toast_maint_enabled: 'Wartungserinnerungen aktiviert.',
    notif_toast_maint_disabled: 'Wartungserinnerungen deaktiviert.',
    notif_toast_permission_granted: 'Lokale Benachrichtigungen aktiviert!',
    notif_toast_permission_denied: 'Benachrichtigungsberechtigung nicht erteilt.',
    notif_warranty_30d_title: '30-Tage Garantieablauf-Hinweis',
    notif_warranty_30d_msg: 'Die gesetzliche Garantie für {asset} läuft am {date} ab. Prüfen Sie das Gerät rechtzeitig auf Mängel.',
    notif_warranty_7d_title: '7-Tage Kritische Ablauf-Frist',
    notif_warranty_7d_msg: 'Nur noch 7 Tage gesetzlicher Garantieschutz für {asset}. Eine abschließende Überprüfung wird empfohlen.',
    notif_warranty_1d_title: '24-Stunden Letzter Garantie-Hinweis',
    notif_warranty_1d_msg: 'Die gesetzliche Garantie für {asset} endet morgen ({date}).',
    notif_part_renewal_title: 'Teileaustausch ({percent} % Verschleiß): {part}',
    notif_part_renewal_msg: 'OEM {pno} geplantes Serviceintervall: {interval}. Zieldatum für Austausch: {date}.',
    notif_maintenance_title: 'Wartung fällig: {step}',
    notif_maintenance_msg: '{detail} (Geplante Häufigkeit: {freq})',
    notif_test_triggered: 'Test-Benachrichtigung für {asset} ausgelöst!',

    status_expiring_soon: 'Läuft bald ab',
    status_no_date: 'Kein Datum gesetzt',
    stat_within_90_days: 'Innerhalb 90 Tagen',
    attention_expired_one: '1 Garantie ist abgelaufen',
    attention_expired_plural: '{count} Garantien sind abgelaufen',
    attention_expiring_one: '1 Garantie läuft bald ab',
    attention_expiring_plural: '{count} Garantien laufen bald ab',
    attention_combined_alert: '{expired} abgelaufen · {expiring} läuft bald ab',
    drawer_expiring_soon: 'Läuft bald ab',
    drawer_user_purchase_price: 'Benutzer-Kaufpreis',
    drawer_estimated_market_value: 'Geschätzter Marktwert',
    not_specified: 'Nicht angegeben',
    statutory_protection_title: 'Gesetzlicher Verbraucherschutz',
    manufacturer_warranty_title: 'Hersteller-Werksgarantie',
    user_coverage_title: 'Ihre aktive Garantieabdeckung',

    drawer_warranty_status_label: 'GARANTIESTATUS',
    drawer_warranty_desc: 'Schweizer OR Art. 210 Gesetzlicher Schutz.',
    drawer_purchase_date_label_short: 'Kaufdatum',
    drawer_warranty_policy_label_short: 'Garantierichtlinie',
    drawer_purchase_price_label_short: 'Kaufpreis',
    detail_nav_title: 'Gerätedetails',
    detail_manual_summary: 'Vom Hersteller empfohlenes Wartungsprotokoll.',
    drawer_diag_prompt: 'Geräte-Fehlercode / Symptom:',
    drawer_diag_placeholder: 'z.B. E24, F10, Fehler 107...',
    drawer_diag_btn: 'Diagnostizieren',
    confirm_serial_badge: 'Seriennummer',

    add_placeholder_appliance: 'z.B. Siemens KG86PFIC0N, Miele W1, Dyson V15, DeLonghi Toaster...',
    add_placeholder_coffee: 'z.B. DeLonghi Magnifica Plus, Sage Barista Touch, Jura E8, Philips LatteGo...',
    add_placeholder_ebike: 'z.B. Scott Patron eRIDE, Specialized Turbo Levo, Trek Rail 9.8...',
    add_placeholder_skigear: 'z.B. Stöckli Laser SL, Atomic Redster S9, Head Worldcup Rebels...',
    promo_line1: 'Schützen Sie Ihre Haushaltsgeräte mit gesetzlicher Garantieüberwachung.',
    promo_line2: 'Typenschilder scannen für sofortige Fehlercodes und Wartungspläne.',
    mo_policy: 'Monate Garantie',
    statutory_standard: 'Gesetzlicher Standard',
    coffee_btn_brew_log: 'Geschmackstagebuch & Mahlgrad',
    coffee_btn_brew_again: 'Rezept anwenden',
    coffee_ratio_label: 'Brühverhältnis',
    coffee_btn_start_timer: 'Extraktions-Timer',
    coffee_extraction_notes_fallback: 'Ausgewogenes & süßes Extraktionsprofil',
    coffee_grinder_step: 'Mahlgrad: Stufe {step}',
    ebike_empty_title: 'Kein E-Bike verknüpft',
    ebike_empty_desc: 'Fügen Sie Ihr E-Bike hinzu, um Akkugesundheit, Motortelemetrie und Kettenverschleiß zu überwachen.',
    ebike_btn_add: 'E-Bike hinzufügen',
    ski_empty_title: 'Keine Alpinski in der Sammlung',
    ski_empty_desc: 'Fügen Sie Ihre Ski hinzu, um die ISO 11088 DIN-Bindungsauslösung zu berechnen und Wachsintervalle zu verfolgen.',
    ski_btn_add: 'Ski hinzufügen',
    tour_step_prefix: 'Schritt {current} von {total}',
    tour_btn_back: 'Zurück',
    tour_btn_skip: 'Tour überspringen',
    tour_btn_start: 'Loslegen',
    tour_btn_next: 'Weiter',
    brand_appliance: 'Geräte Garantie',
    brand_coffee: 'Kaffee Begleiter',
    brand_ebike: 'E-Bike Service',
    brand_skigear: 'Ski-Ausrüstung Tracker',
    nav_home: 'Übersicht',
    nav_appliances: 'Geräte',
    nav_add: 'Hinzufügen',
    nav_warranties: 'Garantien',
    nav_settings: 'Einstellungen',
    nav_today: 'Heute',
    nav_recipes: 'Rezepte',
    nav_machine: 'Maschine',
    nav_ride: 'Fahrt',
    nav_bike: 'E-Bike',
    nav_parts: 'Teile',
    nav_quiver: 'Ski-Quiver',
    nav_setup: 'Setup',
    nav_tuning: 'Service',
    rooms_all: 'Alle',
    rooms_kitchen: 'Küche',
    rooms_living: 'Wohnzimmer',
    rooms_laundry: 'Waschküche',
    rooms_bedroom: 'Schlafzimmer',
    rooms_bathroom: 'Badezimmer',
    rooms_office: 'Arbeitszimmer',
    rooms_dining: 'Esszimmer',
    rooms_hallway: 'Flurschrank',
    rooms_garage: 'Garage',
    rooms_skilocker: 'Skiraum',
    rooms_basement: 'Keller',
    rooms_balcony: 'Balkon / Garten',
    status_active: 'AKTIV',
    status_expired: 'ABGELAUFEN',
    status_expiring_soon: 'LÄUFT BALD AB',
    stat_items: 'Registrierte Geräte',
    stat_protected: 'Aktive Garantien',
    stat_expiring: 'Läuft bald ab',
    stat_expired: 'Abgelaufen',
    attention_expired_one: '1 Garantie ist abgelaufen',
    attention_all_ok: 'Alle {count} Haushaltsgeräte unter Garantie geschützt',
    empty_appliance_title: 'Keine Geräte registriert',
    empty_appliance_desc: 'Fügen Sie Ihr erstes Gerät hinzu, um Garantien, Rechnungen und Wartungen zu verwalten.',
    btn_add_appliance: 'Gerät hinzufügen',
    expires_on: 'Läuft ab: {date}',
    add_purchase_date: 'Kaufdatum hinzufügen',
    drawer_tab_specs: 'Technische Daten',
    drawer_tab_maintenance: 'Pflege & Wartung',
    drawer_tab_parts: 'Ersatzteile & Verschleiss',
    drawer_tab_diagnostics: 'Fehlerdiagnose',
    drawer_purchase_date_label: 'Kaufdatum (Berechnet gesetzlichen Schutz):',
    drawer_policy_label: 'Gesetzliche / Herstellergarantie:',
    drawer_price_label: 'Kaufpreis (Wiederbeschaffungswert):',
    drawer_est_oem_cost: 'Geschätzte OEM-Kosten:',
    drawer_btn_replace: 'Austausch erfassen',
    drawer_btn_delete: 'Gerät aus Portfolio löschen',
    drawer_delete_confirm: 'Möchten Sie "{name}" wirklich löschen? Diese Aktion kann nicht rückgängig gemacht werden.',
    wear_optimal: 'Optimaler Zustand',
    wear_moderate: 'Mässiger Verschleiss',
    wear_due_soon: 'Ersatz bald fällig',
    wear_overdue: 'Ersatz überfällig',
    freq_daily: 'Täglich',
    freq_weekly: 'Wöchentlich',
    freq_monthly: 'Monatlich',
    freq_every_60: 'Alle 60 Tage',
    freq_every_90: 'Alle 90 Tage',
    freq_every_150km: 'Alle 150 km',
    freq_every_4skidays: 'Alle 4 Skitage',
    settings_header: 'Einstellungen & Regionale Standards',
    settings_lang_label: 'Sprache / Language',
    settings_lang_sub: 'Schweizer und europäische Übersetzung',
    settings_currency_label: 'Währungsformat',
    settings_currency_sub: 'Wird auf Gerätewerte, Ersatzteile und Marktpreise angewendet',
    settings_statutory_label: 'Gesetzliche Gewährleistung (OR 210)',
    settings_statutory_sub: 'Standard-Garantiedauer für Haushaltsgeräte',
    settings_tour_label: 'Geführte Einführungstour',
    settings_reset_demo: 'Demo-Hardware zurücksetzen',
    settings_notif_warranty: 'Garantieablauf-Erinnerungen',
    settings_notif_maintenance: 'Wartungs- & Service-Erinnerungen',
    settings_timeline_btn: 'Zeitplan der Benachrichtigungen anzeigen',
    toast_lang_changed: 'Sprache auf {name} aktualisiert!',
    greeting_morning: 'Guten Morgen',
    greeting_afternoon: 'Guten Tag',
    greeting_evening: 'Guten Abend',
    home_title: 'Ihr Zuhause',
    my_appliances: 'Meine Geräte',
    see_all: 'Alle anzeigen →',
    add_appliance_cta_title: '+ Gerät hinzufügen',
    add_appliance_cta_desc: 'Barcode scannen, Typenschild fotografieren oder Modell suchen',
    all_appliances: 'Alle Geräte',
    warranty_timeline: 'Garantie-Zeitachse',
    stat_fully_covered: 'Vollständig gedeckt',
    stat_within_90_days: 'Innerhalb 90 Tage',
    stat_action_required: 'Handlungsbedarf',
    drawer_active: 'Aktiv',
    drawer_expired: 'Abgelaufen',
    drawer_step: 'Schritt',
    drawer_wear: 'Verschleiss',
    drawer_interval: 'Intervall:',
    drawer_in_use: 'in Betrieb',
    toast_purchase_date_updated: 'Kaufdatum aktualisiert! Garantie aktiv bis {date}',
    toast_purchase_date_cleared: 'Kaufdatum gelöscht.',
    toast_warranty_policy_updated: 'Garantie auf {months} Monate aktualisiert!',
    toast_purchase_price_updated: 'Kaufpreis aktualisiert!',
    toast_replacement_logged: 'Austausch für {name} erfasst! Verschleiss auf 0% zurückgesetzt.',
    toast_currency_changed: 'Währung auf {label} aktualisiert',
    toast_statutory_changed: 'Gesetzlicher Standard auf {val} Monate gesetzt',
    add_modal_title_appliance: 'Gerät hinzufügen',
    add_modal_title_coffee: 'Kaffeemaschine hinzufügen',
    add_modal_title_ebike: 'E-Bike hinzufügen',
    add_modal_title_skigear: 'Ski-Ausrüstung hinzufügen',
    add_modal_scan_title: 'Barcode / QR-Code scannen',
    add_modal_scan_desc: 'EAN-13, UPC oder Verpackungsbarcode',
    add_modal_photo_title: 'Typenschild fotografieren',
    add_modal_photo_desc: 'Spezifikationen automatisch aus dem Typenschild auslesen',
    add_modal_manual_label: 'Oder genaues Produkt / Modellnummer eingeben:',
    add_modal_quick_test: 'Schnelltest:',
    add_modal_identify_btn: 'Erkennen',
    add_modal_camera_instruction: 'Barcode oder Typenschild im Fadenkreuz ausrichten',
    add_modal_test_fixtures: 'Test-Barcodes:',
    confirm_badge: 'VERIFIZIERTES PRODUKT',
    confirm_source_badge: 'Herstellerdaten',
    confirm_add_btn: 'Im Portfolio speichern',
    confirm_searching: 'Produktdatenbanken durchsuchen…',
    confirm_verified_title: 'Produkt identifiziert',
    confirm_specs_header: 'HERSTELLER-SPEZIFIKATIONEN',
    confirm_policy_header: 'HERSTELLERGARANTIE / RICHTLINIE',
    confirm_market_header: 'REGIONALER MARKTWERT',
    confirm_ownership_header: 'IHRE GERÄTEDATEN (OPTIONAL)',
    confirm_purchase_date: 'Kaufdatum:',
    confirm_purchase_price: 'Kaufpreis ({currency}):',
    confirm_warranty_duration: 'Garantiedauer:',
    confirm_room_location: 'Raum / Standort:',
    confirm_save_btn: 'Im Portfolio speichern',
    confirm_cancel_btn: 'Abbrechen',
    confirm_warranty_months: '{val} Monate',
    confirm_warranty_text: '{val} Monate ({source})',
    confirm_standard_policy: 'Standard Gewährleistung (OR 210)',
    confirm_market_unavailable: 'Marktwert nicht verfügbar',
    confirm_years: 'Jahre',
    confirm_months_short: 'Monate',
    camera_title: 'Live Barcode- & Typenschild-Scanner',
    toast_offline: 'Sie sind offline. Gespeicherte Gerätedaten bleiben verfügbar.',
    toast_search_busy: 'Produktsuche ist vorübergehend ausgelastet. Bitte kurz warten.',
    toast_search_auth_error: 'Suchdienst-Konfigurationsfehler.',
    toast_search_timeout: 'Zeitüberschreitung der Suchanfrage. Bitte Verbindung prüfen.',
    toast_search_unavailable: 'Produkterkennung vorübergehend nicht verfügbar.',
    coffee_barista_deck: 'Barista-Zentrale',
    coffee_todays_extraction: "Heutige Extraktion",
    coffee_no_machine_paired: 'Keine Kaffeemaschine verbunden',
    coffee_add_machine_title: '+ Kaffeemaschine verbinden',
    coffee_add_machine_desc: 'Verbinden Sie Ihre Espressomaschine für Wasserhärte, Entkalkung und Dial-In-Speicher.',
    coffee_easy_mode_badge: 'EINFACHER MODUS · BOHNE ZUR TASSE',
    coffee_15bar_pump: '15-Bar Thermoblock',
    coffee_select_beverage: 'GETRÄNK WÄHLEN',
    coffee_aroma_strength: 'AROMASTÄRKE',
    coffee_strength_level: 'Stufe {n} von 5',
    coffee_repeat_brew_label: '1-Klick Letzte Extraktion wiederholen',
    coffee_active_recipe_badge: 'AKTIVES ZIELREZEPT',
    coffee_metric_dose_in: 'DOSIERUNG',
    coffee_metric_yield_out: 'AUSGABE (GRAMM)',
    coffee_metric_target_time: 'ZIELZEIT',
    coffee_metric_grinder_step: 'MAHLGRAD',
    coffee_active_bean_title: 'Aktive Bohne im Trichter',
    coffee_bean_cellar_link: 'Bohnenkeller ({count}) →',
    coffee_bag_inventory: 'PACKUNGSBESTAND',
    coffee_roaster_notes: 'Röstnotizen:',
    coffee_water_care_title: 'Wasserchemie & Pflege',
    coffee_equipment_care_link: 'Gerätepflege →',
    coffee_water_source_label: 'STÄDTISCHE WASSERQUELLE',
    coffee_scale_risk_label: 'KALKRISIKO',
    coffee_local_hardness: 'Lokale Härte',
    coffee_next_descale: 'Nächste Entkalkung',
    coffee_descale_in_days: 'In {days} Tagen',
    coffee_filter_life: 'Filter: {percent}%',
    coffee_filtration_label: 'Filtration:',
    coffee_dial_in_memory_title: 'Dial-In Speicher',
    coffee_attempt_number: 'Versuch #{n}',
    coffee_grind_label: 'Mahlgrad',
    coffee_total_shots: 'Gesamtbezüge:',
    coffee_my_grinder_fleet: 'MEINE MÜHLEN',
    coffee_oem_maintenance: 'OEM Wartungsprotokoll',
    coffee_descale_cycle_title: 'Thermoblock Entkalkungszyklus',
    coffee_descale_cycle_detail: 'Fällig in {days} Tagen · Bio-Flüssigentkalker',
    coffee_btn_log_done: 'Als erledigt erfassen',
    coffee_filter_cartridge_title: 'Wasserfilter-Patrone',
    coffee_filter_lifespan_detail: '{percent}% Lebensdauer verbleibend',
    coffee_btn_replaced: 'Ersetzt',
    coffee_freshness_unknown: 'Frische unbekannt',
    coffee_roast_date_not_specified: 'Röstdatum nicht angegeben',
    coffee_freshness_degas: 'Ausgasung ({days} Tage nach Röstung)',
    coffee_freshness_peak: 'Optimales Fenster ★ ({days} Tage)',
    coffee_freshness_mature: 'Reif ({days} Tage)',
    coffee_freshness_past_peak: 'Nach Zenit ({days} Tage)',
    toast_water_source_changed: 'Wasserquelle auf {city} ({dh} °dH) eingestellt',
    toast_brew_logged: '{drink} extrahiert und im Kaffeespeicher gesichert!',
    toast_brew_loaded: 'Letzte Rezeptur geladen: {bean} ({dose}g → {yield}g)',
    brew_timer_target_info: 'Ziel: {time} für {yield} Ausgabe ({ratio})',
    brew_btn_resume: 'Timer fortsetzen',
    brew_btn_pause_evaluate: 'Pause & Bewertung',
    brew_btn_start: 'Timer starten',
    coffee_under_extracted: 'Unterextrahiert (Sauer):',
    coffee_under_extracted_advice: 'Mahlgrad 1 Stufe feiner stellen oder Temperatur um 1°C erhöhen.',
    coffee_over_extracted: 'Überextrahiert (Bitter):',
    coffee_over_extracted_advice: 'Mahlgrad 1 Stufe gröber stellen oder Bezug 2 Sekunden früher stoppen.',
    coffee_optimal_extraction: 'Optimale Extraktion!',
    coffee_optimal_extraction_desc: 'Ausgewogene Süsse und Säure. Im Bohnenspeicher gesichert.',
    toast_brew_saved: 'Extraktion im persönlichen Kaffeespeicher gesichert!',
    coffee_bean_remaining: 'Verbleibend:',
    coffee_bean_roast_date: 'Röstdatum:',
    coffee_bean_finished: 'Aufgebraucht',
    coffee_bean_mark_finished: 'Als aufgebraucht markieren',
    toast_bean_name_required: 'Bitte einen Kaffeebohnen-Namen eingeben',
    toast_bean_added: '{name} zum Bohnenkeller hinzugefügt!',
    toast_scanning_bean_bag: 'Kaffeepackung wird gescannt…',
    toast_bean_bag_scanned: 'Packung erkannt! Rösterei, Ursprung und Röstdatum ausgelesen.',
    toast_bean_finished: '{name} als aufgebraucht markiert.',
    toast_coffee_maintenance_logged: '{task} Wartung erfasst! Timer zurückgesetzt.',
    coffee_recipe_label: 'REZEPTUR:',
    coffee_metric_dose: 'DOSIERUNG',
    coffee_metric_yield: 'AUSGABE',
    coffee_metric_time: 'ZEIT',
    coffee_metric_temp: 'TEMPERATUR',
    coffee_bean_origin_label: 'Bohnenursprung:',
    coffee_tasting_notes_label: 'Geschmacksnoten:',
    coffee_extraction_steps: 'EXTRAKTIONS-SCHRITTE:',
    coffee_step_1_dose: 'Frisch gemahlenen Kaffee in den Siebträger dosieren.',
    coffee_step_2_tamp: 'Gleichmässig und waagerecht tampern.',
    coffee_step_3_extract: 'Extrahieren bis Zielgewicht erreicht ist.',
    toast_recipe_loaded: 'Geladen: {name}',
    coffee_advisor_loading: 'Barista AI berechnet optimale Mahlgrad- & Bezugsparameter…',
    coffee_grind_advisor_title: 'BARISTA DIAL-IN BERATER',
    coffee_advisor_grind: 'MAHLGRAD',
    coffee_advisor_dose: 'DOSIERUNG',
    coffee_advisor_yield: 'AUSGABE',
    coffee_advisor_temp: 'TEMPERATUR',
    coffee_sensory_profile: 'Sensorisches Profil:',
    coffee_advisor_calculated_for: 'Berechnet für {roast} Röstung mit {hardness} Wasserhärte.',
    coffee_recipes_title: 'Rezepturen & Brüh-Labor',
    coffee_bean_cellar: 'Bohnenkeller ({count})',
    coffee_filter_all: 'Alle Methoden',
    coffee_filter_espresso: 'Espresso',
    coffee_filter_pour_over: 'Pour-Over (V60)',
    coffee_filter_aeropress: 'Aeropress',
    coffee_filter_cold_brew: 'Cold Brew',
    coffee_filter_cafe_creme: 'Café Crème',
    coffee_advisor_section_title: 'AI BARISTA DIAL-IN BERATER',
    coffee_advisor_badge: 'Specialty Coffee Standards',
    coffee_advisor_desc: 'Berechnen Sie präzise Mahlstufen, Brühverhältnisse, Wassertemperaturen und Durchlaufzeiten für Ihren Kaffee.',
    coffee_brew_method_label: 'BRÜHMETHODE',
    coffee_roast_level_label: 'RÖSTGRAD',
    coffee_bean_origin_placeholder: 'z.B. Äthiopien Yirgacheffe, Kolombien Huila, Kenia AA…',
    coffee_quick_pick: 'Schnellauswahl:',
    coffee_water_hardness_label: 'LOKALE WASSERHÄRTE',
    coffee_calculate_btn: 'Dial-In & Mahlgrad berechnen',
    coffee_brew_library_title: 'Specialty Coffee Bibliothek',
    coffee_machine_maintenance_title: 'Maschinenwartung & Ausrüstung',
    ebike_garage_fleet: 'Garagen-Flotte',
    ebike_stat_battery: 'AKKU-GESUNDHEIT',
    ebike_stat_odometer: 'GESAMT-KILOMETER',
    ebike_next_service: 'Nächster Service: {km} km',
    ebike_component_wear_title: 'Komponenten-Verschleiss & Telemetrie',
    ebike_all_parts_link: 'Alle Teile →',
    ebike_chain_gauge: 'KETTENLÄNGUNGSMESSER',
    ebike_chain_optimal: '{pct}% (Optimal)',
    ebike_chain_hint: 'Kette bei 0.75% ersetzen (SRAM Eagle 12-fach)',
    ebike_suspension_gauge: 'FEDERGABEL-LUFTDRUCK',
    ebike_suspension_hint: 'Kalibriert für 78 kg Fahrergewicht auf Fox 38 Float 160mm Gabel',
    ebike_maintenance_history: 'Letzte Servicehistorie',
    ebike_chain_lubrication: 'Keramik-Kettenschmierung',
    ebike_applied_next_due: 'Durchgeführt bei {applied} km · Nächste bei {due} km',
    ebike_bike_specs_title: 'Bike-Spezifikationen',
    ebike_consumables_title: 'Verschleissteile & Verbrauchsmaterial',
    ebike_motor_error_decoder: 'MOTOR-FEHLERCODE DECODER',
    ebike_motor_diag_desc: 'Geben Sie einen Bosch-, Shimano EP8- oder Bafang-Fehlercode ein für eine AI-Diagnose.',
    ebike_motor_diag_placeholder: 'Fehlercode (z.B. 503, 540, 0x04)',
    ebike_btn_decode_error: 'Motorfehler mit AI analysieren',
    ebike_frame_serial: 'Rahmennummer: •••• 9912',
    toast_ride_recorded: 'Fahrt über {km} km erfasst! Gesamtkilometer aktualisiert.',
    ebike_diag_empty_toast: 'Bitte Fehlercode eingeben (z.B. 503, 540)',
    ebike_diag_decoding: 'Fehler {code} wird mit Gemini analysiert…',
    ebike_diag_fallback_title: 'Motorsystem-Warnung',
    ebike_diag_cause_label: 'Ursache:',
    ebike_diag_fallback_cause: 'Geschwindigkeitssensor oder Speichenmagnet dejustiert.',
    ebike_diag_action_label: 'Massnahme:',
    ebike_diag_fallback_action: 'Speichenmagnet-Ausrichtung zum Sensor prüfen.',
    ski_alpine_quiver: 'Alpin Ski-Quiver',
    ski_metric_din: 'ISO 11088 DIN-WERT',
    ski_metric_bsl: '{bsl}mm Sohle · {weight}kg Fahrer',
    ski_base_wax: 'GRUNDWACHS',
    ski_snow_range: '{low}°C bis {high}°C Kaltschnee',
    ski_btn_recalc_din: 'Bindungs-DIN neu berechnen (ISO 11088)',
    ski_section_readiness: 'Saison-Bereitschaft & Service',
    ski_btn_tuning_log: 'Service-Historie →',
    ski_readiness_ski_days: 'Skitage diese Saison',
    ski_readiness_ski_days_val: '{n} Tage auf Schnee',
    ski_readiness_edge: 'Seitenkanten-Winkel',
    ski_readiness_edge_val: '{angle}° Diamant-poliert (vor {days} Tagen)',
    ski_readiness_trip: 'Nächster Skitag',
    ski_readiness_trip_val: '{place} (in {days} Tagen)',
    ski_checklist_title: 'Berg-Checkliste',
    ski_safety_notice: 'Obligatorischer Sicherheitshinweis:',
    ski_safety_notice_desc: 'ISO 11088 DIN-Berechnungen sind Richtwerte. Bindungsauslösewerte müssen durch einen zertifizierten Skitechniker auf einer geeichten Drehmoment-Prüfbank eingestellt und geprüft werden.',
    ski_base_wax_applied: 'Aufgetragenes Grundwachs',
    ski_days_on_snow: 'Tage auf Schnee',
    ski_days_unit: 'Tage',
    ski_wax_advisor_section: 'AI WACHSBERATER',
    ski_snow_temp_placeholder: 'Schneetemperatur °C (z.B. -12)',
    ski_snow_type_packed: 'Kompakter Pulverschnee',
    ski_snow_type_fresh: 'Frischer Neuschnee',
    ski_snow_type_icy: 'Vereiste / Harte Piste',
    ski_snow_type_wet: 'Nasser Frühlingsschnee',
    ski_btn_get_ai_wax: 'AI Wachsempfehlung abrufen',
    toast_din_applied: 'DIN {value} auf {binding} angewendet!',
    ski_wax_calculating: 'Berechne Wachsempfehlung für {temp}°C…',
    ski_wax_result_wax: 'EMPFOHLENES WACHS',
    ski_wax_result_iron: 'BÜGELEISENTEMP',
    ski_wax_fallback: 'Toko LF Blue fluorfreies Kaltwachs empfohlen für {temp}°C Pulverschnee.',
    ski_setup_title: 'Bindungs- & Skischuh-Setup',
    ski_tuning_title: 'Kanten- & Wachshistorie',
    ski_domain_subtitle: 'Quiver, DIN-Auslösung & Wachs'
  },

  // ==================== 7. FRANÇAIS (fr) ====================
  fr: {
    settings_group_legal: 'JURIDIQUE, CONFIDENTIALITÉ ET SUPPORT',
    settings_privacy_title: 'Politique de confidentialité',
    settings_privacy_sub: 'Stockage local, zéro traçage, conformité RGPD et LPD suisse',
    settings_terms_title: 'Conditions d\'utilisation (CLUF)',
    settings_terms_sub: 'Exclusion de garantie, sécurité et CLUF standard Apple',
    settings_support_title: 'Support client et diagnostic',
    settings_support_sub: 'Assistance par e-mail, télémétrie système et FAQ',
    settings_erase_title: 'Effacer toutes les données locales',
    settings_erase_sub: 'Supprimer définitivement tous les appareils, garanties et réglages',
    legal_privacy_modal_title: 'Politique de confidentialité et transparence',
    legal_privacy_intro: 'Nordic Asset Suite repose sur une architecture locale stricte. Vos données domestiques vous appartiennent exclusivement.',
    legal_privacy_sec1_title: '1. Stockage local sur l\'appareil',
    legal_privacy_sec1_body: 'Tous vos appareils, numéros de série et historiques de maintenance sont stockés localement sur votre appareil. Nous ne vendons ni ne partageons jamais vos données.',
    legal_privacy_sec2_title: '2. Caméra, photos et OCR de plaque signalétique',
    legal_privacy_sec2_body: 'Les photos sont traitées instantanément pour l\'extraction de texte et ne sont jamais stockées sur des serveurs externes.',
    legal_privacy_sec3_title: '3. Services tiers pour les spécifications',
    legal_privacy_sec3_body: 'Les recherches s\'effectuent via des flux API chiffrés sans transmission de données personnelles identifiables.',
    legal_privacy_sec4_title: '4. RGPD et droits de suppression',
    legal_privacy_sec4_body: 'Vous pouvez inspecter ou effacer définitivement vos données à tout moment via les réglages.',
    legal_privacy_sec5_title: '5. Contact confidentialité',
    legal_privacy_sec5_body: 'Contactez-nous à privacy@nordicasset.app pour toute question relative aux données.',
    legal_terms_modal_title: 'Conditions d\'utilisation et CLUF',
    legal_terms_intro: 'Veuillez lire attentivement ces conditions avant d\'utiliser Nordic Asset Suite.',
    legal_terms_sec1_title: '1. CLUF standard d\'Apple',
    legal_terms_sec1_body: 'L\'utilisation est régie par le CLUF standard d\'Apple et les présentes clauses complémentaires.',
    legal_terms_sec2_title: '2. Exclusion de garantie',
    legal_terms_sec2_body: 'Les calculs d\'expiration de garantie sont fournis à titre informatif et ne constituent pas un contrat d\'assurance.',
    legal_terms_sec3_title: '3. Avertissement de sécurité',
    legal_terms_sec3_body: 'Les utilisateurs assument l\'entière responsabilité de l\'entretien physique et de la sécurité électrique.',
    legal_terms_sec4_title: '4. Marques déposées',
    legal_terms_sec4_body: 'Toutes les marques commerciales appartiennent à leurs propriétaires respectifs. Nordic Asset Suite est un outil indépendant.',
    legal_terms_sec5_title: '5. Droit applicable',
    legal_terms_sec5_body: 'Les présentes conditions sont régies par le droit suisse avec for juridique à Zurich.',
    legal_support_modal_title: 'Support client et diagnostic',
    legal_support_intro: 'Notre équipe d\'ingénierie suisse est à votre écoute pour vous aider.',
    legal_support_email_label: 'E-mail de support direct',
    legal_support_version_label: 'Version de l\'application',
    legal_support_diag_btn: 'Copier le rapport de diagnostic',
    legal_support_faq_title: 'Foire aux questions (FAQ)',
    legal_support_faq1_q: 'Comment est calculée la fin de garantie ?',
    legal_support_faq1_a: 'En combinant votre date d\'achat avec les garanties constructeur vérifiées ou les délais légaux.',
    legal_support_faq2_q: 'Les photos de plaques sont-elles enregistrées dans le cloud ?',
    legal_support_faq2_a: 'Non. Le traitement OCR est éphémère sans stockage distant.',
    legal_support_faq3_q: 'Puis-je exporter mes données ?',
    legal_support_faq3_a: 'Oui, vos données sont conservées de manière structurée sur votre appareil.',
    legal_erase_confirm_prompt: 'Êtes-vous sûr de vouloir effacer définitivement toutes les données locales ?',
    legal_erase_toast_success: 'Toutes les données locales ont été effacées avec succès.',

    notif_log_title: 'Alertes programmées de garantie & entretien',
    notif_log_desc: 'Toutes les notifications sont calculées localement sur votre appareil. Voici votre calendrier de protection actif :',
    notif_empty_desc: 'Aucun appareil actif trouvé. Ajoutez des appareils pour afficher les alertes programmées.',
    notif_asset_label: 'Appareil',
    notif_settings_group: 'NOTIFICATIONS DE GARANTIE ET ENTRETIEN',
    notif_settings_warranty_title: 'Rappels d\'expiration de garantie',
    notif_settings_warranty_desc: 'Notification 30 jours, 7 jours et 1 jour avant la fin de garantie légale',
    notif_settings_maint_title: 'Rappels d\'entretien et de service',
    notif_settings_maint_desc: 'Détartrage, remplacement de filtres et intervalles périodiques',
    notif_settings_timeline: 'Consulter le calendrier des alertes programmées',
    notif_prompt_title: 'Activer les alertes de protection de garantie',
    notif_prompt_desc: 'Nordic Asset Suite protège vos investissements domestiques en fournissant des alertes locales précises avant la fin de couverture :',
    notif_prompt_30d: '30 jours avant expiration : Notification précoce pour planifier une inspection ou déclarer une réclamation.',
    notif_prompt_7d: '7 jours avant expiration : Alerte urgente avant la clôture du délai de garantie.',
    notif_prompt_1d: '24 heures avant expiration : Avis final d\'expiration de garantie.',
    notif_prompt_maint: 'Entretien régulier : Détartrage, nettoyage de filtres et rappels de service.',
    notif_btn_allow: 'Autoriser les notifications',
    notif_btn_later: 'Peut-être plus tard',
    notif_toast_warranty_enabled: 'Rappels d\'expiration de garantie activés (30j, 7j, 1j).',
    notif_toast_warranty_disabled: 'Rappels d\'expiration de garantie désactivés.',
    notif_toast_maint_enabled: 'Rappels d\'entretien activés.',
    notif_toast_maint_disabled: 'Rappels d\'entretien désactivés.',
    notif_toast_permission_granted: 'Notifications locales activées !',
    notif_toast_permission_denied: 'Autorisation de notification non accordée.',
    notif_warranty_30d_title: 'Avis d\'expiration de garantie à 30 jours',
    notif_warranty_30d_msg: 'La garantie légale pour {asset} expire le {date}. Vérifiez l\'état de l\'appareil pour faire valoir vos droits à temps.',
    notif_warranty_7d_title: 'Délai critique d\'expiration à 7 jours',
    notif_warranty_7d_msg: 'Plus que 7 jours de couverture légale pour {asset}. Une inspection finale est recommandée.',
    notif_warranty_1d_title: 'Avis final d\'expiration à 24 heures',
    notif_warranty_1d_msg: 'La garantie légale pour {asset} prend fin demain ({date}).',
    notif_part_renewal_title: 'Remplacement de pièce ({percent} % usure) : {part}',
    notif_part_renewal_msg: 'Intervalle de service OEM {pno} : {interval}. Date cible de remplacement : {date}.',
    notif_maintenance_title: 'Entretien requis : {step}',
    notif_maintenance_msg: '{detail} (Fréquence prévue : {freq})',
    notif_test_triggered: 'Notification de test déclenchée pour {asset} !',

    status_expiring_soon: 'Expire bientôt',
    status_no_date: 'Aucune date définie',
    stat_within_90_days: 'Sous 90 jours',
    attention_expired_one: '1 garantie a expiré',
    attention_expired_plural: '{count} garanties ont expiré',
    attention_expiring_one: '1 garantie expire bientôt',
    attention_expiring_plural: '{count} garanties expirent bientôt',
    attention_combined_alert: '{expired} expirée · {expiring} expire bientôt',
    drawer_expiring_soon: 'Expire bientôt',
    drawer_user_purchase_price: 'Prix d\'achat utilisateur',
    drawer_estimated_market_value: 'Valeur marchande estimée',
    not_specified: 'Non spécifié',
    statutory_protection_title: 'Protection légale de conformité',
    manufacturer_warranty_title: 'Garantie commerciale constructeur',
    user_coverage_title: 'Votre couverture active',

    drawer_warranty_status_label: 'STATUT DE GARANTIE',
    drawer_warranty_desc: 'Protection légale selon l\'art. 210 CO suisse.',
    drawer_purchase_date_label_short: 'Date d\'achat',
    drawer_warranty_policy_label_short: 'Politique de garantie',
    drawer_purchase_price_label_short: 'Prix d\'achat',
    detail_nav_title: 'Détails de l\'équipement',
    detail_manual_summary: 'Protocole d\'entretien recommandé par le fabricant.',
    drawer_diag_prompt: 'Code d\'erreur matériel / symptôme :',
    drawer_diag_placeholder: 'ex. E24, F10, Erreur 107...',
    drawer_diag_btn: 'Diagnostiquer',
    confirm_serial_badge: 'Numéro de série',

    add_placeholder_appliance: 'ex. Siemens KG86PFIC0N, Miele W1, Dyson V15, Grille-pain DeLonghi...',
    add_placeholder_coffee: 'ex. DeLonghi Magnifica Plus, Sage Barista Touch, Jura E8, Philips LatteGo...',
    add_placeholder_ebike: 'ex. Scott Patron eRIDE, Specialized Turbo Levo, Trek Rail 9.8...',
    add_placeholder_skigear: 'ex. Stöckli Laser SL, Atomic Redster S9, Head Worldcup Rebels...',
    promo_line1: 'Protégez vos appareils électroménagers avec le suivi de garantie légale.',
    promo_line2: 'Photographiez la plaque signalétique pour codes d\'erreur et entretien.',
    mo_policy: 'mois de garantie',
    statutory_standard: 'Norme légale',
    coffee_btn_brew_log: 'Journal d\'extraction & mouture',
    coffee_btn_brew_again: 'Appliquer la recette',
    coffee_ratio_label: 'Ratio d\'extraction',
    coffee_btn_start_timer: 'Chronomètre d\'extraction',
    coffee_extraction_notes_fallback: 'Profil équilibré et doux',
    coffee_grinder_step: 'Réglage moulin : Cran {step}',
    ebike_empty_title: 'Aucun vélo électrique associé',
    ebike_empty_desc: 'Ajoutez votre vélo électrique pour surveiller la batterie, la télémétrie moteur et l\'usure de chaîne.',
    ebike_btn_add: 'Ajouter un vélo',
    ski_empty_title: 'Aucun ski alpin enregistré',
    ski_empty_desc: 'Ajoutez vos skis pour calculer le déclenchement ISO 11088 DIN et suivre les cycles de fartage.',
    ski_btn_add: 'Ajouter des skis',
    tour_step_prefix: 'Étape {current} sur {total}',
    tour_btn_back: 'Retour',
    tour_btn_skip: 'Passer la visite',
    tour_btn_start: 'Commencer',
    tour_btn_next: 'Suivant',
    brand_appliance: 'Garantie Appareils',
    brand_coffee: 'Compagnon Café',
    brand_ebike: 'Service Vélo Électrique',
    brand_skigear: 'Suivi Matériel de Ski',
    nav_home: 'Accueil',
    nav_appliances: 'Appareils',
    nav_add: 'Ajouter',
    nav_warranties: 'Garanties',
    nav_settings: 'Paramètres',
    nav_today: 'Aujourd\'hui',
    nav_recipes: 'Recettes',
    nav_machine: 'Machine',
    nav_ride: 'Sortie',
    nav_bike: 'Vélo',
    nav_parts: 'Pièces',
    nav_quiver: 'Skis',
    nav_setup: 'Réglages',
    nav_tuning: 'Entretien',
    rooms_all: 'Tous',
    rooms_kitchen: 'Cuisine',
    rooms_living: 'Salon',
    rooms_laundry: 'Buanderie',
    rooms_bedroom: 'Chambre',
    rooms_bathroom: 'Salle de bain',
    rooms_office: 'Bureau',
    rooms_dining: 'Salle à manger',
    rooms_hallway: 'Couloir / Placard',
    rooms_garage: 'Garage',
    rooms_skilocker: 'Local à skis',
    rooms_basement: 'Cave',
    rooms_balcony: 'Balcon / Jardin',
    status_active: 'ACTIF',
    status_expired: 'EXPIRÉ',
    status_expiring_soon: 'EXPIRE BIENTÔT',
    stat_items: 'Appareils enregistrés',
    stat_protected: 'Garanties actives',
    stat_expiring: 'Expire bientôt',
    stat_expired: 'Expiré',
    attention_expired_one: '1 garantie est expirée',
    attention_all_ok: 'Tous vos {count} appareils sont couverts par la garantie',
    empty_appliance_title: 'Aucun appareil enregistré',
    empty_appliance_desc: 'Ajoutez votre premier appareil pour suivre garanties, factures et entretien.',
    btn_add_appliance: 'Ajouter un appareil',
    expires_on: 'Expire le : {date}',
    add_purchase_date: 'Ajouter date d\'achat',
    drawer_tab_specs: 'Spécifications techniques',
    drawer_tab_maintenance: 'Entretien & Soins',
    drawer_tab_parts: 'Pièces & Usure',
    drawer_tab_diagnostics: 'Diagnostic',
    drawer_purchase_date_label: 'Date d\'achat (Calcule l\'échéance de garantie) :',
    drawer_policy_label: 'Garantie légale / constructeur :',
    drawer_price_label: 'Prix d\'achat (Valeur de remplacement) :',
    drawer_est_oem_cost: 'Coût OEM estimé :',
    drawer_btn_replace: 'Enregistrer le remplacement',
    drawer_btn_delete: 'Supprimer du portefeuille',
    drawer_delete_confirm: 'Voulez-vous vraiment supprimer "{name}" ? Cette action est irréversible.',
    wear_optimal: 'État optimal',
    wear_moderate: 'Usure modérée',
    wear_due_soon: 'Remplacement bientôt nécessaire',
    wear_overdue: 'Remplacement en retard',
    freq_daily: 'Quotidien',
    freq_weekly: 'Hebdomadaire',
    freq_monthly: 'Mensuel',
    freq_every_60: 'Tous les 60 jours',
    freq_every_90: 'Tous les 90 jours',
    freq_every_150km: 'Tous les 150 km',
    freq_every_4skidays: 'Tous les 4 jours de ski',
    settings_header: 'Préférences & Données Régionales',
    settings_lang_label: 'Langue / Language',
    settings_lang_sub: 'Traduction suisse et européenne',
    settings_currency_label: 'Format de devise',
    settings_currency_sub: 'Appliqué aux valeurs, pièces et prix du marché',
    settings_statutory_label: 'Garantie légale (CO 210)',
    settings_statutory_sub: 'Durée standard pour électroménager',
    settings_tour_label: 'Visite guidée de démonstration',
    settings_reset_demo: 'Réinitialiser les données de démo',
    settings_notif_warranty: 'Rappels d\'expiration de garantie',
    settings_notif_maintenance: 'Rappels d\'entretien et de service',
    settings_timeline_btn: 'Voir le calendrier des alertes prévues',
    toast_lang_changed: 'Langue mise à jour : {name} !',
    greeting_morning: 'Bonjour',
    greeting_afternoon: 'Bon après-midi',
    greeting_evening: 'Bonsoir',
    home_title: 'Votre Foyer',
    my_appliances: 'Mes Appareils',
    see_all: 'Tout voir →',
    add_appliance_cta_title: '+ Ajouter un appareil',
    add_appliance_cta_desc: 'Scanner le code-barres, photographier la plaque ou chercher le modèle',
    all_appliances: 'Tous les Appareils',
    warranty_timeline: 'Chronologie des Garanties',
    stat_fully_covered: 'Entièrement couvert',
    stat_within_90_days: 'Dans les 90 jours',
    stat_action_required: 'Action requise',
    drawer_active: 'Actif',
    drawer_expired: 'Expiré',
    drawer_step: 'Étape',
    drawer_wear: 'Usure',
    drawer_interval: 'Intervalle :',
    drawer_in_use: 'en service',
    toast_purchase_date_updated: 'Date d\'achat mise à jour ! Garantie active jusqu\'au {date}',
    toast_purchase_date_cleared: 'Date d\'achat effacée.',
    toast_warranty_policy_updated: 'Garantie mise à jour à {months} mois !',
    toast_purchase_price_updated: 'Prix d\'achat mis à jour !',
    toast_replacement_logged: 'Remplacement enregistré pour {name} ! Usure remise à 0%.',
    toast_currency_changed: 'Devise mise à jour : {label}',
    toast_statutory_changed: 'Standard légal mis à jour à {val} mois',
    add_modal_title_appliance: 'Ajouter un Appareil',
    add_modal_title_coffee: 'Ajouter une Machine à Café',
    add_modal_title_ebike: 'Ajouter un Vélo Électrique',
    add_modal_title_skigear: 'Ajouter du Matériel de Ski',
    add_modal_scan_title: 'Scanner Code-Barres / QR',
    add_modal_scan_desc: 'EAN-13, UPC ou code-barres emballage',
    add_modal_photo_title: 'Photographier Plaque Signalétique',
    add_modal_photo_desc: 'Extraire les spécifications depuis la plaque fabricant',
    add_modal_manual_label: 'Ou entrer le nom exact / numéro de modèle :',
    add_modal_quick_test: 'Test rapide :',
    add_modal_identify_btn: 'Identifier',
    add_modal_camera_instruction: 'Alignez le code-barres ou la plaque dans le réticule',
    add_modal_test_fixtures: 'Codes-barres de test :',
    confirm_badge: 'PRODUIT VÉRIFIÉ',
    confirm_source_badge: 'Données Fabricant Officielles',
    confirm_add_btn: 'Enregistrer dans le portefeuille',
    confirm_searching: 'Recherche dans les bases de données…',
    confirm_verified_title: 'Produit Identifié',
    confirm_specs_header: 'SPÉCIFICATIONS DU FABRICANT',
    confirm_policy_header: 'GARANTIE CONSTRUCTEUR / POLITIQUE',
    confirm_market_header: 'VALEUR MARCHANDE RÉGIONALE',
    confirm_ownership_header: 'VOS DONNÉES D\'ACHAT (OPTIONNEL)',
    confirm_purchase_date: 'Date d\'achat :',
    confirm_purchase_price: 'Prix d\'achat ({currency}) :',
    confirm_warranty_duration: 'Durée de garantie :',
    confirm_room_location: 'Pièce / Emplacement :',
    confirm_save_btn: 'Enregistrer dans le portefeuille',
    confirm_cancel_btn: 'Annuler',
    confirm_warranty_months: '{val} Mois',
    confirm_warranty_text: '{val} Mois ({source})',
    confirm_standard_policy: 'Garantie Légale Standard (CO 210)',
    confirm_market_unavailable: 'Valeur marchande non disponible',
    confirm_years: 'Ans',
    confirm_months_short: 'Mois',
    camera_title: 'Scanner Live Code-Barres & Plaques',
    toast_offline: 'Vous êtes hors ligne. Les données sauvegardées restent accessibles.',
    toast_search_busy: 'Le service de recherche est temporairement occupé.',
    toast_search_auth_error: 'Erreur de configuration du service de recherche.',
    toast_search_timeout: 'Délai d\'attente dépassé. Vérifiez votre connexion.',
    toast_search_unavailable: 'Recherche de produit temporairement indisponible.',
    coffee_barista_deck: 'Espace Barista',
    coffee_todays_extraction: "Extraction du Jour",
    coffee_no_machine_paired: 'Aucune Machine Connectée',
    coffee_add_machine_title: '+ Connecter Votre Machine',
    coffee_add_machine_desc: 'Connectez votre machine pour dureté de l\'eau, détartrage et mémoire dial-in.',
    coffee_easy_mode_badge: 'MODE FACILE · GRAIN À TASSE',
    coffee_15bar_pump: 'Thermobloc 15-Bar',
    coffee_select_beverage: 'SÉLECTIONNER BOISSON',
    coffee_aroma_strength: 'INTENSITÉ D\'ARÔME',
    coffee_strength_level: 'Niveau {n} sur 5',
    coffee_repeat_brew_label: '1-Clic Répéter Dernière Extraction',
    coffee_active_recipe_badge: 'RECETTE CIBLE ACTIVE',
    coffee_metric_dose_in: 'DOSE GRAIN',
    coffee_metric_yield_out: 'RENDEMENT',
    coffee_metric_target_time: 'TEMPS CIBLE',
    coffee_metric_grinder_step: 'CRAN MOUTURE',
    coffee_active_bean_title: 'Grain Actif dans la Trémie',
    coffee_bean_cellar_link: 'Cave à Grains ({count}) →',
    coffee_bag_inventory: 'STOCK EN SACHET',
    coffee_roaster_notes: 'Notes Torréfaction :',
    coffee_water_care_title: 'Chimie de l\'Eau & Entretien',
    coffee_equipment_care_link: 'Entretien Machine →',
    coffee_water_source_label: 'SOURCE D\'EAU MUNICIPALE',
    coffee_scale_risk_label: 'RISQUE DE CALCAIRE',
    coffee_local_hardness: 'Dureté Locale',
    coffee_next_descale: 'Prochain Détartrage',
    coffee_descale_in_days: 'Dans {days} jours',
    coffee_filter_life: 'Filtre : {percent}%',
    coffee_filtration_label: 'Filtration :',
    coffee_dial_in_memory_title: 'Mémoire Dial-In',
    coffee_attempt_number: 'Essai #{n}',
    coffee_grind_label: 'Mouture',
    coffee_total_shots: 'Total Extractions :',
    coffee_my_grinder_fleet: 'MES MOULINS',
    coffee_oem_maintenance: 'Protocole Entretien Constructeur',
    coffee_descale_cycle_title: 'Cycle Détartrage Thermobloc',
    coffee_descale_cycle_detail: 'Dû dans {days} jours · Détartrant organique liquide',
    coffee_btn_log_done: 'Enregistrer comme fait',
    coffee_filter_cartridge_title: 'Cartouche Filtre Adoucisseur',
    coffee_filter_lifespan_detail: '{percent}% de durée de vie restante',
    coffee_btn_replaced: 'Remplacé',
    coffee_freshness_unknown: 'Fraîcheur inconnue',
    coffee_roast_date_not_specified: 'Date de torréfaction non précisée',
    coffee_freshness_degas: 'Dégazage ({days}j après torréfaction)',
    coffee_freshness_peak: 'Fenêtre Optimale ★ ({days}j)',
    coffee_freshness_mature: 'Mûr ({days}j)',
    coffee_freshness_past_peak: 'Après Pic ({days}j)',
    toast_water_source_changed: 'Source d\'eau réglée sur {city} ({dh} °dH)',
    toast_brew_logged: '{drink} extrait et enregistré dans la mémoire café !',
    toast_brew_loaded: 'Dernière recette chargée : {bean} ({dose}g → {yield}g)',
    brew_timer_target_info: 'Cible : {time} pour {yield} ({ratio})',
    brew_btn_resume: 'Reprendre',
    brew_btn_pause_evaluate: 'Pause & Évaluation',
    brew_btn_start: 'Démarrer le Timer',
    coffee_under_extracted: 'Sous-extrait (Trop acide / aigre) :',
    coffee_under_extracted_advice: 'Moulez 1 cran plus fin ou augmentez la température de 1°C.',
    coffee_over_extracted: 'Sur-extrait (Trop amer) :',
    coffee_over_extracted_advice: 'Moulez 1 cran plus gros ou arrêtez 2 secondes plus tôt.',
    coffee_optimal_extraction: 'Extraction Optimale !',
    coffee_optimal_extraction_desc: 'Douceur et acidité parfaitement équilibrées. Enregistré.',
    toast_brew_saved: 'Extraction enregistrée dans la mémoire café personnelle !',
    coffee_bean_remaining: 'Restant :',
    coffee_bean_roast_date: 'Date Torréfaction :',
    coffee_bean_finished: 'Terminé',
    coffee_bean_mark_finished: 'Marquer comme terminé',
    toast_bean_name_required: 'Veuillez entrer un nom de café',
    toast_bean_added: '{name} ajouté à la Cave à Grains !',
    toast_scanning_bean_bag: 'Scan de l\'étiquette du sachet…',
    toast_bean_bag_scanned: 'Sachet reconnu ! Torréfacteur, origine et date extraits.',
    toast_bean_finished: '{name} marqué comme terminé.',
    toast_coffee_maintenance_logged: 'Entretien {task} enregistré ! Compteurs réinitialisés.',
    coffee_recipe_label: 'RECETTE :',
    coffee_metric_dose: 'DOSE',
    coffee_metric_yield: 'RENDEMENT',
    coffee_metric_time: 'TEMPS',
    coffee_metric_temp: 'TEMPÉRATURE',
    coffee_bean_origin_label: 'Origine du Grain :',
    coffee_tasting_notes_label: 'Notes de Dégustation :',
    coffee_extraction_steps: 'ÉTAPES D\'EXTRACTION :',
    coffee_step_1_dose: 'Dosez le café fraîchement moulu dans le porte-filtre.',
    coffee_step_2_tamp: 'Tassez uniformément et horizontalement.',
    coffee_step_3_extract: 'Extrayez jusqu\'au poids cible.',
    toast_recipe_loaded: 'Chargé : {name}',
    coffee_advisor_loading: 'Consultation IA Barista pour les paramètres de mouture…',
    coffee_grind_advisor_title: 'CONSEILLER DIAL-IN BARISTA',
    coffee_advisor_grind: 'MOUTURE',
    coffee_advisor_dose: 'DOSE',
    coffee_advisor_yield: 'RENDEMENT',
    coffee_advisor_temp: 'TEMPÉRATURE',
    coffee_sensory_profile: 'Profil Sensoriel :',
    coffee_advisor_calculated_for: 'Calculé pour torréfaction {roast} avec dureté {hardness}.',
    coffee_recipes_title: 'Recettes & Labo d\'Extraction',
    coffee_bean_cellar: 'Cave à Grains ({count})',
    coffee_filter_all: 'Toutes Méthodes',
    coffee_filter_espresso: 'Espresso',
    coffee_filter_pour_over: 'Pour-Over (V60)',
    coffee_filter_aeropress: 'Aeropress',
    coffee_filter_cold_brew: 'Cold Brew',
    coffee_filter_cafe_creme: 'Café Crème',
    coffee_advisor_section_title: 'IA BARISTA CONSEILLER DIAL-IN',
    coffee_advisor_badge: 'Standards Cafés de Spécialité',
    coffee_advisor_desc: 'Calculez réglage de mouture, ratio d\'extraction, température et temps d\'écoulement.',
    coffee_brew_method_label: 'MÉTHODE D\'EXTRACTION',
    coffee_roast_level_label: 'NIVEAU DE TORRÉFACTION',
    coffee_bean_origin_placeholder: 'ex. Éthiopie Yirgacheffe, Colombie Huila, Kenya AA…',
    coffee_quick_pick: 'Sélection rapide :',
    coffee_water_hardness_label: 'DURETÉ D\'EAU LOCALE',
    coffee_calculate_btn: 'Calculer Dial-In & Réglage Mouture',
    coffee_brew_library_title: 'Bibliothèque de Cafés de Spécialité',
    coffee_machine_maintenance_title: 'Entretien Machine & Équipement',
    ebike_garage_fleet: 'Flotte du Garage',
    ebike_stat_battery: 'SANTÉ BATTERIE',
    ebike_stat_odometer: 'KILOMÉTRAGE TOTAL',
    ebike_next_service: 'Prochain service : {km} km',
    ebike_component_wear_title: 'Usure Composants & Télémétrie',
    ebike_all_parts_link: 'Toutes les pièces →',
    ebike_chain_gauge: 'JAUGE D\'ALLONGEMENT DE CHAÎNE',
    ebike_chain_optimal: '{pct}% (Optimal)',
    ebike_chain_hint: 'Remplacer à 0.75% (SRAM Eagle 12 vitesses)',
    ebike_suspension_gauge: 'PRESSION FOURCHE PNEUMATIQUE',
    ebike_suspension_hint: 'Calibré pour pilote de 78 kg sur fourche Fox 38 Float 160mm',
    ebike_maintenance_history: 'Historique d\'Entretien Récent',
    ebike_chain_lubrication: 'Lubrification Céramique Chaîne',
    ebike_applied_next_due: 'Effectué à {applied} km · Prochain à {due} km',
    ebike_bike_specs_title: 'Spécifications du Vélo',
    ebike_consumables_title: 'Pièces d\'Usure & Consommables',
    ebike_motor_error_decoder: 'DÉCODEUR CODE ERREUR MOTEUR',
    ebike_motor_diag_desc: 'Entrez un code erreur Bosch, Shimano EP8 ou Bafang pour un diagnostic IA.',
    ebike_motor_diag_placeholder: 'Code erreur (ex. 503, 540, 0x04)',
    ebike_btn_decode_error: 'Analyser Code Erreur avec IA',
    ebike_frame_serial: 'N° de Cadre : •••• 9912',
    toast_ride_recorded: 'Sortie de {km} km enregistrée ! Compteur kilométrique mis à jour.',
    ebike_diag_empty_toast: 'Entrez un code erreur moteur (ex. 503, 540)',
    ebike_diag_decoding: 'Analyse du code {code} avec Gemini…',
    ebike_diag_fallback_title: 'Alerte Système Moteur',
    ebike_diag_cause_label: 'Cause :',
    ebike_diag_fallback_cause: 'Capteur de vitesse ou aimant de rayon mal aligné.',
    ebike_diag_action_label: 'Action :',
    ebike_diag_fallback_action: 'Vérifier l\'alignement de l\'aimant de rayon face au capteur.',
    ski_alpine_quiver: 'Matériel Alpin Actif',
    ski_metric_din: 'VALEUR DIN ISO 11088',
    ski_metric_bsl: '{bsl}mm Semelle · Skieur {weight}kg',
    ski_base_wax: 'FART DE BASE',
    ski_snow_range: '{low}°C à {high}°C Neige Froide',
    ski_btn_recalc_din: 'Recalculer DIN Fixation (ISO 11088)',
    ski_section_readiness: 'Préparation Saison & Entretien',
    ski_btn_tuning_log: 'Journal d\'entretien →',
    ski_readiness_ski_days: 'Jours de ski cette saison',
    ski_readiness_ski_days_val: '{n} Jours sur Neige',
    ski_readiness_edge: 'Angle Carres Latérales',
    ski_readiness_edge_val: '{angle}° Fini Diamant (il y a {days} jours)',
    ski_readiness_trip: 'Prochaine Sortie',
    ski_readiness_trip_val: '{place} (dans {days} jours)',
    ski_checklist_title: 'Checklist Montagne',
    ski_safety_notice: 'Exigence de Sécurité Obligatoire :',
    ski_safety_notice_desc: 'Les calculs DIN ISO 11088 sont indicatifs. Le couple de déclenchement des fixations doit être réglé et vérifié par un technicien agréé sur un banc de test étalonné.',
    ski_base_wax_applied: 'Fart de Base Appliqué',
    ski_days_on_snow: 'Jours sur Neige',
    ski_days_unit: 'Jours',
    ski_wax_advisor_section: 'CONSEILLER FARTAGE IA',
    ski_snow_temp_placeholder: 'Température Neige °C (ex. -12)',
    ski_snow_type_packed: 'Neige Damée / Piste',
    ski_snow_type_fresh: 'Neige Fraîche / Poudreuse',
    ski_snow_type_icy: 'Piste Verglacée / Dure',
    ski_snow_type_wet: 'Neige de Printemps Mouillée',
    ski_btn_get_ai_wax: 'Obtenir Recommandation Fart IA',
    toast_din_applied: 'Valeur DIN {value} appliquée sur {binding} !',
    ski_wax_calculating: 'Calcul du fart optimal pour {temp}°C…',
    ski_wax_result_wax: 'FART RECOMMANDÉ',
    ski_wax_result_iron: 'TEMPÉRATURE FER',
    ski_wax_fallback: 'Fart Toko LF Blue sans fluor recommandé pour {temp}°C sur neige damée.',
    ski_setup_title: 'Configuration Fixations & Chaussures',
    ski_tuning_title: 'Historique Carres & Fartage',
    ski_domain_subtitle: 'Matériel, Déclenchement DIN & Fartage'
  },

  // ==================== 8. ITALIANO (it) ====================
  it: {
    settings_group_legal: 'NOTE LEGALI, PRIVACY E SUPPORTO',
    settings_privacy_title: 'Informativa sulla privacy',
    settings_privacy_sub: 'Archiviazione locale, zero tracciamento, conformità GDPR e LPD svizzera',
    settings_terms_title: 'Condizioni d\'uso (EULA)',
    settings_terms_sub: 'Esclusioni di garanzia, linee guida di sicurezza ed EULA standard Apple',
    settings_support_title: 'Supporto clienti e diagnostica',
    settings_support_sub: 'Assistenza e-mail, telemetria di sistema e FAQ',
    settings_erase_title: 'Cancella tutti i dati locali e ripristina',
    settings_erase_sub: 'Elimina definitivamente tutti i dispositivi, registri di garanzia e impostazioni',
    legal_privacy_modal_title: 'Informativa sulla privacy e trasparenza',
    legal_privacy_intro: 'Nordic Asset Suite si basa su una rigorosa architettura di privacy locale. I dati della tua casa appartengono solo a te.',
    legal_privacy_sec1_title: '1. Archiviazione locale sul dispositivo',
    legal_privacy_sec1_body: 'Tutti i tuoi elettrodomestici, numeri di serie e registri di manutenzione sono memorizzati localmente sul tuo dispositivo. Non vendiamo né condividiamo mai i tuoi dati.',
    legal_privacy_sec2_title: '2. Fotocamera, foto e OCR targhetta',
    legal_privacy_sec2_body: 'Le foto vengono elaborate istantaneamente per l\'estrazione del testo e non vengono mai salvate su server esterni.',
    legal_privacy_sec3_title: '3. Servizi di terze parti per specifiche',
    legal_privacy_sec3_body: 'Le ricerche avvengono tramite connessioni API crittografate senza trasmissione di dati personali.',
    legal_privacy_sec4_title: '4. GDPR e diritti di cancellazione',
    legal_privacy_sec4_body: 'Puoi cancellare definitivamente tutti i dati in qualsiasi momento tramite le impostazioni.',
    legal_privacy_sec5_title: '5. Contatto privacy',
    legal_privacy_sec5_body: 'Contattaci all\'indirizzo privacy@nordicasset.app per domande sulla protezione dei dati.',
    legal_terms_modal_title: 'Condizioni d\'uso ed EULA standard',
    legal_terms_intro: 'Si prega di leggere attentamente queste condizioni prima di utilizzare Nordic Asset Suite.',
    legal_terms_sec1_title: '1. EULA standard di Apple',
    legal_terms_sec1_body: 'L\'utilizzo è regolato dai termini EULA standard di Apple e dalle presenti disposizioni integrative.',
    legal_terms_sec2_title: '2. Esclusione di garanzia',
    legal_terms_sec2_body: 'I calcoli di scadenza della garanzia sono forniti a scopo puramente informativo e non costituiscono una polizza assicurativa.',
    legal_terms_sec3_title: '3. Avvertenze di sicurezza',
    legal_terms_sec3_body: 'Gli utenti si assumono la piena responsabilità per la manutenzione fisica e la sicurezza elettrica.',
    legal_terms_sec4_title: '4. Marchi registrati',
    legal_terms_sec4_body: 'Tutti i marchi appartengono ai rispettivi proprietari. Nordic Asset Suite è uno strumento indipendente.',
    legal_terms_sec5_title: '5. Legge applicabile',
    legal_terms_sec5_body: 'Le presenti condizioni sono regolate dal diritto svizzero con foro competente a Zurigo.',
    legal_support_modal_title: 'Supporto clienti e diagnostica',
    legal_support_intro: 'Il nostro team di ingegneri svizzeri è a tua disposizione.',
    legal_support_email_label: 'E-mail di supporto diretto',
    legal_support_version_label: 'Versione dell\'applicazione',
    legal_support_diag_btn: 'Copia report di diagnostica',
    legal_support_faq_title: 'Domande frequenti (FAQ)',
    legal_support_faq1_q: 'Come viene calcolata la scadenza della garanzia?',
    legal_support_faq1_a: 'Combinando la data di acquisto con le garanzie verificate del produttore o i termini di legge.',
    legal_support_faq2_q: 'Le foto delle targhette vengono salvate nel cloud?',
    legal_support_faq2_a: 'No. Il rilevamento OCR è temporaneo senza archiviazione permanente.',
    legal_support_faq3_q: 'Posso esportare i miei dati?',
    legal_support_faq3_a: 'Sì, i tuoi dati sono conservati in formato strutturato sul dispositivo.',
    legal_erase_confirm_prompt: 'Sei sicuro di voler cancellare definitivamente tutti i dati e le impostazioni?',
    legal_erase_toast_success: 'Tutti i dati locali sono stati cancellati.',

    notif_log_title: 'Avvisi programmati di garanzia e manutenzione',
    notif_log_desc: 'Tutte le notifiche sono elaborate localmente sul dispositivo. Di seguito il programma di protezione attivo:',
    notif_empty_desc: 'Nessun dispositivo attivo trovato. Aggiungi elettrodomestici per visualizzare gli avvisi programmati.',
    notif_asset_label: 'Dispositivo',
    notif_settings_group: 'NOTIFICHE DI GARANZIA E SERVIZIO',
    notif_settings_warranty_title: 'Promemoria scadenza garanzia',
    notif_settings_warranty_desc: 'Notifica 30 giorni, 7 giorni e 1 giorno prima del termine di garanzia legale',
    notif_settings_maint_title: 'Promemoria manutenzione e servizio',
    notif_settings_maint_desc: 'Decalcificazione, sostituzione filtri e intervalli di revisione',
    notif_settings_timeline: 'Visualizza cronologia avvisi programmati',
    notif_prompt_title: 'Attiva gli avvisi di protezione garanzia',
    notif_prompt_desc: 'Nordic Asset Suite protegge i tuoi investimenti domestici fornendo tempestivi avvisi locali prima della scadenza della copertura:',
    notif_prompt_30d: '30 giorni prima della scadenza: Notifica tempestiva per programmare controlli o reclami.',
    notif_prompt_7d: '7 giorni prima della scadenza: Avviso critico prima della chiusura della copertura.',
    notif_prompt_1d: '24 ore prima della scadenza: Avviso finale di scadenza garanzia.',
    notif_prompt_maint: 'Manutenzione periodica: Decalcificazione, pulizia filtri e promemoria di servizio.',
    notif_btn_allow: 'Consenti notifiche',
    notif_btn_later: 'Forse più tardi',
    notif_toast_warranty_enabled: 'Promemoria scadenza garanzia attivati (30g, 7g, 1g).',
    notif_toast_warranty_disabled: 'Promemoria scadenza garanzia disattivati.',
    notif_toast_maint_enabled: 'Promemoria manutenzione attivati.',
    notif_toast_maint_disabled: 'Promemoria manutenzione disattivati.',
    notif_toast_permission_granted: 'Notifiche locali attivate!',
    notif_toast_permission_denied: 'Permesso di notifica non concesso.',
    notif_warranty_30d_title: 'Avviso di scadenza garanzia a 30 giorni',
    notif_warranty_30d_msg: 'La garanzia legale per {asset} scade il {date}. Verifica le condizioni del dispositivo per inoltrare richieste in tempo.',
    notif_warranty_7d_title: 'Termine critico di scadenza a 7 giorni',
    notif_warranty_7d_msg: 'Mancano solo 7 giorni al termine della copertura legale per {asset}. Si raccomanda un controllo finale.',
    notif_warranty_1d_title: 'Avviso finale di scadenza a 24 ore',
    notif_warranty_1d_msg: 'La garanzia legale per {asset} scade domani ({date}).',
    notif_part_renewal_title: 'Rinnovo componente ({percent}% usura): {part}',
    notif_part_renewal_msg: 'Intervallo di servizio OEM {pno}: {interval}. Data target per la sostituzione: {date}.',
    notif_maintenance_title: 'Manutenzione dovuta: {step}',
    notif_maintenance_msg: '{detail} (Frequenza programmata: {freq})',
    notif_test_triggered: 'Notifica di test generata per {asset}!',

    status_expiring_soon: 'In scadenza',
    status_no_date: 'Nessuna data impostata',
    stat_within_90_days: 'Entro 90 giorni',
    attention_expired_one: '1 garanzia è scaduta',
    attention_expired_plural: '{count} garanzie sono scadute',
    attention_expiring_one: '1 garanzia è in scadenza',
    attention_expiring_plural: '{count} garanzie in scadenza',
    attention_combined_alert: '{expired} scaduta · {expiring} in scadenza',
    drawer_expiring_soon: 'In scadenza',
    drawer_user_purchase_price: 'Prezzo d\'acquisto utente',
    drawer_estimated_market_value: 'Valore di mercato stimato',
    not_specified: 'Non specificato',
    statutory_protection_title: 'Garanzia legale di conformità',
    manufacturer_warranty_title: 'Garanzia convenzionale produttore',
    user_coverage_title: 'La tua copertura attiva',

    drawer_warranty_status_label: 'STATO GARANZIA',
    drawer_warranty_desc: 'Protezione legale secondo l\'art. 210 CO svizzero.',
    drawer_purchase_date_label_short: 'Data di acquisto',
    drawer_warranty_policy_label_short: 'Politica di garanzia',
    drawer_purchase_price_label_short: 'Prezzo di acquisto',
    detail_nav_title: 'Dettagli risorsa',
    detail_manual_summary: 'Protocollo di manutenzione consigliato dal produttore.',
    drawer_diag_prompt: 'Codice errore hardware / sintomo:',
    drawer_diag_placeholder: 'es. E24, F10, Errore 107...',
    drawer_diag_btn: 'Diagnostica',
    confirm_serial_badge: 'Numero di serie',

    add_placeholder_appliance: 'es. Siemens KG86PFIC0N, Miele W1, Dyson V15, Tostapane DeLonghi...',
    add_placeholder_coffee: 'es. DeLonghi Magnifica Plus, Sage Barista Touch, Jura E8, Philips LatteGo...',
    add_placeholder_ebike: 'es. Scott Patron eRIDE, Specialized Turbo Levo, Trek Rail 9.8...',
    add_placeholder_skigear: 'es. Stöckli Laser SL, Atomic Redster S9, Head Worldcup Rebels...',
    promo_line1: 'Proteggi i tuoi elettrodomestici con il monitoraggio della garanzia legale.',
    promo_line2: 'Fotografa la targhetta per codici errore istantanei e piani di manutenzione.',
    mo_policy: 'mesi di garanzia',
    statutory_standard: 'Standard legale',
    coffee_btn_brew_log: 'Diario estrazioni & macinatura',
    coffee_btn_brew_again: 'Applica ricetta',
    coffee_ratio_label: 'Rapporto di estrazione',
    coffee_btn_start_timer: 'Timer estrazione',
    coffee_extraction_notes_fallback: 'Profilo bilanciato e dolce',
    coffee_grinder_step: 'Regolazione macinacaffè: Passo {step}',
    ebike_empty_title: 'Nessuna E-Bike associata',
    ebike_empty_desc: 'Aggiungi la tua bici elettrica per monitorare salute batteria, telemetria motore e usura catena.',
    ebike_btn_add: 'Aggiungi E-Bike',
    ski_empty_title: 'Nessuno sci alpino registrato',
    ski_empty_desc: 'Aggiungi i tuoi sci per calcolare lo sgancio ISO 11088 DIN e tracciare la sciolinatura.',
    ski_btn_add: 'Aggiungi sci',
    tour_step_prefix: 'Passaggio {current} di {total}',
    tour_btn_back: 'Indietro',
    tour_btn_skip: 'Salta tour',
    tour_btn_start: 'Inizia',
    tour_btn_next: 'Avanti',
    brand_appliance: 'Garanzia Elettrodomestici',
    brand_coffee: 'Compagno Caffè',
    brand_ebike: 'Servizio E-Bike',
    brand_skigear: 'Tracciamento Attrezzatura Sci',
    nav_home: 'Home',
    nav_appliances: 'Elettrodomestici',
    nav_add: 'Aggiungi',
    nav_warranties: 'Garanzie',
    nav_settings: 'Impostazioni',
    nav_today: 'Oggi',
    nav_recipes: 'Ricette',
    nav_machine: 'Macchina',
    nav_ride: 'Uscita',
    nav_bike: 'Bici',
    nav_parts: 'Componenti',
    nav_quiver: 'Sci',
    nav_setup: 'Setup',
    nav_tuning: 'Manutenzione',
    rooms_all: 'Tutti',
    rooms_kitchen: 'Cucina',
    rooms_living: 'Soggiorno',
    rooms_laundry: 'Lavanderia',
    rooms_bedroom: 'Camera da letto',
    rooms_bathroom: 'Bagno',
    rooms_office: 'Studio',
    rooms_dining: 'Sala da pranzo',
    rooms_hallway: 'Corridoio',
    rooms_garage: 'Garage',
    rooms_skilocker: 'Armadietto Sci',
    rooms_basement: 'Cantina',
    rooms_balcony: 'Balcone / Giardino',
    status_active: 'ATTIVO',
    status_expired: 'SCADUTO',
    status_expiring_soon: 'IN SCADENZA',
    stat_items: 'Dispositivi registrati',
    stat_protected: 'Garanzie attive',
    stat_expiring: 'In scadenza',
    stat_expired: 'Scaduto',
    attention_expired_one: '1 garanzia è scaduta',
    attention_all_ok: 'Tutti i {count} elettrodomestici sono coperti da garanzia',
    empty_appliance_title: 'Nessun elettrodomestico registrato',
    empty_appliance_desc: 'Aggiungi il tuo primo dispositivo per monitorare garanzie, fatture e manutenzione.',
    btn_add_appliance: 'Aggiungi elettrodomestico',
    expires_on: 'Scade il: {date}',
    add_purchase_date: 'Aggiungi data di acquisto',
    drawer_tab_specs: 'Specifiche tecniche',
    drawer_tab_maintenance: 'Cura & Manutenzione',
    drawer_tab_parts: 'Ricambi & Usura',
    drawer_tab_diagnostics: 'Diagnostica',
    drawer_purchase_date_label: 'Data di acquisto (Calcola la scadenza legale):',
    drawer_policy_label: 'Garanzia legale / produttore:',
    drawer_price_label: 'Prezzo d\'acquisto (Valore di rimpiazzo):',
    drawer_est_oem_cost: 'Costo OEM stimato:',
    drawer_btn_replace: 'Registra sostituzione',
    drawer_btn_delete: 'Elimina dal portafoglio',
    drawer_delete_confirm: 'Sei sicuro di voler eliminare "{name}"? Questa azione non può essere annullata.',
    wear_optimal: 'Condizione ottimale',
    wear_moderate: 'Usura moderata',
    wear_due_soon: 'Sostituzione consigliata a breve',
    wear_overdue: 'Sostituzione scaduta',
    freq_daily: 'Giornaliero',
    freq_weekly: 'Settimanale',
    freq_monthly: 'Mensile',
    freq_every_60: 'Ogni 60 giorni',
    freq_every_90: 'Ogni 90 giorni',
    freq_every_150km: 'Ogni 150 km',
    freq_every_4skidays: 'Ogni 4 giorni di sci',
    settings_header: 'Preferenze & Dati Regionali',
    settings_lang_label: 'Lingua / Language',
    settings_lang_sub: 'Traduzione nativa svizzera ed europea',
    settings_currency_label: 'Formato valuta',
    settings_currency_sub: 'Applicato a valori di beni, ricambi e prezzi di mercato',
    settings_statutory_label: 'Garanzia legale (CO 210)',
    settings_statutory_sub: 'Durata standard per elettrodomestici',
    settings_tour_label: 'Tour guidato introduttivo',
    settings_reset_demo: 'Reimposta dati dimostrativi',
    settings_notif_warranty: 'Promemoria scadenza garanzia',
    settings_notif_maintenance: 'Promemoria manutenzione e tagliandi',
    settings_timeline_btn: 'Visualizza cronologia avvisi programmati',
    toast_lang_changed: 'Lingua aggiornata a {name}!',
    greeting_morning: 'Buongiorno',
    greeting_afternoon: 'Buon pomeriggio',
    greeting_evening: 'Buonasera',
    home_title: 'La Tua Casa',
    my_appliances: 'I Miei Elettrodomestici',
    see_all: 'Vedi tutti →',
    add_appliance_cta_title: '+ Aggiungi elettrodomestico',
    add_appliance_cta_desc: 'Scansiona codice a barre, fotografa targhetta o cerca modello',
    all_appliances: 'Tutti gli Elettrodomestici',
    warranty_timeline: 'Cronologia Garanzie',
    stat_fully_covered: 'Pienamente coperto',
    stat_within_90_days: 'Entro 90 giorni',
    stat_action_required: 'Azione richiesta',
    drawer_active: 'Attivo',
    drawer_expired: 'Scaduto',
    drawer_step: 'Passo',
    drawer_wear: 'Usura',
    drawer_interval: 'Intervallo:',
    drawer_in_use: 'in uso',
    toast_purchase_date_updated: 'Data di acquisto aggiornata! Garanzia attiva fino al {date}',
    toast_purchase_date_cleared: 'Data di acquisto rimossa.',
    toast_warranty_policy_updated: 'Garanzia aggiornata a {months} mesi!',
    toast_purchase_price_updated: 'Prezzo d\'acquisto aggiornato!',
    toast_replacement_logged: 'Sostituzione registrata per {name}! Usura azzerata allo 0%.',
    toast_currency_changed: 'Valuta aggiornata a {label}',
    toast_statutory_changed: 'Standard legale impostato a {val} mesi',
    add_modal_title_appliance: 'Aggiungi Elettrodomestico',
    add_modal_title_coffee: 'Aggiungi Macchina da Caffè',
    add_modal_title_ebike: 'Aggiungi E-Bike',
    add_modal_title_skigear: 'Aggiungi Attrezzatura Sci',
    add_modal_scan_title: 'Scansiona Codice a Barre / QR',
    add_modal_scan_desc: 'EAN-13, UPC o codice imballaggio',
    add_modal_photo_title: 'Fotografa Targhetta',
    add_modal_photo_desc: 'Estrai specifiche e modello dalla targhetta identificativa',
    add_modal_manual_label: 'Oppure inserisci nome prodotto / codice modello:',
    add_modal_quick_test: 'Test rapido:',
    add_modal_identify_btn: 'Identifica',
    add_modal_camera_instruction: 'Inquadra il codice a barre o la targhetta nel reticolo',
    add_modal_test_fixtures: 'Codici a barre di test:',
    confirm_badge: 'PRODOTTO VERIFICATO',
    confirm_source_badge: 'Dati Ufficiali Produttore',
    confirm_add_btn: 'Salva nel portafoglio',
    confirm_searching: 'Ricerca nei database di prodotto…',
    confirm_verified_title: 'Prodotto Identificato',
    confirm_specs_header: 'SPECIFICHE DEL PRODUTTORE',
    confirm_policy_header: 'GARANZIA / POLITICA PRODUTTORE',
    confirm_market_header: 'VALORE DI MERCATO REGIONALE',
    confirm_ownership_header: 'I TUOI DATI DI ACQUISTO (OPZIONALE)',
    confirm_purchase_date: 'Data di acquisto:',
    confirm_purchase_price: 'Prezzo d\'acquisto ({currency}):',
    confirm_warranty_duration: 'Durata garanzia:',
    confirm_room_location: 'Stanza / Posizione:',
    confirm_save_btn: 'Salva nel portafoglio',
    confirm_cancel_btn: 'Annulla',
    confirm_warranty_months: '{val} Mesi',
    confirm_warranty_text: '{val} Mesi ({source})',
    confirm_standard_policy: 'Garanzia Legale Standard (CO 210)',
    confirm_market_unavailable: 'Prezzo di mercato non disponibile',
    confirm_years: 'Anni',
    confirm_months_short: 'Mesi',
    camera_title: 'Scanner Live Codici a Barre & Targhette',
    toast_offline: 'Sei offline. Le informazioni salvate rimangono accessibili.',
    toast_search_busy: 'Il servizio di ricerca è temporaneamente occupato.',
    toast_search_auth_error: 'Errore di configurazione del servizio di ricerca.',
    toast_search_timeout: 'Richiesta di ricerca scaduta. Controlla la connessione.',
    toast_search_unavailable: 'Servizio di ricerca temporaneamente non disponibile.',
    coffee_barista_deck: 'Postazione Barista',
    coffee_todays_extraction: "Estrazione del Giorno",
    coffee_no_machine_paired: 'Nessuna Macchina Connessa',
    coffee_add_machine_title: '+ Connetti la Tua Macchina',
    coffee_add_machine_desc: 'Collega la macchina per durezza acqua, decalcificazione e memoria dial-in.',
    coffee_easy_mode_badge: 'MODALITÀ FACILE · DAL CHICCO ALLA TAZZINA',
    coffee_15bar_pump: 'Termoblocco 15-Bar',
    coffee_select_beverage: 'SELEZIONA BEVANDA',
    coffee_aroma_strength: 'INTENSITÀ AROMA',
    coffee_strength_level: 'Livello {n} di 5',
    coffee_repeat_brew_label: '1-Tocco Ripeti Ultima Estrazione',
    coffee_active_recipe_badge: 'RICETTA TARGET ATTIVA',
    coffee_metric_dose_in: 'DOSE INGRESSO',
    coffee_metric_yield_out: 'RESA IN TAZZA',
    coffee_metric_target_time: 'TEMPO TARGET',
    coffee_metric_grinder_step: 'GRADO MACINATURA',
    coffee_active_bean_title: 'Chicco Attivo nella Campana',
    coffee_bean_cellar_link: 'Cantina Chicchi ({count}) →',
    coffee_bag_inventory: 'SCORTA SACCHETTO',
    coffee_roaster_notes: 'Note Torrefazione:',
    coffee_water_care_title: 'Chimica dell\'Acqua & Manutenzione',
    coffee_equipment_care_link: 'Cura Macchina →',
    coffee_water_source_label: 'FONTE IDRICA COMUNALE',
    coffee_scale_risk_label: 'RISCHIO CALCARE',
    coffee_local_hardness: 'Durezza Locale',
    coffee_next_descale: 'Prossima Decalcificazione',
    coffee_descale_in_days: 'Tra {days} giorni',
    coffee_filter_life: 'Filtro: {percent}%',
    coffee_filtration_label: 'Filtrazione:',
    coffee_dial_in_memory_title: 'Memoria Dial-In',
    coffee_attempt_number: 'Tentativo #{n}',
    coffee_grind_label: 'Macinatura',
    coffee_total_shots: 'Totale Erogazioni:',
    coffee_my_grinder_fleet: 'I MIEI MACINADOSATORI',
    coffee_oem_maintenance: 'Protocollo di Manutenzione OEM',
    coffee_descale_cycle_title: 'Ciclo Decalcificazione Termoblocco',
    coffee_descale_cycle_detail: 'In scadenza tra {days} giorni · Decalcificante liquido bio',
    coffee_btn_log_done: 'Registra come fatto',
    coffee_filter_cartridge_title: 'Cartuccia Filtro Addolcitore',
    coffee_filter_lifespan_detail: '{percent}% di vita residua',
    coffee_btn_replaced: 'Sostituito',
    coffee_freshness_unknown: 'Freschezza sconosciuta',
    coffee_roast_date_not_specified: 'Data tostatura non specificata',
    coffee_freshness_degas: 'Degasamento ({days}g post-tostatura)',
    coffee_freshness_peak: 'Finestra Ottimale ★ ({days}g)',
    coffee_freshness_mature: 'Maturo ({days}g)',
    coffee_freshness_past_peak: 'Oltre il picco ({days}g)',
    toast_water_source_changed: 'Fonte idrica impostata su {city} ({dh} °dH)',
    toast_brew_logged: '{drink} erogato e salvato nella Memoria Caffè!',
    toast_brew_loaded: 'Caricata ricetta precedente: {bean} ({dose}g → {yield}g)',
    brew_timer_target_info: 'Target: {time} per {yield} ({ratio})',
    brew_btn_resume: 'Riprendi',
    brew_btn_pause_evaluate: 'Pausa & Valutazione',
    brew_btn_start: 'Avvia Timer',
    coffee_under_extracted: 'Sotto-estratto (Troppo acido):',
    coffee_under_extracted_advice: 'Macina 1 step più fine o aumenta la temperatura di 1°C.',
    coffee_over_extracted: 'Sovra-estratto (Troppo amaro):',
    coffee_over_extracted_advice: 'Macina 1 step più grosso o ferma l\'erogazione 2 secondi prima.',
    coffee_optimal_extraction: 'Estrazione Ottimale!',
    coffee_optimal_extraction_desc: 'Dolcezza e acidità perfettamente bilanciate. Salvato.',
    toast_brew_saved: 'Estrazione salvata nella Memoria Caffè Personale!',
    coffee_bean_remaining: 'Rimanente:',
    coffee_bean_roast_date: 'Data Tostatura:',
    coffee_bean_finished: 'Terminato',
    coffee_bean_mark_finished: 'Segna come terminato',
    toast_bean_name_required: 'Inserisci il nome del caffè',
    toast_bean_added: '{name} aggiunto alla Cantina Chicchi!',
    toast_scanning_bean_bag: 'Lettura etichetta sacchetto…',
    toast_bean_bag_scanned: 'Sacchetto riconosciuto! Torrefazione, origine e data estratte.',
    toast_bean_finished: '{name} contrassegnato come terminato.',
    toast_coffee_maintenance_logged: 'Manutenzione {task} registrata! Timer azzerati.',
    coffee_recipe_label: 'RICETTA:',
    coffee_metric_dose: 'DOSE',
    coffee_metric_yield: 'RESA',
    coffee_metric_time: 'TEMPO',
    coffee_metric_temp: 'TEMPERATURA',
    coffee_bean_origin_label: 'Origine del Chicco:',
    coffee_tasting_notes_label: 'Note di Degustazione:',
    coffee_extraction_steps: 'PASSAGGI DI ESTRAZIONE:',
    coffee_step_1_dose: 'Dosa il caffè fresco nel portafiltro.',
    coffee_step_2_tamp: 'Pressa in modo uniforme e piano.',
    coffee_step_3_extract: 'Estrai fino a raggiungere la resa target.',
    toast_recipe_loaded: 'Caricato: {name}',
    coffee_advisor_loading: 'Consultazione IA Barista per parametri di estrazione…',
    coffee_grind_advisor_title: 'CONSIGLIERE DIAL-IN BARISTA',
    coffee_advisor_grind: 'MACINATURA',
    coffee_advisor_dose: 'DOSE',
    coffee_advisor_yield: 'RESA',
    coffee_advisor_temp: 'TEMPERATURA',
    coffee_sensory_profile: 'Profilo Sensoriale:',
    coffee_advisor_calculated_for: 'Calcolato per tostatura {roast} con durezza {hardness}.',
    coffee_recipes_title: 'Ricette & Laboratorio di Estrazione',
    coffee_bean_cellar: 'Cantina Chicchi ({count})',
    coffee_filter_all: 'Tutti i Metodi',
    coffee_filter_espresso: 'Espresso',
    coffee_filter_pour_over: 'Pour-Over (V60)',
    coffee_filter_aeropress: 'Aeropress',
    coffee_filter_cold_brew: 'Cold Brew',
    coffee_filter_cafe_creme: 'Caffè Crema',
    coffee_advisor_section_title: 'IA BARISTA CONSULENTE DIAL-IN',
    coffee_advisor_badge: 'Standard Specialty Coffee',
    coffee_advisor_desc: 'Calcola grado di macinatura, rapporto di estrazione, temperatura e tempi di flusso.',
    coffee_brew_method_label: 'METODO DI ESTRAZIONE',
    coffee_roast_level_label: 'LIVELLO DI TOSTATURA',
    coffee_bean_origin_placeholder: 'es. Etiopia Yirgacheffe, Colombia Huila, Kenya AA…',
    coffee_quick_pick: 'Scelta rapida:',
    coffee_water_hardness_label: 'DUREZZA ACQUA LOCALE',
    coffee_calculate_btn: 'Calcola Dial-In & Macinatura',
    coffee_brew_library_title: 'Libreria Specialty Coffee',
    coffee_machine_maintenance_title: 'Manutenzione Macchina & Strumenti',
    ebike_garage_fleet: 'Flotta Garage',
    ebike_stat_battery: 'SALUTE BATTERIA',
    ebike_stat_odometer: 'CHILOMETRAGGIO TOTALE',
    ebike_next_service: 'Prossimo tagliando: {km} km',
    ebike_component_wear_title: 'Usura Componenti & Telemetria',
    ebike_all_parts_link: 'Tutti i componenti →',
    ebike_chain_gauge: 'CALIBRO ALLUNGAMENTO CATENA',
    ebike_chain_optimal: '{pct}% (Ottimale)',
    ebike_chain_hint: 'Sostituire la catena a 0.75% (SRAM Eagle 12 velocità)',
    ebike_suspension_gauge: 'PRESSIONE FORCELLA AD ARIA',
    ebike_suspension_hint: 'Calibrato per 78 kg di peso su forcella Fox 38 Float 160mm',
    ebike_maintenance_history: 'Storico Manutenzione Recente',
    ebike_chain_lubrication: 'Lubrificazione Ceramica Catena',
    ebike_applied_next_due: 'Applicato a {applied} km · Prossimo a {due} km',
    ebike_bike_specs_title: 'Specifiche Bicicletta',
    ebike_consumables_title: 'Parti di Consumo & Usura',
    ebike_motor_error_decoder: 'DECODER CODICI ERRORE MOTORE',
    ebike_motor_diag_desc: 'Inserisci un codice errore Bosch, Shimano EP8 o Bafang per una diagnosi IA.',
    ebike_motor_diag_placeholder: 'Codice errore (es. 503, 540, 0x04)',
    ebike_btn_decode_error: 'Analizza Errore con IA',
    ebike_frame_serial: 'N° Telaio: •••• 9912',
    toast_ride_recorded: 'Uscita di {km} km registrata! Contachilometri aggiornato.',
    ebike_diag_empty_toast: 'Inserisci un codice errore motore (es. 503, 540)',
    ebike_diag_decoding: 'Analisi codice {code} con Gemini…',
    ebike_diag_fallback_title: 'Avviso Sistema Motore',
    ebike_diag_cause_label: 'Causa:',
    ebike_diag_fallback_cause: 'Sensore di velocità o magnete raggio disallineato.',
    ebike_diag_action_label: 'Azione:',
    ebike_diag_fallback_action: 'Verificare la posizione del magnete del raggio rispetto al sensore.',
    ski_alpine_quiver: 'Attrezzatura Sci Alpino',
    ski_metric_din: 'VALORE DIN ISO 11088',
    ski_metric_bsl: '{bsl}mm Suola · Sciatore {weight}kg',
    ski_base_wax: 'SCIOLINA DI BASE',
    ski_snow_range: '{low}°C a {high}°C Neve Fredda',
    ski_btn_recalc_din: 'Ricalcola DIN Attacco (ISO 11088)',
    ski_section_readiness: 'Preparazione Stagione & Tagliando',
    ski_btn_tuning_log: 'Registro manutenzione →',
    ski_readiness_ski_days: 'Giorni di sci questa stagione',
    ski_readiness_ski_days_val: '{n} Giorni su Neve',
    ski_readiness_edge: 'Angolo Lamina Laterale',
    ski_readiness_edge_val: '{angle}° Finitura Diamante ({days} giorni fa)',
    ski_readiness_trip: 'Prossima Uscita in Montagna',
    ski_readiness_trip_val: '{place} (tra {days} giorni)',
    ski_checklist_title: 'Checklist Montagna',
    ski_safety_notice: 'Requisito di Sicurezza Obbligatorio:',
    ski_safety_notice_desc: 'I calcoli DIN ISO 11088 sono stime informative. I valori di sgancio degli attacchi devono essere tarati fisicamente su un banco prova calibrato da un tecnico specializzato.',
    ski_base_wax_applied: 'Sciolina di Base Applicata',
    ski_days_on_snow: 'Giorni su Neve',
    ski_days_unit: 'Giorni',
    ski_wax_advisor_section: 'CONSULENTE SCIOLINATURA IA',
    ski_snow_temp_placeholder: 'Temperatura Neve °C (es. -12)',
    ski_snow_type_packed: 'Neve Battuta / Pista',
    ski_snow_type_fresh: 'Neve Fresca / Polverosa',
    ski_snow_type_icy: 'Pista Ghiacciata / Dura',
    ski_snow_type_wet: 'Neve Bagnata Primaverile',
    ski_btn_get_ai_wax: 'Ottieni Consiglio Sciolina IA',
    toast_din_applied: 'Valore DIN {value} applicato a {binding}!',
    ski_wax_calculating: 'Calcolo sciolina ideale per {temp}°C…',
    ski_wax_result_wax: 'SCIOLINA CONSIGLIATA',
    ski_wax_result_iron: 'TEMPERATURA SCIOLINATORE',
    ski_wax_fallback: 'Sciolina fluor-free Toko LF Blue consigliata per {temp}°C su neve battuta.',
    ski_setup_title: 'Configurazione Attacco & Scarpone',
    ski_tuning_title: 'Storico Lamine & Sciolinatura',
    ski_domain_subtitle: 'Attrezzatura, Sgancio DIN & Sciolina'
  }
};

// ==================== HELPER FUNCTIONS ====================

let inMemoryLang = 'en';

export function getLanguage() {
  if (typeof localStorage !== 'undefined') {
    const saved = localStorage.getItem('nordic_lang');
    if (saved && SUPPORTED_LANGUAGES[saved]) return saved;
  }
  
  if (inMemoryLang && SUPPORTED_LANGUAGES[inMemoryLang]) {
    return inMemoryLang;
  }
  
  if (typeof navigator !== 'undefined') {
    const rawLangs = [navigator.language, ...(navigator.languages || [])].filter(Boolean);
    for (const raw of rawLangs) {
      const code2 = raw.slice(0, 2).toLowerCase();
      if (code2 === 'nb' || code2 === 'nn') return 'no';
      if (SUPPORTED_LANGUAGES[code2]) return code2;
    }
  }
  
  return 'en';
}

export function detectInitialLocaleAndCurrency() {
  if (typeof localStorage !== 'undefined') {
    const savedLang = localStorage.getItem('nordic_lang');
    if (savedLang && SUPPORTED_LANGUAGES[savedLang]) return;
  }
  
  let detectedCode = 'en';
  if (typeof navigator !== 'undefined') {
    const rawLangs = [navigator.language, ...(navigator.languages || [])].filter(Boolean);
    for (const raw of rawLangs) {
      const code2 = raw.slice(0, 2).toLowerCase();
      if (code2 === 'nb' || code2 === 'nn') {
        detectedCode = 'no';
        break;
      }
      if (SUPPORTED_LANGUAGES[code2]) {
        detectedCode = code2;
        break;
      }
    }
  }

  const langObj = SUPPORTED_LANGUAGES[detectedCode] || SUPPORTED_LANGUAGES.en;
  inMemoryLang = detectedCode;
  if (typeof localStorage !== 'undefined') {
    localStorage.setItem('nordic_lang', detectedCode);
    if (!localStorage.getItem('nordic_currency_custom')) {
      localStorage.setItem('nordic_currency', langObj.defaultCurrency || 'USD');
    }
  }
}

export function setLanguage(langCode) {
  if (SUPPORTED_LANGUAGES[langCode]) {
    inMemoryLang = langCode;
    if (typeof localStorage !== 'undefined') {
      localStorage.setItem('nordic_lang', langCode);
    }
    const langObj = SUPPORTED_LANGUAGES[langCode];
    
    const hasCustomCurr = typeof localStorage !== 'undefined' && localStorage.getItem('nordic_currency_custom') === 'true';
    if (!hasCustomCurr && langObj.defaultCurrency && typeof window !== 'undefined' && window.setCurrency) {
      window.setCurrency(langObj.defaultCurrency);
    }
    
    if (typeof window !== 'undefined') {
      if (window.updateStaticDomTranslations) window.updateStaticDomTranslations();
      if (window.renderActiveDomain) window.renderActiveDomain();
      if (window.selectedAsset && window.openDetailDrawer) {
        window.openDetailDrawer(window.selectedAsset.id, window.currentDomain);
      }
      if (window.updateSettingsUI) window.updateSettingsUI();
      if (window.showToast) window.showToast(t('toast_lang_changed', { name: langObj.name }));
    }
  }
}

export function t(key, params = {}) {
  if (!key) return '';
  let normalizedKey = key;
  if (normalizedKey === 'add_placeholder_applicance') normalizedKey = 'add_placeholder_appliance';

  const currentLang = getLanguage();
  const langAlias = currentLang === 'nb' ? 'no' : currentLang;
  const dict = I18N_DICTIONARY[langAlias] || I18N_DICTIONARY.en || {};
  let str = dict[normalizedKey] !== undefined ? dict[normalizedKey] : ((I18N_DICTIONARY.en && I18N_DICTIONARY.en[normalizedKey]) !== undefined ? I18N_DICTIONARY.en[normalizedKey] : normalizedKey);
  
  if (typeof str === 'string' && params && typeof params === 'object') {
    Object.entries(params).forEach(([k, v]) => {
      str = str.replace(new RegExp(`\\{${k}\\}`, 'g'), v !== undefined && v !== null ? v : '');
    });
  }
  
  return str;
}

export const ROOM_KEYS = [
  { value: 'Living Room', key: 'rooms_living' },
  { value: 'Kitchen', key: 'rooms_kitchen' },
  { value: 'Laundry Room', key: 'rooms_laundry' },
  { value: 'Bedroom', key: 'rooms_bedroom' },
  { value: 'Bathroom', key: 'rooms_bathroom' },
  { value: 'Home Office', key: 'rooms_office' },
  { value: 'Dining Room', key: 'rooms_dining' },
  { value: 'Hallway Closet', key: 'rooms_hallway' },
  { value: 'Garage', key: 'rooms_garage' },
  { value: 'Basement', key: 'rooms_basement' },
  { value: 'Balcony / Garden', key: 'rooms_balcony' },
  { value: 'Ski Locker', key: 'rooms_skilocker' }
];

export function translateRoom(roomName) {
  if (!roomName) return t('rooms_kitchen');
  const lower = roomName.toLowerCase();
  if (lower.includes('all') || lower === 'alle' || lower === 'tous' || lower === 'tümü' || lower === 'tutti' || lower === 'alla') return t('rooms_all');
  if (lower.includes('living') || lower.includes('wohn') || lower.includes('salon') || lower.includes('soggiorno') || lower.includes('stue') || lower.includes('vardagsrum') || lower.includes('oturma')) return t('rooms_living');
  if (lower.includes('kitchen') || lower.includes('küche') || lower.includes('cuisine') || lower.includes('cucina') || lower.includes('køkken') || lower.includes('kök') || lower.includes('kjøkken') || lower.includes('mutfak')) return t('rooms_kitchen');
  if (lower.includes('laundry') || lower.includes('wasch') || lower.includes('buanderie') || lower.includes('lavanderia') || lower.includes('bryggers') || lower.includes('tvätt') || lower.includes('vaskerom') || lower.includes('çamaşır')) return t('rooms_laundry');
  if (lower.includes('bedroom') || lower.includes('schlaf') || lower.includes('chambre') || lower.includes('camera') || lower.includes('sove') || lower.includes('sov') || lower.includes('yatak')) return t('rooms_bedroom');
  if (lower.includes('bath') || lower.includes('bad') || lower.includes('bagno') || lower.includes('banyo')) return t('rooms_bathroom');
  if (lower.includes('office') || lower.includes('büro') || lower.includes('arbeits') || lower.includes('bureau') || lower.includes('studio') || lower.includes('kontor') || lower.includes('çalışma')) return t('rooms_office');
  if (lower.includes('dining') || lower.includes('esszimmer') || lower.includes('manger') || lower.includes('pranzo') || lower.includes('spisestue') || lower.includes('matsal') || lower.includes('yemek')) return t('rooms_dining');
  if (lower.includes('hallway') || lower.includes('flur') || lower.includes('couloir') || lower.includes('corridoio') || lower.includes('gang') || lower.includes('hall') || lower.includes('antre') || lower.includes('koridor') || lower.includes('garderob')) return t('rooms_hallway');
  if (lower.includes('garage') || lower.includes('garasje') || lower.includes('garaj') || lower.includes('box')) return t('rooms_garage');
  if (lower.includes('basement') || lower.includes('keller') || lower.includes('sous') || lower.includes('cantina') || lower.includes('kælder') || lower.includes('källare') || lower.includes('kjeller') || lower.includes('bodrum') || lower.includes('kiler') || lower.includes('cave')) return t('rooms_basement');
  if (lower.includes('balcony') || lower.includes('balkon') || lower.includes('balcon') || lower.includes('balcone') || lower.includes('altan') || lower.includes('garden') || lower.includes('garten') || lower.includes('jardin') || lower.includes('giardino') || lower.includes('have') || lower.includes('trädgård') || lower.includes('bahçe') || lower.includes('hage')) return t('rooms_balcony');
  if (lower.includes('ski') || lower.includes('kayak') || lower.includes('quiver') || lower.includes('skirum') || lower.includes('skibod') || lower.includes('skidförråd')) return t('rooms_skilocker');
  return roomName;
}

export function getGreetingKey() {
  const hour = new Date().getHours();
  if (hour < 12) return 'greeting_morning';
  if (hour < 18) return 'greeting_afternoon';
  return 'greeting_evening';
}

export function translateFrequency(freq) {
  if (!freq) return freq;
  const currentLang = getLanguage();
  const langAlias = currentLang === 'nb' ? 'no' : currentLang;
  const lower = freq.toLowerCase();

  if (lower.includes('semi-annual') || lower.includes('halbjährlich') || lower.includes('semestriel') || lower.includes('semestrale') || lower.includes('halvårlig') || lower.includes('halvårsvis') || lower.includes('6 ay')) {
    if (langAlias === 'tr') return '6 Aylık / Yılda 2 Kez';
    if (langAlias === 'de') return 'Halbjährlich';
    if (langAlias === 'fr') return 'Semestriel';
    if (langAlias === 'it') return 'Semestrale';
    if (langAlias === 'da') return 'Halvårligt';
    if (langAlias === 'sv') return 'Halvårsvis';
    if (langAlias === 'no') return 'Halvårlig';
    return 'Semi-Annual';
  }

  if (lower.includes('quarterly') || lower.includes('vierteljährlich') || lower.includes('trimestriel') || lower.includes('trimestrale') || lower.includes('kvartalsvis') || lower.includes('3 ay') || lower.includes('çeyrek')) {
    if (langAlias === 'tr') return '3 Aylık / Çeyreklik';
    if (langAlias === 'de') return 'Vierteljährlich';
    if (langAlias === 'fr') return 'Trimestriel';
    if (langAlias === 'it') return 'Trimestrale';
    if (langAlias === 'da') return 'Kvartalsvis';
    if (langAlias === 'sv') return 'Kvartalsvis';
    if (langAlias === 'no') return 'Kvartalsvis';
    return 'Quarterly';
  }

  if (lower.includes('bi-weekly') || lower.includes('alle 2 wochen') || lower.includes('toutes les 2 semaines') || lower.includes('ogni 2 settimane') || lower.includes('hver 2. uge') || lower.includes('varannan vecka') || lower.includes('2 hafta')) {
    if (langAlias === 'tr') return '2 Haftada Bir';
    if (langAlias === 'de') return 'Alle 2 Wochen';
    if (langAlias === 'fr') return 'Toutes les 2 semaines';
    if (langAlias === 'it') return 'Ogni 2 settimane';
    if (langAlias === 'da') return 'Hver 2. uge';
    if (langAlias === 'sv') return 'Varannan vecka';
    if (langAlias === 'no') return 'Hver 2. uke';
    return 'Bi-Weekly';
  }

  if (lower.includes('daily') || lower.includes('täglich') || lower.includes('daglig') || lower.includes('dagligt') || lower.includes('quotidien') || lower.includes('giornaliero') || lower.includes('günlük')) {
    if (lower.includes('milk') || lower.includes('milch') || lower.includes('lait') || lower.includes('latte') || lower.includes('süt')) {
      if (langAlias === 'tr') return 'Günlük / Süt Sonrası';
      if (langAlias === 'de') return 'Täglich / Nach Milchnutzung';
      if (langAlias === 'fr') return 'Quotidien / Après utilisation du lait';
      if (langAlias === 'it') return 'Giornaliero / Dopo uso latte';
      if (langAlias === 'da') return 'Dagligt / Efter mælkebrug';
      if (langAlias === 'sv') return 'Dagligen / Efter mjölkanvändning';
      if (langAlias === 'no') return 'Daglig / Etter melkebruk';
      return 'Daily / After Milk';
    }
    return t('freq_daily');
  }

  if (lower.includes('weekly') || lower.includes('wöchentlich') || lower.includes('ugentlig') || lower.includes('ukentlig') || lower.includes('varje vecka') || lower.includes('hebdomadaire') || lower.includes('settimanale') || lower.includes('haftalık')) {
    return t('freq_weekly');
  }

  if (lower.includes('monthly') || lower.includes('monatlich') || lower.includes('månedlig') || lower.includes('varje månad') || lower.includes('mensuel') || lower.includes('mensile') || lower.includes('aylık')) {
    if (lower.includes('automatic') || lower.includes('automatisch') || lower.includes('automatique') || lower.includes('otomatik')) {
      if (langAlias === 'tr') return 'Otomatik / Aylık';
      if (langAlias === 'de') return 'Automatisch / Monatlich';
      if (langAlias === 'fr') return 'Automatique / Mensuel';
      if (langAlias === 'it') return 'Automatico / Mensile';
      if (langAlias === 'da') return 'Automatisk / Månedligt';
      if (langAlias === 'sv') return 'Automatiskt / Månadsvis';
      if (langAlias === 'no') return 'Automatisk / Månedlig';
      return 'Automatic / Monthly';
    }
    return t('freq_monthly');
  }

  if (lower.includes('3-5') || lower.includes('runs') || lower.includes('durchläufe') || lower.includes('cycles') || lower.includes('çalıştırma')) {
    if (langAlias === 'tr') return 'Her 3-5 Çalıştırmada';
    if (langAlias === 'de') return 'Alle 3-5 Durchläufe';
    if (langAlias === 'fr') return 'Tous les 3 à 5 cycles';
    if (langAlias === 'it') return 'Ogni 3-5 cicli';
    if (langAlias === 'da') return 'Hver 3.-5. kørsel';
    if (langAlias === 'sv') return 'Var 3-5:e körning';
    if (langAlias === 'no') return 'Hver 3.-5. kjøring';
    return 'Every 3-5 Runs';
  }

  const daysMatch = freq.trim().match(/^(\d+)\s*(?:days?|tage?|jours?|giorni|dage?|dagar|dager|gün|d)$/i);
  if (daysMatch) {
    const num = daysMatch[1];
    if (langAlias === 'tr') return `${num} Gün`;
    if (langAlias === 'de') return `${num} Tage`;
    if (langAlias === 'fr') return `${num} jours`;
    if (langAlias === 'it') return `${num} giorni`;
    if (langAlias === 'da') return `${num} dage`;
    if (langAlias === 'sv') return `${num} dagar`;
    if (langAlias === 'no') return `${num} dager`;
    return `${num} Days`;
  }

  if (lower.includes('60')) return t('freq_every_60');
  if (lower.includes('90')) return t('freq_every_90');
  if (lower.includes('150')) return t('freq_every_150km');
  if (lower.includes('ski') || lower.includes('skitag') || lower.includes('kayak')) return t('freq_every_4skidays');
  
  if (lower.includes('end of season') || lower.includes('saisonende') || lower.includes('fin de saison') || lower.includes('fine stagione') || lower.includes('sezon sonu')) {
    if (langAlias === 'tr') return 'Sezon Sonu';
    if (langAlias === 'de') return 'Saisonende';
    if (langAlias === 'fr') return 'Fin de saison';
    if (langAlias === 'it') return 'Fine stagione';
    if (langAlias === 'da') return 'Sæsonslut';
    if (langAlias === 'sv') return 'Säsongsslut';
    if (langAlias === 'no') return 'Sesongslutt';
    return 'End of Season';
  }

  if (lower.includes('seasonal') || lower.includes('saisonal') || lower.includes('saisonnier') || lower.includes('stagionale') || lower.includes('sezonluk')) {
    if (langAlias === 'tr') return 'Sezonluk';
    if (langAlias === 'de') return 'Saisonal';
    if (langAlias === 'fr') return 'Saisonnier';
    if (langAlias === 'it') return 'Stagionale';
    if (langAlias === 'da') return 'Sæsonmæssigt';
    if (langAlias === 'sv') return 'Säsongsvis';
    if (langAlias === 'no') return 'Sesongbasert';
    return 'Seasonal';
  }

  return freq;
}

export function translatePartStatus(wearPercent) {
  if (wearPercent < 35) return t('wear_optimal');
  if (wearPercent < 75) return t('wear_moderate');
  if (wearPercent < 100) return t('wear_due_soon');
  return t('wear_overdue');
}

export const JURISDICTIONS = [
  { code: 'CH', nameKey: 'jurisdiction_ch', label: 'Switzerland (CH - OR Art. 210)' },
  { code: 'DK', nameKey: 'jurisdiction_dk', label: 'Denmark (DK - 2 års reklamationsret)' },
  { code: 'AT', nameKey: 'jurisdiction_at', label: 'Austria (AT - Gewährleistung VGG)' },
  { code: 'NO', nameKey: 'jurisdiction_no', label: 'Norway (NO - 5/2 års reklamasjonsrett)' },
  { code: 'SE', nameKey: 'jurisdiction_se', label: 'Sweden (SE - 3 års reklamationsrätt)' },
  { code: 'EU', nameKey: 'jurisdiction_eu', label: 'EU / Other (Review Required)' },
  { code: 'UNKNOWN', nameKey: 'jurisdiction_unknown', label: 'Unknown / Not Specified' }
];

export function populateJurisdictionOptions(selectEl, selectedCode = 'CH') {
  if (!selectEl) return;
  const currentSelected = selectedCode || selectEl.value || 'CH';
  selectEl.innerHTML = '';
  JURISDICTIONS.forEach(j => {
    const opt = document.createElement('option');
    opt.value = j.code;
    opt.textContent = t(j.nameKey) || j.label;
    if (j.code === currentSelected || (currentSelected && j.code.toLowerCase() === currentSelected.toLowerCase())) {
      opt.selected = true;
    }
    selectEl.appendChild(opt);
  });
  if (!Array.from(selectEl.options).some(o => o.selected)) {
    if (selectEl.options.length > 0) selectEl.options[0].selected = true;
  }
}

export function populateWarrantyDurationOptions(selectEl, selectedMonths = 24) {
  if (!selectEl) return;
  const lang = getLanguage();
  const durations = [
    { months: 0, labelEn: 'None / Not Recorded (Voluntary)', labelDe: 'Keine / Nicht erfasst', labelDa: 'Ingen / Ikke registreret', labelSv: 'Ingen / Ej registrerad', labelNo: 'Ingen / Ikke registrert', labelFr: 'Aucune / Non renseignée', labelIt: 'Nessuna / Non registrata', labelTr: 'Yok / Kaydedilmemiş' },
    { months: 12, labelEn: '12 Months (1 Year Policy)', labelDe: '12 Monate (1 Jahr Garantie)', labelDa: '12 Måneder (1 års fabriksgaranti)', labelSv: '12 Månader (1 års garanti)', labelNo: '12 Måneder (1 års garanti)', labelFr: '12 Mois (1 An Garantie)', labelIt: '12 Mesi (1 Anno Garanzia)', labelTr: '12 Ay (1 Yıl Garanti)' },
    { months: 24, labelEn: '24 Months (2 Years Policy)', labelDe: '24 Monate (2 Jahre Herstellergarantie)', labelDa: '24 Måneder (2 års fabriksgaranti)', labelSv: '24 Månader (2 års fabriksgaranti)', labelNo: '24 Måneder (2 års fabrikkgaranti)', labelFr: '24 Mois (2 Ans Garantie Fabricant)', labelIt: '24 Mesi (2 Anni Garanzia Produttore)', labelTr: '24 Ay (2 Yıl Üretici Garantisi)' },
    { months: 25, labelEn: '25 Months (Jura CH Policy)', labelDe: '25 Monate (Jura CH Garantie)', labelDa: '25 Måneder (Jura garanti)', labelSv: '25 Månader (Jura garanti)', labelNo: '25 Måneder (Jura garanti)', labelFr: '25 Mois (Garantie Jura CH)', labelIt: '25 Mesi (Garanzia Jura CH)', labelTr: '25 Ay (Jura Özel Garantisi)' },
    { months: 36, labelEn: '36 Months (3 Years Policy)', labelDe: '36 Monate (3 Jahre Herstellergarantie)', labelDa: '36 Måneder (3 års garanti)', labelSv: '36 Månader (3 års garanti)', labelNo: '36 Måneder (3 års garanti)', labelFr: '36 Mois (3 Ans Garantie)', labelIt: '36 Mesi (3 Anni Garanzia)', labelTr: '36 Ay (3 Yıl Garanti)' },
    { months: 60, labelEn: '60 Months (5 Years Policy)', labelDe: '60 Monate (5 Jahre Langzeitgarantie)', labelDa: '60 Måneder (5 års langtid)', labelSv: '60 Månader (5 års långtid)', labelNo: '60 Måneder (5 års langtid)', labelFr: '60 Mois (5 Ans Garantie Longue)', labelIt: '60 Mesi (5 Anni Lungo Termine)', labelTr: '60 Ay (5 Yıl Uzun Vadeli)' },
    { months: 120, labelEn: '120 Months (10 Years Motor/Inverter)', labelDe: '120 Monate (10 Jahre Motor/Inverter)', labelDa: '120 Måneder (10 års motor)', labelSv: '120 Månader (10 års motor)', labelNo: '120 Måneder (10 års motor)', labelFr: '120 Mois (10 Ans Moteur)', labelIt: '120 Mesi (10 Anni Motore)', labelTr: '120 Ay (10 Yıl Motor / Kompresör)' }
  ];

  const langKey = 'label' + lang.charAt(0).toUpperCase() + lang.slice(1);
  const curVal = selectedMonths ? parseInt(selectedMonths, 10) : 24;

  let hasMatch = durations.some(d => d.months === curVal);
  let optionsHtml = durations.map(d => {
    const text = d[langKey] || d.labelEn;
    return `<option value="${d.months}" ${d.months === curVal ? 'selected' : ''}>${text}</option>`;
  }).join('');

  if (!hasMatch) {
    optionsHtml += `<option value="${curVal}" selected>${curVal} ${t('confirm_months_short')} (${(curVal/12).toFixed(1)} ${t('confirm_years')})</option>`;
  }

  selectEl.innerHTML = optionsHtml;
}

// Localized App Tour Definitions for all 4 standalone apps
export function getAppTourDefinitions(lang, domain = 'appliance') {
  const isTr = lang === 'tr';
  const isDa = lang === 'da';
  const isSv = lang === 'sv';
  const isNo = lang === 'no';
  const isDe = lang === 'de';
  const isFr = lang === 'fr';
  const isIt = lang === 'it';

  const tours = {
    appliance: {
      appTitle: t('brand_appliance'),
      welcomeToast: isTr ? "Cihaz Garanti Takibi'ne hoş geldiniz!" : isDa ? "Velkommen til Hvidevarer Garanti!" : isDe ? "Willkommen bei Geräte Garantie!" : "Welcome to Appliance Warranty!",
      steps: [
        {
          heroGradient: 'linear-gradient(135deg, rgba(56,189,248,0.3), rgba(99,102,241,0.15))',
          heroIcon: 'fa-shield-halved',
          heroColor: '#38bdf8',
          title: isTr ? 'Garanti & Fatura Mahzeni' : isDa ? 'Din Garantiboks' : isDe ? 'Ihr Garantie-Tresor' : 'Your Warranty Vault',
          subtitle: isTr ? 'Her ev cihazınız yasal garanti güvencesi altında.' : isDa ? 'Alle hvidevarer beskyttet under købeloven.' : isDe ? 'Jedes Haushaltsgerät gesetzlich geschützt.' : 'Every appliance protected under statutory law.',
          mockUIHtml: `
            <div class="tour-mock-ui">
              <div class="mock-row">
                <div style="display:flex;align-items:center;gap:8px;">
                  <span class="mock-led mock-led-green"></span>
                  <span class="mock-value">Miele W1 TwinDos / Siemens iQ500</span>
                </div>
                <span class="mock-badge mock-badge-success">${t('status_active')}</span>
              </div>
              <div class="mock-row">
                <span class="mock-label">${t('confirm_policy_header')}</span>
                <span class="mock-value" style="color:#38bdf8;">24 ${t('confirm_months_short')}</span>
              </div>
              <div class="mock-progress-track">
                <div class="mock-progress-fill" style="width:82%;background:linear-gradient(90deg,#38bdf8,#818cf8);"></div>
              </div>
            </div>`
        },
        {
          heroGradient: 'linear-gradient(135deg, rgba(99,102,241,0.25), rgba(56,189,248,0.15))',
          heroIcon: 'fa-barcode',
          heroColor: '#818cf8',
          title: isTr ? 'Yapay Zeka Ürün Tanımlama' : isDa ? 'AI Produktgenkendelse' : isDe ? 'KI-Produkterkennung' : 'AI Product Identification',
          subtitle: isTr ? 'Arayın veya barkod tarayın — anında teknik özellikler ve kılavuz.' : isDa ? 'Søg eller scan — øjeblikkelige specifikationer.' : isDe ? 'Suchen oder scannen — Spezifikationen in Sekunden.' : 'Search or scan — instant specs in seconds.',
          mockUIHtml: `
            <div class="tour-mock-ui">
              <div style="display:flex;align-items:center;gap:10px;background:rgba(30,41,59,0.5);padding:12px;border-radius:10px;margin-bottom:12px;">
                <i class="fa-solid fa-magnifying-glass" style="color:#818cf8;font-size:16px;"></i>
                <span style="flex:1;font-size:13px;color:#94a3b8;font-weight:500;">${t('add_appliance_cta_desc')}</span>
                <span class="mock-badge mock-badge-accent"><i class="fa-solid fa-camera"></i> Scan</span>
              </div>
            </div>`
        }
      ]
    },
    coffee: {
      appTitle: t('brand_coffee'),
      welcomeToast: isTr ? "Kahve Asistanı'na hoş geldiniz!" : isDa ? "Velkommen til Kaffe Ledsager!" : "Welcome to Coffee Companion!",
      steps: [
        {
          heroGradient: 'linear-gradient(135deg, rgba(217,119,6,0.3), rgba(180,83,9,0.15))',
          heroIcon: 'fa-mug-hot',
          heroColor: '#d97706',
          title: isTr ? 'Barista Kontrol Merkezi' : isDa ? 'Barista Kontrolcenter' : isDe ? 'Barista Kontrollzentrum' : 'Barista Command Center',
          subtitle: isTr ? 'Hassas espresso ekstraksiyonu parmaklarınızın ucunda.' : isDa ? 'Præcisionsespresso ved fingerspidserne.' : 'Precision espresso extraction at your fingertips.',
          mockUIHtml: `
            <div class="tour-mock-ui">
              <div style="display:flex;align-items:center;justify-content:space-between;margin-bottom:12px;">
                <div style="display:flex;align-items:center;gap:8px;">
                  <i class="fa-solid fa-mug-hot" style="color:#d97706;font-size:20px;"></i>
                  <div>
                    <div style="font-size:13px;font-weight:700;color:#fff;">${t('coffee_todays_extraction')}</div>
                    <div style="font-size:10px;color:#92400e;">Double Shot · 1:2.0 Ratio</div>
                  </div>
                </div>
                <span class="mock-badge mock-badge-warning">Live</span>
              </div>
            </div>`
        }
      ]
    },
    ebike: {
      appTitle: t('brand_ebike'),
      welcomeToast: isTr ? "E-Bisiklet Servis'e hoş geldiniz!" : "Welcome to E-Bike Service!",
      steps: [
        {
          heroGradient: 'linear-gradient(135deg, rgba(16,185,129,0.3), rgba(5,150,105,0.15))',
          heroIcon: 'fa-bicycle',
          heroColor: '#10b981',
          title: isTr ? 'Sürüş Telemetrisi & Aşınma' : 'Active Ride Telemetry',
          subtitle: isTr ? 'Zincir uzaması ve batarya sağlığı takibi.' : 'Proactive chain wear & battery telemetry.',
          mockUIHtml: `
            <div class="tour-mock-ui">
              <div class="mock-row">
                <span class="mock-label">${t('ebike_stat_odometer')}</span>
                <span class="mock-value" style="color:#10b981;">1,248 km</span>
              </div>
            </div>`
        }
      ]
    },
    skigear: {
      appTitle: t('brand_skigear'),
      welcomeToast: isTr ? "Kayak Ekipmanı Takibi'ne hoş geldiniz!" : "Welcome to Ski Gear Tracker!",
      steps: [
        {
          heroGradient: 'linear-gradient(135deg, rgba(249,115,22,0.3), rgba(234,88,12,0.15))',
          heroIcon: 'fa-person-skiing',
          heroColor: '#f97316',
          title: isTr ? 'Kayak Takımı & DIN Hesaplayıcı' : 'Your Ski Quiver',
          subtitle: isTr ? 'ISO 11088 sertifikalı bağlama ve vaks danışmanı.' : 'ISO 11088 certified safety release values.',
          mockUIHtml: `
            <div class="tour-mock-ui">
              <div class="mock-row">
                <span class="mock-label">ISO 11088 DIN</span>
                <span class="mock-value" style="color:#f97316;">DIN 8.5</span>
              </div>
            </div>`
        }
      ]
    }
  };

  return tours[domain] || tours.appliance;
}


export const SPEC_TRANSLATIONS = {
  "Manufacturer Warranty Policy": {
    "en": "Manufacturer Warranty Policy",
    "tr": "Üretici Garanti Politikası",
    "de": "Herstellergarantie / Richtlinie",
    "fr": "Garantie constructeur / Politique",
    "it": "Garanzia / Politica produttore",
    "da": "Producentgaranti / Politik",
    "sv": "Tillverkargaranti / Policy",
    "no": "Produsentgaranti / Polise"
  },
  "Warranty Policy": {
    "en": "Warranty Policy",
    "tr": "Garanti Politikası",
    "de": "Garantierichtlinie",
    "fr": "Politique de garantie",
    "it": "Politica di garanzia",
    "da": "Garantipolitik",
    "sv": "Garantipolicy",
    "no": "Garantipolise"
  },
  "Total Net Capacity": {
    "en": "Total Net Capacity",
    "tr": "Toplam Net Hacim",
    "de": "Gesamtnutzinhalt",
    "fr": "Capacité nette totale",
    "it": "Capacità netta totale",
    "da": "Samlet nettokapacitet",
    "sv": "Total nettokapacitet",
    "no": "Total nettokapasitet"
  },
  "Cooling System": {
    "en": "Cooling System",
    "tr": "Soğutma Sistemi",
    "de": "Kühlsystem",
    "fr": "Système de refroidissement",
    "it": "Sistema di raffreddamento",
    "da": "Kølesystem",
    "sv": "Kylsystem",
    "no": "Kjølesystem"
  },
  "Noise Level": {
    "en": "Noise Level",
    "tr": "Ses Seviyesi",
    "de": "Geräuschpegel",
    "fr": "Niveau sonore",
    "it": "Livello sonoro",
    "da": "Støjniveau",
    "sv": "Ljudnivå",
    "no": "Støynivå"
  },
  "Energy Rating": {
    "en": "Energy Rating",
    "tr": "Enerji Sınıfı",
    "de": "Energieeffizienzklasse",
    "fr": "Classe énergétique",
    "it": "Classe energetica",
    "da": "Energiklasse",
    "sv": "Energiklass",
    "no": "Energiklasse"
  },
  "Freshness Zone": {
    "en": "Freshness Zone",
    "tr": "Tazelik Bölmesi",
    "de": "Frischezone",
    "fr": "Zone de fraîcheur",
    "it": "Zona freschezza",
    "da": "Friskhedszone",
    "sv": "Färskhetszon",
    "no": "Friskhetssone"
  },
  "Capacity": {
    "en": "Capacity",
    "tr": "Kapasite",
    "de": "Fassungsvermögen",
    "fr": "Capacité",
    "it": "Capacità",
    "da": "Kapacitet",
    "sv": "Kapacitet",
    "no": "Kapasitet"
  },
  "Water Consumption (Eco)": {
    "en": "Water Consumption (Eco)",
    "tr": "Su Tüketimi (Eko)",
    "de": "Wasserverbrauch (Eco)",
    "fr": "Consommation d\'eau (Éco)",
    "it": "Consumo d'acqua (Eco)",
    "da": "Vandforbrug (Eco)",
    "sv": "Vattenförbrukning (Eco)",
    "no": "Vannforbruk (Eco)"
  },
  "Motor / Drive": {
    "en": "Motor / Drive",
    "tr": "Motor / Sürücü Sistemi",
    "de": "Motor / Antrieb",
    "fr": "Moteur / Entraînement",
    "it": "Motore / Trasmissione",
    "da": "Motor / Drev",
    "sv": "Motor / Drivning",
    "no": "Motor / Drift"
  },
  "Programs & Options": {
    "en": "Programs & Options",
    "tr": "Programlar & Seçenekler",
    "de": "Programme & Optionen",
    "fr": "Programmes et options",
    "it": "Programmi e opzioni",
    "da": "Programmer & Tilvalg",
    "sv": "Program & Tillval",
    "no": "Programmer & Valg"
  },
  "Safety System": {
    "en": "Safety System",
    "tr": "Güvenlik Sistemi",
    "de": "Sicherheitssystem",
    "fr": "Système de sécurité",
    "it": "Sistema di sicurezza",
    "da": "Sikkerhedssystem",
    "sv": "Säkerhetssystem",
    "no": "Sikkerhetssystem"
  },
  "Cavity Volume": {
    "en": "Cavity Volume",
    "tr": "Fırın Hacmi",
    "de": "Garraumvolumen",
    "fr": "Volume de la cavité",
    "it": "Volume cavità",
    "da": "Ovnrumsvolumen",
    "sv": "Ugnsvolym",
    "no": "Ovnsvolum"
  },
  "Heating Functions": {
    "en": "Heating Functions",
    "tr": "Isıtma Fonksiyonları",
    "de": "Heizarten",
    "fr": "Modes de cuisson",
    "it": "Funzioni di riscaldamento",
    "da": "Opvarmningsfunktioner",
    "sv": "Uppvärmningsfunktioner",
    "no": "Oppvarmingsfunksjoner"
  },
  "Cleaning System": {
    "en": "Cleaning System",
    "tr": "Temizleme Sistemi",
    "de": "Reinigungssystem",
    "fr": "Système de nettoyage",
    "it": "Sistema di pulizia",
    "da": "Rengøringssystem",
    "sv": "Rengöringssystem",
    "no": "Rengjøringssystem"
  },
  "Temperature Range": {
    "en": "Temperature Range",
    "tr": "Sıcaklık Aralığı",
    "de": "Temperaturbereich",
    "fr": "Plage de température",
    "it": "Intervallo di temperatura",
    "da": "Temperaturområde",
    "sv": "Temperaturintervall",
    "no": "Temperaturområde"
  },
  "Suction Power": {
    "en": "Suction Power",
    "tr": "Emiş Gücü",
    "de": "Saugleistung",
    "fr": "Puissance d\'aspiration",
    "it": "Potenza di aspirazione",
    "da": "Sugeeffekt",
    "sv": "Sugkraft",
    "no": "Sugeeffekt"
  },
  "Navigation & Sensors": {
    "en": "Navigation & Sensors",
    "tr": "Navigasyon & Sensörler",
    "de": "Navigation & Sensoren",
    "fr": "Navigation et capteurs",
    "it": "Navigazione e sensori",
    "da": "Navigation & Sensorer",
    "sv": "Navigation & Sensorer",
    "no": "Navigasjon & Sensorer"
  },
  "Mopping System": {
    "en": "Mopping System",
    "tr": "Paspas & Silme Sistemi",
    "de": "Wischsystem",
    "fr": "Système de lavage",
    "it": "Sistema di lavaggio",
    "da": "Moppesystem",
    "sv": "Moppningssystem",
    "no": "Moppesystem"
  },
  "Brush System": {
    "en": "Brush System",
    "tr": "Fırça Sistemi",
    "de": "Bürstensystem",
    "fr": "Système de brosse",
    "it": "Sistema di spazzole",
    "da": "Børstesystem",
    "sv": "Borstsystem",
    "no": "Børstesystem"
  },
  "Battery & Runtime": {
    "en": "Battery & Runtime",
    "tr": "Pil & Çalışma Süresi",
    "de": "Akku & Laufzeit",
    "fr": "Batterie et autonomie",
    "it": "Batteria e autonomia",
    "da": "Batteri & Driftstid",
    "sv": "Batteri & Drifttid",
    "no": "Batteri & Driftstid"
  },
  "Dustbin & Water Tank": {
    "en": "Dustbin & Water Tank",
    "tr": "Toz Haznesi & Su Deposu",
    "de": "Staubbehälter & Wassertank",
    "fr": "Bac à poussière et réservoir d\'eau",
    "it": "Contenitore polvere e serbatoio acqua",
    "da": "Støvbeholder & Vandtank",
    "sv": "Dammbehållare & Vattentank",
    "no": "Støvbeholder & Vanntank"
  },
  "Pump Pressure": {
    "en": "Pump Pressure",
    "tr": "Pompa Basıncı",
    "de": "Pumpendruck",
    "fr": "Pression de la pompe",
    "it": "Pressione pompa",
    "da": "Pumpetryk",
    "sv": "Pumptryck",
    "no": "Pumpetrykk"
  },
  "Water Tank Capacity": {
    "en": "Water Tank Capacity",
    "tr": "Su Deposu Kapasitesi",
    "de": "Wassertank-Kapazität",
    "fr": "Capacité du réservoir d\'eau",
    "it": "Capacità serbatoio acqua",
    "da": "Vandtankkapacitet",
    "sv": "Vattentankskapacitet",
    "no": "Vanntankkapasitet"
  },
  "Water Tank": {
    "en": "Water Tank",
    "tr": "Su Deposu",
    "de": "Wassertank",
    "fr": "Réservoir d\'eau",
    "it": "Serbatoio acqua",
    "da": "Vandtank",
    "sv": "Vattentank",
    "no": "Vanntank"
  },
  "Bean Container": {
    "en": "Bean Container",
    "tr": "Çekirdek Haznesi",
    "de": "Bohnenbehälter",
    "fr": "Bac à grains",
    "it": "Contenitore chicchi",
    "da": "Bønnebeholder",
    "sv": "Bönbehållare",
    "no": "Bønnebeholder"
  },
  "Bean Container Capacity": {
    "en": "Bean Container Capacity",
    "tr": "Çekirdek Haznesi Kapasitesi",
    "de": "Bohnenbehälter-Kapazität",
    "fr": "Capacité du bac à grains",
    "it": "Capacità contenitore chicchi",
    "da": "Bønnebeholderkapacitet",
    "sv": "Bönbehållarkapacitet",
    "no": "Bønnebeholderkapacitet"
  },
  "Grinder": {
    "en": "Grinder",
    "tr": "Öğütücü",
    "de": "Mahlwerk",
    "fr": "Broyeur",
    "it": "Macinacaffè",
    "da": "Kværn",
    "sv": "Kvarn",
    "no": "Kvern"
  },
  "Beverage Presets": {
    "en": "Beverage Presets",
    "tr": "İçecek Seçenekleri",
    "de": "Getränke-Voreinstellungen",
    "fr": "Boissons préprogrammées",
    "it": "Bevande preimpostate",
    "da": "Drikkeforvalg",
    "sv": "Dryckesförval",
    "no": "Drikkeforvalg"
  },
  "Dimensions (WxDxH)": {
    "en": "Dimensions (WxDxH)",
    "tr": "Boyutlar (GxDxY)",
    "de": "Abmessungen (BxTxH)",
    "fr": "Dimensions (LxPxH)",
    "it": "Dimensioni (LxPxA)",
    "da": "Mål (BxDxH)",
    "sv": "Mått (BxDxH)",
    "no": "Mål (BxDxH)"
  },
  "Weight": {
    "en": "Weight",
    "tr": "Ağırlık",
    "de": "Gewicht",
    "fr": "Poids",
    "it": "Peso",
    "da": "Vægt",
    "sv": "Vikt",
    "no": "Vekt"
  },
  "Filter System": {
    "en": "Filter System",
    "tr": "Filtre Sistemi",
    "de": "Filtersystem",
    "fr": "Système de filtration",
    "it": "Sistema di filtraggio",
    "da": "Filtersystem",
    "sv": "Filtersystem",
    "no": "Filtersystem"
  },
  "Input Power": {
    "en": "Input Power",
    "tr": "Giriş Gücü",
    "de": "Leistungsaufnahme",
    "fr": "Puissance d'entrée",
    "it": "Potenza assorbita",
    "da": "Indgangseffekt",
    "sv": "Ineffekt",
    "no": "Inngangseffekt"
  },
  "Power Consumption": {
    "en": "Power Consumption",
    "tr": "Güç Tüketimi",
    "de": "Stromverbrauch",
    "fr": "Consommation électrique",
    "it": "Consumo energetico",
    "da": "Strømforbrug",
    "sv": "Strömförbrukning",
    "no": "Strømforbruk"
  },
  "Browning Control": {
    "en": "Browning Control",
    "tr": "Kızartma Kademesi",
    "de": "Bräunungsstufen",
    "fr": "Contrôle du dorage",
    "it": "Controllo doratura",
    "da": "Ristningskontrol",
    "sv": "Rostningskontroll",
    "no": "Ristekontroll"
  },
  "Crumb Tray": {
    "en": "Crumb Tray",
    "tr": "Kırıntı Tepsisi",
    "de": "Krümelschublade",
    "fr": "Ramasse-miettes",
    "it": "Vassoio raccoglibriciole",
    "da": "Krummebakke",
    "sv": "Smulbricka",
    "no": "Smuleskuff"
  },
  "Finish": {
    "en": "Finish",
    "tr": "Yüzey Tasarımı",
    "de": "Oberflächen-Finish",
    "fr": "Finition",
    "it": "Finitura",
    "da": "Finish",
    "sv": "Finish",
    "no": "Overflatebehandling"
  },
  "Display Panel": {
    "en": "Display Panel",
    "tr": "Ekran Paneli",
    "de": "Display / Bildschirm",
    "fr": "Panneau d'affichage",
    "it": "Pannello display",
    "da": "Skærmpanel",
    "sv": "Skärmpanel",
    "no": "Skjermpanel"
  },
  "Display": {
    "en": "Display",
    "tr": "Ekran",
    "de": "Display",
    "fr": "Écran",
    "it": "Display",
    "da": "Display",
    "sv": "Display",
    "no": "Display"
  },
  "Refresh Rate": {
    "en": "Refresh Rate",
    "tr": "Yenileme Hızı",
    "de": "Bildwiederholfrequenz",
    "fr": "Taux de rafraîchissement",
    "it": "Frequenza di aggiornamento",
    "da": "Opdateringshastighed",
    "sv": "Uppdateringsfrekvens",
    "no": "Oppdateringsfrekvens"
  },
  "Purchase Date": {
    "en": "Purchase Date",
    "tr": "Satın Alma Tarihi",
    "de": "Kaufdatum",
    "fr": "Date d'achat",
    "it": "Data di acquisto",
    "da": "Købsdato",
    "sv": "Inköpsdatum",
    "no": "Kjøpsdato"
  },
  "Purchase Price": {
    "en": "Purchase Price",
    "tr": "Satın Alma Fiyatı",
    "de": "Kaufpreis",
    "fr": "Prix d'achat",
    "it": "Prezzo di acquisto",
    "da": "Købspris",
    "sv": "Inköpspris",
    "no": "Kjøpspris"
  },
  "Audio": {
    "en": "Audio",
    "tr": "Ses Sistemi",
    "de": "Audiosystem",
    "fr": "Système audio",
    "it": "Sistema audio",
    "da": "Lydsystem",
    "sv": "Ljudsystem",
    "no": "Lydsystem"
  },
  "Smart OS": {
    "en": "Smart OS",
    "tr": "Akıllı İşletim Sistemi",
    "de": "Smart-TV Betriebssystem",
    "fr": "Système d'exploitation Smart",
    "it": "Sistema operativo Smart",
    "da": "Smart OS",
    "sv": "Smart OS",
    "no": "Smart OS"
  },
  "Spin Speed": {
    "en": "Spin Speed",
    "tr": "Sıkma Devri",
    "de": "Schleuderdrehzahl",
    "fr": "Vitesse d'essorage",
    "it": "Velocità di centrifuga",
    "da": "Centrifugeringshastighed",
    "sv": "Centrifugeringshastighet",
    "no": "Sentrifugehastighet"
  },
  "Motor": {
    "en": "Motor",
    "tr": "Motor Tipi",
    "de": "Motortyp",
    "fr": "Type de moteur",
    "it": "Tipo di motore",
    "da": "Motortype",
    "sv": "Motortyp",
    "no": "Motortype"
  },
  "Runtime": {
    "en": "Runtime",
    "tr": "Çalışma Süresi",
    "de": "Laufzeit",
    "fr": "Autonomie",
    "it": "Autonomia",
    "da": "Driftstid",
    "sv": "Drifttid",
    "no": "Driftstid"
  },
  "Filtration": {
    "en": "Filtration",
    "tr": "Filtrasyon",
    "de": "Filtration",
    "fr": "Filtration",
    "it": "Filtrazione",
    "da": "Filtrering",
    "sv": "Filtrering",
    "no": "Filtrering"
  },
  "Manufacturer": {
    "en": "Manufacturer",
    "tr": "Üretici",
    "de": "Hersteller",
    "fr": "Fabricant",
    "it": "Produttore",
    "da": "Producent",
    "sv": "Tillverkare",
    "no": "Produsent"
  },
  "Model": {
    "en": "Model",
    "tr": "Model",
    "de": "Modell",
    "fr": "Modèle",
    "it": "Modello",
    "da": "Model",
    "sv": "Modell",
    "no": "Modell"
  },
  "Power / Voltage": {
    "en": "Power / Voltage",
    "tr": "Güç / Gerilim",
    "de": "Leistung / Spannung",
    "fr": "Puissance / Tension",
    "it": "Potenza / Tensione",
    "da": "Effekt / Spænding",
    "sv": "Effekt / Spänning",
    "no": "Effekt / Spenning"
  },
  "Build Standard": {
    "en": "Build Standard",
    "tr": "Üretim Standardı",
    "de": "Fertigungsstandard",
    "fr": "Norme de fabrication",
    "it": "Standard di costruzione",
    "da": "Byggestandard",
    "sv": "Konstruktionsstandard",
    "no": "Byggestandard"
  },
  "Warranty Policy": {
    "en": "Warranty Policy",
    "tr": "Garanti Politikası",
    "de": "Garantierichtlinie",
    "fr": "Politique de garantie",
    "it": "Politica di garanzia",
    "da": "Garantipolitik",
    "sv": "Garantipolicy",
    "no": "Garantipolise"
  },
  "Milk System": {
    "en": "Milk System",
    "tr": "Süt Sistemi",
    "de": "Milchsystem",
    "fr": "Système de lait",
    "it": "Sistema latte",
    "da": "Mælkesystem",
    "sv": "Mjölksystem",
    "no": "Melkesystem"
  },
  "Length / Radius": {
    "en": "Length / Radius",
    "tr": "Uzunluk / Yarıçap",
    "de": "Länge / Radius",
    "fr": "Longueur / Rayon",
    "it": "Lunghezza / Raggio",
    "da": "Længde / Radius",
    "sv": "Längd / Radie",
    "no": "Lengde / Radius"
  },
  "Sidecut Profile": {
    "en": "Sidecut Profile",
    "tr": "Yan Kesim Profili",
    "de": "Taillierung / Sidecut",
    "fr": "Ligne de cotes",
    "it": "Profilo sciancratura",
    "da": "Sidecut-profil",
    "sv": "Sidoskärningsprofil",
    "no": "Innsvingprofil"
  },
  "Bindings": {
    "en": "Bindings",
    "tr": "Kayak Bağlamaları",
    "de": "Skibindung",
    "fr": "Fixations",
    "it": "Attacchi",
    "da": "Bindinger",
    "sv": "Bindningar",
    "no": "Bindinger"
  },
  "Drivetrain": {
    "en": "Drivetrain",
    "tr": "Aktarma Organı / Vites",
    "de": "Antrieb / Schaltung",
    "fr": "Transmission",
    "it": "Trasmissione",
    "da": "Drivlinje",
    "sv": "Drivlina",
    "no": "Drivlinje"
  },
  "Drive System": {
    "en": "Drive System",
    "tr": "Sürüş Sistemi",
    "de": "Antriebssystem",
    "fr": "Système d'entraînement",
    "it": "Sistema di trazione",
    "da": "Drivsystem",
    "sv": "Drivsystem",
    "no": "Drivsystem"
  },
  "Battery Capacity": {
    "en": "Battery Capacity",
    "tr": "Pil Kapasitesi",
    "de": "Akkukapazität",
    "fr": "Capacité de la batterie",
    "it": "Capacità batteria",
    "da": "Batterikapacitet",
    "sv": "Batterikapacitet",
    "no": "Batterikapasitet"
  },
  "Connectivity": {
    "en": "Connectivity",
    "tr": "Bağlantı Özellikleri",
    "de": "Konnektivität",
    "fr": "Connectivité",
    "it": "Connettività",
    "da": "Forbindelse",
    "sv": "Anslutning",
    "no": "Tilkobling"
  },
  "Cup Warmer": {
    "en": "Cup Warmer",
    "tr": "Fincan Isıtıcı",
    "de": "Tassenwärmer",
    "fr": "Chauffe-tasses",
    "it": "Scaldatazze",
    "da": "Kopvarmer",
    "sv": "Koppvärmare",
    "no": "Koppvarmer"
  },
  "Steam Wand": {
    "en": "Steam Wand",
    "tr": "Buhar Çubuğu",
    "de": "Dampfdüse",
    "fr": "Buse vapeur",
    "it": "Lancia vapore",
    "da": "Dampdyse",
    "sv": "Ångrör",
    "no": "Damprør"
  },
  "Rear Shock": {
    "en": "Rear Shock",
    "tr": "Arka Amortisör",
    "de": "Hinterbaudämpfer",
    "fr": "Amortisseur arrière",
    "it": "Ammortizzatore posteriore",
    "da": "Bagdæmper",
    "sv": "Bakdämpare",
    "no": "Bakdemper"
  },
  "Suspension Fork": {
    "en": "Suspension Fork",
    "tr": "Ön Süspansiyon Çatalı",
    "de": "Federgabel",
    "fr": "Fourche suspendue",
    "it": "Forcella ammortizzata",
    "da": "Forgaffel",
    "sv": "Dämpargaffel",
    "no": "Dempegaffel"
  },
  "Release Standard": {
    "en": "Release Standard",
    "tr": "Bırakma Standardı",
    "de": "Auslösestandard",
    "fr": "Norme de déclenchement",
    "it": "Standard di sgancio",
    "da": "Udløserstandard",
    "sv": "Utlösningsstandard",
    "no": "Utløserstandard"
  },
  "Construction": {
    "en": "Construction",
    "tr": "Yapı & Malzeme",
    "de": "Konstruktion",
    "fr": "Construction",
    "it": "Costruzione",
    "da": "Konstruktion",
    "sv": "Konstruktion",
    "no": "Konstruksjon"
  },
  "Body Width": {
    "en": "Body Width",
    "tr": "Gövde Genişliği",
    "de": "Gehäusebreite",
    "fr": "Largeur du corps",
    "it": "Larghezza corpo",
    "da": "Kropsbredde",
    "sv": "Bredd",
    "no": "Bredde"
  },
  "Dispensing": {
    "en": "Dispensing",
    "tr": "Dozajlama & Dağıtım",
    "de": "Dosierung / Ausgabe",
    "fr": "Distribution",
    "it": "Erogazione",
    "da": "Dosering",
    "sv": "Dosering",
    "no": "Dosering"
  },
  "Extraction": {
    "en": "Extraction",
    "tr": "Ekstraksiyon",
    "de": "Extraktion",
    "fr": "Extraction",
    "it": "Estrazione",
    "da": "Ekstraktion",
    "sv": "Extraktion",
    "no": "Ekstraksjon"
  },
  "Processor": {
    "en": "Processor",
    "tr": "İşlemci",
    "de": "Prozessor",
    "fr": "Processeur",
    "it": "Processore",
    "da": "Processor",
    "sv": "Processor",
    "no": "Prosessor"
  },
  "Water Protection": {
    "en": "Water Protection",
    "tr": "Su Koruma Sistemi",
    "de": "Wasserschutzsystem",
    "fr": "Protection contre l'eau",
    "it": "Protezione contro l'acqua",
    "da": "Vandbeskyttelse",
    "sv": "Vattenskydd",
    "no": "Vannbeskyttelse"
  },
  "Display": {
    "en": "Display",
    "tr": "Ekran & Çözünürlük",
    "de": "Bildschirm & Auflösung",
    "fr": "Écran & Résolution",
    "it": "Schermo & Risoluzione",
    "da": "Skærm & Opløsning",
    "sv": "Skärm & Upplösning",
    "no": "Skjerm & Oppløsning"
  },
  "Display Panel": {
    "en": "Display Panel",
    "tr": "Ekran Paneli & Çözünürlük",
    "de": "Display-Panel & Auflösung",
    "fr": "Panneau d'affichage & Résolution",
    "it": "Pannello display & Risoluzione",
    "da": "Displaypanel & Opløsning",
    "sv": "Skärmpanel & Upplösning",
    "no": "Skjermpanel & Oppløsning"
  },
  "Refresh Rate": {
    "en": "Refresh Rate",
    "tr": "Yenileme Hızı",
    "de": "Bildwiederholfrequenz",
    "fr": "Taux de rafraîchissement",
    "it": "Frequenza di aggiornamento",
    "da": "Opdateringshastighed",
    "sv": "Uppdateringsfrekvens",
    "no": "Oppdateringsfrekvens"
  },
  "Screen Size": {
    "en": "Screen Size",
    "tr": "Ekran Boyutu",
    "de": "Bildschirmdiagonale",
    "fr": "Taille de l'écran",
    "it": "Dimensione schermo",
    "da": "Skærmstørrelse",
    "sv": "Skärmstorlek",
    "no": "Skjermstørrelse"
  },
  "Audio System": {
    "en": "Audio System",
    "tr": "Ses Sistemi & Hoparlör",
    "de": "Audiosystem & Lautsprecher",
    "fr": "Système audio & Haut-parleurs",
    "it": "Sistema audio & Altoparlanti",
    "da": "Lydsystem & Højttalere",
    "sv": "Ljudsystem & Högtalare",
    "no": "Lydsystem & Høyttalere"
  },
  "HDR / Contrast": {
    "en": "HDR / Contrast",
    "tr": "HDR & Kontrast",
    "de": "HDR & Kontrast",
    "fr": "HDR & Contraste",
    "it": "HDR & Contrasto",
    "da": "HDR & Kontrast",
    "sv": "HDR & Kontrast",
    "no": "HDR & Kontrast"
  }
};

export function translateSpecKey(key) {
  if (!key) return '';
  const currentLang = getLanguage();
  const langAlias = currentLang === 'nb' ? 'no' : currentLang;
  
  if (SPEC_TRANSLATIONS[key]) {
    return SPEC_TRANSLATIONS[key][langAlias] || SPEC_TRANSLATIONS[key].en || key;
  }
  
  const lowerKey = key.trim().toLowerCase();

  // Cross-lingual canonical mapping for warranty header variants
  if (lowerKey.includes('garanti') || lowerKey.includes('warranty') || lowerKey.includes('politik') || lowerKey.includes('policy') || lowerKey.includes('polise') || lowerKey.includes('richtlinie')) {
    if (SPEC_TRANSLATIONS['Manufacturer Warranty Policy']) {
      return SPEC_TRANSLATIONS['Manufacturer Warranty Policy'][langAlias] || key;
    }
  }

  // Cross-lingual canonical mapping for capacity variants
  if (lowerKey.includes('netto') || lowerKey.includes('kapasite') || lowerKey.includes('capacity') || lowerKey.includes('kapazität') || lowerKey.includes('capacité') || lowerKey.includes('capacità') || lowerKey.includes('kapacitet')) {
    if (lowerKey.includes('total') || lowerKey.includes('toplam') || lowerKey.includes('gesamt') || lowerKey.includes('samlet')) {
      if (SPEC_TRANSLATIONS['Total Net Capacity']) {
        return SPEC_TRANSLATIONS['Total Net Capacity'][langAlias] || key;
      }
    }
  }

  // Cross-lingual canonical mapping for cooling system variants
  if (lowerKey.includes('soğutma') || lowerKey.includes('kühlsystem') || lowerKey.includes('refroidissement') || lowerKey.includes('raffreddamento') || lowerKey.includes('kølesystem') || lowerKey.includes('kylsystem') || lowerKey.includes('kjølesystem')) {
    if (SPEC_TRANSLATIONS['Cooling System']) {
      return SPEC_TRANSLATIONS['Cooling System'][langAlias] || key;
    }
  }

  // Cross-lingual canonical mapping for freshness zone variants
  if (lowerKey.includes('tazelik') || lowerKey.includes('frische') || lowerKey.includes('fraîcheur') || lowerKey.includes('freschezza') || lowerKey.includes('friskhed') || lowerKey.includes('färskhet') || lowerKey.includes('friskhet')) {
    if (SPEC_TRANSLATIONS['Freshness Zone']) {
      return SPEC_TRANSLATIONS['Freshness Zone'][langAlias] || key;
    }
  }

  // Cross-lingual canonical mapping for noise level variants
  if (lowerKey.includes('ses') || lowerKey.includes('geräusch') || lowerKey.includes('sonore') || lowerKey.includes('rumore') || lowerKey.includes('støj') || lowerKey.includes('ljud') || lowerKey.includes('støy')) {
    if (SPEC_TRANSLATIONS['Noise Level']) {
      return SPEC_TRANSLATIONS['Noise Level'][langAlias] || key;
    }
  }

  // Cross-lingual canonical mapping for energy rating variants
  if (lowerKey.includes('enerji') || lowerKey.includes('energie') || lowerKey.includes('énergétique') || lowerKey.includes('energetica') || lowerKey.includes('energi')) {
    if (SPEC_TRANSLATIONS['Energy Rating']) {
      return SPEC_TRANSLATIONS['Energy Rating'][langAlias] || key;
    }
  }
  
  // Direct scan in dictionary
  for (const [k, obj] of Object.entries(SPEC_TRANSLATIONS)) {
    if (k.toLowerCase() === lowerKey) {
      return obj[langAlias] || obj.en || key;
    }
    // Check if any translated value matches
    for (const [l, translatedVal] of Object.entries(obj)) {
      if (translatedVal.toLowerCase() === lowerKey) {
        return obj[langAlias] || obj.en || key;
      }
    }
  }
  return key;
}

export function translateSpecValue(value) {
  if (!value || typeof value !== 'string') return value;
  const currentLang = getLanguage();
  const langAlias = currentLang === 'nb' ? 'no' : currentLang;
  
  let val = value;

  // 1. Universal Manufacturer Warranty Duration Translation (Separated from Statutory Claims)
  const warMatch = val.match(/(\d+)\s*(?:Ay|Months?|Monate|Mois|Mesi|Måneder|Månader)/i);
  if (warMatch && (val.includes('(') || val.includes('Politik') || val.includes('Policy') || val.includes('Garantie') || val.includes('Garanti') || val.includes('Standart') || val.includes('Standard') || val.includes('Üretici') || val.includes('Hersteller') || val.includes('Manufacturer'))) {
    const m = parseInt(warMatch[1], 10);
    const y = (m / 12).toFixed(0);
    if (langAlias === 'no') return `${m} Måneder (${m} Måneder fabrikkgaranti (${y} år))`;
    if (langAlias === 'da') return `${m} Måneder (${m} Måneder fabriksgaranti (${y} år))`;
    if (langAlias === 'sv') return `${m} Månader (${m} Månader fabriksgaranti (${y} år))`;
    if (langAlias === 'de') return `${m} Monate (${m} Monate Herstellergarantie (${y} Jahre))`;
    if (langAlias === 'fr') return `${m} Mois (${m} Mois garantie commerciale fabricant (${y} ans))`;
    if (langAlias === 'it') return `${m} Mesi (${m} Mesi garanzia commerciale produttore (${y} anni))`;
    if (langAlias === 'tr') return `${m} Ay (${m} Ay Üretici Ticari Garantisi (${y} Yıl))`;
    return `${m} Months (${m} Months Manufacturer Commercial Warranty (${y} Years))`;
  }

  // 2. Language-specific term replacements
  if (langAlias === 'no') {
    val = val.replace(/Fridge:/gi, 'Kjøleskap:')
             .replace(/Freezer:/gi, 'Fryser:')
             .replace(/Soğutucu:/gi, 'Kjøleskap:')
             .replace(/Dondurucu:/gi, 'Fryser:')
             .replace(/Kühlbereich:/gi, 'Kjøleskap:')
             .replace(/Gefrierbereich:/gi, 'Fryser:')
             .replace(/\bClass\s+([A-G])(?:\s*\/\s*([A-G]))?\s*\(EU\/Swiss\)/gi, 'Klasse $1/$2 (EU/Sveits)')
             .replace(/\bClass\s+([A-G])\b/gi, 'Klasse $1')
             .replace(/\bDrawer with Humidity Control\b/gi, 'Skuff med fuktighetskontroll')
             .replace(/Nem Kontrollü Çekmece/gi, 'Skuff med fuktighetskontroll')
             .replace(/Schublade mit Feuchtigkeitsregulierung/gi, 'Skuff med fuktighetskontroll')
             .replace(/\bPlace Settings\b/gi, 'Kuverter')
             .replace(/\bLifetime Water Damage Protection\b/gi, 'Livslang vannskadebeskyttelse')
             .replace(/\bLifetime\b/gi, 'Livslang')
             .replace(/\bFront Access\b/gi, 'Fronttilgang')
             .replace(/\bwith Aroma Cover\b/gi, 'med aromadeksel')
             .replace(/\b13-Step Conical Steel Burr\b/gi, '13-trinns konisk stålverkkvern')
             .replace(/\bWater Softener Filter\b/gi, 'Vannavherdingsfilter')
             .replace(/\bwith Fast Pre-heating\b/gi, 'med hurtigoppvarming')
             .replace(/\bVoice Control\b/gi, 'Talekontroll')
             .replace(/\bObstacle Avoidance\b/gi, 'Hindringsunngåelse')
             .replace(/\bUp to\b/gi, 'Opptil')
             .replace(/\bLitres?\b/gi, 'Liter')
             .replace(/\bMonths?\b/gi, 'Måneder')
             .replace(/\bYears?\b/gi, 'År')
             .replace(/\bDaily\b/gi, 'Daglig')
             .replace(/\bWeekly\b/gi, 'Ukentlig')
             .replace(/\bMonthly\b/gi, 'Månedlig')
             .replace(/\bEvery\b/gi, 'Hver')
             .replace(/\bDays?\b/gi, 'Dager');
  } else if (langAlias === 'da') {
    val = val.replace(/Fridge:/gi, 'Køleskab:')
             .replace(/Freezer:/gi, 'Fryser:')
             .replace(/Soğutucu:/gi, 'Køleskab:')
             .replace(/Dondurucu:/gi, 'Fryser:')
             .replace(/\bClass\s+([A-G])(?:\s*\/\s*([A-G]))?\s*\(EU\/Swiss\)/gi, 'Klasse $1/$2 (EU/Schweiz)')
             .replace(/\bClass\s+([A-G])\b/gi, 'Klasse $1')
             .replace(/\bDrawer with Humidity Control\b/gi, 'Skuffe med fugtighedskontrol')
             .replace(/Nem Kontrollü Çekmece/gi, 'Skuffe med fugtighedskontrol')
             .replace(/\bPlace Settings\b/gi, 'Kuverter')
             .replace(/\bLifetime Water Damage Protection\b/gi, 'Livslang vandskadebeskyttelse')
             .replace(/\bLifetime\b/gi, 'Livslang')
             .replace(/\bFront Access\b/gi, 'Frontadgang')
             .replace(/\bwith Aroma Cover\b/gi, 'med aromalåg')
             .replace(/\b13-Step Conical Steel Burr\b/gi, '13-trins konisk stålkværn')
             .replace(/\bWater Softener Filter\b/gi, 'Vandblødgøringsfilter')
             .replace(/\bwith Fast Pre-heating\b/gi, 'med hurtigopvarmning')
             .replace(/\bVoice Control\b/gi, 'Stemmestyring')
             .replace(/\bUp to\b/gi, 'Op til')
             .replace(/\bLitres?\b/gi, 'Liter')
             .replace(/\bMonths?\b/gi, 'Måneder')
             .replace(/\bYears?\b/gi, 'År')
             .replace(/\bDaily\b/gi, 'Dagligt')
             .replace(/\bWeekly\b/gi, 'Ugentlig')
             .replace(/\bMonthly\b/gi, 'Månedligt')
             .replace(/\bEvery\b/gi, 'Hver')
             .replace(/\bDays?\b/gi, 'Dage');
  } else if (langAlias === 'sv') {
    val = val.replace(/Fridge:/gi, 'Kyl:')
             .replace(/Freezer:/gi, 'Frys:')
             .replace(/Soğutucu:/gi, 'Kyl:')
             .replace(/Dondurucu:/gi, 'Frys:')
             .replace(/\bClass\s+([A-G])(?:\s*\/\s*([A-G]))?\s*\(EU\/Swiss\)/gi, 'Klass $1/$2 (EU/Schweiz)')
             .replace(/\bClass\s+([A-G])\b/gi, 'Klass $1')
             .replace(/\bDrawer with Humidity Control\b/gi, 'Låda med fuktighetsreglering')
             .replace(/Nem Kontrollü Çekmece/gi, 'Låda med fuktighetsreglering')
             .replace(/\bPlace Settings\b/gi, 'Kuvert')
             .replace(/\bLifetime Water Damage Protection\b/gi, 'Livslångt vattenskadeskydd')
             .replace(/\bLifetime\b/gi, 'Livslångt')
             .replace(/\bFront Access\b/gi, 'Frontåtkomst')
             .replace(/\bwith Aroma Cover\b/gi, 'med aromalock')
             .replace(/\b13-Step Conical Steel Burr\b/gi, '13-stegs konisk stålkvarn')
             .replace(/\bWater Softener Filter\b/gi, 'Avhärdningsfilter')
             .replace(/\bwith Fast Pre-heating\b/gi, 'med snabbuppvärmning')
             .replace(/\bVoice Control\b/gi, 'Röststyrning')
             .replace(/\bUp to\b/gi, 'Upp till')
             .replace(/\bLitres?\b/gi, 'Liter')
             .replace(/\bMonths?\b/gi, 'Månader')
             .replace(/\bYears?\b/gi, 'År')
             .replace(/\bDaily\b/gi, 'Dagligen')
             .replace(/\bWeekly\b/gi, 'Veckovis')
             .replace(/\bMonthly\b/gi, 'Månadsvis')
             .replace(/\bEvery\b/gi, 'Varje')
             .replace(/\bDays?\b/gi, 'Dagar');
  } else if (langAlias === 'de') {
    val = val.replace(/Fridge:/gi, 'Kühlbereich:')
             .replace(/Freezer:/gi, 'Gefrierbereich:')
             .replace(/Soğutucu:/gi, 'Kühlbereich:')
             .replace(/Dondurucu:/gi, 'Gefrierbereich:')
             .replace(/\bClass\s+([A-G])(?:\s*\/\s*([A-G]))?\s*\(EU\/Swiss\)/gi, 'Klasse $1/$2 (EU/Schweiz)')
             .replace(/\bClass\s+([A-G])\b/gi, 'Klasse $1')
             .replace(/\bDrawer with Humidity Control\b/gi, 'Schublade mit Feuchtigkeitsregulierung')
             .replace(/Nem Kontrollü Çekmece/gi, 'Schublade mit Feuchtigkeitsregulierung')
             .replace(/\bPlace Settings\b/gi, 'Massgedecke')
             .replace(/\bLifetime Water Damage Protection\b/gi, 'Lebenslanger Wasserschutz')
             .replace(/\bLifetime\b/gi, 'Lebenslang')
             .replace(/\bFront Access\b/gi, 'Frontzugriff')
             .replace(/\bwith Aroma Cover\b/gi, 'mit Aromaschutzdeckel')
             .replace(/\b13-Step Conical Steel Burr\b/gi, '13-stufiges Kegelmahlwerk')
             .replace(/\bWater Softener Filter\b/gi, 'Wasserenthärterfilter')
             .replace(/\bwith Fast Pre-heating\b/gi, 'mit Schnellaufheizung')
             .replace(/\bVoice Control\b/gi, 'Sprachsteuerung')
             .replace(/\bUp to\b/gi, 'Bis zu')
             .replace(/\bLitres?\b/gi, 'Liter')
             .replace(/\bMonths?\b/gi, 'Monate')
             .replace(/\bYears?\b/gi, 'Jahre')
             .replace(/\bDaily\b/gi, 'Täglich')
             .replace(/\bWeekly\b/gi, 'Wöchentlich')
             .replace(/\bMonthly\b/gi, 'Monatlich')
             .replace(/\bEvery\b/gi, 'Alle')
             .replace(/\bDays?\b/gi, 'Tage');
  } else if (langAlias === 'fr') {
    val = val.replace(/Fridge:/gi, 'Réfrigérateur:')
             .replace(/Freezer:/gi, 'Congélateur:')
             .replace(/Soğutucu:/gi, 'Réfrigérateur:')
             .replace(/Dondurucu:/gi, 'Congélateur:')
             .replace(/\bClass\s+([A-G])(?:\s*\/\s*([A-G]))?\s*\(EU\/Swiss\)/gi, 'Classe $1/$2 (UE/Suisse)')
             .replace(/\bClass\s+([A-G])\b/gi, 'Classe $1')
             .replace(/\bDrawer with Humidity Control\b/gi, "Tiroir avec contrôle d'humidité")
             .replace(/Nem Kontrollü Çekmece/gi, "Tiroir avec contrôle d'humidité")
             .replace(/\bPlace Settings\b/gi, 'Couverts')
             .replace(/\bLifetime Water Damage Protection\b/gi, 'Protection antifuites à vie')
             .replace(/\bLifetime\b/gi, 'À vie')
             .replace(/\bFront Access\b/gi, 'Accès frontal')
             .replace(/\bwith Aroma Cover\b/gi, 'avec couvercle hermétique')
             .replace(/\b13-Step Conical Steel Burr\b/gi, 'Broyeur conique en acier à 13 niveaux')
             .replace(/\bWater Softener Filter\b/gi, "Filtre adoucisseur d'eau")
             .replace(/\bwith Fast Pre-heating\b/gi, 'avec préchauffage rapide')
             .replace(/\bVoice Control\b/gi, 'Commande vocale')
             .replace(/\bUp to\b/gi, "Jusqu'à")
             .replace(/\bLitres?\b/gi, 'Litres')
             .replace(/\bMonths?\b/gi, 'Mois')
             .replace(/\bYears?\b/gi, 'Ans')
             .replace(/\bDaily\b/gi, 'Quotidien')
             .replace(/\bWeekly\b/gi, 'Hebdomadaire')
             .replace(/\bMonthly\b/gi, 'Mensuel')
             .replace(/\bEvery\b/gi, 'Tous les')
             .replace(/\bDays?\b/gi, 'Jours');
  } else if (langAlias === 'it') {
    val = val.replace(/Fridge:/gi, 'Frigorifero:')
             .replace(/Freezer:/gi, 'Congelatore:')
             .replace(/Soğutucu:/gi, 'Frigorifero:')
             .replace(/Dondurucu:/gi, 'Congelatore:')
             .replace(/\bClass\s+([A-G])(?:\s*\/\s*([A-G]))?\s*\(EU\/Swiss\)/gi, 'Classe $1/$2 (UE/Svizzera)')
             .replace(/\bClass\s+([A-G])\b/gi, 'Classe $1')
             .replace(/\bDrawer with Humidity Control\b/gi, 'Cassetto con controllo umidità')
             .replace(/Nem Kontrollü Çekmece/gi, 'Cassetto con controllo umidità')
             .replace(/\bPlace Settings\b/gi, 'Coperti')
             .replace(/\bLifetime Water Damage Protection\b/gi, 'Protezione a vita contro danni da acqua')
             .replace(/\bLifetime\b/gi, 'A vita')
             .replace(/\bFront Access\b/gi, 'Accesso frontale')
             .replace(/\bwith Aroma Cover\b/gi, 'con coperchio salva-aroma')
             .replace(/\b13-Step Conical Steel Burr\b/gi, 'Macinacaffè conico a 13 livelli')
             .replace(/\bWater Softener Filter\b/gi, "Filtro addolcitore d'acqua")
             .replace(/\bwith Fast Pre-heating\b/gi, 'con preriscaldamento rapido')
             .replace(/\bVoice Control\b/gi, 'Controllo vocale')
             .replace(/\bUp to\b/gi, 'Fino a')
             .replace(/\bLitres?\b/gi, 'Litri')
             .replace(/\bMonths?\b/gi, 'Mesi')
             .replace(/\bYears?\b/gi, 'Anni')
             .replace(/\bDaily\b/gi, 'Giornaliero')
             .replace(/\bWeekly\b/gi, 'Settimanale')
             .replace(/\bMonthly\b/gi, 'Mensile')
             .replace(/\bEvery\b/gi, 'Ogni')
             .replace(/\bDays?\b/gi, 'Giorni');
  } else if (langAlias === 'tr') {
    val = val.replace(/Fridge:/gi, 'Soğutucu:')
             .replace(/Freezer:/gi, 'Dondurucu:')
             .replace(/Kjøleskap:/gi, 'Soğutucu:')
             .replace(/Fryser:/gi, 'Dondurucu:')
             .replace(/\bClass\s+([A-G])(?:\s*\/\s*([A-G]))?\s*\(EU\/Swiss\)/gi, 'Sınıf $1/$2 (AB/İsviçre)')
             .replace(/\bClass\s+([A-G])\b/gi, 'Sınıf $1')
             .replace(/\bDrawer with Humidity Control\b/gi, 'Nem Kontrollü Çekmece')
             .replace(/\bPlace Settings\b/gi, 'Kişilik Yemek Takımı')
             .replace(/\bLifetime Water Damage Protection\b/gi, 'Ömür Boyu Su Hasarı Koruması')
             .replace(/\bLifetime\b/gi, 'Ömür Boyu')
             .replace(/\bFront Access\b/gi, 'Önden Erişim')
             .replace(/\bwith Aroma Cover\b/gi, 'Aroma Koruma Kapağı ile')
             .replace(/\b13-Step Conical Steel Burr\b/gi, '13 Kademeli Konik Çelik Öğütücü')
             .replace(/\bWater Softener Filter\b/gi, 'Su Yumuşatma Filtresi')
             .replace(/\bwith Fast Pre-heating\b/gi, 'Hızlı Ön Isıtma ile')
             .replace(/\bVoice Control\b/gi, 'Sesli Kontrol')
             .replace(/\bUp to\b/gi, '')
             .replace(/\bLitres?\b/gi, 'Litre')
             .replace(/\bMonths?\b/gi, 'Ay')
             .replace(/\bYears?\b/gi, 'Yıl')
             .replace(/\bDaily\b/gi, 'Günlük')
             .replace(/\bWeekly\b/gi, 'Haftalık')
             .replace(/\bMonthly\b/gi, 'Aylık')
             .replace(/\bEvery\b/gi, 'Her')
             .replace(/\bDays?\b/gi, 'Gün');
  }
  return val;
}

// ==================== MAINTENANCE & CLEANING LOCALIZATION ENGINE ====================
export const MAINTENANCE_TITLES = {
  'Condenser Coil Dust Cleaning': {
    en: 'Condenser Coil Dust Cleaning',
    tr: 'Kondansatör Serpantin Toz Temizliği',
    de: 'Kondensator-Staubabsaugung',
    fr: 'Nettoyage de la poussière du condenseur',
    it: 'Pulizia polvere serpentina condensatore',
    da: 'Støvrengøring af kondensator',
    sv: 'Dammrengöring av kondensator',
    no: 'Støvrengjøring av kondensator'
  },
  'Defrost Drain Hole Unclogging': {
    en: 'Defrost Drain Hole Unclogging',
    tr: 'Defrost Tahliye Deliği Temizliği',
    de: 'Abtauwasser-Ablauföffnung reinigen',
    fr: 'Débouchage de l\'orifice de dégivrage',
    it: 'Pulizia foro di scarico sbrinamento',
    da: 'Rensning af afrimningsafløb',
    sv: 'Rensning av avfrostningsavlopp',
    no: 'Rensing av avrimingsavløp'
  },
  'Magnetic Door Gasket Seal Clean': {
    en: 'Magnetic Door Gasket Seal Clean',
    tr: 'Manyetik Kapı Contası Temizliği',
    de: 'Magnet-Türdichtung reinigen',
    fr: 'Nettoyage du joint magnétique de porte',
    it: 'Pulizia guarnizione magnetica della porta',
    da: 'Rengøring af magnetisk dørpakning',
    sv: 'Rengöring av magnetisk dörrtätning',
    no: 'Rengjøring av magnetisk dørpakning'
  },
  'Sump Microfilter & Coarse Filter Cleaning': {
    en: 'Sump Microfilter & Coarse Filter Cleaning',
    tr: 'Taban Mikrofiltre & Kaba Filtre Temizliği',
    de: 'Pumpensumpf- und Grobfilterreinigung',
    fr: 'Nettoyage du microfiltre et du filtre grossier',
    it: 'Pulizia microfiltro e filtro grosso della vasca',
    da: 'Rensning af bund- og grovfilter',
    sv: 'Rengöring av botten- och grovfilter',
    no: 'Rensing av bunn- og grovfilter'
  },
  'Spray Arm Nozzles & Bearing Check': {
    en: 'Spray Arm Nozzles & Bearing Check',
    tr: 'Püskürtme Kolu Nozulları & Rulman Kontrolü',
    de: 'Sprüharme & Düseninspektion',
    fr: 'Contrôle des buses des bras d\'aspersion',
    it: 'Controllo ugelli bracci irroratori e cuscinetti',
    da: 'Kontrol af spulearmedyser og lejer',
    sv: 'Kontroll av spolarmarnas munstycken och lager',
    no: 'Kontroll av spylearmdyser og lagre'
  },
  'Machine Care Hot Descaling Cycle': {
    en: 'Machine Care Hot Descaling Cycle',
    tr: 'Makine Bakımı Sıcak Kireç Çözme Döngüsü',
    de: 'Machine-Care Heissentkalkungs-Zyklus',
    fr: 'Cycle de détartrage à chaud Machine Care',
    it: 'Ciclo di decalcificazione a caldo Machine Care',
    da: 'Varm afkalkningscyklus (Machine Care)',
    sv: 'Varmt avkalkningsprogram (Machine Care)',
    no: 'Varm avkalkingssyklus (Machine Care)'
  },
  'Door Gasket & Sump Seal Sanitization': {
    en: 'Door Gasket & Sump Seal Sanitization',
    tr: 'Kapı Contası & Hazne Sızdırmazlık Temizliği',
    de: 'Tür- und Wannendichtungs-Desinfektion',
    fr: 'Désinfection des joints de porte et de cuve',
    it: 'Igienizzazione guarnizione porta e vasca',
    da: 'Desinficering af dør- og bundpakning',
    sv: 'Desinfektion av dörr- och bottenpackning',
    no: 'Desinfisering av dør- og bunnpakning'
  },
  'Pyrolytic High-Heat Self-Clean Cycle': {
    en: 'Pyrolytic High-Heat Self-Clean Cycle',
    tr: 'Pirolitik Yüksek Isı Kendi Kendini Temizleme Döngüsü',
    de: 'Pyrolytische Hochtemperatur-Selbstreinigung',
    fr: 'Cycle d\'autonettoyage pyrolytique à haute température',
    it: 'Ciclo di autopulizia pirolitica ad alta temperatura',
    da: 'Pyrolytisk selvrensningscyklus ved høj varme',
    sv: 'Pyrolytisk självrengöring vid hög temperatur',
    no: 'Pyrolytisk selvrensingssyklus ved høy varme'
  },
  'Door Inner Glass Panel De-Greasing': {
    en: 'Door Inner Glass Panel De-Greasing',
    tr: 'Fırın İç Cam Panel Yağ Temizliği',
    de: 'Entfettung der inneren Türglasscheibe',
    fr: 'Dégraissage de la vitre intérieure de porte',
    it: 'Sgrassaggio pannello interno in vetro della porta',
    da: 'Affedtning af indvendigt ovnglas',
    sv: 'Avfettning av inre ugnsluckeglas',
    no: 'Avfetting av innvendig ovnsglass'
  },
  'Door Perimeter Seal Inspection': {
    en: 'Door Perimeter Seal Inspection',
    tr: 'Kapak Çevre Contası İncelemesi',
    de: 'Inspektion der hitzebeständigen Türdichtung',
    fr: 'Inspection du joint thermique de porte',
    it: 'Ispezione guarnizione termica perimetrale',
    da: 'Inspektion af varmebestandig dørpakning',
    sv: 'Inspektion av värmebeständig dörrtätning',
    no: 'Inspeksjon av varmebestandig dørpakning'
  },
  'DuoRoller Main Rubber Brushes De-Tangling': {
    en: 'DuoRoller Main Rubber Brushes De-Tangling',
    tr: 'DuoRoller Çift Kauçuk Fırça Tüy Temizliği',
    de: 'DuoRoller Gummi-Hauptbürsten-Reinigung',
    fr: 'Nettoyage des brosses en caoutchouc DuoRoller',
    it: 'Pulizia spazzole in gomma DuoRoller',
    da: 'Fjernelse af hår fra DuoRoller gummibørster',
    sv: 'Hårborttagning från DuoRoller gummiborstar',
    no: 'Hårfjerning fra DuoRoller gummibørster'
  },
  'Washable E11 Dustbin Air Filter Rinse': {
    en: 'Washable E11 Dustbin Air Filter Rinse',
    tr: 'Yıkanabilir E11 Toz Haznesi Hava Filtresi Yıkaması',
    de: 'E11 Auswaschbarer Staubfilter spülen',
    fr: 'Rinçage du filtre à air lavable E11',
    it: 'Lavaggio filtro aria lavabile E11',
    da: 'Skylning af vaskbart E11 luftfilter',
    sv: 'Sköljning av tvättbart E11-luftfilter',
    no: 'Skylling av vaskbart E11 luftfilter'
  },
  'PreciSense LiDAR & Cliff Optical Lens Wipe': {
    en: 'PreciSense LiDAR & Cliff Optical Lens Wipe',
    tr: 'PreciSense LiDAR & Düşme Sensörü Optik Lens Silimi',
    de: 'PreciSense LiDAR & Absturzsensoren reinigen',
    fr: 'Nettoyage optique LiDAR PreciSense et capteurs de vide',
    it: 'Pulizia lenti ottiche LiDAR e sensori dislivello',
    da: 'Aftørring af PreciSense LiDAR og faldsensorer',
    sv: 'Avtorkning av PreciSense LiDAR och trappsensorer',
    no: 'Avtørking av PreciSense LiDAR og fall-sensorer'
  },
  'Microfiber Mop Pad Wash & Sanitization': {
    en: 'Microfiber Mop Pad Wash & Sanitization',
    tr: 'Mikrofiber Paspas Bezi Yıkama & Dezenfeksiyonu',
    de: 'Mikrofaser-Wischpad waschen & desinfizieren',
    fr: 'Lavage et désinfection de la serpillière microfibre',
    it: 'Lavaggio e igienizzazione panno mocio in microfibra',
    da: 'Vask og desinficering af mikrofibermoppe',
    sv: 'Tvätt och desinfektion av mikrofibermopp',
    no: 'Vask og desinfisering av mikrofibermopp'
  },
  '90°C Eco Drum Clean Cycle': {
    en: '90°C Eco Drum Clean Cycle',
    tr: '90°C Eko Kazan Temizleme Döngüsü',
    de: '90°C Eco-Trommelreinigungsprogramm',
    fr: 'Cycle de nettoyage du tambour 90°C Eco',
    it: 'Ciclo di pulizia del cestello a 90°C Eco',
    da: '90°C Eco tromlerenseprogram',
    sv: '90°C Eco trumrengöringsprogram',
    no: '90°C Eco trommelrenseprogram'
  },
  'Drain Pump Filter & Emergency Hose': {
    en: 'Drain Pump Filter & Emergency Hose',
    tr: 'Tahliye Pompa Filtresi & Acil Durum Tahliyesi',
    de: 'Laugenpumpenfilter & Notentleerung reinigen',
    fr: 'Filtre de pompe de vidange et tuyau d\'urgence',
    it: 'Filtro pompa di scarico e tubo di emergenza',
    da: 'Afløbspumpefilter og nødafløbsslange',
    sv: 'Avloppspumpfilter och nödtömningsslang',
    no: 'Avløpspumpefilter og nødtømmeslange'
  },
  'Detergent Drawer & Siphon Rinse': {
    en: 'Detergent Drawer & Siphon Rinse',
    tr: 'Deterjan Çekmecesi & Sifon Yıkaması',
    de: 'Waschmittelschublade & Siphon spülen',
    fr: 'Rinçage du bac à lessive et du siphon',
    it: 'Lavaggio cassetto detersivo e sifone',
    da: 'Skylning af sæbeskuffe og hævert',
    sv: 'Sköljning av tvättmedelsfack och hävert',
    no: 'Skylling av såpeskuff og hevert'
  },
  'Door Gasket & Bellows Fold Inspection': {
    en: 'Door Gasket & Bellows Fold Inspection',
    tr: 'Körük Contası & Lastik Kıvrım Kontrolü',
    de: 'Türmanschette & Faltenbalg reinigen',
    fr: 'Inspection du joint de hublot et du soufflet',
    it: 'Ispezione guarnizione oblò e soffietto',
    da: 'Rengøring af dørmanchet og bælg',
    sv: 'Rengöring av lucktätning och bälg',
    no: 'Rengjøring av dørmansjett og belg'
  },
  'Organic Lactic Descaling Protocol': {
    en: 'Organic Lactic Descaling Protocol',
    tr: 'Organik Laktik Kireç Çözme Protokolü',
    de: 'Ökologisches Entkalkungsprotokoll (EcoDecalk)',
    fr: 'Protocole de détartrage à l\'acide lactique',
    it: 'Protocollo di decalcificazione ecologica (EcoDecalk)',
    da: 'Organisk mælkesyreafkalkningsprotokol',
    sv: 'Ekologiskt avkalkningsprotokoll (EcoDecalk)',
    no: 'Organisk melkesyreavkalkingsprotokoll'
  },
  'Central Infuser Group Rinse & Lube': {
    en: 'Central Infuser Group Rinse & Lube',
    tr: 'Demleme Grubu Yıkama & Yağlama',
    de: 'Brühgruppe entnehmen, spülen & fetten',
    fr: 'Rinçage et lubrification du groupe infuseur',
    it: 'Lavaggio e lubrificazione gruppo infusore',
    da: 'Skylning og smøring af bryggegruppe',
    sv: 'Sköljning och smörjning av bryggrupp',
    no: 'Skylling og smøring av bryggegruppe'
  },
  'Milk Circuit & LatteGo Auto-Purge': {
    en: 'Milk Circuit & LatteGo Auto-Purge',
    tr: 'Süt Sistemi & LatteGo Otomatik Tahliye',
    de: 'Milchsystem- und LatteGo-Spülung',
    fr: 'Purge automatique du circuit de lait et LatteGo',
    it: 'Lavaggio automatico circuito latte e LatteGo',
    da: 'Automatisk skylning af mælkesystem og LatteGo',
    sv: 'Automatisk sköljning av mjölksystem och LatteGo',
    no: 'Automatisk skylling av melkesystem og LatteGo'
  },
  'LatteGo Quick Clean': {
    en: 'LatteGo Quick Clean',
    tr: 'LatteGo Hızlı Temizlik',
    de: 'LatteGo Schnelltrennung & Reinigung',
    fr: 'Nettoyage rapide LatteGo',
    it: 'Pulizia rapida LatteGo',
    da: 'Hurtig rengøring af LatteGo',
    sv: 'Snabbrengöring av LatteGo',
    no: 'Hurtigrengjøring av LatteGo'
  },
  'Brew Group Lubrication': {
    en: 'Brew Group Lubrication',
    tr: 'Demleme Grubu Yağlama',
    de: 'Brühgruppen-Schmierung',
    fr: 'Lubrification du groupe café',
    it: 'Lubrificazione del gruppo caffè',
    da: 'Smøring af bryggeenhed',
    sv: 'Smörjning av bryggenhet',
    no: 'Smøring av bryggeenhet'
  },
  'Water Softener Filter Refresh': {
    en: 'Water Softener Filter Refresh',
    tr: 'Su Yumuşatma Filtresi Yenileme',
    de: 'Wasserenthärter-Filterpatrone wechseln',
    fr: 'Remplacement de la cartouche filtrante anticalcaire',
    it: 'Sostituzione cartuccia filtro addolcitore',
    da: 'Udskiftning af vandblødgøringsfilter',
    sv: 'Byte av avhärdningsfilter',
    no: 'Utskifting av vannavherdingsfilter'
  },
  'Drivetrain Ultrasonic Degrease & Lube': {
    en: 'Drivetrain Ultrasonic Degrease & Lube',
    tr: 'Aktarma Organı Yağ Temizliği & Yağlama',
    de: 'Antriebs-Entfettung & Keramikschmierung',
    fr: 'Dégraissage et lubrification de la transmission',
    it: 'Sgrassaggio e lubrificazione trasmissione',
    da: 'Affedtning og smøring af drivlinje',
    sv: 'Avfettning och smörjning av drivlina',
    no: 'Avfetting og smøring av drivlinje'
  },
  'Hydraulic Disc Brake Caliper Check': {
    en: 'Hydraulic Disc Brake Caliper Check',
    tr: 'Hidrolik Disk Fren Kaliper Kontrolü',
    de: 'Hydraulische Scheibenbremsen & Belagkontrolle',
    fr: 'Contrôle des freins à disque hydrauliques',
    it: 'Controllo pinze freni a disco idraulici',
    da: 'Kontrol af hydrauliske skivebremser',
    sv: 'Kontroll av hydrauliska skivbromsar',
    no: 'Kontroll av hydrauliske skivebremser'
  },
  'Tubeless Sealant & Tire PSI Inspection': {
    en: 'Tubeless Sealant & Tire PSI Inspection',
    tr: 'Tubeless Sıvısı & Lastik Basınç Kontrolü',
    de: 'Tubeless-Dichtmilch & Reifendruck prüfen',
    fr: 'Vérification du liquide tubeless et de la pression',
    it: 'Controllo liquido sigillante tubeless e pressione pneumatici',
    da: 'Kontrol af tubeless væske og dæktryk',
    sv: 'Kontroll av tubeless-vätska och däcktryck',
    no: 'Kontroll av slangeløs væske og dekktrykk'
  },
  'Lithium Battery Balancing Charge': {
    en: 'Lithium Battery Balancing Charge',
    tr: 'Lityum Batarya Dengeleme Şarjı',
    de: 'Lithium-Ionen Akku-Balancing-Ladung',
    fr: 'Charge d\'équilibrage de la batterie lithium',
    it: 'Carica di bilanciamento della batteria al litio',
    da: 'Balancering af lithiumbatteri',
    sv: 'Balanseringsladdning av litiumbatteri',
    no: 'Balanselading av litiumbatteri'
  },
  'Hydrocarbon Hot Base Wax & Brush': {
    en: 'Hydrocarbon Hot Base Wax & Brush',
    tr: 'Sıcak Hidrokarbon Taban Cilalama & Fırçalama',
    de: 'Heisswachs-Grundbehandlung & Ausbürsten',
    fr: 'Fartage à chaud aux hydrocarbures et brossage',
    it: 'Sciolinatura a caldo con idrocarburi e spazzolatura',
    da: 'Varm voksbehandling og børstning',
    sv: 'Varmvallning och borstning',
    no: 'Varmvoksing og børsting'
  },
  'Hot Wax Base Saturation': {
    en: 'Hot Wax Base Saturation',
    tr: 'Sıcak Vakslama & Taban Doyurma',
    de: 'Heisswachs-Belagsättigung',
    fr: 'Saturation de la semelle au fart chaud',
    it: 'Saturazione soletta con sciolina calda',
    da: 'Varm voks mætning af sål',
    sv: 'Varmvallamättning av belag',
    no: 'Varmvoksmætning av såle'
  },
  'Edge Angle Deburring & Tuning (88°)': {
    en: 'Edge Angle Deburring & Tuning (88°)',
    tr: 'Kenar Açısı Çapak Alma & Bileme (88°)',
    de: 'Kantenentgratung & 88° Diamantschliff',
    fr: 'Ébavurage et affûtage des carres (88°)',
    it: 'Sbavatura e affilatura lamine (88°)',
    da: 'Kantafgratning og 88° diamantslibning',
    sv: 'Kantgradning och 88° diamantslipning',
    no: 'Kantavgrading og 88° diamantsliping'
  },
  'ISO 11088 DIN Binding Calibration': {
    en: 'ISO 11088 DIN Binding Calibration',
    tr: 'ISO 11088 DIN Kayak Bağlama Kalibrasyonu',
    de: 'ISO 11088 DIN Skibindungs-Kalibrierung',
    fr: 'Calibration des fixations DIN ISO 11088',
    it: 'Taratura attacchi DIN ISO 11088',
    da: 'ISO 11088 DIN skibindingskalibrering',
    sv: 'ISO 11088 DIN skidbindningskalibrering',
    no: 'ISO 11088 DIN skibindingskalibrering'
  },
  'Summer Storage Protective Wax Coat': {
    en: 'Summer Storage Protective Wax Coat',
    tr: 'Yaz Saklama Koruyucu Vaks Tabakası',
    de: 'Sommer-Einlagerungs-Schutzwachsschicht',
    fr: 'Couche de fart de protection pour l\'été',
    it: 'Strato di sciolina protettiva per stoccaggio estivo',
    da: 'Beskyttende vokslag til sommeropbevaring',
    sv: 'Skyddande vallalager för sommarförvaring',
    no: 'Beskyttende vokslag for sommerlagring'
  },
  'HEPA Post-Motor Filter Wash': {
    en: 'HEPA Post-Motor Filter Wash',
    tr: 'HEPA Motor Çıkış Filtresi Yıkaması',
    de: 'HEPA Nachmotorfilter auswaschen',
    fr: 'Lavage du filtre HEPA après-moteur',
    it: 'Lavaggio filtro HEPA post-motore',
    da: 'Vask af HEPA eftermotorfilter',
    sv: 'Tvätt av HEPA eftermotorfilter',
    no: 'Vask av HEPA etter-motorfilter'
  },
  'Motorbar / Roller Brush De-Tangling': {
    en: 'Motorbar / Roller Brush De-Tangling',
    tr: 'Motorbar / Fırça Silindiri Tüy Temizliği',
    de: 'Motorbar / Bürstenwalze von Haaren befreien',
    fr: 'Nettoyage des poils sur la brosse Motorbar',
    it: 'Pulizia peli e capelli dalla spazzola Motorbar',
    da: 'Fjernelse af hår fra Motorbar børsterulle',
    sv: 'Hårborttagning från Motorbar borstvals',
    no: 'Hårfjerning fra Motorbar børstevalse'
  },
  'Cyclone Shroud & Dust Bin Wipe': {
    en: 'Cyclone Shroud & Dust Bin Wipe',
    tr: 'Siklon Kovanı & Toz Haznesi Temizliği',
    de: 'Zyklongehäuse & Staubbehälter abwischen',
    fr: 'Nettoyage du cyclone et du bac à poussière',
    it: 'Pulizia del ciclone e del contenitore polvere',
    da: 'Aftørring af cyklon og støvbeholder',
    sv: 'Avtorkning av cyklon och dammbehållare',
    no: 'Avtørking av syklon og støvbeholder'
  },
  'OLED / QLED Pixel Refresh Cycle': {
    en: 'OLED / QLED Pixel Refresh Cycle',
    tr: 'OLED / QLED Piksel Yenileme Döngüsü',
    de: 'OLED / QLED Pixel-Auffrischungszyklus',
    fr: 'Cycle de rafraîchissement des pixels OLED / QLED',
    it: 'Ciclo di aggiornamento pixel OLED / QLED',
    da: 'OLED / QLED pixel-opfriskningscyklus',
    sv: 'OLED / QLED pixeluppdateringscykel',
    no: 'OLED / QLED pikseloppfriskingssyklus'
  },
  'Chassis Air Intake Vent Vacuuming': {
    en: 'Chassis Air Intake Vent Vacuuming',
    tr: 'Kasa Hava Giriş Menfezleri Temizliği',
    de: 'Gehäuselüftungsschlitze absaugen',
    fr: 'Aspiration des orifices de ventilation du châssis',
    it: 'Aspirazione prese d\'aria dello chassis',
    da: 'Støvsugning af kabinettets ventilationsåbninger',
    sv: 'Dammsugning av chassits ventilationsöppningar',
    no: 'Støvsuging av kabinettets ventilasjonsåpninger'
  },
  'Anti-Reflective Panel Microfiber Clean': {
    en: 'Anti-Reflective Panel Microfiber Clean',
    tr: 'Parlama Önleyici Panel Mikrofiber Temizliği',
    de: 'Antireflex-Bildschirm mit Mikrofaser reinigen',
    fr: 'Nettoyage de l\'écran antireflet en microfibre',
    it: 'Pulizia schermo antiriflesso con microfibra',
    da: 'Rengøring af antirefleks-skærm med mikrofiber',
    sv: 'Rengöring av antireflex-skärm med mikrofiber',
    no: 'Rengjøring av antirefleks-skjerm med mikrofiber'
  },
  'External Microfiber Wipe & Clean': {
    en: 'External Microfiber Wipe & Clean',
    tr: 'Dış Gövde Mikrofiber Silme & Temizlik',
    de: 'Aussengehäuse mit Mikrofasertuch reinigen',
    fr: 'Nettoyage extérieur avec chiffon microfibre',
    it: 'Pulizia esterna con panno in microfibra',
    da: 'Udvendig aftørring med mikrofiberklud',
    sv: 'Utvändig avtorkning med mikrofiberduk',
    no: 'Utvendig avtørking med mikrofiberklut'
  },
  'Connection & Filter Inspection': {
    en: 'Connection & Filter Inspection',
    tr: 'Bağlantı & Filtre Kontrolü',
    de: 'Anschlüsse & Filter überprüfen',
    fr: 'Inspection des raccordements et des filtres',
    it: 'Ispezione collegamenti e filtri',
    da: 'Kontrol af tilslutninger og filtre',
    sv: 'Kontroll av anslutningar och filter',
    no: 'Kontroll av tilkoblinger og filtre'
  },
  'Operational Safety & Calibration': {
    en: 'Operational Safety & Calibration',
    tr: 'Çalışma Güvenliği & Kalibrasyon',
    de: 'Betriebssicherheitsprüfung & Kalibrierung',
    fr: 'Contrôle de sécurité de fonctionnement et calibrage',
    it: 'Verifica sicurezza di funzionamento e calibrazione',
    da: 'Driftssikkerhedskontrol og kalibrering',
    sv: 'Driftsäkerhetskontroll och kalibrering',
    no: 'Driftssikkerhetskontroll og kalibrering'
  }
};

export const MAINTENANCE_DETAILS = {
  'Vacuum rear or lower compressor coil to maintain thermal heat exchange efficiency.': {
    en: 'Vacuum rear or lower compressor coil to maintain thermal heat exchange efficiency.',
    tr: 'Termal ısı transfer verimliliğini korumak için arka veya alt kompresör serpantinini süpürün.',
    de: 'Hintere oder untere Kompressorspule absaugen, um die Wärmeableitung zu sichern.',
    fr: 'Aspirer le serpentin arrière ou inférieur du compresseur pour maintenir l\'efficacité thermique.',
    it: 'Aspirare la serpentina posteriore o inferiore del compressore per mantenere l\'efficienza termica.',
    da: 'Støvsug bageste eller nederste kompressorspole for at opretholde varmevekslingseffektiviteten.',
    sv: 'Dammsug bakre eller undre kompressorslinga för att bibehålla värmeväxlingseffektiviteten.',
    no: 'Støvsug bakre eller nedre kompressorspole for å opprettholde varmevekslingseffektiviteten.'
  },
  'Flush internal rear drain funnel with warm water to prevent standing water pooling.': {
    en: 'Flush internal rear drain funnel with warm water to prevent standing water pooling.',
    tr: 'Su birikintisini önlemek için iç arka tahliye hunisini ılık suyla yıkayın.',
    de: 'Innenliegenden hinteren Ablauftrichter mit warmem Wasser spülen, um Wasseransammlungen zu vermeiden.',
    fr: 'Rincer l\'entonnoir de vidange arrière intérieur avec de l\'eau tiède pour éviter la stagnation d\'eau.',
    it: 'Lavare l\'imbuto di scarico interno posteriore con acqua calda per evitare ristagni d\'acqua.',
    da: 'Skyl indvendig bageste afløbstragt med varmt vand for at forhindre vandansamling.',
    sv: 'Spola den inre bakre dräneringstratten med varmt vatten för att förhindra vattenansamling.',
    no: 'Skyll den indre bakre avløpstrakten med varmt vann for å forhindre vannansamling.'
  },
  'Wipe seals with mild soapy water and dry thoroughly to preserve airtight refrigeration closure.': {
    en: 'Wipe seals with mild soapy water and dry thoroughly to preserve airtight refrigeration closure.',
    tr: 'Hava sızdırmazlığını korumak için contaları hafif sabunlu suyla silin ve iyice kurulayın.',
    de: 'Dichtungen mit milder Seifenlauge abwischen und gründlich trocknen, um Luftdichtheit zu bewahren.',
    fr: 'Essuyer les joints avec de l\'eau savonneuse douce et sécher soigneusement pour préserver l\'étanchéité.',
    it: 'Pulire le guarnizioni con acqua e sapone neutro e asciugare accuratamente per preservare la tenuta ermetica.',
    da: 'Tør pakninger af med mildt sæbevand og tør grundigt for at bevare lufttæt forsegling.',
    sv: 'Torka tätningar med milt tvålvatten och torka noggrant för att bevara lufttät förslutning.',
    no: 'Tørk pakninger med mildt såpevann og tørk grundig for å bevare lufttett forsegling.'
  },
  'Rotate cylindrical filter counter-clockwise, rinse under warm running water to remove grease and food particles.': {
    en: 'Rotate cylindrical filter counter-clockwise, rinse under warm running water to remove grease and food particles.',
    tr: 'Silindirik filtreyi saat yönünün tersine çevirerek çıkarın; yağ ve yemek artıklarını temizlemek için ılık akan su altında durulayın.',
    de: 'Zylinderfilter gegen den Uhrzeigersinn drehen und unter warmem Wasser abspülen.',
    fr: 'Tourner le filtre cylindrique dans le sens inverse des aiguilles d\'une montre et rincer à l\'eau tiède.',
    it: 'Ruotare il filtro cilindrico in senso antiorario e sciacquare sotto acqua calda corrente.',
    da: 'Drej det cylindriske filter mod uret og skyl under varmt rindende vand.',
    sv: 'Vrid det cylindriska filtret moturs och skölj under rinnande varmt vatten.',
    no: 'Drei det sylindriske filteret mot klokken og skyll under varmt rennende vann.'
  },
  'Unclip upper and lower spray arms, inspect spray jets for limescale blockages; clear with a wooden toothpick.': {
    en: 'Unclip upper and lower spray arms, inspect spray jets for limescale blockages; clear with a wooden toothpick.',
    tr: 'Üst ve alt püskürtme kollarını çıkarın, nozullardaki kireç tıkanıklıklarını kontrol edin; kürdanla temizleyin.',
    de: 'Sprüharme ausclipsen und Düsen auf Kalkablagerungen prüfen; mit Zahnstocher reinigen.',
    fr: 'Déclipser les bras d\'aspersion et déboucher les buses avec un cure-dent si nécessaire.',
    it: 'Sganciare i bracci irroratori e controllare gli ugelli da blocchi di calcare con uno stuzzicadenti.',
    da: 'Afmonter spulearme og kontroller dyser for kalk; rens med en tandstik.',
    sv: 'Lossa spolarmarna och kontrollera munstyckena för kalk; rensa med tandpetare.',
    no: 'Løsne spylearmene og kontroller dysene for kalk; rens med en tannpirker.'
  },
  'Run 70°C Intensive / Machine Care program empty with active citric descaler tab to dissolve internal fat and lime.': {
    en: 'Run 70°C Intensive / Machine Care program empty with active citric descaler tab to dissolve internal fat and lime.',
    tr: 'İç yağ ve kireci çözmek için aktif sitrik kireç çözücü tablet ile boş olarak 70°C Yoğun / Makine Bakımı programını çalıştırın.',
    de: '70°C Maschinenpflege-Programm leer mit speziellem Maschinenreiniger / Entkalker durchlaufen lassen.',
    fr: 'Lancer le programme Machine Care 70°C à vide avec une pastille détartrante à l\'acide citrique.',
    it: 'Eseguire il programma Machine Care 70°C a vuoto con pastiglia anticalcare all\'acido citrico.',
    da: 'Kør 70°C Machine Care-programmet tomt med en afkalkningstablet.',
    sv: 'Kör 70°C Machine Care-programmet tomt med en avkalkningstablett.',
    no: 'Kjør 70°C Machine Care-programmet tomt med en avkalkingstablett.'
  },
  'Wipe rubber perimeter seals and lower threshold with antibacterial damp cloth.': {
    en: 'Wipe rubber perimeter seals and lower threshold with antibacterial damp cloth.',
    tr: 'Lastik çevre contalarını ve alt eşiği nemli antibakteriyel bezle silin.',
    de: 'Türgummi und untere Dichtungsleiste mit feuchtem Tuch reinigen.',
    fr: 'Essuyer les joints en caoutchouc et le seuil inférieur avec un chiffon antibactérien.',
    it: 'Pulire le guarnizioni perimetrali in gomma e la soglia inferiore con panno umido antibatterico.',
    da: 'Tør gummipakninger og nederste kant af med en fugtig antibakteriel klud.',
    sv: 'Torka av gummilister och nedre tröskel med en fuktig antibakteriell trasa.',
    no: 'Tørk av gummipakninger og nedre terskel med en fuktig antibakteriell klut.'
  },
  'Remove wire racks and initiate 480°C pyrolytic cycle; wipe residual white ash once cooled.': {
    en: 'Remove wire racks and initiate 480°C pyrolytic cycle; wipe residual white ash once cooled.',
    tr: 'Tel ızgaraları çıkarın ve 480°C pirolitik döngüyü başlatın; soğuduktan sonra kalan beyaz külü silin.',
    de: 'Gitterroste entfernen und 480°C Pyrolyse-Reinigungszyklus starten; abgekühlte Asche feucht auswischen.',
    fr: 'Retirer les grilles et lancer le cycle pyrolyse à 480°C ; essuyer les cendres une fois refroidi.',
    it: 'Rimuovere le griglie e avviare il ciclo pirolitico a 480°C; rimuovere la cenere bianca una volta raffreddato.',
    da: 'Fjern riste og start 480°C pyrolyseprogrammet; tør hvid aske af efter afkøling.',
    sv: 'Ta bort galler och starta 480°C pyrolysrengöring; torka av vit aska efter avsvalning.',
    no: 'Fjern rister og start 480°C pyrolyserengjøring; tørk av hvit aske etter avkjøling.'
  },
  'Unclip inner triple-glazed glass pane and clean with non-abrasive degreaser.': {
    en: 'Unclip inner triple-glazed glass pane and clean with non-abrasive degreaser.',
    tr: 'İç cam paneli çıkarın ve aşındırıcı olmayan yağ çözücüyle temizleyin.',
    de: 'Innere Dreifach-Glasscheibe ausclipsen und mit sanftem Fettlöser reinigen.',
    fr: 'Déclipser la vitre intérieure et nettoyer avec un dégraissant non abrasif.',
    it: 'Sganciare il vetro interno triplo e pulire con sgrassatore non abrasivo.',
    da: 'Afmonter det indvendige ovnglas og rens med et skånsomt affedtningsmiddel.',
    sv: 'Lossa innerglaset och rengör med ett skonsamt avfettningsmedel.',
    no: 'Løsne det indre ovnsglasset og rens med et skånsomt avfettingsmiddel.'
  },
  'Inspect silicone heat-resistant seal for tears or elasticity loss.': {
    en: 'Inspect silicone heat-resistant seal for tears or elasticity loss.',
    tr: 'Isıya dayanıklı silikon contayı yırtılma veya esneklik kaybı açısından kontrol edin.',
    de: 'Silikon-Backofendichtung auf Risse oder Elastizitätsverlust prüfen.',
    fr: 'Inspecter le joint en silicone résistant à la chaleur pour vérifier l\'absence de déchirure.',
    it: 'Ispezionare la guarnizione in silicone resistente al calore per tagli o perdita di elasticità.',
    da: 'Kontroller varmebestandig silikonepakning for revner eller tab af elasticitet.',
    sv: 'Inspektera värmebeständig silikontätning för sprickor eller förlorad elasticitet.',
    no: 'Kontroller varmebestandig silikonpakning for rifter eller tap av elastisitet.'
  },
  'Remove dual rubber rollers weekly; clear wound hair and strings from bearing end-caps.': {
    en: 'Remove dual rubber rollers weekly; clear wound hair and strings from bearing end-caps.',
    tr: 'Çift kauçuk silindirleri haftalık olarak çıkarın; rulman uç kapaklarındaki sarılmış saç ve ipleri temizleyin.',
    de: 'DuoRoller-Gummibürsten wöchentlich entnehmen und Haare an den Endkappen entfernen.',
    fr: 'Retirer les doubles rouleaux en caoutchouc et enlever les poils et cheveux enroulés.',
    it: 'Rimuovere i doppi rulli in gomma e togliere capelli e fili dai cuscinetti terminali.',
    da: 'Fjern gummibørster ugentligt og rens for hår og tråde ved lejeenderne.',
    sv: 'Ta bort gummiborstarna varje vecka och rensa bort hår från lagerändarna.',
    no: 'Fjern gummibørstene ukentlig og rens for hår og tråder ved lagerendene.'
  },
  'Tap out fine dust into waste bin; rinse pleated filter under cold running water every 2 weeks, air-dry 24h before refitting.': {
    en: 'Tap out fine dust into waste bin; rinse pleated filter under cold running water every 2 weeks, air-dry 24h before refitting.',
    tr: 'İnce tozu çöp kutusuna dökün; filtreyi 2 haftada bir soğuk akan su altında yıkayın, takmadan önce 24 saat kurutun.',
    de: 'Feinstaub ausklopfen; Lamellenfilter alle 2 Wochen kalt ausspülen und 24h trocknen lassen.',
    fr: 'Tapoter la poussière fine ; rincer le filtre à l\'eau froide toutes les 2 semaines et sécher 24h.',
    it: 'Scuotere la polvere nel cestino; sciacquare il filtro sotto acqua fredda ogni 2 settimane e asciugare 24h.',
    da: 'Bank støv ud; skyl filteret under koldt vand hver 2. uge og lad lufttørre i 24 timer.',
    sv: 'Knacka ur damm; skölj filtret under kallt vatten varannan vecka och lufttorka i 24 timmar.',
    no: 'Bank ut støv; skyll filteret under kaldt vann hver 2. uke og la lufttørke i 24 timer.'
  },
  'Wipe all 4 cliff sensors, front Reactive Tech lens, and dock charging contacts with dry microfiber cloth.': {
    en: 'Wipe all 4 cliff sensors, front Reactive Tech lens, and dock charging contacts with dry microfiber cloth.',
    tr: '4 düşme sensörünü, ön Reactive Tech lensini ve şarj temas noktalarını kuru mikrofiber bezle silin.',
    de: 'Absturzsensoren, Front-Optik und Ladekontakte mit trockenem Mikrofasertuch abwischen.',
    fr: 'Nettoyer les capteurs de vide, l\'optique frontale et les contacts de charge avec un chiffon sec.',
    it: 'Pulire i 4 sensori di dislivello, la lente frontale e i contatti di ricarica con panno asciutto.',
    da: 'Tør alle 4 faldsensorer, frontlinse og ladekontakter af med en tør mikrofiberklud.',
    sv: 'Torka av alla 4 trappsensorer, frontlins och laddkontakter med en torr mikrofiberduk.',
    no: 'Tørk av alle 4 fall-sensorer, frontlinse og ladekontakter med en tørr mikrofiberklut.'
  },
  'Machine-wash mop cloth pads at 60°C; replace pad every 3 to 6 months for optimal hygiene.': {
    en: 'Machine-wash mop cloth pads at 60°C; replace pad every 3 to 6 months for optimal hygiene.',
    tr: 'Paspas bezlerini 60°C\'de makinede yıkayın; hijyen için bezi 3-6 ayda bir değiştirin.',
    de: 'Wischmops bei 60°C in der Waschmaschine waschen; alle 3 bis 6 Monate austauschen.',
    fr: 'Laver les serpillières en machine à 60°C ; remplacer tous les 3 à 6 mois.',
    it: 'Lavare i panni mocio in lavatrice a 60°C; sostituire ogni 3-6 mesi per massima igiene.',
    da: 'Maskinvask moppeklude ved 60°C; udskift hver 3. til 6. måned.',
    sv: 'Maskintvätta moppdukar i 60°C; byt ut var 3:e till 6:e månad.',
    no: 'Maskinvask moppekluter ved 60°C; bytt ut hver 3. til 6. måned.'
  },
  'Run sanitization cycle with empty drum to eliminate detergent biofilm and limescale.': {
    en: 'Run sanitization cycle with empty drum to eliminate detergent biofilm and limescale.',
    tr: 'Deterjan kalıntısı ve kireci yok etmek için boş tamburla hijyen temizleme döngüsünü çalıştırın.',
    de: '90°C Trommelreinigungsprogramm leer durchführen, um Biofilm und Kalkablagerungen zu beseitigen.',
    fr: 'Exécuter un cycle de désinfection à vide pour éliminer le biofilm de lessive et le calcaire.',
    it: 'Eseguire il ciclo igienizzante a cestello vuoto per eliminare residui di detersivo e calcare.',
    da: 'Kør tromlerensningsprogram tomt for at fjerne vaskemiddelrester og kalk.',
    sv: 'Kör trumrengöringsprogram tomt för att avlägsna tvättmedelsrester och kalk.',
    no: 'Kjør trommelrenseprogram tomt for å fjerne vaskemiddelrester og kalk.'
  },
  'Unscrew lower service hatch, drain residual water, and remove trapped lint/debris.': {
    en: 'Unscrew lower service hatch, drain residual water, and remove trapped lint/debris.',
    tr: 'Alt servis kapağını açın, kalan suyu boşaltın ve biriken tüy ve yabancı cisimleri temizleyin.',
    de: 'Serviceklappe öffnen, Restwasser ablassen und Flusensieb von Fremdkörpern befreien.',
    fr: 'Dévisser la trappe de vidange, vider l\'eau résiduelle et retirer les peluches et corps étrangers.',
    it: 'Aprire lo sportellino di servizio, scaricare l\'acqua residua e pulire il filtro da lanugine e residui.',
    da: 'Åbn serviceklappen forneden, tøm restvand og rens nålefælden for fnug og genstande.',
    sv: 'Öppna serviceluckan, töm ut restvatten och rensa nålfällan från ludd och föremål.',
    no: 'Åpne serviceluken, tøm ut restvann og rens lofilteret for lo og fremmedlegemer.'
  },
  'Press siphon release clip, remove dispenser tray, and flush fabric softener residue under warm water.': {
    en: 'Press siphon release clip, remove dispenser tray, and flush fabric softener residue under warm water.',
    tr: 'Sifon mandalına basın, çekmeceyi çıkarın ve yumuşatıcı kalıntılarını ılık su altında durulayın.',
    de: 'Siphonverriegelung drücken, Waschmittelschublade entnehmen und unter warmem Wasser ausspülen.',
    fr: 'Appuyer sur le clip du siphon, retirer le bac et rincer les résidus d\'assouplissant à l\'eau tiède.',
    it: 'Premere il fermo del sifone, estrarre il cassetto detersivo e sciacquare i residui sotto acqua tiepida.',
    da: 'Tryk på hævertudløseren, tag sæbeskuffen ud og skyl rester af skyllemiddel af med varmt vand.',
    sv: 'Tryck på spärren, ta ut tvättmedelsfacket och skölj bort sköljmedelsrester under varmt vatten.',
    no: 'Trykk på utløseren, ta ut såpeskuffen og skyll bort tøymyknerrester under varmt vann.'
  },
  'Wipe rubber bellow fold with damp microfiber cloth and leave door ajar after cycles.': {
    en: 'Wipe rubber bellow fold with damp microfiber cloth and leave door ajar after cycles.',
    tr: 'Körük lastiği kıvrımını nemli mikrofiber bezle silin ve yıkama sonrası kapağı aralık bırakın.',
    de: 'Türmanschette mit feuchtem Tuch abwischen und Tür nach dem Waschen leicht geöffnet lassen.',
    fr: 'Essuyer le pli du joint de hublot avec un chiffon humide et laisser la porte entrouverte.',
    it: 'Pulire la piega della guarnizione con panno umido e lasciare l\'oblò socchiuso dopo i lavaggi.',
    da: 'Tør gummimanchetten af med en fugtig klud og lad lågen stå på klem efter vask.',
    sv: 'Torka av gummilisten med en fuktig trasa och lämna luckan på glänt efter tvätt.',
    no: 'Tørk av gummipakningen med en fuktig klut og la døren stå på gløtt etter vask.'
  },
  'Run manufacturer descaling cycle using EcoDecalk / liquid descaler when indicator warns.': {
    en: 'Run manufacturer descaling cycle using EcoDecalk / liquid descaler when indicator warns.',
    tr: 'Uyarı verildiğinde EcoDecalk / sıvı kireç çözücü kullanarak üretici kireç çözme döngüsünü çalıştırın.',
    de: 'Hersteller-Entkalkungszyklus mit EcoDecalk / speziellem Kaffeemaschinenentkalker durchführen.',
    fr: 'Lancer le cycle de détartrage avec un détartrant liquide dédié dès que le voyant s\'allume.',
    it: 'Eseguire il ciclo di decalcificazione con EcoDecalk / anticalcare liquido quando segnalato.',
    da: 'Kør afkalkningsprogram med EcoDecalk / flydende afkalker, når maskinen adviserer.',
    sv: 'Kör avkalkningsprogram med EcoDecalk / flytande avkalkare när maskinen indikerar.',
    no: 'Kjør avkalkingsprogram med EcoDecalk / flytende avkalker når maskinen varsler.'
  },
  'Slide out internal brewing group, rinse under lukewarm water without soap, and apply food-grade silicone grease.': {
    en: 'Slide out internal brewing group, rinse under lukewarm water without soap, and apply food-grade silicone grease.',
    tr: 'Demleme grubunu çıkarın, sabunsuz ılık suyla durulayın ve gıda uyumlu silikon gres uygulayın.',
    de: 'Brühgruppe herausnehmen, unter lauwarmem Wasser ohne Spülmittel abspülen und lebensmittelecht fetten.',
    fr: 'Retirer le groupe d\'infusion, rincer à l\'eau tiède sans détergent et graisser avec du silicone alimentaire.',
    it: 'Estrarre il gruppo infusore, sciacquare con acqua tiepida senza sapone e applicare grasso al silicone alimentare.',
    da: 'Tag bryggeenheden ud, skyl under lunkent vand uden sæbe og påfør fødevaregodkendt silikonefedt.',
    sv: 'Ta ut bryggruppen, skölj under ljummet vatten utan diskmedel och applicera livsmedelsgodkänt silikonfett.',
    no: 'Ta ut bryggeenheten, skyll under lunkent vann uten såpe og påfør næringsmiddelgodkjent silikonfett.'
  },
  'Disassemble milk carafe / frothing nozzle, rinse components, and run hot water purge.': {
    en: 'Disassemble milk carafe / frothing nozzle, rinse components, and run hot water purge.',
    tr: 'Süt karafı / köpürtme nozulunu sökün, parçaları yıkayın ve sıcak su tahliyesi yapın.',
    de: 'Milchkaraffe / Aufschäumdüse zerlegen, Teile gründlich spülen und Heisswasser-Spülung starten.',
    fr: 'Démonter la carafe à lait / buse vapeur, rincer les éléments et lancer une purge d\'eau chaude.',
    it: 'Smontare la caraffa latte / lancia vapore, risciacquare i componenti ed eseguire lo spurgo con acqua calda.',
    da: 'Skil mælkekande / skummedyse ad, skyl delene og kør en varmtvandsskylning.',
    sv: 'Ta isär mjölkkanna / skummarpip, skölj delarna och kör en hetvattenspolning.',
    no: 'Demonter melkekanne / skummedyse, skyll delene og kjør en varmtvannsskylling.'
  },
  'Rinse 2-piece milk container under warm tap water.': {
    en: 'Rinse 2-piece milk container under warm tap water.',
    tr: '2 parçalı süt haznesini ılık musluk suyu altında durulayın.',
    de: '2-teiligen LatteGo-Milchbehälter unter warmem Leitungswasser abspülen.',
    fr: 'Rincer le réservoir de lait en 2 parties sous l\'eau tiède du robinet.',
    it: 'Sciacquare il contenitore latte a 2 elementi sotto acqua corrente tiepida.',
    da: 'Skyl den 2-delte mælkebeholder under varmt vand fra hanen.',
    sv: 'Skölj den 2-delade mjölkbehållaren under rinnande varmt kranvatten.',
    no: 'Skyll den 2-delte melkebeholderen under lunkent vann fra kranen.'
  },
  'Rinse brew group; apply food-safe silicone grease.': {
    en: 'Rinse brew group; apply food-safe silicone grease.',
    tr: 'Demleme grubunu durulayın; gıdaya uygun silikon gres uygulayın.',
    de: 'Brühgruppe spülen; lebensmittelechtes Silikonfett auftragen.',
    fr: 'Rincer le groupe café ; appliquer de la graisse silicone alimentaire.',
    it: 'Sciacquare il gruppo caffè; applicare grasso al silicone alimentare.',
    da: 'Skyl bryggeenheden; påfør fødevaregodkendt silikonefedt.',
    sv: 'Skölj bryggruppen; applicera livsmedelsgodkänt silikonfett.',
    no: 'Skyll bryggeenheten; påfør næringsmiddelgodkjent silikonfett.'
  },
  'Replace ionic resin water filter in tank to prevent calcium carbonate buildup.': {
    en: 'Replace ionic resin water filter in tank to prevent calcium carbonate buildup.',
    tr: 'Kalsiyum karbonat birikimini önlemek için su deposundaki iyonik reçineli filtreyi değiştirin.',
    de: 'Wasserfilterpatrone im Tank austauschen, um Kalkbildung vorzubeugen.',
    fr: 'Remplacer la cartouche filtrante anticalcaire dans le réservoir d\'eau.',
    it: 'Sostituire la cartuccia filtro a resina ionica nel serbatoio per prevenire il calcare.',
    da: 'Udskift vandfilteret i beholderen for at forhindre kalkaflejringer.',
    sv: 'Byt ut vattenfiltret i tanken för att förhindra kalkavlagringar.',
    no: 'Bytt ut vannfilteret i vanntanken for å forhindre kalkavleiringer.'
  },
  'Clean 12-speed chain with biodegreaser; apply ceramic wet/dry chain lubricant every 150 km.': {
    en: 'Clean 12-speed chain with biodegreaser; apply ceramic wet/dry chain lubricant every 150 km.',
    tr: '12 vitesli zinciri biyolojik yağ çözücüyle temizleyin; her 150 km\'de seramik zincir yağı uygulayın.',
    de: 'Kette mit Bio-Entfetter reinigen und alle 150 km mit Keramikkettenöl nachschmieren.',
    fr: 'Nettoyer la chaîne avec un dégraissant biodégradable et lubrifier tous les 150 km.',
    it: 'Pulire la catena con sgrassatore biodegradabile e lubrificare ogni 150 km.',
    da: 'Rens 12-speed kæden med bioaffedter; påfør keramisk kædesmøremiddel for hver 150 km.',
    sv: 'Rengör 12-delad kedja med bioavfettning; applicera keramiskt kedjesmörjmedel var 150:e km.',
    no: 'Rens kjedet med bio-avfettingsmiddel; påfør keramisk kjedesmøring for hver 150 km.'
  },
  'Inspect pad compound thickness; replace before backing plate wear reaches 0.5 mm.': {
    en: 'Inspect pad compound thickness; replace before backing plate wear reaches 0.5 mm.',
    tr: 'Balata et kalınlığını kontrol edin; taşıyıcı plaka aşınması 0,5 mm\'ye ulaşmadan değiştirin.',
    de: 'Bremsbelagdicke prüfen; vor Erreichen von 0,5 mm Reststärke wechseln.',
    fr: 'Vérifier l\'épaisseur des plaquettes ; remplacer avant d\'atteindre 0,5 mm.',
    it: 'Controllare lo spessore delle pastiglie freno; sostituire prima di scendere sotto 0,5 mm.',
    da: 'Tjek bremseklodsernes tykkelse; udskift før slidgrænsen på 0,5 mm nås.',
    sv: 'Kontrollera bromsbeläggens tjocklek; byt innan slitaget når 0,5 mm.',
    no: 'Sjekk bremseklossenes tykkelse; bytt før slitasjen når 0,5 mm.'
  },
  'Verify tire pressure; top up 60ml liquid latex sealant to prevent puncture flats.': {
    en: 'Verify tire pressure; top up 60ml liquid latex sealant to prevent puncture flats.',
    tr: 'Lastik basıncını kontrol edin; patlakları önlemek için 60 ml sıvı lateks sızdırmazlık maddesi ekleyin.',
    de: 'Reifendruck kontrollieren; 60ml Tubeless-Dichtmilch nachfüllen.',
    fr: 'Vérifier la pression des pneus et rajouter 60 ml de préventif tubeless.',
    it: 'Controllare la pressione gomme; rabboccare 60ml di liquido sigillante per evitare forature.',
    da: 'Tjek dæktryk; påfyld 60 ml tubeless væske mod punkteringer.',
    sv: 'Kontrollera däcktryck; fyll på 60 ml tubeless-tätningsvätska.',
    no: 'Kontroller dekktrykk; etterfyll 60 ml slangeløs tetningsvæske.'
  },
  'Charge to 100% and leave connected to smart charger for 2 hours for BMS cell balancing.': {
    en: 'Charge to 100% and leave connected to smart charger for 2 hours for BMS cell balancing.',
    tr: '%100 şarj edin ve BMS hücre dengelemesi için 2 saat akıllı şarj cihazına bağlı bırakın.',
    de: 'Auf 100% laden und für BMS-Zellenausgleich 2 Stunden am Ladegerät belassen.',
    fr: 'Recharger à 100% et laisser connecté 2h pour l\'équilibrage des cellules par le BMS.',
    it: 'Caricare al 100% e lasciare collegato per 2 ore per il bilanciamento delle celle BMS.',
    da: 'Oplad til 100% og lad være tilsluttet i 2 timer for cellebalancering via BMS.',
    sv: 'Ladda till 100% och låt sitta i laddaren i 2 timmar för BMS-cellbalansering.',
    no: 'Lad til 100% og la stå tilkoblet i 2 timer for BMS-cellebalansering.'
  },
  'Melt temperature-specific wax with iron at 130°C, scrape with acrylic blade, and polish with horsehair.': {
    en: 'Melt temperature-specific wax with iron at 130°C, scrape with acrylic blade, and polish with horsehair.',
    tr: 'Sıcaklığa uygun vaksları 130°C ütüyle eritin, akrilik kazıyıcıyla kazıyın ve at kılı fırçayla parlatın.',
    de: 'Wachs bei 130°C einbügeln, mit Acrylklinge abziehen und mit Rosshaarbürste polieren.',
    fr: 'Appliquer le fart au fer à 130°C, racler au plexiglas et brosser au crin de cheval.',
    it: 'Sciogliere la sciolina a 130°C col ferro, raschiare con spatola in plexiglas e spazzolare con crine.',
    da: 'Smelt voks med strygejern ved 130°C, skrab med akrylblad og poler med hestehårsbørste.',
    sv: 'Smält valla med strykjärn vid 130°C, sickla med akrylsickel och borsta med tagelborste.',
    no: 'Smelt voks med strykejern ved 130°C, sikle med akrylsikling og børst med hestehårbørste.'
  },
  'Iron in Toko LF Blue hydrocarbon wax at 130°C.': {
    en: 'Iron in Toko LF Blue hydrocarbon wax at 130°C.',
    tr: 'Toko LF Blue hidrokarbon vaksını 130°C\'de ütüleyin.',
    de: 'Toko LF Blue Hydrocarbon-Wachs bei 130°C einbügeln.',
    fr: 'Farter au fer chaud avec Toko LF Blue à 130°C.',
    it: 'Stendere a caldo la sciolina Toko LF Blue a 130°C.',
    da: 'Varm Toko LF Blue voks ind med strygejern ved 130°C.',
    sv: 'Stryk in Toko LF Blue valla vid 130°C.',
    no: 'Stryk inn Toko LF Blue voks ved 130°C.'
  },
  'Deburr edge damage with 600-grit diamond stone; maintain 88° side bevel and 0.7° base bevel.': {
    en: 'Deburr edge damage with 600-grit diamond stone; maintain 88° side bevel and 0.7° base bevel.',
    tr: 'Kenar çapaklarını 600 kum elmas taşla temizleyin; 88° yan açı ve 0,7° taban açısını koruyun.',
    de: 'Kanten mit 600er Diamantstein entgraten; 88° Seitenkanten- und 0,7° Belagskantenwinkel beibehalten.',
    fr: 'Ébavurer les carres avec une pierre diamantée 600 ; conserver un angle latéral de 88° et 0,7° côté semelle.',
    it: 'Sbavare le lamine con pietra diamantata grana 600; mantenere angolo laterale a 88° e 0,7° alla soletta.',
    da: 'Afgrat kanter med 600-korn diamantsten; bevar 88° sidevinkel og 0,7° sålvinkel.',
    sv: 'Grada av kanter med 600-kornig diamantsten; behåll 88° sidovinkel och 0,7° belagsvinkel.',
    no: 'Avgrad kanter med 600-kornet diamantstein; oppretthold 88° sidevinkel og 0,7° sålevinkel.'
  },
  'Verify boot sole length (BSL) forward pressure indicator and torque release values.': {
    en: 'Verify boot sole length (BSL) forward pressure indicator and torque release values.',
    tr: 'Ayakkabı taban uzunluğu (BSL) ileri basınç göstergesini ve tork bırakma değerlerini kontrol edin.',
    de: 'Sohlenlänge (BSL), Anpressdruck und Auslösewerte (Z-Wert) der Bindung überprüfen.',
    fr: 'Vérifier la longueur de semelle (BSL), l\'indicateur de poussée et les valeurs de déclenchement.',
    it: 'Controllare lunghezza scarpone (BSL), indicatore di spinta e valori di sgancio della taratura.',
    da: 'Tjek sållængde (BSL), fremadrettet trykindikator og udløserværdier.',
    sv: 'Kontrollera sulans längd (BSL), framåttrycksindikator och utlösningsvärden.',
    no: 'Sjekk sålelengde (BSL), fremadrettet trykkindikator og utløserverdier.'
  },
  'Apply thick layer of unscraped soft wax over edges to prevent off-season oxidation and rust.': {
    en: 'Apply thick layer of unscraped soft wax over edges to prevent off-season oxidation and rust.',
    tr: 'Sezon dışı paslanma ve oksidasyonu önlemek için kenarların üzerine kalın bir yumuşak vaks tabakası uygulayın.',
    de: 'Dicke Schicht ungeschabtes Weichwachs auftragen, um Kanten vor Sommer-Rost zu schützen.',
    fr: 'Appliquer une épaisse couche de fart doux non raclé sur les carres pour éviter la rouille.',
    it: 'Applicare uno spesso strato di sciolina morbida non raschiata sulle lamine per prevenire ruggine e ossidazione.',
    da: 'Påfør et tykt lag uskravet blød voks over kanterne mod rust under sommeropbevaring.',
    sv: 'Applicera ett tjockt lager osicklad mjuk valla över stålkanterna för att förhindra rost.',
    no: 'Påfør et tykt lag usiklet myk voks over stålkantene for å forhindre rust i sesongpausen.'
  },
  'Rinse pleated filter under cold tap water until water runs clear; air-dry 24h before refitting.': {
    en: 'Rinse pleated filter under cold tap water until water runs clear; air-dry 24h before refitting.',
    tr: 'Filtreyi su berraklaşana kadar soğuk musluk suyu altında durulayın; takmadan önce 24 saat kurutun.',
    de: 'Lamellenfilter unter fliessendem kaltem Wasser ausspülen und 24h an der Luft trocknen lassen.',
    fr: 'Rincer le filtre sous l\'eau froide jusqu\'à ce qu\'elle soit claire ; sécher 24h à l\'air libre.',
    it: 'Sciacquare il filtro sotto acqua fredda finché l\'acqua non è limpida; asciugare 24h prima del montaggio.',
    da: 'Skyl filteret under koldt vand til det er helt rent; lad lufttørre 24 timer før montering.',
    sv: 'Skölj filtret under kallt rinnande vatten tills vattnet är klart; lufttorka 24 timmar.',
    no: 'Skyll filteret under kaldt rennende vann til vannet er helt rent; la lufttørke i 24 timer.'
  },
  'Remove end cap, slide out brush bar, and clear wound hair and strings from ball bearings.': {
    en: 'Remove end cap, slide out brush bar, and clear wound hair and strings from ball bearings.',
    tr: 'Uç kapağı çıkarın, fırça çubuğunu kaydırarak çıkarın ve rulmanlardaki sarılmış saçları temizleyin.',
    de: 'Endkappe abnehmen, Bürstenwalze herausziehen und Haare von Kugellagern entfernen.',
    fr: 'Retirer l\'embout, faire glisser le rouleau et retirer les cheveux enroulés autour des roulements.',
    it: 'Rimuovere il cappuccio terminale, sfilare la spazzola e togliere capelli e fili dai cuscinetti.',
    da: 'Fjern endedækslet, træk børstestangen ud og fjern hår fra kuglelejerne.',
    sv: 'Ta bort ändlocket, skjut ut borstvalsen och rensa bort hår från kullagren.',
    no: 'Ta av endestykket, skyv ut børstestangen og rens bort hår fra kulelagrene.'
  },
  'Clear bin with damp microfiber cloth to remove static electro-dust deposits.': {
    en: 'Clear bin with damp microfiber cloth to remove static electro-dust deposits.',
    tr: 'Statik toz birikimini temizlemek için hazneyi nemli mikrofiber bezle silin.',
    de: 'Behälter mit leicht feuchtem Mikrofasertuch von statischen Staubablagerungen befreien.',
    fr: 'Essuyer le bac avec un chiffon microfibre humide pour éliminer les dépôts électrostatiques.',
    it: 'Pulire il contenitore con panno in microfibra umido per eliminare depositi elettrostatici.',
    da: 'Aftør beholderen med en fugtig mikrofiberklud for at fjerne statisk støv.',
    sv: 'Torka ur behållaren med en fuktig mikrofiberduk för att ta bort statiskt damm.',
    no: 'Tørk av beholderen med en fuktig mikrofiberklut for å fjerne statisk støv.'
  },
  'Allow automated panel compensation cycle to complete in standby without disconnecting power.': {
    en: 'Allow automated panel compensation cycle to complete in standby without disconnecting power.',
    tr: 'Güç bağlantısını kesmeden bekleme modunda otomatik panel dengeleme döngüsünün tamamlanmasını bekleyin.',
    de: 'Automatischen Pixel-Auffrischungszyklus im Standby durchführen lassen, ohne das Gerät vom Strom zu trennen.',
    fr: 'Laisser le cycle de compensation automatique se terminer en veille sans débrancher le téléviseur.',
    it: 'Consentire al ciclo di compensazione del pannello di completarsi in standby senza staccare la spina.',
    da: 'Lad det automatiske panelopfriskningsprogram køre færdigt i standby uden at afbryde strømmen.',
    sv: 'Låt den automatiska panelkompenseringen slutföras i standby utan att bryta strömmen.',
    no: 'La den automatiske paneloppfriskingen fullføres i standby uten å koble fra strømmen.'
  },
  'Gently vacuum rear heat exhaust vents with brush attachment to prevent thermal throttling.': {
    en: 'Gently vacuum rear heat exhaust vents with brush attachment to prevent thermal throttling.',
    tr: 'Aşırı ısınmayı önlemek için fırça ucuyla arka ısı tahliye deliklerini nazikçe süpürün.',
    de: 'Hintere Lüftungsschlitze vorsichtig mit Bürstenaufsatz absaugen, um Überhitzung zu vermeiden.',
    fr: 'Aspirer délicatement les grilles d\'aération arrière avec une brosse pour éviter la surchauffe.',
    it: 'Aspirare delicatamente le prese d\'aria posteriori con bocchetta a spazzola per evitare surriscaldamenti.',
    da: 'Støvsug forsigtigt de bageste ventilationsåbninger med børstemundstykke for at undgå overophedning.',
    sv: 'Dammsug försiktigt de bakre ventilationsöppningarna med borstmunstycke för att undvika överhettning.',
    no: 'Støvsug forsiktig de bakre ventilasjonsåpningene med børstemunnstykke for å unngå overoppheting.'
  },
  'Wipe display with dry optical-grade microfiber cloth; avoid alcohol or ammonia sprays.': {
    en: 'Wipe display with dry optical-grade microfiber cloth; avoid alcohol or ammonia sprays.',
    tr: 'Ekranı kuru optik mikrofiber bezle silin; alkol veya amonyaklı spreylerden kaçının.',
    de: 'Display vorsichtig mit optischem Mikrofasertuch abwischen; keine Alkohol- oder Ammoniakreiniger verwenden.',
    fr: 'Essuyer l\'écran avec un chiffon microfibre optique sec ; éviter l\'alcool et l\'ammoniaque.',
    it: 'Pulire lo schermo con panno in microfibra ottico asciutto; evitare spray contenenti alcool o ammoniaca.',
    da: 'Tør skærmen af med en tør optisk mikrofiberklud; undgå alkohol og ammoniak.',
    sv: 'Torka av skärmen med en torr optisk mikrofiberduk; undvik alkohol- eller ammoniaksprayer.',
    no: 'Tørk av skjermen med en tørr optisk mikrofiberklut; unngå alkohol- eller ammoniakksprayer.'
  },
  'Clean control dials and housing with non-abrasive damp microfiber cloth.': {
    en: 'Clean control dials and housing with non-abrasive damp microfiber cloth.',
    tr: 'Kontrol düğmelerini ve gövdeyi aşındırıcı olmayan nemli mikrofiber bezle temizleyin.',
    de: 'Bedienelemente und Gehäuse mit einem feuchten, nicht scheuernden Mikrofasertuch reinigen.',
    fr: 'Nettoyer les boutons et le boîtier avec un chiffon microfibre humide non abrasif.',
    it: 'Pulire le manopole di controllo e la scocca con un panno in microfibra umido non abrasivo.',
    da: 'Rengør betjeningsknapper og kabinet med en fugtig, ikke-slibende mikrofiberklud.',
    sv: 'Rengör reglage och hölje med en fuktig, icke-slipande mikrofiberduk.',
    no: 'Rengjør betjeningsknapper og hus med en fuktig, ikke-slipende mikrofiberklut.'
  },
  'Inspect power cables, seals, and removable intake filters for obstruction.': {
    en: 'Inspect power cables, seals, and removable intake filters for obstruction.',
    tr: 'Güç kablolarını, contaları ve çıkarılabilir giriş filtrelerini tıkanıklıklara karşı kontrol edin.',
    de: 'Netzkabel, Dichtungen und abnehmbare Filter auf Beschädigung oder Blockaden prüfen.',
    fr: 'Inspecter les câbles d\'alimentation, les joints et les filtres pour vérifier l\'absence d\'obstruction.',
    it: 'Ispezionare cavi di alimentazione, guarnizioni e filtri rimovibili da eventuali ostruzioni.',
    da: 'Efterse strømkabler, pakninger og aftagelige filtre for blokeringer.',
    sv: 'Inspektera strömkablar, tätningar och löstagbara filter för blockeringar.',
    no: 'Inspiser strømkabler, pakninger og avtakbare filtre for blokkeringer.'
  },
  'Verify safety cutoffs and perform routine self-test diagnostic.': {
    en: 'Verify safety cutoffs and perform routine self-test diagnostic.',
    tr: 'Güvenlik kesicilerini doğrulayın ve rutin otomatik test teşhisini gerçekleştirin.',
    de: 'Sicherheitsabschaltungen prüfen und routinemässigen Selbsttest durchführen.',
    fr: 'Vérifier les dispositifs de sécurité et effectuer l\'autodiagnostic de routine.',
    it: 'Verificare i blocchi di sicurezza ed eseguire il test diagnostico di routine.',
    da: 'Verificer sikkerhedsafbrydere og udfør rutinemæssig selvtest.',
    sv: 'Verifiera säkerhetsavstängningar och utför rutinmässig självtest.',
    no: 'Verifiser sikkerhetsbrytere og utfør rutinemessig selvtest.'
  }
};

export function translateMaintenanceTitle(title) {
  if (!title) return '';
  const currentLang = getLanguage();
  const langAlias = currentLang === 'nb' ? 'no' : currentLang;
  
  if (MAINTENANCE_TITLES[title]) {
    return MAINTENANCE_TITLES[title][langAlias] || MAINTENANCE_TITLES[title].en || title;
  }
  
  // Case-insensitive fallback
  const lower = title.trim().toLowerCase();
  for (const [k, obj] of Object.entries(MAINTENANCE_TITLES)) {
    if (k.toLowerCase() === lower) {
      return obj[langAlias] || obj.en || title;
    }
  }
  return title;
}

export function translateMaintenanceDetail(detail) {
  if (!detail) return '';
  const currentLang = getLanguage();
  const langAlias = currentLang === 'nb' ? 'no' : currentLang;
  
  if (MAINTENANCE_DETAILS[detail]) {
    return MAINTENANCE_DETAILS[detail][langAlias] || MAINTENANCE_DETAILS[detail].en || detail;
  }
  
  // Case-insensitive fallback
  const lower = detail.trim().toLowerCase();
  for (const [k, obj] of Object.entries(MAINTENANCE_DETAILS)) {
    if (k.toLowerCase() === lower) {
      return obj[langAlias] || obj.en || detail;
    }
  }
  return detail;
}

export function translateMaintenanceSummary(summary, brand = '', modelName = '', category = '') {
  if (!summary) return '';
  const currentLang = getLanguage();
  const langAlias = currentLang === 'nb' ? 'no' : currentLang;
  
  const cleanBrand = brand || '';
  const cleanModel = modelName || '';
  const combined = (summary + ' ' + category).toLowerCase();
  
  if (combined.includes('refrigeration') || combined.includes('refrigerator') || combined.includes('condenser') || combined.includes('kühlschrank') || combined.includes('buzdolabı')) {
    if (langAlias === 'tr') return `${cleanBrand} ${cleanModel} için buzdolabı kondansatörü, tahliye hattı ve kapı contası koruma protokolü.`.trim();
    if (langAlias === 'de') return `Kühlschrank-Kondensator-, Ablauf- und Türdichtungs-Wartungsprotokoll für ${cleanBrand} ${cleanModel}.`.trim();
    if (langAlias === 'fr') return `Protocole d\'entretien du condenseur, du drain et des joints de porte pour ${cleanBrand} ${cleanModel}.`.trim();
    if (langAlias === 'it') return `Protocollo di conservazione condensatore, tubo di scarico e guarnizioni per ${cleanBrand} ${cleanModel}.`.trim();
    if (langAlias === 'da') return `Kondensator-, afløbs- og dørpakningsvedligeholdelse for ${cleanBrand} ${cleanModel}.`.trim();
    if (langAlias === 'sv') return `Underhållsprotokoll för kondensator, dränering och dörrtätning för ${cleanBrand} ${cleanModel}.`.trim();
    if (langAlias === 'no') return `Vedlikeholdsprotokoll for kondensator, avløp og dørpakning for ${cleanBrand} ${cleanModel}.`.trim();
    return `Refrigeration condenser, drain line, and door gasket preservation protocol for ${cleanBrand} ${cleanModel}.`.trim();
  }
  
  if (combined.includes('hydraulic circulation') || combined.includes('dishwasher') || combined.includes('geschirrspüler') || combined.includes('bulaşık')) {
    if (langAlias === 'tr') return `${cleanBrand} ${cleanModel} için hidrolik sirkülasyon, kireç koruması ve filtre hijyen protokolü.`.trim();
    if (langAlias === 'de') return `Hydraulikzirkulations-, Entkalkungs- und Filterhygiene-Protokoll für ${cleanBrand} ${cleanModel}.`.trim();
    if (langAlias === 'fr') return `Protocole de circulation hydraulique, protection anticalcaire et assainissement des filtres pour ${cleanBrand} ${cleanModel}.`.trim();
    if (langAlias === 'it') return `Protocollo di circolazione idraulica, protezione anticalcare e igienizzazione filtri per ${cleanBrand} ${cleanModel}.`.trim();
    if (langAlias === 'da') return `Hydraulisk cirkulation, afkalkning og filterrensning for ${cleanBrand} ${cleanModel}.`.trim();
    if (langAlias === 'sv') return `Hydraulisk cirkulation, avkalkning och filterrengöring för ${cleanBrand} ${cleanModel}.`.trim();
    if (langAlias === 'no') return `Hydraulisk sirkulasjon, avkalking og filterrensing for ${cleanBrand} ${cleanModel}.`.trim();
    return `Hydraulic circulation, lime scale protection, and filter sanitization protocol for ${cleanBrand} ${cleanModel}.`.trim();
  }
  
  if (combined.includes('thermal sensor') || combined.includes('oven') || combined.includes('backofen') || combined.includes('fırın')) {
    if (langAlias === 'tr') return `${cleanBrand} ${cleanModel} için termal sensör, katalitik panel ve teleskopik ray bakım protokolü.`.trim();
    if (langAlias === 'de') return `Thermosensor-, Katalyseliner- und Teleskopschienen-Wartungsprotokoll für ${cleanBrand} ${cleanModel}.`.trim();
    if (langAlias === 'fr') return `Protocole d\'entretien du capteur thermique, des parois catalytiques et des rails télescopiques pour ${cleanBrand} ${cleanModel}.`.trim();
    if (langAlias === 'it') return `Protocollo di manutenzione per sensore termico, pareti catalitiche e guide telescopiche per ${cleanBrand} ${cleanModel}.`.trim();
    if (langAlias === 'da') return `Termosensor-, katalytisk foring- og teleskopskinnevedligeholdelse for ${cleanBrand} ${cleanModel}.`.trim();
    if (langAlias === 'sv') return `Underhållsprotokoll för termosensor, katalytiska paneler och utdragsskenor för ${cleanBrand} ${cleanModel}.`.trim();
    if (langAlias === 'no') return `Vedlikeholdsprotokoll for termosensor, katalytiske paneler og teleskopskinner for ${cleanBrand} ${cleanModel}.`.trim();
    return `Thermal sensor, catalytic liner, and telescopic rail maintenance protocol for ${cleanBrand} ${cleanModel}.`.trim();
  }

  if (combined.includes('automated floorcare') || combined.includes('robot') || combined.includes('roborock') || combined.includes('roomba') || combined.includes('dreame')) {
    if (langAlias === 'tr') return `${cleanBrand} ${cleanModel} için otomatik zemin hijyeni ve sensör bakım protokolü.`.trim();
    if (langAlias === 'de') return `Automatisierte Bodenpflege-Hygiene und Sensor-Wartung für ${cleanBrand} ${cleanModel}.`.trim();
    if (langAlias === 'fr') return `Protocole d\'hygiène et d\'entretien des capteurs pour ${cleanBrand} ${cleanModel}.`.trim();
    if (langAlias === 'it') return `Protocollo di igiene e manutenzione sensori per ${cleanBrand} ${cleanModel}.`.trim();
    if (langAlias === 'da') return `Automatiseret gulvpleje og sensorvedligeholdelse for ${cleanBrand} ${cleanModel}.`.trim();
    if (langAlias === 'sv') return `Automatiserad golvvård och sensorunderhåll för ${cleanBrand} ${cleanModel}.`.trim();
    if (langAlias === 'no') return `Automatisert gulvpleie og sensorvedlikehold for ${cleanBrand} ${cleanModel}.`.trim();
    return `Automated floorcare hygiene and sensor maintenance protocol for ${cleanBrand} ${cleanModel}.`.trim();
  }

  if (combined.includes('hygiene protocols to maintain a-class') || combined.includes('washing') || combined.includes('laundry') || combined.includes('çamaşır') || combined.includes('waschmaschine')) {
    if (langAlias === 'tr') return `A sınıfı enerji verimliliğini korumak ve kireç oluşumunu önlemek için periyodik ${cleanBrand} hijyen protokolü.`.trim();
    if (langAlias === 'de') return `Geplante ${cleanBrand} Hygieneprotokolle ausführen, um Energieeffizienz zu sichern und Kalk vorzubeugen.`.trim();
    if (langAlias === 'fr') return `Exécuter les protocoles d\'hygiène ${cleanBrand} pour maintenir l\'efficacité énergétique et prévenir le tartre.`.trim();
    if (langAlias === 'it') return `Eseguire i protocolli di igiene ${cleanBrand} per mantenere l'efficienza energetica e prevenire il calcare.`.trim();
    if (langAlias === 'da') return `Gennemfør planlagte ${cleanBrand} hygiejneprotokoller for at opretholde energieffektivitet og forhindre kalk.`.trim();
    if (langAlias === 'sv') return `Utför schemalagda ${cleanBrand} hygienprotokoll för att bibehålla energieffektivitet och förhindra kalk.`.trim();
    if (langAlias === 'no') return `Utfør planlagte ${cleanBrand} hygieneprotokoller for å opprettholde energieffektivitet og forhindre kalk.`.trim();
    return `Execute scheduled ${cleanBrand} hygiene protocols to maintain A-class energy efficiency and prevent scale buildup.`.trim();
  }

  if (combined.includes('barista hygiene') || combined.includes('lattego rinse') || combined.includes('coffee') || combined.includes('espresso') || combined.includes('kahve') || combined.includes('kaffee')) {
    if (langAlias === 'tr') return `Termoblok hidroliğini korumak ve mükemmel krema elde etmek için ${cleanBrand} barista bakım standartları.`.trim();
    if (langAlias === 'de') return `Barista-Hygienestandards für ${cleanBrand} befolgen, um Thermoblock-Hydraulik zu schützen und perfekte Crema zu extrahieren.`.trim();
    if (langAlias === 'fr') return `Suivre les standards d\'hygiène barista pour ${cleanBrand} afin de protéger le thermobloc et réussir la crème.`.trim();
    if (langAlias === 'it') return `Seguire gli standard di igiene barista per ${cleanBrand} per proteggere il termoblocco ed estrarre una crema perfetta.`.trim();
    if (langAlias === 'da') return `Følg barista-hygiejnestandarder for ${cleanBrand} for at beskytte termoblokken og udtrække optimal crema.`.trim();
    if (langAlias === 'sv') return `Följ baristahygienstandarder för ${cleanBrand} för att skydda termoblocket och extrahera perfekt crema.`.trim();
    if (langAlias === 'no') return `Følg baristahygienestandarder for ${cleanBrand} for å beskytte termoblokken og trekke ut perfekt crema.`.trim();
    return `Follow Swiss barista hygiene standards for ${cleanBrand} to protect thermoblock hydraulics and extract pristine crema.`.trim();
  }

  if (combined.includes('drivetrain, suspension') || combined.includes('ebike') || combined.includes('bike') || combined.includes('bisiklet') || combined.includes('velo')) {
    if (langAlias === 'tr') return `${cleanBrand} e-bisiklet için aktarma organı, süspansiyon ve batarya telemetri bakım protokolü.`.trim();
    if (langAlias === 'de') return `Proaktive Antriebs-, Federungs- und Akku-Wartung für ${cleanBrand} E-Bike.`.trim();
    if (langAlias === 'fr') return `Entretien proactif de la transmission, de la suspension et de la batterie pour vélo électrique ${cleanBrand}.`.trim();
    if (langAlias === 'it') return `Manutenzione proattiva di trasmissione, sospensioni e telemetria batteria per e-bike ${cleanBrand}.`.trim();
    if (langAlias === 'da') return `Proaktiv transmission-, affjedring- og batterivedligeholdelse for ${cleanBrand} elcykel.`.trim();
    if (langAlias === 'sv') return `Proaktivt underhåll av drivlina, dämpning och batteritelemetri för ${cleanBrand} elcykel.`.trim();
    if (langAlias === 'no') return `Proaktivt vedlikehold av drivlinje, demping og batteritelemetri for ${cleanBrand} elsykkel.`.trim();
    return `Proactive drivetrain, suspension, and battery telemetry maintenance for ${cleanBrand} e-bike.`.trim();
  }

  if (combined.includes('alpine race service') || combined.includes('hydrocarbon base saturation') || combined.includes('ski') || combined.includes('kayak')) {
    if (langAlias === 'tr') return `Kenar tutuşu ve florürsüz kayma performansı için ${cleanBrand} kayak yarış servis protokolü.`.trim();
    if (langAlias === 'de') return `Alpin-Rennservice-Protokoll für ${cleanBrand} Ski für perfekten Kantengriff und fluorfreies Gleiten.`.trim();
    if (langAlias === 'fr') return `Protocole de service de course alpine pour skis ${cleanBrand} garantissant accroche et glisse sans fluor.`.trim();
    if (langAlias === 'it') return `Protocollo di manutenzione race alpina per sci ${cleanBrand} per garantire tenuta di spigolo e scorrevolezza.`.trim();
    if (langAlias === 'da') return `Alpin racerserviceprotokol for ${cleanBrand} ski for at sikre kantgreb og fluorfri glid.`.trim();
    if (langAlias === 'sv') return `Alpin raceserviceprotokoll för ${cleanBrand} skidor för att säkerställa kantgrepp och fluorfri glid.`.trim();
    if (langAlias === 'no') return `Alpin racerserviceprotokoll for ${cleanBrand} ski for å sikre kantgrep og fluorfri glid.`.trim();
    return `Alpine race service protocol for ${cleanBrand} skis to ensure edge bite and fluor-free glide.`.trim();
  }

  if (combined.includes('whole-machine filtration') || combined.includes('vacuum') || combined.includes('süpürge') || combined.includes('staubsauger')) {
    if (langAlias === 'tr') return `${cleanBrand} için komple filtre sistemi ve fırça silindiri bakım protokolü.`.trim();
    if (langAlias === 'de') return `Gesamtsystem-Filtrations- und Bürstenwalzen-Wartungsprotokoll für ${cleanBrand}.`.trim();
    if (langAlias === 'fr') return `Protocole d\'entretien de la filtration et de la brosse motorisée pour ${cleanBrand}.`.trim();
    if (langAlias === 'it') return `Protocollo di manutenzione filtrazione e spazzola motorizzata per ${cleanBrand}.`.trim();
    if (langAlias === 'da') return `Filtrerings- og børsterullevedligeholdelse for ${cleanBrand}.`.trim();
    if (langAlias === 'sv') return `Underhållsprotokoll för helmaskinsfiltrering och borstvals för ${cleanBrand}.`.trim();
    if (langAlias === 'no') return `Vedlikeholdsprotokoll for helmaskinsfiltrering og børstevalse for ${cleanBrand}.`.trim();
    return `Whole-machine filtration and motorbar maintenance protocol for ${cleanBrand}.`.trim();
  }

  if (combined.includes('panel longevity') || combined.includes('television') || combined.includes('tv') || combined.includes('televizyon') || combined.includes('fernseher')) {
    if (langAlias === 'tr') return `${cleanBrand} için panel ömrü ve termal yönetim bakım protokolü.`.trim();
    if (langAlias === 'de') return `Panel-Langlebigkeits- und Wärmemanagement-Protokoll für ${cleanBrand}.`.trim();
    if (langAlias === 'fr') return `Protocole de longévité de la dalle et de gestion thermique pour ${cleanBrand}.`.trim();
    if (langAlias === 'it') return `Protocollo di longevità del pannello e gestione termica per ${cleanBrand}.`.trim();
    if (langAlias === 'da') return `Panellangtids- og varmestyringsvedligeholdelse for ${cleanBrand}.`.trim();
    if (langAlias === 'sv') return `Underhållsprotokoll för panellivslängd och värmehantering för ${cleanBrand}.`.trim();
    if (langAlias === 'no') return `Vedlikeholdsprotokoll for panellevetid og termisk styring for ${cleanBrand}.`.trim();
    return `Panel longevity and thermal management protocol for ${cleanBrand}.`.trim();
  }

  if (langAlias === 'tr') return `${cleanBrand} ${cleanModel} için üretici rutin bakım ve kontrol protokolü.`.trim();
  if (langAlias === 'de') return `Regelmässiges Herstellerpflege- und Inspektionsprotokoll für ${cleanBrand} ${cleanModel}.`.trim();
  if (langAlias === 'fr') return `Protocole d'inspection et d\'entretien périodique constructeur pour ${cleanBrand} ${cleanModel}.`.trim();
  if (langAlias === 'it') return `Protocollo di cura e ispezione periodica del produttore per ${cleanBrand} ${cleanModel}.`.trim();
  if (langAlias === 'da') return `Producentens rutinemæssige pleje- og inspektionsprotokol for ${cleanBrand} ${cleanModel}.`.trim();
  if (langAlias === 'sv') return `Tillverkarens rutinmässiga skötsel- och inspektionsprotokoll för ${cleanBrand} ${cleanModel}.`.trim();
  if (langAlias === 'no') return `Produsentens rutinemessige pleie- og inspeksjonsprotokoll for ${cleanBrand} ${cleanModel}.`.trim();
  return summary;
}


export const PARTS_DICTIONARY = {
  "FreshAir Activated Carbon Antibacterial Air Filter": {
    "en": "FreshAir Activated Carbon Antibacterial Air Filter",
    "tr": "FreshAir Aktif Karbon Antibakteriyel Hava Filtresi",
    "de": "FreshAir Aktivkohle-Antibakterieller Luftfilter",
    "fr": "Filtre à air antibactérien au charbon actif FreshAir",
    "it": "Filtro aria antibatterico a carboni attivi FreshAir",
    "da": "FreshAir aktivt kul antibakterielt luftfilter",
    "sv": "FreshAir aktivt kol antibakteriellt luftfilter",
    "no": "FreshAir aktivt kull antibakterielt luftfilter"
  },
  "Internal Water Dispenser & Ice Maker Inline Filter": {
    "en": "Internal Water Dispenser & Ice Maker Inline Filter",
    "tr": "Dahili Su Sebili & Buz Yapıcı Hat Filtresi",
    "de": "Integrierter Wasserspender & Eiswürfelbereiter-Filter",
    "fr": "Filtre en ligne distributeur d\'eau et machine à glaçons",
    "it": "Filtro in linea per erogatore d'acqua e fabbricatore di ghiaccio",
    "da": "Indbygget vanddispenser & isterningmaskine inline-filter",
    "sv": "Inbyggt vattenfilter för dispenser och ismaskin",
    "no": "Innebygd vannfilter for dispenser og isbitmaskin"
  },
  "Magnetic Silicone Door Perimeter Gasket": {
    "en": "Magnetic Silicone Door Perimeter Gasket",
    "tr": "Manyetik Silikon Kapı Çevre Contası",
    "de": "Magnetische Silikon-Türdichtung",
    "fr": "Joint périmétrique magnétique de porte en silicone",
    "it": "Guarnizione perimetrale magnetica in silicone per porta",
    "da": "Magnetisk silikonedørpakning",
    "sv": "Magnetisk silikondörrtätning",
    "no": "Magnetisk silikondørpakning"
  },
  "OEM Intensive Machine Cleaner & Descaler Tabs (4-Pack)": {
    "en": "OEM Intensive Machine Cleaner & Descaler Tabs (4-Pack)",
    "tr": "OEM Yoğun Makine Temizleyici & Kireç Çözücü Tablet (4'lü Paket)",
    "de": "OEM Intensiv-Maschinenreiniger & Entkalkertabs (4er-Pack)",
    "fr": "Pastilles nettoyantes intensives et détartrantes OEM (Pack de 4)",
    "it": "Pastiglie anticalcare e detergente intensivo OEM (Conf. da 4)",
    "da": "OEM intensiv maskinrens og afkalkningstabletter (4-pak)",
    "sv": "OEM intensiv maskinrengöring och avkalkningstabletter (4-pack)",
    "no": "OEM intensiv maskinrens og avkalkingstabletter (4-pakning)"
  },
  "Stainless Steel Sump Microfilter Assembly": {
    "en": "Stainless Steel Sump Microfilter Assembly",
    "tr": "Paslanmaz Çelik Taban Mikrofiltre Grubu",
    "de": "Edelstahl-Pumpensumpf-Mikrofiltereinheit",
    "fr": "Ensemble microfiltre de cuve en acier inoxydable",
    "it": "Gruppo microfiltro della vasca in acciaio inossidabile",
    "da": "Rustfrit stål bundmikrofilter-enhed",
    "sv": "Rostfritt stål bottenmikrofilterenhet",
    "no": "Rustfritt stål bunnmikrofilter-enhet"
  },
  "Upper & Lower Rotating Spray Arm Set": {
    "en": "Upper & Lower Rotating Spray Arm Set",
    "tr": "Üst & Alt Döner Püskürtme Kolu Seti",
    "de": "Oberer & unterer rotierender Sprüharm-Satz",
    "fr": "Jeu de bras d\'aspersion rotatifs supérieur et inférieur",
    "it": "Set bracci irroratori rotanti superiore e inferiore",
    "da": "Sæt med øvre og nedre roterende spulearme",
    "sv": "Sats med övre och undre roterande spolarmsarmar",
    "no": "Sett med øvre og nedre roterende spylearmer"
  },
  "AquaStop Safety Double-Walled Inlet Hose": {
    "en": "AquaStop Safety Double-Walled Inlet Hose",
    "tr": "AquaStop Çift Cidarlı Emniyet Giriş Hortumu",
    "de": "AquaStop doppelwandiger Sicherheits-Zulaufschlauch",
    "fr": "Tuyau d'arrivée d\'eau de sécurité à double paroi AquaStop",
    "it": "Tubo di carico di sicurezza a doppia parete AquaStop",
    "da": "AquaStop dobbeltvægget sikkerhedstilløbsslange",
    "sv": "AquaStop dubbelväggig säkerhetstilloppsslang",
    "no": "AquaStop dobbeltvegget sikkerhetstilløpsslange"
  },
  "ActiveClean Odor Catalytic Odor Filter Cartridge": {
    "en": "ActiveClean Odor Catalytic Odor Filter Cartridge",
    "tr": "ActiveClean Katalitik Koku Filtresi Kartuşu",
    "de": "ActiveClean katalytische Geruchsfilter-Patrone",
    "fr": "Cartouche filtrante catalytique anti-odeurs ActiveClean",
    "it": "Cartuccia filtro catalitico antiodore ActiveClean",
    "da": "ActiveClean katalytisk lugtfilterpatron",
    "sv": "ActiveClean katalytisk luktfilterpatron",
    "no": "ActiveClean katalytisk luktfilterpatron"
  },
  "Telescopic Full-Extension Oven Shelf Runners": {
    "en": "Telescopic Full-Extension Oven Shelf Runners",
    "tr": "Teleskopik Tam Açılır Fırın Rafı Rayları",
    "de": "Teleskop-Vollauszugschienen für Backofen",
    "fr": "Rails télescopiques à sortie totale pour four",
    "it": "Guide telescopiche a estrazione totale per forno",
    "da": "Teleskopudtræksskinner til ovn",
    "sv": "Teleskoputdragsskenor för ugn",
    "no": "Teleskoputtrekksskinner for ovn"
  },
  "High-Temperature Silicone Cavity Door Seal": {
    "en": "High-Temperature Silicone Cavity Door Seal",
    "tr": "Yüksek Sıcaklık Silikon Fırın Kapak Contası",
    "de": "Hochtemperatur-Silikon-Backraumdichtung",
    "fr": "Joint de porte de four en silicone haute température",
    "it": "Guarnizione porta forno in silicone per alte temperature",
    "da": "Højtemperatur silikonedørpakning til ovn",
    "sv": "Högtemperatur silikontätning för ugnslucka",
    "no": "Høytemperatur silikondørpakning for ovn"
  },
  "DuoRoller Counter-Rotating Rubber Roller Set (Pair)": {
    "en": "DuoRoller Counter-Rotating Rubber Roller Set (Pair)",
    "tr": "DuoRoller Çift Yönlü Kauçuk Silindir Fırça Seti (Çift)",
    "de": "DuoRoller gegenläufiges Gummiwalzen-Set (Paar)",
    "fr": "Jeu de rouleaux en caoutchouc contrarotatifs DuoRoller (Paire)",
    "it": "Set rulli in gomma controrotanti DuoRoller (Coppia)",
    "da": "DuoRoller modroterende gummirullesæt (Par)",
    "sv": "DuoRoller motroterande gummivalsset (Par)",
    "no": "DuoRoller motroterende gummivalsesett (Par)"
  },
  "Washable E11 High-Efficiency Air Filter (2-Pack)": {
    "en": "Washable E11 High-Efficiency Air Filter (2-Pack)",
    "tr": "Yıkanabilir E11 Yüksek Verimli Hava Filtresi (2'li Paket)",
    "de": "Auswaschbarer E11 Hochleistungs-Luftfilter (2er-Pack)",
    "fr": "Filtre à air haute efficacité E11 lavable (Pack de 2)",
    "it": "Filtro aria ad alta efficienza E11 lavabile (Conf. da 2)",
    "da": "Vaskbart E11 højeffektivt luftfilter (2-pak)",
    "sv": "Tvättbart E11 högeffektivt luftfilter (2-pack)",
    "no": "Vaskbart E11 høyeffektivt luftfilter (2-pakning)"
  },
  "Side Sweeping Spinning Edge Brush (2-Pack)": {
    "en": "Side Sweeping Spinning Edge Brush (2-Pack)",
    "tr": "Dönen Kenar Süpürme Fırçası (2'li Paket)",
    "de": "Rotierende Seitenbürsten (2er-Pack)",
    "fr": "Brosses latérales rotatives pour bordures (Pack de 2)",
    "it": "Spazzole laterali rotanti per bordi (Conf. da 2)",
    "da": "Roterende sidebørster (2-pak)",
    "sv": "Roterande sidoborstar (2-pack)",
    "no": "Roterende sidebørster (2-pakning)"
  },
  "Microfiber Floor Mopping Cloth Pads (3-Pack)": {
    "en": "Microfiber Floor Mopping Cloth Pads (3-Pack)",
    "tr": "Mikrofiber Zemin Paspas Bezi Pedleri (3'lü Paket)",
    "de": "Mikrofaser-Wischpads (3er-Pack)",
    "fr": "Patins de nettoyage de sol en microfibre (Pack de 3)",
    "it": "Panni lavapavimenti in microfibra (Conf. da 3)",
    "da": "Mikrofiber gulvmoppepuder (3-pak)",
    "sv": "Mikrofiber golvmoppdynor (3-pack)",
    "no": "Mikrofiber gulvmoppeputer (3-pakning)"
  },
  "OEM Drum Hygiene & Descale Formula (3-Pack)": {
    "en": "OEM Drum Hygiene & Descale Formula (3-Pack)",
    "tr": "OEM Kazan Hijyeni & Kireç Çözücü Formül (3'lü Paket)",
    "de": "OEM Trommelhygiene- & Entkalker-Formel (3er-Pack)",
    "fr": "Formule détartrante et d\'hygiène du tambour OEM (Pack de 3)",
    "it": "Formula anticalcare e igienizzante per cestello OEM (Conf. da 3)",
    "da": "OEM tromlehygiejne og afkalkningsmiddel (3-pak)",
    "sv": "OEM trumhygien och avkalkningsmedel (3-pack)",
    "no": "OEM trommelhygiene og avkalkingsmiddel (3-pakning)"
  },
  "Inlet Hose Silt & Sand Water Filter Mesh": {
    "en": "Inlet Hose Silt & Sand Water Filter Mesh",
    "tr": "Giriş Hortumu Tortu & Kum Su Filtresi Filtre Ağı",
    "de": "Zulaufschlauch-Feinsieb gegen Sand und Sedimente",
    "fr": "Filtre fin pour tuyau d'arrivée d\'eau contre les sédiments",
    "it": "Filtro a rete per tubo di carico contro sedimenti e sabbia",
    "da": "Tilløbsslange-si mod sand og urenheder",
    "sv": "Tilloppsslangssil mot sand och partiklar",
    "no": "Tilløpsslangesil mot sand og partikler"
  },
  "Silicone Door Bellow Gasket Conditioning Balm": {
    "en": "Silicone Door Bellow Gasket Conditioning Balm",
    "tr": "Silikon Körük Contası Bakım Balsamı",
    "de": "Silikon-Türmanschetten-Pflegebalsam",
    "fr": "Baume d\'entretien pour joint soufflet de porte en silicone",
    "it": "Balsamo protettivo per guarnizione soffietto oblò in silicone",
    "da": "Silikonebælg-plejebalsam til lågepakning",
    "sv": "Silikonbälg-vårdande balsam för lucktätning",
    "no": "Silikonbelg-pleiende balsam for dørtetning"
  },
  "Anti-Vibration Acoustic Damper Feet (Set of 4)": {
    "en": "Anti-Vibration Acoustic Damper Feet (Set of 4)",
    "tr": "Titreşim Önleyici Akustik Ayaklar (4'lü Set)",
    "de": "Antivibrations-Dämpferfüsse (4er-Set)",
    "fr": "Pieds amortisseurs antivibrations (Lot de 4)",
    "it": "Piedini antivibrazione fonoassorbenti (Set da 4)",
    "da": "Antivibrationsfødder (Sæt med 4)",
    "sv": "Vibrationsdämpande fötter (Sats med 4)",
    "no": "Vibrasjonsdempende føtter (Sett med 4)"
  },
  "Water Softener Ionic Resin Filter Cartridge": {
    "en": "Water Softener Ionic Resin Filter Cartridge",
    "tr": "Su Yumuşatıcı İyonik Reçine Filtre Kartuşu",
    "de": "Wasserenthärter-Filterpatrone mit Ionenharz",
    "fr": "Cartouche filtrante anticalcaire à résine ionique",
    "it": "Cartuccia filtro a resina ionica per addolcimento acqua",
    "da": "Vandblødgørende ionbytterfilterpatron",
    "sv": "Avhärdande jonbytarfilterpatron",
    "no": "Vannavherdende ionebytterfilterpatron"
  },
  "EcoDecalk Multi-Dose Organic Descaler 500ml": {
    "en": "EcoDecalk Multi-Dose Organic Descaler 500ml",
    "tr": "EcoDecalk Çoklu Doz Organik Kireç Çözücü 500ml",
    "de": "EcoDecalk organischer Mehrfachdosis-Entkalker 500ml",
    "fr": "Détartrant écologique multi-doses EcoDecalk 500ml",
    "it": "Decalcificante biologico multidose EcoDecalk 500ml",
    "da": "EcoDecalk økologisk multiafkalker 500ml",
    "sv": "EcoDecalk ekologisk multiavkalkare 500ml",
    "no": "EcoDecalk økologisk multiavkalker 500ml"
  },
  "Food-Grade Brew Group Silicone Grease & O-Rings": {
    "en": "Food-Grade Brew Group Silicone Grease & O-Rings",
    "tr": "Gıda Uyumlu Demleme Grubu Silikon Gres & O-Ring Seti",
    "de": "Lebensmittelechtes Brühgruppen-Silikonfett & O-Ringe",
    "fr": "Graisse silicone alimentaire pour groupe café et joints toriques",
    "it": "Grasso al silicone alimentare per gruppo caffè e guarnizioni O-Ring",
    "da": "Fødevaregodkendt silikonefedt og O-ringe til bryggegruppe",
    "sv": "Livsmedelsgodkänt silikonfett och O-ringar för bryggrupp",
    "no": "Næringsmiddelgodkjent silikonfett og O-ringer for bryggegruppe"
  },
  "Milk Circuit Sanitizing Solution & Brush Set": {
    "en": "Milk Circuit Sanitizing Solution & Brush Set",
    "tr": "Süt Sistemi Dezenfeksiyon Solüsyonu & Fırça Seti",
    "de": "Milchsystem-Reinigungslösung & Bürstenset",
    "fr": "Solution désinfectante pour circuit de lait et set de goupillons",
    "it": "Soluzione igienizzante per circuito latte e set scovolini",
    "da": "Rengøringsmiddel og børstesæt til mælkesystem",
    "sv": "Rengöringsmedel och borstsats för mjölksystem",
    "no": "Rengjøringsmiddel og børstesett for melkesystem"
  },
  "AquaClean Calc and Water Filter": {
    "en": "AquaClean Calc and Water Filter",
    "tr": "AquaClean Kireç ve Su Filtresi",
    "de": "AquaClean Kalk- und Wasserfilter",
    "fr": "Filtre à eau et anticalcaire AquaClean",
    "it": "Filtro acqua e anticalcare AquaClean",
    "da": "AquaClean kalk- og vandfilter",
    "sv": "AquaClean kalk- och vattenfilter",
    "no": "AquaClean kalk- og vannfilter"
  },
  "Special Decalcifier Solution (250ml)": {
    "en": "Special Decalcifier Solution (250ml)",
    "tr": "Özel Kireç Çözücü Solüsyon (250ml)",
    "de": "Spezial-Entkalkerlösung (250ml)",
    "fr": "Solution détartrante spéciale (250ml)",
    "it": "Soluzione decalcificante speciale (250ml)",
    "da": "Special afkalkningsopløsning (250ml)",
    "sv": "Specialavkalkningslösning (250ml)",
    "no": "Spesialavkalingsløsning (250ml)"
  }
};

export function translatePartName(name) {
  if (!name) return '';
  const currentLang = getLanguage();
  const langAlias = currentLang === 'nb' ? 'no' : currentLang;
  
  if (PARTS_DICTIONARY[name]) {
    return PARTS_DICTIONARY[name][langAlias] || PARTS_DICTIONARY[name].en || name;
  }
  
  const lower = name.trim().toLowerCase();
  for (const [k, obj] of Object.entries(PARTS_DICTIONARY)) {
    if (k.toLowerCase() === lower) {
      return obj[langAlias] || obj.en || name;
    }
  }
  return name;
}
