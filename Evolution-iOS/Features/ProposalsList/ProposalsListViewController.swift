//
//  ProposalsListViewController.swift
//  Evolution-iOS
//
//  Created by uuttff8 on 1/26/20.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import UIKit

class ProposalsListViewController: BaseViewController, Storyboarded {
    
    @IBOutlet weak var navDropDown: NavDropDown! {
        didSet {
            self.navDropDown.vc = self
        }
    }
    
    override func viewDidLoad() {
        self.navDropDown.didChangeLanguageCompletion = { (lang: LanguageSelected) in
            print(lang)
        }
    }
}
