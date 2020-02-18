//
//  ProfileCoordinator.swift
//  Evolution-iOS
//
//  Created by uuttff8 on 2/18/20.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import UIKit

class ProfileCoordinator: Coordinator {
    var navigationController: UINavigationController?
    var childCoordinators = [Coordinator]()
    
    var person: Person
    
    init(navigationController: UINavigationController?, person: Person) {
        self.navigationController = navigationController
        self.person = person
    }
    
    func start() {
        let vc = ProfileViewController.instantiate(from: AppStoryboards.Profile)
        vc.coordinator = self
        vc.profile = person
        navigationController?.pushViewController(vc, animated: true)
    }
    
    typealias CompletionUserProfile = (GithubProfile?) -> Swift.Void
    
    @discardableResult
    func fetchProfile(from username: String, completion: @escaping CompletionUserProfile) -> URLSessionDataTask? {
        let url = "\(Config.Base.URL.GitHub.users)/\(username)"
        let request = RequestSettings(url)
        
        let task = MLApi.dispatch(request) { result in
            switch result {
            case let .success(data):
                let response = try? JSONDecoder().decode(GithubProfile.self, from: data)
                completion(response)
            default:
                break
            }
        }
        return task
    }
}
