//
//  ReceiptParser.swift
//  AssetCoreOCR
//
//  Created for Nordic Asset Suite.
//  Strict Concurrency: Complete. European & Nordic Currency/Date Extraction.
//

import Foundation

/// High-precision rule-based parser for receipts, warranty certificates, and invoices.
public final class ReceiptParser: Sendable {
    public static let shared = ReceiptParser()
    
    private init() {}
    
    // Currency Regex Patterns (supports Swiss apostrophe 1'949.00, EU dot 5.499,00, standard 1250.50)
    private let currencyRegex = try? NSRegularExpression(
        pattern: #"(CHF|EUR|€|DKK|SEK|NOK|\$)\s*(\d{1,5}(?:[.,'’\s]\d{2,3})*(?:[.,]\d{2})?)|(\d{1,5}(?:[.,'’\s]\d{2,3})*(?:[.,]\d{2})?)\s*(CHF|EUR|€|DKK|SEK|NOK|kr|.-)"#,
        options: [.caseInsensitive]
    )
    
    // Date Regex Patterns (DD.MM.YYYY, YYYY-MM-DD, DD/MM/YYYY)
    private let dateRegex = try? NSRegularExpression(
        pattern: #"\b(\d{1,2})[./\-](\d{1,2})[./\-](\d{2,4})\b|\b(\d{4})[./\-](\d{1,2})[./\-](\d{1,2})\b"#,
        options: []
    )
    
    /// Parses raw OCR text into a structured receipt object.
    public func parseReceipt(from ocrText: String, confidenceScore: Float) -> ParsedReceiptData {
        let lines = ocrText.components(separatedBy: .newlines).map { $0.trimmingCharacters(in: .whitespaces) }.filter { !$0.isEmpty }
        
        let merchant = extractMerchant(from: lines)
        let (amount, currency) = extractTotalAmountAndCurrency(from: lines)
        let date = extractDate(from: lines)
        
        return ParsedReceiptData(
            merchantName: merchant,
            transactionDate: date,
            totalAmount: amount,
            currencyCode: currency,
            vatAmount: nil,
            extractedLines: lines,
            confidenceScore: confidenceScore
        )
    }
    
    private func extractMerchant(from lines: [String]) -> String? {
        // Merchant is typically within the top 3 lines
        for line in lines.prefix(3) {
            let lower = line.lowercased()
            if !lower.contains("bon") && !lower.contains("rechnung") && !lower.contains("tel") && !lower.contains("uid") && line.count > 2 {
                return line
            }
        }
        return lines.first
    }
    
    private func extractTotalAmountAndCurrency(from lines: [String]) -> (Decimal?, String?) {
        var foundAmount: Decimal? = nil
        var foundCurrency: String? = nil
        
        // Scan bottom-up for total lines (TOTAL, SUMME, MONTANT, I ALT, BELÖP)
        let totalKeywords = ["total", "summe", "endbetrag", "montant", "totalt", "i alt", "beløp", "att betala"]
        
        for line in lines.reversed() {
            let lower = line.lowercased()
            let isTotalLine = totalKeywords.contains(where: { lower.contains($0) })
            
            let (amt, curr) = parseAmountLine(line)
            if let amt = amt {
                if isTotalLine {
                    return (amt, curr)
                } else if foundAmount == nil {
                    foundAmount = amt
                    foundCurrency = curr
                }
            }
        }
        
        return (foundAmount, foundCurrency)
    }
    
    private func parseAmountLine(_ line: String) -> (Decimal?, String?) {
        guard let regex = currencyRegex else { return (nil, nil) }
        let range = NSRange(location: 0, length: line.utf16.count)
        guard let match = regex.firstMatch(in: line, options: [], range: range) else { return (nil, nil) }
        
        var currencyString = "CHF"
        var amountString = ""
        
        if match.range(at: 1).location != NSNotFound {
            currencyString = (line as NSString).substring(with: match.range(at: 1))
            amountString = (line as NSString).substring(with: match.range(at: 2))
        } else if match.range(at: 3).location != NSNotFound {
            amountString = (line as NSString).substring(with: match.range(at: 3))
            currencyString = (line as NSString).substring(with: match.range(at: 4))
        }
        
        // Clean currency symbol to ISO code
        let normalizedCurrency: String
        let upperCurr = currencyString.uppercased()
        if upperCurr.contains("CHF") || upperCurr.contains(".-") {
            normalizedCurrency = "CHF"
        } else if upperCurr.contains("EUR") || upperCurr.contains("€") {
            normalizedCurrency = "EUR"
        } else if upperCurr.contains("DKK") {
            normalizedCurrency = "DKK"
        } else if upperCurr.contains("SEK") {
            normalizedCurrency = "SEK"
        } else if upperCurr.contains("NOK") || upperCurr.contains("KR") {
            normalizedCurrency = "NOK"
        } else {
            normalizedCurrency = "CHF"
        }
        
        // Parse numbers with comma or dot decimals:
        // Case 1: 5.499,00 -> 5499.00
        // Case 2: 1'949.00 -> 1949.00
        var cleaned = amountString.replacingOccurrences(of: "'", with: "").replacingOccurrences(of: "’", with: "").replacingOccurrences(of: " ", with: "")
        if cleaned.contains(",") && cleaned.contains(".") {
            // e.g. 5.499,00
            cleaned = cleaned.replacingOccurrences(of: ".", with: "").replacingOccurrences(of: ",", with: ".")
        } else if cleaned.contains(",") {
            cleaned = cleaned.replacingOccurrences(of: ",", with: ".")
        }
        
        let decimal = Decimal(string: cleaned)
        return (decimal, normalizedCurrency)
    }
    
    private func extractDate(from lines: [String]) -> Date? {
        guard let regex = dateRegex else { return nil }
        
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "de_CH")
        
        for line in lines {
            let range = NSRange(location: 0, length: line.utf16.count)
            if let match = regex.firstMatch(in: line, options: [], range: range) {
                let dateSubstring = (line as NSString).substring(with: match.range)
                
                let formats = ["dd.MM.yyyy", "dd/MM/yyyy", "dd-MM-yyyy", "yyyy-MM-dd", "dd.MM.yy"]
                for format in formats {
                    dateFormatter.dateFormat = format
                    if let parsedDate = dateFormatter.date(from: dateSubstring) {
                        return parsedDate
                    }
                }
            }
        }
        
        return nil
    }
}
