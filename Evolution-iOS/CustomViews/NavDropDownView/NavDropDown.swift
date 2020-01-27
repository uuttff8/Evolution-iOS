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

class NavDropDown: UIButton {
    
    var language = LanguageSelected.Swift
    
    var vc: UIViewController?
    
    @IBOutlet private weak var title: UILabel!
    @IBOutlet weak var arrow: UIButton!
    
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
    
    func commonInit() {
        guard let view = Bundle(for: NavDropDown.self).loadNibNamed(String(describing: NavDropDown.self), owner: self, options: nil)?.first as? UIView else { return }
        view.frame = self.bounds
        self.addSubview(view)
        
        let gest = UITapGestureRecognizer(target: self, action: #selector(self.lol))
        
        addGestureRecognizer(gest)
    }
    
    
    // TODO: Add Closures when value is changed
    @objc func lol() {
        rotateArrowWithAnimation()
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let swiftAc = UIAlertAction(title: "Swift", style: .default) { (action) in
            self.title.text = "Swift"
            self.language = LanguageSelected.Swift
            self.rotateArrowWithAnimation()
        }
        
        let rustAc = UIAlertAction(title: "Rust", style: .default) { (action) in
            self.title.text = "Rust"
            self.language = LanguageSelected.Rust
            self.rotateArrowWithAnimation()
        }
        
        alert.addAction(swiftAc); alert.addAction(rustAc)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (_) in
            self.rotateArrowWithAnimation()
            
        }))
        vc?.present(alert, animated: true, completion: nil)
    }
    
    func rotateArrowWithAnimation() {
        UIView.animate(withDuration: 0.2, delay: 0.0, options: [.curveEaseInOut], animations: {
                self.arrow.rotate(angle: -180)
        })
    }
}


// MARK: - UIView Extension -

extension UIView {
    
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
