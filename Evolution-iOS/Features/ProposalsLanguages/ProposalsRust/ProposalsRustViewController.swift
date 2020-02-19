//
//  ProposalsViewController.swift
//  Evolution-iOS
//
//  Created by uuttff8 on 1/26/20.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import UIKit
import Combine

class ProposalsRustViewController: NetViewController, Storyboarded {
    
    weak var coordinator: ProposalsLanguagesCoordinator?
    
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            self.tableView.estimatedRowHeight = 164
            self.tableView.rowHeight = UITableView.automaticDimension
        }
    }
    
    var dataSource: ProposalsRust = { return ProposalsRust(proposals: []) }() {
        didSet {
            self.dataSource.proposals.reverse()
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let _ = coordinator else { return }
        
        getProposalList()
    }
    
    //MARK: - Request
    private func getProposalList() {
        MLApi.Rust.fetchProposals { (propRust) in
            guard let propRust = propRust else { return }
            self.dataSource = propRust
        }
    }
}

extension ProposalsRustViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.proposals.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.cell(forRowAt: indexPath) as ProposalsRustTableViewCell
        
        cell.initialize(with: dataSource.proposals[indexPath.item])
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        coordinator?.showProposalDetail(proposalLang: .RustData(self.dataSource.proposals[indexPath.item]))
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
}
