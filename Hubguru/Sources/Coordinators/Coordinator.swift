//
//  Coordinator.swift
//  Hubguru
//
//  Created by Piotr Sochalewski on 18.07.2017.
//  Copyright © 2017 Netguru Sp. z o.o. All rights reserved.
//

import UIKit

class Coordinator {
    
    var childCoordinators = [Coordinator]()
    weak var navigationController: UINavigationController!
    
    required init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
}
