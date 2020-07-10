//
//  OCRViewController.swift
//  AnyDoc
//
//  Created by Ahmed Fathi on 7/10/20.
//  Copyright © 2020 Ahmed Fathi. All rights reserved.
//

import UIKit

class OCRViewController: UIViewController {

    // MARK: IBOutlets
    
    @IBOutlet var imageView: UIImageView!
    
    // MARK: Constants
    
    enum Constants {
        static let OCRResultsSegue = "OCRResultsSegue"
        static let collectionInteritemSpacing: CGFloat = 8
        static let collectionLineSpacing: CGFloat = 8
        static let collectionNumberOfColumns: CGFloat = 3
    }
    
    // MARK: Dependancies
    
    var image: UIImage?
    var visionReader: VisionReader!
    var progressView: ProgressView!

    // MARK: View functions
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Prepare the dependancies
        visionReader = VisionReader(delegate: self)
        progressView = ProgressView(presentingViewController: self)
        
        // If image exist then start the OCR process
        if let image = image {
            imageView.image = image
            visionReader.recognizeText(in: image)
        }
        
    }
    
    // MARK: Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let navController = segue.destination as? UINavigationController,
            let resultVC = navController.viewControllers.first as? OCRResultViewController {
            resultVC.text = sender as? String
            resultVC.onDismissal = { [weak self] in
                self?.dismiss(animated: true)
            }
        }
    }
}


// MARK: - VisionReaderDelegate

extension OCRViewController: VisionReaderDelegate {

    func willStartRecognition() {
        progressView.present()
    }
    
    func didCompleteRecognition(text: String) {
        
        // Dismiss the the progress view
        progressView.dismiss {
            
            // After completion: Present the result view controller
            self.performSegue(withIdentifier: Constants.OCRResultsSegue, sender: text)
        }
        
        if let image = image {
            // Fire a notification with the image scan details
            let imageScan = ImageScan(image: image, text: text)
            NotificationCenter.default.post(name: .didAddNewImageScan, object: imageScan)
        }
    }

    func didUpdateProgress(percent: Double) {
        // Update the progress view with the new progress
        progressView.setProgress(Float(percent))
    }

    func didFail(error: Error) {
        // Dismiss the progress in case of failure
        progressView.dismiss()
        print("[Error] Text Recogintion Failed:", error)
    }
}
