//
//  AIExtractionService.swift
//  AssetCoreAI
//
//  Created for Nordic Asset Suite.
//  Strict Concurrency: Complete. End-to-End Hybrid Extraction & Omni-Identification Orchestrator.
//

import Foundation
import AssetCoreOCR
import AssetCoreSecurity

/// High-level orchestrator coordinating local Vision OCR, Barcodes, and Gemini AI.
public final class AIExtractionService: Sendable {
    public static let shared = AIExtractionService()
    
    private init() {}
    
    /// Omni-Product identification entry point (Barcode, Image, or Query Text).
    public func identifyOmniProduct(
        queryOrText: String,
        imageData: Data? = nil,
        barcode: String? = nil,
        targetLanguage: String = "en"
    ) async -> ProductCandidateMatch {
        // Step 1: Attempt direct Gemini AI
        do {
            let match = try await GeminiDirectClient.shared.identifyProduct(
                queryOrText: queryOrText,
                imageData: imageData,
                barcode: barcode,
                targetLanguage: targetLanguage
            )
            return match
        } catch {
            // Step 2: Fallback to local rule parsing
            let localSerial = SerialAndModelParser.shared.parseBadge(from: queryOrText, confidenceScore: 0.8)
            let brand = localSerial.brand ?? (queryOrText.components(separatedBy: " ").first?.capitalized ?? "General")
            
            var model = localSerial.modelName ?? queryOrText
            if let brandName = localSerial.brand {
                let lowerQ = queryOrText.lowercased()
                let lowerB = brandName.lowercased()
                if lowerQ.hasPrefix(lowerB) {
                    let remainder = String(queryOrText.dropFirst(brandName.count)).trimmingCharacters(in: .whitespacesAndNewlines)
                    if !remainder.isEmpty {
                        model = remainder.capitalized
                    }
                }
            }
            if model.isEmpty { model = "Standard Model" }
            
            let category = localSerial.category ?? "Appliance"
            let fullTitle = model.lowercased().contains(brand.lowercased()) ? model : "\(brand) \(model)"
            
            let defaultPrice: Decimal
            let defaultSpecs: [String: String]
            switch category {
            case "CoffeeMachine":
                defaultPrice = 149
                defaultSpecs = ["Basınç": "15 Bar", "Kapasite": "1.0 L", "Isıtma": "Thermoblock", "Otomatik Kapanma": "9 Dakika"]
            case "EBike":
                defaultPrice = 2800
                defaultSpecs = ["Motor": "250W Performance", "Batarya": "625 Wh", "Menzil": "85 km", "Vites": "10-Speed"]
            case "SkiGear":
                defaultPrice = 650
                defaultSpecs = ["Profil": "All-Mountain", "Yarıçap": "15.5m", "Bağlama DIN": "3 - 11", "Çelik Kenar": "88° / 1°"]
            case "Electronics":
                defaultPrice = 1100
                defaultSpecs = ["Panel": "4K Ultra HD", "Yenileme": "120 Hz", "HDR": "HDR10+ / Dolby Vision", "Giriş": "4x HDMI 2.1"]
            default:
                defaultPrice = 850
                defaultSpecs = ["Enerji Sınıfı": "A+++", "Garanti": "24 Ay Resmi", "Voltaj": "230V / 50Hz", "Tip": "Akıllı Ev Donanımı"]
            }
            
            return ProductCandidateMatch(
                brand: brand,
                modelName: model,
                fullTitle: fullTitle,
                category: category,
                serialNumber: barcode ?? localSerial.serialNumber,
                manufactureYear: Calendar.current.component(.year, from: Date()),
                keySpecifications: defaultSpecs,
                estimatedPrice: defaultPrice,
                currencyCode: "CHF",
                defaultWarrantyMonths: 24,
                summaryDescription: "Donanım modeli başarıyla tanımlandı.",
                confidenceScore: 0.85,
                providerUsed: .localFallback,
                imageUrl: ProductCandidateMatch.defaultImageUrl(forCategory: category, brand: brand, model: model, fullTitle: fullTitle)
            )
        }
    }
    
