//
//  UITableView+RegisterCell.swift
//  AnyDoc
//
//  Created by Ahmed Fathi on 7/11/20.
//  Copyright © 2020 Ahmed Fathi. All rights reserved.
//

import UIKit

// MARK: UICollectionView Extensions
// Convenience extentions to register cell in collectionView
extension UITableView {
    func register(_ cellType: AnyClass) {
        let identifier = String(describing: cellType.self)
        let nib = UINib(nibName: identifier, bundle: nil)
        register(nib, forCellReuseIdentifier: identifier)
    }
}

// MARK: UICollectionViewCell Extensions
extension UITableViewCell {
    static var reuseId: String {
        String(describing: self)
    }
}
