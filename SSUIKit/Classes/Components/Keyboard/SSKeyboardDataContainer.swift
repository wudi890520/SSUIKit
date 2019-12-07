//
//  KeyboardDataContainer.swift
//  SSUIKit_Example
//
//  Created by 吴頔 on 2019/12/4.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class SSKeyboardDataContainer: NSObject {
    var customTitle: String {
        return ss_filterNil(keyboardType?.customButtonTitle, "")
    }
    
    var inputTextDriver: Driver<String>? {
        if let textField = input as? UITextField {
            return textField.rx.text.orEmpty.asDriver()
        }else if let textView = input as? UITextView {
            return textView.rx.text.orEmpty.asDriver()
        }
        return nil
    }
    
    /// 输入框
    weak var input: UITextInput?

    /// 键盘类型
    var keyboardType: SSKeyboardType?
       
    /// 计时器(用户长按删除按钮)
    var timerWhenDeleteButtonLongPress: Timer?
}

extension SSKeyboardDataContainer {
    
    /// 销毁计时器
    public func destroyTimerAction() {
        timerWhenDeleteButtonLongPress?.invalidate()
        timerWhenDeleteButtonLongPress = nil
    }
    
    /// 计时器循环
    @objc private func timerAction() {
        /// 如果timer为nil， return
        guard let _ = timerWhenDeleteButtonLongPress else { return }
        
        if input?.ss_text?.isEmpty == true {
            destroyTimerAction()
        }else{
            input?.deleteBackward()
            if keyboardType?.isNeedBlank == true {
                input?.deleteBackward()
            }
        }
    }
}

extension SSKeyboardDataContainer {
    
    /// 销毁计时器
    public var destroyTimer: AnyObserver<Void> {
        return Binder.init(self, binding: { (this, _) in
            this.destroyTimerAction()
        }).asObserver()
    }
    
    /// 启动计时器
    public var scheduledTimer: AnyObserver<UILongPressGestureRecognizer> {
        return Binder.init(self, binding: { (this, gesture) in
            
            /// 如果长按结束了，销毁timer
            if gesture.state == .ended {
                this.destroyTimerAction()
                return
            }
            
            /// 如果timer不等于nil， return
            if let _ = this.timerWhenDeleteButtonLongPress { return }
            
            /// 否则启动定时器
            this.timerWhenDeleteButtonLongPress = Timer.scheduledTimer(
                timeInterval: 0.2,
                target: self,
                selector: #selector(this.timerAction),
                userInfo: nil,
                repeats: true
            )
            this.timerWhenDeleteButtonLongPress?.fire()
        }).asObserver()
    }
}
