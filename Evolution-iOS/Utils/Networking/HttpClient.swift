//
//  HttpClient.swift
//  Evolution-iOS
//
//  Created by uuttff8 on 1/29/20.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import Foundation

// MARK: - Service Result
enum ServiceResult<T> {
    case failure(Error)
    case success(T)
    
    var value: T? {
        switch self {
        case .success(let value):
            return value
        case .failure:
            return nil
        }
    }
    
    var error: Error? {
        switch self {
        case .success:
            return nil
        case .failure(let error):
            return error
        }
    }
    
    func flatMap<U>(closure: (T) throws -> U?)-> ServiceResult<U> {
        switch self {
        case .failure(let error):
            return .failure(error)
        case .success(let value):
            do {
                if let newValue = try closure(value) {
                    return .success(newValue)
                }
                else {
                    return .failure(ServiceError.invalidResponse)
                }
            }
            catch {
                return .failure(error)
            }
            
        }
    }
}

// MARK: - Errors
enum ServiceError: Error {
    case unknownState
    case invalidURL(String)
    case invalidResponse
    
    static func fail<T>(with error: ServiceError = .unknownState, _ closure: (ServiceResult<T>) -> Void) {
        assertionFailure("we should get an error or a data here")
        closure(.failure(error))
    }
}

protocol HTTPClientProvider {
    func get(url: URL, completion: @escaping ((Result<Data, ServiceError>) -> ()))
    func post(url: URL, params: [String: Any], completion: @escaping ((Result<Data, ServiceError>)-> ()))
}

final class HTTPClient: HTTPClientProvider {
    
    func get(url: URL, completion: @escaping ((Result<Data, ServiceError>) -> ())) {
        let request = URLRequest(url: url)
        URLSession.shared.dataTask(with: request) { (data: Data?, response: URLResponse?, error: Error?) in
            if let data = data {
                completion(.success(data))
            }
        }.resume()
    }
    
    func post(url: URL, params: [String: Any], completion: @escaping ((Result<Data, ServiceError>)-> ())) {
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
