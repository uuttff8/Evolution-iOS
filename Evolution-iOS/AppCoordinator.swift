//
//  AppCoordinator.swift
//  Evolution-iOS
//
//  Created by uuttff8 on 2/4/20.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import UIKit
import Combine

class AppCoordinator: Coordinator {
    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let child = ProposalsListCoordinator(navigationController: navigationController)
        childCoordinators.append(child)
        child.start()
    }
}
