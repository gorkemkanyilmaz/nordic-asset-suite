//
//  ProductImageSearchService.swift
//  AssetCoreAI
//
//  Created for Nordic Asset Suite.
//  Strict Concurrency: Complete. Automated Live Web/Shopping Image Search for Hardware & Electronics.
//

import Foundation

/// High-performance actor for searching and resolving real manufacturer and retail product images.
public actor ProductImageSearchService {
    public static let shared = ProductImageSearchService()
    
    private var cache: [String: String] = [:]
    
    private init() {}
    
    /// Searches for official product / shopping imagery given a brand and model.
    /// Uses real web shopping search and filters for high-quality product photography.
    public func searchProductImage(brand: String, model: String, category: String = "") async -> String? {
        // Fast-path: Never block automated unit tests or CI runner with network lookups
        if ProcessInfo.processInfo.environment["XCTestConfigurationFilePath"] != nil ||
           ProcessInfo.processInfo.environment["XCTestBundlePath"] != nil ||
           ProcessInfo.processInfo.processName.lowercased().contains("xctest") ||
           NSClassFromString("XCTest") != nil {
            return nil
        }
        
        let query = "\(brand) \(model)".trimmingCharacters(in: .whitespacesAndNewlines)
        guard !query.isEmpty else { return nil }
        
        let cacheKey = query.lowercased()
        if let cached = cache[cacheKey] {
            return cached
        }
        
        // 1. DuckDuckGo Shopping / Product Search
        if let found = await fetchViaDuckDuckGo(query: "\(query) official product") {
            cache[cacheKey] = found
            return found
        }
        
        return nil
    }
    
    private func fetchViaDuckDuckGo(query: String) async -> String? {
        guard let encoded = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
              let tokenUrl = URL(string: "https://duckduckgo.com/?q=\(encoded)") else {
            return nil
        }
        
        var request = URLRequest(url: tokenUrl)
        request.setValue("Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/122.0.0.0 Safari/537.36", forHTTPHeaderField: "User-Agent")
        request.timeoutInterval = 4.0
        
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200,
                  let html = String(data: data, encoding: .utf8) else {
                return nil
            }
            
            guard let vqd = extractVqd(from: html) else { return nil }
            guard let imgUrl = URL(string: "https://duckduckgo.com/i.js?l=us-en&o=json&q=\(encoded)&vqd=\(vqd)&f=,,,") else {
                return nil
            }
            
            var imgRequest = URLRequest(url: imgUrl)
            imgRequest.setValue("Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/122.0.0.0 Safari/537.36", forHTTPHeaderField: "User-Agent")
            imgRequest.timeoutInterval = 4.0
            
            let (imgData, imgResponse) = try await URLSession.shared.data(for: imgRequest)
            guard let imgHttpResponse = imgResponse as? HTTPURLResponse, imgHttpResponse.statusCode == 200 else {
                return nil
            }
            
            struct DDGResponse: Decodable, Sendable {
                struct Result: Decodable, Sendable {
                    let image: String
                }
                let results: [Result]
            }
            
            let decoded = try JSONDecoder().decode(DDGResponse.self, from: imgData)
            for res in decoded.results {
                let imgLower = res.image.lowercased()
                if !imgLower.hasSuffix(".svg") &&
                   !imgLower.contains("logo") &&
                   !imgLower.contains("trustpilot") &&
                   !imgLower.contains("avatar") &&
                   !imgLower.contains("badge") &&
                   !imgLower.contains("banner") {
                    return res.image
                }
            }
        } catch {
            return nil
        }
        
        return nil
    }
    
    private func extractVqd(from html: String) -> String? {
        if let range = html.range(of: "vqd=([0-9-]+)", options: .regularExpression) {
            let match = String(html[range])
            return match.replacingOccurrences(of: "vqd=", with: "")
        }
        if let range = html.range(of: "vqd=\"([^\"]+)\"", options: .regularExpression) {
            let match = String(html[range])
            return match.replacingOccurrences(of: "vqd=\"", with: "").replacingOccurrences(of: "\"", with: "")
        }
        return nil
    }
}
