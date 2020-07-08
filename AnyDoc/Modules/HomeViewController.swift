//
//  HomeViewController.swift
//  AnyDoc
//
//  Created by Ahmed Fathi on 7/7/20.
//  Copyright © 2020 Ahmed Fathi. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {

    // MARK: IBOutlets
    
    @IBOutlet var imageView: UIImageView!
    
    // MARK: Constants
    
    enum Constants {
        static var resultsSegue = "resultsSegue"
    }
    
    // MARK: Dependancies
    
    var imagePicker: ImagePicker!
    var visionReader: VisionReader!
    var progressView: ProgressView!

    // MARK: View functions
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.imagePicker = ImagePicker(presentationController: self, delegate: self)
        self.visionReader = VisionReader(delegate: self)
        self.progressView = ProgressView(presentingViewController: self)
    }

    // MARK: Actions
    
    @IBAction func showImagePicker(_ sender: UIButton) {
        self.imagePicker.present(from: sender)
    }
    
    @IBAction func applyOCR(_ sender: UIButton) {
        guard let image = imageView.image else {
            print("No image selected")
            return
        }
        
        visionReader.recognizeText(in: image)
        progressView.present()
    }
    
    // MARK: Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let resultVC = segue.destination as? ResultViewController {
            resultVC.text = sender as? String
        }
    }
}


// MARK: - ImagePickerDelegate

extension HomeViewController: ImagePickerDelegate {

    func didSelect(image: UIImage?) {
        self.imageView.backgroundColor = .clear
        self.imageView.image = image
    }
}

// MARK: - VisionReaderDelegate

extension HomeViewController: VisionReaderDelegate {
    
    func didCompleteRecognition(text: String) {
        // Dismiss the the progress
        progressView.dismiss {
            
            // After completion: Navigate to the result view controller
            self.performSegue(withIdentifier: Constants.resultsSegue, sender: text)
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
