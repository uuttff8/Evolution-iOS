//
//  SwiftProposals+Ext.swift
//  Evolution-iOS
//
//  Created by uuttff8 on 2/11/20.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import Foundation

// MARK: - Proposals Filters

public enum Sorting {
    case ascending
    case descending
}

extension Sequence where Self: RangeReplaceableCollection, Self: RandomAccessCollection, Iterator.Element == ProposalSwift {
    func get(by id: Int) -> ProposalSwift? {
        guard let index = self.firstIndex(where: { $0.id == id }) else {
            return nil
        }
        
        return self[index]
    }
    
    func filter(author: Person) -> [ProposalSwift] {
        var filter: [ProposalSwift] = []
        guard let name = author.name else {
            return []
        }

        let authors = self.filter {
            guard let authors = $0.authors else { return false }
            return authors.filter(by: name).count > 0
        }
        if authors.count > 0 {
            filter.append(contentsOf: authors)
        }
        
        return filter
    }
    
    func filter(manager: Person) -> [ProposalSwift] {
        var filter: [ProposalSwift] = []
        
        guard let managerName = manager.name else {
            return []
        }
        
        let reviewManagers = self.filter {
            guard let manager = $0.reviewManager,
                let name = manager.name,
                name == managerName
                else {
                    return false
            }
            return true
        }
        if reviewManagers.count > 0 {
            filter.append(contentsOf: reviewManagers)
        }
        
        return filter
    }
    
    func filter(status: StatusState) -> [ProposalSwift] {
        return self.filter { $0.status.state == status }
    }
    
    func filter(language version: Version) -> [ProposalSwift] {
        return self.filter { $0.status.version == version }
    }
    
    func filter(by value: String) -> [ProposalSwift] {
        var filter: [ProposalSwift] = []
        
        // ID
        let ids = self.filter { String($0.id) == value }
        if ids.count > 0 {
            filter.append(contentsOf: ids)
        }
        
        // ID with prefix
        let withPrefixes = self.filter { String($0.description).lowercased() == value.lowercased() }
        if withPrefixes.count > 0 {
            filter.append(contentsOf: withPrefixes)
        }
        
        // Title
        let titles = self.filter { $0.title.contains(value) }
        if titles.count > 0 {
            filter.append(contentsOf: titles)
        }
        
        // Status
        let statuses = self.filter { $0.status.state.rawValue.name.contains(value) }
        if statuses.count > 0 {
            filter.append(contentsOf: statuses)
        }
        
        // Summary
        let summaries = self.filter {
            guard let summary = $0.summary else { return false }
            return summary.contains(value)
        }
        if summaries.count > 0 {
            filter.append(contentsOf: summaries)
        }
        
        // Author
        let authors = self.filter {
            guard let authors = $0.authors else { return false }
            return authors.filter(by: value).count > 0
        }
        if authors.count > 0 {
            filter.append(contentsOf: authors)
        }
        
        // Review Manager
        let reviews = self.filter {
            guard let manager = $0.reviewManager,
                let name = manager.name,
                let username = manager.username
                else {
                    return false
            }
            return (name.contains(value) || username == value)
        }
        if reviews.count > 0 {
            filter.append(contentsOf: reviews)
        }
        
        // Bug
        let bugs = self.filter {
            guard let bugs = $0.bugs else { return false }
            return bugs.filter(by: value).count > 0
        }
        if bugs.count > 0 {
            filter.append(contentsOf: bugs)
        }
        
        return filter
    }
    
    func filter(by languages: [Version]) -> [ProposalSwift] {
        var filter: [ProposalSwift] = []
        
        languages.forEach { language in
            let list = self.filter(language: language)
            filter.append(contentsOf: list)
        }
        
        return filter
    }
    
    func filter(by statuses: [StatusState], exceptions: [StatusState] = []) -> [ProposalSwift] {
        var filter: [ProposalSwift] = []
        
        statuses.forEach { state in
            guard exceptions.contains(state) == false else {
                return
            }
            
            let list = self.filter(status: state).sort(.descending)
            filter.append(contentsOf: list)
        }
        
        return filter
    }
    
    func index(of proposal: ProposalSwift) -> Int? {
        return self.firstIndex(where: { $0 == proposal }) as? Int
    }
    
    func sort(_ direction: Sorting) -> [ProposalSwift] {
        return self.sorted(by: direction == .ascending ? { $0 < $1 } : { $0 > $1 })
    }
    
    /**
     Remove duplicated items from current list
     */
    func distinct() -> [ProposalSwift] {
        var result: [ProposalSwift] = []
        
        for value in self {
            if result.firstIndex(of: value) == nil {
                result.append(value)
            }
        }
        
        return result
    }
}

extension Sequence where Self: RangeReplaceableCollection, Self: RandomAccessCollection, Iterator.Element == ProposalRust {
    func filter(by value: String) -> [ProposalRust] {
        var filter: [ProposalRust] = []
        
        // Index
        let ids = self.filter {
            return String($0.index) == value
        }
        
        if ids.count > 0 {
            filter.append(contentsOf: ids)
        }
        
        // Title
        let titles = self.filter {
            guard let title = $0.beatifulTitle() else { return false }
            return title.contains(value)
        }
        
        if titles.count > 0 {
            filter.append(contentsOf: titles)
        }
        
        // Date
        
        let dates = self.filter {
            guard let date = $0.date else { return false }
            return date.contains(value)
        }
        
        if dates.count > 0 {
            filter.append(contentsOf: titles)
        }
        
        // Issues
        
        let issues = self.filter {
            guard let issues = $0.getIssuePath() else { return false }
            return issues.contains(value)
        }
        
        if issues.count > 0 {
            filter.append(contentsOf: titles)
        }
        
        return filter
    }
    
    /**
     Remove duplicated items from current list
     */
    func distinct() -> [ProposalRust] {
        var result: [ProposalRust] = []
        
        for value in self {
            if result.firstIndex(of: value) == nil {
                result.append(value)
            }
        }
        
        return result
    }
}



// MARK: - Status State Extension
extension Sequence where Self: RangeReplaceableCollection, Self: RandomAccessCollection, Iterator.Element == Bug {
    func filter(by value: String) -> [Bug] {
        var filter: [Bug] = []
        
        // ID
        let ids = self.filter { String($0.id).lowercased() == value.lowercased() }
        if ids.count > 0 {
            filter.append(contentsOf: ids)
        }
        
        // ID with prefix
        let withPrefixes = self.filter { String($0.description).lowercased() == value.lowercased() }
        if withPrefixes.count > 0 {
            filter.append(contentsOf: withPrefixes)
        }
        
        // Status
        let statuses = self.filter {
            guard let status = $0.status else { return false }
            return status.lowercased() == value.lowercased()
        }
        if statuses.count > 0 {
            filter.append(contentsOf: statuses)
        }
        
        // Resolution
        let resolutions = self.filter {
            guard let resolution = $0.resolution else { return false }
            return resolution.lowercased() == value.lowercased()
        }
        if resolutions.count > 0 {
            filter.append(contentsOf: resolutions)
        }

        return filter
    }
    
}
