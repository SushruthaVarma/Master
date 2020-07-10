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
    
    @IBOutlet var collectionView: UICollectionView! {
        didSet {
            collectionView.delegate = self
            collectionView.dataSource = self
            collectionView.contentInset = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
            collectionView.register(ScanCollectionViewCell.self)
        }
    }
    @IBOutlet weak var addButton: UIButton!
    
    // MARK: Constants
    
    enum Constants {
        static let collectionInteritemSpacing: CGFloat = 8
        static let collectionLineSpacing: CGFloat = 8
        static let collectionNumberOfColumns: CGFloat = 3
    }
    
    // MARK: Properties
    
    var imagesScans = [ImageScan]() {
        didSet {
            collectionView.reloadData()
        }
    }
    

    // MARK: View functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addButton.layer.cornerRadius = addButton.frame.height / 2
        addButton.clipsToBounds = true
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(didAddNewImageHandler),
            name: .didAddNewImageScan,
            object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: Helpers
    
    @objc private func didAddNewImageHandler(notification: Notification) {
        guard let imageScan = notification.object as? ImageScan else { return }
        imagesScans.append(imageScan)
    }
    
    // MARK: Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let resultVC = segue.destination as? OCRResultViewController {
            resultVC.text = sender as? String
        }
    }
}


// MARK: - UICollectionViewDelegate

extension HomeViewController: UICollectionViewDelegate {
    
}

// MARK: - UICollectionViewDataSource

extension HomeViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        imagesScans.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: ScanCollectionViewCell.reuseId, for: indexPath)
            as? ScanCollectionViewCell else { fatalError() }
        cell.scanImageView.image = imagesScans[indexPath.row].image
        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension HomeViewController: UICollectionViewDelegateFlowLayout {
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


extension Notification.Name {
    static let didAddNewImageScan = Notification.Name(rawValue: "didAddNewImageScan")
}
