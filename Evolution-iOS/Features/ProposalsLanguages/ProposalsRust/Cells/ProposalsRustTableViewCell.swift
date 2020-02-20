//
//  ProposalsRustTableViewCell.swift
//  Evolution-iOS
//
//  Created by uuttff8 on 2/4/20.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import UIKit
import SwiftRichString

protocol ProposalRustDelegate: AnyObject {
    func didSelect(issue: String)
}

class ProposalsRustTableViewCell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var indexLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var issueLabel: UILabel!
    
    @IBOutlet weak var issueStackView: UIStackView!
    @IBOutlet weak var dateStackView: UIStackView!
    
    weak var delegate: ProposalRustDelegate?
    
    func initialize(with proposal: ProposalRust?) {
        if let proposal = proposal {
            titleLabel.text = proposal.beatifulTitle()
            indexLabel.text = proposal.index
            
            if let proposalDate = proposal.date, !proposalDate.isEmpty {
                dateLabel.text = proposalDate
            } else {
                self.dateStackView.isHidden = true
            }
            
            if let proposalIssue = proposal.getIssuePath(), !proposalIssue.isEmpty {
                issueLabel.attributedText = NSAttributedString(string: proposalIssue, attributes:
                [.underlineStyle: NSUnderlineStyle.single.rawValue])
                
            } else {
                self.issueStackView.isHidden = true
            }
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
}
