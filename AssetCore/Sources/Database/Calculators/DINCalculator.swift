//
//  DINCalculator.swift
//  AssetCoreDatabase
//
//  Created for Nordic Asset Suite.
//  Strict Concurrency: Complete. ISO 11088 Standard Implementation.
//

import Foundation

/// Skier classification according to ISO 11088.
public enum SkierType: String, CaseIterable, Sendable, Codable {
    case typeI = "Type I (Cautious / Beginner)"
    case typeII = "Type II (Moderate / All-Mountain)"
    case typeIII = "Type III (Aggressive / Expert)"
    case typeIIIPlus = "Type III+ (Racer / Extreme)"
}

/// Result of an ISO 11088 DIN calculation.
public struct DINCalculationResult: Sendable {
    public let dinValue: Double
    public let skierCode: String
    public let toeReleaseTorqueNm: Double
    public let heelReleaseTorqueNm: Double
    public let disclaimerRequired: Bool
    
    public init(
        dinValue: Double,
        skierCode: String,
        toeReleaseTorqueNm: Double,
        heelReleaseTorqueNm: Double,
        disclaimerRequired: Bool = true
    ) {
        self.dinValue = dinValue
        self.skierCode = skierCode
        self.toeReleaseTorqueNm = toeReleaseTorqueNm
        self.heelReleaseTorqueNm = heelReleaseTorqueNm
        self.disclaimerRequired = disclaimerRequired
    }
}

/// Official ISO 11088 Skier Binding Release Torque & DIN Calculator.
public final class DINCalculator: Sendable {
    public static let shared = DINCalculator()
    
    public static let legalSafetyDisclaimer = """
    CRITICAL SAFETY DISCLAIMER:
    Ski binding adjustment is a safety-critical procedure. Incorrect settings may result in severe injury or death.
    This calculator provides an estimate based on the ISO 11088 standard for reference only.
    You MUST have your ski bindings adjusted, tested, and calibrated on an approved mechanical testing device by a certified ski technician before skiing.
    """
    
    private init() {}
    
    /// Computes DIN release setting adhering to ISO 11088 weight/height and boot sole length matrix.
    public func calculateDIN(
        weightKg: Double,
        heightCm: Double,
        age: Int,
        skierType: SkierType,
        bootSoleLengthMm: Int
    ) -> DINCalculationResult {
        // Step 1: Determine Skier Code Index (0 = A, 1 = B, ... 12 = M)
        let weightCode = getWeightCodeIndex(weightKg: weightKg)
        let heightCode = getHeightCodeIndex(heightCm: heightCm)
        
        // Use the smaller index between weight and height
        var codeIndex = min(weightCode, heightCode)
        
        // Step 2: Apply Skier Type Modifier
        switch skierType {
        case .typeI:
            break // Baseline index
        case .typeII:
            codeIndex += 1
        case .typeIII:
            codeIndex += 2
        case .typeIIIPlus:
            codeIndex += 3
        }
        
        // Step 3: Apply Age Modifier (Under 9 or 50+ shifts code 1 step down)
        if age < 9 || age >= 50 {
            codeIndex = max(0, codeIndex - 1)
        }
        
        codeIndex = max(0, min(12, codeIndex))
        let skierCodeLetters = ["A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M"]
        let codeLetter = skierCodeLetters[codeIndex]
        
        // Step 4: Map Skier Code & Boot Sole Length Bracket to DIN
        let bslBracket = getBSLBracketIndex(bslMm: bootSoleLengthMm)
        let rawDIN = dinMatrix[codeIndex][bslBracket]
        
        let toeTorque = rawDIN * 8.5
        let heelTorque = rawDIN * 31.0
        
        return DINCalculationResult(
            dinValue: rawDIN,
            skierCode: codeLetter,
            toeReleaseTorqueNm: toeTorque,
            heelReleaseTorqueNm: heelTorque,
            disclaimerRequired: true
        )
    }
    
    private func getWeightCodeIndex(weightKg: Double) -> Int {
        switch weightKg {
        case ..<13: return 0  // A
        case 13..<18: return 1 // B
        case 18..<26: return 2 // C
        case 26..<36: return 3 // D
        case 36..<48: return 4 // E
        case 48..<58: return 5 // F
        case 58..<67: return 6 // G
        case 67..<79: return 7 // H
        case 79..<95: return 8 // I
        case 95..<108: return 9 // J
        case 108...: return 10 // K
        default: return 7
        }
    }
    
    private func getHeightCodeIndex(heightCm: Double) -> Int {
        switch heightCm {
        case ..<148: return 6 // G
        case 148..<158: return 7 // H
        case 158..<167: return 8 // I
        case 167..<179: return 9 // J
        case 179..<195: return 10 // K
        case 195...: return 11 // L
        default: return 8
        }
    }
    
    private func getBSLBracketIndex(bslMm: Int) -> Int {
        switch bslMm {
        case ..<250: return 0 // < 250mm
        case 251...270: return 1
        case 271...290: return 2
        case 291...310: return 3
        case 311...330: return 4
        default: return 5 // > 330mm
        }
    }
    
    // ISO 11088 Reference Table [CodeIndex][BSLBracket]
    private let dinMatrix: [[Double]] = [
        [0.75, 0.75, 0.75, 0.75, 0.75, 0.75], // A
        [1.00, 0.75, 0.75, 0.75, 0.75, 0.75], // B
        [1.50, 1.25, 1.00, 1.00, 0.75, 0.75], // C
        [2.00, 1.75, 1.50, 1.25, 1.00, 1.00], // D
        [2.50, 2.25, 2.00, 1.75, 1.50, 1.25], // E
        [3.00, 2.75, 2.50, 2.25, 2.00, 1.75], // F
        [3.50, 3.00, 2.75, 2.50, 2.25, 2.00], // G
        [4.50, 4.00, 3.50, 3.00, 2.75, 2.50], // H
        [5.50, 5.00, 4.50, 4.00, 3.50, 3.00], // I
        [6.50, 6.00, 5.50, 5.00, 4.50, 4.00], // J
        [7.50, 7.00, 6.50, 6.00, 5.50, 5.00], // K
        [8.50, 8.00, 7.50, 7.00, 6.50, 6.00], // L
        [10.0, 9.50, 9.00, 8.50, 8.00, 7.50]  // M
    ]
}
