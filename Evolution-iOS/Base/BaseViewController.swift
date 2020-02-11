//
//  BaseViewController.swift
//  Evolution-iOS
//
//  Created by uuttff8 on 1/26/20.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import UIKit
import Combine

class NetViewController: UIViewController {
    
    var cancellable = Set<AnyCancellable>()
    
    lazy var noConnectionView: NoConnectionViewController = {
        return NoConnectionViewController.instantiate(from: AppStoryboards.NoConnection)
    }()
    
    var showNoConnection: Bool = false {
        didSet {
            DispatchQueue.main.async { [unowned self] in
                self.noConnectionView.view.isHidden = !self.showNoConnection
            }
        }
    }
    
    var alert: UIAlertController {
        let alert = UIAlertController(title: nil, message: "Please wait...", preferredStyle: .alert)
        let loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50))
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.style = UIActivityIndicatorView.Style.medium
        loadingIndicator.startAnimating();
        
        alert.view.addSubview(loadingIndicator)
        
        return alert
    }
    
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        
        refreshControl.tintColor = UIColor.Generic.darkGray
        
        return refreshControl
    }()
}
