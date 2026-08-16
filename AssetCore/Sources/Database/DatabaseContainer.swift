//
//  DatabaseContainer.swift
//  AssetCoreDatabase
//
//  Created for Nordic Asset Suite.
//  Strict Concurrency: Complete. App Group & SwiftData Configuration.
//

import Foundation
import SwiftData

/// Thread-safe factory for instantiating partitioned SwiftData ModelContainers.
public final class DatabaseContainer: Sendable {
    public static let shared = DatabaseContainer()
    
    public static let appGroupIdentifier = "group.com.nordicassetsuite.shared"
    
    private init() {}
    
    /// Creates a production ModelContainer configured with the shared App Group container directory.
    public func makeProductionContainer() throws -> ModelContainer {
        let schema = Schema(SchemaV1.models)
        
        let storeURL: URL
        if let containerURL = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: Self.appGroupIdentifier) {
            storeURL = containerURL.appendingPathComponent("NordicAssetSuite.sqlite")
        } else {
            // Fallback to standard Application Support directory if App Groups are not configured in test/sim
            let appSupportURL = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask).first!
            try? FileManager.default.createDirectory(at: appSupportURL, withIntermediateDirectories: true)
            storeURL = appSupportURL.appendingPathComponent("NordicAssetSuite.sqlite")
        }
        
        let configuration = ModelConfiguration(
            "NordicAssetSuiteProduction",
            schema: schema,
            url: storeURL,
            allowsSave: true,
            cloudKitDatabase: .private("iCloud.com.nordicassetsuite.assets")
        )
        
        return try ModelContainer(for: schema, migrationPlan: nil, configurations: [configuration])
    }
    
    /// Creates an isolated in-memory ModelContainer for unit testing and SwiftUI previews.
    public func makeInMemoryContainer() throws -> ModelContainer {
        let schema = Schema(SchemaV1.models)
        let configuration = ModelConfiguration(
            "NordicAssetSuiteInMemory",
            schema: schema,
            isStoredInMemoryOnly: true
        )
        return try ModelContainer(for: schema, configurations: [configuration])
    }
}
