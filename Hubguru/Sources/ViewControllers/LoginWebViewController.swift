//
//  LoginWebViewController.swift
//  Hubguru
//
//  Created by Piotr Sochalewski on 18.07.2017.
//  Copyright © 2017 Netguru Sp. z o.o. All rights reserved.
//

import UIKit
import EasyPeasy

protocol LoginWebViewControllerDelegate: class {
    func didSignIn(code: String)
}

final class LoginWebViewController: UIViewController {
    
    fileprivate enum Constants {
        static let secretCodeStartsWithPhrase = "code="
    }
    
    weak var delegate: LoginWebViewControllerDelegate?
    private(set) var url: URL!
    private let webView = UIWebView()
    
    convenience init(url: URL, delegate: LoginWebViewControllerDelegate?) {
        self.init()
        self.url = url
        self.delegate = delegate
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    private func setup() {
        view.addSubview(webView)
        webView <- Edges()
        webView.delegate = self
        webView.loadRequest(URLRequest(url: url))
    }
}

extension LoginWebViewController: UIWebViewDelegate {
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        guard let urlString = request.url?.absoluteString else { return true }
        
        if let range = urlString.range(of: Constants.secretCodeStartsWithPhrase) {
            let index = range.upperBound
            let code = urlString.substring(from: index)
            dismiss(animated: true, completion: nil)
            delegate?.didSignIn(code: code)
            
            return false
        }
        
        return true
    }
}
