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
            createStoryboard(AppStoryboards.ProposalsContainer)
        case .ProposalsRust:
            createStoryboard(AppStoryboards.ProposalsRust)
        case .ProposalsSwift:
            createStoryboard(AppStoryboards.ProposalsSwift)
        case .NoConnection:
            createStoryboard(AppStoryboards.NoConnection)
        }
                
        // instantiate a view controller with that identifier, and force cast as the type that was requested
        return storyboard.instantiateViewController(withIdentifier: id) as! Self
    }
}
