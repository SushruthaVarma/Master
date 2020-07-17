//
//  OnboardingItem.swift
//  AnyDoc
//
//  Created by Ahmed Fathi on 7/16/20.
//  Copyright © 2020 Ahmed Fathi. All rights reserved.
//

import Foundation

struct OnboardingItem {
    
    var image: String
    var title: String
    var body: String
    
}


var allOnboardingItems = [
    OnboardingItem(
        image: "onboarding-1",
        title: "Scan Recipts, Notices & Documents\ninto Images and PDF",
        body: "Protecting your privacy with our end to end security"),
    
    OnboardingItem(
        image: "onboarding-2",
        title: "Aim and Shoot\nAnything\nAnywhere",
        body: "Save to cloud and share with your network"),
    
    OnboardingItem(
        image: "onboarding-3",
        title: "Store your personal docs like Passport, Aadhar etc securely",
        body: "Save single or multiple pages as a collection")
]
