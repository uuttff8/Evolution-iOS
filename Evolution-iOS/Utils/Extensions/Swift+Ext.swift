//
//  Swift+Ext.swift
//  Evolution-iOS
//
//  Created by uuttff8 on 2/11/20.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import Foundation

extension Array where Element: Equatable {
    func removeDuplicates() -> [Element] {
        var result: [Element] = []
        
        for value in self {
            if !result.contains(value) {
                result.append(value)
            }
        }
        
        return result
    }
}

extension Array {
    func shuffle() -> [Element] {
        var list = self
        list.sort { (_, _) in
            arc4random() < arc4random()
        }
        
        return list
    }
}
