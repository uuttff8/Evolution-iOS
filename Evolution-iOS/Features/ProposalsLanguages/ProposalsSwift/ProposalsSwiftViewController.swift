//
//  ProposalsSwiftViewController.swift
//  Evolution-iOS
//
//  Created by uuttff8 on 2/6/20.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import UIKit
import Combine

class ProposalsSwiftViewController: NetViewController, Storyboarded {
    
    // Private IBOutlets
    @IBOutlet private(set) weak var footerView: UIView!
    @IBOutlet private(set) weak var filterHeaderView: FilterHeaderView! {
        didSet {
            self.filterHeaderView.clipsToBounds = true
            
            self.filterHeaderView.filterButton.addTarget(self,
                                                         action: #selector(filterButtonAction(_:)),
                                                         for: .touchUpInside)

            
            filterHeaderView.filterLevel = .without
        }
    }
    @IBOutlet private(set) weak var filterHeaderViewHeightConstraint: NSLayoutConstraint!
    
    // @IBOutlet private(set) weak var settingsBarButtonItem: UIBarButtonItem?
    
    // Private properties
    fileprivate var timer: Timer = Timer()
    
    weak var coordinator: ProposalsLanguagesCoordinator?
    fileprivate weak var appDelegate: AppDelegate?
    
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.estimatedRowHeight = 164
            tableView.estimatedSectionHeaderHeight = 44.0
            tableView.rowHeight = UITableView.automaticDimension
            tableView.registerNib(withClass: ProposalListHeaderTableViewCell.self)
            
