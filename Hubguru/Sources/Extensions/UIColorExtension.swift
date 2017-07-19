//
//  UIColorExtension.swift
//  Hubguru
//
//  Copyright © 2016 Netguru Sp. z o.o. All rights reserved.
//

import UIKit

/// Think of it as of hexadecimal value, not "unsigned integer of 32bit size"
/// Use hex of size 24 e.g. 0xFFFFFF
typealias HexColor = UInt32

internal extension UIColor {
    
    /// Convenience init for creating color out of hexadecimal value
    ///
    /// - parameter hex:   hexadecimal color value
    /// - parameter alpha: alpha double value
    ///
    /// - returns: Initialized UIColor
    internal convenience init(hex: HexColor, alpha: Double = 1.0) {
        self.init(
            red: CGFloat(hex >> 16 & 0xff) / 0xff,
            green: CGFloat(hex >> 8 & 0xff) / 0xff,
            blue: CGFloat(hex >> 0 & 0xff) / 0xff,
            alpha: CGFloat(alpha)
        )
    }
    
    class var navigationBarGray: UIColor {
        return UIColor(red: 0.19, green: 0.19, blue: 0.19, alpha: 1.0)
    }
    
    class var swift: UIColor {
        return UIColor(red: 0.58, green: 0.46, blue: 0.8, alpha: 1.0)
    }
    
    class var ruby: UIColor {
        return UIColor(red: 0.45, green: 0.75, blue: 0.95, alpha: 1.0)
    }
    
    class var javaScript: UIColor {
        return UIColor(red: 0.46, green: 0.78, blue: 0.52, alpha: 1.0)
    }
    
    class var python: UIColor {
        return UIColor(red: 1.0, green: 0.88, blue: 0.52, alpha: 1.0)
    }
    
    class var cPlusPlus: UIColor {
        return UIColor(red: 0.94, green: 0.51, blue: 0.51, alpha: 1.0)
    }
}
