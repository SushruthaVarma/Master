//
//  HomeViewController.swift
//  AnyDoc
//
//  Created by Ahmed Fathi on 7/7/20.
//  Copyright © 2020 Ahmed Fathi. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {

    @IBOutlet var imageView: UIImageView!
    
    var imagePicker: ImagePicker!
    var visionReader: VisionReader!

    override func viewDidLoad() {
        super.viewDidLoad()

        self.imagePicker = ImagePicker(presentationController: self, delegate: self)
        self.visionReader = VisionReader(delegate: self)
    }

    @IBAction func showImagePicker(_ sender: UIButton) {
        self.imagePicker.present(from: sender)
    }
    
    @IBAction func applyOCR(_ sender: UIButton) {
        guard let image = imageView.image else {
            print("No image selected")
            return
        }
        
        visionReader.recognizeText(in: image)
    }
}

extension HomeViewController: ImagePickerDelegate {

    func didSelect(image: UIImage?) {
        self.imageView.backgroundColor = .clear
        self.imageView.image = image
    }
}


extension HomeViewController: VisionReaderDelegate {
    
    func didCompleteRecognition(text: String) {
        print(string)
    }
    
    func didFail(error: Error) {
        print(error)
    }
}
