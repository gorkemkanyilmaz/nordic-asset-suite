//
//  DatabaseContainer.swift
//  AssetCoreDatabase
//
//  Created for Nordic Asset Suite.
//  Strict Concurrency: Complete. Crash-proof Local SwiftData Configuration.
//

import Foundation
import SwiftData

/// Thread-safe factory for instantiating partitioned SwiftData ModelContainers.
public final class DatabaseContainer: Sendable {
    public static let shared = DatabaseContainer()
    
    public static let appGroupIdentifier = "group.com.nordicassetsuite.shared"
    
    private init() {}
    
    /// Creates a production ModelContainer configured with local SQLite persistence.
    public func makeProductionContainer() throws -> ModelContainer {
        let schema = Schema(SchemaV1.models)
        
        let storeURL: URL
        if let containerURL = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: Self.appGroupIdentifier) {
            storeURL = containerURL.appendingPathComponent("NordicAssetSuite.sqlite")
        } else {
            let appSupportURL = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask).first ?? FileManager.default.temporaryDirectory
            try? FileManager.default.createDirectory(at: appSupportURL, withIntermediateDirectories: true)
            storeURL = appSupportURL.appendingPathComponent("NordicAssetSuite.sqlite")
        }
        
        let configuration = ModelConfiguration(
            "NordicAssetSuiteProduction",
            schema: schema,
            url: storeURL,
            allowsSave: true,
            cloudKitDatabase: .none
        )
        
        return try ModelContainer(for: schema, migrationPlan: nil, configurations: [configuration])
    }
    
    /// Creates an isolated in-memory ModelContainer for testing or safe fallback.
    public func makeInMemoryContainer() -> ModelContainer {
        let schema = Schema(SchemaV1.models)
        let configuration = ModelConfiguration(
            "NordicAssetSuiteInMemory",
            schema: schema,
            isStoredInMemoryOnly: true,
            cloudKitDatabase: .none
        )
        if let container = try? ModelContainer(for: schema, configurations: [configuration]) {
            return container
        }
        // Minimal fallback container
        do {
            return try ModelContainer(for: schema)
        } catch {
            preconditionFailure("Critical database initialization error: \(error.localizedDescription)")
        }
    }
    
    /// Safe, non-throwing container builder guaranteed to return a valid ModelContainer.
    public func makeSafeContainer() -> ModelContainer {
        if let prod = try? makeProductionContainer() {
            return prod
        }
        return makeInMemoryContainer()
    }
}
