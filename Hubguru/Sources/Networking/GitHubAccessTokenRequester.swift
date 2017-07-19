//
//  GitHubAccessTokenRequester.swift
//  Hubguru
//
//  Created by Piotr Sochalewski on 19.07.2017.
//  Copyright © 2017 Netguru Sp. z o.o. All rights reserved.
//

import Foundation

struct GitHubAccessTokenClientConfiguration: ApiClientConfiguration {
    let baseURL = URL(string: "https://github.com")!
    let sessionConfiguration = URLSessionConfiguration.default
}

class GitHubAccessTokenRequester: ApiRequester {
    let configuration: ApiClientConfiguration = GitHubAccessTokenClientConfiguration()
    let session: URLSession!
    let oauthToken: String?
    
    init() {
        session = URLSession(configuration: configuration.sessionConfiguration)
        oauthToken = nil
    }
}
