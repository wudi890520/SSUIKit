//
//  SSAlertConfiguration.swift
//  DeviceKit
//
//  Created by 吴頔 on 2019/12/6.
//

import UIKit
import JCAlertController

class SSAlertTitle {
    var font: UIFont? = UIFont.largeTitle.bold
    var textColor: UIColor? = .black
    var onlyTitleInsets = UIEdgeInsets(top: 40, left: 20, bottom: 40, right: 20)
    var insets = UIEdgeInsets(top: 25, left: 20, bottom: 10, right: 20)
    var textAlignment: NSTextAlignment = .center
    
    func reload() {
        JCAlertStyle.share()?.title.font = font
        JCAlertStyle.share()?.title.textColor = textColor
        JCAlertStyle.share()?.title.onlyTitleInsets = onlyTitleInsets
        JCAlertStyle.share()?.title.insets = insets
        JCAlertStyle.share()?.title.textAlignment = textAlignment
    }
}

class SSAlertContent {
    var font: UIFont? = UIFont.lightTitle
    var textColor: UIColor? = .gray
    var onlyMessageInsets = UIEdgeInsets(top: 40, left: 20, bottom: 40, right: 20)
    var insets = UIEdgeInsets(top: 5, left: 20, bottom: 25, right: 20)
    var textAlignment: NSTextAlignment = .center
    
    func reload() {
        JCAlertStyle.share()?.content.font = font
        JCAlertStyle.share()?.content.textColor = textColor
        JCAlertStyle.share()?.content.onlyMessageInsets = onlyMessageInsets
        JCAlertStyle.share()?.content.insets = insets
        JCAlertStyle.share()?.content.textAlignment = textAlignment
    }
}

class SSAlertCancelButton {
    var font: UIFont? = UIFont.with(17)
    var textColor: UIColor? = .gray
    var highlightTextColor: UIColor? = .lightGray
    var highlightBackgroundColor: UIColor? = .ss_background
    var height: CGFloat = 54
    
    func reload() {
        JCAlertStyle.share()?.buttonCancel.font = font
        JCAlertStyle.share()?.buttonCancel.textColor = textColor
        JCAlertStyle.share()?.buttonCancel.highlightTextColor = highlightTextColor
        JCAlertStyle.share()?.buttonCancel.highlightBackgroundColor = highlightBackgroundColor
        JCAlertStyle.share()?.buttonCancel.height = height
    }
}

class SSAlertNormalButton {
    var font: UIFont? = UIFont.with(17).bold
    var textColor: UIColor? = .ss_main
    var highlightTextColor: UIColor? = .ss_main
    var highlightBackgroundColor: UIColor? = .ss_background
    var height: CGFloat = 54
    
    func reload() {
        JCAlertStyle.share()?.buttonNormal.font = font
        JCAlertStyle.share()?.buttonNormal.textColor = textColor
        JCAlertStyle.share()?.buttonNormal.highlightTextColor = highlightTextColor
        JCAlertStyle.share()?.buttonNormal.highlightBackgroundColor = highlightBackgroundColor
        JCAlertStyle.share()?.buttonNormal.height = height
    }
}

class SSAlertSeparator {
    var color: UIColor? = .ss_line
    var width: CGFloat = .line
    
    func reload() {
        JCAlertStyle.share()?.separator.color = color
        JCAlertStyle.share()?.separator.width = width
        
        JCAlertStyle.share()?.background.alpha = 4
    }
}

class SSAlertDisplayView {
    var width: CGFloat = CGFloat.screenWith - 40
    var maxHeight: CGFloat = CGFloat.screenHeight
    var cornerRadius: CGFloat = 13
    var backgroundColor: UIColor? = .white
    
    func reload() {
        JCAlertStyle.share()?.alertView.width = width
        JCAlertStyle.share()?.alertView.maxHeight = maxHeight
        JCAlertStyle.share()?.alertView.cornerRadius = cornerRadius
        JCAlertStyle.share()?.alertView.backgroundColor = backgroundColor
    }
}

class SSAlertBackground {
    var alpha: Float = 0.4
    
    func reload() {
        JCAlertStyle.share()?.background.alpha = alpha
    }
}

public class SSAlertConfiguration: NSObject {

    static let shared = SSAlertConfiguration()
    
    /// 标题
    internal let title = SSAlertTitle()
    
    /// 内容
    internal let content = SSAlertContent()
    
    /// 内容
    internal let cancelButton = SSAlertCancelButton()
    
    /// 内容
    internal let normalButton = SSAlertNormalButton()
    
    /// 分割线
    internal let separator = SSAlertSeparator()
    
    /// 显示的视图
    internal let displayView = SSAlertDisplayView()
    
    /// 背景
    internal let background = SSAlertBackground()
    
    private override init() {
        super.init()
    }
    
}

