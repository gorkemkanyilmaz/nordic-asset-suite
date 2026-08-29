//
//  LegalDefectNoticeModal.swift
//  ApplianceWarrantyManager
//
//  Created for Nordic Asset Suite.
//  Strict Concurrency: Complete. 1-Tap Official Statutory Defect Claim Notice Generator.
//

import SwiftUI
#if canImport(UIKit)
import UIKit
#endif
import AssetCoreDatabase
import AssetCoreUIComponents
import AssetCoreLocalization

public enum DefectCategory: String, CaseIterable, Identifiable, Sendable {
    case electronicControl = "ELECTRONIC_CONTROL"
    case motorInverter = "MOTOR_INVERTER"
    case heatingPump = "HEATING_PUMP"
    case doorSeal = "DOOR_SEAL"
    case unresponsivePower = "UNRESPONSIVE_POWER"
    
    public var id: String { rawValue }
    
    public var title: String {
        switch self {
        case .electronicControl: return "Electronic Control & Display Failure"
        case .motorInverter: return "Drive Motor / Inverter Compressor Breakdown"
        case .heatingPump: return "Heating Element & Water Pump Failure"
        case .doorSeal: return "Hydraulic Door Gasket & Seal Leakage"
        case .unresponsivePower: return "Completely Unresponsive to Power Supply"
        }
    }
    
    public var description: String {
        switch self {
        case .electronicControl:
            return "The internal electronic power control module and display panel have ceased functioning under normal domestic usage conditions, rendering the appliance inoperable."
        case .motorInverter:
            return "The primary drive motor / inverter compressor exhibits mechanical breakdown and failure to engage, not attributable to external impact or user error."
        case .heatingPump:
            return "The heating element and circulation water pump failed prematurely to reach operational temperature and maintain correct pressure."
        case .doorSeal:
            return "Premature hydraulic seal and gasket degradation causing leakage during standard operational cycles."
        case .unresponsivePower:
            return "The appliance is entirely unresponsive to electrical supply despite verified mains connectivity, indicating an internal component defect present at delivery."
        }
    }
}

public enum ClaimRemedy: String, CaseIterable, Identifiable, Sendable {
    case repair = "REPAIR"
    case replacement = "REPLACEMENT"
    case refund = "REFUND"
    
    public var id: String { rawValue }
    
    public var title: String {
        switch self {
        case .repair: return "Free Repair (Nachbesserung / Reparasjon)"
        case .replacement: return "Free Replacement Delivery (Ersatzlieferung)"
        case .refund: return "Contract Rescission & Refund (Wandelung / Heving)"
        }
    }
    
    public var legalText: String {
        switch self {
        case .repair:
            return "immediate free-of-charge repair (Nachbesserung / Reparasjon) by an authorized service partner with zero cost burden to the consumer."
        case .replacement:
            return "prompt delivery of a conforming, brand-new replacement appliance (Ersatzlieferung / Omlevering)."
        case .refund:
            return "rescission of the purchase agreement and immediate full refund of the original purchase price (Wandelung / Heving)."
        }
    }
}

public struct LegalDefectNoticeModal: View {
    @Environment(\.dismiss) private var dismiss
    public let appliance: ApplianceDTO
    private let theme = ApplianceTheme()
    
    @State private var selectedDefect: DefectCategory = .electronicControl
    @State private var selectedRemedy: ClaimRemedy = .repair
    @State private var copiedToast: Bool = false
    
    public init(appliance: ApplianceDTO, presetDefect: DefectCategory? = nil) {
        self.appliance = appliance
        if let preset = presetDefect {
            _selectedDefect = State(initialValue: preset)
        }
    }
    
