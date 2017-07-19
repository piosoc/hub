//
//  UILabelExtension.swift
//  Hubguru
//
//  Created by Piotr Sochalewski on 19.07.2017.
//  Copyright © 2017 Netguru Sp. z o.o. All rights reserved.
//

import UIKit

extension UILabel {
    static func regularFontLabel() -> UILabel {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14.0, weight: UIFontWeightRegular)
        label.textColor = .black
        
        return label
    }
}
