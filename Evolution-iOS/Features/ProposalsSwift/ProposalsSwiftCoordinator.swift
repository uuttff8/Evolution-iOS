//
//  ProposalsSwiftCoordinator.swift
//  Evolution-iOS
//
//  Created by uuttff8 on 2/6/20.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import UIKit
import Combine

class ProposalsSwiftCoordinator: Coordinator {
    var navigationController: UINavigationController?
    var childCoordinators = [Coordinator]()

    
    init(navigationController: UINavigationController? = nil) {
        self.navigationController = navigationController
    }
    
    func start() {
        
    }
    
    func getVC() -> ProposalsSwiftViewController {
        let vc = ProposalsSwiftViewController.instantiate(from: AppStoryboards.ProposalsSwift)
        vc.coordinator = self
        return vc
    }
}
