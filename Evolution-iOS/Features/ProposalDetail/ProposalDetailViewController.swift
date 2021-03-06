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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard coordinator != nil else { return }
        
        switch currentLanguage {
        case .Rust:
            
            let navTitle = proposalId?
                .replacingOccurrences(of: "-", with: " ")
                .dropFirst(5)
                .dropLast(3)
            title = String(navTitle ?? "").firstUppercased
        case .Swift:
            title = proposalId
        default:
            break
        }
        
        getProposalDetailText { [weak self] (text) in
            DispatchQueue.main.async {
                guard let self = self else { return }
                self.renderDownInWebView(for: text)
                
            }
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        coordinator?.removeDependency(coordinator)
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
            // TODO: Write Bundle files to Documents directory and accesses to it from Down framework,
            // because Application can't write data to their bundles (DownView.bundle)

//            try changeFont(to: "0.9")
            
            let downView = try DownView(frame: self.view.bounds, markdownString: text/*, templateBundle: bundle*/, didLoadSuccessfully: {
                print("Markdown was rendered.")
            })
            
            downView.translatesAutoresizingMaskIntoConstraints = false
            self.view.addSubview(downView)
            self.constrain(subview: downView)
            self.createStatusBarBackgrounds(above: downView)
        } catch(let error) {
            self.showError(message: error.localizedDescription)
            print(error.localizedDescription)
        }
    }
    
    func writeChangesToDisk(from: String, to: String) throws {
        // Get access to down.min.css file in Resources/DownView.bunlde/css/down.min.css
        let classBundle = Bundle(for: DownView.self)
        
        guard let url = classBundle.url(forResource: "DownView", withExtension: "bundle"),
            let bundle = Bundle(url: url),
            let path = bundle.url(forResource: "down", withExtension: "min.css", subdirectory: "css")
            else {
                self.showError(message: "Debug: cannot find bundle for Down")
                return
        }
        // Get contents of a file
        let con = try String(contentsOf: path)
        
        // Access to a line of a file in [Int]
        var components = con.components(separatedBy: "\n")
        
        // Change font from 0.9 to 1.2 in css
        let str = components[4].replacingOccurrences(of: String(from), with: String(to))
        // change only 4 line
        components[4] = str
        
        // TODO: Write Bundle files to Documents directory and accesses to it from Down framework,
        // because Application can't write data to their bundles (DownView.bundle)
        try components.joined(separator: "\n").write(to: path, atomically: true, encoding: .utf8)
    }
    
    func getDocumentsDirectory() -> URL {
        // find all possible documents directories for this user
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)

        // just send back the first one, which ought to be the only one
        return paths[0]
    }
    
    func changeFont(to fontSize: String) throws {
        let defaultFont = UserDefaultsService.shared.downFontSize
        let newFont = String(0.9)
        UserDefaultsService.shared.downFontSize = newFont
        try writeChangesToDisk(from: defaultFont, to: fontSize)
        UserDefaultsService.shared.clearOnlyDownFontSize()
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
            subview.bottomAnchor.constraint(equalTo: bottomAnchor ?? view.bottomAnchor)
        ])
    }
    
    func showError(message: String) {
        let alertController = UIAlertController(title: "DownView Render Error",
                                                message: message,
                                                preferredStyle: .alert)
        self.present(alertController, animated: true, completion: nil)
    }
    
}
