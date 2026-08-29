//
//  LiveBrewTimerView.swift
//  CoffeeMachineCompanion
//
//  Created for Nordic Asset Suite.
//  Strict Concurrency: Complete. Live Extraction Stopwatch & Ratio Dial-In.
//

import SwiftUI
import AssetCoreDatabase
import AssetCoreUIComponents
import AssetCoreLocalization

public struct LiveBrewTimerView: View {
    private let theme = CoffeeTheme()
    
    @State private var timeElapsed: Double = 0.0
    @State private var isRunning: Bool = false
    @State private var timer: Timer? = nil
    @State private var doseGrams: Double = 18.0
    @State private var targetRatio: Double = 2.0 // 1:2.0
    
    private var targetYield: Double {
        doseGrams * targetRatio
    }
    
    public init() {}
    
    public var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    // Stopwatch Dial Card
                    VStack(spacing: 12) {
                        Text("EXTRACTION TIMER")
                            .font(.caption2)
                            .fontWeight(.bold)
                            .foregroundColor(theme.secondaryAccent)
                        
                        Text(String(format: "%04.1f s", timeElapsed))
                            .font(.system(size: 54, weight: .heavy, design: .monospaced))
                            .foregroundColor(theme.primaryAccent)
                        
                        HStack(spacing: 16) {
                            Button(action: toggleTimer) {
                                HStack {
                                    Image(systemName: isRunning ? "pause.fill" : "play.fill")
                                    Text(isRunning ? "Pause" : "Start Extraction")
                                        .fontWeight(.bold)
                                }
                                .padding(.horizontal, 24)
                                .padding(.vertical, 14)
                                .background(isRunning ? theme.statusCritical : theme.primaryAccent)
                                .foregroundColor(.white)
                                .clipShape(Capsule())
                            }
                            
                            Button(action: resetTimer) {
                                Image(systemName: "arrow.counterclockwise")
                                    .font(.title3)
                                    .padding(14)
                                    .background(theme.surfaceElevated)
                                    .foregroundColor(theme.textPrimary)
                                    .clipShape(Circle())
                            }
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 24)
                    .background(theme.cardBackground)
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(theme.borderSubtle, lineWidth: 1)
                    )
                    
                    // Dial-In Calculator Card
                    VStack(alignment: .leading, spacing: 14) {
                        Text("EXTRACTION TARGETS & RATIO")
                            .font(.caption2)
                            .fontWeight(.bold)
                            .foregroundColor(theme.textSecondary)
                        
                        HStack {
                            VStack(alignment: .leading, spacing: 2) {
                                Text("DOSE (GROUND COFFEE)")
                                    .font(.caption2)
                                    .foregroundColor(theme.textMuted)
                                Text("\(String(format: "%.1f", doseGrams)) g")
                                    .font(.title3)
                                    .fontWeight(.bold)
                                    .foregroundColor(theme.textPrimary)
                            }
                            Spacer()
                            Stepper("", value: $doseGrams, in: 7...30, step: 0.5)
                        }
                        
                        Divider()
                        
                        HStack {
                            VStack(alignment: .leading, spacing: 2) {
                                Text("BREW RATIO")
                                    .font(.caption2)
                                    .foregroundColor(theme.textMuted)
                                Text("1 : \(String(format: "%.1f", targetRatio))")
                                    .font(.title3)
                                    .fontWeight(.bold)
                                    .foregroundColor(theme.secondaryAccent)
                            }
                            Spacer()
                            Stepper("", value: $targetRatio, in: 1.0...18.0, step: 0.1)
                        }
                        
                        Divider()
                        
                        HStack {
                            Text("CALCULATED TARGET YIELD")
                                .font(.caption2)
                                .fontWeight(.bold)
                                .foregroundColor(theme.textSecondary)
                            Spacer()
                            Text("\(String(format: "%.1f", targetYield)) g in Cup")
                                .font(.headline)
                                .fontWeight(.bold)
                                .foregroundColor(theme.primaryAccent)
                        }
                    }
                    .padding(16)
                    .background(theme.cardBackground)
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(theme.borderSubtle, lineWidth: 1)
                    )
                }
                .padding()
            }
            .background(theme.backgroundGrouped.ignoresSafeArea())
            .preferredColorScheme(.dark)
            .navigationTitle("Live Brew Timer")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
    
    private func toggleTimer() {
        if isRunning {
            timer?.invalidate()
            timer = nil
            isRunning = false
        } else {
            isRunning = true
            timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { _ in
                timeElapsed += 0.1
            }
        }
    }
    
    private func resetTimer() {
        timer?.invalidate()
        timer = nil
        isRunning = false
        timeElapsed = 0.0
    }
}
