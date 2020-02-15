//
//  SettingsCoordinator.swift
//  Evolution-iOS
//
//  Created by uuttff8 on 2/15/20.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import UIKit

class SettingsCoordinator: Coordinator {
    var navigationController: UINavigationController?
    var childCoordinators = [Coordinator]()
    
    init(navigationController: UINavigationController?) {
        self.navigationController = navigationController
    }
    
    func start() {
        let vc = SettingsViewController.instantiate(from: AppStoryboards.Settings)
        vc.coordinator = self
        navigationController?.pushViewController(vc, animated: true)
    }
}
