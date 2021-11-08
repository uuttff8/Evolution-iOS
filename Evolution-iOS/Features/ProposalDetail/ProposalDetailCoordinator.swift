//
//  ProposalDetailCoordinator.swift
//  Evolution-iOS
//
//  Created by uuttff8 on 2/12/20.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import UIKit

class ProposalDetailCoordinator: Coordinator {
    
    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController?
    
    var language: LanguageType
    var proposalId: String
    
    init(navigationController: UINavigationController? = nil, language: LanguageType, proposalId: String) {
        self.navigationController = navigationController
        self.language = language
        self.proposalId = proposalId
    }
    
    func start() {
        let vc = ProposalDetailViewController.instantiate(from: AppStoryboards.ProposalDetail)
        vc.coordinator = self
        vc.currentLanguage = language
        vc.proposalId = proposalId
        navigationController?.pushViewController(vc, animated: true)
    }
}
