//
//  SceneDelegate.swift
//  AnyDoc
//
//  Created by Ahmed Fathi on 7/7/20.
//  Copyright © 2020 Ahmed Fathi. All rights reserved.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        let window = UIWindow(windowScene: windowScene)
        
        if UserDefaults.didCompleteOnboarding {
            launchTabBar(window)
        } else {
            UserDefaults.didCompleteOnboarding = true
            launchOnboarding(window)
        }
        
        self.window = window
        
    }
    
    private func launchOnboarding(_ window: UIWindow) {
        let storyboard = UIStoryboard(name: "Onboarding", bundle: nil)
        let viewController = storyboard.instantiateInitialViewController()
        window.rootViewController = viewController
        window.makeKeyAndVisible()
    }
    
    private func launchTabBar(_ window: UIWindow) {
        let storyboard = UIStoryboard(name: "TabBar", bundle: nil)
        let viewController = storyboard.instantiateInitialViewController()
        window.rootViewController = viewController
        window.makeKeyAndVisible()
    }

}

