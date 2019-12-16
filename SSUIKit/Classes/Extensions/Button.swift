//
//  Button.swift
//  SSUIKit
//
//  Created by 吴頔 on 2019/11/30.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import UIKit
import QMUIKit
import YYCategories
import Kingfisher
import RxSwift
import RxCocoa

public typealias Button = QMUIButton

public protocol SSUIButtonCompatible {}
extension UIButton: SSUIButtonCompatible {}

public extension SSUIButtonCompatible where Self: UIButton {
    
    /// 设置按钮标题内容
    ///
    /// - Parameter text: String
    /// - Parameter state: UIControl.State
    /// - Returns: UIButton
    @discardableResult
    func ss_title(_ title: Any?, for state: UIControl.State? = .normal) -> Self {
        guard let title = title else { return self }
        if let state = state {
            setTitle("\(title)", for: state)
        }else{
            setTitle("\(title)", for: .normal)
        }
        return self
    }
   
    /// 设置按钮标题富文本
    ///
    /// - Parameter text: String
    /// - Returns: UIButton
    @discardableResult
    func ss_attributeTitle(_ title: NSMutableAttributedString?, for state: UIControl.State? = .normal) -> Self {
        if let state = state {
            setAttributedTitle(title, for: state)
        }else{
            setAttributedTitle(title, for: .normal)
        }
        return self
    }
    
    /// 设置按钮标题颜色
    ///
    /// - Parameter color: UIColor
    /// - Parameter state: UIControl.State
    /// - Returns: UIButton
    @discardableResult
    func ss_titleColor(_ color: UIColor?, for state: UIControl.State? = .normal) -> Self {
        if isKind(of: QMUIButton.self) && color != .white {
            tintColor = color
        }
        setTitleColor(color, for: state ?? .normal)
        return self
    }
    
    /// 设置按钮图片
    ///
    /// - Parameter image: UIImage
    /// - Parameter state: UIControl.State
    /// - Returns: UIButton
    @discardableResult
    func ss_image(_ image: UIImage?, for state: UIControl.State? = .normal) -> Self {
        imageView?.contentMode = .scaleAspectFit
        if let state = state {
            setImage(image, for: state)
        }else{
            setImage(image, for: .normal)
        }
        return self
    }
    
    /// 设置按钮背景图片(用图片)
    ///
    /// - Parameter image: UIImage
    /// - Parameter state: UIControl.State
    /// - Returns: UIButton
    @discardableResult
    func ss_backgroundImage(_ image: UIImage?, for state: UIControl.State? = .normal) -> Self {
        if let state = state {
            setBackgroundImage(image, for: state)
        }else{
            setBackgroundImage(image, for: .normal)
        }
        return self
    }
    
    /// 设置按钮背景图片(用Color)
    ///
    /// - Parameter image: UIImage
    /// - Parameter state: UIControl.State
    /// - Returns: UIButton
    @discardableResult
    func ss_backgroundImage(_ color: UIColor? = .white, for state: UIControl.State? = .normal) -> Self {
        var image: UIImage?
        
        if let color = color {
            image = UIImage(color: color)
        }else{
            image = UIImage(color: .white)
        }
        
        if let state = state {
            setBackgroundImage(image, for: state)
        }else{
            setBackgroundImage(image, for: .normal)
        }
        
        if isKind(of: QMUIButton.self) && color != .white {
            tintColor = .white
            ss_titleColor(.white)
        }
      
        return self
    }
    
    /// 设置按钮标题字体
    /// - Parameter font: 字体
    @discardableResult
    func ss_font(_ font: UIFont) -> Self {
        titleLabel?.font = font
        return self
    }
    
    /// 设置按钮标题字体
    ///
    /// - Parameters:
    ///   - fontSize: 字号
    ///   - isBold: 是否加粗
    ///   - autoFixBase47Inch: 是否需要根据屏幕尺寸自适应（以4.7英寸为标准，小于4.7字号减1，大于4.7字号加1）
    /// - Returns: UIButton
    @discardableResult
    func ss_font(_ fontSize: CGFloat, isBold: Bool? = false) -> Self {
        if isBold == true {
            titleLabel?.font = .boldSystemFont(ofSize: fontSize)
        }else{
            titleLabel?.font = .systemFont(ofSize: fontSize)
        }
        return self
    }
    
    /// 设置按钮内容水平对齐方式
    ///
    /// - Parameter contentHorizontalAlignment: ContentHorizontalAlignment
    /// - Returns: UIButton
    @discardableResult
    func ss_horizontalAlignment(_ contentHorizontalAlignment: UIControl.ContentHorizontalAlignment) -> Self {
        self.contentHorizontalAlignment = contentHorizontalAlignment
        return self
    }
    
    /// 设置按钮内容垂直对齐方式
    ///
    /// - Parameter contentHorizontalAlignment: ContentHorizontalAlignment
    /// - Returns: UIButton
    @discardableResult
    func ss_verticalAlignment(_ contentVerticalAlignment: UIControl.ContentVerticalAlignment) -> Self {
        self.contentVerticalAlignment = contentVerticalAlignment
        return self
    }
    
    /// 设置按钮图片显示方式
    ///
    /// - Parameter mode: ContentMode
    /// - Returns: UIButton
    @discardableResult
    func ss_contentMode(_ mode: UIView.ContentMode = .scaleAspectFill) -> Self {
        self.imageView?.contentMode = mode
        return self
    }
    
    /// 设置按钮图片显示方式
    ///
    /// - Parameter numberOfLines: 文本显示多少行
    /// - Returns: UIButton
    @discardableResult
    func ss_numberOfLines(_ numberOfLines: Int = 0) -> Self {
        titleLabel?.numberOfLines = numberOfLines
        return self
    }
 
