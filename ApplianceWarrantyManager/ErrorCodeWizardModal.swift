//
//  ErrorCodeWizardModal.swift
//  ApplianceWarrantyManager
//
//  Created for Nordic Asset Suite.
//  Strict Concurrency: Complete. Interactive Error Code Troubleshooting & Legal Defect Link.
//

import SwiftUI
import AssetCoreDatabase
import AssetCoreUIComponents
import AssetCoreLocalization

public struct ErrorDiagnosticItem: Identifiable, Sendable {
    public let id: String
    public let code: String
    public let title: String
    public let severity: String
    public let severityStatus: MetricBadgeStatus
    public let probableCause: String
    public let diySteps: [String]
    public let defectCategory: DefectCategory
    public let tip: String
}

public struct ErrorCodeWizardModal: View {
    @Environment(\.dismiss) private var dismiss
    public let appliance: ApplianceDTO
    private let theme = ApplianceTheme()
    
    @State private var searchText: String = "E18"
    @State private var selectedError: ErrorDiagnosticItem? = nil
    @State private var showingDefectModal: Bool = false
    
    private let commonErrors: [ErrorDiagnosticItem] = [
        ErrorDiagnosticItem(
            id: "E18",
            code: "E18",
            title: "Drain Pump Filter Blockage / Timeout",
            severity: "Moderate (DIY Resolvable in 10 mins)",
            severityStatus: .warning,
            probableCause: "Foreign object (coins, lint, hairpins) jammed in drain filter chamber or kinked drain hose.",
            diySteps: [
                "1. Disconnect machine from power mains.",
                "2. Open bottom service flap and release residual drain tube into shallow container.",
                "3. Unscrew coin trap filter and remove debris/hairpins from pump impeller.",
                "4. Screw filter back tightly and run a 2-minute rinse test."
            ],
            defectCategory: .doorSeal,
            tip: "Eligible for free repair under statutory defect rights if pump motor itself is mechanically burnt."
        ),
        ErrorDiagnosticItem(
            id: "E15",
            code: "E15",
            title: "Water in Base Tray / Flood Protection",
            severity: "Major (Safety Water Shutoff Active)",
            severityStatus: .critical,
            probableCause: "Water leakage into base pan triggered the float safety microswitch. Sump gasket or spray arm seal degraded.",
            diySteps: [
                "1. Unplug dishwasher immediately and shut off water inlet cock.",
                "2. Tilt appliance backward ~30° to drain base tray water into towels.",
                "3. Check door seal gasket and bottom sump perimeter for leakage.",
                "4. Sump gasket degradation is a statutory defect covered under seller warranty."
            ],
            defectCategory: .doorSeal,
            tip: "Sump gasket degradation is a statutory defect covered under Swiss OR 210 / Nordic law."
        ),
        ErrorDiagnosticItem(
            id: "F20",
            code: "F20",
            title: "Heating Circuit & Element Failure",
            severity: "Major (Electrical Hardware Defect)",
            severityStatus: .critical,
            probableCause: "Heating element burned out, NTC temperature sensor open circuit, or relay failure on main PCB.",
            diySteps: [
                "1. Verify water inlet temperature is within standard parameters.",
                "2. Perform cold power cycle by leaving unplugged for 15 minutes.",
                "3. If error recurs, heating element must be repaired by the seller under statutory defect rights."
            ],
            defectCategory: .heatingPump,
            tip: "Eligible for Free Repair under Statutory Defect Rights if within statutory coverage window!"
        ),
        ErrorDiagnosticItem(
            id: "F04",
            code: "F04",
            title: "Drainage Issue / Impeller Jam",
            severity: "Moderate (DIY Resolvable)",
            severityStatus: .warning,
            probableCause: "Drain pump blocked or non-return valve stuck.",
            diySteps: [
                "1. Clean drain filter and non-return valve located under the filter chamber.",
                "2. Spin impeller manually with a pen to ensure free rotation.",
                "3. Reinstall and run drain cycle."
            ],
            defectCategory: .motorInverter,
            tip: "If impeller does not spin freely, motor bearing is defective."
        ),
        ErrorDiagnosticItem(
            id: "E01",
            code: "E01",
            title: "Electronic Control / NTC Sensor Mismatch",
            severity: "Critical (Internal Hardware Defect)",
            severityStatus: .critical,
            probableCause: "Internal sensor communication lost with main power board.",
            diySteps: [
                "1. Disconnect power for 20 minutes to reset microcontroller logic.",
                "2. Reconnect. If red standby LED blinks or error persists, mainboard is defective.",
                "3. Generate 1-Tap Legal Defect Notice to request free replacement from retailer."
            ],
            defectCategory: .electronicControl,
            tip: "Statutory Defect: Seller is legally required to replace panel/power supply free under statutory law!"
        )
    ]
    
    public init(appliance: ApplianceDTO) {
        self.appliance = appliance
    }
    
