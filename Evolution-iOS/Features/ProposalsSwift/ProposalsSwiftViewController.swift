//
//  ProposalsSwiftViewController.swift
//  Evolution-iOS
//
//  Created by uuttff8 on 2/6/20.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import UIKit

class ProposalsSwiftViewController: NetViewController, Storyboarded {

    weak var coordinator: ProposalsSwiftCoordinator?
    
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.estimatedRowHeight = 164
            tableView.estimatedSectionHeaderHeight = 44.0
            tableView.rowHeight = UITableView.automaticDimension
            
            tableView.addSubview(refreshControl)
        }
    }
    
    var dataSource: [ProposalSwift]? {
        didSet {
            self.dataSource?.reverse()
        }
    }
    
    fileprivate weak var appDelegate: AppDelegate?
    
    // Filters
    fileprivate var languages: [Version] = []
    fileprivate var status: [StatusState] = []
    
    // Proposal ordering
    fileprivate lazy var statusOrder: [StatusState] = {
        return [.awaitingReview, .scheduledForReview, .activeReview,
                .returnedForRevision, .accepted, .acceptedWithRevisions, .implemented,
                .deferred, .rejected, .withdrawn]
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        refreshControl.addTarget(self, action: #selector(pullToRefresh(_:)), for: .valueChanged)
        
        // Filter Header View settings
//        filterHeaderView.statusFilterView.delegate = self
//        filterHeaderView.languageVersionFilterView.delegate = self
//        filterHeaderView.searchBar.delegate = self
//        filterHeaderView.clipsToBounds = true
//
//        filterHeaderView.filterButton.addTarget(self, action: #selector(filterButtonAction(_:)), for: .touchUpInside)
//        filterHeaderView.filteredByButton.addTarget(self, action: #selector(filteredByButtonAction(_:)), for: .touchUpInside)
//
//        filterHeaderView.filterLevel = .without

    }
    
    // MARK: - Objc Actions
    @objc private func pullToRefresh(_ sender: UIRefreshControl) {
//        getProposalList()
    }

}

extension ProposalsSwiftViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: ProposalsSwiftTableViewCell.self), for: indexPath) as! ProposalsSwiftTableViewCell
        
        cell.proposal = self.dataSource?[indexPath.item]
        cell.delegate = self
        
        return cell
    }
}

extension ProposalsSwiftViewController: ProposalSwiftDelegate {
    func didSelect(person: Person) {
        // TODO: Go to person screen
        print("person selected")
    }
    
    func didSelect(proposal: ProposalSwift) {
        // TODO: Go to proposal screen
        print("proposal selected")
    }
    
    func didSelect(implementation: Implementation) {
        // TODO: Go to safari with implementation
        print("implementation selected")
    }
}
