//
//  AboutOpenSourceNavController.swift
//  Evolution-iOS
//
//  Created by uuttff8 on 2/17/20.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import UIKit

class AboutOpenSourceNavigationController: BaseNavigationController, Storyboarded {
    weak var coordinator: AboutOpenSourceNavigationCoordinator?
    
    override func viewDidLoad() {
        coordinator?.showAbout()
    }
}

class AboutOpenSourceNavigationCoordinator: Coordinator {
    var navigationController: UINavigationController?
    var childCoordinators = [Coordinator]()
        
    init(navigationController: UINavigationController?) {
        self.navigationController = navigationController
    }
    
    func start() {
        let navigation = AboutOpenSourceNavigationController.instantiate(from: AppStoryboards.AboutOpenSource)
        navigation.coordinator = self
        navigationController?.present(navigation, animated: true, completion: nil)
    }
    
    func showAbout() {
        let coordinator = AboutOpenSourceCoordinator(navigationController: navigationController)
        childCoordinators.append(coordinator)
        coordinator.start()
    }
}
