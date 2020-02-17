//
//  Section.swift
//  Evolution-iOS
//
//  Created by uuttff8 on 2/16/20.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import Foundation

enum SectionType: String {
    // About
    case mainDeveloper = "Main Developer"
    case contributors = "Contributors"
    case licenses = "Licenses"
    case evolution = "Evolution App"
    case swiftEvolution = "Swift Evolution"
    case thanks = "Thanks to"
    
    // Settings
    case notifications = "Notifications"
    case openSource = "Open Source"
    case authors = "Authors"
}

// MARK: -
enum Type: String {
    case github = "github.com"
    case twitter = "twitter.com"
    case url
    case email
    case undefined
}

// MARK: - ItemProtocols
protocol ItemProtocol {
    var text: String { get set }
    var type: Type { get  set }
    var value: String { get set }
}

struct Contributor: ItemProtocol {
    var text: String
    var type: Type
    var value: String
}

struct License: ItemProtocol {
    var text: String
    var type: Type
    var value: String
}

struct Item: ItemProtocol {
    var text: String
    var type: Type
    var value: String
}

struct Subscription: ItemProtocol {
    var text: String
    var type: Type
    var value: String
    var subscribed: Bool
}

// MARK: -
struct Section {
    var section: SectionType
    var items: [ItemProtocol]
    var footer: String?
    var grouped: Bool
}

extension ItemProtocol {
    var media: String {
        switch type {
        case .github, .twitter:
            return "\(type.rawValue)/\(value)"
        default:
            return value
        }
    }
}

// MARK: - Equatable
extension ItemProtocol where Self: Equatable {
    static func == (lhs: Self, rhs: Self) -> Bool {
        return lhs.text == rhs.text
    }
}

// MARK: - Contributor Extension
extension Contributor {
    func picture(_ width: Int = 200) -> String {
        return "https://avatars.githubusercontent.com/\(self.value)?size=\(width)"
    }
}

extension SectionType: CustomStringConvertible {
    var description: String {
        return self.rawValue
    }
}
