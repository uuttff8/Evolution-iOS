//
//  ProposalsContainerViewController.swift
//  Evolution-iOS
//
//  Created by uuttff8 on 2/6/20.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import UIKit

class ProposalsContainerViewController: UIViewController, Storyboarded, Containered {
    
    // MARK: - Properties
    
    weak var coordinator: ProposalsContainerCoordinator?
    
    @IBOutlet weak var navDropDown: NavDropDown! {
        didSet {
            navDropDown.showAlertCompletion = { [weak self] alert in
                self?.present(alert, animated: true, completion: nil)
            }
        }
    }
            
    private lazy var proposalsRustVC: ProposalsRustViewController = {
        let coordinatorRust = ProposalsLanguagesCoordinator(navigationController: self.navigationController)
        coordinator?.childCoordinators.append(coordinatorRust)
        coordinatorRust.start()
        let vc = coordinatorRust.generateRustViewController()
        
        // Add View Controller as Child View Controller
        add(asChildViewController: vc)

        return vc
    }()

    private lazy var proposalsSwiftVC: ProposalsSwiftViewController = {
        let coordinatorSwift = ProposalsLanguagesCoordinator(navigationController: self.navigationController)
        coordinator?.childCoordinators.append(coordinatorSwift)
        coordinatorSwift.start()
        let vc = coordinatorSwift.generateSwiftViewController()
        
        // Add View Controller as Child View Controller
        add(asChildViewController: vc)
        return vc
    }()
    
    private lazy var noConnectionVC = NoConnectionViewController.instantiate(from: AppStoryboards.NoConnection)
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        switch Config.Common.defaultLanguage {
        case .Swift:
            add(asChildViewController: proposalsSwiftVC)
        case .Rust:
            add(asChildViewController: proposalsRustVC)
        }
        
        add(asChildViewController: proposalsSwiftVC)
        languageChangeSubscribe()
    }
    
    // MARK: - Actions
    
    @IBAction func settingsButtonTapped(_ sender: UIBarButtonItem) {
        coordinator?.goToSettingsScreen()
    }
    
    // MARK: - Private
    
    private func languageChangeSubscribe() {
        self.navDropDown.didChangeLanguageCompletion = { [weak self] (selectedLang: LanguageType) in
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
