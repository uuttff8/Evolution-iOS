//
//  NavDropDown.swift
//  Evolution-iOS
//
//  Created by uuttff8 on 1/27/20.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import UIKit

enum LanguageSelected {
    case Swift
    case Rust
}

@IBDesignable
class NavDropDown: UIButton {
    
    var showAlertCompletion: ((UIAlertController) -> ())?
    var didChangeLanguageCompletion: ((LanguageSelected) -> ())?
    
    var language = LanguageSelected.Rust
    
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
    
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        commonInit()
    }
    
    private func commonInit() {
        guard let view = Bundle(for: NavDropDown.self)
            .loadNibNamed(String(describing: NavDropDown.self), owner: self, options: nil)?
            .first as? UIView
            else { return }
        view.frame = self.bounds
        self.addSubview(view)
        
        // handle first language init
        switch language {
        case .Rust:
            title.text = "Rust"
        case .Swift:
            title.text = "Swift"
        }
        
        let gest = UITapGestureRecognizer(target: self, action: #selector(self.rotateArrow))
        
        addGestureRecognizer(gest)
    }
    
    
    @objc func rotateArrow() {
        rotateArrowWithAnimation()
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let swiftAc = UIAlertAction(title: "Swift", style: .default) { (action) in
            self.title.text = "Swift"
            self.language = LanguageSelected.Swift
            self.rotateArrowWithAnimation()
            self.didChangeLanguageCompletion?(LanguageSelected.Swift)
        }
        
        let rustAc = UIAlertAction(title: "Rust", style: .default) { (action) in
            self.title.text = "Rust"
            self.language = LanguageSelected.Rust
            self.rotateArrowWithAnimation()
            self.didChangeLanguageCompletion?(LanguageSelected.Rust)
        }
        
        alert.addAction(swiftAc); alert.addAction(rustAc)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action) in
            self.rotateArrowWithAnimation()
        }))
        
        self.showAlertCompletion?(alert)
    }
    
    private func rotateArrowWithAnimation() {
        UIView.animate(withDuration: 0.2, delay: 0.0, options: [.curveEaseInOut], animations: {
            self.arrow.rotate(angle: 180)
        })
    }
}


// MARK: - UIView Extension -

private extension UIView {
    
    /**
     Rotate a view by specified degrees
     
     - parameter angle: angle in degrees
     */
    func rotate(angle: CGFloat) {
        let radians = angle / 180.0 * CGFloat.pi
        let rotation = self.transform.rotated(by: radians)
        self.transform = rotation
    }
    
}
