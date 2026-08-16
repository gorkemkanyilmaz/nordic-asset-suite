//
//  PIIRedactor.swift
//  AssetCoreSecurity
//
//  Created for Nordic Asset Suite.
//  Strict Concurrency: Complete. GDPR & Swiss FADP Compliant.
//

import Foundation

/// Defines options for client-side Personally Identifiable Information (PII) scrubbing.
public struct PIIRedactionOptions: OptionSet, Sendable {
    public let rawValue: Int
    
    public init(rawValue: Int) {
        self.rawValue = rawValue
    }
    
    public static let creditCards = PIIRedactionOptions(rawValue: 1 << 0)
    public static let emailAddresses = PIIRedactionOptions(rawValue: 1 << 1)
    public static let phoneNumbers = PIIRedactionOptions(rawValue: 1 << 2)
    public static let ibanAndBank = PIIRedactionOptions(rawValue: 1 << 3)
    public static let all: PIIRedactionOptions = [.creditCards, .emailAddresses, .phoneNumbers, .ibanAndBank]
}

/// Provides high-speed, on-device regex and algorithmic PII scrubbing.
public final class PIIRedactor: Sendable {
    public static let shared = PIIRedactor()
    
    private init() {}
    
    // Regex Patterns
    private let creditCardRegex = try? NSRegularExpression(
        pattern: #"\b(?:4[0-9]{12}(?:[0-9]{3})?|5[1-5][0-9]{14}|6(?:011|5[0-9][0-9])[0-9]{12}|3[47][0-9]{13}|3(?:0[0-5]|[68][0-9])[0-9]{11}|(?:2131|1800|35\d{3})\d{11})\b"#,
        options: []
    )
    
    private let emailRegex = try? NSRegularExpression(
        pattern: #"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,64}"#,
        options: []
    )
    
    private let phoneRegex = try? NSRegularExpression(
        pattern: #"(?:\+\d{1,3}[-.\s]?)?\(?\d{2,4}\)?[-.\s]?\d{3,4}[-.\s]?\d{3,4}"#,
        options: []
    )
    
    private let ibanRegex = try? NSRegularExpression(
        pattern: #"\b[A-Z]{2}\d{2}[A-Z0-9]{4}\d{7}([A-Z0-9]?){0,16}\b"#,
        options: []
    )
    
    /// Redacts identified PII entities from the input text before logging or cloud transmission.
    public func redact(text: String, options: PIIRedactionOptions = .all) -> String {
        var sanitized = text
        
        if options.contains(.creditCards), let regex = creditCardRegex {
            let range = NSRange(location: 0, length: sanitized.utf16.count)
            sanitized = regex.stringByReplacingMatches(in: sanitized, options: [], range: range, withTemplate: "[REDACTED_CARD]")
        }
        
        if options.contains(.emailAddresses), let regex = emailRegex {
            let range = NSRange(location: 0, length: sanitized.utf16.count)
            sanitized = regex.stringByReplacingMatches(in: sanitized, options: [], range: range, withTemplate: "[REDACTED_EMAIL]")
        }
        
        if options.contains(.phoneNumbers), let regex = phoneRegex {
            let range = NSRange(location: 0, length: sanitized.utf16.count)
            sanitized = regex.stringByReplacingMatches(in: sanitized, options: [], range: range, withTemplate: "[REDACTED_PHONE]")
        }
        
        if options.contains(.ibanAndBank), let regex = ibanRegex {
            let range = NSRange(location: 0, length: sanitized.utf16.count)
            sanitized = regex.stringByReplacingMatches(in: sanitized, options: [], range: range, withTemplate: "[REDACTED_IBAN]")
        }
        
        return sanitized
    }
}
