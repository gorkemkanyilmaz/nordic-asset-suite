// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "AssetCore",
    defaultLocalization: "en",
    platforms: [
        .iOS(.v17),
        .macOS(.v14)
    ],
    products: [
        .library(
            name: "AssetCore",
            targets: [
                "AssetCoreDatabase",
                "AssetCoreOCR",
                "AssetCoreAI",
                "AssetCoreSearch",
                "AssetCoreReports",
                "AssetCoreAnalytics",
                "AssetCoreNotifications",
                "AssetCoreLocalization",
                "AssetCoreCloudSync",
                "AssetCoreSubscription",
                "AssetCoreSecurity",
                "AssetCoreUIComponents",
                "AssetCoreManufacturerSync",
                "AssetCoreKnowledgeBase",
                "AssetCoreImageEngine"
            ]
        )
    ],
    dependencies: [],
    targets: [
        // MARK: - Core Security & Foundation
        .target(
            name: "AssetCoreSecurity",
            dependencies: [],
            path: "Sources/Security"
        ),
        
        // MARK: - Core Localization
        .target(
            name: "AssetCoreLocalization",
            dependencies: [],
            path: "Sources/Localization",
            resources: [
                .process("Resources")
            ]
        ),

        // MARK: - Core UI Components (Design System Primitives)
        .target(
            name: "AssetCoreUIComponents",
            dependencies: [
                "AssetCoreLocalization",
                "AssetCoreAI",
                "AssetCoreImageEngine"
            ],
            path: "Sources/UIComponents"
        ),

        // MARK: - Core Database (SwiftData & Schema Engine)
        .target(
            name: "AssetCoreDatabase",
            dependencies: [
                "AssetCoreSecurity"
            ],
            path: "Sources/Database"
        ),

        // MARK: - Core Cloud Sync (CloudKit Engine)
        .target(
            name: "AssetCoreCloudSync",
            dependencies: [
                "AssetCoreDatabase",
                "AssetCoreSecurity"
            ],
            path: "Sources/CloudSync"
        ),

        // MARK: - Core Image Processing
        .target(
            name: "AssetCoreImageEngine",
            dependencies: [],
            path: "Sources/ImageEngine"
        ),

        // MARK: - Core OCR (Apple Vision)
        .target(
            name: "AssetCoreOCR",
            dependencies: [
                "AssetCoreImageEngine",
                "AssetCoreSecurity"
            ],
            path: "Sources/OCR"
        ),

        // MARK: - Core AI (App Attest Proxy & Fallback Engine)
        .target(
            name: "AssetCoreAI",
            dependencies: [
                "AssetCoreSecurity",
                "AssetCoreOCR"
            ],
            path: "Sources/AI"
        ),

        // MARK: - Core Knowledge Base
        .target(
            name: "AssetCoreKnowledgeBase",
            dependencies: [
                "AssetCoreDatabase",
                "AssetCoreCloudSync"
            ],
            path: "Sources/KnowledgeBase",
            resources: [
                .process("Resources")
            ]
        ),

        // MARK: - Core Manufacturer Sync
        .target(
            name: "AssetCoreManufacturerSync",
            dependencies: [
                "AssetCoreKnowledgeBase",
                "AssetCoreSecurity"
            ],
            path: "Sources/ManufacturerSync"
        ),

        // MARK: - Core Search Engine
        .target(
            name: "AssetCoreSearch",
            dependencies: [
                "AssetCoreDatabase",
                "AssetCoreKnowledgeBase"
            ],
            path: "Sources/Search"
        ),

        // MARK: - Core Subscription (StoreKit 2)
        .target(
            name: "AssetCoreSubscription",
            dependencies: [
                "AssetCoreSecurity",
                "AssetCoreUIComponents",
                "AssetCoreLocalization"
            ],
            path: "Sources/Subscription"
        ),

        // MARK: - Core Notifications
        .target(
            name: "AssetCoreNotifications",
            dependencies: [
                "AssetCoreDatabase"
            ],
            path: "Sources/Notifications"
        ),

        // MARK: - Core Reports (PDF Export)
        .target(
            name: "AssetCoreReports",
            dependencies: [
                "AssetCoreDatabase",
                "AssetCoreLocalization"
            ],
            path: "Sources/Reports"
        ),

        // MARK: - Core Analytics (Privacy-First Local Telemetry)
        .target(
            name: "AssetCoreAnalytics",
            dependencies: [],
            path: "Sources/Analytics"
        ),

        // MARK: - Test Targets
        .testTarget(
            name: "AssetCoreDatabaseTests",
            dependencies: ["AssetCoreDatabase"],
            path: "Tests/DatabaseTests"
        ),
        .testTarget(
            name: "AssetCoreSecurityTests",
            dependencies: ["AssetCoreSecurity"],
            path: "Tests/SecurityTests"
        ),
        .testTarget(
            name: "AssetCoreSubscriptionTests",
            dependencies: ["AssetCoreSubscription"],
            path: "Tests/SubscriptionTests"
        ),
        .testTarget(
            name: "AssetCoreOCRTests",
            dependencies: ["AssetCoreOCR", "AssetCoreImageEngine"],
            path: "Tests/OCRTests"
        ),
        .testTarget(
            name: "AssetCoreAITests",
            dependencies: ["AssetCoreAI", "AssetCoreSecurity", "AssetCoreOCR"],
            path: "Tests/AITests"
        ),
        .testTarget(
            name: "AssetCoreLocalizationTests",
            dependencies: ["AssetCoreLocalization"],
            path: "Tests/LocalizationTests"
        )
    ]
)
