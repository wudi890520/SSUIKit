//
//  SSActionSheetTableViewCell.swift
//  DeviceKit
//
//  Created by 吴頔 on 2019/12/5.
//

import UIKit

class SSActionSheetTableViewCell: UITableViewCell {
    
    /// 标题控件
    public let titleLabel = UILabel()
        .ss_frame(x: 0, y: 0, width: CGFloat.screenWith, height: SSActionSheetConfiguration.shared.rowHeight)
        .ss_font(SSActionSheetConfiguration.shared.buttonItemFont)
        .ss_textAlignment(.center)
        .ss_numberOfLines()
    
    /// 点击按钮的高亮颜色
    private let selectedBGView = UIView()
        .ss_frame(x: 0, y: 0, width: CGFloat.screenWith, height: SSActionSheetConfiguration.shared.rowHeight)
        .ss_backgroundColor(.ss_background)
    
    public let line = UIView.line()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectedBackgroundView = selectedBGView
        contentView.addSubview(titleLabel)
        contentView.addSubview(line)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
