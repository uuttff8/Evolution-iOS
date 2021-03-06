//
//  CustomSubtitleTableViewCell.swift
//  Evolution-iOS
//
//  Created by uuttff8 on 2/16/20.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import UIKit

final class CustomSubtitleTableViewCell: UITableViewCell {
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    var contributor: Contributor? {
        didSet {
            guard let contributor = contributor else {
                return
            }
            
            let placeholder = UIImage(named: "placeholder-photo")
            imageView?.image = placeholder
            
            textLabel?.text = contributor.text
            detailTextLabel?.text = contributor.media
            
            loadProfileImage()
        }
    }
    
    var license: License? {
        didSet {
            guard let license = license else {
                return
            }
            
            textLabel?.text = license.text
            detailTextLabel?.text = license.media
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        if let imageView = imageView {
            let currentSize = imageView.frame.size
            let size = CGSize(width: currentSize.width - 8, height: currentSize.height - 8)
            
            let currentOrigin = imageView.frame.origin
            let origin = CGPoint(x: currentOrigin.x, y: currentOrigin.y + 4)
            
            let frame = CGRect(origin: origin, size: size)
            imageView.frame = frame
            
            imageView.backgroundColor = UIColor.Proposal.lightGray.withAlphaComponent(0.5)
            imageView.layer.cornerRadius = imageView.frame.size.width / 2
            imageView.clipsToBounds = true
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if let imageView = imageView {
            imageView.layer.cornerRadius = imageView.frame.size.width / 2
            imageView.clipsToBounds = true

        }
    }
    
    private func loadProfileImage() {
        guard let contributor = contributor, let imageView = imageView else {
            return
        }
        
        let url = contributor.picture(120)
        guard url != "" else {
            return
        }
        
        imageView.loadImage(from: url, completion: {  (image) in
            DispatchQueue.main.async {
                imageView.image = image
            }
        })
    }
}