extension SSAlertConfiguration {
    func reloadStyle() {
        title.reload()
        content.reload()
        cancelButton.reload()
        normalButton.reload()
        separator.reload()
        displayView.reload()
        background.reload()
    }
}

public extension SSAlertConfiguration {
    
    struct Title {
        public static var font: UIFont? = UIFont.largeTitle.bold {
            didSet { SSAlertConfiguration.shared.title.font = font }
        }
        
        public static var textColor: UIColor? = .black {
            didSet { SSAlertConfiguration.shared.title.textColor = textColor }
        }
        
        public static var onlyTitleInsets: UIEdgeInsets = UIEdgeInsets(top: 40, left: 20, bottom: 40, right: 20) {
            didSet { SSAlertConfiguration.shared.title.onlyTitleInsets = onlyTitleInsets }
        }
        
        public static var insets: UIEdgeInsets = UIEdgeInsets(top: 25, left: 20, bottom: 10, right: 20) {
            didSet { SSAlertConfiguration.shared.title.insets = insets }
        }
        
        public static var textAlignment: NSTextAlignment = .center {
            didSet { SSAlertConfiguration.shared.title.textAlignment = textAlignment }
        }
    }
    
    struct Content {
        public static var font: UIFont? = UIFont.largeTitle.bold {
            didSet { SSAlertConfiguration.shared.content.font = font }
        }
        
        public static var textColor: UIColor? = .black {
            didSet { SSAlertConfiguration.shared.content.textColor = textColor }
        }
        
        public static var onlyMessageInsets: UIEdgeInsets = UIEdgeInsets(top: 40, left: 20, bottom: 40, right: 20) {
            didSet { SSAlertConfiguration.shared.content.onlyMessageInsets = onlyMessageInsets }
        }
        
        public static var insets: UIEdgeInsets = UIEdgeInsets(top: 5, left: 20, bottom: 25, right: 20) {
            didSet { SSAlertConfiguration.shared.content.insets = insets }
        }
        
        public static var textAlignment: NSTextAlignment = .center {
            didSet { SSAlertConfiguration.shared.content.textAlignment = textAlignment }
        }
    }
    
    struct CancelButton {
        public static var font: UIFont? = UIFont.with(17) {
            didSet { SSAlertConfiguration.shared.cancelButton.font = font }
        }
        
        public static var textColor: UIColor? = .gray {
            didSet { SSAlertConfiguration.shared.cancelButton.textColor = textColor }
        }
        
        public static var highlightTextColor: UIColor? = .lightGray {
            didSet { SSAlertConfiguration.shared.cancelButton.highlightTextColor = highlightTextColor }
        }
        
        public static var highlightBackgroundColor: UIColor? = .ss_background {
            didSet { SSAlertConfiguration.shared.cancelButton.highlightBackgroundColor = highlightBackgroundColor }
        }
        
        public static var height: CGFloat = 54 {
            didSet { SSAlertConfiguration.shared.cancelButton.height = height }
        }
    }
    
    struct NormalButton {
        public static var font: UIFont? = UIFont.with(17).bold {
            didSet { SSAlertConfiguration.shared.normalButton.font = font }
        }
        
        public static var textColor: UIColor? = .ss_main {
            didSet { SSAlertConfiguration.shared.normalButton.textColor = textColor }
        }
        
        public static var highlightTextColor: UIColor? = .ss_main {
            didSet { SSAlertConfiguration.shared.normalButton.highlightTextColor = highlightTextColor }
        }
        
        public static var highlightBackgroundColor: UIColor? = .ss_background {
            didSet { SSAlertConfiguration.shared.normalButton.highlightBackgroundColor = highlightBackgroundColor }
        }
        
        public static var height: CGFloat = 54 {
            didSet { SSAlertConfiguration.shared.normalButton.height = height }
        }
    }
    
    struct Separator {
        public static var color: UIColor? = .ss_line {
            didSet { SSAlertConfiguration.shared.separator.color = color }
        }
        
        public static var width: CGFloat = .line {
            didSet { SSAlertConfiguration.shared.separator.width = width }
        }
    }
    
    struct DisplayView {
        public static var width: CGFloat = CGFloat.screenWith - 40 {
            didSet { SSAlertConfiguration.shared.displayView.width = width }
        }
        
        public static var maxHeight: CGFloat = CGFloat.screenHeight {
            didSet { SSAlertConfiguration.shared.displayView.maxHeight = maxHeight }
        }
        
        public static var cornerRadius: CGFloat = 15 {
            didSet { SSAlertConfiguration.shared.displayView.cornerRadius = cornerRadius }
        }
        
        public static var backgroundColor: UIColor? = .white {
            didSet { SSAlertConfiguration.shared.displayView.backgroundColor = backgroundColor }
        }
    }
    
    struct Background {
        public static var alpha: Float = 0.4 {
            didSet { SSAlertConfiguration.shared.background.alpha = alpha }
        }
    }
}
