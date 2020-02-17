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
        
        tableView.register(CustomSubtitleTableViewCell.self, forCellReuseIdentifier: "AboutCellIdentifier")
        
        tableView.dataSource = self.dataSource
        
        self.dataSource.data.addAndNotify(observer: self) { [weak self] in
            self?.tableView.reloadData()
        }
        
        self.viewModel.fetchDataSource()
    }
}
//
//// MARK: - Navigation
//extension AboutViewController {
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if let destinationViewController = segue.destination as? AboutDetailTableViewController,
//            let indexPath = tableView.indexPathForSelectedRow {
//
//            let section = dataSource[indexPath.section]
//            if section.grouped {
//                destinationViewController.about = section
//            }
//        }
//    }
//}


// MARK: - UITableView Delegate
extension AboutOpenSourceViewController {
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let about = self.dataSource.data.value[indexPath.section]
        let item = about.items[indexPath.row]
        
        if about.grouped {
            coordinator?.showAboutDetail()
        }
        else {
            let alertController = UIAlertController.presentAlert(to: item)
            self.present(alertController, animated: true, completion: nil)
        }
    }
}
