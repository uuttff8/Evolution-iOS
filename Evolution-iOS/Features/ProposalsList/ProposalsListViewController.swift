//
//  ProposalsListViewController.swift
//  Evolution-iOS
//
//  Created by uuttff8 on 1/26/20.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import UIKit
import Combine

class ProposalsListViewController: ViewController {
    
    weak var coordinator: ProposalsListCoordinator?
    
    @IBOutlet weak var navDropDown: NavDropDown! {
        didSet {
            self.navDropDown.vc = self
        }
    }
    
    override func viewDidLoad() {
        guard let coordinator = coordinator else { return }
        
        self.navDropDown.didChangeLanguageCompletion = { (selectedLang: LanguageSelected) in
            coordinator.changeLangTo(selectedLang)
        }
    }
}

extension ProposalsListViewController: Storyboarded {}
