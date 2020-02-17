//
//  SwiftProposals.swift
//  Evolution-iOS
//
//  Created by uuttff8 on 2/5/20.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import UIKit

// MARK: - Swift Proposals Models

struct ProposalSwift: Decodable {
    let id: Int
    let title: String
    let status: Status
    let summary: String?
    let authors: [Person]?
    let warnings: [Warning]?
    let link: String?
    let reviewManager: Person?
    let sha: String?
    let bugs: [Bug]?
    let implementations: [Implementation]?
    
    enum Keys: String, CodingKey {
        case status
        case summary
        case authors
        case id
        case title
        case warnings
        case link
        case reviewManager
        case sha
        case trackingBugs
        case implementation
    }
    
    init(id: Int, link: String) {
        self.id                 = id
        self.link               = link
        self.title              = ""
        self.status             = Status(version: nil, state: .accepted, start: nil, end: nil)
        self.summary            = nil
        self.authors            = nil
        self.warnings           = nil
        self.reviewManager      = nil
        self.sha                = nil
        self.bugs               = nil
        self.implementations    = nil
    }
    
}

extension ProposalSwift {
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: Keys.self)
        
        let idString = try container.decode(String.self, forKey: .id)
        self.id = ProposalIDFormatter.format(unboxedValue: idString)
        
        self.title              = try container.decode(String.self, forKey: .title)
        self.status             = try container.decode(Status.self, forKey: .status)
        self.summary            = try container.decodeIfPresent(String.self, forKey: .summary)
        self.authors            = try container.decodeIfPresent([Person].self, forKey: .authors)
        self.warnings           = try container.decodeIfPresent([Warning].self, forKey: .warnings)
        self.link               = try container.decodeIfPresent(String.self, forKey: .link)
        self.reviewManager      = try container.decodeIfPresent(Person.self, forKey: .reviewManager)
        self.sha                = try container.decodeIfPresent(String.self, forKey: .sha)
        self.bugs               = try container.decodeIfPresent([Bug].self, forKey: .trackingBugs)
        self.implementations    = try container.decodeIfPresent([Implementation].self, forKey: .implementation)
    }
    
}

private struct ProposalIDFormatter {
    static func format(unboxedValue: String) -> Int {
        let id: Int = unboxedValue.regex(Config.Common.Regex.proposalID)
        return id
    }
}

extension ProposalSwift: CustomStringConvertible {
    var description: String {
        return String(format: "SE-%04i", self.id)
    }
}

extension ProposalSwift: Comparable {
    public static func == (lhs: ProposalSwift, rhs: ProposalSwift) -> Bool {
        return lhs.id == rhs.id
    }
    
    public static func < (lhs: ProposalSwift, rhs: ProposalSwift) -> Bool {
        return lhs.id < rhs.id
    }
    
    public static func <= (lhs: ProposalSwift, rhs: ProposalSwift) -> Bool {
        return lhs.id <= rhs.id
    }
    
    public static func >= (lhs: ProposalSwift, rhs: ProposalSwift) -> Bool {
        return lhs.id >= rhs.id
    }
    
    public static func > (lhs: ProposalSwift, rhs: ProposalSwift) -> Bool {
        return lhs.id > rhs.id
    }
}


struct Person: Decodable {
    var id: String?
    let name: String?
    let link: String?
    let username: String?

    // These properties will not come from server
    var github: GithubProfile?
    var asAuthor: [ProposalSwift]?
    var asManager: [ProposalSwift]?
    
    enum Keys: String, CodingKey {
        case id
        case name
        case link
    }
    
}

extension Person: Searchable {
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: Keys.self)
        self.id = try container.decodeIfPresent(String.self, forKey: .id)
        self.name = try container.decodeIfPresent(String.self, forKey: .name)
        self.link = try container.decodeIfPresent(String.self, forKey: .link)
        self.username = GithubUserFormatter.format(unboxedValue: self.link)
    }
    
}

struct GithubUserFormatter {
    static func format(unboxedValue: String?) -> String? {
        guard let unboxedValue = unboxedValue else { return nil }
        let values = unboxedValue.components(separatedBy: "/").filter { $0 != "" }
        if values.count > 0, let value = values.last {
            return value
        }

        return nil
    }
}


struct GithubProfile: Codable {
    let login: String
    let id: Int
    let avatar: String?
    let gravatar: String?
    let bio: String?
    
