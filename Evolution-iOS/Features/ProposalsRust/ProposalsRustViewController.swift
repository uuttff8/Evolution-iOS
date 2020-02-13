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
    
    weak var coordinator: ProposalsRustCoordinator?
    
    @IBOutlet weak var tableView: UITableView!
    
    var dataSource: ProposalsRust = { return ProposalsRust(proposals: []) }() {
        didSet {
            self.dataSource.proposals.reverse()
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    // MARK: - Lifecycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        guard let _ = coordinator else { return }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        coordinator?.showProposalDetail(proposal: self.dataSource.proposals[indexPath.item])
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 106
    }
}
