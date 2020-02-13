//
//  ProposalDetailViewController.swift
//  Evolution-iOS
//
//  Created by uuttff8 on 2/12/20.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import UIKit
import Down

class ProposalDetailViewController: NetViewController, Storyboarded {
    weak var coordinator: ProposalDetailCoordinator?
    
    var currentLanguage: LanguageSelected?
    var proposalId: String?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getProposalDetailText { [weak self] (text) in
            DispatchQueue.main.async {
                guard let self = self else { return }
                self.renderDownInWebView(for: text)
                
            }
        }
    }
    
    private func getProposalDetailText(completion: @escaping (String) -> Void) {
        switch currentLanguage {
        case .Swift:
            MLApi.Swift.proposalDetail(title: proposalId ?? "") { (markdown) in
                guard let markdown = markdown else { return }
                completion(markdown)
            }
        case .Rust:
            MLApi.Rust.proposalDetail(title: proposalId ?? "") { (markdown) in
                guard let markdown = markdown else { return }
                completion(markdown)
            }
        default:
            break
        }
    }
    
    
}

private extension ProposalDetailViewController {
    
    func renderDownInWebView(for text: String) {
        do {
            // Implement through UserDefault
            //            // Get access to down.min.css file in Resources/DownView.bunlde/css/down.min.css
            //            let classBundle = Bundle(for: DownView.self)
            //            let url = classBundle.url(forResource: "DownView", withExtension: "bundle")!
            //            let bundle = Bundle(url: url)!
            //            let path = bundle.url(forResource: "down", withExtension: "min.css", subdirectory: "css")
            //
            //            // Get contents of a file
            //            let con = try String(contentsOf: path!)
            //
            //            // Access to a line of a file in [Int]
            //            let components = con.components(separatedBy: "\n")
            //
            //            // Change font from 0.9 to 1.2 in css
            //            let str = components[4].replacingOccurrences(of: "0.9em", with: "1.2em")
            //            print(str)
            //            try str.write(to: path!, atomically: true, encoding: .utf8)
            //
            
            let downView = try DownView(frame: self.view.bounds, markdownString: text/*, templateBundle: bundle*/, didLoadSuccessfully: {
                print("Markdown was rendered.")
            })
            
            downView.translatesAutoresizingMaskIntoConstraints = false
            self.view.addSubview(downView)
            self.constrain(subview: downView)
            self.createStatusBarBackgrounds(above: downView)
        } catch(let error) {
            self.showError(message: error.localizedDescription)
        }
        
    }
    
    func createStatusBarBackgrounds(above subview: UIView) {
        let blurEffect = UIBlurEffect(style: .prominent)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.translatesAutoresizingMaskIntoConstraints = false
        view.insertSubview(blurEffectView, aboveSubview: subview)
        constrain(subview: blurEffectView, bottomAnchor: view.safeAreaLayoutGuide.topAnchor)
    }
    
    func constrain(subview: UIView, bottomAnchor: NSLayoutYAxisAnchor? = nil) {
        NSLayoutConstraint.activate([
            subview.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            subview.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            subview.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            subview.bottomAnchor.constraint(equalTo: bottomAnchor ?? view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    func showError(message: String) {
        let alertController = UIAlertController(title: "DownView Render Error",
                                                message: message,
                                                preferredStyle: .alert)
        self.present(alertController, animated: true, completion: nil)
    }
    
}
