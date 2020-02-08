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
    var navigationController: UINavigationController?    
    var childCoordinators = [Coordinator]()
    
    init(navigationController: UINavigationController?) {
        self.navigationController = navigationController
    }
    
    func start() {
        let child = ProposalsContainerCoordinator(navigationController: navigationController!)
        childCoordinators.append(child)
        child.start()
    }
}
