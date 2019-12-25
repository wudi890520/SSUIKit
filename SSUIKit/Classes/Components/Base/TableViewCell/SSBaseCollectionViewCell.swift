//
//  SSBaseCollectionViewCell.swift
//  BlocksKit
//
//  Created by 吴頔 on 2019/12/25.
//

import UIKit

open class SSBaseCollectionViewCell: UICollectionViewCell {

    override open func awakeFromNib() {
        super.awakeFromNib()
        addSubviews()
        makeLayout()
        // Initialization code
    }

}

extension SSBaseCollectionViewCell {
    @objc open func addSubviews() {
        /// override by subclass
    }
    
    @objc open func makeLayout() {
        /// override by subclass
    }
}

extension SSBaseCollectionViewCell {
    @objc open func reloadCellData(_ data: Any) {
        /// override by subclass
    }
}
