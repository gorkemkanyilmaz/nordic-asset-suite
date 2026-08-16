//
//  AssetSearchEngine.swift
//  AssetCoreSearch
//
//  Created for Nordic Asset Suite.
//  Strict Concurrency: Complete. Local Full-Text & High-Intent Search.
//

import Foundation
import AssetCoreDatabase
import AssetCoreKnowledgeBase

/// High-speed on-device search engine matching brand, model, serial, and maintenance problems.
public final class AssetSearchEngine: Sendable {
    public static let shared = AssetSearchEngine()
    
    private init() {}
    
    /// Matches user search query against cached assets and knowledge base specs.
    public func search<T: Identifiable>(items: [T], query: String, keyPath: (T) -> String) -> [T] {
        guard !query.trimmingCharacters(in: .whitespaces).isEmpty else { return items }
        let cleanQuery = query.lowercased()
        
        return items.filter { item in
            keyPath(item).lowercased().contains(cleanQuery)
        }
    }
}
