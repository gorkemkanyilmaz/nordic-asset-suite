//
//  LiveScannerSwiftUIView.swift
//  AssetCoreOCR
//
//  Created for Nordic Asset Suite.
//  Strict Concurrency: Complete. Futuristic Live Camera Scanner View with Barcode & AI Omni-Intake.
//

import SwiftUI
import AVFoundation
import PhotosUI
import AssetCoreLocalization

public enum ScannerIntakeMode: String, CaseIterable, Identifiable {
    case barcode = "Barcode / QR"
    case ratingBadge = "Rating Badge"
    case receipt = "Receipt / Invoice"
    case manualText = "Search / Text"
    
    public var id: String { rawValue }
    public var icon: String {
        switch self {
        case .barcode: return "barcode.viewfinder"
        case .ratingBadge: return "text.viewfinder"
        case .receipt: return "doc.text.viewfinder"
        case .manualText: return "magnifyingglass"
        }
    }
    
    @MainActor
    public func localizedName(using lang: LanguageManager) -> String {
        switch self {
        case .barcode: return lang.t(.barcodeQR)
        case .ratingBadge: return lang.t(.ratingBadge)
        case .receipt: return lang.t(.receiptInvoice)
        case .manualText: return lang.t(.searchText)
        }
    }
}

public struct LiveScannerSwiftUIView: View {
    @Environment(\.dismiss) private var dismiss
    private let lang = LanguageManager.shared
    
    #if os(iOS)
    @StateObject private var cameraController = CameraBarcodeScannerController()
    #endif
    
    @State private var intakeMode: ScannerIntakeMode = .barcode
    @State private var manualSearchText: String = ""
    @State private var isProcessing: Bool = false
    @State private var statusMessage: String? = nil
    @State private var laserOffset: CGFloat = -110
    @State private var selectedPhotoItem: PhotosPickerItem? = nil
    
    public let onDetectedBarcode: (String) -> Void
    public let onCapturedPhoto: (Data) -> Void
    public let onManualSearchSubmit: (String) -> Void
    
    public init(
        onDetectedBarcode: @escaping (String) -> Void,
        onCapturedPhoto: @escaping (Data) -> Void,
        onManualSearchSubmit: @escaping (String) -> Void
    ) {
        self.onDetectedBarcode = onDetectedBarcode
        self.onCapturedPhoto = onCapturedPhoto
        self.onManualSearchSubmit = onManualSearchSubmit
    }
    
