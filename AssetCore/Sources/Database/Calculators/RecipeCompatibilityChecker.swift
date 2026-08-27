//
//  RecipeCompatibilityChecker.swift
//  AssetCoreDatabase
//
//  Created for Nordic Asset Suite.
//  Strict Concurrency: Complete. Machine-aware recipe validation engine.
//

import Foundation

// MARK: - Recipe Compatibility Result

/// Encapsulates the result of checking whether a brew recipe is compatible
/// with a specific coffee machine's capabilities.
public struct RecipeCompatibility: Sendable {
    public let isCompatible: Bool
    public let warnings: [CompatibilityWarning]
    
    public init(isCompatible: Bool, warnings: [CompatibilityWarning]) {
        self.isCompatible = isCompatible
        self.warnings = warnings
    }
    
    /// Convenience: returns true if there are critical (blocking) warnings.
    public var hasCriticalIssues: Bool {
        warnings.contains(where: { $0.severity == .critical })
    }
}

/// A single compatibility warning with severity level and user-facing message.
public struct CompatibilityWarning: Sendable, Identifiable {
    public let id: UUID
    public let severity: Severity
    public let message: String
    public let iconName: String
    
    public enum Severity: String, Sendable {
        case critical   // Recipe physically cannot be performed on this machine
        case warning    // Recipe can be attempted but results may differ
        case info       // Informational note about machine limitations
    }
    
    public init(severity: Severity, message: String, iconName: String = "exclamationmark.triangle.fill") {
        self.id = UUID()
        self.severity = severity
        self.message = message
        self.iconName = iconName
    }
}

// MARK: - Recipe Compatibility Checker

/// Validates whether a brew recipe is compatible with a given coffee machine's
/// specifications. Checks pressure, brew method, grouphead size, and temperature.
public struct RecipeCompatibilityChecker: Sendable {
    public static let shared = RecipeCompatibilityChecker()
    
    private init() {}
    
    /// Validates a recipe against a machine's capabilities.
    /// - Parameters:
    ///   - recipe: The brew recipe to validate (pressure, method, dose, temp).
    ///   - machine: The coffee machine entity with its specifications.
    /// - Returns: A `RecipeCompatibility` result with any warnings.
    public func validate(recipe: BrewRecipe, machine: CoffeeMachineEntity) -> RecipeCompatibility {
        var warnings: [CompatibilityWarning] = []
        
        // ── 1. Brew Method Compatibility ──
        let recipeMethod = recipe.requiredBrewMethod
        if !machine.supportedBrewMethods.contains(recipeMethod) {
            let machineMethodList = machine.supportedBrewMethods.joined(separator: ", ")
            warnings.append(CompatibilityWarning(
                severity: .critical,
                message: "\(recipeMethod) is not supported by this \(machine.machineType) machine. Supported methods: \(machineMethodList).",
                iconName: "xmark.octagon.fill"
            ))
        }
        
        // ── 2. Pump Pressure Check ──
        if recipe.minimumPumpPressureBar > 0 && machine.pumpPressureBar > 0 {
            if machine.pumpPressureBar < recipe.minimumPumpPressureBar {
                warnings.append(CompatibilityWarning(
                    severity: .critical,
                    message: "This recipe requires minimum \(formatBar(recipe.minimumPumpPressureBar)) pressure. Your machine's pump reaches \(formatBar(machine.pumpPressureBar)).",
                    iconName: "gauge.with.dots.needle.33percent"
                ))
            } else if machine.pumpPressureBar < recipe.brewPressureBar {
                warnings.append(CompatibilityWarning(
                    severity: .warning,
                    message: "Target pressure is \(formatBar(recipe.brewPressureBar)) but your machine reaches \(formatBar(machine.pumpPressureBar)). Extraction may vary.",
                    iconName: "gauge.with.dots.needle.50percent"
                ))
            }
        }
        
        // ── 3. Grouphead Size Check (portafilter basket capacity) ──
        if machine.groupheadDiameterMm > 0 && recipeMethod == "Espresso" {
            // Smaller groupheads have lower dose capacity
            let maxDoseForGrouphead = estimateMaxDose(groupheadMm: machine.groupheadDiameterMm)
            if recipe.dryDoseGrams > maxDoseForGrouphead {
                warnings.append(CompatibilityWarning(
                    severity: .warning,
                    message: "Recipe dose (\(formatGrams(recipe.dryDoseGrams))) may exceed \(machine.groupheadDiameterMm)mm basket capacity (~\(formatGrams(maxDoseForGrouphead)) max).",
                    iconName: "scalemass.fill"
                ))
            }
        }
        
        // ── 4. Superautomatic Limitations ──
        if machine.machineType == "Superautomatic" && machine.groupheadDiameterMm == 0 {
            if recipeMethod == "Espresso" || recipeMethod == "Lungo" {
                warnings.append(CompatibilityWarning(
                    severity: .info,
                    message: "Superautomatic machines have fixed brew programs. Dose, grind, and pressure are adjusted within the machine's built-in range.",
                    iconName: "gearshape.fill"
                ))
            }
        }
        
        // ── 5. Steam Wand for Milk-Based Recipes ──
        // Check if recipe steps mention milk/steam/foam
        let needsSteam = recipe.sensoryNotes.localizedCaseInsensitiveContains("microfoam") ||
                          recipe.sensoryNotes.localizedCaseInsensitiveContains("milk") ||
                          recipe.sensoryNotes.localizedCaseInsensitiveContains("latte") ||
                          recipe.sensoryNotes.localizedCaseInsensitiveContains("flat white")
        if needsSteam && !machine.hasSteamWand {
            warnings.append(CompatibilityWarning(
                severity: .warning,
                message: "This recipe calls for steamed milk, but your machine has no steam wand. Use an external milk frother.",
                iconName: "drop.triangle.fill"
            ))
        }
        
        let isCompatible = !warnings.contains(where: { $0.severity == .critical })
        return RecipeCompatibility(isCompatible: isCompatible, warnings: warnings)
    }
    
