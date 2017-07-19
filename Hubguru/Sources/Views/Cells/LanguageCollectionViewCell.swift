//
//  LanguageCollectionViewCell.swift
//  Hubguru
//
//  Copyright © 2016 Netguru Sp. z o.o. All rights reserved.
//

import UIKit
import EasyPeasy

final class LanguageCollectionViewCell: UICollectionViewCell, Reusable {
    
    var language: Language? {
        didSet {
            titleLabel.text = language?.rawValue
            backgroundColor = language?.color
        }
    }
    
    private let titleLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(titleLabel)
        titleLabel <- Center()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