    enum Keys: String, CodingKey {
        case login
        case id
        case avatar_url
        case gravatar_url
        case bio
    }
}

enum ImplementationType: String, Codable {
    case commit
    case pull
}

struct Implementation: Decodable {
    let type: ImplementationType
    let id: String
    let repository: String
    let account: String
}


extension Implementation: CustomStringConvertible {
    var description: String {
        var content: String = ""
        
        switch self.type {
        case .pull:
            content = "\(repository)#\(id)"
            
        case .commit:
            let index = id.index(id.startIndex, offsetBy: 7)
            let hash = id.prefix(upTo: index)
            
            content = "\(repository)@\(hash)"
            
        }
        return content
    }
    
    var path: String {
        return "\(account)/\(repository)/\(type.rawValue)/\(id)"
    }
}

extension Implementation: Equatable {
    public static func == (lhs: Implementation, rhs: Implementation) -> Bool {
        return lhs.path == rhs.path
    }
}



struct Bug: Codable {
    let id: Int
    let status: String?
    let updated: Date?
    let title: String?
    let link: String?
    let radar: String?
    let assignee: String?
    let resolution: String?
    
    enum Keys: String, CodingKey {
        case id
        case status
        case title
        case link
        case radar
        case resolution
        case assignee
        case updated
    }
    
}

extension Bug {
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: Keys.self)
        self.status = try container.decodeIfPresent(String.self, forKey: .status)
        self.title = try container.decodeIfPresent(String.self, forKey: .title)
        self.link = try container.decodeIfPresent(String.self, forKey: .link)
        self.radar = try container.decodeIfPresent(String.self, forKey: .radar)
        self.assignee = try container.decodeIfPresent(String.self, forKey: .assignee)
        self.resolution = try container.decodeIfPresent(String.self, forKey: .resolution)
        let idString = try container.decode(String.self, forKey: .id)
        self.id = BugIDFormatter.format(unboxedValue: idString)
        if let dateString = try container.decodeIfPresent(String.self, forKey: .updated) {
            let dateFormatter = Config.Date.Formatter.iso8601
            self.updated = dateFormatter.date(from: dateString)
        }
        else {
            self.updated = nil
        }
    }
    
}

struct BugIDFormatter {
    static func format(unboxedValue: String) -> Int {
        let id: Int = unboxedValue.regex(Config.Common.Regex.bugID)
        return id
    }
}


extension Bug: CustomStringConvertible {
    var description: String {
        return String(format: "SR-\(self.id)")
    }
}


struct Status: Decodable {
    let version: Version?
    let state: StatusState
    let start: Date?
    let end: Date?
    
    enum StatusKeys: String, CodingKey {
        case version
        case state
        case start
        case end
    }
}


enum ServerError: Error {
    case unknownState
}

extension Status {
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: StatusKeys.self)
        
        version = try container.decodeIfPresent(String.self, forKey: .version)
        
        let stateString = try container.decode(String.self, forKey: .state)
        let desiredState = State(stateString)
        
        guard let validState = StatusState(rawValue: desiredState) else {
            throw ServerError.unknownState
        }
        state = validState
        
        let dateFormatter = Config.Date.Formatter.yearMonthDay
        if let startDate = try container.decodeIfPresent(String.self, forKey: .start) {
            start = dateFormatter.date(from: startDate)
        }
        else {
            start = nil
        }
        
        if let endDate = try container.decodeIfPresent(String.self, forKey: .end) {
            end = dateFormatter.date(from: endDate)
        }
        else {
            end = nil
        }
    }
    
}

struct Warning: Codable {
    let message: String?
    let stage: String?
    let kind: String?
}

public enum StatusState {
    case awaitingReview
    case scheduledForReview
    case activeReview
    case returnedForRevision
    case withdrawn
    case deferred
    case accepted
    case acceptedWithRevisions
    case rejected
    case implemented
    case error
    
}

extension StatusState: RawRepresentable {
    public typealias RawValue = State
    
    public init?(_ state: StatusState) {
        self = state
    }
    
    public init?(rawValue: RawValue) {
        switch rawValue.identifier {
        case ".awaitingReview":
            self = .awaitingReview
        case ".scheduledForReview":
            self = .scheduledForReview
        case ".activeReview":
            self = .activeReview
        case ".returnedForRevision":
            self = .returnedForRevision
        case ".withdrawn":
            self = .withdrawn
        case ".deferred":
            self = .deferred
        case ".accepted":
            self = .accepted
        case ".acceptedWithRevisions":
            self = .acceptedWithRevisions
        case ".rejected":
            self = .rejected
        case ".implemented":
            self = .implemented
        case ".error":
            self = .error
            
        default:
            return nil
        }
    }
    
