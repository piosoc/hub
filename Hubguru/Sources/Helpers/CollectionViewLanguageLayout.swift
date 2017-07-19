//
//  CollectionViewLanguageLayout.swift
//  Hubguru
//
//  Created by Piotr Sochalewski on 18.07.2017.
//  Copyright © 2017 Netguru Sp. z o.o. All rights reserved.
//

import UIKit

final class CollectionViewLanguageLayout: UICollectionViewFlowLayout {
    
    fileprivate enum Constants {
        static let widthToHeightRatio: CGFloat = 1.88
    }

    override init() {
        super.init()
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    fileprivate func setup() {
        minimumLineSpacing = 0.0
        minimumInteritemSpacing = 0.0
        let width = UIScreen.main.bounds.width / 2.0
        itemSize = CGSize(width: width, height: width / Constants.widthToHeightRatio)
    }
}
