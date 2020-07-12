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

    @IBOutlet weak var previewView: PreviewView!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var gallaryButton: UIButton!

    @IBOutlet weak var greenDotView: UIView!
    @IBOutlet weak var captureTypeCollectionView: UICollectionView! {
        didSet {
            captureTypeCollectionView.delegate = self
            captureTypeCollectionView.dataSource = self
            captureTypeCollectionView.isUserInteractionEnabled = false
            captureTypeCollectionView.register(CaptureTypeCollectionViewCell.self)
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }
    
    private lazy var leftSwipe: UISwipeGestureRecognizer = {
        let leftSwipe = UISwipeGestureRecognizer()
        leftSwipe.direction = .left
        leftSwipe.addTarget(self, action: #selector(didSwipeLeft))
        return leftSwipe
    }()
    
    private lazy var rightSwipe: UISwipeGestureRecognizer = {
        let rightSwipe = UISwipeGestureRecognizer()
        rightSwipe.direction = .right
        rightSwipe.addTarget(self, action: #selector(didSwipeRight))
        return rightSwipe
    }()
    
    // MARK: Constants
    
    enum Constants {
        static let OCRSegue = "OCRSegue"
    }
    
    // MARK: Dependancies

    lazy var imagePicker: ImagePicker = {
        let imagePicker = ImagePicker(presentationController: self, delegate: self)
        return imagePicker
    }()
    
    lazy var captureManager: CaptureManager = {
        let manager = PhotoCaptureManager()
        manager.didProcessImage = didProcessImage
        return manager
    }()
    
    // MARK: View functions

    override func viewDidLoad() {
        super.viewDidLoad()
        
        recordButton.layer.cornerRadius = recordButton.frame.height / 2
        greenDotView.layer.cornerRadius = greenDotView.frame.height / 2
        
        view.addGestureRecognizer(leftSwipe)
        view.addGestureRecognizer(rightSwipe)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        selectCaptureType(.single)
        
        previewView.videoPreviewLayer.session = captureManager.session
        previewView.videoPreviewLayer.videoGravity = .resizeAspectFill
        captureManager.startSession()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        captureManager.stopSession()
    }
    
    // MARK: Actions
    
    @IBAction func didTapCapture(_ sender: UIButton) {
        captureManager.capture()
    }

    @IBAction func didTapPhotoGallary(_ sender: UIButton) {
        imagePicker.present(from: sender)
    }
    
    @IBAction func didTapClose(_ sender: UIButton) {
        dismiss(animated: true)
    }
    
    @objc private func didSwipeLeft(_ gesture: UISwipeGestureRecognizer) {
        selectCaptureType(.batch)
    }
    
    @objc private func didSwipeRight(_ gesture: UISwipeGestureRecognizer) {
        selectCaptureType(.single)
    }
    
    private lazy var didProcessImage: (Data) -> Void = { [weak self] data in
        guard let image = UIImage(data: data) else { return }
        self?.performSegue(withIdentifier: Constants.OCRSegue, sender: image)
    }
    
    // MARK: Helpers
    
    private func selectCaptureType(_ type: CaptureType) {
        let indexPath = IndexPath(item: type.rawValue, section: 0)
        captureTypeCollectionView.selectItem(at: indexPath, animated: true, scrollPosition: .centeredHorizontally)
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

// MARK: - Capture Type Handlers

// MARK: UICollectionViewDelegate

extension CaptureViewController: UICollectionViewDelegate {
    
}

// MARK: UICollectionViewDataSource

extension CaptureViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        CaptureType.allCases.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: CaptureTypeCollectionViewCell.reuseId, for: indexPath)
            as? CaptureTypeCollectionViewCell else { fatalError() }
        cell.type = CaptureType.allCases[indexPath.row]
        return cell
    }
}

// MARK: CaptureType Enum

enum CaptureType: Int, CaseIterable {
    case single
    case batch
    
    var localizedTitle: String {
        switch self {
        case .single:   return "Single"
        case .batch:    return "Batch"
        }
    }
}
