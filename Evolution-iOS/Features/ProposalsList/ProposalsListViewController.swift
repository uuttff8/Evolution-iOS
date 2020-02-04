//
//  ProposalsListViewController.swift
//  Evolution-iOS
//
//  Created by uuttff8 on 1/26/20.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import UIKit
import Combine

class ProposalsListViewController: ViewController, Storyboarded {
    
    weak var coordinator: ProposalsListCoordinator?
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var navDropDown: NavDropDown! {
        didSet {
            self.navDropDown.vc = self
        }
    }
    
    var dataSource: ProposalsRust? {
        didSet {
            self.dataSource?.proposals.reverse()
            tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        guard let coordinator = coordinator else { return }
        
        self.navDropDown.didChangeLanguageCompletion = { [weak self] (selectedLang: LanguageSelected) in
            guard let self = self else { return }
            
            coordinator.changeLangTo(selectedLang, completion: { (langData) in
                switch langData {
                case .RustData(let propRust):
                    self.dataSource = propRust
                    break
                case .SwiftData(let propSwift):
                    
                    break
                }
            })
        }
    }
}

extension ProposalsListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource?.proposals.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: ProposalsRustTableViewCell.self), for: indexPath) as! ProposalsRustTableViewCell
        cell.title.text = dataSource?.proposals[indexPath.item].title
        cell.date.text = dataSource?.proposals[indexPath.item].date
        cell.index.text = dataSource?.proposals[indexPath.item].index
        cell.issue.text = dataSource?.proposals[indexPath.item].issue

        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 106
    }
    
    
}
