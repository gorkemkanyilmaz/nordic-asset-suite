//
//  MaintenanceNotificationScheduler.swift
//  AssetCoreNotifications
//
//  Created for Nordic Asset Suite.
//  Strict Concurrency: Complete. Local Warranty & Service Expiry Notification Scheduler.
//

import Foundation
import UserNotifications
import AssetCoreDatabase

/// Actor managing local user notification scheduling for warranty and maintenance events.
public actor MaintenanceNotificationScheduler {
    public static let shared = MaintenanceNotificationScheduler()
    
    private init() {}
    
    /// Requests local notification authorization from the user.
    public func requestAuthorization() async -> Bool {
        #if os(iOS)
        do {
            return try await UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound])
        } catch {
            return false
        }
        #else
        return true
        #endif
    }
    
    /// Schedules local notifications for an upcoming warranty expiration date (30 Days, 7 Days, and 1 Day prior).
    public func scheduleWarrantyReminder(applianceId: String, modelName: String, expiryDate: Date) async {
        #if os(iOS)
        let center = UNUserNotificationCenter.current()
        let intervals: [(daysBefore: Int, identifier: String, title: String, body: String)] = [
            (30, "warranty_\(applianceId)_30d", "Warranty Expiring in 30 Days", "Statutory warranty for your \(modelName) expires in 30 days. Review condition for any warranty claims."),
            (7, "warranty_\(applianceId)_7d", "Warranty Expiring in 7 Days", "Only 1 week remaining on the warranty for your \(modelName)."),
            (1, "warranty_\(applianceId)_1d", "Warranty Expiration Tomorrow", "Final 24 hours of warranty coverage for your \(modelName).")
        ]
        
        for item in intervals {
            let reminderDate = Calendar.current.date(byAdding: .day, value: -item.daysBefore, to: expiryDate) ?? expiryDate
            if reminderDate > Date() {
                let content = UNMutableNotificationContent()
                content.title = item.title
                content.body = item.body
                content.sound = .default
                
                let triggerDate = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: reminderDate)
                let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDate, repeats: false)
                let request = UNNotificationRequest(identifier: item.identifier, content: content, trigger: trigger)
                try? await center.add(request)
            }
        }
        #endif
    }
    
    /// Cancels all scheduled warranty reminders for a given appliance.
    public func cancelWarrantyReminders(applianceId: String) async {
        #if os(iOS)
        let identifiers = [
            "warranty_\(applianceId)_30d",
            "warranty_\(applianceId)_7d",
            "warranty_\(applianceId)_1d"
        ]
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: identifiers)
        #endif
    }
}
