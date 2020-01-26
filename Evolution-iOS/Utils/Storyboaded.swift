//
//  Storyboaded.swift
//  Evolution-iOS
//
//  Created by uuttff8 on 1/26/20.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import UIKit

enum AppStoryboards: String {
    case ProposalsList = "ProposalsList"
}

protocol Storyboarded {
    static func instantiate(from storyboardId: AppStoryboards) -> Self
}

extension Storyboarded where Self: UIViewController {
    static func instantiate(from storyboardId: AppStoryboards) -> Self {
        print("111asdads")

        let id = String(describing: self)
        // load our storyboard
        var storyboard: UIStoryboard
        
        switch storyboardId {
        case .ProposalsList:
            storyboard = UIStoryboard(name: AppStoryboards.ProposalsList.rawValue, bundle: Bundle.main)
            print(storyboard)
        }
        // instantiate a view controller with that identifier, and force cast as the type that was requested
        return storyboard.instantiateViewController(withIdentifier: id) as! Self
    }

}
