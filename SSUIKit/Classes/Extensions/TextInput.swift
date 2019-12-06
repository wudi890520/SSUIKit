//
//  TextInput.swift
//  SSUIKit_Example
//
//  Created by 吴頔 on 2019/12/4.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import UIKit

public extension UITextInput {
    
    /// 输入框文本内容
    var ss_text: String? {
        if let textField = self as? UITextField {
            return textField.text
        }else if let textView = self as? UITextView {
            return textView.text
        }
        return nil
    }
    
    /// 输入框位数限制
    var ss_limit: Int? {
        if let textField = self as? UITextField {
            return textField.ss_limit
        }else if let textView = self as? UITextView {
            return textView.ss_limit
        }
        return nil
    }
    
    /// 输入框整数部分位数限制
    var ss_integerLimit: Int? {
        if let textField = self as? UITextField {
            return textField.ss_integerLimit
        }else if let textView = self as? UITextView {
            return textView.ss_integerLimit
        }
        return nil
    }
    
    /// 输入框小数部分位数限制
    var ss_decimalLimit: Int? {
        if let textField = self as? UITextField {
            return textField.ss_decimalLimit
        }else if let textView = self as? UITextView {
            return textView.ss_decimalLimit
        }
        return nil
    }
    
    /// 输入框键盘风格
    var ss_keyboardType: SSKeyboardType? {
        if let textField = self as? UITextField {
            return textField.ss_keyboardType
        }else if let textView = self as? UITextView {
            return textView.ss_keyboardType
        }
        return nil
    }
    
    /// 是否显示“收回键盘”按钮
    var ss_dismissKeyboardEnable: Bool? {
        if let textField = self as? UITextField {
            return textField.ss_dismissKeyboardEnable
        }else if let textView = self as? UITextView {
            return textView.ss_dismissKeyboardEnable
        }
        return nil
    }
    
}

public extension UITextInput {
    
    /// 从后面开始删除输入框的文本内容
    ///
    /// - Parameter count: 删除几位
    func ss_deleteBackward(_ count: Int?) {
        for _ in 0 ..< (count ?? 0) {
            deleteBackward()
        }
    }
    
    /// 插入新文本
    ///
    /// - Parameter text: 文本内容
    func ss_intert(_ text: String?) {
        insertText(text ?? "")
        ss_addBlankIfNeeded()
    }
    
    /// 添加空格（当输入框键盘类型为mobile时生效）
    func ss_addBlankIfNeeded() {
        guard let keyboardType = ss_keyboardType, keyboardType == .mobile else { return }

        func handle(_ string: String) -> String? {
            let text = string.filter(keywords: " ").ss_sub(to: 11)
            if text.count > 3 && text.count <= 7 {
                return "\(text.ss_sub(to: 3)) \(text.ss_sub(from: 3))"
            }else if text.count > 7 && text.count <= 11 {
                return "\(text.ss_sub(to: 3)) \(text.ss_sub(from: 3).ss_sub(to: 4)) \(text.ss_sub(from: 7))"
            }
            return nil
        }
        
        if let textField = self as? UITextField, let textString = textField.text {
            if let text = handle(textString) {
                textField.text = text
            }
        }else if let textView = self as? UITextView, let textString = textView.text {
            if let text = handle(textString) {
                textView.text = text
            }
        }
    }
}
