//
//  ProposalsSiwftTableViewCell.swift
//  Evolution-iOS
//
//  Created by uuttff8 on 2/7/20.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import UIKit
import SwiftRichString

class ProposalsSwiftTableViewCell: UITableViewCell {
    @IBOutlet weak var detalisLabel: UITextView!
    @IBOutlet weak var statusIndicatorView: UIView!
    @IBOutlet weak var statusLabel: StatusLabel!
    
    @IBOutlet weak var statusLabelWidthConstraint: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
