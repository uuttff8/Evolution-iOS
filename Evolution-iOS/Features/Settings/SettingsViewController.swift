//
//  SettingsViewController.swift
//  Evolution-iOS
//
//  Created by uuttff8 on 2/15/20.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import UIKit

class SettingsViewController: NetViewController, Storyboarded {
    weak var coordinator: SettingsCoordinator?
    
    private let dataSource = SettingsDataSource()
    lazy var viewModel : SettingsViewModel = {
        let viewModel = SettingsViewModel(dataSource: dataSource)
        return viewModel
    }()
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let _ = coordinator else { return }
        
        tableView.registerNib(withClass: CustomSubtitleTableViewCell.self)
        tableView.registerNib(withClass: DataValueTableViewCell.self)
        
        self.tableView.dataSource = self.dataSource
        
        self.dataSource.data.addAndNotify(observer: self) { [weak self] in
            self?.tableView.reloadData()
        }
        
        self.viewModel.fetchDataSource()
    }
}

// UITableViewDelegate
extension SettingsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let section = self.viewModel.dataSource?.data.value[indexPath.section]
        if section?.section == .authors {
            return 60
        }
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let section = self.dataSource.data.value[indexPath.section]
        
        switch section.section {
        case .openSource:
            coordinator?.showAboutOpenSourceScreen()
        case .authors:
            let item = section.items[indexPath.item]
            let alertController = UIAlertController.presentAlert(to: item)
            self.present(alertController, animated: true, completion: nil)
        default:
            break
        }
        
    }
}
