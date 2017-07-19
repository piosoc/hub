//
//  RepositoryParserSpec.swift
//  Hubguru
//
//  Created by Piotr Sochalewski on 19.07.2017.
//  Copyright © 2017 Netguru Sp. z o.o. All rights reserved.
//

import XCTest
import SwiftyJSON

@testable import Hubguru

final class RepositoryParserSpec: XCTestCase {

    var sut: Repository!
    
    override func setUp() {
        super.setUp()
        let json = JSONMock.repositoryMock()
        sut = Repository(json: json)
    }
    
    func testParsingRepository() {
        XCTAssert(sut.name == "Alamofire")
        XCTAssert(sut.id == 22458259)
        XCTAssert(sut.owner == sut.name)
    }
}
