//
//  NavDropDown.swift
//  Evolution-iOS
//
//  Created by uuttff8 on 1/27/20.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import UIKit

@IBDesignable
class NavDropDown: UIButton {
    
    var showAlertCompletion: ((UIAlertController) -> ())?
    var didChangeLanguageCompletion: ((LanguageType) -> ())?
    
    var language = Config.Common.defaultLanguage {
        didSet {
            self.title.text = self.language.rawValue
            self.rotateArrowWithAnimation()
            self.didChangeLanguageCompletion?(language)
        }
    }
    
    @IBOutlet private weak var title: UILabel!
    @IBOutlet private weak var arrow: UIButton!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
        
    private func commonInit() {
        guard let view = Bundle(for: NavDropDown.self)
            .loadNibNamed(String(describing: NavDropDown.self), owner: self, options: nil)?.first as? UIView
        else {
            return
        }
        
        view.frame = self.bounds
        self.addSubview(view)
        
        // handle first language init
        title.text = language.rawValue
        
        let gest = UITapGestureRecognizer(target: self, action: #selector(self.showLanguagePicker))
        addGestureRecognizer(gest)
    }
    
    @objc func showLanguagePicker() {
        
        rotateArrowWithAnimation()
        
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let swiftAc = UIAlertAction(title: "Swift", style: .default) { _ in
            self.language = .Swift
        }
        
        let rustAc = UIAlertAction(title: "Rust", style: .default) { _ in
            self.language = .Rust
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { _ in
            self.rotateArrowWithAnimation()
        }
        
        alert.addAction(swiftAc)
        alert.addAction(rustAc)
        alert.addAction(cancelAction)
        
        self.showAlertCompletion?(alert)
    }
    
    private func rotateArrowWithAnimation() {
        UIView.animate(withDuration: 0.2, delay: 0.0, options: [.curveEaseInOut], animations: {
            self.arrow.rotate(angle: 180)
        })
    }
}

