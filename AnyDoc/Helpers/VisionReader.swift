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
    
    func didCompleteRecognition(text: String)
    func didUpdateProgress(percent: Double)
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
        
        // Create text reuqest with the completion handler
        let textRequest = VNRecognizeTextRequest(completionHandler: completionHandler)
        
        // Specify the progress handler
        textRequest.progressHandler = progressHandler
        
        // Specify recognition level
        textRequest.recognitionLevel = .accurate
        
        // Specify language correction
        textRequest.usesLanguageCorrection = true
        
        // Perform the text recogintion request on a background thread
        DispatchQueue.global(qos: .userInteractive).async {
            do {
                try imageRequest.perform([textRequest])
                
            } catch {
                print("Faild to perform the text recognition request. \(error)")
            }
        }
        
    }
    
    // MARK: Completion Handler
    
    // Text recognition completion handler
    lazy var completionHandler: VNRequestCompletionHandler = { [weak delegate] request, error in
                
        // Inform the delegate with the error if exists
        if let error = error {
            DispatchQueue.main.async {
                delegate?.didFail(error: error)
            }
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
        
        DispatchQueue.main.async {
            // Inform the delegate with the recoginzed text
            delegate?.didCompleteRecognition(text: recognizedText)
        }
        
    }
    
    // MARK: Progress Handler
    lazy var progressHandler: VNRequestProgressHandler = { [weak delegate] _, percent, _ in
        DispatchQueue.main.async {
            delegate?.didUpdateProgress(percent: percent)
        }
    }
    
    
}
