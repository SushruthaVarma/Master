//
//  PreviewViewController.swift
//  AnyDoc
//
//  Created by Ahmed Fathi on 7/12/20.
//  Copyright © 2020 Ahmed Fathi. All rights reserved.
//

import UIKit

class PreviewViewController: UIViewController {
    
    // MARK: IBOutlets
    
    @IBOutlet weak var imageView: UIImageView!
    
    // MARK: Dependancies
    
    var scan: Scan?
    
    // MARK: View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.image = scan?.image
    }
    
    // MARK: Actions
    
    @IBAction func didTapClose(_ sender: Any) {
        dismiss(animated: true)
    }
    
    @IBAction func didTapShare(_ sender: Any) {
        guard let scan = scan else { return }
        let shareMenu = UIActivityViewController(activityItems: [scan.image, scan.text], applicationActivities: nil)
        present(shareMenu, animated: true)
    }
    
}

