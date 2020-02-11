//
//  UICollectionView+Ext.swift
//  Evolution-iOS
//
//  Created by uuttff8 on 2/11/20.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import UIKit

extension UICollectionView {
    
    func registerNib<T: UICollectionViewCell>(withClass cellClass: T.Type) {
        register(
            Config.Nib.loadNib(name: T.cellIdentifier),
            forCellWithReuseIdentifier: T.cellIdentifier
        )
    }
    
    func registerClass<T: UICollectionViewCell>(_ cellClass: T.Type) {
        register(
            cellClass.self,
            forCellWithReuseIdentifier: cellClass.cellIdentifier
        )
    }
    
    func cell<T: ReusableCellIdentifiable>(forItemAt indexPath: IndexPath) -> T {
        return dequeueReusableCell(withReuseIdentifier: T.cellIdentifier,
                                   for: indexPath) as! T
    }
    
}
