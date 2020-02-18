//
//  AboutDetailOpenSourceCoordinator.swift
//  Evolution-iOS
//
//  Created by uuttff8 on 2/17/20.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import UIKit

class AboutDetailOpenSourceCoordinator: Coordinator {
    var navigationController: UINavigationController?
    var childCoordinators = [Coordinator]()
    
    var aboutData: Section
        
    init(navigationController: UINavigationController?, aboutData: Section) {
        self.navigationController = navigationController
        self.aboutData = aboutData
    }
    
    func start() {
        let vc = AboutDetailOpenSourceViewController.instantiate(from: AppStoryboards.AboutOpenSource)
        vc.coordinator = self
        vc.about = self.aboutData
        navigationController?.pushViewController(vc, animated: true)
    }
}
