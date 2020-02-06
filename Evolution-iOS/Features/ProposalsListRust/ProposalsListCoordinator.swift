//
//  ProposalsListController.swift
//  Evolution-iOS
//
//  Created by uuttff8 on 2/4/20.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import UIKit
import Combine

enum LangData {
    case RustData(ProposalsRust)
    case SwiftData([ProposalSwift])
}

class ProposalsListRustCoordinator: Coordinator {

    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController

    private var cancellable = Set<AnyCancellable>()

    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        // Make here init of Swift proposals
        let vc = ProposalsListRustViewController.instantiate(from: AppStoryboards.ProposalsListRust)
        navigationController.pushViewController(vc, animated: false)
        vc.coordinator = self
        
    }
}
