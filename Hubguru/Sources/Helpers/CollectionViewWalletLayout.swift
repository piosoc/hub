//
// CollectionViewWalletLayout.swift
//
// Copyright © 2017 Netguru Sp. z o.o. All rights reserved.
//

import UIKit

/// A wallet collection view layout.
public final class CollectionViewWalletLayout: UICollectionViewFlowLayout {

    fileprivate var attributeList = [CollectionViewWalletLayoutAttributes]()

    public var featuredIndexPath: IndexPath? {
        didSet {
            collectionView?.performBatchUpdates({
                self.invalidateLayout()
            }, completion: nil)
        }
    }
    
    public var bottomShowCount = 5 {
        didSet {
            collectionView?.performBatchUpdates({
                self.collectionView?.reloadData()
            }, completion: nil)
        }
    }
    
    public var titleHeight: CGFloat = 50.0 {
        didSet {
            collectionView?.performBatchUpdates({
                self.invalidateLayout()
            }, completion: nil)
        }
    }
    
    public var cardHeight: CGFloat = 300.0 {
        didSet {
            var size = cellSize
            size.height = cardHeight
            cellSize = size
            collectionView?.performBatchUpdates({
                self.invalidateLayout()
            }, completion: nil)
        }
    }
    
    lazy var cellSize: CGSize = {
        let width = self.collectionView!.bounds.width
        let height = self.collectionView!.bounds.height * 0.85
        
        return CGSize(width: width, height: height)
    }()
    
    override public var collectionViewContentSize: CGSize {
        set {}
        get {
            let sections = collectionView!.numberOfSections
            let total = (0..<sections).reduce(0) { (total, current) -> Int in
                return total + self.collectionView!.numberOfItems(inSection: current)
            }
            let contentHeight = titleHeight*CGFloat(total-1) + cellSize.height
            return CGSize(width: cellSize.width, height: contentHeight )
        }
    }
    
    func updateCellSize() {
        cellSize.width = collectionView!.frame.width
        cellSize.height = cardHeight * 0.85
    }
   
    override public func prepare() {
        super.prepare()
        let update = collectionView!.calculate.isNeedUpdate()
        
        if let featured = featuredIndexPath, !update {
            attributeList.forEach {
                let mode: CollectionViewWalletLayoutAttributes.Mode = ($0.indexPath == featured) ? .featured : .discrete
                set(mode: mode, for: $0)
            }
        } else {
            if !update && collectionView!.calculate.totalCount == attributeList.count {
                attributeList.forEach {
                    set(mode: .normal, for: $0)
                }
                return
            }
            let list = generateAttributeList()
            if list.isNotEmpty {
                attributeList.removeAll()
                attributeList += list
            }
        }
    }
    
    fileprivate func generateAttributeList() -> [CollectionViewWalletLayoutAttributes] {
        var attributes = [CollectionViewWalletLayoutAttributes]()
        let offsetY = collectionView!.contentOffset.y > 0 ? collectionView!.contentOffset.y : 0.0
        let startIdx = abs(Int(offsetY / titleHeight))
        let sections = collectionView!.numberOfSections
        var itemsIdx = 0
        
        for section in 0..<sections {
            let count = collectionView!.numberOfItems(inSection: section)
            if itemsIdx + count-1 < startIdx {
                itemsIdx += count
                continue
            }
            for item in 0..<count {
                if itemsIdx >= startIdx {
                    let indexPath = IndexPath(item: item, section: section)
                    let attribute = CollectionViewWalletLayoutAttributes(forCellWith: indexPath)
                    attribute.zIndex = itemsIdx
                    set(mode: .normal, for: attribute)
                    attributes.append(attribute)
                }
                itemsIdx += 1
            }
        }
        return attributes
    }
    
    fileprivate func set(mode: CollectionViewWalletLayoutAttributes.Mode, for attribute: CollectionViewWalletLayoutAttributes) {
        attribute.mode = mode
        
        switch mode {
        case .featured:
            attribute.frame = CGRect(x: 0.0, y: collectionView!.contentOffset.y, width: cellSize.width, height: cellSize.height)
            
        case .normal:
            let index = attribute.zIndex
            var currentFrame = CGRect.zero
            let ratio = 1.0 - (titleHeight * CGFloat(attributeList.count) / collectionView!.frame.height)
            currentFrame = CGRect(x: 0.0, y: (titleHeight * CGFloat(index)) + (collectionView!.frame.height * ratio * 0.99), width: cellSize.width, height: cellSize.height)
            attribute.frame = currentFrame
        
        case .discrete:
            let baseHeight = collectionView!.contentOffset.y + collectionView!.bounds.height * 0.9
            let bottomH = cellSize.height * 0.1
            let discreteAttributes = attributeList.filter({ $0.mode == .discrete })
            guard discreteAttributes.contains(attribute) else { return }
            let margin: CGFloat = bottomH / CGFloat(discreteAttributes.count)
            let yPos = CGFloat(discreteAttributes.index(of: attribute)!) * margin + baseHeight
            attribute.frame = CGRect(x: 0.0, y: yPos, width: cellSize.width, height: cellSize.height)
        }
    }
    
    override public func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        guard let first = attributeList.first(where: { $0.indexPath == indexPath }) else {
            let attr = CollectionViewWalletLayoutAttributes(forCellWith: indexPath)
            return attr
        }
        return first
    }
    
    override public func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var reset = rect
        reset.origin.y = collectionView!.contentOffset.y
        
        return attributeList.filter {
            var fix = $0.frame
            fix.size.height = titleHeight
            return fix.intersects(reset)
        }
    }
    
    override public func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
}
