# Nordic Asset Suite

A modular, privacy-first, offline-ready iOS ecosystem engineered in **Swift 6** and **SwiftUI** for high-income European and Nordic markets (Switzerland, Denmark, Austria, Norway, Sweden).

## Monorepo Architecture

```text
NordicAssetSuite/
├── AssetCore/                  # Swift 6 Modular Core Framework (15 Sub-Packages)
│   ├── Package.swift
│   └── Sources/
│       ├── Security/           # Keychain, CryptoKit, App Attest & PII Scrubber
│       ├── Localization/       # Multi-language regional engine (EN, DE, FR, IT, DA, SV, NO)
│       ├── Database/           # SwiftData VersionedSchema & @ModelActor engine
│       ├── OCR/                # Apple Vision receipt & serial recognition
│       ├── AI/                 # Cloudflare App Attest serverless proxy client
│       ├── Subscription/       # StoreKit 2 transaction & bundle entitlement manager
│       ├── CloudSync/          # CloudKit Private & Public database sync engine
│       ├── KnowledgeBase/      # Seed JSON catalog & dynamic cloud specifications
│       ├── UIComponents/       # Accessible design systems & unique theme tokens
│       ├── Search/             # Local full-text & intent search engine
│       ├── Reports/            # PDF warranty certificate generation
│       ├── Analytics/          # Privacy-preserving local telemetry
│       ├── Notifications/      # Local maintenance & warranty expiry scheduling
│       ├── ManufacturerSync/   # OEM maintenance protocol client
│       └── ImageEngine/        # Perspective correction & image pre-processing
├── ApplianceWarrantyManager/   # App 1: Room-based Home Appliance Platform
├── SkiGearTracker/             # App 2: Season-based DIN & Waxing Tracker
├── EBikeServiceTracker/        # App 3: Garage-based Telemetry & Wear Tracker
├── CoffeeMachineCompanion/     # App 4: Barista-based Descaling & Dial-In Companion
├── AppStoreMetadata/           # ASO Keyword strategies & Guideline 4.3 compliance proofs
├── Wireframes/                 # Information Architecture & interaction specifications
├── TestPlans/                  # StoreKit 2 configuration & XCTest plans
└── BuildScripts/               # CI/CD & verification scripts
```

## Security & Compliance
* **GDPR & Swiss FADP Compliant:** On-device PII masking prior to external diagnostic calls.
* **Zero Secrets in Binary:** Vendor API keys are isolated behind a Cloudflare Worker proxy with Apple App Attest hardware validation.
* **Apple Review Guideline 4.3 Guaranteed:** Four fully distinct visual themes, independent navigation paradigms, unique data models, and non-overlapping feature trees.