    public var body: some View {
        NavigationStack {
            ZStack {
                Color.black.ignoresSafeArea()
                
                #if os(iOS)
                // Camera Feed or Simulator Fallback
                if cameraController.hasCameraPermission && cameraController.isCameraReady {
                    CameraPreviewRepresentable(session: cameraController.captureSession)
                        .ignoresSafeArea()
                } else {
                    SimulatorCameraMockView(
                        onSelectSampleBarcode: { code in
                            handleDetectedBarcode(code)
                        },
                        onSelectSampleText: { text in
                            handleManualSearch(text)
                        }
                    )
                }
                #else
                SimulatorCameraMockView(
                    onSelectSampleBarcode: { code in handleDetectedBarcode(code) },
                    onSelectSampleText: { text in handleManualSearch(text) }
                )
                #endif
                
                // Target Overlay Reticle & Laser Sweep
                if intakeMode != .manualText {
                    VStack {
                        Spacer()
                        
                        ZStack {
                            // Scanner Frame
                            RoundedRectangle(cornerRadius: 18)
                                .stroke(Color.white.opacity(0.4), lineWidth: 2)
                                .frame(width: 280, height: intakeMode == .barcode ? 160 : 260)
                                .background(Color.black.opacity(0.2))
                            
                            // Laser Scan Line
                            Rectangle()
                                .fill(
                                    LinearGradient(
                                        colors: [Color.clear, Color.cyan.opacity(0.8), Color.clear],
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    )
                                )
                                .frame(width: 260, height: 3)
                                .offset(y: laserOffset)
                                .shadow(color: Color.cyan, radius: 8)
                            
                            // Reticle Corner Accents
                            ReticleCorners(width: 280, height: intakeMode == .barcode ? 160 : 260)
                        }
                        
                        Text(intakeMode == .barcode ? lang.t(.alignBarcode) : lang.t(.alignRatingPlate))
                            .font(.caption)
                            .fontWeight(.medium)
                            .foregroundColor(.white.opacity(0.85))
                            .padding(.top, 14)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 6)
                            .background(Color.black.opacity(0.6))
                            .clipShape(Capsule())
                        
                        Spacer()
                    }
                }
                
                // Top Overlay Controls
                VStack {
                    HStack {
                        Button(action: { dismiss() }) {
                            Image(systemName: "xmark")
                                .font(.title3)
                                .foregroundColor(.white)
                                .padding(12)
                                .background(Color.black.opacity(0.5))
                                .clipShape(Circle())
                        }
                        
                        Spacer()
                        
                        #if os(iOS)
                        HStack(spacing: 12) {
                            Button(action: { cameraController.toggleTorch() }) {
                                Image(systemName: cameraController.isTorchOn ? "flashlight.on.fill" : "flashlight.off.fill")
                                    .font(.title3)
                                    .foregroundColor(cameraController.isTorchOn ? .yellow : .white)
                                    .padding(12)
                                    .background(Color.black.opacity(0.5))
                                    .clipShape(Circle())
                            }
                            
                            Button(action: { cameraController.flipCamera() }) {
                                Image(systemName: "camera.rotate")
                                    .font(.title3)
                                    .foregroundColor(.white)
                                    .padding(12)
                                    .background(Color.black.opacity(0.5))
                                    .clipShape(Circle())
                            }
                        }
                        #endif
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 10)
                    
                    // Intake Mode Segmented Control
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 8) {
                            ForEach(ScannerIntakeMode.allCases) { mode in
                                Button(action: { intakeMode = mode }) {
                                    HStack(spacing: 6) {
                                        Image(systemName: mode.icon)
                                        Text(mode.localizedName(using: lang))
                                            .font(.caption)
                                            .fontWeight(.semibold)
                                    }
                                    .padding(.horizontal, 14)
                                    .padding(.vertical, 8)
                                    .background(intakeMode == mode ? Color.cyan : Color.black.opacity(0.5))
                                    .foregroundColor(intakeMode == mode ? .black : .white)
                                    .clipShape(Capsule())
                                }
                            }
                        }
                        .padding(.horizontal, 20)
                    }
                    .padding(.top, 8)
                    
                    Spacer()
                    
                    // Bottom Controls & Input Bar
                    VStack(spacing: 16) {
                        if intakeMode == .manualText {
                            // Free-text Omni-search bar (e.g. Samsung QN85D)
                            HStack {
                                Image(systemName: "sparkles")
                                    .foregroundColor(.cyan)
                                TextField("e.g. Samsung QN85D, Miele W1, Jura E8...", text: $manualSearchText)
                                    .foregroundColor(.white)
                                    .submitLabel(.search)
                                    .onSubmit {
                                        handleManualSearch(manualSearchText)
                                    }
                                
                                if !manualSearchText.isEmpty {
                                    Button(action: { handleManualSearch(manualSearchText) }) {
                                        Text(lang.t(.search))
                                            .font(.caption)
                                            .fontWeight(.bold)
                                            .padding(.horizontal, 12)
                                            .padding(.vertical, 6)
                                            .background(Color.cyan)
                                            .foregroundColor(.black)
                                            .clipShape(Capsule())
                                    }
                                }
                            }
                            .padding(.horizontal, 16)
                            .padding(.vertical, 12)
                            .background(Color.white.opacity(0.15))
                            .clipShape(RoundedRectangle(cornerRadius: 14))
                            .padding(.horizontal, 20)
                        }
                        
                        HStack(spacing: 36) {
                            // Photo Library Picker
                            PhotosPicker(selection: $selectedPhotoItem, matching: .images) {
                                Image(systemName: "photo.on.rectangle")
                                    .font(.title2)
                                    .foregroundColor(.white)
                                    .frame(width: 52, height: 52)
                                    .background(Color.white.opacity(0.2))
                                    .clipShape(Circle())
                            }
                            .onChange(of: selectedPhotoItem) { _, newItem in
                                Task {
                                    if let data = try? await newItem?.loadTransferable(type: Data.self) {
                                        onCapturedPhoto(data)
                                        dismiss()
                                    }
                                }
                            }
                            
                            // Shutter / Capture Button
                            Button(action: {
                                #if os(iOS)
                                cameraController.capturePhoto()
                                #else
                                handleManualSearch(manualSearchText.isEmpty ? "Samsung QN85D" : manualSearchText)
                                #endif
                            }) {
                                ZStack {
                                    Circle()
                                        .stroke(Color.white, lineWidth: 4)
                                        .frame(width: 72, height: 72)
                                    Circle()
                                        .fill(Color.white)
                                        .frame(width: 58, height: 58)
                                }
                            }
                            
                            // Flash / Status Indicator
                            Button(action: {
                                handleManualSearch("Samsung QN85D Neo QLED")
                            }) {
                                Image(systemName: "sparkle.magnifyingglass")
                                    .font(.title2)
                                    .foregroundColor(.cyan)
                                    .frame(width: 52, height: 52)
                                    .background(Color.white.opacity(0.2))
                                    .clipShape(Circle())
                            }
                        }
                        .padding(.bottom, 24)
                    }
                    .background(
                        LinearGradient(
                            colors: [Color.clear, Color.black.opacity(0.85), Color.black],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                }
            }
            #if os(iOS)
            .toolbar(.hidden, for: .navigationBar)
            #endif
            .onAppear {
                #if os(iOS)
                Task {
                    await cameraController.requestPermissionAndSetup()
                }
                #endif
                withAnimation(.easeInOut(duration: 1.8).repeatForever(autoreverses: true)) {
                    laserOffset = 110
                }
            }
        }
    }
    
    private func handleDetectedBarcode(_ code: String) {
        onDetectedBarcode(code)
        dismiss()
    }
    
    private func handleManualSearch(_ text: String) {
        guard !text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { return }
        onManualSearchSubmit(text)
        dismiss()
    }
}

