//
//  URL.swift
//  Evolution-iOS
//
//  Created by uuttff8 on 2/10/20.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import Foundation

extension URL {
    subscript(parameter: String) -> String? {
        guard let components = URLComponents(string: self.absoluteString) else {
            return nil
        }
        
        guard let query = components.queryItems else {
            return nil
        }
        
        guard let param = query.first(where: { $0.name == parameter }), let value = param.value else {
            return nil
        }
        
        return value
    }
}