    public var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 16) {
                    searchHeader
                    
                    // Quick Code Pills
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 8) {
                            ForEach(commonErrors) { item in
                                Button(action: {
                                    searchText = item.code
                                    selectedError = item
                                }) {
                                    Text(item.code)
                                        .font(.caption)
                                        .fontWeight(.bold)
                                        .padding(.horizontal, 14)
                                        .padding(.vertical, 7)
                                        .background((selectedError?.code == item.code || searchText == item.code) ? theme.primaryAccent : theme.surfaceElevated)
                                        .foregroundColor((selectedError?.code == item.code || searchText == item.code) ? .white : theme.textPrimary)
                                        .clipShape(Capsule())
                                        .overlay(
                                            Capsule()
                                                .stroke(theme.borderSubtle, lineWidth: 1)
                                        )
                                }
                            }
                        }
                    }
                    
                    // Active Diagnostic Result Card
                    let currentDiagnostic = activeDiagnostic
                    VStack(alignment: .leading, spacing: 14) {
                        HStack {
                            VStack(alignment: .leading, spacing: 2) {
                                Text("ERROR \(currentDiagnostic.code.uppercased())")
                                    .font(.caption2)
                                    .fontWeight(.bold)
                                    .foregroundColor(theme.primaryAccent)
                                Text(currentDiagnostic.title)
                                    .font(.headline)
                                    .fontWeight(.bold)
                                    .foregroundColor(theme.textPrimary)
                            }
                            Spacer()
                            MetricBadgeView(
                                label: "Severity",
                                value: currentDiagnostic.severity.components(separatedBy: " ").first ?? "High",
                                status: currentDiagnostic.severityStatus,
                                theme: theme
                            )
                        }
                        
                        Divider()
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text("PROBABLE ROOT CAUSE")
                                .font(.caption2)
                                .fontWeight(.bold)
                                .foregroundColor(theme.textSecondary)
                            Text(currentDiagnostic.probableCause)
                                .font(.caption)
                                .foregroundColor(theme.textPrimary)
                        }
                        
                        VStack(alignment: .leading, spacing: 6) {
                            Text("RECOMMENDED ACTION & DIY STEPS")
                                .font(.caption2)
                                .fontWeight(.bold)
                                .foregroundColor(theme.textSecondary)
                            
                            ForEach(currentDiagnostic.diySteps, id: \.self) { step in
                                HStack(alignment: .top, spacing: 6) {
                                    Image(systemName: "checkmark.circle.fill")
                                        .font(.caption2)
                                        .foregroundColor(theme.primaryAccent)
                                        .padding(.top, 2)
                                    Text(step)
                                        .font(.caption)
                                        .foregroundColor(theme.textPrimary)
                                }
                            }
                        }
                        
                        // Statutory Tip
                        HStack(spacing: 8) {
                            Image(systemName: "shield.lefthalf.filled.badge.checkmark")
                                .foregroundColor(.green)
                            Text(currentDiagnostic.tip)
                                .font(.caption2)
                                .foregroundColor(theme.textPrimary)
                        }
                        .padding(10)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(Color.green.opacity(0.1))
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                    }
                    .padding(16)
                    .background(theme.cardBackground)
                    .clipShape(RoundedRectangle(cornerRadius: 14))
                    .overlay(
                        RoundedRectangle(cornerRadius: 14)
                            .stroke(theme.borderSubtle, lineWidth: 1)
                    )
                    
                    // Direct Action Button to Legal Claim
                    Button(action: { showingDefectModal = true }) {
                        HStack(spacing: 8) {
                            Image(systemName: "filemenu.and.selection")
                            Text("Generate Official Defect Notice for Seller")
                                .fontWeight(.bold)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 14)
                        .background(theme.primaryAccent)
                        .foregroundColor(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                    }
                }
                .padding()
            }
            .background(theme.backgroundGrouped.ignoresSafeArea())
            .preferredColorScheme(.dark)
            .navigationTitle("Error Code Wizard")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Done") { dismiss() }
                }
            }
            .sheet(isPresented: $showingDefectModal) {
                LegalDefectNoticeModal(
                    appliance: appliance,
                    presetDefect: activeDiagnostic.defectCategory
                )
            }
        }
    }
    
    private var activeDiagnostic: ErrorDiagnosticItem {
        if let match = commonErrors.first(where: { $0.code.lowercased() == searchText.trimmingCharacters(in: .whitespaces).lowercased() }) {
            return match
        }
        return ErrorDiagnosticItem(
            id: searchText,
            code: searchText.isEmpty ? "UNKNOWN" : searchText,
            title: "Hardware Diagnostic Assessment",
            severity: "Moderate (Investigation Required)",
            severityStatus: .warning,
            probableCause: "Sensor mismatch or temporary component lockout detected on \(appliance.brand) \(appliance.modelName).",
            diySteps: [
                "1. Disconnect power cord for 15 minutes to reset internal micro-controllers.",
                "2. Inspect filters, water supply, and drainage lines for physical blockage.",
                "3. If error persists upon power reconnection, generate an official statutory defect notice."
            ],
            defectCategory: .electronicControl,
            tip: "Use our 1-Tap Legal Defect Notice to request free authorized inspection from the retailer."
        )
    }
    
    private var searchHeader: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(theme.textSecondary)
            TextField("Enter Error Code (e.g. E18, E15, F20, F04...)", text: $searchText)
                .font(.subheadline)
                .foregroundColor(theme.textPrimary)
            
            if !searchText.isEmpty {
                Button(action: { searchText = "" }) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(theme.textSecondary)
                }
            }
        }
        .padding(12)
        .background(theme.surfaceElevated)
        .clipShape(RoundedRectangle(cornerRadius: 10))
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(theme.borderSubtle, lineWidth: 1)
        )
    }
}