    public var rawValue: RawValue {
        switch self {
        case .awaitingReview:
            return State(name: "Awaiting Review", shortName: "Awaiting Review", className: "awaiting-review", identifier: ".awaitingReview", color: UIColor.Status.awaitingReview)
            
        case .scheduledForReview:
            return State(name: "Scheduled for Review", shortName: "Scheduled", className: "scheduled-for-review", identifier: ".scheduledForReview", color: UIColor.Status.scheduledForReview)
            
        case .activeReview:
            return State(name: "Active Review", shortName: "Active Review", className: "active-review", identifier: ".activeReview", color: UIColor.Status.activeReview)
            
        case .returnedForRevision:
            return State(name: "Returned for Revision", shortName: "Returned", className: "returned-for-revision", identifier: ".returnedForRevision", color: UIColor.Status.returnedForRevision)
            
        case .withdrawn:
            return State(name: "Withdrawn", shortName: "Withdrawn", className: "withdrawn", identifier: ".withdrawn", color: UIColor.Status.withdrawn)
            
        case .deferred:
            return State(name: "Deferred", shortName: "Deferred", className: "deferred", identifier: ".deferred", color: UIColor.Status.deferred)
            
        case .accepted:
            return State(name: "Accepted", shortName: "Accepted", className: "accepted", identifier: ".accepted", color: UIColor.Status.accepted)
            
        case .acceptedWithRevisions:
            return State(name: "Accepted with Revisions", shortName: "Accepted with Revisions", className: "accepted-with-revisions", identifier: ".acceptedWithRevisions", color: UIColor.Status.acceptedWithRevisions)
            
        case .rejected:
            return State(name: "Rejected", shortName: "Rejected", className: "rejected", identifier: ".rejected", color: UIColor.Status.rejected)
            
        case .implemented:
            return State(name: "Implemented", shortName: "Implemented", className: "implemented", identifier: ".implemented", color: UIColor.Status.implemented)
            
        case .error:
            return State(name: "Error", shortName: "Error", className: "error", identifier: ".error", color: UIColor.clear)
        }
    }
}

extension StatusState: CustomStringConvertible {
    public var description: String {
        return self.rawValue.shortName
    }
}

typealias Version = String

public struct State {
    let name: String
    let shortName: String
    let className: String
    let identifier: String
    let color: UIColor
    
    public init(_ identifier: String) {
        self.name = ""
        self.shortName = ""
        self.className = ""
        self.identifier = identifier
        self.color = UIColor.clear
    }
    
    public init(name: String? = nil, shortName: String? = nil, className: String? = nil, identifier: String, color: UIColor = UIColor.clear) {
        self.name = name ?? ""
        self.shortName = shortName ?? ""
        self.className = className ?? ""
        self.identifier = identifier
        self.color = color
    }
}


//struct User: Codable {
//    let id: String
//    let tags: [Notifications.Tag]?
//    var notifications: Bool?
//    let createdAt: Date?
//    let updatedAt: Date?
//
//    enum CodingKeys: String, CodingKey {
//        case id = "ckID"
//        case tags
//        case createdAt
//        case updatedAt
//        case notifications
//    }
//
//    init(id: String, tags: [Notifications.Tag]? = nil, notifications: Bool = true) {
//        self.id             = id
//        self.tags           = tags
//        self.notifications  = notifications
//        self.createdAt      = nil
//        self.updatedAt      = nil
//    }
//}
//
//extension User {
//    static var current: User? {
//        let bundleID = Environment.bundleID ?? "io.swift-evolution.app"
//        let keychain = Keychain(service: bundleID).synchronizable(true)
//
//        guard let token = try? keychain.getString("currentUser") else {
//            return nil
//        }
//
//
//        return User(id: token)
//    }
//}
//
//struct Notifications {}
//
//extension Notifications {
//    struct Tag: Codable {
//        let id: String
//        let name: String
//        let identifier: String
//        let subscribed: Bool?
//
//        enum CodingKeys: String, CodingKey {
//            case id = "_id"
//            case name
//            case identifier
//            case subscribed
//        }
//    }
//}
