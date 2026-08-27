//
//  ProductConfirmationModal.swift
//  AssetCoreUIComponents
//
//  Created for Nordic Asset Suite.
//  Strict Concurrency: Complete. Human-Verifiable Product Match Confirmation.
//

import SwiftUI
import AssetCoreAI
import AssetCoreLocalization

public struct ProductConfirmationModal: View {
    @Environment(\.dismiss) private var dismiss
    private let lang = LanguageManager.shared
    
    public let match: ProductCandidateMatch
    public let onConfirm: (ProductCandidateMatch) -> Void
    public let onEdit: () -> Void
    
    public init(
        match: ProductCandidateMatch,
        onConfirm: @escaping (ProductCandidateMatch) -> Void,
        onEdit: @escaping () -> Void
    ) {
        self.match = match
        self.onConfirm = onConfirm
        self.onEdit = onEdit
    }
    
    public var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 18) {
                    heroCard
                    actionButtons
                        .padding(.top, 6)
                }
                .padding()
            }
            .background(Color.adaptiveGroupedBackground)
            .navigationTitle(lang.t(.confirmAsset))
            #if os(iOS)
            .navigationBarTitleDisplayMode(.inline)
            #endif
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button(lang.t(.cancel)) { dismiss() }
                }
            }
        }
    }
    
    private var heroCard: some View {
        VStack(alignment: .leading, spacing: 14) {
            headerRow
            
            Divider()
            
            if !match.keySpecifications.isEmpty {
                specGrid
            }
            
            warrantyRow
        }
        .padding(18)
        .background(Color.adaptiveSystemBackground)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color.black.opacity(0.06), lineWidth: 1)
        )
    }
    
    private var headerRow: some View {
        HStack(alignment: .top) {
            VStack(alignment: .leading, spacing: 3) {
                Text(lang.t(.productDetected))
                    .font(.caption2)
                    .fontWeight(.bold)
                    .foregroundColor(.secondary)
                    .tracking(0.5)
                
                Text(match.fullTitle)
                    .font(.title3)
                    .fontWeight(.bold)
                    .foregroundColor(.primary)
                
                Text(lang.t(.confirmThisMatches))
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            Spacer()
            
            Image(systemName: iconForCategory(match.category))
                .font(.system(size: 32))
                .foregroundColor(.primary)
                .padding(10)
                .background(Color.adaptiveSecondaryBackground)
                .clipShape(RoundedRectangle(cornerRadius: 12))
        }
    }
    
    private var specGrid: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(lang.t(.specifications))
                .font(.caption2)
                .fontWeight(.bold)
                .foregroundColor(.secondary)
                .tracking(0.5)
            
            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 8) {
                ForEach(Array(match.keySpecifications.keys.sorted()), id: \.self) { key in
                    if let value = match.keySpecifications[key] {
                        VStack(alignment: .leading, spacing: 2) {
                            Text(key)
                                .font(.caption2)
                                .foregroundColor(.secondary)
                            Text(value)
                                .font(.caption)
                                .fontWeight(.semibold)
                                .foregroundColor(.primary)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(8)
                        .background(Color.adaptiveSecondaryBackground)
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                    }
                }
            }
        }
    }
    
    private var warrantyRow: some View {
        HStack {
            Label(String(format: lang.t(.monthsWarranty), match.defaultWarrantyMonths), systemImage: "shield.checkmark.fill")
                .font(.caption)
                .fontWeight(.semibold)
                .foregroundColor(.green)
            Spacer()
            if let price = match.estimatedPrice {
                Text(LocalizedCurrencyFormatter.format(amount: price, currencyCode: match.currencyCode))
                    .font(.caption)
                    .fontWeight(.bold)
                    .foregroundColor(.primary)
            }
        }
        .padding(10)
        .background(Color.green.opacity(0.08))
        .clipShape(RoundedRectangle(cornerRadius: 8))
    }
    
    private var actionButtons: some View {
        VStack(spacing: 10) {
            Button(action: {
                onConfirm(match)
                dismiss()
            }) {
                Text(lang.t(.confirmAndSaveAsset))
                    .font(.headline)
                    .fontWeight(.semibold)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 14)
                    .background(Color.accentColor)
                    .foregroundColor(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
            }
            
            Button(action: {
                onEdit()
                dismiss()
            }) {
                Text(lang.t(.editDetailsManually))
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .foregroundColor(.secondary)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 10)
            }
        }
    }
    
    private func iconForCategory(_ category: String) -> String {
        switch category.lowercased() {
        case "coffeemachine": return "cup.and.saucer.fill"
        case "ebike": return "bicycle"
        case "skigear": return "figure.skiing.downhill"
        case "electronics", "audiovisual", "television": return "tv.fill"
        default: return "washer.fill"
        }
    }
}

@MainActor
private enum LocalizedCurrencyFormatter {
    static func format(amount: Decimal, currencyCode: String) -> String {
        RegionalFormatter.shared.formatCurrency(amount: amount, currencyCode: currencyCode, locale: LanguageManager.shared.currentLocale)
    }
}
