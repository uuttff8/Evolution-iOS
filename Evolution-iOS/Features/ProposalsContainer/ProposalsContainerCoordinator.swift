//
//  ProposalsContainerController.swift
//  Evolution-iOS
//
//  Created by uuttff8 on 2/6/20.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import UIKit
import Combine

class ProposalsContainerCoordinator: Coordinator {
    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController?
    
    var cancellable = Set<AnyCancellable>()
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let vc = ProposalsContainerViewController.instantiate(from: AppStoryboards.ProposalsContainer)
        navigationController?.pushViewController(vc, animated: false)
        vc.coordinator = self
    }
    
    func initSwiftVC(completion: @escaping ([ProposalSwift]) -> ()) {
        MLApi.Swift.fetchProposals()
            .receive(on: RunLoop.main)
            .sink { (propSwift) in
            guard let propSwift = propSwift else { return }
            completion(propSwift)
        }.store(in: &self.cancellable)
    }
    
    func changeLangTo(_ lang: LanguageSelected, completion: @escaping (LangData) -> ()) {
        switch lang {
        case .Rust:
            MLApi.Rust.fetchProposals()
                .receive(on: RunLoop.main)
                .sink { (propRust) in
                    guard let propRust = propRust else { return }
                    completion(LangData.RustData(propRust))
            }.store(in: &self.cancellable)
        case .Swift:
            MLApi.Swift.fetchProposals()
                .receive(on: RunLoop.main)
                .sink { (propSwift) in
                guard let propSwift = propSwift else { return }
                completion(LangData.SwiftData(propSwift))
            }.store(in: &self.cancellable)
        }
    }
    
}
