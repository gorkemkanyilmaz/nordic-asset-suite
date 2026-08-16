//
//  VisionOCRService.swift
//  AssetCoreOCR
//
//  Created for Nordic Asset Suite.
//  Strict Concurrency: Complete. Apple Vision Native Pipeline.
//

import Foundation
import Vision
import CoreGraphics

/// Errors encountered during Vision OCR execution.
public enum VisionOCRError: Error, LocalizedError, Sendable {
    case invalidImageData
    case recognitionExecutionFailed(reason: String)
    case emptyTextDetected
    
    public var errorDescription: String? {
        switch self {
        case .invalidImageData:
            return "Failed to construct valid CGImage from supplied image data."
        case .recognitionExecutionFailed(let reason):
            return "Vision text recognition request failed: \(reason)"
        case .emptyTextDetected:
            return "No readable text was detected in the document image."
        }
    }
}

/// Actor-isolated Apple Vision OCR recognition engine.
public actor VisionOCRService {
    public static let shared = VisionOCRService()
    
    private init() {}
    
    /// Recognizes text from raw image data with dynamic language correction control.
    public func recognizeText(
        from imageData: Data,
        target: OCRScanTarget = .receiptOrInvoice
    ) async throws -> OCRScanResult {
        // Run Vision request in background actor
        return try await withCheckedThrowingContinuation { continuation in
            let requestHandler = VNImageRequestHandler(data: imageData, options: [:])
            
            let request = VNRecognizeTextRequest { request, error in
                if let error = error {
                    continuation.resume(throwing: VisionOCRError.recognitionExecutionFailed(reason: error.localizedDescription))
                    return
                }
                
                guard let observations = request.results as? [VNRecognizedTextObservation], !observations.isEmpty else {
                    continuation.resume(throwing: VisionOCRError.emptyTextDetected)
                    return
                }
                
                var elements: [RecognizedTextElement] = []
                var fullTextLines: [String] = []
                var totalConfidence: Float = 0.0
                
                for observation in observations {
                    guard let topCandidate = observation.topCandidates(1).first else { continue }
                    
                    let text = topCandidate.string
                    let confidence = topCandidate.confidence
                    let boundingBox = observation.boundingBox
                    
                    elements.append(RecognizedTextElement(
                        text: text,
                        confidence: confidence,
                        boundingBox: boundingBox
                    ))
                    fullTextLines.append(text)
                    totalConfidence += confidence
                }
                
                let averageConfidence = elements.isEmpty ? 0.0 : (totalConfidence / Float(elements.count))
                let rawText = fullTextLines.joined(separator: "\n")
                
                // If average confidence is below threshold or scan is ambiguous, mark for AI fallback
                let requiresFallback = averageConfidence < 0.85
                
                let result = OCRScanResult(
                    rawText: rawText,
                    elements: elements,
                    averageConfidence: averageConfidence,
                    target: target,
                    requiresAIFallback: requiresFallback
                )
                
                continuation.resume(returning: result)
            }
            
            // Precision Configuration
            request.recognitionLevel = .accurate
            request.usesLanguageCorrection = target.usesLanguageCorrection
            
            if target.usesLanguageCorrection {
                request.recognitionLanguages = [
                    "en-US",
                    "de-DE",
                    "fr-FR",
                    "it-IT",
                    "da-DK",
                    "sv-SE",
                    "nb-NO"
                ]
            }
            
            do {
                try requestHandler.perform([request])
            } catch {
                continuation.resume(throwing: VisionOCRError.recognitionExecutionFailed(reason: error.localizedDescription))
            }
        }
    }
}
