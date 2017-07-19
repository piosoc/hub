//
//  ObservableExtension.swift
//  Hubguru
//
//  Created by Piotr Sochalewski on 18.07.2017.
//  Copyright © 2017 Netguru Sp. z o.o. All rights reserved.
//

import RxSwift
import SwiftyJSON

extension Observable where Element == JSON {
    func mapRepositories(prefix: UInt = 5) -> Observable<[Repository]?> {
        return map { (json: JSON) -> [Repository]? in
            let items = json.dictionary?["items"]?.array
            let slice = items?.prefix(Int(prefix))
        
            return slice?.map { Repository(json: $0) }
        }
    }
}
