//
//  AboutOpenSourceData.swift
//  Evolution-iOS
//
//  Created by uuttff8 on 2/17/20.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import Foundation

struct AboutOpenSourceData {
    static let shared = AboutOpenSourceData()
    
    func sectionsData() -> [Section] {
        return [
            mainDeveloper(),
            contributors(),
            licenses(),
            app(),
            swiftEvolution(),
            thanks()
        ]
    }
    
    private func mainDeveloper() -> Section {
        return Section(
            section: .mainDeveloper,
            items: [
                Contributor(
                    text: "Thiago Holanda",
                    type: .github,
                    value: "unnamedd"
                )
            ],
            footer: nil,
            grouped: false
        )
    }
    
    private func contributors() -> Section {
        let members = [
            Contributor(text: "Anton Kuzmin", type: .github, value: "uuttff8"),
            Contributor(text: "Bruno Bilescky", type: .github, value: "brunogb"),
            Contributor(text: "Bruno Guidolim", type: .github, value: "bguidolim"),
            Contributor(text: "Bruno Hecktheuer", type: .github, value: "bbheck"),
            Contributor(text: "Diego Ventura", type: .github, value: "diegoventura"),
            Contributor(text: "Diogo Tridapalli", type: .github, value: "diogot"),
            Contributor(text: "Ezequiel França", type: .github, value: "ezefranca"),
            Contributor(text: "Gustavo Barbosa", type: .github, value: "barbosa"),
            Contributor(text: "Guilherme Rambo", type: .github, value: "insidegui"),
            Contributor(text: "Leonardo Cardoso", type: .github, value: "leonardocardoso"),
            Contributor(text: "Ricardo Borelli", type: .github, value: "rabc"),
            Contributor(text: "Ricardo Olivieri", type: .github, value: "rolivieri"),
            Contributor(text: "Rob Hudson", type: .github, value: "robtimp"),
            Contributor(text: "Rodrigo Reis", type: .github, value: "digoreis"),
            Contributor(text: "Taylor Franklin", type: .github, value: "tfrank64"),
            Contributor(text: "Xaver Lohmüller", type: .github, value: "xaverlohmueller")
        ]
        
        return Section(
            section: .contributors,
            items: members,
            footer: nil,
            grouped: true
        )
    }
    
    private func licenses() -> Section {
        let items = [
            License(text: "Down", type: .github, value: "iwasrobbed/Down"),
            License(text: "SwiftRichString", type: .github, value: "malcommac/SwiftRichString"),
            License(text: "Kitura Web Framework", type: .url, value: "http://www.kitura.io/")
        ]
        
        return Section(
            section: .licenses,
            items: items,
            footer: nil,
            grouped: true
        )
    }
    
    private func app() -> Section {
        let items = [
            Item(text: "iOS App", type: .github, value: "evolution-app/ios"),
            Item(text: "Backend Swift", type: .github, value: "evolution-app/backend"),
            Item(text: "Backend Rust", type: .github, value: "uuttff8/evo-rust-backend"),
            Item(text: "Twitter", type: .twitter, value: "evoapp_io"),
            Item(text: "Feedback", type: .email, value: "feedback@evoapp.io")
        ]
        
        return Section(
            section: .evolution,
            items: items,
            footer: nil,
            grouped: false
        )
    }
    
    private func swiftEvolution() -> Section {
        let items = [
            Item(text: "Swift Language - Twitter", type: .twitter, value: "swiftlang"),
            Item(text: "Site", type: .url, value: "https://apple.github.io/swift-evolution"),
            Item(text: "Repository", type: .github, value: "apple/swift-evolution"),
            Item(text: "Forum", type: .url, value: "https://forums.swift.org/c/evolution")
        ]
        
        return Section(
            section: .swiftEvolution,
            items: items,
            footer: nil,
            grouped: false
        )
    }
    
    private func thanks() -> Section {
        let items = [
            Item(text: "Chris Bailey", type: .twitter, value: "Chris__Bailey"),
            Item(text: "Daniel Dunbar", type: .twitter, value: "daniel_dunbar"),
            Item(text: "Danilo Altheman", type: .twitter, value: "daltheman"),
            Item(text: "John Calistro", type: .twitter, value: "johncalistro"),
            Item(text: "Lisa Dziuba", type: .twitter, value: "LisaDziuba")
        ]
        
        let copyright = "Copyright (c) 2017-2018 Thiago Holanda (thiago@evoapp.io)\n\nSwift and the Swift logo are trademarks of Apple Inc., registered in the U.S. and other countries."
        return Section(
            section: .thanks,
            items: items,
            footer: copyright,
            grouped: false
        )
    }
}
