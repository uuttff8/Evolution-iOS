//
//  Storyboaded.swift
//  Evolution-iOS
//
//  Created by uuttff8 on 1/26/20.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import UIKit

enum AppStoryboards: String {
    case ProposalsContainer = "ProposalsContainer"
    case ProposalsRust = "ProposalsRust"
    case ProposalsSwift = "ProposalsSwift"
    case NoConnection = "NoConnection"
    case ProposalDetail = "ProposalDetail"
    case Settings = "Settings"
    case AboutOpenSource = "AboutOpenSource"
}

protocol Storyboarded {
    static func instantiate(from storyboardId: AppStoryboards) -> Self
}

extension Storyboarded where Self: UIViewController {
    static func instantiate(from storyboardId: AppStoryboards) -> Self {
        let id = String(describing: self)
        // load our storyboard
        var storyboard: UIStoryboard!
        
        func createStoryboard(_ sb: AppStoryboards) {
            storyboard = UIStoryboard(name: sb.rawValue, bundle: Bundle.main)
            print("UIStoryboard: \(storyboard.value(forKey: "name") ?? "Error! Unknown class")")
        }
        
        // TODO(uuttff8): Refactor
        switch storyboardId {
        case .ProposalsContainer:
            createStoryboard(storyboardId)
        case .ProposalsRust:
            createStoryboard(storyboardId)
        case .ProposalsSwift:
            createStoryboard(storyboardId)
        case .NoConnection:
            createStoryboard(storyboardId)
        case .ProposalDetail:
            createStoryboard(storyboardId)
        case .Settings:
            createStoryboard(storyboardId)
        case .AboutOpenSource:
            createStoryboard(storyboardId)
        }
                
        // instantiate a view controller with that identifier, and force cast as the type that was requested
        return storyboard.instantiateViewController(withIdentifier: id) as! Self
    }
}
