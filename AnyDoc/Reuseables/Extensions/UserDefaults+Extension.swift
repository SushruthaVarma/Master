//
//  UserDefaults+Extension.swift
//  AnyDoc
//
//  Created by Ahmed Fathi on 7/16/20.
//  Copyright © 2020 Ahmed Fathi. All rights reserved.
//

import Foundation

extension UserDefaults {
    
    static var didCompleteOnboarding: Bool {
        get {
            UserDefaults.standard.bool(forKey: "didCompleteOnboarding")
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "didCompleteOnboarding")
        }
    }
}
