//
//  AttributeString.swift
//  SSUIKit
//
//  Created by 吴頔 on 2019/11/30.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import UIKit
import YYText
import QMUIKit

public extension NSMutableAttributedString {
    /// 改变颜色
    ///
    /// - Parameters:
    ///   - color: 颜色
    ///   - text: 要改变颜色的字符串
    /// - Returns: NSMutableAttributedString
    @discardableResult
    open func ss_color(color: UIColor?, with text: String? = nil) -> NSMutableAttributedString {
        guard let color = color else { return self }
        var str = text ?? ""
        if text == nil {
            str = self.string
        }
        if !string.contains(str) { return self }
        let range = string.ss_nsString.range(of: str)
        addAttribute(.foregroundColor, value: color, range: range)
        return self
    }
    
    /// 改变文字背景颜色
    /// - Parameter color: 颜色
    /// - Parameter text: 要改变颜色的字符串背景
    @discardableResult
    open func ss_backgroundColor(color: UIColor?, with text: String? = nil) -> NSMutableAttributedString {
        guard let color = color else { return self }
        var str = text.orEmpty
        if text == nil {
            str = self.string
        }
        if !string.contains(str) { return self }
        let range = string.ss_nsString.range(of: str)
        addAttribute(.backgroundColor, value: color, range: range)
        return self
    }
    
    /// 改变字体大小
    ///
    /// - Parameters:
    ///   - fontSize: 字体大小
    ///   - isBord: 是否加粗
    ///   - text: 要改变字体大小的字符串
    /// - Returns: NSMutableAttributedString
    @discardableResult
    open func ss_font(
        font: UIFont,
        with text: String? = nil
        ) -> NSMutableAttributedString {
        var str = text.orEmpty
        if text == nil {
            str = self.string
        }
        if !string.contains(str) { return self }
        
        let range = string.ss_nsString.range(of: str)

        addAttribute(.font, value: font, range: range)
        return self
    }
    
    /// 改变字符串的对齐方式
    ///
    /// - Parameters:
    ///   - alignment: NSTextAlignment
    ///   - text: 要改变对齐方式的字符串
    /// - Returns: NSMutableAttributedString
    @discardableResult
    open func ss_alignment(alignment: NSTextAlignment, with lineSpacing: CGFloat = 0, with text: String? = nil) -> NSMutableAttributedString {
        var str = text.orEmpty
        if text == nil {
            str = self.string
        }
        if !string.contains(str) { return self }
        let range = string.ss_nsString.range(of: str)
        let paragraph = NSMutableParagraphStyle()
        paragraph.alignment = alignment
        if lineSpacing > 0 {
            paragraph.lineSpacing = lineSpacing
        }
        
        addAttribute(.paragraphStyle, value: paragraph, range: range)
        return self
    }
    
    
    /// 添加字符串的样式
    ///
    /// - Parameter text: 要添加样式的字符串
    /// - Returns: NSMutableAttributedString
    @discardableResult
    open func ss_addAttribute(key: NSAttributedString.Key, value: Any? = nil, with text:String? = nil) -> NSMutableAttributedString{
        var str = text.orEmpty
        if text == nil {
            str = self.string
        }
        if !string.contains(str) { return self }
        let range = string.ss_nsString.range(of: str)
        let addValue = value == nil ? NSNumber(value: 1) : value!
        addAttribute(key, value: addValue, range: range)
        return self
    }
    
    /// 添加图片
    ///
    /// - Parameters:
    ///   - image: UIImage
    ///   - bounds: CGRect
    ///   - text: 在哪个文本的后面
    /// - Returns: NSMutableAttributedString
    @discardableResult
    open func ss_image(image: UIImage?, bounds: CGRect, behind text: String? = nil, insertAtFirst: Bool = false) -> NSMutableAttributedString {
        
        guard let image = image else { return self }
        
        var str = text.orEmpty
        if text == nil {
            str = self.string
        }
        let attachment = NSTextAttachment()
        attachment.image = image
        attachment.bounds = bounds
        let imageAttribute = NSAttributedString(attachment: attachment)
        if insertAtFirst {
            insert(imageAttribute, at: 0)
        }else{
            insert(imageAttribute, at: str.count)
        }
        
        return self
    }
    
    /// 设置整体的对齐方式及行间距
    ///
    /// - Parameters:
    ///   - aligment: 对齐方式
    ///   - lineSpacing: 间距
    /// - Returns: NSMutableAttributedString
    @discardableResult
    open func ss_alignment(_ aligment: NSTextAlignment, lineSpacing: CGFloat? = nil) -> NSMutableAttributedString {
        let paragraph = NSMutableParagraphStyle()
        paragraph.alignment = aligment
        if let lineSpacing = lineSpacing {
            paragraph.lineSpacing = lineSpacing
        }
        addAttribute(.paragraphStyle, value: paragraph, range: NSMakeRange(0, string.count))
        return self
    }
}

public extension NSMutableAttributedString {
    var ss_layout: YYTextLayout? {
        let conteiner = YYTextContainer(size: CGSize(width: CGFloat.infinity, height:  CGFloat.infinity))
        let layout = YYTextLayout(container: conteiner, text: self)
        return layout
    }
    
    var ss_image: UIImage? {
        return UIImage.qmui_image(with: self)
    }
    
}
