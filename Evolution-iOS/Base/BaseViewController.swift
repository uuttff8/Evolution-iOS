//
//  BaseViewController.swift
//  Evolution-iOS
//
//  Created by uuttff8 on 1/26/20.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import UIKit

class NetViewController: UIViewController {
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
