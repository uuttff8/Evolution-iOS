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

    private var cancellable = Set<AnyCancellable>()
    
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
    
    func getProposalsList(completion: @escaping (([ProposalSwift]) -> ())) {
        MLApi.Swift.fetchProposals()
            .receive(on: RunLoop.main)
            .sink { (propSwift) in
            guard let propSwift = propSwift else { return }
            completion(propSwift)
        }.store(in: &self.cancellable)
    }
}

