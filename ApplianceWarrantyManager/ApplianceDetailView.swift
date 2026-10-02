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
    @State private var lang = LanguageManager.shared
    
    @Environment(\.dismiss) private var dismiss
    @State private var selectedTab: Int = 0
    @State private var inputErrorCode: String = ""
    @State private var isDiagnosing: Bool = false
    @State private var diagnosticResult: AIDiagnosticResponse? = nil
    @State private var showingLegalDefectModal: Bool = false
    @State private var showingErrorCodeWizard: Bool = false
    @State private var showingDeleteAlert: Bool = false
    
    // Purchase Context Editable State
    @State private var editPurchaseDate: Date = Date()
    @State private var editDeliveryDate: Date = Date()
    @State private var editCountry: String = "CH"
    @State private var editRoom: String = "Living Room"
    @State private var editWarrantyMonths: Int = 24
    @State private var editPrice: String = ""
    @State private var isInitialized: Bool = false
    
    public init(appliance: ApplianceDTO, viewModel: ApplianceViewModel) {
        self.appliance = appliance
        self.viewModel = viewModel
    }
    
    public var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                // 1. Hero Header Card
                BaseCardView(theme: theme) {
                    HStack(spacing: 14) {
                        ProductThumbnailView(
                            userImageData: appliance.appliancePhotoData,
                            verifiedImageUrl: (appliance.imageUrl != nil && !appliance.imageUrl!.isEmpty) ? URL(string: appliance.imageUrl!) : nil,
                            categoryIconName: iconForCategory(appliance.category),
                            variant: .medium,
                            cornerRadius: 12,
                            theme: theme
                        )
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text(appliance.brand.uppercased())
                                .font(.caption2)
                                .fontWeight(.bold)
                                .foregroundColor(theme.textMuted)
                            
                            Text(appliance.modelName)
                                .font(.headline)
                                .fontWeight(.bold)
                                .foregroundColor(theme.textPrimary)
                            
                            HStack(spacing: 6) {
                                Text(translateRoom(appliance.roomLocation))
                                    .font(.caption2)
                                    .foregroundColor(theme.textSecondary)
                                
                                Text("·")
                                    .foregroundColor(theme.textMuted)
                                
                                let serialLast4 = appliance.serialNumber.count > 4 ? String(appliance.serialNumber.suffix(4)) : (appliance.serialNumber.isEmpty ? "9912" : appliance.serialNumber)
                                Text("Serial •••• \(serialLast4)")
                                    .font(.caption2)
                                    .foregroundColor(theme.textMuted)
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
                
                // 2. Multi-Layer Protection & Warranty Cards Container
                coverageOverviewCards
                
                // 3. Purchase Evidence & Legal Context Box
                purchaseEvidenceBox
                
                // 4. High-Value Pro Actions: Legal Defect Notice & Error Code Wizard
                HStack(spacing: 10) {
                    Button(action: { showingLegalDefectModal = true }) {
                        HStack(spacing: 6) {
                            Image(systemName: "filemenu.and.selection")
                            Text(lang.t(.drawerLegalNoticeBtn))
                                .font(.caption)
                                .fontWeight(.bold)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 12)
                        .background(Color.cyan.opacity(0.12))
                        .foregroundColor(.cyan)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.cyan.opacity(0.4), lineWidth: 1)
                        )
                    }
                    
                    Button(action: { showingErrorCodeWizard = true }) {
                        HStack(spacing: 6) {
                            Image(systemName: "wrench.and.screwdriver.fill")
                            Text(lang.t(.drawerErrorWizardBtn))
                                .font(.caption)
                                .fontWeight(.bold)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 12)
                        .background(Color.purple.opacity(0.12))
                        .foregroundColor(Color(red: 0.8, green: 0.55, blue: 1.0))
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.purple.opacity(0.4), lineWidth: 1)
                        )
                    }
                }
                
                // 5. Segmented Tab Selector (Specs, Maintenance, Parts & Wear, Diagnostics)
                Picker("Detail View", selection: $selectedTab) {
                    Text(lang.t(.drawerTabSpecs)).tag(0)
                    Text(lang.t(.drawerTabMaintenance)).tag(1)
                    Text(lang.t(.drawerTabParts)).tag(2)
                    Text(lang.t(.drawerTabDiagnostics)).tag(3)
                }
                .pickerStyle(.segmented)
                
                // Tab Content
                if selectedTab == 0 {
                    specsPane
                } else if selectedTab == 1 {
                    let manual = viewModel.getManual(brand: appliance.brand, model: appliance.modelName)
                    MaintenanceManualCardView(manual: manual, theme: theme)
                } else if selectedTab == 2 {
                    let partsSchedule = viewModel.getPartsSchedule(brand: appliance.brand, model: appliance.modelName)
                    SparePartsWearView(schedule: partsSchedule, theme: theme) { _ in }
                } else if selectedTab == 3 {
                    diagnosticsPane
                }
                
                // 6. Danger Zone: Delete Asset
                Button(action: { showingDeleteAlert = true }) {
                    HStack {
                        Image(systemName: "trash")
                        Text(lang.t(.drawerDeleteBtn))
                            .fontWeight(.semibold)
                    }
                    .font(.caption)
                    .foregroundColor(.red)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 12)
                    .background(Color.red.opacity(0.08))
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.red.opacity(0.3), lineWidth: 1)
                    )
                }
                .padding(.top, 10)
            }
            .padding()
        }
        .background(theme.backgroundGrouped.ignoresSafeArea())
        .navigationTitle(appliance.modelName)
        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: $showingLegalDefectModal) {
            LegalDefectNoticeModal(appliance: appliance)
        }
        .sheet(isPresented: $showingErrorCodeWizard) {
            ErrorCodeWizardModal(appliance: appliance)
        }
        .alert("Delete Appliance?", isPresented: $showingDeleteAlert) {
            Button("Cancel", role: .cancel) {}
            Button("Delete", role: .destructive) {
                Task {
                    await viewModel.deleteAppliance(id: appliance.id)
                    dismiss()
                }
            }
        } message: {
            Text("Are you sure you want to permanently delete this \(appliance.brand) \(appliance.modelName)? This action cannot be undone.")
        }
        .task {
            if !isInitialized {
                editPurchaseDate = appliance.purchaseDate
                editDeliveryDate = appliance.deliveryDate ?? appliance.purchaseDate
                editCountry = appliance.purchaseCountry
                editRoom = appliance.roomLocation
                editWarrantyMonths = appliance.manufacturerWarrantyMonths ?? 24
                editPrice = "\(appliance.purchasePrice)"
                isInitialized = true
            }
            await viewModel.prefetchManualAndParts(
                brand: appliance.brand,
                model: appliance.modelName,
                category: appliance.category
            )
        }
    }
    
    // MARK: - Multi-Layer Coverage Cards
    
    private var coverageOverviewCards: some View {
        VStack(spacing: 10) {
            let summary = appliance.warrantySummary
            
            // 1. Overall Status Card
            BaseCardView(theme: theme) {
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Text(lang.t(.coverageOverview).uppercased())
                            .font(.system(size: 10, weight: .bold))
                            .foregroundColor(theme.textMuted)
                        Spacer()
                        Text(summary.hasActiveProtection ? lang.t(.statusActive) : lang.t(.statusExpired))
                            .font(.system(size: 10, weight: .bold))
                            .padding(.horizontal, 8)
                            .padding(.vertical, 3)
                            .background(summary.hasActiveProtection ? theme.statusSuccess.opacity(0.15) : theme.statusCritical.opacity(0.15))
                            .foregroundColor(summary.hasActiveProtection ? theme.statusSuccess : theme.statusCritical)
                            .clipShape(Capsule())
                    }
                    
                    Text(summary.hasActiveProtection ? lang.t(.statFullyCovered) : lang.t(.statusExpired))
                        .font(.subheadline)
                        .fontWeight(.bold)
                        .foregroundColor(theme.textPrimary)
                    
                    Text("Statutory defect rights and manufacturer warranty evaluated independently.")
                        .font(.caption2)
                        .foregroundColor(theme.textSecondary)
                }
            }
            
            // 2. Statutory Consumer Rights Card (Against Seller)
            if let statutory = summary.statutoryProtection {
                VStack(alignment: .leading, spacing: 6) {
                    HStack {
                        Label(lang.t(.statutoryProtectionTitle), systemImage: "scale.3d")
                            .font(.caption)
                            .fontWeight(.bold)
                            .foregroundColor(.cyan)
                        Spacer()
                        Text(statutory.status == .active ? lang.t(.statusActive) : lang.t(.statusExpired))
                            .font(.system(size: 9, weight: .bold))
                            .padding(.horizontal, 6)
                            .padding(.vertical, 2)
                            .background(statutory.status == .active ? Color.cyan.opacity(0.15) : Color.red.opacity(0.15))
                            .foregroundColor(statutory.status == .active ? .cyan : .red)
                            .clipShape(Capsule())
                    }
                    
                    if let end = statutory.endDate {
                        let daysText = statutory.status == .active ? "\(lang.t(.statusActive)) · \(RegionalFormatter.shared.formatDate(end))" : "\(lang.t(.statusExpired)) · \(RegionalFormatter.shared.formatDate(end))"
                        Text(daysText)
                            .font(.subheadline)
                            .fontWeight(.bold)
                            .foregroundColor(theme.textPrimary)
                    }
                    
                    Text("Claim Obligor: \(appliance.sellerName.isEmpty ? "Seller / Retailer" : appliance.sellerName)")
                        .font(.caption2)
                        .foregroundColor(theme.textSecondary)
                    
                    Text("Source: \(statutory.sourceName)")
                        .font(.system(size: 9))
                        .foregroundColor(theme.textMuted)
                        .padding(.top, 2)
                }
                .padding(12)
                .background(Color.cyan.opacity(0.06))
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.cyan.opacity(0.25), lineWidth: 1)
                )
            }
            
            // 3. Manufacturer Commercial Warranty Card
            if let mfr = summary.manufacturerWarranty {
                VStack(alignment: .leading, spacing: 6) {
                    HStack {
                        Label(lang.t(.manufacturerCommercialTitle), systemImage: "shield.lefthalf.filled")
                            .font(.caption)
                            .fontWeight(.bold)
                            .foregroundColor(Color.purple)
                        Spacer()
                        Text(mfr.status == .active ? lang.t(.statusActive) : lang.t(.statusExpired))
                            .font(.system(size: 9, weight: .bold))
                            .padding(.horizontal, 6)
                            .padding(.vertical, 2)
                            .background(mfr.status == .active ? Color.purple.opacity(0.15) : Color.red.opacity(0.15))
                            .foregroundColor(mfr.status == .active ? Color.purple : .red)
                            .clipShape(Capsule())
                    }
                    
                    if let end = mfr.endDate {
                        let dur = mfr.durationMonths ?? 24
                        Text("\(RegionalFormatter.shared.formatDate(end)) (\(dur) \(lang.t(.monthsWarranty)))")
                            .font(.subheadline)
                            .fontWeight(.bold)
                            .foregroundColor(theme.textPrimary)
                    }
                    
                    Text("Source: Verified \(appliance.brand) Commercial Policy")
                        .font(.system(size: 9))
                        .foregroundColor(theme.textMuted)
                }
                .padding(12)
                .background(Color.purple.opacity(0.06))
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.purple.opacity(0.25), lineWidth: 1)
                )
            }
        }
    }
    
    // MARK: - Purchase Evidence & Legal Context Box (Interactive Edit)
    
    private var purchaseEvidenceBox: some View {
        BaseCardView(theme: theme) {
            VStack(alignment: .leading, spacing: 10) {
                Label(lang.t(.drawerEvidenceHeader), systemImage: "doc.text")
                    .font(.caption)
                    .fontWeight(.bold)
                    .foregroundColor(theme.textPrimary)
                
                Divider()
                
                // Purchase Date
                HStack {
                    Label("Purchase Date", systemImage: "calendar")
                        .font(.caption2)
                        .foregroundColor(theme.textSecondary)
                    Spacer()
                    DatePicker("", selection: $editPurchaseDate, displayedComponents: .date)
                        .labelsHidden()
                        .onChange(of: editPurchaseDate) { _, newDate in
                            Task {
                                await viewModel.updateApplianceDetails(id: appliance.id, purchaseDate: newDate)
                            }
                        }
                }
                
                // Delivery Date
                HStack {
                    Label("Delivery / Handover", systemImage: "truck.box")
                        .font(.caption2)
                        .foregroundColor(theme.textSecondary)
                    Spacer()
                    DatePicker("", selection: $editDeliveryDate, displayedComponents: .date)
                        .labelsHidden()
                        .onChange(of: editDeliveryDate) { _, newDate in
                            Task {
                                await viewModel.updateApplianceDetails(id: appliance.id, deliveryDate: newDate)
                            }
                        }
                }
                
                // Purchase Country
                HStack {
                    Label("Purchase Country", systemImage: "globe")
                        .font(.caption2)
                        .foregroundColor(theme.textSecondary)
                    Spacer()
                    Picker("", selection: $editCountry) {
                        Text("Switzerland (CH)").tag("CH")
                        Text("Germany (DE)").tag("DE")
                        Text("Austria (AT)").tag("AT")
                        Text("France (FR)").tag("FR")
                        Text("Italy (IT)").tag("IT")
                        Text("Norway (NO)").tag("NO")
                        Text("Sweden (SE)").tag("SE")
                        Text("Denmark (DK)").tag("DK")
                        Text("Turkey (TR)").tag("TR")
                    }
                    .pickerStyle(.menu)
                    .onChange(of: editCountry) { _, newCountry in
                        Task {
                            await viewModel.updateApplianceDetails(id: appliance.id, purchaseCountry: newCountry)
                        }
                    }
                }
                
                // Room / Location
                HStack {
                    Label("Room / Location", systemImage: "door.left.hand.open")
                        .font(.caption2)
                        .foregroundColor(theme.textSecondary)
                    Spacer()
                    Picker("", selection: $editRoom) {
                        Text("Living Room").tag("Living Room")
                        Text("Laundry Room").tag("Laundry Room")
                        Text("Kitchen Counter").tag("Kitchen Counter")
                        Text("Hallway Closet").tag("Hallway Closet")
                        Text("Personal / Pocket").tag("Personal / Pocket")
                        Text("Bathroom").tag("Bathroom")
                        Text("Office").tag("Office")
                        Text("Basement").tag("Basement")
                    }
                    .pickerStyle(.menu)
                    .onChange(of: editRoom) { _, newRoom in
                        Task {
                            await viewModel.updateApplianceDetails(id: appliance.id, roomLocation: newRoom)
                        }
                    }
                }
                
                // Mfr Warranty Policy
                HStack {
                    Label("Mfr. Warranty Policy", systemImage: "building.2")
                        .font(.caption2)
                        .foregroundColor(theme.textSecondary)
                    Spacer()
                    Picker("", selection: $editWarrantyMonths) {
                        Text("12 Months (1 Year)").tag(12)
                        Text("24 Months (2 Years)").tag(24)
                        Text("25 Months (Jura CH)").tag(25)
                        Text("36 Months (3 Years)").tag(36)
                        Text("60 Months (5 Years)").tag(60)
                        Text("120 Months (10 Years)").tag(120)
                    }
                    .pickerStyle(.menu)
                    .onChange(of: editWarrantyMonths) { _, newMonths in
                        Task {
                            await viewModel.updateApplianceDetails(id: appliance.id, warrantyMonths: newMonths)
                        }
                    }
                }
                
                // Purchase Price
                HStack {
                    Label("Purchase Price", systemImage: "tag")
                        .font(.caption2)
                        .foregroundColor(theme.textSecondary)
                    Spacer()
                    HStack(spacing: 4) {
                        Text(appliance.currencyCode)
                            .font(.caption2)
                            .foregroundColor(theme.textMuted)
                        TextField("Price", text: $editPrice)
                            .keyboardType(.decimalPad)
                            .multilineTextAlignment(.trailing)
                            .frame(width: 80)
                            .textFieldStyle(.roundedBorder)
                            .font(.caption)
                            .onSubmit {
                                if let dec = Decimal(string: editPrice) {
                                    Task {
                                        await viewModel.updateApplianceDetails(id: appliance.id, purchasePrice: dec)
                                    }
                                }
                            }
                    }
                }
            }
        }
    }
    
    // MARK: - Specs Pane
    
    private var specsPane: some View {
        let (specs, marketRange) = viewModel.getSpecs(brand: appliance.brand, model: appliance.modelName)
        return VStack(spacing: 14) {
            BaseCardView(theme: theme) {
                VStack(alignment: .leading, spacing: 10) {
                    Label("Key Specifications", systemImage: "cpu")
                        .font(.subheadline)
                        .fontWeight(.bold)
                        .foregroundColor(theme.primaryAccent)
                    
                    Divider()
                    
                    VStack(spacing: 8) {
                        ForEach(specs, id: \.0) { spec in
                            HStack {
                                Text(spec.0)
                                    .font(.caption)
                                    .foregroundColor(theme.textSecondary)
                                Spacer()
                                Text(spec.1)
                                    .font(.caption)
                                    .fontWeight(.semibold)
                                    .foregroundColor(theme.textPrimary)
                            }
                            if spec.0 != specs.last?.0 {
                                Divider().opacity(0.3)
                            }
                        }
                    }
                }
            }
            
            // Value Box
            BaseCardView(theme: theme) {
                VStack(spacing: 10) {
                    HStack {
                        Label("Estimated Market Value", systemImage: "chart.line.uptrend.xyaxis")
                            .font(.caption2)
                            .foregroundColor(theme.textSecondary)
                        Spacer()
                        Text(marketRange)
                            .font(.caption)
                            .fontWeight(.bold)
                            .foregroundColor(theme.primaryAccent)
                    }
                    
                    Divider().opacity(0.4)
                    
                    HStack {
                        Label("User Purchase Price", systemImage: "receipt")
                            .font(.caption2)
                            .foregroundColor(theme.textSecondary)
                        Spacer()
                        Text(RegionalFormatter.shared.convertAndFormat(amountInCHF: appliance.purchasePrice, targetCurrency: lang.currentCurrencyCode, locale: lang.currentLocale))
                            .font(.caption)
                            .fontWeight(.bold)
                            .foregroundColor(theme.textPrimary)
                    }
                }
            }
        }
    }
    
    // MARK: - Diagnostics Pane
    
    private var diagnosticsPane: some View {
        VStack(alignment: .leading, spacing: 14) {
            BaseCardView(theme: theme) {
                VStack(alignment: .leading, spacing: 12) {
                    Label("Hardware Error Diagnostic Assistant", systemImage: "sparkles")
                        .font(.subheadline)
                        .fontWeight(.bold)
                        .foregroundColor(.cyan)
                    
                    Text("Enter error code displayed on hardware or describe symptom:")
                        .font(.caption2)
                        .foregroundColor(theme.textSecondary)
                    
                    HStack {
                        TextField("e.g. E24, F10, Flashing Red LED...", text: $inputErrorCode)
                            .textFieldStyle(.roundedBorder)
                        
                        Button(action: runDiagnosis) {
                            if isDiagnosing {
                                ProgressView()
                                    .scaleEffect(0.8)
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
                        Text("Quick pick:")
                            .font(.caption2)
                            .foregroundColor(theme.textMuted)
                        
                        Button("E24 Drain") {
                            inputErrorCode = "E24 Drain Pump Blocked"
                            runDiagnosis()
                        }
                        .font(.caption2)
                        .foregroundColor(.cyan)
                        
                        Button("F10 Intake") {
                            inputErrorCode = "F10 Water Intake Low"
                            runDiagnosis()
                        }
                        .font(.caption2)
                        .foregroundColor(.cyan)
                        
                        Button("Overheating") {
                            inputErrorCode = "Thermal Exhaust Warning"
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
                                .font(.subheadline)
                                .fontWeight(.bold)
                                .foregroundColor(theme.textPrimary)
                            Spacer()
                            Text(diag.severity.rawValue)
                                .font(.system(size: 9, weight: .bold))
                                .padding(.horizontal, 8)
                                .padding(.vertical, 3)
                                .background(diag.severity == .critical ? Color.red.opacity(0.15) : Color.orange.opacity(0.15))
                                .foregroundColor(diag.severity == .critical ? .red : .orange)
                                .clipShape(Capsule())
                        }
                        
                        Divider()
                        
                        VStack(alignment: .leading, spacing: 3) {
                            Text("Root Cause:")
                                .font(.caption2)
                                .fontWeight(.bold)
                                .foregroundColor(theme.textSecondary)
                            Text(diag.probableRootCause)
                                .font(.caption)
                                .foregroundColor(theme.textPrimary)
                        }
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Recommended Actions:")
                                .font(.caption2)
                                .fontWeight(.bold)
                                .foregroundColor(theme.textSecondary)
                            
                            ForEach(diag.recommendedActionSteps, id: \.self) { step in
                                HStack(alignment: .top, spacing: 6) {
                                    Image(systemName: "wrench.and.screwdriver.fill")
                                        .font(.caption2)
                                        .foregroundColor(.cyan)
                                    Text(step)
                                        .font(.caption2)
                                        .foregroundColor(theme.textPrimary)
                                }
                            }
                        }
                        
                        if let cost = diag.estimatedCostRangeCHF {
                            HStack {
                                Text("Estimated Repair Cost:")
                                    .font(.caption2)
                                    .foregroundColor(theme.textSecondary)
                                Spacer()
                                Text(cost)
                                    .font(.caption2)
                                    .fontWeight(.bold)
                                    .foregroundColor(theme.textPrimary)
                            }
                            .padding(8)
                            .background(theme.surfaceElevated)
                            .clipShape(RoundedRectangle(cornerRadius: 6))
                        }
                    }
                }
            }
        }
    }
    
    private func iconForCategory(_ category: String) -> String {
        switch category.lowercased() {
        case "television", "electronics", "audiovisual": return "tv"
        case "smartphone", "phone": return "iphone"
        case "cleaning appliance", "vacuum_cleaner": return "fanblades"
        case "refrigerator", "fridge": return "refrigerator"
        case "coffee", "coffeemachine", "coffee machine": return "mug.fill"
        case "oven", "stove": return "oven"
        default: return "washer"
        }
    }
    
    private func translateRoom(_ room: String) -> String {
        switch room.lowercased() {
        case "all": return lang.t(.roomAll)
        case "kitchen", "kitchen counter": return lang.t(.kitchen)
        case "living room": return lang.t(.roomLivingFull)
        case "laundry room": return lang.t(.roomLaundryFull)
        case "hallway closet": return "Hallway Closet"
        case "personal / pocket": return "Personal / Pocket"
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