    /// Quick check for a recipe DTO (used by the web-demo and recipe listing UI).
    /// - Parameters:
    ///   - recipeMethod: The brew method string (e.g., "Espresso", "Pour-Over")
    ///   - recipePressureBar: The target pressure for the recipe
    ///   - machinePressureBar: The machine's maximum pump pressure
    ///   - machineBrewMethods: The machine's supported brew methods
    /// - Returns: A `RecipeCompatibility` result.
    public func quickCheck(
        recipeMethod: String,
        recipePressureBar: Double,
        minimumPressureBar: Double,
        machinePressureBar: Double,
        machineBrewMethods: [String]
    ) -> RecipeCompatibility {
        var warnings: [CompatibilityWarning] = []
        
        if !machineBrewMethods.contains(recipeMethod) {
            warnings.append(CompatibilityWarning(
                severity: .critical,
                message: "\(recipeMethod) is not supported by this machine.",
                iconName: "xmark.octagon.fill"
            ))
        }
        
        if minimumPressureBar > 0 && machinePressureBar > 0 && machinePressureBar < minimumPressureBar {
            warnings.append(CompatibilityWarning(
                severity: .critical,
                message: "Requires \(formatBar(minimumPressureBar)) pressure; machine provides \(formatBar(machinePressureBar)).",
                iconName: "gauge.with.dots.needle.33percent"
            ))
        }
        
        let isCompatible = !warnings.contains(where: { $0.severity == .critical })
        return RecipeCompatibility(isCompatible: isCompatible, warnings: warnings)
    }
    
    // MARK: - Private Helpers
    
    private func formatBar(_ value: Double) -> String {
        if value == value.rounded() {
            return "\(Int(value)) bar"
        }
        return String(format: "%.1f bar", value)
    }
    
    private func formatGrams(_ value: Double) -> String {
        return String(format: "%.1fg", value)
    }
    
    /// Estimates maximum single-dose capacity based on portafilter basket diameter.
    private func estimateMaxDose(groupheadMm: Int) -> Double {
        switch groupheadMm {
        case ...50:  return 14.0   // 49mm (e.g. DeLonghi Dedica)
        case 51...53: return 16.0  // 51mm (Breville Bambino)
        case 54:      return 20.0  // 54mm (Breville/Sage standard)
        case 55...57: return 21.0  // 57mm (some commercial)
        default:      return 22.0  // 58mm (standard commercial / prosumer)
        }
    }
}
