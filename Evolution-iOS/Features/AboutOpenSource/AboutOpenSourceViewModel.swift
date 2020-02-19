//
//  AboutOpenSoucreViewModel.swift
//  Evolution-iOS
//
//  Created by uuttff8 on 2/17/20.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import UIKit


struct AboutOpenSourceViewModel {
    weak var dataSource : GenericDataSource<Section>?
    
    init(dataSource : GenericDataSource<Section>?) {
        self.dataSource = dataSource
    }
    
    func fetchDataSource() {
        let datas = AboutOpenSourceData.shared.sectionsData()
        
        self.dataSource?.data.value = datas
    }
}

class AboutOpenSourceDataSource: GenericDataSource<Section>, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return data.value.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let about = data.value[section]
        guard about.grouped == false else {
            return 1
        }
        
        return about.items.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let about = data.value[section]

        return about.section.description
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let about = data.value[indexPath.section]
        let item = about.items[indexPath.row]
        
        let cellIdentifier = about.grouped ? "GroupedTableViewCell" : "AboutCellIdentifier"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier,
                                                 for: indexPath)
        
        cell.selectionStyle = .none
        
        if about.grouped {
            // Question to Thiago: Why did you add this shuffle here?
            let contributors = about.items //.shuffle()
            cell.textLabel?.text = contributors.text
            cell.accessoryType = .disclosureIndicator
        }
        else {
            cell.textLabel?.text = item.text
            cell.detailTextLabel?.text = item.media
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        guard let footer = data.value[section].footer else {
            return nil
        }
        
        return footer
    }

}
