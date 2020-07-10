//
//  CaptureManager.swift
//  AnyDoc
//
//  Created by Ahmed Fathi on 7/10/20.
//  Copyright © 2020 Ahmed Fathi. All rights reserved.
//

import UIKit
import AVFoundation

protocol CaptureManager {
    var session: AVCaptureSession { get }
    var didProcessImage: ((Data) -> Void)? { get }
    func startSession()
    func stopSession()
    func capture()
}

class PhotoCaptureManager: CaptureManager {
    
    lazy var session = AVCaptureSession()
    private lazy var output = AVCapturePhotoOutput()
    private lazy var processor: ImageProcessor = {
        let imageProcessor = ImageProcessor()
        imageProcessor.didProcessImage = didProcessImage
        return imageProcessor
    }()
    
    var didProcessImage: ((Data) -> Void)?
    
    init() {
        initCaptureSessionInputs()
        initCaptureSessionOutputs()
    }
    
    private func initCaptureSessionInputs() {
        session.beginConfiguration()
        guard
            let videoDevice = AVCaptureDevice.default(
                .builtInDualCamera,
                for: .depthData,
                position: .unspecified),
            let videoDeviceInput = try? AVCaptureDeviceInput(device: videoDevice),
            session.canAddInput(videoDeviceInput) else { return }
        session.addInput(videoDeviceInput)
    }
    
    private func initCaptureSessionOutputs() {
        guard session.canAddOutput(output) else { return }
        session.sessionPreset = .photo
        session.addOutput(output)
        session.commitConfiguration()
        output.isDepthDataDeliveryEnabled = output.isDepthDataDeliverySupported
    }
    
    func startSession() {
        session.startRunning()
        UIApplication.shared.isIdleTimerDisabled = true
    }
    
    func stopSession() {
        session.stopRunning()
        UIApplication.shared.isIdleTimerDisabled = false
    }
    
    func capture() {
        let photoSettings = AVCapturePhotoSettings(format: [AVVideoCodecKey: AVVideoCodecType.jpeg])
        photoSettings.isDepthDataDeliveryEnabled = output.isDepthDataDeliverySupported
        output.capturePhoto(with: photoSettings, delegate: processor)
    }
    
}
