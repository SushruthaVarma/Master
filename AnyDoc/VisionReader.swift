//
//  VisionReader.swift
//  AnyDoc
//
//  Created by Ahmed Fathi on 7/8/20.
//  Copyright © 2020 Ahmed Fathi. All rights reserved.
//

import UIKit
import Vision

protocol VisionReaderDelegate: AnyObject {
    
    func didCompleteRecognition(string: String)
    func didFail(error: Error)
    
}

class VisionReader {
    
    // MARK: Initializers
    
    private weak var delegate: VisionReaderDelegate?
    init(delegate: VisionReaderDelegate) {
        self.delegate = delegate
    }
    
    // MARK: Recoginze Text
    
    func recognizeText(in image: UIImage) {
        // Create CGImage
        guard let cgImage = image.cgImage else { return }
        
        // Create image request with CGImage
        let imageRequest = VNImageRequestHandler(cgImage: cgImage, options: [:])
        
        // Create text reuqest
        let textRequest = VNRecognizeTextRequest(completionHandler: completionHandler)
        
        // Select recognition level
        textRequest.recognitionLevel = .accurate
        
        // Specify language correction
        textRequest.usesLanguageCorrection = true
        
        do {
            // Perform the text recogintion request
            try imageRequest.perform([textRequest])
            
        } catch {
            print("Faild to perform the text recognition request. \(error)")
        }
        
    }
    
    // MARK: Completion Handler
    // Text recognition completion handler
    lazy var completionHandler: (VNRequest, Error?) -> Void = { [weak delegate] request, error in
                
        // Inform the delegate with the error if exists
        if let error = error {
            delegate?.didFail(error: error)
        }
        
        // The results are in the request
        guard let results = request.results as? [VNRecognizedTextObservation] else {
            return
        }
        
        // Maximum canditates of interest
        let maximumCandidates = 1
        
        // String to contain all recognized strings
        var recognizedText = ""
        
        // Iterate over the results
        for result in results {
            // Get the top candidate
            guard let candidate = result.topCandidates(maximumCandidates).first else {
                continue
            }
            
            // append to the recognized text
            recognizedText += candidate.string
            recognizedText += "\n"
        }
        
        // Inform the delegate with the recoginzed text
        delegate?.didCompleteRecognition(string: recognizedText)
        
    }
    
    
}
