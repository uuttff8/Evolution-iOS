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
    
    
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            self.tableView.estimatedRowHeight = 164
            self.tableView.rowHeight = UITableView.automaticDimension
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
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        coordinator?.removeDependency(coordinator)
    }
}

extension ProposalsRustViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        coordinator?.showProposalDetail(proposalLang: .RustData((self.viewModel.dataSource?.data.value[indexPath.item])!))
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