    private var legalFramework: (citation: String, badge: String, period: String) {
        switch appliance.purchaseCountry.uppercased() {
        case "CH":
            return (
                citation: "Swiss Code of Obligations (OR) Art. 210 in conjunction with Art. 205 (Mängelrüge / Gewährleistung des Verkäufers)",
                badge: "Swiss OR Art. 210",
                period: "24 months"
            )
        case "NO":
            return (
                citation: "Norwegian Consumer Purchases Act (Forbrukerkjøpsloven) § 27 second paragraph (5-year statutory defect claim right for durable appliances)",
                badge: "Forbrukerkjøpsloven § 27 (5 Yrs)",
                period: "5 years"
            )
        case "SE":
            return (
                citation: "Swedish Consumer Sales Act (Konsumentköplagen) 4 kap. 14 § (3-year statutory defect claim right against seller)",
                badge: "Konsumentköplagen (3 Yrs)",
                period: "3 years"
            )
        case "DK":
            return (
                citation: "Danish Sale of Goods Act (Købeloven) §§ 54, 83 (2-year statutory right of complaint / 2 års reklamationsret)",
                badge: "Købeloven §§ 54, 83",
                period: "2 years"
            )
        case "AT":
            return (
                citation: "Austrian Consumer Warranty Act (VGG) & General Civil Code (ABGB § 922 ff.)",
                badge: "Austrian VGG / ABGB",
                period: "24 months"
            )
        default:
            return (
                citation: "EU Directive 2019/771 on Consumer Sales of Goods & Statutory Conformity Rights",
                badge: "EU Conformity Rights",
                period: "24 months"
            )
        }
    }
    
    private var sellerDisplayName: String {
        if !appliance.sellerName.isEmpty { return appliance.sellerName }
        switch appliance.purchaseCountry.uppercased() {
        case "CH": return "Digitec Galaxus AG / Fust AG / Authorized Swiss Dealer"
        case "NO": return "Elkjøp Nordic AS / Power AS"
        case "SE": return "Elgiganten AB / MediaMarkt Sweden"
        default: return "Authorized Retailer & Service Department"
        }
    }
    
    private var generatedNoticeText: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        let todayStr = formatter.string(from: Date())
        let purchaseStr = formatter.string(from: appliance.purchaseDate)
        let deliveryStr = appliance.deliveryDate.map { formatter.string(from: $0) } ?? purchaseStr
        let warrantyEndStr = formatter.string(from: appliance.warrantyEndDate)
        let statusStr = appliance.isWarrantyActive ? "CURRENTLY ACTIVE (Valid until \(warrantyEndStr))" : "Statutory Defect Rights Window"
        
