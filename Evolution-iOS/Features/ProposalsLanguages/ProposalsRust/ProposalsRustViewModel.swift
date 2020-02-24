//
//  ProposalsRustViewModel.swift
//  Evolution-iOS
//
//  Created by uuttff8 on 2/20/20.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import UIKit

class ProposalsRustViewModel {
    weak var filteredDataSource : GenericDataSource<ProposalRust>?
    var dataSource: [ProposalRust]?
    
    init(dataSource : GenericDataSource<ProposalRust>) {
        self.filteredDataSource = dataSource
    }
    
    func fetchDataSource() {
        MLApi.Rust.fetchProposals { (propRust) in
            guard let propRust = propRust else { return }
            
            self.filteredDataSource?.data.value = propRust.proposals
            self.filteredDataSource?.data.value.reverse()
            
            self.dataSource = propRust.proposals.reversed()
        }
    }
}

class ProposalsRustDataSource: GenericDataSource<ProposalRust>, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.value.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.cell(forRowAt: indexPath) as ProposalsRustTableViewCell
        
        cell.initialize(with: data.value[indexPath.item])
        cell.selectionStyle = .none
        
        return cell
    }
}
