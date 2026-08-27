//
//  ProductThumbnailView.swift
//  AssetCoreUIComponents
//
//  Created for Nordic Asset Suite.
//  Strict Concurrency: Complete. 5-Tier Product Imagery & Thumbnail Component.
//

import SwiftUI
import AssetCoreImageEngine
#if canImport(UIKit)
import UIKit
#elseif canImport(AppKit)
import AppKit
#endif

/// Standardized SwiftUI component implementing the 5-tier product imagery resolution hierarchy.
public struct ProductThumbnailView: View {
    public let userImageData: Data?
    public let verifiedImageUrl: URL?
    public let categoryIconName: String
    public let variant: ThumbnailVariant
    public let cornerRadius: CGFloat
    public let theme: any AppDesignTheme
    
    public init(
        userImageData: Data? = nil,
        verifiedImageUrl: URL? = nil,
        categoryIconName: String = "cube.fill",
        variant: ThumbnailVariant = .medium,
        cornerRadius: CGFloat = 12,
        theme: any AppDesignTheme
    ) {
        self.userImageData = userImageData
        self.verifiedImageUrl = verifiedImageUrl
        self.categoryIconName = categoryIconName
        self.variant = variant
        self.cornerRadius = cornerRadius
        self.theme = theme
    }
    
    public var body: some View {
        ZStack {
            // Tier 1: User-Provided Photo
            if let data = userImageData, let photo = platformImage(from: data) {
                photo
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: variant.targetDimension.width, height: variant.targetDimension.height)
                    .clipped()
            }
            // Tier 2: Verified Remote / Cached Product Image
            else if let url = verifiedImageUrl {
                AsyncImage(url: url) { phase in
                    switch phase {
                    case .success(let image):
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: variant.targetDimension.width, height: variant.targetDimension.height)
                            .clipped()
                    case .failure:
                        fallbackCategoryIcon
                    case .empty:
                        ZStack {
                            theme.surfaceElevated
                            ProgressView()
                                .scaleEffect(0.7)
                        }
                    @unknown default:
                        fallbackCategoryIcon
                    }
                }
                .frame(width: variant.targetDimension.width, height: variant.targetDimension.height)
            }
            // Tier 5: Minimal Category Fallback Icon
            else {
                fallbackCategoryIcon
            }
        }
        .frame(width: variant.targetDimension.width, height: variant.targetDimension.height)
        .background(theme.surfaceElevated)
        .clipShape(RoundedRectangle(cornerRadius: cornerRadius, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                .stroke(theme.borderSubtle, lineWidth: 1)
        )
    }
    
    private func platformImage(from data: Data) -> Image? {
        #if canImport(UIKit)
        if let image = UIImage(data: data) { return Image(uiImage: image) }
        #elseif canImport(AppKit)
        if let image = NSImage(data: data) { return Image(nsImage: image) }
        #endif
        return nil
    }
    
    private var fallbackCategoryIcon: some View {
        ZStack {
            theme.surfaceElevated
            Image(systemName: categoryIconName)
                .font(.system(size: variant.targetDimension.width * 0.4, weight: .medium))
                .foregroundColor(theme.primaryAccent)
        }
        .frame(width: variant.targetDimension.width, height: variant.targetDimension.height)
    }
}
