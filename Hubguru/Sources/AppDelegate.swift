//
// ApplicationDelegate.swift
//
// Copyright © 2016 Netguru Sp. z o.o. All rights reserved.
//

import UIKit

/// Entry point for the application.
@UIApplicationMain final class AppDelegate: UIResponder, UIApplicationDelegate {

	/// Application's key window. Optional because of protocol requirements.
	@nonobjc lazy var window: UIWindow? = UIWindow(frame: UIScreen.main.bounds)
    
    private(set) var coordinator: AppCoordinator!

	/// - SeeAlso: UIApplicationDelegate.application(_:willFinishLaunchingWithOptions:)
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {

		guard let window = window else {
			fatalError("There is no way `window` can be `nil` at this point")
		}
        
        let loginViewController = LoginViewController()
        let navigationController = MainNavigationController(rootViewController: loginViewController)
        coordinator = AppCoordinator(navigationController: navigationController)
        loginViewController.delegate = coordinator
		
		window.rootViewController = navigationController
		window.makeKeyAndVisible()

		return true
	}
}
