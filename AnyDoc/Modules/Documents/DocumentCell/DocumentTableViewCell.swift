//
//  DocumentTableViewCell.swift
//  AnyDoc
//
//  Created by Ahmed Fathi on 7/11/20.
//  Copyright © 2020 Ahmed Fathi. All rights reserved.
//

import UIKit

class DocumentTableViewCell: UITableViewCell {

    
    @IBOutlet weak var previewImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    
    var document: Document? {
        didSet {
            guard let document = document else { return }
            updateUI(document)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    private func updateUI(_ document: Document) {
        DispatchQueue.main.async {
            self.previewImageView.image = document.scans.first?.image
            self.nameLabel.text = document.name
        }
    }
    
}
