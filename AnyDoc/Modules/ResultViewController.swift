//
//  ResultViewController.swift
//  AnyDoc
//
//  Created by Ahmed Fathi on 7/8/20.
//  Copyright © 2020 Ahmed Fathi. All rights reserved.
//

import UIKit

class ResultViewController: UIViewController {
    
    // MARK: IBOutlets
    
    @IBOutlet weak var textView: UITextView! {
        didSet {
            textView.contentInset = UIEdgeInsets(top: 15, left: 10, bottom: 30, right: 10)
            textView.isEditable = false
        }
    }
    
    // MARK: Dependancies
    
    var text: String?
    
    // MARK: View functions
    override func viewDidLoad() {
        super.viewDidLoad()
        
        textView.text = text
    }
}
