//
//  ProposalsContainerViewController.swift
//  Evolution-iOS
//
//  Created by uuttff8 on 2/6/20.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import UIKit

class ProposalsContainerViewController: UIViewController, Storyboarded, Containered {
    
    @IBOutlet weak var navDropDown: NavDropDown! {
        didSet {
            self.navDropDown.showAlertCompletion = { [weak self] (alert: UIAlertController) in
                guard let self = self else { return }
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    weak var coordinator: ProposalsContainerCoordinator?
    
    // MARK: - proposals view controllers
    private lazy var proposalsRustVC: ProposalsRustViewController = {
        let coordinatorRust = ProposalsRustCoordinator(navigationController: self.navigationController)
        coordinator?.childCoordinators.append(coordinatorRust)
        coordinatorRust.start()
        let vc = coordinatorRust.getVC()
        // Add View Controller as Child View Controller
        self.add(asChildViewController: vc)

        return vc
    }()

    // default view controller to be inited
    private lazy var proposalsSwiftVC: ProposalsSwiftViewController = {
        let coordinatorSwift = ProposalsSwiftCoordinator(navigationController: self.navigationController)
        coordinator?.childCoordinators.append(coordinatorSwift)
        coordinatorSwift.start()
        let vc = coordinatorSwift.getVC()
        // Add View Controller as Child View Controller
        self.add(asChildViewController: vc)
        return vc
    }()
    
    private lazy var noConnectionVC: NoConnectionViewController = {
        let vc = NoConnectionViewController.instantiate(from: AppStoryboards.NoConnection)
        return vc
    }()
    
    // MARK: - Lifecycle -
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let _ = coordinator else { return }
        
        // default
        self.add(asChildViewController: self.proposalsSwiftVC)
        
        languageChangeSubscribe()
        
    }
    
    // MARK: - Private -
    private func languageChangeSubscribe() {
        self.navDropDown.didChangeLanguageCompletion = { [weak self] (selectedLang: LanguageSelected) in
            guard let self = self else { return }
            
            switch selectedLang {
            case .Rust:
                self.remove(asChildViewController: self.proposalsSwiftVC)
                self.add(asChildViewController: self.proposalsRustVC)
            case .Swift:
                self.remove(asChildViewController: self.proposalsRustVC)
                self.add(asChildViewController: self.proposalsSwiftVC)
            }
        }
    }
}
