//
//  AddApplianceScannerView.swift
//  ApplianceWarrantyManager
//
//  Created for Nordic Asset Suite.
//  Strict Concurrency: Complete. Vision OCR & Multimodal AI Ingestion Sheet.
//

import SwiftUI
import AssetCoreUIComponents
import AssetCoreOCR
import AssetCoreAI

public struct AddApplianceScannerView: View {
    @Environment(\.dismiss) private var dismiss
    
    private let theme = ApplianceTheme()
    private let onAdd: (String, String, String, String, Decimal, String) -> Void
    
    @State private var brand: String = ""
    @State private var modelName: String = ""
    @State private var serialNumber: String = ""
    @State private var roomLocation: String = "Kitchen"
    @State private var purchasePriceText: String = "1250.00"
    @State private var currencyCode: String = "CHF"
    @State private var isScanning: Bool = false
    @State private var scanStatusMessage: String? = nil
    
    private let roomOptions = ["Kitchen", "Laundry Room", "Bathroom", "Basement", "Living Room", "Utility Closet"]
    
    public init(onAdd: @escaping (String, String, String, String, Decimal, String) -> Void) {
        self.onAdd = onAdd
    }
    
    public var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Smart Ingestion (Apple Vision & AI)")) {
                    Button(action: performSimulatedScan) {
                        HStack {
                            Image(systemName: "camera.viewfinder")
                                .font(.title3)
                                .foregroundColor(theme.primaryAccent)
                            VStack(alignment: .leading, spacing: 2) {
                                Text("Scan Rating Badge / Receipt")
                                    .fontWeight(.semibold)
                                    .foregroundColor(theme.textPrimary)
                                Text("Auto-detects Brand, Serial, Model, & Price")
                                    .font(.caption)
                                    .foregroundColor(theme.textSecondary)
                            }
                            Spacer()
                            if isScanning {
                                ProgressView()
                            }
                        }
                    }
                    if let status = scanStatusMessage {
                        Text(status)
                            .font(.caption)
                            .foregroundColor(theme.statusSuccess)
                    }
                }
                
                Section(header: Text("Appliance Details")) {
                    TextField("Brand (e.g. V-ZUG, Miele, Bosch)", text: $brand)
                    TextField("Model (e.g. AdoraWaschen V4000)", text: $modelName)
                    TextField("Serial Number (e.g. SN-981240)", text: $serialNumber)
                    
                    Picker("Room Location", selection: $roomLocation) {
                        ForEach(roomOptions, id: \.self) { room in
                            Text(room).tag(room)
                        }
                    }
                }
                
                Section(header: Text("Purchase & Warranty")) {
                    HStack {
                        TextField("Price", text: $purchasePriceText)
                            .keyboardType(.decimalPad)
                        
                        Picker("Currency", selection: $currencyCode) {
                            Text("CHF").tag("CHF")
                            Text("EUR").tag("EUR")
                            Text("DKK").tag("DKK")
                            Text("NOK").tag("NOK")
                            Text("SEK").tag("SEK")
                        }
                        .pickerStyle(.segmented)
                    }
                }
            }
            .navigationTitle("Add Appliance")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        let price = Decimal(string: purchasePriceText) ?? 0.0
                        onAdd(brand, modelName, serialNumber, roomLocation, price, currencyCode)
                        dismiss()
                    }
                    .disabled(brand.isEmpty || modelName.isEmpty)
                }
            }
        }
    }
    
    private func performSimulatedScan() {
        isScanning = true
        scanStatusMessage = "Analyzing rating badge with Apple Vision..."
        
        Task {
            try? await Task.sleep(nanoseconds: 800_000_000)
            // Simulated scan result
            brand = "V-ZUG"
            modelName = "AdoraWaschen V4000"
            serialNumber = "2304891104"
            purchasePriceText = "2350.00"
            currencyCode = "CHF"
            roomLocation = "Laundry Room"
            scanStatusMessage = "Badge verified locally (Confidence: 96%)"
            isScanning = false
        }
    }
}
