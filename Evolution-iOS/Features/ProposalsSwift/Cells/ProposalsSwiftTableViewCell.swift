//
//  ProposalsSiwftTableViewCell.swift
//  Evolution-iOS
//
//  Created by uuttff8 on 2/7/20.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import UIKit
import SwiftRichString


// MARK: - Cell Delegate
protocol ProposalSwiftDelegate: class {
    func didSelect(person: Person)
    func didSelect(proposal: ProposalSwift)
    func didSelect(implementation: Implementation)
}


class ProposalsSwiftTableViewCell: UITableViewCell {
    @IBOutlet weak var detailsLabel: UITextView!
    @IBOutlet weak var statusIndicatorView: UIView!
    @IBOutlet weak var statusLabel: StatusLabel!
    
    @IBOutlet weak var statusLabelWidthConstraint: NSLayoutConstraint!
    
    // MARK: - Initialization
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.detailsLabel.delegate = self
        // Configure links into textView
        self.detailsLabel.linkTextAttributes = [
            NSAttributedString.Key.foregroundColor: UIColor.Proposal.darkGray
        ]
    }
    
    // MARK: - Public properties
    weak open var delegate: ProposalSwiftDelegate?
    public var proposal: ProposalSwift? {
        didSet {
            self.configureElements()
        }
    }
    
    // MARK: - Layout
    private func configureElements() {
        guard let proposal = self.proposal else {
            return
        }
        
        let state = proposal.status.state.rawValue
        self.statusLabel.borderColor = state.color
        self.statusLabel.textColor = state.color
        self.statusLabel.text = state.shortName
        self.statusIndicatorView.backgroundColor = state.color
        
        // Fit size to status text
        let statusWidth = state.shortName.contraint(height: self.statusLabel.bounds.size.height,
                                                    font: self.statusLabel.font)
        self.statusLabelWidthConstraint.constant = statusWidth + 20
        
        var details = ""
        details += proposal.description.tag(.id)
        details += String.newLine
        
        let title = proposal.title.trimmingCharacters(in: .whitespacesAndNewlines).convertHTMLEntities.tag(.title)
        
        details += title
        
        if self.delegate != nil {
            
            // Render Authors
            if let authors = self.renderAuthors() {
                details += String.newLine + String.newLine
                details += authors
            }
            
            // Render Review Manager
            if let reviewer = proposal.reviewManager, var name = reviewer.name, name != "" {
                if name != "TBD", name != "N/A" {
                    name = name.tag(.anchor)
                }
                
                details += String.newLine + "Review Manager:".tag(.label) + String.doubleSpace + name
            }
            
            // Render Bugs
            if let bugs = self.renderBugs() {
                details += String.newLine + bugs
            }
            
            // Render Implemented Proposal
            if proposal.status.state == .implemented, let version = proposal.status.version {
                details += String.newLine + "Implemented in:".tag(.label) + String.doubleSpace + "Swift \(version)".tag(.value)
            }
            
            // Render Status
            if proposal.status.state == .acceptedWithRevisions ||
                proposal.status.state == .activeReview ||
                proposal.status.state == .scheduledForReview ||
                proposal.status.state == .returnedForRevision {
                
                details += String.newLine + "Status:".tag(.label) + String.doubleSpace + state.name.tag(.value)
                
                if (proposal.status.state == .activeReview ||
                    proposal.status.state == .scheduledForReview), let period = self.renderReviewPeriod() {
                    
                    details += String.newLine + period
                }
            }
            
            // Render Implementations
            if let implementations = renderImplementations() {
                details += String.newLine + implementations
            }
        }
        else {
            self.detailsLabel.isUserInteractionEnabled = false
        }
        
        let defaultStyle = Style("defaultStyle", {
            $0.lineSpacing = 5.5
            $0.hyphenationFactor = 1.0
        })
        
        // Convert all styles into text
        if let tagged = MarkupString(source: details) {
            var attributedText = tagged.render(withStyles: self.styles()).add(style: defaultStyle)
            let details = attributedText.string
            
            // Title
            attributedText = attributedText.link(title: proposal, text: details)
            
            // Authors
            if let authors = proposal.authors {
                attributedText = attributedText.link(authors, text: details)
                detailsLabel.attributedText = attributedText
            }
            
            // Review Manager
            if let reviewer = proposal.reviewManager {
                attributedText = attributedText.link(reviewer, text: details)
                detailsLabel.attributedText = attributedText
            }
            
            // Implementations
            if let implementations = proposal.implementations {
                attributedText = attributedText.link(implementations, text: details)
            }
            
            self.detailsLabel.attributedText = attributedText
        }
    }
}