    /// 加载网络图片
    ///
    /// - Parameter urlString: 图片链接地址
    /// - Returns: UIImageView
    @discardableResult
    func ss_kingfisherImage(_ urlString: String?, placeholder: UIImage? = nil) -> Self {
        self.kf.setImage(with: urlString?.ss_url, for: .normal, placeholder: placeholder)
        self.kf.setImage(with: urlString?.ss_url, for: .highlighted, placeholder: placeholder)
        return self
    }
    
    /// 点击按钮时收起键盘
    @discardableResult
    func ss_endEditingWhenTap() -> Self {
        _ = rx.tap.asObservable()
            .subscribe(onNext: { (_) in
                UIApplication.endEditing()
            })
        return self
    }
}

extension UIButton {
    @objc func endEditingWhenTap() {
        UIApplication.endEditing()
    }
}

public extension UIButton {
    
    /// 获取按钮标题
    var ss_title: String { return titleLabel?.text ?? "" }
    
    /// 标题字体大小
    var ss_fontSize: CGFloat { return titleLabel?.font.pointSize ?? 0 }
    
}

public extension UIButton {
    
    /// 设置高度
    ///
    /// - Parameter edge: 文本与Label上下边缘的间距
    /// - Returns: UILabel
    @discardableResult
    func ss_fitHeight(with edge: CGFloat = 0) -> Self {
        guard let titleLabel = titleLabel, let font = titleLabel.font else { return self }
        height = ss_title.ss_nsString.height(for: font, width: width) + (edge * 2)
        return self
    }
    
    /// 设置宽度
    ///
    /// - Parameter edge: 文本与Label左右边缘的间距
    /// - Returns: UIButton
    @discardableResult
    func ss_fitWidth(with space: CGFloat = 0) -> Self {
        guard let titleLabel = titleLabel, let font = titleLabel.font else { return self }
        width = ss_title.ss_nsString.width(for: font) + (space * 2)
        return self
    }
    
    /// 为文本和图片之间添加间距
    ///
    /// - Parameter space: 间距值
    /// - Returns: UIButton
    @discardableResult
    func ss_addEdge(with space: CGFloat = 5) -> Self {
        titleEdgeInsets = UIEdgeInsets(top: 0, left: space, bottom: 0, right: 0)
        return self
    }
    
    /// 为文本添加上下左右间距
    ///
    /// - Parameter contentInsets: UIEdgeInsets
    /// - Returns: UIButton
    @discardableResult
    func ss_titleEdgeInsets(_ contentInsets: UIEdgeInsets) -> Self {
        titleEdgeInsets = contentInsets
        return self
    }
    
    /// 为图片添加上下左右间距
    ///
    /// - Parameter contentInsets: UIEdgeInsets
    /// - Returns: UIButton
    @discardableResult
    func ss_imageEdgeInsets(_ contentInsets: UIEdgeInsets) -> Self {
        imageEdgeInsets = contentInsets
        return self
    }
}

public enum SSButtonStyle {
    /// 默认圆角的按钮（圆角为4）
    case `default`
    /// 按钮颜色全部填充，且圆角为按钮高度的一半，会随着按钮大小的变化而变化
    case filled(tintColor: UIColor?)
    /// 按钮为透明，有边框颜色，且圆角为按钮高度的一半，会随着按钮大小的变化而变化
    case border(tintColor: UIColor?)
}

public enum SSButtonTintColorStrategy {
    /// 让按钮的文字颜色自动跟随tintColor调整
    case title
    /// 让按钮的图片颜色自动跟随tintColor调整
    case image
    /// 让按钮的文字颜色和图片颜色自动跟随tintColor调整
    case titleAndImage
}

public extension QMUIButton {
    
    /// 设置按钮风格
    /// - Parameter style: SSButtonStyle
    @discardableResult
    func ss_style(_ style: SSButtonStyle) -> QMUIButton {
        switch style {
            
        case let .filled(tintColor):
            let button = QMUIFillButton()
            button.fillColor = tintColor
            return button
            
        case let .border(tintColor):
            let button = QMUIGhostButton()
            button.ghostColor = tintColor
            return button
            
        default:
            return self
        }
    }
    
    /// 设置tintColor
    /// - Parameter color: 颜色
    /// - Parameter strategy: 策略
    @discardableResult
    func ss_tintColor(_ color: UIColor?, strategy: SSButtonTintColorStrategy) -> Self {
        tintColor = color
        adjustsTitleTintColorAutomatically = true
        return self
    }
    
    /// 设置按钮点击时的背景色
    /// - Parameter color: 颜色
    /// - Parameter isLight: 点击时的颜色是深色还是浅色 (isLight == true 表示浅色)
    /// - Parameter progress: 浅色透明度
    @discardableResult
    func ss_highlightedBackgroundColor(_ color: UIColor, isLight: Bool = true, progress: CGFloat? = nil) -> Self {
        let toColor: UIColor = isLight ? .white : .black
        let toProgress: CGFloat = isLight ? 0.75 : 0.15
        let newProgress = progress == nil ? toProgress : progress!
        highlightedBackgroundColor = color.qmui_transition(to: toColor, progress: newProgress)
        return self
    }
    
    /// 图片+文字的按钮，设置图片的位置
    /// - Parameter position: QMUIButtonImagePosition
    /// - Parameter spacing: 图片与文字之间的距离
    @discardableResult
    func ss_imagePosition(_ position: QMUIButtonImagePosition, spacing: CGFloat = 8) -> Self {
        imagePosition = position
        spacingBetweenImageAndTitle = spacing
        return self
    }

}
