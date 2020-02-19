//
//  AboutOpenSourceViewController.swift
//  Evolution-iOS
//
//  Created by uuttff8 on 2/17/20.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import UIKit

class AboutOpenSourceViewController: UITableViewController, Storyboarded {
    
    weak var coordinator: AboutOpenSourceCoordinator?
    
    private let dataSource = AboutOpenSourceDataSource()
    
    lazy var viewModel : AboutOpenSourceViewModel = {
        let viewModel = AboutOpenSourceViewModel(dataSource: dataSource)
        return viewModel
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let _ = coordinator else { return }
        
        title = "Open Source"
        
        tableView.register(CustomSubtitleTableViewCell.self, forCellReuseIdentifier: "AboutCellIdentifier")
        
        tableView.dataSource = self.dataSource
        self.dataSource.data.addAndNotify(observer: self) { [weak self] in
            self?.tableView.reloadData()
        }
        self.viewModel.fetchDataSource()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        coordinator?.removeDependency(self.coordinator)
    }
}


// MARK: - UITableView Delegate
extension AboutOpenSourceViewController {
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let about = self.dataSource.data.value[indexPath.section]
        let item = about.items[indexPath.row]
        
        if about.grouped {
            coordinator?.showAboutDetail(aboutData: self.dataSource.data.value[indexPath.section])
        }
        else {
            let alertController = UIAlertController.presentAlert(to: item)
            self.present(alertController, animated: true, completion: nil)
        }
    }
}
