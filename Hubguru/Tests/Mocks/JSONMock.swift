//
//  JSONMock.swift
//  Hubguru
//
//  Created by Piotr Sochalewski on 19.07.2017.
//  Copyright © 2017 Netguru Sp. z o.o. All rights reserved.
//

import Foundation
import SwiftyJSON

final class JSONMock {
    static func repositoryMock() -> JSON {
        let path = Bundle(for: JSONMock.self).url(forResource: "repository", withExtension: "json")
        let jsonData = try! Data(contentsOf: path!)
    
        return JSON(data: jsonData)
    }
}
