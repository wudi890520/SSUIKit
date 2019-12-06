//
//  KeyboardDoneButtonManager.swift
//  SSUIKit_Example
//
//  Created by 吴頔 on 2019/12/4.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxKeyboard
import RxOptional

class SSKeyboardDoneButtonManager: NSObject {

    static let hideKeyboardButtonTag = 999999
    
    static let shared = SSKeyboardDoneButtonManager()
    
    var keyboardShowing: Bool = false
    
    /// 收回键盘按钮
    private let hideKeyboardButton = UIButton()
        .ss_frame(x: CGFloat.screenWith-70, y: 0, width: 60, height: 36)
        .ss_image("dismissKeyboard".bundleImage)
        .ss_shadow()
        .ss_layerCornerRadius(18, isOnShadow: true)
        .ss_tag(hideKeyboardButtonTag)
    
    /// 当前的输入框
    private weak var textInput: UITextInput?
    
    private var inputAccessoryView: UIView?
    
    private var isListening = false
    
    /// 信号回收
    private let dispose = DisposeBag()
    
    private override init() {
        super.init()
    }
    
    static func setup() {
        SSKeyboardDoneButtonManager.shared.startListen()
    }
    
}

extension SSKeyboardDoneButtonManager {
    private func startListen() {
        
        if isListening {
            return
        }
        isListening = true
        
        /// 监听UITextField弹出
        let textFieldDidBeginEditing = NotificationCenter.default
            .rx.notification(UITextField.textDidBeginEditingNotification)
            .asObservable()
        
        /// 监听UITextView弹出
        let textViewDidBeginEditing = NotificationCenter.default
            .rx.notification(UITextView.textDidBeginEditingNotification)
            .asObservable()
        
        Observable.merge(textFieldDidBeginEditing, textViewDidBeginEditing)
            .do(onNext: {[weak self] (noti) in
                if let textView = noti.object as? UITextView {
                    self?.inputAccessoryView = textView.inputAccessoryView
                }
                if let textField = noti.object as? UITextField {
                    self?.inputAccessoryView = textField.inputAccessoryView
                }
            })
            .map{ $0.object as? UITextInput }
            .filterNil()
            .do(onNext: {[weak self] (input) in self?.textInput = input })
            .flatMapLatest{ _ in RxKeyboard.instance.visibleHeight.asObservable() }
            .bind(to: keyboardHeight)
            .disposed(by: dispose)
        
        hideKeyboardButton
            .rx.tap
            .asDriver()
            .drive(resignFirstResponder)
            .disposed(by: dispose)
    }
}

extension SSKeyboardDoneButtonManager {

    private var keyboardHeight: AnyObserver<CGFloat> {
        return Binder.init(self, binding: { (this, height) in
            guard let doneEnable = this.textInput?.ss_dismissKeyboardEnable, doneEnable == true else { return }
    
            if height == 0 {
                this.keyboardShowing = false
                this.hideKeyboardButton.removeFromSuperview()
            }else{
                this.keyboardShowing = true
                if let view = this.inputAccessoryView {
                    view.addSubview(this.hideKeyboardButton)
                }
            }
        }).asObserver()
    }
    
    private var resignFirstResponder: AnyObserver<Void> {
        return Binder.init(self) { (this, _) in
            UIApplication.shared.keyWindow?.rootViewController?.view.endEditing(true)
        }.asObserver()
    }
}
