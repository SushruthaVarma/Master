//
//  ScanCollectionViewCell.swift
//  AnyDoc
//
//  Created by Ahmed Fathi on 7/10/20.
//  Copyright © 2020 Ahmed Fathi. All rights reserved.
//

import UIKit

class ScanCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var scanImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        scanImageView.backgroundColor = UIColor.gray.withAlphaComponent(0.1)
    }

}
