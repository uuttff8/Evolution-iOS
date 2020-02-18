//
//  ProposalsLanguagesCoordinator.swift
//  Evolution-iOS
//
//  Created by uuttff8 on 2/15/20.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import UIKit
import SafariServices

enum LangDataOne {
    case RustData(ProposalRust)
    case SwiftData(ProposalSwift)
}

class ProposalsLanguagesCoordinator: NSObject, Coordinator {
    var navigationController: UINavigationController?
    var childCoordinators = [Coordinator]()
    
    
    init(navigationController: UINavigationController? = nil) {
        self.navigationController = navigationController
    }
    
    func start() { }
    
    func getVcRust() -> ProposalsRustViewController {
        let vc = ProposalsRustViewController.instantiate(from: AppStoryboards.ProposalsRust)
        vc.coordinator = self
        return vc
    }
    
    func getVcSwift() -> ProposalsSwiftViewController {
        let vc = ProposalsSwiftViewController.instantiate(from: AppStoryboards.ProposalsSwift)
        vc.coordinator = self
        return vc
    }
    
    func showProposalDetail(proposalLang: LangDataOne) {
        
        switch proposalLang {
        case let .RustData(propRust):
            let coordinator = ProposalDetailCoordinator(navigationController: navigationController,
                                                        lang: LanguageSelected.Rust,
                                                        proposalId: propRust.title ?? "")
            childCoordinators.append(coordinator)
            coordinator.start()
        case let .SwiftData(propSwift):
            let coordinator = ProposalDetailCoordinator(navigationController: navigationController,
                                                        lang: LanguageSelected.Swift,
                                                        proposalId: propSwift.description)
            childCoordinators.append(coordinator)
            coordinator.start()
        }
    }
    
    func goToBrowser(target: UIViewController, with implementation: Implementation) {
        if let url = URL(string: "\(Config.Base.URL.GitHub.base)/\(implementation.path)") {
            let safariViewController = SFSafariViewController(url: url)
            target.present(safariViewController, animated: true)
        }
    }
    
    func showProfile(with person: Person) {
        let coordinator = ProfileCoordinator(navigationController: navigationController, person: person)
        childCoordinators.append(coordinator)
        coordinator.start()
    }
}
