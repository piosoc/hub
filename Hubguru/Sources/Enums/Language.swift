//
//  Language.swift
//  Hubguru
//
//  Created by Piotr Sochalewski on 18.07.2017.
//  Copyright © 2017 Netguru Sp. z o.o. All rights reserved.
//

import UIKit

enum Language: String {
    case swift = "Swift"
    case ruby = "Ruby"
    case javaScript = "JavaScript"
    case python = "Python"
    case cPlusPlus = "C++"
    
    static var allValues: [Language] = [.swift, .ruby, .javaScript, .python, .cPlusPlus]
    
    var color: UIColor {
        switch self {
        case .swift: return .swift
        case .ruby: return .ruby
        case .javaScript: return .javaScript
        case .python: return .python
        case .cPlusPlus: return .cPlusPlus
        }
    }
}
