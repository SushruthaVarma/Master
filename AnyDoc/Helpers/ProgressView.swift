//
//  ProgressView.swift
//  AnyDoc
//
//  Created by Ahmed Fathi on 7/8/20.
//  Copyright © 2020 Ahmed Fathi. All rights reserved.
//

import UIKit

class ProgressView {
    
    private lazy var progressView: UIProgressView = {
        let progressView = UIProgressView(frame: CGRect(x: 15, y: 20, width: 240, height: 8))
        return progressView
    }()
    
    private lazy var alert: UIAlertController = {
        let alert = UIAlertController(title: "", message: "", preferredStyle: .alert)
        alert.view.addSubview(progressView)
        return alert
    }()
    
    private weak var presentingViewController: UIViewController?
    init(presentingViewController: UIViewController) {
        self.presentingViewController = presentingViewController
    }
    
    func present() {
        progressView.progress = 0
        presentingViewController?.present(alert, animated: true)
    }
    
    func setProgress(_ progress: Float) {
        progressView.progress = progress
    }
    
    func dismiss(completion: (() -> Void)? = nil) {
        alert.dismiss(animated: true, completion: completion)
    }
    
}
