//
//  Implementation.swift
//  Evolution-iOS
//
//  Created by uuttff8 on 08.11.2021.
//  Copyright © 2021 Anton Kuzmin. All rights reserved.
//

import Foundation

enum ImplementationType: String, Codable {
    case commit
    case pull
}

struct Implementation: Decodable {
    let type: ImplementationType
    let id: String
    let repository: String
    let account: String
}

extension Implementation: CustomStringConvertible {
    var description: String {
        var content: String = ""
        
        switch self.type {
        case .pull:
            content = "\(repository)#\(id)"
            
        case .commit:
            let index = id.index(id.startIndex, offsetBy: 7)
            let hash = id.prefix(upTo: index)
            
            content = "\(repository)@\(hash)"
            
        }
        return content
    }
    
    var path: String {
        return "\(account)/\(repository)/\(type.rawValue)/\(id)"
    }
}

extension Implementation: Equatable {
    public static func == (lhs: Implementation, rhs: Implementation) -> Bool {
        return lhs.path == rhs.path
    }
}

extension Sequence where Self: RangeReplaceableCollection, Self: RandomAccessCollection, Iterator.Element == Implementation {
    func get(by path: String) -> Implementation? {
        guard let index = self.firstIndex(where: { $0.path == path }) else {
            return nil
        }
        
        return self[index]
    }
    
    func index(of implementation: Implementation) -> Int? {
        return self.firstIndex(where: { $0 == implementation }) as? Int
    }
}

extension Sequence where Self: RangeReplaceableCollection, Self: RandomAccessCollection, Iterator.Element == Person {
    func filter(by value: String) -> [Person] {
        var filter: [Person] = []
        
        // Names
        let names = self.filter {
            guard let name = $0.name else { return false }
            return name.contains(value)
        }
        if names.count > 0 {
            filter.append(contentsOf: names)
        }
        
        // Users
        let users = self.filter {
            guard let name = $0.username else { return false }
            return name.contains(value)
        }
        if users.count > 0 {
            filter.append(contentsOf: users)
        }
        
        return filter
    }
    
    func get(username: String) -> Person? {
        guard let index = self.firstIndex(where: {
            guard let user = $0.username, username != "" else {
                return false
            }
            return user == username
        }) else {
            return nil
        }

        return self[index]
    }
    
    func get(name: String) -> Person? {
        guard let index = self.firstIndex(where: {
            guard let user = $0.name, name != "" else {
                return false
            }
            return user == name
        }) else {
            return nil
        }
        
        return self[index]
    }
    
    func get(id: String) -> Person? {
        guard let index = self.firstIndex(where: {
            guard let user = $0.id, id != "" else {
                return false
            }
            return user == id
        }) else {
            return nil
        }
        
        return self[index]
    }


}
