//
//  ScansViewController.swift
//  AnyDoc
//
//  Created by Ahmed Fathi on 7/7/20.
//  Copyright © 2020 Ahmed Fathi. All rights reserved.
//

import UIKit

class ScansViewController: UIViewController {
    
    // MARK: IBOutlets
    
    @IBOutlet var collectionView: UICollectionView! {
        didSet {
            collectionView.register(ScanCollectionViewCell.self)
            collectionView.delegate = self
            collectionView.dataSource = self
            collectionView.contentInset = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        }
    }
    
    // MARK: Constants
    
    enum Constants {
        static let previewSegue = "previewSegue"
        static let collectionInteritemSpacing: CGFloat = 8
        static let collectionLineSpacing: CGFloat = 8
        static let collectionNumberOfColumns: CGFloat = 3
    }
    
    // MARK: Properties
    
    var document: Document? {
        didSet {
            navigationItem.title = document?.name
            collectionView?.reloadData()
        }
    }

    // MARK: View functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let previewVC = segue.destination as? PreviewViewController {
            previewVC.scan = sender as? Scan
        }
    }
    
}


// MARK: - UICollectionViewDelegate

extension ScansViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let scan = document?.scans[indexPath.row] else { return }
        performSegue(withIdentifier: Constants.previewSegue, sender: scan)
    }
}

// MARK: - UICollectionViewDataSource

extension ScansViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        document?.scans.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: ScanCollectionViewCell.reuseId, for: indexPath)
            as? ScanCollectionViewCell,
            let scans = document?.scans
        else { fatalError() }
        
        cell.scanImageView.image = scans[indexPath.row].image
        
        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension ScansViewController: UICollectionViewDelegateFlowLayout {
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


