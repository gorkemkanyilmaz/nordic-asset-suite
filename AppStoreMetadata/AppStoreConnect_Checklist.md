# App Store Connect — Pre-Submission Checklist

> Complete every item before clicking "Submit for Review" in App Store Connect.
> This checklist covers all 4 apps in the Nordic Asset Suite monorepo.

---

## 1. App Store Connect Portal Setup

### Per-App Configuration (repeat for each app)

| App | Bundle ID | Primary Category | Secondary Category |
|-----|-----------|------------------|--------------------|
| Appliance Warranty Manager | `com.nordicassetsuite.appliance` | Utilities | Lifestyle |
| Ski & Snowboard Gear Tuning | `com.nordicassetsuite.skigear` | Sports | Utilities |
| E-Bike Service & Maintenance | `com.nordicassetsuite.ebike` | Sports | Utilities |
| Coffee Brew & Espresso Log | `com.nordicassetsuite.coffee` | Food & Drink | Lifestyle |

- [ ] Create each app record in App Store Connect
- [ ] Set correct Primary & Secondary categories
- [ ] Set Age Rating to **4+** (all apps)
- [ ] Set Content Rights: "Does not contain third-party content"

---

## 2. Metadata — Localized Fields

> All metadata text files are in `fastlane/metadata/<scheme>/<locale>/`

### Supported Locales (8 per app)
`en-US` · `tr` · `de-DE` · `fr-FR` · `it` · `da` · `sv` · `nb`

- [ ] **App Name** (≤ 30 chars) — `name.txt`
- [ ] **Subtitle** (≤ 30 chars) — `subtitle.txt`
- [ ] **Keywords** (≤ 100 chars, comma-separated) — `keywords.txt`
- [ ] **Promotional Text** (≤ 170 chars) — `promotional_text.txt`
- [ ] **Description** (≤ 4000 chars) — `description.txt`
- [ ] **What's New / Release Notes** — `release_notes.txt`
- [ ] Verify zero keyword duplication across Name + Subtitle + Keywords per locale
- [ ] Run `fastlane deliver_all` with `submit_for_review: false` to validate metadata upload

---

## 3. Screenshots & App Previews

> Storyboard specifications in `AppStoreMetadata/ScreenshotStoryboards.md`

### Required Device Sizes
- [ ] iPhone 6.9" (iPhone 16 Pro Max) — 1320 × 2868 px
- [ ] iPhone 6.3" (iPhone 16 Pro) — 1206 × 2622 px
- [ ] iPad Pro 13" (M4) — 2064 × 2752 px

### Per-App Screenshot Sets
- [ ] **Appliance Warranty Manager**: Room dashboard, Rating Plate Scanner, Error Code Wizard, Warranty Timeline, Legal Notice Generator
- [ ] **Ski & Snowboard Gear Tuning**: Quiver Dashboard, DIN Calculator, Wax Advisor, Edge Tuning Log, Season Overview
- [ ] **E-Bike Service & Maintenance**: Garage Dashboard, Battery Health, Chain Wear Gauge, Suspension Setup, Ride Logbook
- [ ] **Coffee Brew & Espresso Log**: Barista Deck, Dial-In Journal, Water Hardness Lab, Descaling Horizon, Bean Tracker

### Localization
- [ ] EN screenshots with localized overlay text for each supported locale
- [ ] Place files in `fastlane/metadata/<scheme>/<locale>/screenshots/`

---

## 4. In-App Purchase Configuration

| App | IAP Product ID | Display Name | Type |
|-----|----------------|--------------|------|
| Appliance Warranty Manager | `com.nordicassetsuite.appliance.pro` | Pro Unlimited Warranty | Auto-Renewable |
| Ski & Snowboard Gear Tuning | `com.nordicassetsuite.skigear.pro` | Pro Race Pass | Auto-Renewable |
| E-Bike Service & Maintenance | `com.nordicassetsuite.ebike.pro` | Pro Fleet Pass | Auto-Renewable |
| Coffee Brew & Espresso Log | `com.nordicassetsuite.coffee.pro` | Pro Barista Pass | Auto-Renewable |

