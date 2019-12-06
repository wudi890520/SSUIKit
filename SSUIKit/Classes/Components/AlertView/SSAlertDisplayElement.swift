//
//  SSAlertDisplayElement.swift
//  DeviceKit
//
//  Created by 吴頔 on 2019/12/6.
//

import UIKit

public enum SSAlertDisplayElementButtonType {
    /// 在左边
    case cancel
    /// 在右边
    case confirm
    /// 在中间，就一个按钮
    case justOnly
}

public struct SSAlertDisplayTableViewItemData {
    let image: UIImage?
    let title: String?
    let subTitle: String?
    let extra: Any?
}

/// 弹框上面的元素
public enum SSAlertDisplayElement {
    
    /// 标签，字体默认居中
    /// - Parameters content: 内容
    /// - Parameters insets: 上下左右间距
    case label(content: NSMutableAttributedString, insets: UIEdgeInsets)
    
    /// 输入框
    /// - Parameters placeholder: 提示文本
    /// - Parameters keyboardType: 键盘类型
    /// - Parameters insets: 上下左右间距
    /// - Parameters leftTitle: 左标题
    /// - Parameters rightTitle: 右标题
    case textField(placeholder: String, keyboardType: SSKeyboardType, insets: UIEdgeInsets, leftTitle: NSMutableAttributedString?, rightTitle: NSMutableAttributedString?, textDidChange: ((String) -> Void)?)
    
    /// 列表
    /// - Parameters dataSource: 数据源
    /// - Parameters rowHeight: 行高
    case tableView(dataSource: [SSAlertDisplayTableViewItemData], rowHeight: CGFloat, selectedIndex: ((Int) -> Void)?)
    
    /// 列表
    /// - Parameters title: 按钮标题
    /// - Parameters titleColor: 按钮标题颜色
    /// - Parameters backgroundColor: 按钮背景颜色
    /// - Parameters type: 按钮类型
    case button(title: String, titleColor: UIColor?, backgroundColor: UIColor?, type: SSAlertDisplayElementButtonType, didTap: ((Void) -> Void)?)
}
