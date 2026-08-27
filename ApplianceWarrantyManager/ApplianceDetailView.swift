//
//  ApplianceDetailView.swift
//  ApplianceWarrantyManager
//
//  Created for Nordic Asset Suite.
//  Strict Concurrency: Complete. Spatial Room, Maintenance Manuals, Spare Parts & AI Diagnostics.
//

import SwiftUI
import AssetCoreDatabase
import AssetCoreUIComponents
import AssetCoreLocalization
import AssetCoreAI

public struct ApplianceDetailView: View {
    public let appliance: ApplianceDTO
    public let viewModel: ApplianceViewModel
    private let theme = ApplianceTheme()
    private let lang = LanguageManager.shared
    
    @State private var selectedTab: Int = 0
    @State private var showingErrorScanner: Bool = false
    @State private var inputErrorCode: String = ""
    @State private var isDiagnosing: Bool = false
    @State private var diagnosticResult: AIDiagnosticResponse? = nil
    
    public init(appliance: ApplianceDTO, viewModel: ApplianceViewModel) {
        self.appliance = appliance
        self.viewModel = viewModel
    }
    
    public var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Hero Header Card
                BaseCardView(theme: theme) {
                    HStack {
                        VStack(alignment: .leading, spacing: 6) {
                            Text(appliance.brand.uppercased())
                                .font(.caption)
                                .fontWeight(.bold)
                                .foregroundColor(theme.textSecondary)
                            
                            Text(appliance.modelName)
                                .font(.title2)
                                .fontWeight(.bold)
                                .foregroundColor(theme.textPrimary)
                            
                            HStack(spacing: 8) {
                                Label(translateRoom(appliance.roomLocation), systemImage: "door.left.hand.open")
                                    .font(.caption2)
                                    .foregroundColor(theme.textSecondary)
                                
                                if !appliance.serialNumber.isEmpty {
                                    Text("• SN: \(appliance.serialNumber)")
                                        .font(.caption2)
                                        .foregroundColor(theme.textSecondary)
                                }
                            }
                        }
                        Spacer()
                        
                        MetricBadgeView(
                            label: lang.t(.health),
                            value: "\(appliance.latestHealthScore ?? 98)%",
                            status: (appliance.latestHealthScore ?? 98) > 80 ? .success : .warning,
                            theme: theme
                        )
                    }
                }
                
                // Segmented Tab Selector
                Picker("Detail View", selection: $selectedTab) {
                    Text(lang.t(.protocolTab)).tag(0)
                    Text(lang.t(.spareParts)).tag(1)
                    Text(lang.t(.warranty)).tag(2)
                    Text(lang.t(.aiDiagnostics)).tag(3)
                }
                .pickerStyle(.segmented)
                
