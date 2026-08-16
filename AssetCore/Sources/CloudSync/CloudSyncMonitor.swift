//
//  CloudSyncMonitor.swift
//  AssetCoreCloudSync
//
//  Created for Nordic Asset Suite.
//  Strict Concurrency: Complete. CloudKit Sync Status & Conflict Manager.
//

import Foundation
import CloudKit
import AssetCoreDatabase
import AssetCoreSecurity

/// Status of CloudKit private and public database synchronization.
public enum CloudSyncStatus: String, Sendable {
    case synced = "All assets synced with iCloud"
    case syncing = "Synchronizing deltas..."
    case offline = "Offline mode (Local changes cached)"
    case quotaExceeded = "iCloud storage quota reached"
    case accountNotAvailable = "iCloud account not signed in"
}

/// Actor monitoring CloudKit synchronization status and network reachability.
public actor CloudSyncMonitor {
    public static let shared = CloudSyncMonitor()
    
    private var currentStatus: CloudSyncStatus = .synced
    
    private init() {}
    
    /// Checks CloudKit account status on the device.
    public func checkAccountStatus() async -> CloudSyncStatus {
        do {
            let container = CKContainer(identifier: "iCloud.com.nordicassetsuite.assets")
            let status = try await container.accountStatus()
            
            switch status {
            case .available:
                self.currentStatus = .synced
            case .noAccount:
                self.currentStatus = .accountNotAvailable
            case .restricted, .couldNotDetermine:
                self.currentStatus = .offline
            case .temporarilyUnavailable:
                self.currentStatus = .offline
            @unknown default:
                self.currentStatus = .offline
            }
        } catch {
            self.currentStatus = .offline
        }
        
        return currentStatus
    }
    
    /// Returns the current synchronization status.
    public func getStatus() -> CloudSyncStatus {
        return currentStatus
    }
}
