//
//  UserDefaultsService.swift
//  Evolution-iOS
//
//  Created by uuttff8 on 2/15/20.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import Foundation

class UserDefaultsService {
    
    static var shared = UserDefaultsService()
    
    enum KEYS: String {
        case DOWN_FONT_SIZE = "DOWN_FONT_SIZE"
    }
    
    func clear() {
        guard let bundleID = Bundle.main.bundleIdentifier else { return }
        UserDefaults.standard.removePersistentDomain(forName: bundleID)
    }
    
    func clearOnlyDownFontSize() {
        let fontSizeKey = UserDefaultsService.KEYS.DOWN_FONT_SIZE.rawValue
        UserDefaults.standard.removeObject(forKey: fontSizeKey)
    }
    
    var downFontSize: String {
        get { return UserDefaults.standard.string(forKey: UserDefaultsService.KEYS.DOWN_FONT_SIZE.rawValue) ?? "0.9" }
        set (newValue) { UserDefaults.standard.set(newValue, forKey: UserDefaultsService.KEYS.DOWN_FONT_SIZE.rawValue) }
    }
}
