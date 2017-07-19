//
//  MainNavigationController.swift
//  Hubguru
//
//  Created by Piotr Sochalewski on 18.07.2017.
//  Copyright © 2017 Netguru Sp. z o.o. All rights reserved.
//

import UIKit

final class MainNavigationController: UINavigationController {
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    private func setup() {
        navigationBar.isTranslucent = false
        navigationBar.tintColor = .white
        navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : UIColor.white]
        navigationBar.barTintColor = .navigationBarGray
    }
}
