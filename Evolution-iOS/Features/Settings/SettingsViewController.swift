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
    lazy var viewModel : CurrencyViewModel = {
        let viewModel = CurrencyViewModel(dataSource: dataSource)
        return viewModel
    }()
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let _ = coordinator else { return }
        
        tableView.registerNib(withClass: CustomSubtitleTableViewCell.self)
        
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
        // let section = coordinator?.dataSource[indexPath.section]
        
//        if section.section == .about {
//            performSegue(withIdentifier: "AboutStoryboardSegue", sender: nil)
//        }
//        else if section.section == .author, let item = section.items.first {
//            let alertController = UIAlertController.presentAlert(to: item)
//            self.present(alertController, animated: true, completion: nil)
//        }
    }
}
