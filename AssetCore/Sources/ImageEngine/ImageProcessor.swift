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

/// Standardized thumbnail size variants for the 5-tier product imagery system.
public enum ThumbnailVariant: String, Sendable, CaseIterable {
    /// 48 x 48 pt — Compact list rows, activity feeds, search results
    case small
    /// 80 x 80 pt — Main dashboard cards, room grids
    case medium
    /// 160 x 160 pt — Add confirmation modal, category selector cards
    case large
    /// 768 x 432 pt (16:9) — Product detail hero header, active digital twin
    case hero
    
    public var targetDimension: CGSize {
        switch self {
        case .small:
            return CGSize(width: 48, height: 48)
        case .medium:
            return CGSize(width: 80, height: 80)
        case .large:
            return CGSize(width: 160, height: 160)
        case .hero:
            return CGSize(width: 768, height: 432)
        }
    }
}

/// Errors encountered during image pre-processing and compression.
public enum ImageProcessingError: Error, LocalizedError, Sendable {
    case invalidImageData
    case renderingFailed
    case compressionFailed
    case cacheMiss
    
    public var errorDescription: String? {
        switch self {
        case .invalidImageData:
            return "Supplied image data is corrupted or unsupported."
        case .renderingFailed:
            return "CoreImage filter rendering operation failed."
        case .compressionFailed:
            return "Failed to compress processed image to target format."
        case .cacheMiss:
            return "Requested image asset is not in cache."
        }
    }
}

/// High-performance thread-safe image pre-processor for OCR optimization, thumbnail generation, and archival.
public final class ImageProcessor: @unchecked Sendable {
    public static let shared = ImageProcessor()
    
    private let ciContext: CIContext
    
    public init() {
        self.ciContext = CIContext(options: [.useSoftwareRenderer: false])
    }
    
    /// Generates a standardized thumbnail variant preserving aspect ratio with center-crop fill.
    public func generateThumbnail(from imageData: Data, variant: ThumbnailVariant) throws -> Data {
        #if os(iOS)
        guard let sourceImage = UIImage(data: imageData) else {
            throw ImageProcessingError.invalidImageData
        }
        
        let targetSize = variant.targetDimension
        let format = UIGraphicsImageRendererFormat.default()
        format.scale = 2.0 // High-DPI retina display
        
        let renderer = UIGraphicsImageRenderer(size: targetSize, format: format)
        let renderedImage = renderer.image { _ in
            let aspectWidth = targetSize.width / sourceImage.size.width
            let aspectHeight = targetSize.height / sourceImage.size.height
            let scale = max(aspectWidth, aspectHeight)
            
            let scaledWidth = sourceImage.size.width * scale
            let scaledHeight = sourceImage.size.height * scale
            let x = (targetSize.width - scaledWidth) / 2.0
            let y = (targetSize.height - scaledHeight) / 2.0
            
            sourceImage.draw(in: CGRect(x: x, y: y, width: scaledWidth, height: scaledHeight))
        }
        
        guard let outputData = renderedImage.jpegData(compressionQuality: 0.85) else {
            throw ImageProcessingError.compressionFailed
        }
        
        return outputData
        #else
        return imageData
        #endif
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
        
        let exposureFilter = CIFilter(name: "CIExposureAdjust")
        exposureFilter?.setValue(ciImage, forKey: kCIInputImageKey)
        exposureFilter?.setValue(0.5, forKey: kCIInputEVKey)
        
        let contrastFilter = CIFilter(name: "CIColorControls")
        contrastFilter?.setValue(exposureFilter?.outputImage ?? ciImage, forKey: kCIInputImageKey)
        contrastFilter?.setValue(1.3, forKey: kCIInputContrastKey)
        contrastFilter?.setValue(0.0, forKey: kCIInputSaturationKey) // Grayscale
        
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
        
        if let heicData = uiImage.heicData(compressionQuality: 0.8) {
            return heicData
        }
        
        guard let jpegData = uiImage.jpegData(compressionQuality: 0.8) else {
            throw ImageProcessingError.compressionFailed
        }
        return jpegData
        #else
        return imageData
        #endif
    }
}

/// Thread-safe in-memory and disk image cache manager keyed by product identity or image fingerprint.
public actor ImageCacheManager {
    public static let shared = ImageCacheManager()
    
    private var memoryCache: [String: Data] = [:]
    private let maxMemoryItems = 100
    
    public init() {}
    
    public func cacheImage(data: Data, forKey key: String) {
        if memoryCache.count >= maxMemoryItems {
            memoryCache.remove(at: memoryCache.startIndex)
        }
        memoryCache[key] = data
    }
    
    public func getImage(forKey key: String) -> Data? {
        return memoryCache[key]
    }
    
    public func removeImage(forKey key: String) {
        memoryCache.removeValue(forKey: key)
    }
    
    public func clearCache() {
        memoryCache.removeAll()
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
