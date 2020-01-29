//
//  HttpClient.swift
//  Evolution-iOS
//
//  Created by uuttff8 on 1/29/20.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import Combine
import Foundation

protocol HTTPClientProvider {
    func get(url: URL) -> AnyPublisher<Data?, URLError>
    func post(url: URL, params: [String: Any]) -> AnyPublisher<Data?, Never>
}

final class HTTPClient: HTTPClientProvider {
    func get(url: URL) -> AnyPublisher<Data?, URLError> {
        let request = URLRequest(url: url)
        return URLSession.shared.dataTaskPublisher(for: request)
            .map { Optional.init($0.data) }
            .eraseToAnyPublisher()
    }
    
    func post(url: URL, params: [String: Any]) -> AnyPublisher<Data?, Never> {
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let jsonData = try? JSONSerialization.data(withJSONObject: params, options: .prettyPrinted)
        request.httpBody = jsonData
        return URLSession.shared.dataTaskPublisher(for: request)
            .map { Optional.init($0.data) }
            .replaceError(with: nil)
            .eraseToAnyPublisher()
    }
}
