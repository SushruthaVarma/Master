//
//  PhotoProcessor.swift
//  AnyDoc
//
//  Created by Ahmed Fathi on 7/10/20.
//  Copyright © 2020 Ahmed Fathi. All rights reserved.
//

import AVFoundation

class ImageProcessor: NSObject, AVCapturePhotoCaptureDelegate {
    
    var didProcessImage: ((Data) -> Void)?
    
    func photoOutput(
        _ output: AVCapturePhotoOutput,
        didFinishProcessingPhoto photo: AVCapturePhoto,
        error: Error?)
    {
        // Currently no processing required. Just return the image data as is.
        guard
            let data = photo.fileDataRepresentation()
            else { return }
        didProcessImage?(data)
    }
}
