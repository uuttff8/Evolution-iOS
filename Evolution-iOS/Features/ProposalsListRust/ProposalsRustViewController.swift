//
//  ProposalsViewController.swift
//  Evolution-iOS
//
//  Created by uuttff8 on 1/26/20.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import UIKit
import Combine

private typealias OfferEmployeCell = (type: String, height: CGFloat, enumType: LanguageSelected, data: Any?)

class ProposalsRustViewController: ViewController, Storyboarded {
    
    weak var coordinator: ProposalsRustCoordinator?
    
    @IBOutlet weak var tableView: UITableView!
    
    var dataSource: ProposalsRust? {
        didSet {
            self.dataSource?.proposals.reverse()
            tableView.reloadData()
        }
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        guard let _ = coordinator else { return }
    }
}

extension ProposalsRustViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource?.proposals.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: ProposalsRustTableViewCell.self), for: indexPath) as! ProposalsRustTableViewCell
        
        cell.initialaze(with: dataSource?.proposals[indexPath.item])
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 106
    }
}
