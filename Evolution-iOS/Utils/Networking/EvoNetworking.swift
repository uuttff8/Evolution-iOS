//
//  EvoNetworking.swift
//  Evolution-iOS
//
//  Created by uuttff8 on 1/29/20.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import Foundation
import Combine

protocol MLApiLinksProvider {
    func fetchLinks(url: String, userCountry: String) -> AnyPublisher<Proposals?, Never>
}

protocol MLApiProvider: MLApiLinksProvider { }

final class MLApi: MLApiProvider {
    private struct Constants {
        static let apiUrl: String = "http://34.90.185.88:8000/"
    }
    
    private let httpClient: HTTPClientProvider
    
    init(httpClient: HTTPClientProvider = HTTPClient()) {
        self.httpClient = httpClient
    }
    
    func fetchLinks(url: String, userCountry: String) -> AnyPublisher<Proposals?, Never> {
        let url = URL(string: Constants.apiUrl + "proposals")
        return httpClient.get(url: url!)
            .retry(1)
            .map { data -> Proposals? in
                guard let data = data,
                let response = try? JSONDecoder().decode(Proposals.self, from: data) else {
                    return nil
            }
            return response
        }
        .replaceError(with: nil)
        .eraseToAnyPublisher()
    }
}
