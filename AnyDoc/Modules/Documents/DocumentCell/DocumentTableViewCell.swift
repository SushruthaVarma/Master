//
//  DocumentTableViewCell.swift
//  AnyDoc
//
//  Created by Ahmed Fathi on 7/11/20.
//  Copyright © 2020 Ahmed Fathi. All rights reserved.
//

import UIKit

class DocumentTableViewCell: UITableViewCell {

    // MARK: IBOutlets
    
    @IBOutlet weak var previewImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var numberOfScansLabel: UILabel!
    
    // MARK: Dependancies
    
    var document: Document? {
        didSet {
            guard let document = document else { return }
            updateUI(document)
        }
    }
    
    // MARK: View Functions
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    // MARK: Update UserInterface
    
    private func updateUI(_ document: Document) {
        DispatchQueue.main.async {
            self.previewImageView.image = document.scans.first?.image
            self.nameLabel.text = document.name
            self.numberOfScansLabel.text = String(document.scans.count)
        }
    }
    
}
