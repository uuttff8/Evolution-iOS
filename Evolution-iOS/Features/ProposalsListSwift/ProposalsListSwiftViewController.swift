//
//  ProposalsListSwiftViewController.swift
//  Evolution-iOS
//
//  Created by uuttff8 on 2/6/20.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import UIKit

class ProposalsListSwiftViewController: ViewController, Storyboarded {

    weak var coordinator: ProposalsListSwiftCoordinator?
    
    @IBOutlet weak var tableView: UITableView!
    
    var dataSource: [ProposalSwift]? {
        didSet {
            self.dataSource?.reverse()
            tableView.reloadData()
        }
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

}

extension ProposalsListSwiftViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: ProposalsListSwiftTableViewCell.self), for: indexPath) as! ProposalsListSwiftTableViewCell
        
        // TODO:
//        cell.initialaze(with: dataSource?[indexPath.item])
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 106
    }
}
