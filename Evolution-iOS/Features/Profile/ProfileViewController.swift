//
//  ProfileViewController.swift
//  Evolution-iOS
//
//  Created by uuttff8 on 2/18/20.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import UIKit

class ProfileViewController: NetViewController, Storyboarded {
    
    weak var coordinator: ProfileCoordinator?
    
    fileprivate struct Section {
        let title: String
        let proposals: [ProposalSwift]
    }
    
    static var dismissCallback: ((Any?) -> Void)?
    
    @IBOutlet private weak var profileView: ProfileView!
    @IBOutlet private weak var tableView: UITableView!
//    @IBOutlet private weak var toolbar: UIToolbar!
//    @IBOutlet private weak var toolbarTopYConstraint: NSLayoutConstraint!
    
    open var profile: Person?
    fileprivate lazy var sections: [Section] = {
        return []
    }()
    
    
    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Register Cell to TableView
        self.tableView.registerNib(withClass: ProposalsSwiftTableViewCell.self)
        self.tableView.registerNib(withClass: ProposalListHeaderTableViewCell.self)
        
        self.tableView.estimatedRowHeight = 164
        self.tableView.estimatedSectionHeaderHeight = 44.0
        self.tableView.rowHeight = UITableView.automaticDimension
        
//        if UIDevice.current.userInterfaceIdiom != .pad {
//            toolbar?.items?.removeAll()
//            toolbarTopYConstraint.constant = -44
//            view.layoutIfNeeded()
//        }
        
        // Settings
        // self.showNoConnection = false
        self.profileView.profile = profile
        self.getUserDataFromGithub()
        self.tableView.reloadData()
        
        // Title
        if let profile = self.profile, let username = profile.username {
            self.title = "@\(username)"
            
        }
        
        self.configureSections()
        
        //        // Configure reachability closures
        //        self.reachability?.whenReachable = { [unowned self] reachability in
        //            if self.profileView.imageURL == nil {
        //                self.getUserDataFromGithub()
        //            }
        //        }
    }
    
}

// MARK: - Requests
extension ProfileViewController {
    fileprivate func configureSections() {
        guard let profile = self.profile else {
            return
        }
        
        if let author = profile.asAuthor, author.count > 0 {
            let section = Section(title: "Author", proposals: author)
            sections.append(section)
        }
        
        if let manager = profile.asManager, manager.count > 0 {
            let section = Section(title: "Review Manager", proposals: manager)
            sections.append(section)
        }
        
        self.tableView.reloadData()
    }
    
    fileprivate func getUserDataFromGithub() {
        guard let profile = self.profile, let username = profile.username else {
            return
        }
        
        if Reachability.isConnectedToNetwork() {
            coordinator?.fetchProfile(from: username, completion: { [weak self] (profile) in
                guard let self = self else { return }
                guard let githubProfile = profile else { return }
                
                self.profile?.github = githubProfile
                self.profileView.imageURL = githubProfile.avatar
            })
        }
    }
}


// MARK: - UITableView DataSource
extension ProfileViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        let sections = self.sections.count
        
        guard sections > 0 else {
            return 0
        }
        
        return sections
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.sections[section].proposals.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.cell(forRowAt: indexPath) as ProposalsSwiftTableViewCell
        
        let section = self.sections[indexPath.section]
        let proposal = section.proposals[indexPath.row]
        
        cell.proposal = proposal
        
        return cell
    }
}

// MARK: - UITableView Delegate
extension ProfileViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerCell = tableView.cell(forClass: ProposalListHeaderTableViewCell.self)
        
        let section = self.sections[section]
        headerCell.header = section.title
        
        return headerCell.contentView
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.01
    }
}