        return """
FORMAL NOTICE OF STATUTORY DEFECT (MÄNGELRÜGE / REKLAMASJON)
----------------------------------------------------------------------
To: \(sellerDisplayName) (Customer Service & Warranty Claims Division)
Date: \(todayStr)

REGARDING:
Product: \(appliance.brand) \(appliance.modelName)
Serial Number: \(appliance.serialNumber.isEmpty ? "SN-ON-INVOICE" : appliance.serialNumber)
Handover / Delivery Date: \(deliveryStr) (Purchase Date: \(purchaseStr))
Statutory Coverage Status: \(statusStr)

STATEMENT OF NON-CONFORMITY & DEFECT:
I hereby officially notify you of a material defect in the above-mentioned household appliance, supplied by your company.

Defect Summary:
\(selectedDefect.description)

LEGAL GROUNDS:
Under \(legalFramework.citation), the seller is statutorily liable for lack of conformity existing at the time of delivery, subject to a statutory period of \(legalFramework.period). This defect constitutes a failure of inherent durability and functionality that I could not reasonably expect under standard domestic usage.

DEMANDED REMEDY:
Pursuant to statutory consumer protection law, I formally request \(selectedRemedy.legalText)

Please confirm receipt of this notice within 5 business days and provide the RMA reference number or instructions for authorized technician scheduling.

Sincerely,
Verified Consumer & Device Owner
(Generated via Nordic Asset Suite • Appliance Vault Pro)
"""
    }
    
    public var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 16) {
                    headerBanner
                    
                    // Options Card
                    VStack(alignment: .leading, spacing: 14) {
                        Text("1. DEFECT SYMPTOM / CATEGORY")
                            .font(.caption2)
                            .fontWeight(.bold)
                            .foregroundColor(theme.textSecondary)
                        
                        Picker("Defect Category", selection: $selectedDefect) {
                            ForEach(DefectCategory.allCases) { category in
                                Text(category.title).tag(category)
                            }
                        }
                        .pickerStyle(.menu)
                        .padding(10)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(theme.surfaceElevated)
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                        
                        Divider()
                        
                        Text("2. DEMANDED STATUTORY REMEDY")
                            .font(.caption2)
                            .fontWeight(.bold)
                            .foregroundColor(theme.textSecondary)
                        
                        Picker("Demanded Remedy", selection: $selectedRemedy) {
                            ForEach(ClaimRemedy.allCases) { remedy in
                                Text(remedy.title).tag(remedy)
                            }
                        }
                        .pickerStyle(.menu)
                        .padding(10)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(theme.surfaceElevated)
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                    }
                    .padding(16)
                    .background(theme.cardBackground)
                    .clipShape(RoundedRectangle(cornerRadius: 14))
                    .overlay(
                        RoundedRectangle(cornerRadius: 14)
                            .stroke(theme.borderSubtle, lineWidth: 1)
                    )
                    
                    // Notice Letter Preview Card
                    VStack(alignment: .leading, spacing: 10) {
                        HStack {
                            Image(systemName: "doc.text.fill")
                                .foregroundColor(theme.primaryAccent)
                            Text("OFFICIAL NOTICE DRAFT")
                                .font(.caption2)
                                .fontWeight(.bold)
                                .foregroundColor(theme.textSecondary)
                            Spacer()
                            Text(legalFramework.badge)
                                .font(.caption2)
                                .fontWeight(.bold)
                                .padding(.horizontal, 8)
                                .padding(.vertical, 3)
                                .background(theme.primaryAccent.opacity(0.15))
                                .foregroundColor(theme.primaryAccent)
                                .clipShape(Capsule())
                        }
                        
                        Text(generatedNoticeText)
                            .font(.system(.caption2, design: .monospaced))
                            .foregroundColor(theme.textPrimary)
                            .padding(12)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background(Color.black.opacity(0.3))
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                    }
                    .padding(16)
                    .background(theme.cardBackground)
                    .clipShape(RoundedRectangle(cornerRadius: 14))
                    .overlay(
                        RoundedRectangle(cornerRadius: 14)
                            .stroke(theme.borderSubtle, lineWidth: 1)
                    )
                    
                    // Action Buttons
                    VStack(spacing: 10) {
                        Button(action: copyToClipboard) {
                            HStack {
                                Image(systemName: copiedToast ? "checkmark" : "doc.on.doc.fill")
                                Text(copiedToast ? "Copied to Clipboard!" : "Copy Legal Notice Letter")
                                    .fontWeight(.bold)
                            }
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 14)
                            .background(theme.primaryAccent)
                            .foregroundColor(.white)
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                        }
                        
                        ShareLink(item: generatedNoticeText, subject: Text("Formal Defect Notice: \(appliance.brand) \(appliance.modelName)"), message: Text(generatedNoticeText)) {
                            HStack {
                                Image(systemName: "square.and.arrow.up")
                                Text("Share / Email Notice to Seller")
                                    .fontWeight(.semibold)
                            }
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 12)
                            .background(theme.surfaceElevated)
                            .foregroundColor(theme.textPrimary)
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(theme.borderSubtle, lineWidth: 1)
                            )
                        }
                    }
                    .padding(.top, 4)
                }
                .padding()
            }
            .background(theme.backgroundGrouped.ignoresSafeArea())
            .preferredColorScheme(.dark)
            .navigationTitle("Legal Defect Notice")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Close") { dismiss() }
                }
            }
        }
    }
    
    private var headerBanner: some View {
        HStack(spacing: 12) {
            Image(systemName: "scale.3d")
                .font(.title2)
                .foregroundColor(theme.primaryAccent)
            
            VStack(alignment: .leading, spacing: 2) {
                Text("Official Statutory Defect Notice")
                    .font(.subheadline)
                    .fontWeight(.bold)
                    .foregroundColor(theme.textPrimary)
                Text("Generate legally binding *Mängelrüge / Reklamasjon* under \(legalFramework.badge).")
                    .font(.caption2)
                    .foregroundColor(theme.textSecondary)
            }
            Spacer()
        }
        .padding(14)
        .background(theme.primaryAccent.opacity(0.1))
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
    
    private func copyToClipboard() {
        #if os(iOS)
        UIPasteboard.general.string = generatedNoticeText
        UIImpactFeedbackGenerator(style: .medium).impactOccurred()
        #endif
        copiedToast = true
        Task {
            try? await Task.sleep(nanoseconds: 2_000_000_000)
            copiedToast = false
        }
    }
}
