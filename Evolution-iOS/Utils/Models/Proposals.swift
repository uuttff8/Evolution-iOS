//
//  Proposals.swift
//  Evolution-iOS
//
//  Created by uuttff8 on 1/29/20.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import UIKit

struct ProposalsRust: Decodable {
    let proposals: Array<ProposalRust>
}

struct ProposalRust: Decodable {
    let title: String
    let index: String // change to int
    let date: String
    let issue: String
}


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
    case asdasf
}

extension Status {
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: StatusKeys.self)
        
        version = try container.decodeIfPresent(String.self, forKey: .version)
        
        let stateString = try container.decode(String.self, forKey: .state)
        let desiredState = State(stateString)
        
        guard let validState = StatusState(rawValue: desiredState) else {
            throw ServerError.asdasf
        }
        state = validState
        
        let dateFormatter = Formatter.yearMonthDay
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

struct Formatter {
    static func custom(_ value: String) -> DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = value
        formatter.locale = Locale(identifier: "en_US")
        
        return formatter
    }
    
    static var iso8601: DateFormatter {
        return custom("yyyy-MM-dd'T'HH:mm:ss.SSS")
    }
    
    static var yearMonthDay: DateFormatter {
        return custom("yyyy-MM-dd")
    }

    static var monthDay: DateFormatter {
        return custom("MMMM dd")
    }
}
