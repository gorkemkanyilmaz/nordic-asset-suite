//
//  CameraBarcodeScannerController.swift
//  AssetCoreOCR
//
//  Created for Nordic Asset Suite.
//  Strict Concurrency: Complete. AVFoundation Live Camera & Vision Barcode/OCR Controller.
//

import Foundation
import AVFoundation
import Vision
#if os(iOS)
import UIKit
import PhotosUI

/// Delegate for live camera scan events.
@MainActor
public protocol CameraScannerDelegate: AnyObject {
    func didDetectBarcode(code: String, symbology: String)
    func didCapturePhoto(data: Data)
    func didEncounterCameraError(error: Error)
}

/// AVFoundation camera controller managing live feed, barcode metadata output, and photo capture.
@MainActor
public final class CameraBarcodeScannerController: NSObject, ObservableObject {
    @Published public var isTorchOn: Bool = false
    @Published public var isCameraReady: Bool = false
    @Published public var isScanningPaused: Bool = false
    @Published public var detectedBarcode: String? = nil
    @Published public var detectedSymbology: String? = nil
    @Published public var hasCameraPermission: Bool = false
    
    public let captureSession = AVCaptureSession()
    private var photoOutput = AVCapturePhotoOutput()
    private var metadataOutput = AVCaptureMetadataOutput()
    private var currentCameraPosition: AVCaptureDevice.Position = .back
    
    public weak var delegate: CameraScannerDelegate?
    
    public override init() {
        super.init()
    }
    
    public func requestPermissionAndSetup() async {
        let status = AVCaptureDevice.authorizationStatus(for: .video)
        switch status {
        case .authorized:
            self.hasCameraPermission = true
            self.configureSession()
        case .notDetermined:
            let granted = await AVCaptureDevice.requestAccess(for: .video)
            self.hasCameraPermission = granted
            if granted {
                self.configureSession()
            }
        case .denied, .restricted:
            self.hasCameraPermission = false
        @unknown default:
            self.hasCameraPermission = false
        }
    }
    
    private func configureSession() {
        captureSession.beginConfiguration()
        captureSession.sessionPreset = .high
        
        // Remove previous inputs
        for input in captureSession.inputs {
            captureSession.removeInput(input)
        }
        
        // Setup Video Device
        guard let videoDevice = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: currentCameraPosition),
              let videoInput = try? AVCaptureDeviceInput(device: videoDevice) else {
            captureSession.commitConfiguration()
            return
        }
        
        if captureSession.canAddInput(videoInput) {
            captureSession.addInput(videoInput)
        }
        
        // Setup Barcode Metadata Output
        if captureSession.canAddOutput(metadataOutput) {
            captureSession.addOutput(metadataOutput)
            metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            
            let supportedTypes: [AVMetadataObject.ObjectType] = [
                .ean13, .ean8, .qr, .code128, .code39, .dataMatrix, .upce, .pdf417
            ]
            metadataOutput.metadataObjectTypes = metadataOutput.availableMetadataObjectTypes.filter { supportedTypes.contains($0) }
        }
        
        // Setup Photo Output
        if captureSession.canAddOutput(photoOutput) {
            captureSession.addOutput(photoOutput)
        }
        
        captureSession.commitConfiguration()
        
        Task.detached { [session = captureSession] in
            session.startRunning()
        }
        self.isCameraReady = true
    }
    
    public func startScanning() {
        guard !captureSession.isRunning else { return }
        Task.detached { [session = captureSession] in
            session.startRunning()
        }
        isScanningPaused = false
    }
    
    public func pauseScanning() {
        isScanningPaused = true
    }
    
    public func resumeScanning() {
        detectedBarcode = nil
        detectedSymbology = nil
        isScanningPaused = false
    }
    
    public func stopScanning() {
        guard captureSession.isRunning else { return }
        Task.detached { [session = captureSession] in
            session.stopRunning()
        }
    }
    
    public func toggleTorch() {
        guard let device = AVCaptureDevice.default(for: .video), device.hasTorch else { return }
        do {
            try device.lockForConfiguration()
            device.torchMode = device.isTorchActive ? .off : .on
            self.isTorchOn = device.isTorchActive
            device.unlockForConfiguration()
        } catch {
            print("Torch error: \(error)")
        }
    }
    
    public func flipCamera() {
        currentCameraPosition = currentCameraPosition == .back ? .front : .back
        configureSession()
    }
    
    public func capturePhoto() {
        let settings = AVCapturePhotoSettings()
        photoOutput.capturePhoto(with: settings, delegate: self)
    }
}

// MARK: - AVCaptureMetadataOutputObjectsDelegate

extension CameraBarcodeScannerController: AVCaptureMetadataOutputObjectsDelegate {
    public func metadataOutput(
        _ output: AVCaptureMetadataOutput,
        didOutput metadataObjects: [AVMetadataObject],
        from connection: AVCaptureConnection
    ) {
        guard !isScanningPaused else { return }
        guard let metadataObject = metadataObjects.first as? AVMetadataMachineReadableCodeObject,
              let stringValue = metadataObject.stringValue else { return }
        
        self.detectedBarcode = stringValue
        self.detectedSymbology = metadataObject.type.rawValue
        
        // Haptic feedback
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.success)
        
        delegate?.didDetectBarcode(code: stringValue, symbology: metadataObject.type.rawValue)
    }
}

// MARK: - AVCapturePhotoCaptureDelegate

extension CameraBarcodeScannerController: AVCapturePhotoCaptureDelegate {
    public func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        if let error = error {
            delegate?.didEncounterCameraError(error: error)
            return
        }
        
        guard let photoData = photo.fileDataRepresentation() else { return }
        
        // Haptic feedback
        let impact = UIImpactFeedbackGenerator(style: .medium)
        impact.impactOccurred()
        
        delegate?.didCapturePhoto(data: photoData)
    }
}
#endif