- [ ] Create subscription group per app
- [ ] Set pricing tiers (Tier 1–3 recommended for premium Nordic markets)
- [ ] Add localized IAP display names and descriptions
- [ ] Upload review screenshot for each IAP
- [ ] Verify StoreKit 2 Product IDs match `SubscriptionProduct.swift`

---

## 5. Privacy & Legal

> Full details in `AppStoreMetadata/PrivacyPolicy.md` and `AppStoreMetadata/TermsOfUse_EULA.md`

- [ ] **Privacy Policy URL** — Host and enter URL in App Store Connect
- [ ] **Privacy Nutrition Labels** — Configure per `AppStoreMetadata/PrivacyNutritionLabels.md`
  - [ ] Data Not Collected (all 4 apps — fully offline)
  - [ ] No tracking / No third-party analytics
- [ ] **EULA** — Upload custom EULA or accept Apple's standard terms
- [ ] **Terms of Use URL** — Host and enter URL

---

## 6. App Review Information

- [ ] **Contact Information**: Name, email, phone for App Review team
- [ ] **Demo Account**: Not required (no login system)
- [ ] **Review Notes**: Include the following for each app:
  ```
  This app works 100% offline. No account or login is required.
  All data is stored locally on-device. No cloud services are used 
  except optional iCloud sync (Pro feature).
  
  To test the camera scanner, point the device at any appliance 
  rating plate / ski binding / bike frame / espresso machine badge.
  
  The free tier allows up to 10 items. The Pro subscription unlocks 
  unlimited storage.
  ```
- [ ] **Guideline 4.3 Differentiation Proof**: Reference `AppStoreMetadata/AppStoreReviewGuideline4.3_Compliance.md`

---

## 7. Build & Signing

- [ ] Xcode Archive builds successfully for all 4 schemes
- [ ] `MARKETING_VERSION` set to target version in `project.yml`
- [ ] `CURRENT_PROJECT_VERSION` incremented
- [ ] `ITSAppUsesNonExemptEncryption` = `NO` (all 4 apps)
- [ ] Code signing with Apple Distribution certificate
- [ ] App Store provisioning profiles for all 4 bundle IDs
- [ ] IPA uploaded via `fastlane deploy_all` (TestFlight)
- [ ] TestFlight build processing completed
- [ ] Internal testing group verified on TestFlight

---

## 8. Release Configuration

- [ ] **Version Release**: Manual release (recommended for first submission)
- [ ] **Phased Release**: Enable for subsequent updates
- [ ] **Pricing**: Free (with IAP)
- [ ] **Availability**: Select target countries:
  - [ ] Switzerland 🇨🇭
  - [ ] Germany 🇩🇪
  - [ ] Austria 🇦🇹
  - [ ] Denmark 🇩🇰
  - [ ] Sweden 🇸🇪
  - [ ] Norway 🇳🇴
  - [ ] Türkiye 🇹🇷
  - [ ] United States 🇺🇸
  - [ ] United Kingdom 🇬🇧

---

## 9. Pre-Flight Validation

- [ ] Run `fastlane precheck` for each app
- [ ] Verify all metadata character limits
- [ ] Confirm no placeholder text remains
- [ ] Cross-reference ASO metadata with `ASO_Final_Metadata.md`
- [ ] Validate screenshot dimensions and count
- [ ] Check export compliance (no encryption = exempt)

---

## 10. Post-Submission Monitoring

- [ ] Monitor App Store Connect for review status updates
- [ ] Prepare responses for potential reviewer questions
- [ ] Keep `AppStoreReviewGuideline4.3_Compliance.md` readily accessible
- [ ] Plan TestFlight beta distribution per `TestFlight_Beta_Plan.md`

---

## Quick Reference: Fastlane Commands

```bash
# Upload builds to TestFlight
fastlane deploy_all

# Upload metadata & submit for App Review
fastlane deliver_all

# Validate metadata without submitting
fastlane deliver_all submit_for_review:false

# Run precheck validation
fastlane precheck
```

---

> **Last updated:** 2026-08-27
> **Source metadata:** `AppStoreMetadata/ASO_Final_Metadata.md`
> **Fastlane metadata:** `fastlane/metadata/<scheme>/<locale>/*.txt`
