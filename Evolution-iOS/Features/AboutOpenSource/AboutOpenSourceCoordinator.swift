//
//  AboutOpenSourceCoordinator.swift
//  Evolution-iOS
//
//  Created by uuttff8 on 2/17/20.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import UIKit

class AboutOpenSourceCoordinator: Coordinator {
    var navigationController: UINavigationController?
    var childCoordinators = [Coordinator]()

    var modalNavController: UINavigationController?
    
    init(navigationController: UINavigationController?) {
        self.navigationController = navigationController
    }
    
    func start() {
        let vc = AboutOpenSourceViewController.instantiate(from: AppStoryboards.AboutOpenSource)

        modalNavController = BaseNavigationController(rootViewController: vc)
        
        vc.coordinator = self
        navigationController?.present(modalNavController ?? BaseNavigationController(), animated: true, completion: nil)
    }
    
    func showAboutDetail(aboutData: Section) {
        let coordinator = AboutDetailOpenSourceCoordinator(navigationController: modalNavController, aboutData: aboutData)
        childCoordinators.append(coordinator)
        coordinator.start()
    }
}