            tableView.addSubview(refreshControl)
            self.tableView.keyboardDismissMode = .onDrag
        }
    }
    
    private lazy var filteredDataSource: [ProposalSwift] = {
        return []
    }()
    
    var dataSource: [ProposalSwift] = { return [] }()
    
    // Filters
    fileprivate var languages: [Version] = []
    fileprivate var status: [StatusState] = []
    
    // Proposal ordering
    fileprivate lazy var statusOrder: [StatusState] = {
        return [.awaitingReview, .scheduledForReview, .activeReview,
                .returnedForRevision, .accepted, .acceptedWithRevisions, .implemented,
                .deferred, .rejected, .withdrawn]
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.appDelegate = UIApplication.shared.delegate as? AppDelegate
        
        refreshControl.addTarget(self, action: #selector(pullToRefresh(_:)), for: .valueChanged)
        
        self.filterHeaderView.filteredByButton.addTarget(self,
                                                         action: #selector(filteredByButtonAction(_:)),
                                                         for: .touchUpInside)
        setupFilterHeaderDelegates()

        getProposalList()
        
        if !Reachability.isConnectedToNetwork() {
            self.showNoConnection = true
        }
    }
    
    // MARK: - Layout
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        self.filterHeaderViewHeightConstraint.constant = self.filterHeaderView.heightForView
    }
    
    fileprivate func layoutFilterHeaderView() {
        UIView.animate(withDuration: 0.25) {
            self.filterHeaderViewHeightConstraint.constant = self.filterHeaderView.heightForView
            self.view.layoutIfNeeded()
        }
    }
    
    // MARK: - Objc Actions -
    @objc func filterButtonAction(_ sender: UIButton?) {
        
        guard let sender = sender else {
            return
        }
        
        sender.isSelected = !sender.isSelected
        self.filterHeaderView.filterLevel = .without
        
        if !sender.isSelected {
            self.filterHeaderView.filteredByButton.isSelected = false
        }
        else {
            // Open filter until filteredByButton max height
            self.filterHeaderView.filterLevel = .filtered
            
            // If have any status selected, open to status list max height, else open to language version max height
            if let selected = self.filterHeaderView.statusFilterView.indexPathsForSelectedItems, selected.count > 0 {
                
                self.filterHeaderView.filterLevel = .status
                if self.selected(status: .implemented) {
                    self.filterHeaderView.filterLevel = .version
                }
                
                self.filterHeaderView.filteredByButton.isSelected = true
            }
        }
        
        self.updateTableView()
        self.layoutFilterHeaderView()
    }
    
    @objc func filteredByButtonAction(_ sender: UIButton?) {
        guard let sender = sender else { return }
        
        sender.isSelected = !sender.isSelected
        self.filterHeaderView.filterLevel = sender.isSelected ? .status : .filtered
        
        // If have any status selected, open to status list max height, else open to language version max height
        if let selected = self.filterHeaderView.statusFilterView.indexPathsForSelectedItems, selected.count > 0, sender.isSelected {
            self.filterHeaderView.filterLevel = self.selected(status: .implemented) ? .version : .status
        }
        
        self.layoutFilterHeaderView()
    }
    
    @objc func fireSearch(_ timer: Timer) {
        guard let search = timer.userInfo as? Search else {
            return
        }
        
        let filtered = self.dataSource.filter(by: search.query)
        self.updateTableView(filtered)
    }
    
    @objc private func pullToRefresh(_ sender: UIRefreshControl) {
        getProposalList()
    }
    
    // MARK: - Utils -
    fileprivate func updateTableView(_ filtered: [ProposalSwift]? = nil) {
        if let filtered = filtered {
            self.filteredDataSource = filtered
        }
        else {
            self.filteredDataSource = self.dataSource
        }
        
        if self.filterHeaderView.filterButton.isSelected {

            // Check if there is at least on status selected
            if self.status.count > 0 {
                var expection: [StatusState] = [.implemented]
                if self.selected(status: .implemented) && self.languages.count == 0 {
                    expection = []
                }

                self.filteredDataSource = self.filteredDataSource.filter(by: self.status, exceptions: expection).sort(.descending)
            }

            // Check if the status selected is equal to .implemented and has language versions selected
            if self.selected(status: .implemented) && self.languages.count > 0 {
                let implemented = self.dataSource.filter(by: self.languages).filter(status: .implemented)
                self.filteredDataSource.append(contentsOf: implemented)
            }
        }
        
        // Sort in the right order
        self.filteredDataSource = self.filteredDataSource.filter(by: self.statusOrder)
        
        self.tableView.beginUpdates()
        self.tableView.reloadSections(IndexSet(integer: 0), with: .fade)
        self.tableView.endUpdates()
    }
    
    func setupFilterHeaderDelegates() {
        filterHeaderView.statusFilterView.delegate = self
        filterHeaderView.languageVersionFilterView.delegate = self
        filterHeaderView.searchBar.delegate = self
    }
    
    // MARK: - Requests
    private func getProposalList() {
        if Reachability.isConnectedToNetwork() {
            // Hide No Connection View
            
            self.refreshControl.forceShowAnimation()
            
            MLApi.Swift.fetchProposals { [weak self] (propSwift) in
                guard let self = self else { return }
                guard let propSwift = propSwift else { return }
                
                DispatchQueue.main.async {
                    if self.refreshControl.isRefreshing {
                        self.refreshControl.endRefreshing()
                    }
                }
                
                if self.dataSource.count > 0 {
                    self.filteredDataSource   = []
                    self.dataSource           = []
                    self.languages            = []
                    self.status               = []
                    self.appDelegate?.people  = [:]
                }
                
                self.dataSource                       = propSwift.filter(by: self.statusOrder)
                self.filteredDataSource               = self.dataSource
                self.filterHeaderView.statusSource   = self.statusOrder
                self.buildPeople()
                
                // Language Versions source
                self.filterHeaderView?.languageVersionSource = propSwift.compactMap({ $0.status.version }).removeDuplicates().sorted()
                
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                    
                    if self.refreshControl.isRefreshing {
                        self.refreshControl.endRefreshing()
                    }
                }
            }
        } else {
            refreshControl.endRefreshing()
            showNoConnection = true
        }
    }
    
    
    // MARK: - Filters
    fileprivate func selected(status: StatusState) -> Bool {
        guard let indexPaths = self.filterHeaderView.statusFilterView.indexPathsForSelectedItems,
            indexPaths.compactMap({ self.filterHeaderView.statusSource[$0.item] }).filter({ $0 == status }).count > 0 else {
                return false
        }
        return true
    }
    
    
    // MARK: - Data Consolidation
    
    func buildPeople() {
        var authors: [String: Person] = [:]
        
        dataSource.forEach { proposal in
            proposal.authors?.forEach { person in
                guard let name = person.name, name != "" else {
                    return
                }
                
                guard authors[name] == nil else {
                    return
                }
                
                authors[name] = person
                
                guard var user = authors[name] else {
                    return
                }
                
                user.id         = UUID().uuidString
                user.asAuthor   = dataSource.filter(author: user)
                user.asManager  = dataSource.filter(manager: user)
                
                authors[name] = user
            }
        }
        
        appDelegate?.people = authors
    }
}

