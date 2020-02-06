//
//  ProposalsListContainerViewController.swift
//  Evolution-iOS
//
//  Created by uuttff8 on 2/6/20.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import UIKit

class ProposalsListContainerViewController: UIViewController, Storyboarded, Containered {
    
    @IBOutlet weak var navDropDown: NavDropDown! {
        didSet {
            self.navDropDown.vc = self
        }
    }
    weak var coordinator: ProposalsListContainerCoordinator?
    
    private lazy var proposalsRustVC: ProposalsListRustViewController = {
        let vc = ProposalsListRustViewController.instantiate(from: AppStoryboards.ProposalsListRust)
        
        // Add View Controller as Child View Controller
        self.add(asChildViewController: vc)

        return vc
    }()

    private lazy var proposalsSwiftVC: ProposalsListSwiftViewController = {
        let vc = ProposalsListSwiftViewController.instantiate(from: AppStoryboards.ProposalsListSwift)
        
        // Add View Controller as Child View Controller
        self.add(asChildViewController: vc)

        return vc
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let coordinator = coordinator else { return }
        
        self.add(asChildViewController: self.proposalsSwiftVC)

        languageChangeSubscriber(coordinator)
    }
    
    // MARK: - Private
    fileprivate func languageChangeSubscriber(_ coordinator: ProposalsListContainerCoordinator) {
        self.navDropDown.didChangeLanguageCompletion = { [weak self] (selectedLang: LanguageSelected) in
            guard let self = self else { return }
            
            coordinator.changeLangTo(selectedLang, completion: { (langData) in
                switch langData {
                case .RustData(let propRust):
                    self.remove(asChildViewController: self.proposalsSwiftVC)
                    self.add(asChildViewController: self.proposalsRustVC)
                    self.proposalsRustVC.dataSource = propRust
                    break
                case .SwiftData(_ /*let propSwift*/):
                    self.remove(asChildViewController: self.proposalsRustVC)
                    self.add(asChildViewController: self.proposalsSwiftVC)
                }
            })
        }
    }
    
}