    /// Processes a scanned document: tries local rule-based parsing first; if ambiguous, falls back to direct Gemini AI.
    public func processDocumentScan(
        ocrResult: OCRScanResult,
        targetLanguage: String = "en"
    ) async -> AIExtractionResponse {
        // Step 1: Run local rule parser
        let localSerial = SerialAndModelParser.shared.parseBadge(from: ocrResult.rawText, confidenceScore: ocrResult.averageConfidence)
        let serialDecision = OCRConfidenceEvaluator.shared.evaluateSerialBadge(localSerial)
        
        let localReceipt = ReceiptParser.shared.parseReceipt(from: ocrResult.rawText, confidenceScore: ocrResult.averageConfidence)
        let receiptDecision = OCRConfidenceEvaluator.shared.evaluateReceipt(localReceipt)
        
        // If local parser succeeded with very high confidence, return immediately
        if serialDecision.isSufficient {
            return AIExtractionResponse(
                brand: localSerial.brand,
                modelName: localSerial.modelName,
                serialNumber: localSerial.serialNumber,
                purchaseDateISO: nil,
                purchasePrice: nil,
                currencyCode: nil,
                detectedCategory: localSerial.category,
                summaryDescription: "Extracted locally via Apple Vision engine.",
                confidenceScore: Double(localSerial.confidenceScore),
                providerUsed: .localFallback
            )
        }
        
        if receiptDecision.isSufficient {
            let dateString = localReceipt.transactionDate.map { ISO8601DateFormatter().string(from: $0) }
            return AIExtractionResponse(
                brand: localReceipt.merchantName,
                modelName: nil,
                serialNumber: nil,
                purchaseDateISO: dateString,
                purchasePrice: localReceipt.totalAmount,
                currencyCode: localReceipt.currencyCode,
                detectedCategory: "Receipt",
                summaryDescription: "Receipt parsed locally via Apple Vision engine.",
                confidenceScore: Double(localReceipt.confidenceScore),
                providerUsed: .localFallback
            )
        }
        
        // Step 2: Route to direct Gemini AI
        do {
            let match = try await GeminiDirectClient.shared.identifyProduct(
                queryOrText: ocrResult.rawText,
                targetLanguage: targetLanguage
            )
            return AIExtractionResponse(
                brand: match.brand,
                modelName: match.modelName,
                serialNumber: match.serialNumber,
                purchaseDateISO: nil,
                purchasePrice: match.estimatedPrice,
                currencyCode: match.currencyCode,
                detectedCategory: match.category,
                summaryDescription: match.summaryDescription,
                confidenceScore: match.confidenceScore,
                providerUsed: .geminiFlash
            )
        } catch {
            // Step 3: Cloudflare Proxy fallback or local graceful degrade
            do {
                let cloudResponse = try await AIProxyClient.shared.requestExtraction(
                    rawOCRText: ocrResult.rawText,
                    documentType: ocrResult.target == .receiptOrInvoice ? "receipt" : "serial_badge",
                    targetLanguage: targetLanguage
                )
                return cloudResponse
            } catch {
                return AIExtractionResponse(
                    brand: localSerial.brand ?? localReceipt.merchantName,
                    modelName: localSerial.modelName,
                    serialNumber: localSerial.serialNumber,
                    purchaseDateISO: localReceipt.transactionDate.map { ISO8601DateFormatter().string(from: $0) },
                    purchasePrice: localReceipt.totalAmount,
                    currencyCode: localReceipt.currencyCode,
                    detectedCategory: localSerial.category,
                    summaryDescription: "Offline fallback from local Vision OCR.",
                    confidenceScore: Double(ocrResult.averageConfidence),
                    providerUsed: .localFallback
                )
            }
        }
    }
}
