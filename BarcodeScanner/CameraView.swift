//
//  CameraView.swift
//  BarcodeScanner
//
//  Created by Danish on 26/06/24.
//

import Foundation
import AVFoundation
import SwiftUI


struct CameraView: UIViewControllerRepresentable {
    @Binding var scannedCode: String?

    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }

    func makeUIViewController(context: Context) -> UIViewController {
        let viewController = UIViewController()
        let captureSession = AVCaptureSession()

        guard let videoCaptureDevice = AVCaptureDevice.default(for: .video) else { return viewController }
        let videoInput: AVCaptureDeviceInput

        do {
            videoInput = try AVCaptureDeviceInput(device: videoCaptureDevice)
        } catch {
            return viewController
        }

        if (captureSession.canAddInput(videoInput)) {
            captureSession.addInput(videoInput)
        } else {
            return viewController
        }

        let metadataOutput = AVCaptureMetadataOutput()

        if (captureSession.canAddOutput(metadataOutput)) {
            captureSession.addOutput(metadataOutput)

            metadataOutput.setMetadataObjectsDelegate(context.coordinator, queue: DispatchQueue.main)
            metadataOutput.metadataObjectTypes = [.ean8, .ean13, .pdf417, .qr]
        } else {
            return viewController
        }

        let previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.videoGravity = .resizeAspectFill // Maintain aspect ratio
        viewController.view.layer.addSublayer(previewLayer)

        // Adjusting previewLayer frame to fit within specified height
        let statusBarHeight = UIApplication.shared.statusBarFrame.height
        let navigationBarHeight = viewController.navigationController?.navigationBar.frame.height ?? 0
        let topInset = statusBarHeight + navigationBarHeight
        previewLayer.frame = CGRect(x: 0, y: topInset, width: UIScreen.main.bounds.width, height: 220)

        captureSession.startRunning()

        return viewController
    }

    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
    }

    class Coordinator: NSObject, AVCaptureMetadataOutputObjectsDelegate {
        var parent: CameraView

        init(parent: CameraView) {
            self.parent = parent
        }

        func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
            if let metadataObject = metadataObjects.first {
                guard let readableObject = metadataObject as? AVMetadataMachineReadableCodeObject else { return }
                if let stringValue = readableObject.stringValue {
                    AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
                    parent.scannedCode = stringValue
                }
            }
        }
    }
}
