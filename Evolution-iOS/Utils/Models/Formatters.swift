//
//  Formatters.swift
//  Evolution-iOS
//
//  Created by uuttff8 on 08.11.2021.
//  Copyright © 2021 Anton Kuzmin. All rights reserved.
//

import Foundation

struct GithubUserFormatter {
    static func format(unboxedValue: String?) -> String? {
        guard let unboxedValue = unboxedValue else { return nil }
        let values = unboxedValue.components(separatedBy: "/").filter { $0 != "" }
        if values.count > 0, let value = values.last {
            return value
        }

        return nil
    }
}


struct ProposalIDFormatter {
    static func format(unboxedValue: String) -> Int {
        let id: Int = unboxedValue.regex(Config.Common.Regex.proposalID)
        return id
    }
}

struct BugIDFormatter {
    static func format(unboxedValue: String) -> Int {
        let id: Int = unboxedValue.regex(Config.Common.Regex.bugID)
        return id
    }
}
