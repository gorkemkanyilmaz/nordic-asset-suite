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
            let brand = localSerial.brand ?? "Unknown Brand"
            let model = localSerial.modelName ?? (queryOrText.isEmpty ? "Standard Model" : queryOrText)
            
            return ProductCandidateMatch(
                brand: brand,
                modelName: model,
                fullTitle: "\(brand) \(model)",
                category: localSerial.category ?? "Appliance",
                serialNumber: barcode ?? localSerial.serialNumber,
                manufactureYear: Calendar.current.component(.year, from: Date()),
                keySpecifications: [:],
                estimatedPrice: 950,
                currencyCode: "CHF",
                defaultWarrantyMonths: 24,
                summaryDescription: "Offline local match from input criteria.",
                confidenceScore: 0.75,
                providerUsed: .localFallback
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
