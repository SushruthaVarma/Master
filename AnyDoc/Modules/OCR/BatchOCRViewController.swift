//
//  BatchOCRViewController.swift
//  AnyDoc
//
//  Created by Ahmed Fathi on 7/14/20.
//  Copyright © 2020 Ahmed Fathi. All rights reserved.
//

import UIKit

class BatchOCRViewController: UIViewController {
    
    // MARK: IBOutlets
    
    @IBOutlet var batchOCRButton: UIButton!

    @IBOutlet var collectionView: UICollectionView! {
        didSet {
            collectionView.contentInset = UIEdgeInsets(top: 8, left: 8, bottom: 60, right: 8)
            collectionView.register(ScanCollectionViewCell.self)
            collectionView.delegate = self
            collectionView.dataSource = self
        }
    }
    
    // MARK: Constants
    
    enum Constants {
        static let collectionInteritemSpacing: CGFloat = 8
        static let collectionLineSpacing: CGFloat = 8
        static let collectionNumberOfColumns: CGFloat = 3
    }
    
    // MARK: Properties
    
    var document: Document! {
        didSet {
            navigationItem.title = document.name
            collectionView?.reloadData()
        }
    }
    
    var indexOfImageInOCR = 0
    
    // MARK: Dependancies
    
    var visionReader: VisionReader!
    var progressView: ProgressView!
    
    // MARK: View functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        batchOCRButton.layer.cornerRadius = 8
        visionReader = VisionReader(delegate: self)
        progressView = ProgressView(presentingViewController: self)
    }
    
    // MARK: Actions
    
    @IBAction private func didTapOCR(_ sender: UIButton) {
        progressView.present()
        tryProcessImage(at: 0)
    }
    
    @IBAction func didTapCancel(_ sender: Any) {
        dismiss(animated: true)
    }
    
    private func tryProcessImage(at index: Int) {
        visionReader.recognizeText(in: document.scans[index].image)
    }
}

// MARK: - UICollectionViewDelegate

extension BatchOCRViewController: UICollectionViewDelegate {}

// MARK: - UICollectionViewDataSource

extension BatchOCRViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        document.scans.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: ScanCollectionViewCell.reuseId, for: indexPath)
            as? ScanCollectionViewCell else { fatalError() }
        cell.scanImageView.image = document.scans[indexPath.row].image
        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension BatchOCRViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let paddings = (Constants.collectionNumberOfColumns + 1) * Constants.collectionInteritemSpacing
        let width = (collectionView.frame.width - paddings) / Constants.collectionNumberOfColumns
        let height = width
        return CGSize(width: floor(width), height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        Constants.collectionLineSpacing
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        Constants.collectionInteritemSpacing
    }
    
}

extension BatchOCRViewController: VisionReaderDelegate {

    func willStartRecognition() {}
    
    func didCompleteRecognition(text: String) {
        // Assign the scanned text to the image
        document.scans[indexOfImageInOCR].text = text
        
        // Increment the counter
        indexOfImageInOCR += 1
        
        // If there is more images then try to scan the next one
        if indexOfImageInOCR < document.scans.count {
            tryProcessImage(at: indexOfImageInOCR)
        } else {
            // All images has been completed
            // Fire a notification with the document
            NotificationCenter.default.post(name: .didAddNewDocument, object: document)
            
            // Dismiss the progress view
            progressView.dismiss {
                // After completion dismiss the current view controller
                self.dismiss(animated: true)
            }
        }
    }

    func didUpdateProgress(percent: Double) {
        let segments = document.scans.count
        let completedImages = Double(indexOfImageInOCR) * (1.0 / Double(segments))
        let normalizedProgressOfCurrentImage = percent / Double(segments)
        
        let totalProgress = completedImages + normalizedProgressOfCurrentImage
        progressView.setProgress(Float(totalProgress))
    }

    func didFail(error: Error) {
        // Dismiss the progress in case of failure
        progressView.dismiss()
        print("[Error] Text Recogintion Failed:", error)
    }
}

extension Notification.Name {
    static let didAddNewDocument = Notification.Name(rawValue: "didAddNewDocument")
}
