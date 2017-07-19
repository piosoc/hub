//
//  UINavigationControllerExtension.swift
//  Hubguru
//
//  Created by Piotr Sochalewski on 19.07.2017.
//  Copyright © 2017 Netguru Sp. z o.o. All rights reserved.
//

import UIKit

extension UINavigationController {
    func setBackButton(title: String) {
        let backButton = UIBarButtonItem(title: title, style: .plain, target: nil, action: nil)
        topViewController?.navigationItem.backBarButtonItem = backButton
    }
}