// MARK: - Reticle Corner Accents
struct ReticleCorners: View {
    let width: CGFloat
    let height: CGFloat
    let cornerLength: CGFloat = 24
    let cornerThickness: CGFloat = 4
    
    var body: some View {
        ZStack {
            // Top Left
            Path { path in
                path.move(to: CGPoint(x: 0, y: cornerLength))
                path.addLine(to: CGPoint(x: 0, y: 0))
                path.addLine(to: CGPoint(x: cornerLength, y: 0))
            }
            .stroke(Color.cyan, style: StrokeStyle(lineWidth: cornerThickness, lineCap: .round))
            .frame(width: width, height: height)
            
            // Top Right
            Path { path in
                path.move(to: CGPoint(x: width - cornerLength, y: 0))
                path.addLine(to: CGPoint(x: width, y: 0))
                path.addLine(to: CGPoint(x: width, y: cornerLength))
            }
            .stroke(Color.cyan, style: StrokeStyle(lineWidth: cornerThickness, lineCap: .round))
            .frame(width: width, height: height)
            
            // Bottom Left
            Path { path in
                path.move(to: CGPoint(x: 0, y: height - cornerLength))
                path.addLine(to: CGPoint(x: 0, y: height))
                path.addLine(to: CGPoint(x: cornerLength, y: height))
            }
            .stroke(Color.cyan, style: StrokeStyle(lineWidth: cornerThickness, lineCap: .round))
            .frame(width: width, height: height)
            
            // Bottom Right
            Path { path in
                path.move(to: CGPoint(x: width - cornerLength, y: height))
                path.addLine(to: CGPoint(x: width, y: height))
                path.addLine(to: CGPoint(x: width, y: height - cornerLength))
            }
            .stroke(Color.cyan, style: StrokeStyle(lineWidth: cornerThickness, lineCap: .round))
            .frame(width: width, height: height)
        }
    }
}

