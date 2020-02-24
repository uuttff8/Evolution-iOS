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
    
    private let dataSource = ProposalsRustDataSource()
    
    lazy var viewModel : ProposalsRustViewModel = {
        let viewModel = ProposalsRustViewModel(dataSource: self.dataSource)
        return viewModel
    }()
    
    @IBOutlet weak var rustProposalsSearchBar: UISearchBar! {
        didSet {
            self.rustProposalsSearchBar.delegate = self
        }
    }
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            self.tableView.estimatedRowHeight = 164
            self.tableView.rowHeight = UITableView.automaticDimension
            self.tableView.refreshControl = refreshControl
        }
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let _ = coordinator else { return }
        
        self.tableView.dataSource = self.dataSource
        
        self.dataSource.data.addAndNotify(observer: self) { [weak self] in
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
        
        self.viewModel.fetchDataSource()
        
        refreshControl.addTarget(self, action: #selector(handlePullToRefresh), for: .valueChanged)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        coordinator?.removeDependency(coordinator)
    }
    
    @objc func handlePullToRefresh() {
        refreshControl.beginRefreshing()
        self.viewModel.fetchDataSource()
        if self.refreshControl.isRefreshing {
            self.refreshControl.endRefreshing()
        }
    }
    
    fileprivate func updateTableView(_ filtered: [ProposalRust]? = nil) {
        
        if let filtered = filtered {
            self.viewModel.filteredDataSource?.data.value = filtered
        } else {
            self.viewModel.filteredDataSource?.data.value = self.viewModel.dataSource!
        }
        
        
        self.viewModel.filteredDataSource?.data.value = (self.viewModel.filteredDataSource?.data.value.removeDuplicates())!
                
        self.tableView.beginUpdates()
        self.tableView.reloadSections(IndexSet(integer: 0), with: .fade)
        self.tableView.endUpdates()
    }

}

extension ProposalsRustViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        coordinator?.showProposalDetail(proposalLang: .RustData((self.viewModel.filteredDataSource?.data.value[indexPath.item])!))
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension ProposalsRustViewController: UISearchBarDelegate {
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(true, animated: true)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard searchText != "" else {
            self.updateTableView()
            return
        }
        
        
        if searchText.count > 3 {
            let interval = 0.7
            Timer.scheduledTimer(withTimeInterval: interval, repeats: false) { _ in
                let filtered = self.dataSource.data.value.filter(by: searchText)
                self.updateTableView(filtered)
            }
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let query = searchBar.text,
            query.trimmingCharacters(in: .whitespaces) != ""
            else {
                return
        }
        
        let filtered = self.dataSource.data.value.filter(by: query)
        self.updateTableView(filtered)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(false, animated: true)
        searchBar.resignFirstResponder()
        searchBar.text = ""
        
        self.updateTableView()
    }
}
