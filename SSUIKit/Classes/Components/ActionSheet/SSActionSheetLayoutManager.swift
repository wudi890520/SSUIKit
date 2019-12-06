//
//  SSActionSheetLayoutManager.swift
//  SSUIKit_Example
//
//  Created by 吴頔 on 2019/12/5.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import UIKit
import SnapKit

class SSActionSheetLayoutManager: NSObject, SSLayoutType {
    
    var superView: UIView?

    var children: SSActionSheetViewContainer?
}

extension SSActionSheetLayoutManager {
    func make(children views: SSActionSheetViewContainer, in view: UIView) {
        superView = view
        children = views
        addChildren()
        layoutChildren()
    }
}

extension SSActionSheetLayoutManager {
    
    func addChildren() {
        
        guard let superView = superView else { return }
        guard let children = children else { return }
        
        superView.backgroundColor = .ss_background
 
        superView
            .ss_add(children.tableView)
            .ss_add(children.cancelButton)
        
        if let _ = children.titleLabel.text {
            children.tableHeaderView.ss_add(children.titleLabel)
            children.titleLabel.ss_fitHeight(with: 20)
            children.tableHeaderView.height = children.titleLabel.height
            children.tableHeaderView.ss_border(at: .bottom)
            children.tableView.tableHeaderView = children.tableHeaderView
        }else{
            children.tableView.tableHeaderView = nil
        }
        
    }
    
    func layoutChildren() {
        guard let _ = superView else { return }
        guard let children = children else { return }
        
        children.tableView.snp.makeConstraints { (make) in
            make.left.right.top.equalToSuperview()
            make.bottom.equalTo(children.cancelButton.snp.top).offset(-8)
        }
        
        children.cancelButton.snp.makeConstraints { (make) in
            make.height.equalTo(SSActionSheetConfiguration.shared.rowHeight+CGFloat.unsafeBottom)
            make.left.right.bottom.equalToSuperview()
        }
       
    }
}

