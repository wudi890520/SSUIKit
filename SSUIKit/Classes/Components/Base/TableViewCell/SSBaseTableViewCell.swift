//
//  SSBaseTableViewCell.swift
//  BlocksKit
//
//  Created by 吴頔 on 2019/12/25.
//

import UIKit
import RxSwift
import RxCocoa

open class SSBaseTableViewCell: UITableViewCell {

    public let line = UIView.line()
    
    public var indexPath: IndexPath?
    
    public var numberOfRowsInSection: Int = 0
    
    public var dispose = DisposeBag()
    
    override open func awakeFromNib() {
        super.awakeFromNib()
        addSubviews()
        makeLayout()
        // Initialization code
    }

    override open func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

extension SSBaseTableViewCell {
    @objc open func addSubviews() {
        /// override by subclass
    }
    
    @objc open func makeLayout() {
        /// override by subclass
    }
}

extension SSBaseCollectionViewCell {
    @objc open func reloadData(_ data: Any) {
        /// override by subclass
    }
}
