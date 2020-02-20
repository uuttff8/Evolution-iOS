//
//  SettingsViewModel.swift
//  Evolution-iOS
//
//  Created by uuttff8 on 2/17/20.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import UIKit


struct SettingsViewModel {
    weak var dataSource : GenericDataSource<Section>?
    
    init(dataSource : GenericDataSource<Section>?) {
        self.dataSource = dataSource
    }
    
    func fetchDataSource() {
        
        let authors = Section(section: .authors,
                              items:[
                                Contributor(text: "Anton Kuzmin", type: .github, value: "uuttff8"),
                                Contributor(text: "Thiago Holanda", type: .github, value: "unnamedd") ],
                              footer: nil,
                              grouped: false)
        
        let about = Section(section: .openSource,
                            items: [
                                Item(text: "See all details about this app", type: .undefined, value: "")],
                            footer: nil,
                            grouped: false)
        
        let version = Section(
            section: .application,
            items: [
                Item(text: "Build", type: .noUrl, value: Bundle.main.buildVersionNumber ?? ""),
                Item(text: "Version", type: .noUrl, value: Bundle.main.releaseVersionNumber ?? "")
            ],
            footer: nil,
            grouped: false
        )
        
        
        
        self.dataSource?.data.value = [authors, about, version]
    }
}

class SettingsDataSource: GenericDataSource<Section>, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.data.value.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.data.value[section].items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: UITableViewCell
        
        let section = self.data.value[indexPath.section]
        let item = section.items[indexPath.row]
        
        switch section.section {
        case .openSource:
            cell = tableView.cell(forRowAt: indexPath) as CustomSubtitleTableViewCell
            cell.textLabel?.text        = "Contributors, licenses and more"
            cell.detailTextLabel?.text  = item.text
        case .authors:
            let contributor = section.items[indexPath.item] as? Contributor
            let contributorCell = tableView.cell(forRowAt: indexPath) as CustomSubtitleTableViewCell
            contributorCell.contributor = contributor
            
            cell = contributorCell
        case .application:
            let versionCell = tableView.cell(forRowAt: indexPath) as DataValueTableViewCell
            versionCell.item = section.items[indexPath.item] as? Item
            versionCell.selectionStyle = .none
        
            cell = versionCell
        default:
            cell = UITableViewCell()
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.setNeedsDisplay()
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let section = self.data.value[section]
        
        return section.section.description
    }
    
    func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        let section = self.data.value[section]
        
        return section.footer
    }
}
