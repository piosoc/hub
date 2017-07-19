//
//  GitHubApiRequester.swift
//  Hubguru
//
//  Copyright © 2016 Netguru Sp. z o.o. All rights reserved.
//

import Foundation
import RxSwift

struct GitHubApiClientConfiguration: ApiClientConfiguration {
    let baseURL = URL(string: "https://api.github.com")!
    let sessionConfiguration = URLSessionConfiguration.default
}

class GitHubApiRequester: ApiRequester {
    let configuration: ApiClientConfiguration = GitHubApiClientConfiguration()
    let session: URLSession!
    let oauthToken: String?
    
    private let disposeBag = DisposeBag()
    
    init(oauthToken: String? = nil) {
        self.oauthToken = oauthToken
        session = URLSession(configuration: configuration.sessionConfiguration)
    }
}
