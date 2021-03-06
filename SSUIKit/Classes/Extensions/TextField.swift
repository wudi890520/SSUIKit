//
//  TextField.swift
//  SSUIKit
//
//  Created by 吴頔 on 2019/11/30.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import UIKit
import QMUIKit

public typealias TextField = QMUITextField

/// 限制输入框位数类型
///
/// - all: 限制全部字符
/// - integer: 限制整数部分
/// - decimal: 限制小数部分
public enum SSInputLimitType {

    /// 限制全部字符
    case all
    
    /// 限制整数部分
    case integer
    
    /// 限制小数部分
    case decimal
}

public extension UITextField {
    
    private struct AssociatedKeys {
        
        /// 键盘类型
        static var keyboardType = "ss_uiTextField_keyboardType"
        
        /// 极值位数
        static var limit = "ss_uiTextField_limit"
        
        /// 如果键盘类型为浮点型，整数部分的极值位数
        static var integerLimit = "ss_uiTextField_integerLimit"
        
        /// 如果键盘类型为浮点型，小数部分的极值位数
        static var decimalLimit = "ss_uiTextField_decimalLimit"
        
        /// 是否显示收回键盘按钮
        static var dismissKeyboardEnable = "ss_uiTextField_dismissKeyboardEnable"
    }
    
