//
//  ProductThumbnailView.swift
//  AssetCoreUIComponents
//
//  Created for Nordic Asset Suite.
//  Strict Concurrency: Complete. 5-Tier Product Imagery & Thumbnail Component.
//

import SwiftUI
import AssetCoreImageEngine

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
            if let data = userImageData, let uiImage = UIImage(data: data) {
                Image(uiImage: uiImage)
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
