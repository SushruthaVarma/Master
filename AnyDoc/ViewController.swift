//
//  ViewController.swift
//  AnyDoc
//
//  Created by Ahmed Fathi on 7/7/20.
//  Copyright © 2020 Ahmed Fathi. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet var imageView: UIImageView!
    
    var imagePicker: ImagePicker!

    override func viewDidLoad() {
        super.viewDidLoad()

        self.imagePicker = ImagePicker(presentationController: self, delegate: self)
    }

    @IBAction func showImagePicker(_ sender: UIButton) {
        self.imagePicker.present(from: sender)
    }
    
    @IBAction func applyOCR(_ sender: UIButton) {
        // TODO: Apply OCR
    }
}

extension ViewController: ImagePickerDelegate {

    func didSelect(image: UIImage?) {
        self.imageView.image = image
    }
}
