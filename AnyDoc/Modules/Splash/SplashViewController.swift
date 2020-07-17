//
//  SplashViewController.swift
//  AnyDoc
//
//  Created by Ahmed Fathi on 7/18/20.
//  Copyright © 2020 Ahmed Fathi. All rights reserved.
//

import UIKit

class SplashViewController: UIViewController {
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.presentNextScreen()
        }
    }

    
    private func presentNextScreen() {
        if UserDefaults.didCompleteOnboarding {
            presentTabBar()
        } else {
            presentOnboarding()
        }
    }
    
    private func presentTabBar() {
        let storyboard = UIStoryboard(name: "TabBar", bundle: nil)
        let viewController = storyboard.instantiateInitialViewController()!
        viewController.modalTransitionStyle = .crossDissolve
        viewController.modalPresentationStyle = .fullScreen
        present(viewController, animated: true)
    }
    
    private func presentOnboarding() {
        let storyboard = UIStoryboard(name: "Onboarding", bundle: nil)
        let viewController = storyboard.instantiateInitialViewController()!
        viewController.modalTransitionStyle = .crossDissolve
        viewController.modalPresentationStyle = .fullScreen
        present(viewController, animated: true)
    }
    
}