                // Tab Content
                if selectedTab == 0 {
                    // Maintenance Protocol & Guide
                    let manual = viewModel.getManual(brand: appliance.brand, model: appliance.modelName)
                    MaintenanceManualCardView(manual: manual, theme: theme)
                } else if selectedTab == 1 {
                    // Spare Parts Wear Schedule
                    let partsSchedule = viewModel.getPartsSchedule(brand: appliance.brand, model: appliance.modelName)
                    SparePartsWearView(schedule: partsSchedule, theme: theme) { replacedPart in
                        // Log part replaced
                    }
                } else if selectedTab == 2 {
                } else if selectedTab == 2 {
                    // Multi-Layer Protection & Warranty Details
                    VStack(spacing: 16) {
                        let summary = appliance.warrantySummary
                        
                        // 1. Coverage Overview Card
                        BaseCardView(theme: theme) {
                            VStack(alignment: .leading, spacing: 12) {
                                HStack {
                                    Label(lang.t(.coverageOverview), systemImage: "shield.checkered")
                                        .font(.headline)
                                        .foregroundColor(theme.primaryAccent)
                                    Spacer()
                                    Text(summary.hasActiveProtection ? lang.t(.active) : lang.t(.expired))
                                        .font(.caption2)
                                        .fontWeight(.bold)
                                        .padding(.horizontal, 8)
                                        .padding(.vertical, 4)
                                        .background(summary.hasActiveProtection ? Color.green.opacity(0.12) : Color.red.opacity(0.12))
                                        .foregroundColor(summary.hasActiveProtection ? .green : .red)
                                        .clipShape(Capsule())
                                }
                                
                                Text(summary.hasActiveProtection 
                                     ? "Your appliance is currently covered by active statutory or contractual protection layers." 
                                     : "Standard protection periods have elapsed. Review repair options.")
                                    .font(.caption)
                                    .foregroundColor(theme.textSecondary)
                            }
                        }
                        
                        // 2. Statutory Consumer Rights Card (Against Seller)
                        if let statutory = summary.statutoryProtection {
                            BaseCardView(theme: theme) {
                                VStack(alignment: .leading, spacing: 12) {
                                    HStack {
                                        Label(statutory.titleLocalizedFallback, systemImage: "scale.3d")
                                            .font(.subheadline)
                                            .fontWeight(.bold)
                                            .foregroundColor(.blue)
                                        Spacer()
                                        Text(statutory.status == .active ? lang.t(.active) : (statutory.status == .expiringSoon ? "Expiring Soon" : lang.t(.expired)))
                                            .font(.caption2)
                                            .fontWeight(.bold)
                                            .padding(.horizontal, 8)
                                            .padding(.vertical, 3)
                                            .background(statutory.status == .active ? Color.blue.opacity(0.12) : (statutory.status == .expiringSoon ? Color.orange.opacity(0.15) : Color.gray.opacity(0.15)))
                                            .foregroundColor(statutory.status == .active ? .blue : (statutory.status == .expiringSoon ? .orange : .secondary))
                                            .clipShape(Capsule())
                                    }
                                    
                                    Divider()
                                    
                                    HStack {
                                        Text(lang.t(.statutoryObligorSeller))
                                            .font(.caption)
                                            .foregroundColor(theme.textSecondary)
                                        Spacer()
                                        Text(appliance.sellerName.isEmpty ? "Seller / Retailer" : appliance.sellerName)
                                            .font(.caption)
                                            .fontWeight(.semibold)
                                    }
                                    
                                    if let end = statutory.endDate {
                                        HStack {
                                            Text("Statutory Claim Deadline:")
                                                .font(.caption)
                                                .foregroundColor(theme.textSecondary)
                                            Spacer()
                                            Text(RegionalFormatter.shared.formatDate(end, locale: lang.currentLocale))
                                                .font(.caption)
                                                .fontWeight(.bold)
                                        }
                                        
                                        HStack {
                                            Text(lang.t(.remainingTime))
                                                .font(.caption)
                                                .foregroundColor(theme.textSecondary)
                                            Spacer()
                                            Text(RegionalFormatter.shared.formatRelativeTime(to: end, locale: lang.currentLocale))
                                                .font(.caption)
                                                .foregroundColor(statutory.status == .active ? theme.textSecondary : .red)
                                        }
                                    }
                                    
                                    VStack(alignment: .leading, spacing: 4) {
                                        Text("Source: \(statutory.sourceName)")
                                            .font(.caption2)
                                            .foregroundColor(.secondary)
                                        Text(lang.t(.statutoryNoticeDisclaimer))
                                            .font(.caption2)
                                            .foregroundColor(.secondary)
                                    }
                                    .padding(8)
                                    .background(Color(.secondarySystemBackground))
                                    .clipShape(RoundedRectangle(cornerRadius: 6))
                                }
                            }
                        }
                        
                        // 3. Manufacturer Commercial Warranty Card (Voluntary)
                        if let mfr = summary.manufacturerWarranty {
                            BaseCardView(theme: theme) {
                                VStack(alignment: .leading, spacing: 12) {
                                    HStack {
                                        Label(lang.t(.manufacturerWarrantyTitle), systemImage: "building.2.crop.circle")
                                            .font(.subheadline)
                                            .fontWeight(.bold)
                                            .foregroundColor(.purple)
                                        Spacer()
                                        Text(mfr.status == .active ? lang.t(.active) : (mfr.status == .expiringSoon ? "Expiring Soon" : lang.t(.expired)))
                                            .font(.caption2)
                                            .fontWeight(.bold)
                                            .padding(.horizontal, 8)
                                            .padding(.vertical, 3)
                                            .background(mfr.status == .active ? Color.purple.opacity(0.12) : (mfr.status == .expiringSoon ? Color.orange.opacity(0.15) : Color.gray.opacity(0.15)))
                                            .foregroundColor(mfr.status == .active ? .purple : (mfr.status == .expiringSoon ? .orange : .secondary))
                                            .clipShape(Capsule())
                                    }
                                    
                                    Divider()
                                    
                                    HStack {
                                        Text("Manufacturer Policy:")
                                            .font(.caption)
                                            .foregroundColor(theme.textSecondary)
                                        Spacer()
                                        Text("\(mfr.durationMonths ?? 24) Months (\(appliance.brand))")
                                            .font(.caption)
                                            .fontWeight(.semibold)
                                    }
                                    
                                    if let end = mfr.endDate {
                                        HStack {
                                            Text(lang.t(.warrantyExpiration))
                                                .font(.caption)
                                                .foregroundColor(theme.textSecondary)
                                            Spacer()
                                            Text(RegionalFormatter.shared.formatDate(end, locale: lang.currentLocale))
                                                .font(.caption)
                                                .fontWeight(.bold)
                                        }
                                        
                                        HStack {
                                            Text(lang.t(.remainingTime))
                                                .font(.caption)
                                                .foregroundColor(theme.textSecondary)
                                            Spacer()
                                            Text(RegionalFormatter.shared.formatRelativeTime(to: end, locale: lang.currentLocale))
                                                .font(.caption)
                                                .foregroundColor(mfr.status == .active ? theme.textSecondary : .red)
                                        }
                                    }
                                }
                            }
                        }
                        
                        // 4. Purchase Context & Evidence Card
                        BaseCardView(theme: theme) {
                            VStack(alignment: .leading, spacing: 10) {
                                Label("Purchase & Legal Evidence", systemImage: "doc.text")
                                    .font(.subheadline)
                                    .fontWeight(.bold)
                                    .foregroundColor(theme.textPrimary)
                                
                                Divider()
                                
                                HStack {
                                    Text("Purchase Date:")
                                        .font(.caption)
                                        .foregroundColor(theme.textSecondary)
                                    Spacer()
                                    Text(RegionalFormatter.shared.formatDate(appliance.purchaseDate, locale: lang.currentLocale))
                                        .font(.caption)
                                        .fontWeight(.semibold)
                                }
                                
                                if let dDate = appliance.deliveryDate {
                                    HStack {
                                        Text(lang.t(.deliveryDateLabel))
                                            .font(.caption)
                                            .foregroundColor(theme.textSecondary)
                                        Spacer()
                                        Text(RegionalFormatter.shared.formatDate(dDate, locale: lang.currentLocale))
                                            .font(.caption)
                                            .fontWeight(.semibold)
                                    }
                                }
                                
                                HStack {
                                    Text(lang.t(.purchaseCountryLabel))
                                        .font(.caption)
                                        .foregroundColor(theme.textSecondary)
                                    Spacer()
                                    Text(appliance.purchaseCountry)
                                        .font(.caption)
                                        .fontWeight(.bold)
                                }
                                
                                HStack {
                                    Text(lang.t(.purchaseValue))
                                        .font(.caption)
                                        .foregroundColor(theme.textSecondary)
                                    Spacer()
                                    Text(RegionalFormatter.shared.formatCurrency(amount: appliance.purchasePrice, currencyCode: appliance.currencyCode, locale: lang.currentLocale))
                                        .font(.caption)
                                        .fontWeight(.semibold)
                                }
                            }
                        }
                    }
                } else if selectedTab == 3 {
                    // AI Error Diagnostic Assistant
                    VStack(alignment: .leading, spacing: 16) {
                        BaseCardView(theme: theme) {
                            VStack(alignment: .leading, spacing: 12) {
                                Label(lang.t(.aiDiagnosticAssistant), systemImage: "sparkles")
                                    .font(.headline)
                                    .foregroundColor(.cyan)
                                
                                Text(lang.t(.enterErrorCode))
                                    .font(.caption)
                                    .foregroundColor(theme.textSecondary)
                                
                                HStack {
                                    TextField("e.g. E24, F10, Flashing Red LED...", text: $inputErrorCode)
                                        .textFieldStyle(.roundedBorder)
                                    
                                    Button(action: runDiagnosis) {
                                        if isDiagnosing {
                                            ProgressView()
                                        } else {
                                            Text(lang.t(.diagnose))
                                                .font(.caption)
                                                .fontWeight(.bold)
                                                .padding(.horizontal, 14)
                                                .padding(.vertical, 8)
                                                .background(Color.cyan)
                                                .foregroundColor(.black)
                                                .clipShape(Capsule())
                                        }
                                    }
                                    .disabled(inputErrorCode.isEmpty || isDiagnosing)
                                }
                                
                                HStack(spacing: 6) {
                                    Text(lang.t(.quickTest))
                                        .font(.caption2)
                                        .foregroundColor(theme.textSecondary)
                                    
                                    Button("E24 Drain Error") {
                                        inputErrorCode = "E24 Drain Pump Blocked"
                                        runDiagnosis()
                                    }
                                    .font(.caption2)
                                    .foregroundColor(.cyan)
                                    
                                    Button("F10 Water Intake") {
                                        inputErrorCode = "F10 Water Intake Low"
                                        runDiagnosis()
                                    }
                                    .font(.caption2)
                                    .foregroundColor(.cyan)
                                }
                            }
                        }
                        
                        if let diag = diagnosticResult {
                            BaseCardView(theme: theme) {
                                VStack(alignment: .leading, spacing: 12) {
                                    HStack {
                                        Text(diag.issueTitle)
                                            .font(.headline)
                                            .foregroundColor(theme.textPrimary)
                                        Spacer()
                                        Text(diag.severity.rawValue)
                                            .font(.caption2)
                                            .fontWeight(.bold)
                                            .padding(.horizontal, 8)
                                            .padding(.vertical, 4)
                                            .background(diag.severity == .critical ? Color.red.opacity(0.15) : Color.orange.opacity(0.15))
                                            .foregroundColor(diag.severity == .critical ? .red : .orange)
                                            .clipShape(Capsule())
                                    }
                                    
                                    Divider()
                                    
                                    VStack(alignment: .leading, spacing: 4) {
                                        Text(lang.t(.probableRootCause))
                                            .font(.caption2)
                                            .fontWeight(.bold)
                                            .foregroundColor(theme.textSecondary)
                                        Text(diag.probableRootCause)
                                            .font(.subheadline)
                                            .foregroundColor(theme.textPrimary)
                                    }
                                    
                                    VStack(alignment: .leading, spacing: 6) {
                                        Text(lang.t(.recommendedActionSteps))
                                            .font(.caption2)
                                            .fontWeight(.bold)
                                            .foregroundColor(theme.textSecondary)
                                        
                                        ForEach(diag.recommendedActionSteps, id: \.self) { step in
                                            HStack(alignment: .top, spacing: 6) {
                                                Image(systemName: "wrench.and.screwdriver.fill")
                                                    .font(.caption2)
                                                    .foregroundColor(.cyan)
                                                Text(step)
                                                    .font(.caption)
                                                    .foregroundColor(theme.textPrimary)
                                            }
                                        }
                                    }
                                    
                                    if let cost = diag.estimatedCostRangeCHF {
                                        HStack {
                                            Text(lang.t(.estimatedRepairCost))
                                                .font(.caption)
                                                .foregroundColor(theme.textSecondary)
                                            Spacer()
                                            Text(cost)
                                                .font(.caption)
                                                .fontWeight(.bold)
                                                .foregroundColor(theme.textPrimary)
                                        }
                                        .padding(8)
                                        .background(Color(.secondarySystemBackground))
                                        .clipShape(RoundedRectangle(cornerRadius: 8))
                                    }
                                }
                            }
                        }
                    }
                }
            }
            .padding()
        }
        .background(theme.backgroundGrouped)
        .navigationTitle(appliance.modelName)
        .navigationBarTitleDisplayMode(.inline)
    }
    
    private func translateRoom(_ room: String) -> String {
        switch room.lowercased() {
        case "kitchen": return lang.t(.kitchen)
        case "living room": return lang.t(.roomLivingFull)
        case "laundry room": return lang.t(.roomLaundryFull)
        case "bathroom": return lang.t(.applianceRoomBathroom)
        case "basement": return lang.t(.basement)
        case "utility closet": return lang.t(.utilityCloset)
        case "office": return lang.t(.office)
        default: return room
        }
    }
    
    private func runDiagnosis() {
        guard !inputErrorCode.isEmpty else { return }
        isDiagnosing = true
        
        Task {
            if let result = try? await GeminiDirectClient.shared.diagnoseHardware(
                domain: "Appliance",
                brand: appliance.brand,
                modelName: appliance.modelName,
                errorCodeOrSymptom: inputErrorCode
            ) {
                self.diagnosticResult = result
            } else {
                // Fallback local diagnosis
                self.diagnosticResult = AIDiagnosticResponse(
                    issueTitle: "Diagnostic Assessment: \(inputErrorCode)",
                    probableRootCause: "Obstruction in drainage pump filter or temporary sensor mismatch.",
                    severity: .medium,
                    recommendedActionSteps: [
                        "Disconnect appliance power and water inlet.",
                        "Open the lower service flap and unscrew the coin trap / drain filter.",
                        "Check impeller for foreign objects (coins, lint, hairpin).",
                        "Reinstall filter tightly and run short test cycle."
                    ],
                    requiresProfessionalService: false,
                    estimatedCostRangeCHF: "0 - 45 CHF (DIY)",
                    updatedHealthScore: 85,
                    providerUsed: .localFallback
                )
            }
            self.isDiagnosing = false
        }
    }
}
