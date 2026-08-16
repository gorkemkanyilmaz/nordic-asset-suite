//
//  AIExtractionService.swift
//  AssetCoreAI
//
//  Created for Nordic Asset Suite.
//  Strict Concurrency: Complete. End-to-End Hybrid Extraction Orchestrator.
//

import Foundation
import AssetCoreOCR
import AssetCoreSecurity

/// High-level orchestrator coordinating local Vision OCR and cloud LLM fallback.
public final class AIExtractionService: Sendable {
    public static let shared = AIExtractionService()
    
    private init() {}
    
    /// Processes a scanned document: tries local rule-based parsing first; if ambiguous, falls back to cloud AI.
    public func processDocumentScan(
        ocrResult: OCRScanResult,
        targetLanguage: String = "en"
    ) async -> AIExtractionResponse {
        // Step 1: Run local rule parser
        let localSerial = SerialAndModelParser.shared.parseBadge(from: ocrResult.rawText, confidenceScore: ocrResult.averageConfidence)
        let serialDecision = OCRConfidenceEvaluator.shared.evaluateSerialBadge(localSerial)
        
        let localReceipt = ReceiptParser.shared.parseReceipt(from: ocrResult.rawText, confidenceScore: ocrResult.averageConfidence)
        let receiptDecision = OCRConfidenceEvaluator.shared.evaluateReceipt(localReceipt)
        
        // If local parser succeeded with high confidence, return immediately with zero API cost
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
        
        // Step 2: Local parsing had low confidence or missing fields -> Route to Cloudflare AI Proxy
        do {
            let cloudResponse = try await AIProxyClient.shared.requestExtraction(
                rawOCRText: ocrResult.rawText,
                documentType: ocrResult.target == .receiptOrInvoice ? "receipt" : "serial_badge",
                targetLanguage: targetLanguage
            )
            return cloudResponse
        } catch {
            // Step 3: If cloud AI fails (e.g. offline), gracefully return whatever local parser managed to identify
            return AIExtractionResponse(
                brand: localSerial.brand ?? localReceipt.merchantName,
                modelName: localSerial.modelName,
                serialNumber: localSerial.serialNumber,
                purchaseDateISO: localReceipt.transactionDate.map { ISO8601DateFormatter().string(from: $0) },
                purchasePrice: localReceipt.totalAmount,
                currencyCode: localReceipt.currencyCode,
                detectedCategory: localSerial.category,
                summaryDescription: "Offline mode: Partial extraction from local OCR.",
                confidenceScore: Double(ocrResult.averageConfidence),
                providerUsed: .localFallback
            )
        }
    }
}
