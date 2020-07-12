//
//  CaptureTypeLayout.swift
//  AnyDoc
//
//  Created by Ahmed Fathi on 7/12/20.
//  Copyright © 2020 Ahmed Fathi. All rights reserved.
//

import UIKit

class CaptureTypeLayout: UICollectionViewLayout {
    
    // MARK: Constants
    private let interitemSpace: CGFloat = 4
    private let scaleFactor: CGFloat = 0.3
    
    // MARK: Book keeping
    private var itemCount = 0
    private var itemSize = CGSize.zero
    private var contentInsets = UIEdgeInsets.zero
    private var itemWidth: CGFloat {
        itemSize.width
    }
    private var itemAndSpaceWidth: CGFloat {
        itemWidth + interitemSpace
    }
    private var contentWidth: CGFloat {
        (CGFloat(itemCount) * itemWidth)
            + (CGFloat(itemCount - 1) * interitemSpace)
    }
    
    // Cached layout attributes
    private var layoutAttributes: [UICollectionViewLayoutAttributes] = []
    
    // ContentSize
    override var collectionViewContentSize: CGSize {
        guard let cv = collectionView else { return .zero }
        return CGSize(width: contentWidth, height: cv.bounds.height)
    }
    
    // MARK: - Prepare
    
    override func prepare() {
        super.prepare()

        guard let cv = collectionView else { return }
        
        cv.decelerationRate = .fast
        contentInsets = UIEdgeInsets(top: 8, left: cv.frame.width / 2, bottom: 0, right: cv.frame.width / 2)
        cv.contentInset = contentInsets
        itemCount = cv.numberOfItems(inSection: 0)

        let width: CGFloat = 80
        let height = cv.bounds.height - contentInsets.top
        itemSize = CGSize(width: width, height: height)


        // Pre-variables
        layoutAttributes = []
        var currentX: CGFloat = 0
        
        // Calculating the attributes for all the items.
        // For large collection views more a thouthand item
        // Consider splitting these calculations into chunks
        for item in 0..<itemCount {
            
            // Create attributes for each item
            let indexPath = IndexPath(item: item, section: 0)
            let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)

            // Set attributes size
            attributes.size = itemSize

            // Set attributes center
            let xCenter = currentX + (itemWidth / 2.0)
            let yCenter = cv.bounds.midY + contentInsets.top
            attributes.center = CGPoint(x: xCenter, y: yCenter)

            // Append to cache
            layoutAttributes.append(attributes)

            // Shift current x with item width and interitem spacing
            currentX += itemAndSpaceWidth
        }
        
    }
    
    // MARK: - Layout Attributes
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        
        guard let cv = collectionView else { return nil }
        
        let visibleRect = CGRect(origin: cv.contentOffset, size: cv.bounds.size)
        for attributes in layoutAttributes where visibleRect.intersects(attributes.frame) {
            attributes.transform = getTransform(for: attributes)
        }
        
        return layoutAttributes.filter { rect.intersects($0.frame) }
        
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        layoutAttributes.filter { $0.indexPath == indexPath }.first
    }
    
    // MARK: - Adjust contentOffset
    
    override func targetContentOffset(
        forProposedContentOffset proposedContentOffset: CGPoint,
        withScrollingVelocity velocity: CGPoint) -> CGPoint
    {
        guard let cv = collectionView else { return proposedContentOffset }

        // Get target item
        let targetX = proposedContentOffset.x
        let targetMidX = targetX + (cv.bounds.width / 2.0)
        let targetItem = floor(targetMidX / itemAndSpaceWidth)

        // Calculate adjusted offset
        let adjustedX = (targetItem * itemAndSpaceWidth) + (itemSize.width / 2) - contentInsets.left
        return CGPoint(x: adjustedX, y: proposedContentOffset.y)
    }
    
    // MARK: - Layout invalidations
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        true
    }
    
    override func invalidateLayout(with context: UICollectionViewLayoutInvalidationContext) {
        if context.invalidateEverything || context.invalidateDataSourceCounts {
            layoutAttributes = []
        }
        super.invalidateLayout(with: context)
    }
    
    
    // MARK: - Transform Calculator
    
    private func getTransform(for attributes: UICollectionViewLayoutAttributes) -> CGAffineTransform {
        
        let scale = getScale(for: attributes)
        let transform = CGAffineTransform.identity.scaledBy(x: scale, y: scale)

        return transform
    }
    
    private func getScale(for attributes: UICollectionViewLayoutAttributes) -> CGFloat {
        guard let cv = collectionView else { return .zero }

        let visibleRect = CGRect(origin: cv.contentOffset, size: cv.bounds.size)
        let center = CGPoint(x: visibleRect.midX, y: visibleRect.midY)

        let itemDistanceFromCenter = abs(attributes.center.x - center.x)
        let totalSpaceFromCenterToEdge = (visibleRect.maxX - visibleRect.minX) / 2.0

        // Capping the factor between 0 -> 1
        let factor = itemDistanceFromCenter / totalSpaceFromCenterToEdge
        let scale = 1 + (-1 * scaleFactor * factor)

        return scale
    }
}
