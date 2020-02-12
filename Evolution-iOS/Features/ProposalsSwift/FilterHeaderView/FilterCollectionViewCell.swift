//
//  FilterCollectionViewCell.swift
//  Evolution-iOS
//
//  Created by uuttff8 on 2/11/20.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import UIKit

class FilterCollectionViewCell: UICollectionViewCell {

    @IBOutlet private weak var statusLabel: StatusLabel!
    
    var text: String? = nil {
        didSet {
            self.statusLabel.text = text
        }
    }
    
    override var isSelected: Bool {
        didSet {
            self.statusLabel.selected = isSelected
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        self.isSelected = false
        self.statusLabel.selected = false
    }

}

