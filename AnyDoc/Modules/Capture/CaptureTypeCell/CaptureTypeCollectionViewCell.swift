//
//  CaptureTypeCollectionViewCell.swift
//  AnyDoc
//
//  Created by Ahmed Fathi on 7/12/20.
//  Copyright © 2020 Ahmed Fathi. All rights reserved.
//

import UIKit

class CaptureTypeCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var label: UILabel!
    
    var type: CaptureType? {
        didSet {
            guard let type = type else { return }
            updateUI(type)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    private func updateUI(_ type: CaptureType) {
        DispatchQueue.main.async {
            self.label.text = type.localizedTitle
        }
    }
    
    override var isSelected: Bool {
        didSet {
            self.label.textColor = isSelected ? .systemGreen : .white
        }
    }

}
