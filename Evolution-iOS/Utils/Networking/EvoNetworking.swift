//
//  EvoNetworking.swift
//  Evolution-iOS
//
//  Created by uuttff8 on 1/29/20.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import UIKit

private enum ConstantsApiUrl: String {
    case Swift = "https://data.evoapp.io/"
    case Rust = "http://34.90.185.88:8000/"
}

private protocol MLApiLinksProviderSwift {
    func fetchProposals(completion: @escaping ([ProposalSwift]?) -> Void)
    func proposalDetail(title: String, completion: @escaping ((String?) -> Void))
}

private protocol MLApiLinksProviderRust {
    func fetchProposals(completion: @escaping (ProposalsRust?) -> ())
    func proposalDetail(title: String, completion: @escaping ((String?) -> Void))
}

private protocol MLApiProviderRust: MLApiLinksProviderRust { }
private protocol MLApiProviderSwift: MLApiLinksProviderSwift { }

final class MLApiImplRust: MLApiProviderRust {
        
    private let httpClient: HTTPClientProvider
    
    init(httpClient: HTTPClientProvider = HTTPClient()) {
        self.httpClient = httpClient
    }
    
    func fetchProposals(completion: @escaping (ProposalsRust?) -> ()) {
        let url = URL(string: ConstantsApiUrl.Rust.rawValue + "proposals")!
        
        httpClient.get(url: url) { (res) in
            switch res {
            case .success(let data):
                let response = try? JSONDecoder().decode(ProposalsRust.self, from: data)
                completion(response)
            default:
                break
            }
        }
    }
    
    func proposalDetail(title: String, completion: @escaping ((String?) -> Void)) {
        let url = URL(string: Config.Base.URL.GitHub.markdownRust(for: title))!
        print(url)
        
        httpClient.get(url: url) { (res) in
            switch res {
            case let .success(data):
                let response: String = String.init(data: data, encoding: .utf8) ?? ""
                completion(response)
            default:
                break
            }
        }
    }

}

final class MLApiImplSwift: MLApiProviderSwift {

    private let httpClient: HTTPClientProvider
    
    init(httpClient: HTTPClientProvider = HTTPClient()) {
        self.httpClient = httpClient
    }
    
    func fetchProposals(completion: @escaping ([ProposalSwift]?) -> Void) {
        let url = URL(string: ConstantsApiUrl.Swift.rawValue + "proposals")!
        httpClient.get(url: url) { (res) in
            switch res {
            case .success(let data):
                let response = try? JSONDecoder().decode([ProposalSwift].self, from: data)
                completion((response))
            default:
                break
            }
        }
    }
    
    func proposalDetail(title: String, completion: @escaping ((String?) -> Void)) {
        let url = URL(string: Config.Base.URL.Evolution.markdown(for: title))!
        print(url)
        
        httpClient.get(url: url) { (res) in
            switch res {
            case let .success(data):
                let response: String = String.init(data: data, encoding: .utf8) ?? ""
                completion(response)
            default:
                break
            }
        }
    }
}

enum MLApi {
    static let Swift = MLApiImplSwift()
    static let Rust = MLApiImplRust()
}

extension MLApi {
    @discardableResult
    static func requestImage(_ url: String, completion: @escaping (Swift.Result<UIImage, ServerError>) -> Void) -> URLSessionDownloadTask? {
        guard let URL = URL(string: url) else {
            completion(.failure(ServerError.unknownState))
            return nil
        }
        
        let cache = URLCache.shared
        let request = URLRequest(url: URL)
        
        if let cachedResponse = cache.cachedResponse(for: request),
            let image = UIImage(data: cachedResponse.data) {
            completion(.success(image))
        }
        else {
            let session = URLSession(configuration: .default)
            let task = session.downloadTask(with: URL) { url, response, error in
                if let _ = error {
                    completion(.failure(ServerError.unknownState))
                }
                else if let validURL = url,
                    let response = response,
                    let data = try? Data(contentsOf: validURL),
                    let image = UIImage(data: data) {
                    
                    let cachedData = CachedURLResponse(response: response, data: data)
                    cache.storeCachedResponse(cachedData, for: request)
                    completion(.success(image))
                }
                else {
                    completion(.failure(ServerError.unknownState))
                }
            }
            task.resume()
            return task
        }
        
        return nil
    }
}

enum Header: String {
    case accept = "Accept"
    case authorization = "Authorization"
    case contentType = "Content-Type"
}

enum MimeType: String {
    case applicationJSON = "application/json"
    case formUrlEncoded = "application/x-www-form-urlencoded"
    case textPlain = "text/plain"
}

protocol RequestProtocol {
    var url: String { get }
    var method: ServiceMethod { get }
    var headers: [Header: String]? { get }
    var params: [String: Any]? { get }
}

// MARK: - Method
enum ServiceMethod: String {
    case get
    case post
    case put
}

struct RequestSettings: RequestProtocol {
    var url: String
    var method: ServiceMethod
    var params: [String: Any]?
    var headers: [Header: String]?
    
    init(_ url: String, method: ServiceMethod = .get, params: [String: Any]? = nil, headers: [Header: String]? = nil) {
        self.url = url
        self.method = method
        self.params = params
        self.headers = headers
    }
}


extension MLApi {
    // MARK: - Base Request
    
    @discardableResult
    static func dispatch(_ settings: RequestProtocol, useLoadingMonitor: Bool = true, completion: @escaping (Swift.Result<Data, ServerError>) -> Void) -> URLSessionDataTask? {
        guard let baseURL = URL(string: settings.url) else {
            completion(.failure(ServerError.invalidURL(settings.url)))
            return nil
        }
        
        var request: URLRequest = URLRequest(url: baseURL)
        request.httpMethod = settings.method.rawValue.uppercased()
        
        // Configure body based on method
        switch settings.method {
        case .post, .put:
            if let parameters = settings.params {
                do {
                    let data = try JSONSerialization.data(withJSONObject: parameters, options: [])
                    request.httpBody = data
                }
                catch let error {
                    print("[Request URL] Error: \(error.localizedDescription)")
                }
            }
        default:
            break
        }
        
        // Configure Headers
        if let headers = settings.headers {
            headers.forEach { (arg: (key: Header, value: String)) in
                request.addValue(arg.value, forHTTPHeaderField: arg.key.rawValue)
            }
        }
        
        let config = URLSessionConfiguration.default
        
//        if useLoadingMonitor {
//            config.protocolClasses = [LoadingMonitor.self]
//        }
        
        let session = URLSession(configuration: config)
        let task = session.dataTask(with: request) { data, _, error in
            if let _ = error {
                completion(.failure(ServerError.unknownState))
            }
            else if let data = data {
                completion(.success(data))
            }
            else {
                completion(.failure(ServerError.unknownState))
            }
        }
        task.resume()
        return task
    }
}
