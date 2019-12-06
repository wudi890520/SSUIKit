//
//  Label.swift
//  SSUIKit
//
//  Created by 吴頔 on 2019/11/30.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import UIKit
import QMUIKit

public typealias Label = QMUILabel

public protocol SSUILabelCompatible {}
extension UILabel: SSUILabelCompatible {}

public extension SSUILabelCompatible where Self: UILabel {
    
    /// 设置文本内容
    ///
    /// - Parameter text: String
    /// - Returns: UILabel
    @discardableResult
    func ss_text(_ value: Any?) -> Self {
        if let value = value {
            self.text = "\(value)"
        }
        return self
    }
    
    /// 设置富文本内容
    ///
    /// - Parameter attribute: NSMutableAttributedString
    /// - Returns: UILabel
    @discardableResult
    func ss_attribute(_ attribute: NSMutableAttributedString?) -> Self {
        self.attributedText = attribute
        return self
    }
    
    /// 设置文本颜色
    ///
    /// - Parameter color: UIColor
    /// - Returns: UILabel
    @discardableResult
    func ss_textColor(_ color: UIColor?) -> Self {
        self.textColor = color
        return self
    }
    
    /// 设置文本对齐方式
    ///
    /// - Parameter textAlignment: NSTextAlignment
    /// - Returns: UILabel
    @discardableResult
    func ss_textAlignment(_ textAlignment: NSTextAlignment) -> Self {
        self.textAlignment = textAlignment
        return self
    }
    
    /// 设置按钮标题字体
    /// - Parameter font: 字体
    @discardableResult
    func ss_font(_ font: UIFont) -> Self {
        self.font = font
        return self
    }
    
    /// 设置文本字体大小
    ///
    /// - Parameters:
    ///   - fontSize: 字号
    ///   - isBold: 是否加粗
    ///   - autoFixBase47Inch: 是否需要根据屏幕尺寸自适应（以4.7英寸为标准，小于4.7字号减1，大于4.7字号加1）
    /// - Returns: UILabel
    @discardableResult
    func ss_font(_ fontSize: CGFloat, isBold: Bool? = false) -> Self {
        if isBold == true {
            font = .boldSystemFont(ofSize: fontSize)
        }else{
            font = .systemFont(ofSize: fontSize)
        }
        return self
    }
    
    /// 文本可视行数
    ///
    /// - Parameter numberOfLines: 多少行
    /// - Returns: UILabel
    @discardableResult
    func ss_numberOfLines(_ numberOfLines: Int = 0) -> Self {
        self.numberOfLines = numberOfLines
        return self
    }

}

public extension UILabel {
    
    /// 获取文本内容
    var ss_text: String {
        if let text = self.text {
            return text
        }else if let text = self.attributedText?.string {
            return text
        }else{
            return ""
        }
    }
    
    /// 复制文本之后的回调通知名称
    static var ss_copiedNotification: Notification.Name {
        return Notification.Name.init("ss_uiLabel_copiedNotification")
    }
}

public extension UILabel {
    
    /// 设置高度
    ///
    /// - Parameter edge: 文本与Label上下边缘的间距
    /// - Returns: UILabel
    @discardableResult
    func ss_fitHeight(with edge: CGFloat = 0) -> Self {
        height = ss_text.ss_nsString.height(for: font, width: width) + (edge * 2)
        return self
    }
    
    /// 设置宽度
    ///
    /// - Parameter edge: 文本与Label左右边缘的间距
    /// - Returns: UILabel
    @discardableResult
    func ss_fitWidth(with edge: CGFloat = 0) -> Self {
        width = ss_text.ss_nsString.width(for: font) + (edge * 2)
        return self
    }
}

public extension QMUILabel {

    /// 控制label内容的padding
    @discardableResult
    func ss_contentInset(top: CGFloat, left: CGFloat, bottom: CGFloat, right: CGFloat) -> Self {
        contentEdgeInsets = UIEdgeInsets(top: top, left: left, bottom: bottom, right: right)
        return self
    }
    
    /// 让Label支持长按手势，且弹出“复制”的menuitem, 点击复制后的回调以通知的形式发出
    @discardableResult
    func ss_canPerformCopyAction() -> Self {
        canPerformCopyAction = true
        self.didCopyBlock = { label, copyString in
            NotificationCenter.default.post(name: UILabel.ss_copiedNotification, object: (label, copyString))
        }
        return self
    }
}


