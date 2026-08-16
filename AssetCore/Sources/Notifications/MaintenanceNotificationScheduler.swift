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
    
    /// Schedules a local notification for an upcoming warranty expiration date.
    public func scheduleWarrantyReminder(applianceId: String, modelName: String, expiryDate: Date) async {
        #if os(iOS)
        let content = UNMutableNotificationContent()
        content.title = "Warranty Expiring Soon"
        content.body = "The warranty for your \(modelName) expires in 30 days."
        content.sound = .default
        
        let reminderDate = Calendar.current.date(byAdding: .day, value: -30, to: expiryDate) ?? expiryDate
        let triggerDate = Calendar.current.dateComponents([.year, .month, .day, .hour], from: reminderDate)
        let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDate, repeats: false)
        
        let request = UNNotificationRequest(identifier: "warranty_\(applianceId)", content: content, trigger: trigger)
        try? await UNUserNotificationCenter.current().add(request)
        #endif
    }
}
