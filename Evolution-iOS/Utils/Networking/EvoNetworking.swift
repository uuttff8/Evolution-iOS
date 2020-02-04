//
//  EvoNetworking.swift
//  Evolution-iOS
//
//  Created by uuttff8 on 1/29/20.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import Foundation
import Combine


private enum ConstantsApiUrl: String {
    case Swift = "https://data.evoapp.io/"
    case Rust = "http://34.90.185.88:8000/"
}

private protocol MLApiLinksProviderSwift {
    func fetchProposals() -> AnyPublisher<[ProposalSwift]?, Never>
}

private protocol MLApiLinksProviderRust {
    func fetchProposals() -> AnyPublisher<ProposalsRust?, Never>
}

private protocol MLApiProviderRust: MLApiLinksProviderRust { }
private protocol MLApiProviderSwift: MLApiLinksProviderSwift { }

final class MLApiImplRust: MLApiProviderRust {
        
    private let httpClient: HTTPClientProvider
    
    init(httpClient: HTTPClientProvider = HTTPClient()) {
        self.httpClient = httpClient
    }
    
    func fetchProposals() -> AnyPublisher<ProposalsRust?, Never> {
        let url = URL(string: ConstantsApiUrl.Rust.rawValue + "proposals")
        return httpClient.get(url: url!)
            .retry(1)
            .map { data -> ProposalsRust? in
                guard let data = data,
                let response = try? JSONDecoder().decode(ProposalsRust.self, from: data) else {
                    return nil
            }
            return response
        }
        .replaceError(with: nil)
        .eraseToAnyPublisher()
    }
}

final class MLApiImplSwift: MLApiProviderSwift {

    private let httpClient: HTTPClientProvider
    
    init(httpClient: HTTPClientProvider = HTTPClient()) {
        self.httpClient = httpClient
    }
    
    func fetchProposals() -> AnyPublisher<[ProposalSwift]?, Never> {
        let url = URL(string: ConstantsApiUrl.Swift.rawValue + "proposals")
        return httpClient.get(url: url!)
            .retry(1)
            .map { data -> [ProposalSwift]? in
                guard let data = data,
                let response = try? JSONDecoder().decode([ProposalSwift].self, from: data) else {
                    return nil
            }
            return response
        }
        .replaceError(with: nil)
        .eraseToAnyPublisher()
    }
}

enum MLApi {
    static let Swift = MLApiImplSwift()
    static let Rust = MLApiImplRust()
}
