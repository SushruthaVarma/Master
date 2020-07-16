//
//  OnboardingViewController.swift
//  AnyDoc
//
//  Created by Ahmed Fathi on 7/16/20.
//  Copyright © 2020 Ahmed Fathi. All rights reserved.
//

import UIKit


class OnboardingViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView! {
        didSet {
            collectionView.delegate = self
            collectionView.dataSource = self
            collectionView.isPagingEnabled = true
            collectionView.register(OnboardingCollectionViewCell.self)
        }
    }
    @IBOutlet weak var pageControl: UIPageControl! {
        didSet {
            pageControl.currentPage = 0
            pageControl.numberOfPages = onboardingItems.count
            pageControl.pageIndicatorTintColor = UIColor.systemGreen.withAlphaComponent(0.1)
            pageControl.currentPageIndicatorTintColor = .systemGreen
        }
    }
    @IBOutlet weak var goButton: UIButton!
    
    var onboardingItems: [OnboardingItem] = allOnboardingItems
    
    override func viewDidLoad() {
        super.viewDidLoad()
        goButton.isHidden = true
    }
    
}

extension OnboardingViewController: UICollectionViewDelegate {
    
}

extension OnboardingViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        onboardingItems.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: OnboardingCollectionViewCell.reuseId, for: indexPath)
            as? OnboardingCollectionViewCell else { fatalError() }
        cell.onboardingItem = onboardingItems[indexPath.row]
        return cell
    }
}

extension OnboardingViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        collectionView.frame.size
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        .zero
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        .zero
    }
}

extension OnboardingViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let centerX = scrollView.contentOffset.x + (scrollView.frame.width / 2)
        let center = CGPoint(x: centerX, y: scrollView.frame.height / 2)
        guard let targetIndex = collectionView.indexPathForItem(at: center) else { return }
        pageControl.currentPage = targetIndex.item
        goButton.isHidden = targetIndex.item < onboardingItems.count - 1
    }
}

