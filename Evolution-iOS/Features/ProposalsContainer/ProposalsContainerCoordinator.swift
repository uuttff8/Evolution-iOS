//
//  ProposalsContainerController.swift
//  Evolution-iOS
//
//  Created by uuttff8 on 2/6/20.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import UIKit
import Combine

class ProposalsContainerCoordinator: Coordinator {
    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController?
        
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let vc = ProposalsContainerViewController.instantiate(from: .ProposalsContainer)
        navigationController?.pushViewController(vc, animated: false)
        vc.coordinator = self
    }
    
    func goToSettingsScreen() {
        let coordinator = SettingsCoordinator(navigationController: navigationController)
        childCoordinators.append(coordinator)
        coordinator.start()
    }
}
