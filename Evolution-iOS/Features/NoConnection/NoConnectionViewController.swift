//
//  NoConnectionViewController.swift
//  Evolution-iOS
//
//  Created by uuttff8 on 2/10/20.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import UIKit

protocol NoConnectionDelegate: AnyObject {
    func retryConnection()
}

class NoConnectionViewController: UIViewController, Storyboarded {
    
    weak var delegate: NoConnectionDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func noConnectionButton(_ sender: UIButton) {
        delegate?.retryConnection()
    }
}
