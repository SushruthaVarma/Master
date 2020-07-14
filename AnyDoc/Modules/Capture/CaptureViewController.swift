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
    
    @IBOutlet weak var bottomRightCornerView: UIView! {
        didSet {
            bottomRightCornerView.addGestureRecognizer(bottomRightCornerTapGesture)
        }
    }
    @IBOutlet weak var lastImagePlaceholder: UIImageView!
    @IBOutlet weak var rightArrow: UIImageView!
    
    @IBOutlet weak var greenDotView: UIView!
    @IBOutlet weak var captureTypeCollectionView: UICollectionView! {
        didSet {
            captureTypeCollectionView.delegate = self
            captureTypeCollectionView.dataSource = self
            captureTypeCollectionView.isUserInteractionEnabled = false
            captureTypeCollectionView.register(CaptureTypeCollectionViewCell.self)
        }
    }
    
    lazy var bottomRightCornerTapGesture: UITapGestureRecognizer = {
        let tap = UITapGestureRecognizer()
        tap.addTarget(self, action: #selector(didTapBottomRightCorner))
        return tap
    }()
    
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
        static let singleOCRSegue = "singleOCRSegue"
        static let batchOCRSegue = "batchOCRSegue"
    }
    
    enum State {
        case noPhotos
        case batchPhotos
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
    
    // MARK: Properties
    
    var captureType: CaptureType = .single {
        didSet {
            selectCaptureType(captureType)
        }
    }
    
    private var images = [UIImage]() {
        didSet {
            state = images.isEmpty ? .noPhotos : .batchPhotos
        }
    }
    
    private var state: State = .noPhotos {
        didSet {
            updateUI(state)
        }
    }
    
    // MARK: View functions

    override func viewDidLoad() {
        super.viewDidLoad()
        state = .noPhotos
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.captureType = .single            
        }
        
        recordButton.layer.cornerRadius = recordButton.frame.height / 2
        greenDotView.layer.cornerRadius = greenDotView.frame.height / 2
        
        view.addGestureRecognizer(leftSwipe)
        view.addGestureRecognizer(rightSwipe)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
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

    @objc func didTapBottomRightCorner(_ gesture: UITapGestureRecognizer) {
        if state == .noPhotos {
            imagePicker.present(from: bottomRightCornerView)
        } else if state == .batchPhotos {
            let name = Document.generateDocumentName()
            let scans = images.map { Scan(image: $0) }
            let document = Document(name: name, scans: scans)
            performSegue(withIdentifier: Constants.batchOCRSegue, sender: document)
        }
    }
    
    @IBAction func didTapClose(_ sender: UIButton) {
        dismiss(animated: true)
    }
    
    @objc private func didSwipeLeft(_ gesture: UISwipeGestureRecognizer) {
        if let nextType = captureType.next {
            captureType = nextType
        }
    }
    
    @objc private func didSwipeRight(_ gesture: UISwipeGestureRecognizer) {
        if let previousType = captureType.previous {
            captureType = previousType
        }
    }
    
    private lazy var didProcessImage: (Data) -> Void = { [weak self] data in
        guard let strongSelf = self, let image = UIImage(data: data) else { return }
        if strongSelf.captureType == .single {
            strongSelf.performSegue(withIdentifier: Constants.singleOCRSegue, sender: image)
        } else {
            strongSelf.images.append(image)
        }
    }
    
    // MARK: Helpers
    
    private func selectCaptureType(_ type: CaptureType, animated: Bool = true) {
        let indexPath = IndexPath(item: type.rawValue, section: 0)
        captureTypeCollectionView.selectItem(at: indexPath, animated: true, scrollPosition: .centeredHorizontally)
    }
    
    
    // MARK: Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let ocrViewController = segue.destination as? OCRViewController {
            ocrViewController.image = sender as? UIImage
        } else if let navController = segue.destination as? UINavigationController,
            let batchOCRViewController = navController.viewControllers.first as? BatchOCRViewController {
            batchOCRViewController.document = sender as? Document
        }
    }
    
    // MARK: Update UserInterface
    
    func updateUI(_ state: State) {
        switch state {
        case .noPhotos:
            rightArrow.isHidden = true
            lastImagePlaceholder.image = UIImage(named: "i-gallary")
            
        case .batchPhotos:
            rightArrow.isHidden = false
            lastImagePlaceholder.image = images.last
            
        }
    }

}

// MARK: - ImagePickerDelegate

extension CaptureViewController: ImagePickerDelegate {
    
    func didSelect(image: UIImage?) {
        guard let image = image else { return }
        if captureType == .single {
            performSegue(withIdentifier: Constants.singleOCRSegue, sender: image)
        } else {
            self.images.append(image)
        }
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
    case OCR
    case IDCard
    case single
    case batch
    case IDPhoto
    case QRCode
    
    var previous: CaptureType? {
        CaptureType(rawValue: self.rawValue - 1)
    }
    
    var next: CaptureType? {
        CaptureType(rawValue: self.rawValue + 1)
    }
    
    var localizedTitle: String {
        switch self {
        case .OCR:              return "OCR"
        case .IDCard:           return "ID Card"
        case .single:           return "Single"
        case .batch:            return "Batch"
        case .IDPhoto:          return "ID Photo"
        case .QRCode:           return "QR Code"
        }
    }
}
