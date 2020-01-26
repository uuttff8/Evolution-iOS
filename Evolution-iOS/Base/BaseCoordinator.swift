//
//  BaseCoordinator.swift
//  Evolution-iOS
//
//  Created by uuttff8 on 1/26/20.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import Foundation

class BaseCoordinator<BaseView> {
  
    var presenterView: BaseView?
    
    func onCreate(view: BaseView) {
        self.presenterView = view
    }

    func onDestroy() {
        self.presenterView = nil
    }
    
    func printDada(response: Data) {
        print(String(data: response, encoding: .utf8) ?? "")
    }
}
