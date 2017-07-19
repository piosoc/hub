//
//  LoginViewController.swift
//  Hubguru
//
//  Copyright © 2016 Netguru Sp. z o.o. All rights reserved.
//

import UIKit
import RxSwift

protocol LoginViewControllerDelegate: class {
    func didTapSignInButton()
}

final class LoginViewController: UIViewController {
    
    weak var delegate: LoginViewControllerDelegate?
    
    fileprivate var loginView: LoginView {
        return view as! LoginView
    }
    private let disposeBag = DisposeBag()

    override func loadView() {
        view = LoginView(frame: CGRect.zero)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navigationItem.backBarButtonItem = nil
    }
    
    private func setup() {
        title = Bundle.main.object(forInfoDictionaryKey: "CFBundleName") as? String

        loginView.signInButton.rx.tap
            .subscribe(onNext: { [weak delegate = self.delegate] _ in
                delegate?.didTapSignInButton()
            })
            .disposed(by: disposeBag)
    }
}
