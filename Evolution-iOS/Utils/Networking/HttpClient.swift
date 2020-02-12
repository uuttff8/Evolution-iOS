//
//  HttpClient.swift
//  Evolution-iOS
//
//  Created by uuttff8 on 1/29/20.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import Foundation

enum CustomHttpError: Error {
    case fail
}

protocol HTTPClientProvider {
    func get(url: URL, completion: @escaping ((Result<Data, CustomHttpError>) -> ()))
    func post(url: URL, params: [String: Any], completion: @escaping ((Result<Data, CustomHttpError>)-> ()))
}

final class HTTPClient: HTTPClientProvider {
    
    func get(url: URL, completion: @escaping ((Result<Data, CustomHttpError>) -> ())) {
        let request = URLRequest(url: url)
        URLSession.shared.dataTask(with: request) { (data: Data?, response: URLResponse?, error: Error?) in
            if let data = data {
                completion(.success(data))
            }
        }.resume()
    }
    
    func post(url: URL, params: [String: Any], completion: @escaping ((Result<Data, CustomHttpError>)-> ())) {
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let jsonData = try? JSONSerialization.data(withJSONObject: params, options: .prettyPrinted)
        request.httpBody = jsonData
        URLSession.shared.dataTask(with: request) { (data: Data?, response: URLResponse?, error: Error?) in
            if let data = data {
                completion(.success(data))
            }
        }.resume()
    }
}
