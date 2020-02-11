//
//  ProposalListHeaderTableViewCell.swift
//  Evolution-iOS
//
//  Created by uuttff8 on 2/11/20.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import UIKit

final class ProposalListHeaderTableViewCell: UITableViewCell {
    
    // MARK: - Outlets
    
    @IBOutlet private weak var proposalsCountLabel: UILabel!
    
    // MARK: - Internal Attributes
    
    var proposalCount: Int = 0 {
        didSet {
            proposalsCountLabel.text = "\(proposalCount) proposals"
        }
    }
    
    var header: String? = "" {
        didSet {
            proposalsCountLabel.text = header
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        contentView.backgroundColor = UIColor(named: "SecBgColor")
    }
    
}