// MARK: - Renders && Style
extension ProposalsSwiftTableViewCell {
    
    fileprivate func styles() -> [Style] {
        let id = Style("id", {
            $0.font = FontAttribute(.HelveticaNeue, size: 20)
            $0.color = UIColor.Proposal.lightGray
            $0.lineSpacing = 0
        })
        
        let title = Style("title", {
            $0.font = FontAttribute(.HelveticaNeue, size: 20)
            $0.color = UIColor.Proposal.darkGray
            $0.lineSpacing = 0
        })
        
        let label = Style("label", {
            $0.color = UIColor.Proposal.lightGray
            $0.font = FontAttribute(.HelveticaNeue, size: 14)
        })
        
        let value = Style("value", {
            $0.color = UIColor.Proposal.darkGray
            $0.font = FontAttribute(.HelveticaNeue, size: 14)
        })
        
        let anchor = Style("anchor", {
            $0.color = UIColor.Proposal.darkGray
            $0.font = FontAttribute(.HelveticaNeue, size: 14)
            $0.underline = UnderlineAttribute(color: UIColor.Proposal.darkGray, style: NSUnderlineStyle.single)
        })
        
        return [id, title, label, value, anchor]
    }
    
    fileprivate func renderAuthors() -> String? {
        guard let proposal = self.proposal,
            let authors = proposal.authors,
            authors.count > 0 else {
                return nil
        }
        
        let names: [String] = authors.compactMap({ $0.name != "" && $0.link != "" ? $0.name : nil })
        
        var detail = names.count > 1 ? "Authors" : "Author"
        detail = "\(detail):".tag(.label) + String.doubleSpace + names.map({ $0.tag(.anchor) }).joined(separator: ", ")
        
        return detail
    }
    
    fileprivate func renderBugs() -> String? {
        guard let proposal = self.proposal,
            let bugs = proposal.bugs,
            bugs.count > 0 else {
                return nil
        }
        
        let names: [String] = bugs.compactMap({
            if let assignee = $0.assignee, let status = $0.status {
                var issue = $0.description
                issue += " ("
                issue += assignee == "" ? "Unassigned" : assignee
                
                if status != "" {
                    issue += ", "
                    issue += status
                }
                
                issue += ")"
                
                return issue
            }
            return nil
        })
        
        var detail = names.count > 1 ? "Bugs" : "Bug"
        detail = "\(detail):".tag(.label) + String.doubleSpace + names.joined(separator: ", ").tag(.value)
        
        return detail
    }
    
    fileprivate func renderReviewPeriod() -> String? {
        guard let proposal = self.proposal,
            let startDate = proposal.status.start,
            let endDate = proposal.status.end else {
                return nil
        }
        
        let components: Set<Calendar.Component> = [.month, .day]
        let startDC = Calendar.current.dateComponents(components, from: startDate)
        let endDC = Calendar.current.dateComponents(components, from: endDate)
        
        var details = ""
        if let start = startDC.month, let end = endDC.month {
            
            details += Config.Date.Formatter.monthDay.string(from: startDate)
            details += " - "
            
            if let day = endDC.day, start == end {
                details += String(format: "%02i", day)
            }
            else {
                details += Config.Date.Formatter.monthDay.string(from: endDate)
            }
        }
        
        details = "Scheduled:".tag(.label) + String.doubleSpace + details.tag(.value)
        
        return details
    }
    
