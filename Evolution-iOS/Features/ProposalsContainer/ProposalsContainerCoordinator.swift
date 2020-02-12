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
    
    var cancellable = Set<AnyCancellable>()
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let vc = ProposalsContainerViewController.instantiate(from: AppStoryboards.ProposalsContainer)
        navigationController?.pushViewController(vc, animated: false)
        vc.coordinator = self
    }
    
    
}
