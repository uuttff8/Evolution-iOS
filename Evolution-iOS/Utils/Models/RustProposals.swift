//
//  RustProposals.swift
//  Evolution-iOS
//
//  Created by uuttff8 on 1/29/20.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import UIKit

// MARK: - Rust Proposals Models

struct ProposalsRust: Decodable {
    var proposals: Array<ProposalRust>
}

struct ProposalRust: Decodable {
    let title: String?
    let index: String? 
    let date: String?
    let issue: String?
}