// MARK: - Table View DataSource And Delegate
extension ProposalsSwiftViewController: UITableViewDelegate, UITableViewDataSource {
    // Data source
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredDataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.cell(forRowAt: indexPath) as ProposalsSwiftTableViewCell
        
        cell.delegate = self
        cell.proposal = self.filteredDataSource[indexPath.row]

        return cell
    }
    
    // Delegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // TODO: support split vc
        //let sourceViewController = UIDevice.current.userInterfaceIdiom == .pad ? splitViewController : self
        //Config.Segues.proposalDetail.performSegue(in: sourceViewController, split: true)
        coordinator?.showProposalDetail(proposalLang:  .SwiftData(self.filteredDataSource[indexPath.item]))
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard !dataSource.isEmpty else {
            return nil
        }
        
        let headerCell = tableView.cell(forClass: ProposalListHeaderTableViewCell.self)
        headerCell.proposalCount = self.filteredDataSource.count
        
        return headerCell.contentView
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.01
    }
}

extension ProposalsSwiftViewController: ProposalSwiftDelegate {
    func didSelect(person: Person) {
        coordinator?.showProfile(with: person)
    }
    
    func didSelect(proposal: ProposalSwift) {
        coordinator?.showProposalDetail(proposalLang:  .SwiftData(proposal))
    }
    
    func didSelect(implementation: Implementation) {
        coordinator?.goToBrowser(target: self, with: implementation)
    }
}


// MARK: - FilterGenericView Delegate
extension ProposalsSwiftViewController: FilterGenericViewDelegate {
    func didSelectFilter(_ view: FilterListGenericView, type: FilterListGenericType, indexPath: IndexPath) {
        switch type {
        case .status:
            if self.filterHeaderView.statusSource[indexPath.item] == .implemented {
                self.filterHeaderView.filterLevel = .version
                self.layoutFilterHeaderView()
                
                self.languages = []
            }
            
            if let item: StatusState = view.dataSource[indexPath.item] as? StatusState {
                self.status.append(item)
            }
            
            self.updateTableView()
            
        case .version:
            if let version = view.dataSource[indexPath.item] as? String {
                self.languages.append(version)
            }
            
            self.updateTableView()
            
        default:
            break
        }
        self.filterHeaderView.updateFilterButton(status: self.status)
    }
    
    func didDeselectFilter(_ view: FilterListGenericView, type: FilterListGenericType, indexPath: IndexPath) {
        let item = view.dataSource[indexPath.item]
        
        switch type {
        case .status:
            if let indexPaths = view.indexPathsForSelectedItems,
                indexPaths.compactMap({ self.filterHeaderView.statusSource[$0.item] }).filter({ $0 == .implemented }).count == 0 {
                
                self.filterHeaderView.filterLevel = .status
                self.layoutFilterHeaderView()
            }
            
            
            if let status = item as? StatusState, self.status.remove(status) {
                self.updateTableView()
            }
            
        case .version:
            if self.languages.remove(string: item.description) {
                self.updateTableView()
            }
            
        default:
            break
        }
        self.filterHeaderView.updateFilterButton(status: self.status)
    }
}


// MARK: - UISearchBar Delegate

fileprivate struct Search {
    let query: String
}

extension ProposalsSwiftViewController: UISearchBarDelegate {
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(true, animated: true)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard searchText != "" else {
            self.updateTableView()
            return
        }
        
        if self.timer.isValid {
            self.timer.invalidate()
        }
        
        if searchText.count > 3 {
            let interval = 0.7
            self.timer = Timer.scheduledTimer(withTimeInterval: interval, repeats: false) { _ in
                let filtered = self.dataSource.filter(by: searchText)
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
        
        let filtered = self.dataSource.filter(by: query)
        self.updateTableView(filtered)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(false, animated: true)
        searchBar.resignFirstResponder()
        searchBar.text = ""
        
        self.updateTableView()
    }
}
