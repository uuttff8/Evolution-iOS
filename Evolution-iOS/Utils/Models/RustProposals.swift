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
    let index: String
    let date: String?
    let issue: String?
    
    func getIssuePath() -> String? {
        return self.issue?.replacingOccurrences(of: "https://github.com", with: "")
    }
    
    func beatifulTitle() -> String? {
        return self.title?
            .replacingOccurrences(of: "-", with: " ")
            .dropFirst(5)
            .dropLast(3)
            .firstUppercased
    }
}

extension ProposalRust: Comparable {
    public static func == (lhs: ProposalRust, rhs: ProposalRust) -> Bool {
        return lhs.index == rhs.index
    }
    
    public static func < (lhs: ProposalRust, rhs: ProposalRust) -> Bool {
        return lhs.index < rhs.index
    }
    
    public static func <= (lhs: ProposalRust, rhs: ProposalRust) -> Bool {
        return lhs.index <= rhs.index
    }
    
    public static func >= (lhs: ProposalRust, rhs: ProposalRust) -> Bool {
        return lhs.index >= rhs.index
    }
    
    public static func > (lhs: ProposalRust, rhs: ProposalRust) -> Bool {
        return lhs.index > rhs.index
    }
}
