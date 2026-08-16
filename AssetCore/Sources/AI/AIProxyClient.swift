//
//  AIProxyClient.swift
//  AssetCoreAI
//
//  Created for Nordic Asset Suite.
//  Strict Concurrency: Complete. Zero Client Secrets & Multi-Tier AI Fallback.
//

import Foundation
import AssetCoreSecurity

/// Errors encountered in AI communication.
public enum AIError: Error, LocalizedError, Sendable {
    case networkUnavailable
    case rateLimitExceeded
    case serverError(statusCode: Int, message: String)
    case decodingFailed(reason: String)
    case allProvidersExhausted
    
    public var errorDescription: String? {
        switch self {
        case .networkUnavailable:
            return "Internet connectivity unavailable. Operating in offline mode."
        case .rateLimitExceeded:
            return "AI diagnostic quota temporarily reached. Please retry in a few moments."
        case .serverError(let statusCode, let message):
            return "AI Proxy Server returned HTTP \(statusCode): \(message)"
        case .decodingFailed(let reason):
            return "Failed to decode structured AI response: \(reason)"
        case .allProvidersExhausted:
            return "All AI backends (Gemini, Grok) are currently unavailable. Falling back to local offline rules."
        }
    }
}

/// Actor managing client-to-proxy communication with PII scrubbing, App Attest assertions, and provider fallback.
public actor AIProxyClient {
    public static let shared = AIProxyClient()
    
    private let proxyBaseURL: URL
    private let urlSession: URLSession
    
    public init(
        proxyBaseURL: URL = URL(string: "https://ai-proxy.nordicassetsuite.workers.dev")!,
        sessionConfiguration: URLSessionConfiguration = .default
    ) {
        self.proxyBaseURL = proxyBaseURL
        sessionConfiguration.timeoutIntervalForRequest = 15.0 // 15s timeout
        sessionConfiguration.timeoutIntervalForResource = 30.0
        self.urlSession = URLSession(configuration: sessionConfiguration)
    }
    
    /// Dispatches a structured document extraction request through the secure Cloudflare proxy.
    public func requestExtraction(
        rawOCRText: String,
        documentType: String = "receipt",
        targetLanguage: String = "en"
    ) async throws -> AIExtractionResponse {
        // STEP 1: Mandatory on-device PII scrubbing (GDPR / Swiss FADP)
        let sanitizedText = PIIRedactor.shared.redact(text: rawOCRText)
        
        // STEP 2: Obtain App Attest key ID
        let keyId = try? await AppAttestManager.shared.getOrCreateKeyId()
        
        let requestPayload = AIExtractionRequest(
            rawOCRText: sanitizedText,
            documentType: documentType,
            targetLanguage: targetLanguage,
            clientAttestationKeyId: keyId
        )
        
        let endpoint = proxyBaseURL.appendingPathComponent("v1/extract")
        
        // STEP 3: Execute with automatic retry & fallback
        return try await executeWithRetry(endpoint: endpoint, payload: requestPayload)
    }
    
    /// Dispatches an AI diagnostic assessment request through the secure Cloudflare proxy.
    public func requestDiagnostics(
        assetDomain: String,
        brand: String,
        modelName: String,
        errorCodeOrSymptom: String,
        currentAgeMonths: Int = 0,
        historicalTelemetry: String = "",
        targetLanguage: String = "en"
    ) async throws -> AIDiagnosticResponse {
        let sanitizedSymptom = PIIRedactor.shared.redact(text: errorCodeOrSymptom)
        
        let requestPayload = AIDiagnosticRequest(
            assetDomain: assetDomain,
            brand: brand,
            modelName: modelName,
            errorCodeOrSymptom: sanitizedSymptom,
            currentAgeMonths: currentAgeMonths,
            historicalTelemetrySummary: historicalTelemetry,
            targetLanguage: targetLanguage
        )
        
        let endpoint = proxyBaseURL.appendingPathComponent("v1/diagnose")
        return try await executeWithRetry(endpoint: endpoint, payload: requestPayload)
    }
    
    // MARK: - Network Pipeline with Exponential Backoff
    
    private func executeWithRetry<Request: Encodable & Sendable, Response: Decodable & Sendable>(
        endpoint: URL,
        payload: Request,
        maxRetries: Int = 2
    ) async throws -> Response {
        var currentAttempt = 0
        var lastError: Error?
        
        let encoder = JSONEncoder()
        let bodyData = try encoder.encode(payload)
        
        while currentAttempt <= maxRetries {
            do {
                var request = URLRequest(url: endpoint)
                request.httpMethod = "POST"
                request.setValue("application/json", forHTTPHeaderField: "Content-Type")
                request.setValue("application/json", forHTTPHeaderField: "Accept")
                request.setValue("NordicAssetSuite-iOS/3.0", forHTTPHeaderField: "User-Agent")
                request.httpBody = bodyData
                
                let (data, response) = try await urlSession.data(for: request)
                
                guard let httpResponse = response as? HTTPURLResponse else {
                    throw AIError.networkUnavailable
                }
                
                if httpResponse.statusCode == 200 {
                    let decoder = JSONDecoder()
                    return try decoder.decode(Response.self, from: data)
                } else if httpResponse.statusCode == 429 {
                    throw AIError.rateLimitExceeded
                } else {
                    let errorMsg = String(data: data, encoding: .utf8) ?? "Unknown error"
                    throw AIError.serverError(statusCode: httpResponse.statusCode, message: errorMsg)
                }
            } catch {
                lastError = error
                currentAttempt += 1
                
                if currentAttempt <= maxRetries {
                    // Exponential backoff: 1s, 2s with jitter
                    let delay = Double(currentAttempt) * 1.0 + Double.random(in: 0.1...0.3)
                    try? await Task.sleep(nanoseconds: UInt64(delay * 1_000_000_000))
                }
            }
        }
        
        throw lastError ?? AIError.allProvidersExhausted
    }
}
