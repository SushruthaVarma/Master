//
//  TabBarController.swift
//  AnyDoc
//
//  Created by Ahmed Fathi on 7/10/20.
//  Copyright © 2020 Ahmed Fathi. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController {
    
    lazy var addButton: UIButton = {
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "tabBar-camera"), for: .normal)
        button.setImage(#imageLiteral(resourceName: "tabBar-camera"), for: .highlighted)
        button.backgroundColor = .systemGreen
        button.addTarget(self, action: #selector(presentCapturePhoto), for: .touchUpInside)
        return button
    }()
    
    enum Constants {
        static let buttonHeight: CGFloat = 65
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // TabBar
        tabBar.backgroundImage = UIImage()
        tabBar.shadowImage = UIImage()
        tabBar.backgroundColor = UIColor.secondarySystemBackground
        tabBar.tintColor = .systemGreen
        
        // Docs Button
        if let docs = tabBar.items?.first {
            docs.title = "Docs"
            docs.image = UIImage(named: "tabBar-doc")
        }
        
        // Middle button
        tabBar.addSubview(addButton)
        addButton.layer.cornerRadius = Constants.buttonHeight / 2
        addButton.frame = CGRect(
            x: (tabBar.frame.width - Constants.buttonHeight) / 2,
            y:  -18,
            width: Constants.buttonHeight,
            height: Constants.buttonHeight)
        
        // Profile (Me) Button
        if let profile = tabBar.items?.last {
            profile.title = "Me"
            profile.image = UIImage(named: "tabBar-profile")
        }
        
    }
    
    @objc private func presentCapturePhoto() {
        performSegue(withIdentifier: "captureSegue", sender: nil)
    }
    
}

extension TabBarController: UITabBarControllerDelegate {
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        
        guard
            let index = tabBarController.viewControllers?.firstIndex(of: viewController)
            else { return true }
        return index != 1
        
    }
}
