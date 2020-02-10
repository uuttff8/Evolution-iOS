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
    
    var alert: UIAlertController {
        let alert = UIAlertController(title: nil, message: "Please wait...", preferredStyle: .alert)
        let loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50))
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.style = UIActivityIndicatorView.Style.medium
        loadingIndicator.startAnimating();
        
        alert.view.addSubview(loadingIndicator)
        
        return alert
    }
    
    private lazy var proposalsRustVC: ProposalsRustViewController = {
        let coordinator = ProposalsRustCoordinator()
        coordinator.start()
        let vc = coordinator.getVC()
        // Add View Controller as Child View Controller
        self.add(asChildViewController: vc)

        return vc
    }()

    private lazy var proposalsSwiftVC: ProposalsSwiftViewController = {
        let coordinator = ProposalsSwiftCoordinator()
        coordinator.start()
        let vc = coordinator.getVC()
        // Add View Controller as Child View Controller
        self.add(asChildViewController: vc)

        return vc
    }()
    
    private lazy var noConnectionVC: NoConnectionViewController = {
        let vc = NoConnectionViewController.instantiate(from: AppStoryboards.NoConnection)
        vc.delegate = self
        return vc
    }()

    
    
    // MARK: - Lifecycle -
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let _ = coordinator else { return }
        
        connectIfhasConnection()
        
    }
    
    // MARK: - Private -
    
    private func connectIfhasConnection() {
        if Reachability.isConnectedToNetwork() == true {
            setupProcessing()
        } else {
            // TODO: create no connection view
            self.add(asChildViewController: self.noConnectionVC)
        }
    }
    
    private func setupProcessing() {
        downloadSwiftProposals()
        languageChangeSubscribe()
    }
    
    private func downloadSwiftProposals() {
        // Show loading Indicator
        self.parent?.present(alert, animated: true, completion: nil)
        
        coordinator?.initSwiftVC { (propSwift) in
            self.add(asChildViewController: self.proposalsSwiftVC)
            self.proposalsSwiftVC.dataSource = propSwift
            
            // Hide loading indicator
            self.parent?.dismiss(animated: true, completion: nil)
        }
    }
    
    private func languageChangeSubscribe() {
        self.navDropDown.didChangeLanguageCompletion = { [weak self] (selectedLang: LanguageSelected) in
            guard let self = self else { return }
            
            self.coordinator?.changeLangTo(selectedLang, completion: { (langData) in
                switch langData {
                case .RustData(let propRust):
                    self.remove(asChildViewController: self.proposalsSwiftVC)
                    self.add(asChildViewController: self.proposalsRustVC)
                    self.proposalsRustVC.dataSource = propRust
                    break
                case .SwiftData(let propSwift):
                    self.remove(asChildViewController: self.proposalsRustVC)
                    self.add(asChildViewController: self.proposalsSwiftVC)
                    self.proposalsSwiftVC.dataSource = propSwift
                }
            })
        }
    }
}

extension ProposalsContainerViewController: NoConnectionDelegate {
    func retryConnection() {
        self.remove(asChildViewController: self.noConnectionVC)
        
        self.connectIfhasConnection()
    }
}
