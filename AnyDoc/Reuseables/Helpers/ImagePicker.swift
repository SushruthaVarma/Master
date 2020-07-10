//
//  ImagePicker.swift
//  AnyDoc
//
//  Created by Ahmed Fathi on 7/7/20.
//  Copyright © 2020 Ahmed Fathi. All rights reserved.
//

import UIKit

protocol ImagePickerDelegate: class {
    func didSelect(image: UIImage?)
}

class ImagePicker: NSObject {
    
    private lazy var pickerController: UIImagePickerController = {
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.mediaTypes = ["public.image"]
        pickerController.modalPresentationStyle = .fullScreen
        return pickerController
    }()
    
    private weak var presentationController: UIViewController?
    private weak var delegate: ImagePickerDelegate?
    
    init(presentationController: UIViewController, delegate: ImagePickerDelegate) {
        super.init()
        self.presentationController = presentationController
        self.delegate = delegate
    }
    
    func present(from sourceView: UIView) {
        pickerController.sourceType = .photoLibrary
        presentationController?.present(pickerController, animated: true)
    }
    
    private func pickerController(_ controller: UIImagePickerController, didSelect image: UIImage?) {
        controller.dismiss(animated: true, completion: nil)
        delegate?.didSelect(image: image)
    }
}

extension ImagePicker: UIImagePickerControllerDelegate {
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        pickerController(picker, didSelect: nil)
    }
    
    func imagePickerController(
        _ picker: UIImagePickerController,
        didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any])
    {
        guard let image = info[.originalImage] as? UIImage else {
            return pickerController(picker, didSelect: nil)
        }
        pickerController(picker, didSelect: image)
    }
}

extension ImagePicker: UINavigationControllerDelegate {
    
}
