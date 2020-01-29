//
//  Proposals.swift
//  Evolution-iOS
//
//  Created by uuttff8 on 1/29/20.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import Foundation

struct Proposals: Decodable {
    let proposal: Array<Proposal>
}

struct Proposal: Decodable {
    let title: String
    let id: String // change to int
    let date: String
    let issue: String
}
