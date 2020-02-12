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
    
    var lang: LanguageSelected
    var proposalLink: String
    
    init(navigationController: UINavigationController? = nil, lang: LanguageSelected, link: String) {
        self.navigationController = navigationController
        self.lang = lang
        self.proposalLink = link
    }
    
    func start() {
        let vc = ProposalDetailViewController.instantiate(from: AppStoryboards.ProposalDetail)
        vc.coordinator = self
        vc.currentLanguage = self.lang
        vc.proposalLink = self.proposalLink
        navigationController?.pushViewController(vc, animated: true)
    }
}
