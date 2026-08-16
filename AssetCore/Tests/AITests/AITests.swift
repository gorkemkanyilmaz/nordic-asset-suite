//
//  AITests.swift
//  AssetCoreAITests
//
//  Created for Nordic Asset Suite.
//  Strict Concurrency: Complete. XCTest Suite for AI Models, PII Masking, & Fallback Routing.
//

import XCTest
@testable import AssetCoreAI
@testable import AssetCoreSecurity
@testable import AssetCoreOCR

final class AITests: XCTestCase {
    
    // MARK: - Test 1: PII Scrubbing Prior to AI Dispatch
    func testPIIRedactionScrubbing() {
        let rawReceiptWithPII = """
        Customer: Max Mustermann
        Email: max.mustermann@bluewin.ch
        Card: 4532 1120 4491 8820
        IBAN: CH93 0076 2011 6238 5295 7
        Tel: +41 44 123 45 67
        Item: V-ZUG AdoraWaschen V4000
        Total: CHF 2'350.00
        """
        
        let sanitized = PIIRedactor.shared.redact(text: rawReceiptWithPII)
        
        XCTAssertFalse(sanitized.contains("4532 1120 4491 8820"), "Credit card must be scrubbed before transmission.")
        XCTAssertFalse(sanitized.contains("max.mustermann@bluewin.ch"), "Email must be scrubbed.")
        XCTAssertFalse(sanitized.contains("+41 44 123 45 67"), "Phone number must be scrubbed.")
        XCTAssertFalse(sanitized.contains("CH93 0076 2011 6238 5295 7"), "IBAN must be scrubbed.")
        XCTAssertTrue(sanitized.contains("[REDACTED_CARD]"))
        XCTAssertTrue(sanitized.contains("[REDACTED_EMAIL]"))
        XCTAssertTrue(sanitized.contains("[REDACTED_PHONE]"))
        XCTAssertTrue(sanitized.contains("[REDACTED_IBAN]"))
        XCTAssertTrue(sanitized.contains("V-ZUG AdoraWaschen V4000"), "Hardware metadata must be preserved.")
    }
    
    // MARK: - Test 2: Structured JSON Extraction Decoding
    func testAIExtractionJSONDecoding() throws {
        let sampleJSON = """
        {
            "brand": "Miele",
            "modelName": "Triflex HX2 Pro",
            "serialNumber": "SN-MIELE-99812",
            "purchaseDateISO": "2026-01-20",
            "purchasePrice": 899.00,
            "currencyCode": "CHF",
            "detectedCategory": "Appliance",
            "summaryDescription": "Miele cordless vacuum cleaner with 2-year warranty.",
            "confidenceScore": 0.98,
            "providerUsed": "gemini-1.5-flash"
        }
        """.data(using: .utf8)!
        
        let decoder = JSONDecoder()
        let response = try decoder.decode(AIExtractionResponse.self, from: sampleJSON)
        
        XCTAssertEqual(response.brand, "Miele")
        XCTAssertEqual(response.modelName, "Triflex HX2 Pro")
        XCTAssertEqual(response.serialNumber, "SN-MIELE-99812")
        XCTAssertEqual(response.purchasePrice, Decimal(899.00))
        XCTAssertEqual(response.currencyCode, "CHF")
        XCTAssertEqual(response.providerUsed, .geminiFlash)
    }
    
    // MARK: - Test 3: Structured Diagnostic Response Decoding
    func testAIDiagnosticJSONDecoding() throws {
        let sampleDiagnosticJSON = """
        {
            "issueTitle": "V-ZUG E24 Drain Pump Blockage",
            "probableRootCause": "Foreign object or lint obstructing the drain filter impeller.",
            "severity": "MEDIUM",
            "recommendedActionSteps": [
                "Turn off the washing machine and disconnect power.",
                "Open bottom service flap and drain residual water via drain hose.",
                "Unscrew lint filter and remove foreign objects.",
                "Ensure pump impeller spins freely before reassembling."
            ],
            "requiresProfessionalService": false,
            "estimatedCostRangeCHF": "CHF 0 (DIY) / CHF 180 (Technician)",
            "updatedHealthScore": 75,
            "providerUsed": "grok-2"
        }
        """.data(using: .utf8)!
        
        let decoder = JSONDecoder()
        let diagnostic = try decoder.decode(AIDiagnosticResponse.self, from: sampleDiagnosticJSON)
        
        XCTAssertEqual(diagnostic.issueTitle, "V-ZUG E24 Drain Pump Blockage")
        XCTAssertEqual(diagnostic.severity, .medium)
        XCTAssertEqual(diagnostic.recommendedActionSteps.count, 4)
        XCTAssertFalse(diagnostic.requiresProfessionalService)
        XCTAssertEqual(diagnostic.providerUsed, .grok2)
    }
    
    // MARK: - Test 4: Local-First Fast Path Routing
    func testLocalFirstRoutingWithoutCloudCost() async {
        let highConfidenceScan = OCRScanResult(
            rawText: """
            Scott Sports SA
            Model: Patron eRIDE 900
            Frame No: SCOTT-EN15194-9844
            """,
            elements: [],
            averageConfidence: 0.95,
            target: .serialNumberOrBarcode,
            requiresAIFallback: false
        )
        
        let response = await AIExtractionService.shared.processDocumentScan(ocrResult: highConfidenceScan)
        
        XCTAssertEqual(response.brand, "Scott")
        XCTAssertEqual(response.serialNumber, "SCOTT-EN15194-9844")
        XCTAssertEqual(response.providerUsed, .localFallback, "High confidence local OCR must resolve on-device without cloud API calls.")
    }
}
