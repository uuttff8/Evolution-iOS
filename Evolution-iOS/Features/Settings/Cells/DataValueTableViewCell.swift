//
//  DataValueTableViewCell.swift
//  Evolution-iOS
//
//  Created by uuttff8 on 2/19/20.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import UIKit

class DataValueTableViewCell: UITableViewCell {
    @IBOutlet weak var dataLabel: UILabel!
    @IBOutlet weak var valueLabel: UILabel!
    
    var item: Item? {
        didSet {
            self.dataLabel.text = self.item?.text
            self.valueLabel.text = self.item?.value
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
