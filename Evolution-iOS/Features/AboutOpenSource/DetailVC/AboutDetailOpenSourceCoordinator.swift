//
//  AboutDetailOpenSourceCoordinator.swift
//  Evolution-iOS
//
//  Created by uuttff8 on 2/17/20.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import UIKit

class AboutDetailOpenSourceCoordinator: Coordinator {
    var navigationController: UINavigationController?
    var childCoordinators = [Coordinator]()
        
    init(navigationController: UINavigationController?) {
        self.navigationController = navigationController
    }
    
    func start() {
        let vc = AboutDetailOpenSourceViewController.instantiate(from: AppStoryboards.AboutOpenSource)
        vc.coordinator = self
        navigationController?.pushViewController(vc, animated: true)
    }
}