// MARK: - Simulator Camera Mock View
struct SimulatorCameraMockView: View {
    let onSelectSampleBarcode: (String) -> Void
    let onSelectSampleText: (String) -> Void
    private let lang = LanguageManager.shared
    
    var body: some View {
        ZStack {
            Color(red: 0.08, green: 0.10, blue: 0.14)
                .ignoresSafeArea()
            
            VStack(spacing: 16) {
                Image(systemName: "camera.metering.matrix")
                    .font(.system(size: 48))
                    .foregroundColor(.cyan.opacity(0.6))
                
                Text(lang.t(.liveCameraReady))
                    .font(.headline)
                    .foregroundColor(.white)
                
                Text(lang.t(.tapSampleAsset))
                    .font(.caption)
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 24)
                
                VStack(spacing: 8) {
                    SampleScanButton(title: "📺 Samsung QN85D Neo QLED TV", subtitle: "Free-Text / Model Search") {
                        onSelectSampleText("Samsung QN85D Neo QLED 4K TV")
                    }
                    
                    SampleScanButton(title: "🧺 Miele W1 Washing Machine", subtitle: "Barcode: 4002516281921") {
                        onSelectSampleBarcode("4002516281921")
                    }
                    
                    SampleScanButton(title: "☕ Jura E8 Piano Black", subtitle: "Barcode: 7610917153723") {
                        onSelectSampleBarcode("7610917153723")
                    }
                    
                    SampleScanButton(title: "⚡ Scott Patron eRIDE 900", subtitle: "Frame: SCOTT-PATRON-CX4") {
                        onSelectSampleText("Scott Patron eRIDE 900 Bosch CX")
                    }
                    
                    SampleScanButton(title: "🎿 Stöckli Laser SL Racing", subtitle: "Serial: STK-2026-99") {
                        onSelectSampleText("Stöckli Laser SL 165cm")
                    }
                }
                .padding(.horizontal, 20)
            }
            .padding()
        }
    }
}

struct SampleScanButton: View {
    let title: String
    let subtitle: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                VStack(alignment: .leading, spacing: 2) {
                    Text(title)
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                    Text(subtitle)
                        .font(.caption2)
                        .foregroundColor(.cyan)
                }
                Spacer()
                Image(systemName: "arrow.up.forward.circle.fill")
                    .foregroundColor(.cyan)
            }
            .padding(.horizontal, 14)
            .padding(.vertical, 10)
            .background(Color.white.opacity(0.08))
            .clipShape(RoundedRectangle(cornerRadius: 10))
        }
    }
}

#if os(iOS)
// MARK: - UIViewRepresentable for AVCaptureVideoPreviewLayer
struct CameraPreviewRepresentable: UIViewRepresentable {
    let session: AVCaptureSession
    
    func makeUIView(context: Context) -> CameraPreviewUIView {
        let view = CameraPreviewUIView()
        view.previewLayer.session = session
        view.previewLayer.videoGravity = .resizeAspectFill
        return view
    }
    
    func updateUIView(_ uiView: CameraPreviewUIView, context: Context) {}
}

class CameraPreviewUIView: UIView {
    override class var layerClass: AnyClass {
        return AVCaptureVideoPreviewLayer.self
    }
    
    var previewLayer: AVCaptureVideoPreviewLayer {
        return layer as! AVCaptureVideoPreviewLayer
    }
}
#endif
