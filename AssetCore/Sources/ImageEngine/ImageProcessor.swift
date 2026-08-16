//
//  ImageProcessor.swift
//  AssetCoreImageEngine
//
//  Created for Nordic Asset Suite.
//  Strict Concurrency: Complete. CoreImage & HEIC Optimization.
//

import Foundation
import CoreGraphics
@preconcurrency import CoreImage
#if os(iOS)
import UIKit
#endif

/// Errors encountered during image pre-processing and compression.
public enum ImageProcessingError: Error, LocalizedError, Sendable {
    case invalidImageData
    case renderingFailed
    case compressionFailed
    
    public var errorDescription: String? {
        switch self {
        case .invalidImageData:
            return "Supplied image data is corrupted or unsupported."
        case .renderingFailed:
            return "CoreImage filter rendering operation failed."
        case .compressionFailed:
            return "Failed to compress processed image to target HEIC format."
        }
    }
}

/// High-performance thread-safe image pre-processor for OCR optimization and archival.
public final class ImageProcessor: @unchecked Sendable {
    public static let shared = ImageProcessor()
    
    private let ciContext: CIContext
    
    public init() {
        self.ciContext = CIContext(options: [.useSoftwareRenderer: false])
    }
    
    /// Downsamples an image so its maximum dimension does not exceed 3840 pixels (4K limit), preventing OOM spikes.
    public func downsampleTo4KMax(imageData: Data) throws -> Data {
        #if os(iOS)
        guard let sourceImage = UIImage(data: imageData) else {
            throw ImageProcessingError.invalidImageData
        }
        
        let maxDimension: CGFloat = 3840.0
        let originalSize = sourceImage.size
        
        guard originalSize.width > maxDimension || originalSize.height > maxDimension else {
            return imageData
        }
        
        let ratio = min(maxDimension / originalSize.width, maxDimension / originalSize.height)
        let targetSize = CGSize(width: originalSize.width * ratio, height: originalSize.height * ratio)
        
        let format = UIGraphicsImageRendererFormat.default()
        format.scale = 1.0
        let renderer = UIGraphicsImageRenderer(size: targetSize, format: format)
        
        let downsampled = renderer.image { _ in
            sourceImage.draw(in: CGRect(origin: .zero, size: targetSize))
        }
        
        guard let outputData = downsampled.jpegData(compressionQuality: 0.9) else {
            throw ImageProcessingError.compressionFailed
        }
        
        return outputData
        #else
        return imageData
        #endif
    }
    
    /// Enhances image contrast and sharpens metallic badges or faded thermal receipts for OCR ingestion.
    public func enhanceForOCR(imageData: Data) throws -> CGImage {
        guard let ciImage = CIImage(data: imageData) else {
            throw ImageProcessingError.invalidImageData
        }
        
        // Apply exposure and contrast adjustments
        let exposureFilter = CIFilter(name: "CIExposureAdjust")
        exposureFilter?.setValue(ciImage, forKey: kCIInputImageKey)
        exposureFilter?.setValue(0.5, forKey: kCIInputEVKey)
        
        let contrastFilter = CIFilter(name: "CIColorControls")
        contrastFilter?.setValue(exposureFilter?.outputImage ?? ciImage, forKey: kCIInputImageKey)
        contrastFilter?.setValue(1.3, forKey: kCIInputContrastKey) // Boost contrast
        contrastFilter?.setValue(0.0, forKey: kCIInputSaturationKey) // Convert to Grayscale
        
        guard let outputCI = contrastFilter?.outputImage,
              let cgImage = ciContext.createCGImage(outputCI, from: outputCI.extent) else {
            throw ImageProcessingError.renderingFailed
        }
        
        return cgImage
    }
    
    /// Compresses image to HEIC at 80% quality for CloudKit-friendly lightweight archiving.
    public func compressToHEIC80(imageData: Data) throws -> Data {
        #if os(iOS)
        guard let uiImage = UIImage(data: imageData) else {
            throw ImageProcessingError.invalidImageData
        }
        
        // HEIC compression on iOS 17+
        if let heicData = uiImage.heicData(compressionQuality: 0.8) {
            return heicData
        }
        
        // Fallback to JPEG at 0.8 if HEIC hardware encoder is unavailable
        guard let jpegData = uiImage.jpegData(compressionQuality: 0.8) else {
            throw ImageProcessingError.compressionFailed
        }
        return jpegData
        #else
        return imageData
        #endif
    }
}

#if os(iOS)
extension UIImage {
    func heicData(compressionQuality: CGFloat) -> Data? {
        guard let cgImage = self.cgImage else { return nil }
        let mutableData = NSMutableData()
        guard let destination = CGImageDestinationCreateWithData(mutableData, "public.heic" as CFString, 1, nil) else {
            return nil
        }
        let options: [CFString: Any] = [
            kCGImageDestinationLossyCompressionQuality: compressionQuality
        ]
        CGImageDestinationAddImage(destination, cgImage, options as CFDictionary)
        guard CGImageDestinationFinalize(destination) else { return nil }
        return mutableData as Data
    }
}
#endif
