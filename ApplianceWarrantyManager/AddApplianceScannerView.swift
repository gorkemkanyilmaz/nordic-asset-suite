//
//  AddApplianceScannerView.swift
//  ApplianceWarrantyManager
//
//  Created for Nordic Asset Suite.
//  Strict Concurrency: Complete. Vision OCR & Multimodal AI Ingestion Sheet with Live Camera.
//

import SwiftUI
import AssetCoreUIComponents
import AssetCoreOCR
import AssetCoreAI
import AssetCoreLocalization

public struct AddApplianceScannerView: View {
    @Environment(\.dismiss) private var dismiss
    private let lang = LanguageManager.shared
    
    private let theme = ApplianceTheme()
    public let onConfirmMatch: (ProductCandidateMatch) -> Void
    public let onManualAdd: (String, String, String, String, Decimal, String) -> Void
    
    @State private var showingLiveCamera: Bool = true
    @State private var manualSearchText: String = ""
    @State private var brand: String = ""
    @State private var modelName: String = ""
    @State private var serialNumber: String = ""
    @State private var roomLocation: String = "Kitchen"
    @State private var purchasePriceText: String = "1450.00"
    @State private var currencyCode: String = "CHF"
    @State private var isProcessingAI: Bool = false
    @State private var identifiedMatch: ProductCandidateMatch? = nil
    
    private var roomOptions: [String] {
        [lang.t(.kitchen), lang.t(.livingRoom), lang.t(.laundryRoom), lang.t(.applianceRoomBathroom), lang.t(.basement), lang.t(.utilityCloset), lang.t(.office)]
    }
    
    public init(
        onConfirmMatch: @escaping (ProductCandidateMatch) -> Void,
        onManualAdd: @escaping (String, String, String, String, Decimal, String) -> Void
    ) {
        self.onConfirmMatch = onConfirmMatch
        self.onManualAdd = onManualAdd
    }
    
    public var body: some View {
        NavigationStack {
            ZStack {
                Form {
                    Section(header: Text(lang.t(.smartIngestion))) {
                        Button(action: { showingLiveCamera = true }) {
                            HStack {
                                Image(systemName: "camera.viewfinder")
                                    .font(.title2)
                                    .foregroundColor(.cyan)
                                
                                VStack(alignment: .leading, spacing: 3) {
                                    Text(lang.t(.openLiveCamera))
                                        .font(.subheadline)
                                        .fontWeight(.bold)
                                        .foregroundColor(theme.textPrimary)
                                    Text(lang.t(.scansBarcodes))
                                        .font(.caption2)
                                        .foregroundColor(theme.textSecondary)
                                }
                                Spacer()
                                Image(systemName: "chevron.right")
                                    .font(.caption)
                                    .foregroundColor(theme.textSecondary)
                            }
                            .padding(.vertical, 4)
                        }
                    }
                    
                    Section(header: Text(lang.t(.orTypeModelName))) {
                        HStack {
                            Image(systemName: "sparkles")
                                .foregroundColor(.cyan)
                            TextField("e.g. Samsung QN85D, Miele W1, Jura E8...", text: $manualSearchText)
                                .submitLabel(.search)
                                .onSubmit {
                                    triggerAISearch(query: manualSearchText)
                                }
                            
                            if !manualSearchText.isEmpty {
                                Button(action: { triggerAISearch(query: manualSearchText) }) {
                                    if isProcessingAI {
                                        ProgressView()
                                    } else {
                                        Text(lang.t(.identify))
                                            .font(.caption)
                                            .fontWeight(.bold)
                                            .padding(.horizontal, 10)
                                            .padding(.vertical, 6)
                                            .background(Color.cyan)
                                            .foregroundColor(.black)
                                            .clipShape(Capsule())
                                    }
                                }
                            }
                        }
                    }
                    
                    Section(header: Text(lang.t(.applianceDetails))) {
                        TextField(lang.t(.brandPlaceholder), text: $brand)
                        TextField(lang.t(.modelPlaceholder), text: $modelName)
                        TextField(lang.t(.serialPlaceholder), text: $serialNumber)
                        
                        Picker(lang.t(.roomLocation), selection: $roomLocation) {
                            ForEach(roomOptions, id: \.self) { room in
                                Text(room).tag(room)
                            }
                        }
                    }
                    
                    Section(header: Text(lang.t(.purchaseAndWarranty))) {
                        HStack {
                            TextField(lang.t(.price), text: $purchasePriceText)
                                .keyboardType(.decimalPad)
                            
                            Picker(lang.t(.currency), selection: $currencyCode) {
                                Text("CHF").tag("CHF")
                                Text("EUR").tag("EUR")
                                Text("DKK").tag("DKK")
                                Text("NOK").tag("NOK")
                                Text("SEK").tag("SEK")
                                Text("USD").tag("USD")
                            }
                            .pickerStyle(.segmented)
                        }
                    }
                }
                
                if isProcessingAI {
                    ZStack {
                        Color.black.opacity(0.4).ignoresSafeArea()
                        VStack(spacing: 14) {
                            ProgressView()
                                .scaleEffect(1.3)
                                .tint(.cyan)
                            Text(lang.t(.geminiIdentifying))
                                .font(.subheadline)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                        }
                        .padding(24)
                        .background(Color(.systemGray6))
                        .clipShape(RoundedRectangle(cornerRadius: 18))
                    }
                }
            }
            .navigationTitle(lang.t(.addAsset))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button(lang.t(.cancel)) { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button(lang.t(.save)) {
                        let price = Decimal(string: purchasePriceText) ?? 0.0
                        onManualAdd(brand, modelName, serialNumber, roomLocation, price, currencyCode)
                        dismiss()
                    }
                    .disabled(brand.isEmpty || modelName.isEmpty)
                }
            }
            .fullScreenCover(isPresented: $showingLiveCamera) {
                LiveScannerSwiftUIView(
                    onDetectedBarcode: { barcode in
                        triggerAISearch(barcode: barcode)
                    },
                    onCapturedPhoto: { photoData in
                        triggerAISearch(imageData: photoData)
                    },
                    onManualSearchSubmit: { query in
                        triggerAISearch(query: query)
                    }
                )
            }
            .sheet(item: $identifiedMatch) { match in
                ProductConfirmationModal(
                    match: match,
                    onConfirm: { confirmed in
                        onConfirmMatch(confirmed)
                        dismiss()
                    },
                    onEdit: {
                        self.brand = match.brand
                        self.modelName = match.modelName
                        self.serialNumber = match.serialNumber ?? "SN-\(Int.random(in: 100000...999999))"
                        if let price = match.estimatedPrice {
                            self.purchasePriceText = "\(price)"
                        }
                    }
                )
            }
        }
    }
    
    private func triggerAISearch(query: String = "", imageData: Data? = nil, barcode: String? = nil) {
        isProcessingAI = true
        let searchText = query.isEmpty ? (barcode ?? "Samsung QN85D") : query
        
        Task {
            let match = await AIExtractionService.shared.identifyOmniProduct(
                queryOrText: searchText,
                imageData: imageData,
                barcode: barcode
            )
            self.isProcessingAI = false
            self.identifiedMatch = match
        }
    }
}
