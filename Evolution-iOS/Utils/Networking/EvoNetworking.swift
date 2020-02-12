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
    func fetchProposals(completion: @escaping ([ProposalSwift]?) -> Void) 
}

private protocol MLApiLinksProviderRust {
    func fetchProposals(completion: @escaping (Result<ProposalsRust?, Never>) -> ())
}

private protocol MLApiProviderRust: MLApiLinksProviderRust { }
private protocol MLApiProviderSwift: MLApiLinksProviderSwift { }

final class MLApiImplRust: MLApiProviderRust {
        
    private let httpClient: HTTPClientProvider
    
    init(httpClient: HTTPClientProvider = HTTPClient()) {
        self.httpClient = httpClient
    }
    
    func fetchProposals(completion: @escaping (Result<ProposalsRust?, Never>) -> ()) {
        let url = URL(string: ConstantsApiUrl.Rust.rawValue + "proposals")!
        
        httpClient.get(url: url) { (res) in
            switch res {
            case .success(let data):
                let response = try? JSONDecoder().decode(ProposalsRust.self, from: data)
                completion(.success(response))
            default:
                break
            }
        }
    }
}

//            .retry(1)
//            .map { data -> ProposalsRust? in
//                guard let data = data,
//                let response = try? JSONDecoder().decode(ProposalsRust.self, from: data) else {
//                    return nil
//            }
//            return response
    
//    return httpClient.get(url: url!)
//        .retry(1)
//        .map { data -> [ProposalSwift]? in
//            guard let data = data,
//            let response = try? JSONDecoder().decode([ProposalSwift].self, from: data) else {
//                return nil
//        }
//        return response
//    }



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
}

enum MLApi {
    static let Swift = MLApiImplSwift()
    static let Rust = MLApiImplRust()
}
