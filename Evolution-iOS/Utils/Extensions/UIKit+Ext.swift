//
//  UIKit+Ext.swift
//  Evolution-iOS
//
//  Created by uuttff8 on 2/11/20.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import UIKit

// MARK: - UIView Extension -

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


extension UIImageView {
    public func round(with color: UIColor? = nil, width: CGFloat?) {
        
        if let color = color {
            self.layer.borderColor = color.cgColor
        }
        
        if let width = width {
            self.layer.borderWidth = width
        }
        
        self.layer.cornerRadius = self.bounds.size.height / 2
        self.layer.masksToBounds = true
    }
    
    public func loadImage(from url: String?, completion: @escaping (UIImage) -> ()) {
        guard let url = url, url != "" else {
            return
        }
        
        MLApi.requestImage(url) { result in
            switch result {
            case .success(let image):
                completion(image)
            default: break
            }
        }
    }
}

extension UIAlertController {
    static func presentAlert(to item: ItemProtocol) -> UIAlertController {
        var title = "Open Safari?"
        var value = ""
        var message = ""
        
        switch item.type {
        case .twitter:
            value = "twitter://user?screen_name=\(item.value)"
            
            if let url = URL(string: value), UIApplication.shared.canOpenURL(url) {
                title = "Open Twitter ?"
                message = "@\(item.value)"
            }
            else {
                value = "https://\(item.type.rawValue)/\(item.value)"
                message = value
            }
            
        case .github:
            value = "https://\(item.type.rawValue)/\(item.value)"
            message = value
            
        case .email:
            title = "Open Mail ?"
            value = "mailto:\(item.value)"
            message = item.value
        case .noUrl:
            break
        default:
            value = item.value
            message = value
        }
        
        let alertController = UIAlertController(title: title,
                                                message: message,
                                                preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let openAction = UIAlertAction(title: "Open", style: .default) { _ in
            if let url = URL(string: value) {
                UIApplication.shared.open(url, options: [UIApplication.OpenExternalURLOptionsKey.universalLinksOnly: false])
            }
        }
        
        alertController.addAction(cancelAction)
        alertController.addAction(openAction)
        
        return alertController
    }
    
}

extension Bundle {
    var releaseVersionNumber: String? {
        return infoDictionary?["CFBundleShortVersionString"] as? String
    }
    var buildVersionNumber: String? {
        return infoDictionary?["CFBundleVersion"] as? String
    }
}