    /// 键盘类型
    var ss_keyboardType: SSKeyboardType? {
        set {
            objc_setAssociatedObject(self, &type(of: self).AssociatedKeys.keyboardType, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        get {
            return objc_getAssociatedObject(self, &type(of: self).AssociatedKeys.keyboardType) as? SSKeyboardType
        }
    }
    
    /// 极值位数
    var ss_limit: Int? {
        set {
            objc_setAssociatedObject(self, &type(of: self).AssociatedKeys.limit, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        get {
            return objc_getAssociatedObject(self, &type(of: self).AssociatedKeys.limit) as? Int
        }
    }
    
    /// 如果键盘类型为浮点型，整数部分的极值位数
    var ss_integerLimit: Int? {
        set {
            objc_setAssociatedObject(self, &type(of: self).AssociatedKeys.integerLimit, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        get {
            return objc_getAssociatedObject(self, &type(of: self).AssociatedKeys.integerLimit) as? Int
        }
    }
    
    /// 如果键盘类型为浮点型，小数部分的极值位数
    var ss_decimalLimit: Int? {
        set {
            objc_setAssociatedObject(self, &type(of: self).AssociatedKeys.decimalLimit, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        get {
            return objc_getAssociatedObject(self, &type(of: self).AssociatedKeys.decimalLimit) as? Int
        }
    }
    
    /// 是否自动显示收回键盘按钮
    var ss_dismissKeyboardEnable: Bool? {
        set {
            objc_setAssociatedObject(self, &type(of: self).AssociatedKeys.dismissKeyboardEnable, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        get {
            return objc_getAssociatedObject(self, &type(of: self).AssociatedKeys.dismissKeyboardEnable) as? Bool
        }
    }
}

public protocol SSUITextFieldCompatible {}
extension TextField: SSUITextFieldCompatible {}

public extension SSUITextFieldCompatible where Self: TextField {
    /// 设置文本内容
    ///
    /// - Parameter text: String
    /// - Returns: UITextField
    @discardableResult
    func ss_text(_ text: String?) -> Self {
        self.text = text
        return self
    }

    /// 设置富文本内容
    ///
    /// - Parameter attribute: NSMutableAttributedString
    /// - Returns: UITextField
    @discardableResult
    func ss_attribute(_ attribute: NSMutableAttributedString) -> Self {
        self.attributedText = attribute
        return self
    }

    /// 设置文本颜色
    ///
    /// - Parameter color: UIColor
    /// - Returns: UITextField
    @discardableResult
    func ss_textColor(_ color: UIColor?) -> Self {
        self.textColor = color
        return self
    }

    /// 设置文本对齐方式
    ///
    /// - Parameter textAlignment: NSTextAlignment
    /// - Returns: UITextField
    @discardableResult
    func ss_textAlignment(_ textAlignment: NSTextAlignment) -> Self {
        self.textAlignment = textAlignment
        return self
    }

    /// 设置文本字体大小
    ///
    /// - Parameters:
    ///   - font: 字体
    /// - Returns: UITextField
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
    /// - Returns: UITextField
    @discardableResult
    func ss_font(_ fontSize: CGFloat, isBold: Bool? = false) -> Self {
        if isBold == true {
            font = .boldSystemFont(ofSize: fontSize)
        }else{
            font = .systemFont(ofSize: fontSize)
        }
        return self
    }

    /// 设置提示文本
    ///
    /// - Parameter placeholder: String
    /// - Returns: UITextField
    @discardableResult
    func ss_placeholder(_ placeholder: String) -> Self {
        self.placeholder = placeholder
        return self
    }

    /// 设置输入位数长度
    ///
    /// - Returns: UITextField
    @discardableResult
    func ss_limit(_ count: Int?, for type: SSInputLimitType = .all) -> Self {
        switch type {
        case .all:
            self.ss_limit = count
            if let count = count {
                maximumTextLength = UInt(count)
            }else{
                maximumTextLength = UInt.max
            }
        case .integer:
            self.ss_integerLimit = count
            maximumTextLength = UInt.max
        case .decimal:
            self.ss_decimalLimit = count
            maximumTextLength = UInt.max
        }

        /// 防止先设置了键盘类型，后设置位数长度的情况
        if let keyboardType = ss_keyboardType {
            ss_keyboardType(keyboardType)
        }
        
        return self
    }

    /// 设置键盘类型()
    ///
    /// - Parameter keyboardType: SSKeyboardType
    /// - Returns: UITextField
    @discardableResult
    func ss_keyboardType(_ keyboardType: SSKeyboardType? = nil) -> Self {
        
        guard let keyboardType = keyboardType else { return self }
        
        self.ss_keyboardType = keyboardType

        if keyboardType == .default {
            inputView = nil
        }else{
            inputView = SSKeyboardView(keyboardType, input: self)
        }
        return self
    }

    /// 设置显示”回收键盘“按钮
    ///
    /// - Parameter keyboardType: SSKeyboardType
    /// - Returns: UITextField
    @discardableResult
    func ss_showDismissButtonItem(_ enable: Bool = true) -> Self {
        self.ss_dismissKeyboardEnable = enable
        if enable {
            let inputAccessoryView = UIView(frame: CGRect(x: 0, y: 0, width: CGFloat.screenWidth, height: 44))
            self.inputAccessoryView = inputAccessoryView
            SSKeyboardDoneButtonManager.setup()
        }else{
            self.inputAccessoryView = nil
        }
        return self
    }

    /// 设置成密码输入样式
    ///
    /// - Returns: UITextField
    @discardableResult
    func ss_secureTextEntry(_ isSecureTextEntry: Bool = true) -> Self {
        self.isSecureTextEntry = isSecureTextEntry
        return self
    }

    /// 设置删除按钮模式
    ///
    /// - Returns: UITextField
    @discardableResult
    func ss_clearButtonMode(_ mode: UITextField.ViewMode = .whileEditing) -> Self {
        clearButtonMode = mode
        return self
    }

    /// 弹出键盘，成为第一响应者
    ///
    /// - Returns: UITextField
    @discardableResult
    func ss_becomeFirstResponder(_ afterDelay: TimeInterval = 0) -> Self {
        if afterDelay == 0 {
            becomeFirstResponder()
        }else{
            perform(#selector(becomeFirstResponder), afterDelay: afterDelay)
        }
        becomeFirstResponder()
        return self
    }

    /// 收回键盘
    ///
    /// - Returns: UITextField
    @discardableResult
    func ss_resignFirstResponder() -> Self {
        resignFirstResponder()
        return self
    }

    /// 设置左视图
    ///
    /// - Parameter view: UIView
    /// - Returns: UITextField
    @discardableResult
    func ss_leftView(_ view: UIView?) -> Self {
        guard let view = view else {
            self.leftView = nil
            self.leftViewMode = .never
            return self
        }
        let leftView = UIView(frame: view.bounds)
        leftView.ss_add(view)
        self.leftView = leftView
        self.leftViewMode = .always
        return self
    }

    /// 设置右视图
    ///
    /// - Parameter view: UIView
    /// - Returns: UITextField
    @discardableResult
    func ss_rightView(_ view: UIView?) -> Self {
        guard let view = view else {
            self.rightView = nil
            self.rightViewMode = .never
            return self
        }
        let rightView = UIView(frame: view.bounds)
        rightView.ss_add(view)
        self.rightView = rightView
        self.rightViewMode = .always
        return self
    }
    
    /// 控制TextField内容的padding
    @discardableResult
    func ss_contentInset(top: CGFloat, left: CGFloat, bottom: CGFloat, right: CGFloat) -> Self {
        textInsets = UIEdgeInsets(top: top, left: left, bottom: bottom, right: right)
        return self
    }
}

public extension SSUITextFieldCompatible where Self: TextField {
    
    /// 追加字符串（会将原有的文本和新追加的拼起来）
    /// - Parameter string: 要追加的文本
    @discardableResult
    func ss_append(_ string: String? = nil) -> Self {
        let originText = (text == nil).ss_ternary("", text!)
        let appendText = (string == nil).ss_ternary("", string!)
        let text = "\(originText)\(appendText)"
        self.text = text
        return self
    }
    
}
