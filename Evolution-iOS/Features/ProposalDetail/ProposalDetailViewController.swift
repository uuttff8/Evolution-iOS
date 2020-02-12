//
//  ProposalDetailViewController.swift
//  Evolution-iOS
//
//  Created by uuttff8 on 2/12/20.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import UIKit

class ProposalDetailViewController: NetViewController, Storyboarded {
    weak var coordinator: ProposalDetailCoordinator?
    
    var currentLanguage: LanguageSelected?
    var proposalLink: String?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print(proposalLink)
    }

}
