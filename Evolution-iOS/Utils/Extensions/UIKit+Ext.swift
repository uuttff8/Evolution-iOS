//
//  UIKit+Ext.swift
//  Evolution-iOS
//
//  Created by uuttff8 on 2/11/20.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import UIKit

extension UIView {
    private class UIViewNamed: UIView {
        var name: String
        var thickness: CGFloat?
        required init(frame: CGRect = CGRect.zero, name: String) {
            self.name = name
            
            super.init(frame: frame)
        }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    }
    
    public enum RectEdge: String {
        case top
        case right
        case bottom
        case left
    }
    
    open func set(to edge: RectEdge, with color: UIColor, thickness: CGFloat? = nil) {
        let view = self.border(to: edge) ?? UIViewNamed(name: edge.rawValue)
        let thicknessToApply = thickness ?? view.thickness ?? 1.0
        
        view.backgroundColor = color
        view.translatesAutoresizingMaskIntoConstraints = false
        view.thickness = thicknessToApply
        
        self.removeConstraints(view.constraints)
        self.addSubview(view)
        self.constraint(to: view, edge: edge, thickness: thicknessToApply)
    }
    
    private func border(to edge: RectEdge) -> UIViewNamed? {
        let index = self.subviews.firstIndex(where: {
            if $0 is UIViewNamed, let view = $0 as? UIViewNamed, view.name == edge.rawValue {
                return true
            }
            
            return false
        })
        
        guard let i = index else {
            return nil
        }
        
        return self.subviews[i] as? UIViewNamed
    }
    
    private func constraint(to view: UIView, edge: RectEdge, thickness: CGFloat) {
        
        switch edge {
        case .top:
            self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-(0)-[top(==thickness)]",
                                                               options: [],
                                                               metrics: ["thickness": thickness],
                                                               views: ["top": view]))
            
            self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-(0)-[top]-(0)-|",
                                                               options: [],
                                                               metrics: nil,
                                                               views: ["top": view]))
            
        case .right:
            self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:[right(==thickness)]-(0)-|",
                                                               options: [],
                                                               metrics: ["thickness": thickness],
                                                               views: ["right": view]))
            self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-(0)-[right]-(0)-|",
                                                               options: [],
                                                               metrics: nil,
                                                               views: ["right": view]))
            
        case .bottom:
            self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[bottom(==thickness)]-(0)-|",
                                                               options: [],
                                                               metrics: ["thickness": thickness],
                                                               views: ["bottom": view]))
            self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-(0)-[bottom]-(0)-|",
                                                               options: [],
                                                               metrics: nil,
                                                               views: ["bottom": view]))
            
        case .left:
            self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-(0)-[left(==thickness)]",
                                                               options: [],
                                                               metrics: ["thickness": thickness],
                                                               views: ["left": view]))
            self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-(0)-[left]-(0)-|",
                                                               options: [],
                                                               metrics: nil,
                                                               views: ["left": view]))
        }
    }
    
    public static func fromNib<T: UIView>(nibName: String? = nil) -> T? {
        var name: String? = nibName
        
        if name == nil {
            name = String(describing: T.self)
        }
        
        if let nib = Config.Nib.loadNib(name: name),
            let nibViews = nib.instantiate(withOwner: self, options: nil) as? [T],
            let view = nibViews.first {
            
            return view
        }
        
        return nil
    }
}


extension UIRefreshControl {
    func forceShowAnimation() {
        DispatchQueue.main.async {
            guard let scrollView = self.superview as? UIScrollView else {
                return
            }
            
            let offSet = CGPoint(x: 0, y: scrollView.contentOffset.y - self.frame.height)
            scrollView.setContentOffset(offSet, animated: true)

            self.beginRefreshing()
        }
    }
}


extension UITableView {
    
    func registerNib<T: UITableViewCell>(withClass cellClass: T.Type) {
        register(
            Config.Nib.loadNib(name: T.cellIdentifier),
            forCellReuseIdentifier: T.cellIdentifier
        )
    }
    
    func registerClass<T: UITableViewCell>(_ cellClass: T.Type) {
        register(cellClass.self, forCellReuseIdentifier: cellClass.cellIdentifier)
    }
    
    func cell<T: ReusableCellIdentifiable>(forRowAt indexPath: IndexPath) -> T {
        return dequeueReusableCell(withIdentifier: T.cellIdentifier, for: indexPath) as! T
    }
    
    func cell<T: ReusableCellIdentifiable>(forClass cellClass: T.Type) -> T {
        return dequeueReusableCell(withIdentifier: T.cellIdentifier) as! T
    }
    
}
