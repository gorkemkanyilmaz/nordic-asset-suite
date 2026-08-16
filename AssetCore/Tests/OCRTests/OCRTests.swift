//
//  OCRTests.swift
//  AssetCoreOCRTests
//
//  Created for Nordic Asset Suite.
//  Strict Concurrency: Complete. XCTest Suite for Apple Vision & Parsers.
//

import XCTest
@testable import AssetCoreOCR
@testable import AssetCoreImageEngine

final class OCRTests: XCTestCase {
    
    // MARK: - Test 1: Language Correction Dynamic Toggling
    func testLanguageCorrectionDynamicToggling() {
        let receiptTarget = OCRScanTarget.receiptOrInvoice
        XCTAssertTrue(receiptTarget.usesLanguageCorrection, "Receipts must use language dictionary correction for multi-language texts.")
        
        let serialTarget = OCRScanTarget.serialNumberOrBarcode
        XCTAssertFalse(serialTarget.usesLanguageCorrection, "Serial scan target must disable language correction to prevent '0' -> 'O' corruptions.")
    }
    
    // MARK: - Test 2: Swiss German Receipt Parsing (CHF)
    func testSwissReceiptParsing() {
        let sampleSwissReceipt = """
        FUST AG - Filiale Zurich
        Bahnhofstrasse 12, 8001 Zurich
        Datum: 12.01.2026
        1x Miele W1 Washing Machine CHF 1'899.00
        1x Lieferung CHF 50.00
        TOTAL: CHF 1'949.00
        MWST 8.1% inkl.
        Vielen Dank für Ihren Einkauf!
        """
        
        let parsed = ReceiptParser.shared.parseReceipt(from: sampleSwissReceipt, confidenceScore: 0.94)
        
        XCTAssertEqual(parsed.merchantName, "FUST AG - Filiale Zurich")
        XCTAssertEqual(parsed.totalAmount, Decimal(1949.00))
        XCTAssertEqual(parsed.currencyCode, "CHF")
        XCTAssertNotNil(parsed.transactionDate)
        
        let decision = OCRConfidenceEvaluator.shared.evaluateReceipt(parsed)
        XCTAssertTrue(decision.isSufficient)
    }
    
    // MARK: - Test 3: Nordic Danish Receipt Parsing (DKK)
    func testDanishReceiptParsing() {
        let sampleDanishReceipt = """
        Elgiganten Kobenhavn
        Kvittering Nr: 890123
        Dato: 15/02/2026
        Bosch Opvaskemaskine Serie 6
        I ALT: 5.499,00 DKK
        Moms 25% udgor: 1.099,80 DKK
        """
        
        let parsed = ReceiptParser.shared.parseReceipt(from: sampleDanishReceipt, confidenceScore: 0.91)
        
        XCTAssertEqual(parsed.merchantName, "Elgiganten Kobenhavn")
        XCTAssertEqual(parsed.totalAmount, Decimal(5499.00))
        XCTAssertEqual(parsed.currencyCode, "DKK")
        XCTAssertNotNil(parsed.transactionDate)
        
        let decision = OCRConfidenceEvaluator.shared.evaluateReceipt(parsed)
        XCTAssertTrue(decision.isSufficient)
    }
    
    // MARK: - Test 4: Appliance Hardware Serial Badge
    func testApplianceBadgeParsing() {
        let sampleBadgeText = """
        V-ZUG AG Switzerland
        Typ: AdoraWaschen V4000
        Modell: WA4T-11023
        S/N: 2304891104
        230V~ 50Hz 2300W
        Made in Switzerland
        """
        
        let parsed = SerialAndModelParser.shared.parseBadge(from: sampleBadgeText, confidenceScore: 0.96)
        
        XCTAssertEqual(parsed.brand, "V-ZUG")
        XCTAssertEqual(parsed.serialNumber, "2304891104")
        XCTAssertEqual(parsed.modelName, "AdoraWaschen")
        XCTAssertEqual(parsed.category, "Appliance")
        
        let decision = OCRConfidenceEvaluator.shared.evaluateSerialBadge(parsed)
        XCTAssertTrue(decision.isSufficient)
    }
    
    // MARK: - Test 5: E-Bike Frame & Motor Badge
    func testEBikeFrameBadgeParsing() {
        let sampleEBikeText = """
        Scott Sports SA
        Model: Patron eRIDE 900
        Frame No: SCOTT-EN15194-9844
        Drive Unit: Bosch CX Gen4 85Nm
        """
        
        let parsed = SerialAndModelParser.shared.parseBadge(from: sampleEBikeText, confidenceScore: 0.92)
        
        XCTAssertEqual(parsed.brand, "Scott")
        XCTAssertEqual(parsed.serialNumber, "SCOTT-EN15194-9844")
        XCTAssertEqual(parsed.category, "EBike")
    }
    
    // MARK: - Test 6: Coffee Machine Serial Badge
    func testCoffeeMachineBadgeParsing() {
        let sampleJuraText = """
        Jura Elektroapparate AG
        Type: E8 Piano Black
        Art. Nr.: 15355
        Seriennummer: JURA-2026-88120
        Made in Switzerland
        """
        
        let parsed = SerialAndModelParser.shared.parseBadge(from: sampleJuraText, confidenceScore: 0.95)
        
        XCTAssertEqual(parsed.brand, "Jura")
        XCTAssertEqual(parsed.serialNumber, "JURA-2026-88120")
        XCTAssertEqual(parsed.category, "CoffeeMachine")
    }
    
    // MARK: - Test 7: Low Confidence AI Fallback Recommendation
    func testLowConfidenceFallbackEvaluation() {
        let degradedReceipt = ParsedReceiptData(
            merchantName: nil,
            transactionDate: nil,
            totalAmount: nil,
            currencyCode: nil,
            confidenceScore: 0.62
        )
        
        let decision = OCRConfidenceEvaluator.shared.evaluateReceipt(degradedReceipt)
        XCTAssertFalse(decision.isSufficient, "Degraded receipt scan must trigger AI fallback.")
        XCTAssertTrue(decision.missingFields.contains("Total Amount"))
    }
}