    fileprivate func renderImplementations() -> String? {
        guard let proposal = self.proposal,
            let implementations = proposal.implementations,
            implementations.count > 0 else {
                return nil
        }
        
        var detail = implementations.count > 1 ? "Implementations" : "Implementation"
        detail = "\(detail):".tag(.label) + String.doubleSpace + implementations.map({ $0.description.tag(.anchor) }).joined(separator: ", ")
        
        return detail
    }
}

// MARK: - UITextView Delegate
extension ProposalsSwiftTableViewCell: UITextViewDelegate {
    
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        return self.textView(textView, shouldInteractWith: URL, in: characterRange)
    }
    
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange) -> Bool {
        
        guard let proposal = self.proposal,
            let urlhost = URL.host,
            let host = Host(urlhost) else {
                return false
        }
        
        if host == .profile {
            let username = URL.lastPathComponent
            var person: Person?
            
            if let authors = proposal.authors, let author = authors.get(username: username) {
                person = author
            }
            
            if let manager = proposal.reviewManager, let reviewer = manager.username, reviewer == username {
                person = manager
            }
            
            if let person = person, let delegate = self.delegate {
                delegate.didSelect(person: person)
            }
        }
        else if host == .proposal, let proposal = self.proposal {
            delegate?.didSelect(proposal: proposal)
        }
        else if host == .implementation, let proposal = self.proposal, let implementations = proposal.implementations {
            guard let path = URL["path"], let value = implementations.get(by: path)  else {
                return false
            }
            
            delegate?.didSelect(implementation: value)
        }
        
        return false
    }
}



public enum Host {
    case proposal
    case profile
    case implementation
    
    init?(_ value: String?) {
        guard let value = value else {
            return nil
        }
        
        switch value {
        case "proposal":
            self = .proposal
            
        case "profile":
            self = .profile
            
        case "implementation":
            self = .implementation
            
        default:
            return nil
        }
    }
}

// MARK: - NSMutableAttributedString Extension
fileprivate extension NSMutableAttributedString {
   
   func add(style: Style, range: NSRange) -> NSMutableAttributedString {
       self.addAttributes(style.attributes, range: range)
       return self
   }
   
   func link(_ person: Person, text: String) -> NSMutableAttributedString {
       return self.link([person], text: text)
   }
   
   func link(_ people: [Person], text: String) -> NSMutableAttributedString {
       var attributed = self
       
       people.forEach { person in
           guard let username = person.username, let name = person.name else {
               return
           }
           
           if let nameRange = text.range(of: name) {
               let range = text.nsRange(from: nameRange)
               let style = Style("url") {
                   $0.linkURL = URL(string: "evo://profile/\(username)")
               }
               
               attributed = attributed.add(style: style, range: range)
           }
       }
       
       return attributed
   }
   
   func link(title proposal: ProposalSwift, text: String) -> NSMutableAttributedString {
       var attributed = self
       
       let title = proposal.title.trimmingCharacters(in: .whitespacesAndNewlines)
       if let titleRange = text.range(of: title) {
           let range = text.nsRange(from: titleRange)
           let style = Style("url") {
               $0.linkURL = URL(string: "evo://proposal/\(proposal.description)")
           }
           
           attributed = attributed.add(style: style, range: range)
       }
       
       return attributed
   }
   
   func link(_ implementations: [Implementation], text: String) -> NSMutableAttributedString {
       var attributed = self
       
       implementations.forEach { implementation in
           if let textRange = text.range(of: implementation.description) {
               let range = text.nsRange(from: textRange)
               let style = Style("url") {
                   $0.linkURL = URL(string: "evo://implementation?path=\(implementation.path)")
               }
               
               attributed = attributed.add(style: style, range: range)
           }
       }
       
       return attributed
   }
}
