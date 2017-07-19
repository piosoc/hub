//
//  Request.swift
//  Hubguru
//
//  Created by Piotr Sochalewski on 19.07.2017.
//  Copyright © 2017 Netguru Sp. z o.o. All rights reserved.
//

import Foundation

struct Endpoint: Query {
    let type: RequestType
    let path: String
    let parameters: [String : String]
}

enum Request {
    case accessToken(String)
    case repos(Language, SortType)
    case readme(Repository)
    
    private var path: String {
        switch self {
        case .accessToken:
            return "login/oauth/access_token"
        case .repos:
            return "search/repositories"
        case .readme(let repository):
            return "repos/\(repository.owner)/\(repository.name)/readme"
        }
    }
    
    private var parameters: [String : String] {
        switch self {
        case .accessToken(let code):
            return [
                "client_id" : "5648525eb1547d2c38ce",
                "client_secret" : "6c88fff8fcccd2d8ebcdc1edcf22551219de6e3c",
                "code" : code
            ]
        case .repos(let language, let sort):
            return [
                "q" : "language:\(language.rawValue)",
                "sort" : sort.rawValue
            ]
        case .readme:
            return [:]
        }
    }
    
    private var type: RequestType {
        switch self {
        case .accessToken:
            return .post
        default:
            return .get
        }
    }
    
    var query: Query {
        return Endpoint(type: type, path: path, parameters: parameters)
    }
}
