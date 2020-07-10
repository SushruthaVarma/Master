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
    
    // MARK: Constants
    
    enum Constants {
        static let OCRSegue = "OCRSegue"
    }
    
    // MARK: Dependancies

    var imagePicker: ImagePicker!
    
    lazy var captureSessionManager: CaptureManager = {
        let manager = PhotoCaptureManager()
        manager.didProcessImage = didProcessImage
        return manager
    }()
    
    // MARK: View functions

    override func viewDidLoad() {
        super.viewDidLoad()
        
        recordButton.layer.cornerRadius = recordButton.frame.height / 2
        recordButton.clipsToBounds = true
        
        self.imagePicker = ImagePicker(presentationController: self, delegate: self)
        
    }
    
    // MARK: Actions

    @IBAction func didTapPhotoGallary(_ sender: UIButton) {
        imagePicker.present(from: sender)
    }
    
    @IBAction func didTapClose(_ sender: UIButton) {
        dismiss(animated: true)
    }
    
    lazy var didProcessImage: (Data) -> Void = { [weak self] data in
        guard let image = UIImage(data: data) else { return }
        self?.performSegue(withIdentifier: Constants.OCRSegue, sender: image)
    }
    
    // MARK: Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let ocrViewController = segue.destination as? OCRViewController {
            ocrViewController.image = sender as? UIImage
        }
    }

}

// MARK: - ImagePickerDelegate

extension CaptureViewController: ImagePickerDelegate {
    
    func didSelect(image: UIImage?) {
        guard let image = image else { return }
        performSegue(withIdentifier: Constants.OCRSegue, sender: image)
    }
    
}
