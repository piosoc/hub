//
//  AppCoordinator.swift
//  Hubguru
//
//  Created by Piotr Sochalewski on 18.07.2017.
//  Copyright © 2017 Netguru Sp. z o.o. All rights reserved.
//

import UIKit
import RxSwift

final class AppCoordinator: Coordinator {
    
    fileprivate let disposeBag = DisposeBag()
    fileprivate var accessToken: String?
    
    fileprivate enum Constants {
        static let loginURL = URL(string: "https://github.com/login/oauth/authorize?client_id=5648525eb1547d2c38ce&redirect_uri=https://netguru.co/hubguru")!
        static let back = NSLocalizedString("Back", comment: "Back")
    }
}

extension AppCoordinator: LoginViewControllerDelegate {
    func didTapSignInButton() {
        navigationController.setBackButton(title: Constants.back)
        let loginWebViewController = LoginWebViewController(url: Constants.loginURL, delegate: self)
        navigationController.pushViewController(loginWebViewController, animated: true)
    }
}

extension AppCoordinator: LoginWebViewControllerDelegate {
    func didSignIn(code: String) {
        let accessTokenRequester = GitHubAccessTokenRequester()
        let query = Request.accessToken(code).query
        
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
        accessTokenRequester.jsonResponse(for: query)
            .observeOn(MainScheduler.instance)
            .map { $0.json.dictionaryObject?["access_token"] as? String }
            .do(onNext: { [weak self] accessToken in
                self?.accessToken = accessToken
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
            })
            .subscribe(onNext: { [weak self] _ in
                self?.navigationController.popToRootViewController(animated: false)
                self?.navigationController.setBackButton(title: "Logout")
                let languagesViewController = LanguagesCollectionViewController(delegate: self)
                self?.navigationController.pushViewController(languagesViewController, animated: true)
            })
            .disposed(by: disposeBag)
    }
}

extension AppCoordinator: LanguagesCollectionViewControllerDelegate {
    func didSelect(language: Language) {
        navigationController.setBackButton(title: Constants.back)
        let apiRequester = GitHubApiRequester(oauthToken: accessToken)
        let repositoriesViewModel = RepositoriesViewModel(apiRequester: apiRequester, delegate: self, language: language, sortType: .stars)
        let repositoriesViewController = RepositoriesViewController(viewModel: repositoriesViewModel)
        navigationController.pushViewController(repositoriesViewController, animated: true)
    }
}

extension AppCoordinator: RepositoriesViewControllerDelegate {
    func didTapSortButton() {
        navigationController.setBackButton(title: Constants.back)
        let sortingViewControler = SortingViewController()
        sortingViewControler.delegate = navigationController.viewControllers.flatMap({ $0 as? RepositoriesViewController }).first
        navigationController.pushViewController(sortingViewControler, animated: true)
    }
}
