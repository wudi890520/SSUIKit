//
//  SSActionSheetViewContainer.swift
//  SSUIKit_Example
//
//  Created by 吴頔 on 2019/12/5.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import UIKit
import QMUIKit

class SSActionSheetViewContainer: NSObject {
    let tableView = UITableView.ss_plain()
        .ss_rowHeight(SSActionSheetConfiguration.shared.rowHeight)
        .ss_backgroundColor(.clear)
        .ss_separatorStyleNone()
        .ss_bouncesDisable()
        .ss_register(SSActionSheetTableViewCell.self)
    
    var tableHeaderView = UIView()
        .ss_frame(x: 0, y: 0, width: CGFloat.screenWith, height: 0)
        .ss_backgroundColor(.white)
    
    let titleLabel = UILabel()
        .ss_frame(x: 20, y: 0, width: CGFloat.screenWith-40, height: 0)
        .ss_font(.lightDetail)
        .ss_textColor(.lightGray)
        .ss_textAlignment(.center)
        .ss_numberOfLines()
    
    let cancelButton = UIButton()
        .ss_font(SSActionSheetConfiguration.shared.buttonItemFont)
        .ss_backgroundImage(.white)
        .ss_backgroundImage(.ss_background, for: .highlighted)
        .ss_title("取消")
        .ss_titleColor(.darkText)
        .ss_titleEdgeInsets(UIEdgeInsets(top: 0, left: 0, bottom: CGFloat.unsafeBottom, right: 0))
}
