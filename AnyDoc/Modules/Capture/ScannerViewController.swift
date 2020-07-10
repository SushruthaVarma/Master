//
//  CaptureViewController.swift
//  AnyDoc
//
//  Created by Ahmed Fathi on 7/10/20.
//  Copyright © 2020 Ahmed Fathi. All rights reserved.
//

import UIKit

class CaptureViewController: UIViewController {
    
    // MARK: IBOutlets

    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var gallaryButton: UIButton!
    
    // MARK: Dependancies

    var imagePicker: ImagePicker!
    
    // MARK: View functions

    override func viewDidLoad() {
        super.viewDidLoad()
        
        recordButton.layer.cornerRadius = recordButton.frame.height / 2
        recordButton.clipsToBounds = true
        
        self.imagePicker = ImagePicker(presentationController: self, delegate: self)
        
    }
    
    // MARK: Actions

    @IBAction func didTapPhotoGallary(_ sender: UIButton) {
        self.imagePicker.present(from: sender)
    }
    
    // MARK: Navigation

}

// MARK: - ImagePickerDelegate

extension CaptureViewController: ImagePickerDelegate {
    
    func didSelect(image: UIImage?) {}
    
}
