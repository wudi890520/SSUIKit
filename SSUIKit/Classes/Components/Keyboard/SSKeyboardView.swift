//
//  KeboardView.swift
//  SSUIKit_Example
//
//  Created by 吴頔 on 2019/12/4.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import RxGesture

open class SSKeyboardView: UIView {
    
    private let subViews = SSKeyboardViewContainer()
    
    private let datas = SSKeyboardDataContainer()
    
    private let layout = SSKeyboardLayoutManager()
    
    private let viewModel = SSKeyboardViewModel()
    
    private let dispose = DisposeBag()
    
    public init(_ keyboardType: SSKeyboardType, input: UITextInput) {
        let height = SSKeyboardViewContainer.Content.height + CGFloat.unsafeBottom
        super.init(frame: CGRect(x: 0, y: 0, width: CGFloat.screenWidth, height: height))
        ss_setValues(keyboardType, input: input)
        ss_layoutSubviews()
        ss_bindDataSource()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension SSKeyboardView {
    private func ss_setValues(_ keyboardType: SSKeyboardType, input: UITextInput) {
        subViews.keyboardType = keyboardType
        datas.keyboardType = keyboardType
        datas.input = input
    }
}

extension SSKeyboardView {
    private func ss_layoutSubviews() {
        layout.make(children: subViews, in: self)
    }
}

extension SSKeyboardView {
    private func ss_bindDataSource() {
        guard
            let textInput = datas.input,
            let textDriver = datas.inputTextDriver
        else { return }
        
        let customTitle = datas.customTitle
        
        /// 初始化位数限制
        let limit = (
            all: textInput.ss_limit,
            integer: textInput.ss_integerLimit,
            decimal: textInput.ss_decimalLimit
        )
        
        /// 点击了数字（数组）
        let numberTap = subViews.numbers
            .compactMap{ btn in btn.rx.tap.asDriver().map{ btn.tag } }
        
        let input = SSKeyboardViewModel.Input(
            /// 当前输入框内容变化的信号
            text: textDriver,
            /// 将数组合并和一个信号
            number: Driver.merge(numberTap),
            /// 点击了删除按钮
            delete: subViews.deleteBtn.rx.tap.asDriver(),
            /// 点击了自定义按钮
            custom: subViews.customBtn?.rx.tap.asDriver().map{ customTitle },
            /// 位数限制
            limit: Driver.just(limit)
        )
        
        let output = viewModel.transform(input: input)
        
        /// 向当前输入框插入一个新字符
        output.insert
            .asObservable()
            .subscribe(onNext: { textInput.ss_intert($0) })
            .disposed(by: dispose)
        
        /// 删除当前输入框的最后一个字符
        output.deleteBackward
            .asObservable()
            .subscribe(onNext: { textInput.ss_deleteBackward($0) })
            .disposed(by: dispose)
        
        /// 销毁定时器
        output.destroyTimer
            .drive(datas.destroyTimer)
            .disposed(by: dispose)

        /// 手指离开按钮，销毁定时器
        subViews.deleteBtn.rx
            .longPressGesture()
            .asObservable()
            .bind(to: datas.scheduledTimer)
            .disposed(by: dispose)
        
    }
}
