//
//  OnboardingCollectionViewCell.swift
//  AnyDoc
//
//  Created by Ahmed Fathi on 7/16/20.
//  Copyright © 2020 Ahmed Fathi. All rights reserved.
//

import UIKit

class OnboardingCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var bodyLabel: UILabel!
    
    var onboardingItem: OnboardingItem? {
        didSet {
            guard let onboardingItem = onboardingItem else { return }
            updateUI(onboardingItem)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    private func updateUI(_ onboardingItem: OnboardingItem) {
        DispatchQueue.main.async {
            self.imageView.image = UIImage(named: onboardingItem.image)
            self.titleLabel.text = onboardingItem.title
            self.bodyLabel.text = onboardingItem.body
        }
    }

}
