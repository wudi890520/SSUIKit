//
//  TableViewCell.swift
//  SSUIKit
//
//  Created by 吴頔 on 2019/11/30.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import UIKit

public protocol SSUITableViewCellCompatible {}
extension UITableViewCell: SSUITableViewCellCompatible {}

private let SSTableViewCellBottomLineTag = 250000
public extension SSUITableViewCellCompatible where Self: UITableViewCell {

    /// 设置配件类型
    ///
    /// - Parameter type: 默认显示箭头
    /// - Returns: UITableViewCell
    @discardableResult
    func ss_accessoryType(_ type: UITableViewCell.AccessoryType = .disclosureIndicator) -> Self {
        accessoryType = type
        return self
    }
    
    /// 设置配件视图(用UIView)
    ///
    /// - Parameter customView: 自定义视图
    /// - Returns: UITableViewCell
    @discardableResult
    func ss_accessoryView(with customView: UIView?) -> Self {
        accessoryView = customView
        return self
    }
    
    /// 设置配件视图(用UIImage)
    ///
    /// - Parameter customView: 图片
    /// - Returns: UITableViewCell
    @discardableResult
    func ss_accessoryView(with image: UIImage?) -> Self {
        guard let image = image else { return self }
        let imageView = UIImageView()
            .ss_frame(rect: CGRect(origin: .zero, size: image.size))
            .ss_image(image)
        ss_accessoryView(with: imageView)
        return self
    }
    
    /// 设置点击风格
    ///
    /// - Parameter style: 默认为none
    /// - Returns: UITableViewCell
    @discardableResult
    func ss_selectionStyle(_ style: UITableViewCell.SelectionStyle = .none) -> Self {
        selectionStyle = style
        return self
    }

    /// 设置标题字体大小
    ///
    /// - Parameters:
    ///   - fontSize: 字号
    ///   - isBold: 是否加粗
    ///   - autoFixBase47Inch: 是否需要根据屏幕尺寸自适应（以4.7英寸为标准，小于4.7字号减1，大于4.7字号加1）
    /// - Returns: UITableViewCell
    @discardableResult
    func ss_setTextLabelFont(_ fontSize: CGFloat, isBold: Bool? = false) -> Self {
        textLabel?.ss_font(fontSize, isBold: isBold)
        return self
    }
    
    /// 设置标题文本颜色
    ///
    /// - Parameter textColor: UIColor
    /// - Returns: UITableViewCell
    @discardableResult
    func ss_setTextLabelTextColor(_ textColor: UIColor) -> Self {
        textLabel?.ss_textColor(textColor)
        return self
    }
    
    /// 设置标题文本内容
    ///
    /// - Parameter text: String
    /// - Returns: UITableViewCell
    @discardableResult
    func ss_setTextLabelText(_ text: String) -> Self {
        textLabel?.ss_text(text)
        return self
    }
    
    /// 设置详情字体大小
    ///
    /// - Parameters:
    ///   - fontSize: 字号
    ///   - isBold: 是否加粗
    ///   - autoFixBase47Inch: 是否需要根据屏幕尺寸自适应（以4.7英寸为标准，小于4.7字号减1，大于4.7字号加1）
    /// - Returns: UITableViewCell
    @discardableResult
    func ss_setDetailTextLabelFont(_ fontSize: CGFloat, isBold: Bool? = false, autoFixBase47Inch: Bool? = true) -> Self {
        detailTextLabel?.ss_font(fontSize, isBold: isBold)
        return self
    }
    
    /// 设置详情文本颜色
    ///
    /// - Parameter textColor: UIColor
    /// - Returns: UITableViewCell
    @discardableResult
    func ss_setDetailTextLabelTextColor(_ textColor: UIColor) -> Self {
        _ = detailTextLabel?.ss_textColor(textColor)
        return self
    }
    
    /// 设置详情文本内容
    ///
    /// - Parameter text: String
    /// - Returns: UITableViewCell
    @discardableResult
    func ss_setDetailTextLabelText(_ text: String) -> Self {
        _ = detailTextLabel?.ss_text(text)
        return self
    }
}
