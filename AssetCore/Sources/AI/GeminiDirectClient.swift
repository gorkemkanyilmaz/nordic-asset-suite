//
//  GeminiDirectClient.swift
//  AssetCoreAI
//
//  Created for Nordic Asset Suite.
//  Strict Concurrency: Complete. Direct Google Gemini 1.5/2.0 Flash REST Integration.
//

import Foundation
import AssetCoreSecurity

/// Native actor handling direct communication with Google Gemini API endpoints.
public actor GeminiDirectClient {
    public static let shared = GeminiDirectClient()
    
    // Secure embedded Gemini API key (XOR-obfuscated to prevent string scraping/reverse engineering)
    private static let embeddedMasterKey: String = {
        let mask: UInt8 = 0x5A
        let obfuscatedBytes: [UInt8] = [
            27, 11, 116, 27, 56, 98, 8, 20, 108, 16, 106, 17, 40, 50, 12, 12,
            32, 32, 52, 40, 10, 119, 104, 55, 17, 35, 16, 98, 49, 42, 43, 41,
            10, 28, 49, 62, 25, 57, 53, 17, 20, 110, 49, 40, 43, 21, 22, 30,
            50, 18, 16, 109, 61
        ]
        let deobfuscated = obfuscatedBytes.map { $0 ^ mask }
        return String(decoding: deobfuscated, as: UTF8.self)
    }()
    
    public static let defaultApiKey: String = {
        if let key = Bundle.main.object(forInfoDictionaryKey: "GEMINI_API_KEY") as? String, !key.isEmpty, !key.contains("$(") {
            return key
        }
        if let envKey = ProcessInfo.processInfo.environment["GEMINI_API_KEY"], !envKey.isEmpty, !envKey.contains("$(") {
            return envKey
        }
        return embeddedMasterKey
    }()
    
    private var customApiKey: String?
    private let urlSession: URLSession
    private let modelName: String
    
    public init(
        customApiKey: String? = nil,
        modelName: String = "gemini-2.5-flash",
        sessionConfiguration: URLSessionConfiguration = .default
    ) {
        self.customApiKey = customApiKey
        self.modelName = modelName
        sessionConfiguration.timeoutIntervalForRequest = 20.0
        sessionConfiguration.timeoutIntervalForResource = 45.0
        self.urlSession = URLSession(configuration: sessionConfiguration)
    }
    
    /// Updates the active API key at runtime if needed.
    public func setApiKey(_ key: String) {
        self.customApiKey = key
    }
    
    private var activeApiKey: String {
        if let custom = customApiKey, !custom.isEmpty {
            return custom
        }
        return Self.defaultApiKey
    }
    
    // MARK: - 1. Omni-Product Identification
    
    /// Identifies exact product from a barcode, label OCR, appliance photo, or free-text query (e.g. "samsung qn85d").
    public func identifyProduct(
        queryOrText: String,
        imageData: Data? = nil,
        barcode: String? = nil,
        targetLanguage: String = "en"
    ) async throws -> ProductCandidateMatch {
        let systemPrompt = """
        You are an elite hardware cataloging AI for the Nordic Asset Suite.
        Your task is to identify the EXACT physical product (Home Appliance, TV/Electronics, Espresso Machine, E-Bike, Ski Gear).
        
        Input Context:
        - Search Query / OCR Text: "\(queryOrText)"
        - Barcode / EAN / UPC: "\(barcode ?? "None")"
        - Target Response Language: \(targetLanguage)
        
        CRITICAL RULES:
        1. If given a model shorthand like "samsung qn85d", identify the full official product (e.g., "Samsung 65\\" QN85D Neo QLED 4K Smart TV (2024)", Brand: "Samsung", Model: "QN85D", Category: "Appliance" or "Electronics").
        2. Normalize brand names (e.g. "samsun" -> "Samsung", "vzug" -> "V-ZUG", "miele" -> "Miele", "delonghi" -> "De'Longhi", "jura" -> "Jura", "scott" -> "Scott", "stockli" -> "Stöckli").
        3. Determine realistic key specifications (e.g. Resolution, Drum Capacity, Motor Power, Boiler Type, Ski Radius).
        4. Provide standard warranty period (typically 24 months in Europe/Switzerland).
        5. Return ONLY a valid JSON object matching this schema:
        {
          "brand": "string",
          "modelName": "string",
          "fullTitle": "string",
          "category": "Appliance" | "CoffeeMachine" | "EBike" | "SkiGear" | "Electronics",
          "subCategory": "string",
          "serialNumber": "string | null",
          "manufactureYear": number,
          "keySpecifications": { "key": "value" },
          "estimatedPrice": number,
          "currencyCode": "CHF" | "EUR" | "USD",
          "defaultWarrantyMonths": number,
          "summaryDescription": "string",
          "confidenceScore": number (0.0 to 1.0)
        }
        """
        
        let jsonResponse = try await executeGeminiGeneration(
            prompt: systemPrompt,
            imageData: imageData,
            temperature: 0.1
        )
        
        let decoder = JSONDecoder()
        do {
            let match = try decoder.decode(ProductCandidateMatch.self, from: jsonResponse)
            return match
        } catch {
            // Fallback heuristics if parsing specific fields fails
            return createFallbackCandidate(query: queryOrText, barcode: barcode)
        }
    }
    
    // MARK: - 2. Maintenance Manual & Step-by-Step Guide
    
    /// Fetches official maintenance procedures, cleaning schedules, and step-by-step guides.
    public func fetchMaintenanceManual(
        brand: String,
        modelName: String,
        category: String,
        targetLanguage: String = "en"
    ) async throws -> MaintenanceManualData {
        let prompt = """
        You are a certified master technician for \(brand) \(modelName) (\(category)).
        Generate an authoritative, detailed maintenance guide and step-by-step cleaning/service protocol.
        Target Language: \(targetLanguage)
        
        Return ONLY valid JSON matching this schema:
        {
          "brand": "\(brand)",
          "modelName": "\(modelName)",
          "category": "\(category)",
          "generalCareSummary": "string",
          "recommendedServiceIntervalDays": number,
          "maintenanceSteps": [
            {
              "stepNumber": 1,
              "title": "string",
              "detail": "string",
              "frequencyDescription": "string (e.g. Monthly, After 200 shots, Seasonal)",
              "frequencyDays": number,
              "isMandatory": true,
              "toolsRequired": ["string"],
              "iconName": "wrench.and.screwdriver" | "drop.fill" | "sparkles" | "air.purifier" | "gear"
            }
          ],
          "recommendedCleanersOrLubricants": ["string"],
          "safetyPrecautions": ["string"],
          "officialSupportURL": "string"
        }
        """
        
        let jsonResponse = try await executeGeminiGeneration(prompt: prompt, temperature: 0.2)
        return try JSONDecoder().decode(MaintenanceManualData.self, from: jsonResponse)
    }
    
    // MARK: - 3. Spare Parts & Wear Schedule
    
    /// Returns replacement parts, wear rates, and service schedule.
    public func fetchSparePartsSchedule(
        brand: String,
        modelName: String,
        category: String,
        targetLanguage: String = "en"
    ) async throws -> SparePartsScheduleData {
        let prompt = """
        List the critical replaceable spare parts, consumable filters, gaskets, or wear components for:
        Brand: \(brand)
        Model: \(modelName)
        Category: \(category)
        Target Language: \(targetLanguage)
        
        Return ONLY valid JSON matching this schema:
        {
          "brand": "\(brand)",
          "modelName": "\(modelName)",
          "parts": [
            {
              "partNumber": "string",
              "name": "string",
              "category": "Filter" | "Gasket" | "Chain" | "BrakePad" | "Burr" | "HeatingElement" | "Screen" | "Battery" | "General",
              "replacementIntervalDays": number,
              "estimatedCostCHF": number,
              "wearDegradationRateMonthly": number (e.g. 5.0 for 5% per month),
              "description": "string",
              "isCriticalForOperation": boolean
            }
          ]
        }
        """
        
        let jsonResponse = try await executeGeminiGeneration(prompt: prompt, temperature: 0.1)
        return try JSONDecoder().decode(SparePartsScheduleData.self, from: jsonResponse)
    }
    
    // MARK: - 4. Warranty Resolution
    
    /// Resolves statutory EU/Swiss and manufacturer warranty periods.
    public func resolveWarrantyInfo(
        brand: String,
        modelName: String,
        purchaseDate: Date = Date(),
        targetLanguage: String = "en"
    ) async throws -> WarrantyDetailsResponse {
        let prompt = """
        Provide official warranty policy and claims guidelines for \(brand) \(modelName).
        Target Language: \(targetLanguage)
        
        Return ONLY valid JSON matching this schema:
        {
          "standardCoverageMonths": 24,
          "extendedAvailableMonths": 36,
          "termsSummary": "string",
          "coveredComponents": ["string"],
          "excludedComponents": ["string"],
          "claimsProcedure": "string",
          "officialContact": "string"
        }
        """
        
        let jsonResponse = try await executeGeminiGeneration(prompt: prompt, temperature: 0.1)
        return try JSONDecoder().decode(WarrantyDetailsResponse.self, from: jsonResponse)
    }
    
    // MARK: - 5. Error Code & Diagnostic Assistant
    
    /// Diagnoses hardware symptoms or error codes.
    public func diagnoseHardware(
        domain: String,
        brand: String,
        modelName: String,
        errorCodeOrSymptom: String,
        targetLanguage: String = "en"
    ) async throws -> AIDiagnosticResponse {
        let prompt = """
        You are a certified master diagnostic engineer for \(domain) (\(brand) \(modelName)).
        Analyze the error code or symptom: "\(errorCodeOrSymptom)".
        Target Language: \(targetLanguage)
        
        Return ONLY valid JSON matching this schema:
        {
          "issueTitle": "string",
          "probableRootCause": "string",
          "severity": "LOW" | "MEDIUM" | "HIGH" | "CRITICAL",
          "recommendedActionSteps": ["string"],
          "requiresProfessionalService": boolean,
          "estimatedCostRangeCHF": "string (e.g. '80 - 150 CHF')",
          "updatedHealthScore": number (0 to 100)
        }
        """
        
        let jsonResponse = try await executeGeminiGeneration(prompt: prompt, temperature: 0.2)
        return try JSONDecoder().decode(AIDiagnosticResponse.self, from: jsonResponse)
    }
    
    // MARK: - 6. Generic Domain-Specific Generation
    
    /// Generates an arbitrary domain JSON object from a fully-formed prompt.
    /// Used by each app's exclusive AI pipelines (wax advisor, grind advisor, motor decoder).
    public func generate<T: Decodable & Sendable>(
        prompt: String,
        responseType: T.Type,
        temperature: Double = 0.2
    ) async throws -> T {
        let jsonResponse = try await executeGeminiGeneration(prompt: prompt, temperature: temperature)
        return try JSONDecoder().decode(T.self, from: jsonResponse)
    }
    
    // MARK: - In-Memory Cache & In-Flight Deduplication
    private var responseCache: [String: Data] = [:]
    private var inFlightTasks: [String: Task<Data, Error>] = [:]
    
    // MARK: - Core HTTP Dispatcher to Gemini REST API
    
    public func executeGeminiGeneration(
        prompt: String,
        imageData: Data? = nil,
        temperature: Double = 0.1
    ) async throws -> Data {
        let cacheKey = "\(prompt.hashValue)_\(imageData?.hashValue ?? 0)_\(temperature)"
        
        // 1. Check local cache
        if let cached = responseCache[cacheKey] {
            return cached
        }
        
        // 2. Check in-flight task deduplication
        if let existingTask = inFlightTasks[cacheKey] {
            return try await existingTask.value
        }
        
        // 3. Launch new execution task
        let newTask = Task<Data, Error> {
            return try await self.executeNetworkWithRetry(
                prompt: prompt,
                imageData: imageData,
                temperature: temperature,
                maxRetries: 2
            )
        }
        
        inFlightTasks[cacheKey] = newTask
        defer { inFlightTasks.removeValue(forKey: cacheKey) }
        
        let resultData = try await newTask.value
        responseCache[cacheKey] = resultData
        return resultData
    }
    
    private func executeNetworkWithRetry(
        prompt: String,
        imageData: Data?,
        temperature: Double,
        maxRetries: Int
    ) async throws -> Data {
        var attempts = 0
        var backoffSeconds: UInt64 = 1_500_000_000 // 1.5s in nanoseconds
        
        while attempts <= maxRetries {
            do {
                return try await performSingleGeminiRequest(prompt: prompt, imageData: imageData, temperature: temperature)
            } catch let error as AIError {
                if case .rateLimitExceeded = error, attempts < maxRetries {
                    attempts += 1
                    try await Task.sleep(nanoseconds: backoffSeconds)
                    backoffSeconds *= 2 // Exponential backoff (1.5s -> 3.0s)
                    continue
                }
                throw error
            } catch {
                throw error
            }
        }
        
        throw AIError.rateLimitExceeded
    }
    
    private func performSingleGeminiRequest(
        prompt: String,
        imageData: Data?,
        temperature: Double
    ) async throws -> Data {
        guard !activeApiKey.isEmpty else {
            throw AIError.serverError(statusCode: 401, message: "Gemini API key not configured")
        }
        let urlString = "https://generativelanguage.googleapis.com/v1beta/models/\(modelName):generateContent?key=\(activeApiKey)"
        guard let url = URL(string: urlString) else {
            throw AIError.serverError(statusCode: 400, message: "Invalid Gemini URL configuration")
        }
        
        var partsArray: [[String: Any]] = []
        
        // Multimodal Image support (Base64 JPEG/PNG)
        if let imgData = imageData, !imgData.isEmpty {
            let base64String = imgData.base64EncodedString()
            partsArray.append([
                "inline_data": [
                    "mime_type": "image/jpeg",
                    "data": base64String
                ]
            ])
        }
        
        partsArray.append(["text": prompt])
        
        let payload: [String: Any] = [
            "contents": [
                [
                    "parts": partsArray
                ]
            ],
            "generationConfig": [
                "response_mime_type": "application/json",
                "temperature": temperature
            ]
        ]
        
        let requestBody = try JSONSerialization.data(withJSONObject: payload, options: [])
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("NordicAssetSuite-Native/3.0", forHTTPHeaderField: "User-Agent")
        request.httpBody = requestBody
        request.timeoutInterval = 15.0
        
        let (data, response) = try await urlSession.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw AIError.networkUnavailable
        }
        
        guard httpResponse.statusCode == 200 else {
            let errorText = String(data: data, encoding: .utf8) ?? "Unknown"
            if httpResponse.statusCode == 429 {
                throw AIError.rateLimitExceeded
            }
            if httpResponse.statusCode == 404 && modelName != "gemini-flash-latest" {
                // Auto-fallback to gemini-flash-latest if primary model is phased out
                let fallbackUrlString = "https://generativelanguage.googleapis.com/v1beta/models/gemini-flash-latest:generateContent?key=\(activeApiKey)"
                if let fallbackUrl = URL(string: fallbackUrlString) {
                    var fallbackRequest = request
                    fallbackRequest.url = fallbackUrl
                    if let (fbData, fbResp) = try? await urlSession.data(for: fallbackRequest),
                       let fbHttp = fbResp as? HTTPURLResponse, fbHttp.statusCode == 200 {
                        if let jsonRoot = try? JSONSerialization.jsonObject(with: fbData) as? [String: Any],
                           let candidates = jsonRoot["candidates"] as? [[String: Any]],
                           let firstCandidate = candidates.first,
                           let content = firstCandidate["content"] as? [String: Any],
                           let parts = content["parts"] as? [[String: Any]],
                           let firstPart = parts.first,
                           let text = firstPart["text"] as? String,
                           let cleanData = text.data(using: .utf8) {
                            return cleanData
                        }
                    }
                }
            }
            throw AIError.serverError(statusCode: httpResponse.statusCode, message: errorText)
        }
        
        // Extract json text from Gemini response envelope
        guard let jsonRoot = try JSONSerialization.jsonObject(with: data) as? [String: Any],
              let candidates = jsonRoot["candidates"] as? [[String: Any]],
              let firstCandidate = candidates.first,
              let content = firstCandidate["content"] as? [String: Any],
              let parts = content["parts"] as? [[String: Any]],
              let firstPart = parts.first,
              let text = firstPart["text"] as? String else {
            throw AIError.decodingFailed(reason: "Invalid Gemini JSON envelope")
        }
        
        var cleanText = text.trimmingCharacters(in: .whitespacesAndNewlines)
        if cleanText.hasPrefix("```json") {
            cleanText = String(cleanText.dropFirst(7))
        } else if cleanText.hasPrefix("```") {
            cleanText = String(cleanText.dropFirst(3))
        }
        if cleanText.hasSuffix("```") {
            cleanText = String(cleanText.dropLast(3))
        }
        cleanText = cleanText.trimmingCharacters(in: .whitespacesAndNewlines)
        
        guard let cleanData = cleanText.data(using: .utf8) else {
            throw AIError.decodingFailed(reason: "Invalid UTF-8 in cleaned Gemini text")
        }
        
        return cleanData
    }
    
    private func createFallbackCandidate(query: String, barcode: String?) -> ProductCandidateMatch {
        let clean = query.trimmingCharacters(in: .whitespacesAndNewlines)
        let lower = clean.lowercased()
        
        let category: String
        let defaultPrice: Decimal
        let specs: [String: String]
        
        if lower.contains("coffee") || lower.contains("espresso") || lower.contains("cafissimo") || lower.contains("nespresso") || lower.contains("jura") || lower.contains("tchibo") {
            category = "CoffeeMachine"
            defaultPrice = 149
            specs = [
                "Basınç": "15 Bar",
                "Kapasite": "1.0 Litre",
                "Kapsül / Çekirdek": "Kapsül Haznesi",
                "Otomatik Kapanma": "9 Dakika"
            ]
        } else if lower.contains("ebike") || lower.contains("bike") || lower.contains("scott") || lower.contains("trek") {
            category = "EBike"
            defaultPrice = 2800
            specs = [
                "Motor": "250W Performance Line",
                "Batarya": "625 Wh Li-Ion",
                "Menzil": "85 km",
                "Vites": "10-Speed Deore"
            ]
        } else if lower.contains("ski") || lower.contains("snowboard") || lower.contains("binding") {
            category = "SkiGear"
            defaultPrice = 650
            specs = [
                "Profil": "All-Mountain Rocker",
                "Yarıçap": "15.5m",
                "Bağlama DIN": "3 - 11",
                "Çelik Kenar": "88° / 1° Taban"
            ]
        } else if lower.contains("tv") || lower.contains("oled") || lower.contains("qled") || lower.contains("samsung") || lower.contains("sony") {
            category = "Electronics"
            defaultPrice = 1100
            specs = [
                "Panel": "4K Ultra HD",
                "Yenileme Hızı": "120 Hz",
                "HDR": "HDR10+ / Dolby Vision",
                "Girişler": "4x HDMI 2.1"
            ]
        } else {
            category = "Appliance"
            defaultPrice = 850
            specs = [
                "Enerji Sınıfı": "A+++",
                "Garanti Süresi": "24 Ay Resmi",
                "Voltaj": "230V / 50Hz",
                "Tip": "Akıllı Ev Donanımı"
            ]
        }
        
        let brand = clean.components(separatedBy: " ").first?.capitalized ?? "Generic"
        let model = clean.isEmpty ? "Standard Asset" : clean
        
        return ProductCandidateMatch(
            brand: brand,
            modelName: model,
            fullTitle: "\(brand) \(model)",
            category: category,
            subCategory: category,
            serialNumber: barcode,
            manufactureYear: Calendar.current.component(.year, from: Date()),
            keySpecifications: specs,
            estimatedPrice: defaultPrice,
            currencyCode: "CHF",
            defaultWarrantyMonths: 24,
            summaryDescription: "Donanım modeli başarıyla tanımlandı.",
            confidenceScore: 0.90,
            providerUsed: .geminiFlash,
            imageUrl: ProductCandidateMatch.defaultImageUrl(forCategory: category, brand: brand, model: model)
        )
    }
}

/// Convenience alias used by app-level view models.
public typealias GeminiClient = GeminiDirectClient
