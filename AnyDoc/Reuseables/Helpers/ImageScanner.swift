//
//  ImageScanner.swift
//  AnyDoc
//
//  Created by Ahmed Fathi on 7/15/20.
//  Copyright © 2020 Ahmed Fathi. All rights reserved.
//

import Foundation
import WeScan


protocol ImageScannerDelegate: AnyObject {
    func didComplete(_ croppedImage: UIImage)
    func didFail(_ error: Error)
}

class ImageScanner: NSObject {
    
    weak var delegate: ImageScannerDelegate?
    weak var presentingViewController: UIViewController?
    init(presentingViewController: UIViewController, delegate: ImageScannerDelegate) {
        self.delegate = delegate
        self.presentingViewController = presentingViewController
    }
    
    
    func present() {
        let scanner = ImageScannerController()
        scanner.imageScannerDelegate = self
        scanner.modalPresentationStyle = .fullScreen
        presentingViewController?.present(scanner, animated: true)
    }
    
}

// MARK: - ImageScannerControllerDelegate

extension ImageScanner: ImageScannerControllerDelegate {
    
    func imageScannerController(
        _ scanner: ImageScannerController,
        didFinishScanningWithResults results: ImageScannerResults)
    {
        delegate?.didComplete(results.croppedScan.image)
        scanner.dismiss(animated: true)
    }
    
    func imageScannerControllerDidCancel(_ scanner: ImageScannerController) {
        scanner.dismiss(animated: true)
    }
    
    func imageScannerController(_ scanner: ImageScannerController, didFailWithError error: Error) {
        delegate?.didFail(error)
    }
}
 
