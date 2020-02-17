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
    
    // MARK: - Private properties
    private lazy var dataSource: [Section] = {
        return AboutOpenSourceData.shared.sectionsData()
    }()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(CustomSubtitleTableViewCell.self, forCellReuseIdentifier: "AboutCellIdentifier")
        tableView.reloadData()

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

// MARK: - UITableView Data Source
extension AboutOpenSourceViewController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        return dataSource.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let about = dataSource[section]
        guard about.grouped == false else {
            return 1
        }
        
        return about.items.count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let about = dataSource[section]

        return about.section.description
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let about = dataSource[indexPath.section]
        let item = about.items[indexPath.row]
        
        let cellIdentifier = about.grouped ? "GroupedTableViewCell" : "AboutCellIdentifier"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier,
                                                 for: indexPath)
        
        cell.selectionStyle = .none
        
        if about.grouped {
            let contributors = about.items.shuffle()
            cell.textLabel?.text = contributors.text
        }
        else {
            cell.textLabel?.text = item.text
            cell.detailTextLabel?.text = item.media
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        guard let footer = dataSource[section].footer else {
            return nil
        }
        
        return footer
    }
}


// MARK: - UITableView Delegate
extension AboutOpenSourceViewController {
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let about = dataSource[indexPath.section]
        let item = about.items[indexPath.row]
        
        if about.grouped {
            // Config.Segues.aboutDetails.performSegue(in: self)
        }
        else {
            let alertController = UIAlertController.presentAlert(to: item)
            self.present(alertController, animated: true, completion: nil)
        }
    }
}
