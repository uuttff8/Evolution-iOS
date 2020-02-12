//
//  FilterListGenericView.swift
//  Evolution-iOS
//
//  Created by uuttff8 on 2/11/20.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import UIKit

// MARK: - FilterGenericView Delegate
protocol FilterGenericViewDelegate: class {
    func didSelectFilter(_ view: FilterListGenericView, type: FilterListGenericType, indexPath: IndexPath)
    func didDeselectFilter(_ view: FilterListGenericView, type: FilterListGenericType, indexPath: IndexPath)
}

protocol FilterGenericViewLayoutDelegate: class {
    func didFinishCalculateHeightToView(type: FilterListGenericType, height: CGFloat)
}

public enum FilterListGenericType {
    case status
    case version
    case none
}

class FilterListGenericView: UIView {

    @IBOutlet private weak var descriptionLabel: UILabel!
    @IBOutlet private weak var collectionView: UICollectionView!
    
    weak open var delegate: FilterGenericViewDelegate?
    weak open var layoutDelegate: FilterGenericViewLayoutDelegate?
    
    open var height: CGFloat = 0
    open var type: FilterListGenericType = .none
    open var selectedItems: [IndexPath] = []
    open var indexPathsForSelectedItems: [IndexPath]? {
        return self.collectionView.indexPathsForSelectedItems
    }
    
    var dataSource: [CustomStringConvertible] = [] {
        didSet {
            self.reloadData()
        }
    }
    
    // MARK: - Initialization
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()

        self.collectionView.registerNib(withClass: FilterCollectionViewCell.self)
        self.collectionView.collectionViewLayout = DGCollectionViewLeftAlignFlowLayout()
        self.collectionView.allowsMultipleSelection = true
    }
    
    // MARK: - Util

    fileprivate func textFor(indexPath: IndexPath) -> String? {
        var text: String?
        let item = self.dataSource[indexPath.item]

        text = (item is String) ? "Swift \(item)" : item.description
        
        return text
    }
    
    // MARK: - Layout
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.height = self.collectionView.contentSize.height + self.descriptionLabel.frame.maxY
        self.layoutDelegate?.didFinishCalculateHeightToView(type: self.type, height: self.height)
    }
    
    private func reloadData() {
        guard dataSource.count > 0 else {
            return
        }
        
        
        DispatchQueue.main.async {
            self.collectionView.reloadData()
            self.collectionView.performBatchUpdates(nil) { _ in
                self.height = self.collectionView.contentSize.height + self.descriptionLabel.bounds.maxY
                self.layoutDelegate?.didFinishCalculateHeightToView(type: self.type, height: self.height)
            }
        }
    }
}

// MARK: - UICollectionView DataSource

extension FilterListGenericView: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.dataSource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.cell(forItemAt: indexPath) as FilterCollectionViewCell
        
        cell.text = self.textFor(indexPath: indexPath) ?? ""
        
        return cell
    }
}

// MARK: - UICollectionView Delegate

extension FilterListGenericView: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.delegate?.didSelectFilter(self, type: self.type, indexPath: indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        self.delegate?.didDeselectFilter(self, type: self.type, indexPath: indexPath)
    }

}

// MARK: - UICollectionView DelegateFlowLayout

extension FilterListGenericView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if let text = self.textFor(indexPath: indexPath), let font = UIFont(name: "HelveticaNeue", size: 16) {
            let width = text.contraint(height: 28, font: font) + 34
            
            let size = CGSize(width: width, height: 28)
            return size
        }
        
        return CGSize.zero
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 3
    }
}

