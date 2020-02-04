//
//  ProposalsListController.swift
//  Evolution-iOS
//
//  Created by uuttff8 on 2/4/20.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import UIKit
import Combine

class ProposalsListCoordinator: Coordinator {

    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController

    private var cancellable = Set<AnyCancellable>()

    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        // Make here init of Swift proposals
        let vc = ProposalsListViewController.instantiate(from: AppStoryboards.ProposalsList)
        navigationController.pushViewController(vc, animated: false)
        vc.coordinator = self
        
    }
    
    func changeLangTo(_ lang: LanguageSelected) {
        switch lang {
        case .Rust:
            MLApi.Rust.fetchProposals()
                .receive(on: RunLoop.main)
                .sink { (propRust) in
                    if let propRust = propRust {
                        print(propRust)
                    }
            }.store(in: &self.cancellable)
        case .Swift:
            MLApi.Swift.fetchProposals().sink { (propSwift) in
                if let propSwift = propSwift {
                    print(propSwift)
                }
            }.store(in: &self.cancellable)
        }
    }
    
    
}
