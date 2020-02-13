//
//  ProposalsController.swift
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

class ProposalsRustCoordinator: Coordinator {

    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController?
    
    init(navigationController: UINavigationController? = nil) {
        self.navigationController = navigationController
    }
    
    func start() {
        
    }
    
    func getVC() -> ProposalsRustViewController {
        let vc = ProposalsRustViewController.instantiate(from: AppStoryboards.ProposalsRust)
        vc.coordinator = self
        return vc
    }
    
    func showProposalDetail(proposal: ProposalRust) {
        let coordinator = ProposalDetailCoordinator(navigationController: navigationController,
                                                    lang: LanguageSelected.Rust,
                                                    proposalId: proposal.title ?? "")
        coordinator.start()
    }
}
