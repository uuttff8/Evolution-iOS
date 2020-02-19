//
//  ProposalsRustTableViewCell.swift
//  Evolution-iOS
//
//  Created by uuttff8 on 2/4/20.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import UIKit

class ProposalsRustTableViewCell: UITableViewCell {

    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var index: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var issue: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func initialize(with proposal: ProposalRust?) {
        if let proposal = proposal {
            title.text = proposal.beatifulTitle()
            index.text = proposal.index
            date.text  = proposal.date
            
            print(proposal.issue)
            issue.text = proposal.getIssuePath()
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func prepareForReuse() {
        // BUG: Unexpectedly found nil while implicitly unwrapping an Optional value: file Features/ProposalsList/ProposalsListViewController.swift, cellForRowAt
//        title = nil
//        index = nil
//        date = nil
//        issue = nil
    }

}
