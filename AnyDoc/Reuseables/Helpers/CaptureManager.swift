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
    
    // Called when the output done processing the images and capturing it
    var didProcessImage: ((Data) -> Void)?
    
    init() {
        
        // Capture session inputs
        initCaptureSessionInputs()
        
        // Capture session outputs
        initCaptureSessionOutputs()
    }
    
    private func initCaptureSessionInputs() {
        
        // Begin the capturing session configurations
        session.beginConfiguration()
        
        guard
            // Create the capture device configuration
            let videoDevice = AVCaptureDevice.default(for: .video),
            
            // Get a capture input from the device configurations
            let videoDeviceInput = try? AVCaptureDeviceInput(device: videoDevice),
            
            // Verify that the session can accept these inputs
            session.canAddInput(videoDeviceInput)
            
            else { return }
        
        // Add the video input to capture session
        session.addInput(videoDeviceInput)
    }
    
    private func initCaptureSessionOutputs() {
        
        // Verify that the session can accept this output
        guard session.canAddOutput(output) else { return }
        
        // Setup the session with the output and the desired configurations
        session.sessionPreset = .photo
        session.addOutput(output)
        session.commitConfiguration()
        output.isDepthDataDeliveryEnabled = output.isDepthDataDeliverySupported
    }
    
//    func present(in view: UIView) {
//        let cameraLayer = AVCaptureVideoPreviewLayer(session: session)
//        cameraLayer.frame = view.frame
//    }
    
    func startSession() {
        
        // Guard the availability of the camera
        guard UIImagePickerController.isSourceTypeAvailable(.camera) else { return }
        
        // Start the capturing session
        session.startRunning()
        
        // Disable the idle timer to prevent the phone from turing off display
        UIApplication.shared.isIdleTimerDisabled = true
    }
    
    func stopSession() {
        
        // Stop the capturing session
        session.stopRunning()
        
        // Re-enable the phone to turn of display using idle timer
        UIApplication.shared.isIdleTimerDisabled = false
    }
    
    func capture() {
        
        // Specify the photo codec type
        let photoSettings = AVCapturePhotoSettings(format: [AVVideoCodecKey: AVVideoCodecType.jpeg])
        
        // Set depth enabled to the output's one
        photoSettings.isDepthDataDeliveryEnabled = output.isDepthDataDeliverySupported
        
        // Ask the capture output to capture a photo and send it to the delegate
        output.capturePhoto(with: photoSettings, delegate: processor)
    }
    
}
