//
//  OCRModels.swift
//  AssetCoreOCR
//
//  Created for Nordic Asset Suite.
//  Strict Concurrency: Complete. Vision OCR & Barcode Data Structures.
//

import Foundation
import CoreGraphics

/// Defines the target document type for dynamic OCR engine parameter tuning.
public enum OCRScanTarget: Sendable {
    /// Invoices, receipts, warranty certificates (Enables language correction across target markets).
    case receiptOrInvoice
    /// Metallic rating plates, frame serials, barcodes (STRICT: Disables language correction).
    case serialNumberOrBarcode
    /// User manual pages, technical specification tables.
    case technicalManual
    /// General multi-purpose document.
    case general
    
    /// Indicates whether Apple Vision dictionary-based language correction should be applied.
    public var usesLanguageCorrection: Bool {
        switch self {
        case .receiptOrInvoice, .technicalManual, .general:
            return true
        case .serialNumberOrBarcode:
            return false // Prevent autocorrecting '0' to 'O', '5' to 'S'
        }
    }
}

/// A recognized text line with bounding box coordinates and Vision confidence score.
public struct RecognizedTextElement: Sendable, Identifiable {
    public let id: UUID
    public let text: String
    public let confidence: Float
    public let boundingBox: CGRect
    
    public init(id: UUID = UUID(), text: String, confidence: Float, boundingBox: CGRect) {
        self.id = id
        self.text = text
        self.confidence confidence
        self.boundingBox = boundingBox
    }
}

/// A recognized barcode / QR observation from Vision.
public struct RecognizedBarcodeElement: Sendable, Identifiable {
    public let id: UUID
    public let payloadString: String
    public let symbology: String // EAN13, EAN8, QRCode, Code128, etc.
    public let boundingBox: CGRect
    
    public init(id: UUID = UUID(), payloadString: String, symbology: String, boundingBox: CGRect) {
        self.id = id
        self.payloadString = payloadString
        self.symbology = symbology
        self.boundingBox = boundingBox
    }
}

/// Structured outcome of a local Apple Vision OCR scan pass.
public struct OCRScanResult: Sendable {
    public let rawText: String
    public let elements: [RecognizedTextElement]
    public let averageConfidence: Float
    public let target: OCRScanTarget
    public let requiresAIFallback: Bool
    
    public init(
        rawText: String,
        elements: [RecognizedTextElement],
        averageConfidence: Float,
        target: OCRScanTarget,
        requiresAIFallback: Bool = false
    ) {
        self.rawText = rawText
        self.elements = elements
        self.averageConfidence = averageConfidence
        self.target = target
        self.requiresAIFallback = requiresAIFallback
    }
}

/// Unified multi-pass scan output combining both barcodes and OCR text.
public struct UnifiedScanOutput: Sendable {
    public let barcodes: [RecognizedBarcodeElement]
    public let ocrResult: OCRScanResult
    public let primaryBarcode: String?
    public let rawText: String
    public let capturedImageData: Data?
    
    public init(
        barcodes: [RecognizedBarcodeElement] = [],
        ocrResult: OCRScanResult,
        capturedImageData: Data? = nil
    ) {
        self.barcodes = barcodes
        self.ocrResult = ocrResult
        self.primaryBarcode = barcodes.first?.payloadString
        self.rawText = ocrResult.rawText
        self.capturedImageData = capturedImageData
    }
}

/// Structured receipt and invoice extraction outcome.
public struct ParsedReceiptData: Sendable {
    public let merchantName: String?
    public let transactionDate: Date?
    public let totalAmount: Decimal?
    public let currencyCode: String?
    public let vatAmount: Decimal?
    public let extractedLines: [String]
    public let confidenceScore: Float
    
    public init(
        merchantName: String? = nil,
        transactionDate: Date? = nil,
        totalAmount: Decimal? = nil,
        currencyCode: String? = nil,
        vatAmount: Decimal? = nil,
        extractedLines: [String] = [],
        confidenceScore: Float = 0.0
    ) {
        self.merchantName = merchantName
        self.transactionDate = transactionDate
        self.totalAmount = totalAmount
        self.currencyCode = currencyCode
        self.vatAmount = vatAmount
        self.extractedLines = extractedLines
        self.confidenceScore = confidenceScore
    }
}

/// Structured serial number, brand, and model extraction outcome.
public struct ParsedSerialData: Sendable {
    public let brand: String?
    public let modelName: String?
    public let serialNumber: String?
    public let category: String?
    public let confidenceScore: Float
    
    public init(
        brand: String? = nil,
        modelName: String? = nil,
        serialNumber: String? = nil,
        category: String? = nil,
        confidenceScore: Float = 0.0
    ) {
        self.brand = brand
        self.modelName = modelName
        self.serialNumber = serialNumber
        self.category = category
        self.confidenceScore = confidenceScore
    }
}
