//
//  Protocols.swift
//  Evolution-iOS
//
//  Created by uuttff8 on 2/5/20.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import UIKit

// MARK: - Searchable Protocol
protocol Searchable {}

// MARK: - Reusable Protocol
protocol ReusableCellIdentifiable {
    static var cellIdentifier: String { get }
}

extension ReusableCellIdentifiable where Self: UITableViewCell {
    static var cellIdentifier: String {
        return String(describing: self)
    }
}

extension ReusableCellIdentifiable where Self: UICollectionViewCell {
    static var cellIdentifier: String {
        return String(describing: self)
    }
}

extension UITableViewCell: ReusableCellIdentifiable {}
extension UICollectionViewCell: ReusableCellIdentifiable {}


