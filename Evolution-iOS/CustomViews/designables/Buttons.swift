//
//  Buttons.swift
//  Evolution-iOS
//
//  Created by uuttff8 on 2/3/20.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import UIKit

@IBDesignable
open class BorderedLabel: UILabel {

    @IBInspectable
    var cornerRadius: CGFloat = 0.0 {
        didSet {
            self.layer.cornerRadius = cornerRadius
        }
    }
    
    @IBInspectable
    var borderColor: UIColor = UIColor.clear {
        didSet {
            self.layer.borderColor = borderColor.cgColor
        }
    }
    
    @IBInspectable
    var borderWidth: CGFloat = 0.0 {
        didSet {
            self.layer.borderWidth = borderWidth
        }
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)

        self.cornerRadius = 0.0
        self.borderWidth = 0.0
        self.borderColor = UIColor.clear
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}

class StatusLabel: BorderedLabel {

    @IBInspectable
    var selectedColor: UIColor?
    
    @IBInspectable
    var normalColor: UIColor?
    
    @IBInspectable
    var selected: Bool = false {
        didSet {
            if let normalColor = self.normalColor,
                let selectedColor = self.selectedColor {
                self.textColor = selected ? selectedColor : normalColor
                self.backgroundColor = selected ? normalColor : UIColor.clear
            }
        }
    }
    
    override func drawText(in rect: CGRect) {
        let edgeInsets = rect.inset(by: UIEdgeInsets(top: 0, left: 8, bottom: 3, right: 8))
        
        super.drawText(in: edgeInsets)
    }
    
    
}


