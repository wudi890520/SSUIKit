//
//  SSAlertDemoViewController.swift
//  SSUIKit_Example
//
//  Created by 吴頔 on 2019/12/6.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import UIKit
import SSUIKit
import RxCocoa
import RxSwift
import Toast_Swift

class SSAlertDemoViewController: UIViewController {

    let normal = Button()
        .ss_style(.filled(tintColor: .ss_main))
        .ss_title("弹出普通alert")
    
    let towButtons = Button()
        .ss_style(.filled(tintColor: .ss_main))
        .ss_title("底部2个按钮的alert")
    
    let textFieldButton = Button()
        .ss_style(.filled(tintColor: .ss_main))
        .ss_title("自定义alert（带输入框）")
    
    private let alertTitle = "在此推荐一个苹果针对浮点型计算时存在精度计算误差的问题而提供的一个计算类"
    
    let dispose = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Alert的使用"
        view.backgroundColor = .ss_background
        view.ss_add(normal)
            .ss_add(towButtons)
            .ss_add(textFieldButton)
        
        normal.snp.makeConstraints { (make) in
            make.top.equalTo(CGFloat.unsafeTop+50)
            make.left.equalTo(44)
            make.right.equalToSuperview().offset(-44)
            make.height.equalTo(50)
        }
        
        towButtons.snp.makeConstraints { (make) in
            make.top.equalTo(normal.snp.bottom).offset(15)
            make.left.equalTo(44)
            make.right.equalToSuperview().offset(-44)
            make.height.equalTo(50)
        }

        textFieldButton.snp.makeConstraints { (make) in
            make.top.equalTo(towButtons.snp.bottom).offset(15)
            make.left.equalTo(44)
            make.right.equalToSuperview().offset(-44)
            make.height.equalTo(50)
        }
        
        normal.rx.tap
            .subscribe(onNext: {[weak self] (_) in self?.showNormalAlert() })
            .disposed(by: dispose)
        
        towButtons.rx.tap
            .subscribe(onNext: {[weak self] (_) in self?.showTwoButtonsAlert() })
            .disposed(by: dispose)
        
        textFieldButton.rx.tap
            .subscribe(onNext: {[weak self] (_) in self?.showTextFieldAlert() })
            .disposed(by: dispose)
        // Do any additional setup after loading the view.
    }

    func showNormalAlert() {
        /// 不处理回调
//        SSAlert.show(alertTitle)
        
        /// 处理回调事件
        SSAlert.show(alertTitle) { [weak self] in
            self?.showToast("alert 消失了")
        }
    }
    
    func showTwoButtonsAlert() {
        SSAlert.show(alertTitle, message: "这是 message", cancelButtonTitle: "取消", confirmButtonTitle: "确定") {[weak self] (result) in
            if result == true {
                self?.showToast("点击了确定")
            }else if result == false {
                self?.showToast("点击了取消")
            }
        }
    }
    
    func showTextFieldAlert() {
        
        var content: String = ""
        
        let titleLabel = SSAlertDisplayElement.label(
            content: "这是标题".ss_attribute
                .ss_font(font: .largePrice)
                .ss_color(color: .red)
                .ss_color(color: .blue, with: "是")
                .ss_color(color: .green, with: "标")
                .ss_color(color: .orange, with: "题")
                .ss_alignment(.center),
            insets: UIEdgeInsets(top: 20, left: 30, bottom: 20, right: 30))
        
        let detail = SSAlertDisplayElement.label(
            content: "在此推荐一个苹果针对浮点型计算时存在精度计算误差的问题而提供的一个计算类".ss_attribute
                .ss_font(font: .detail)
                .ss_color(color: .lightGray)
                .ss_color(color: .orange, with: "浮点型")
                .ss_alignment(.center),
            insets: UIEdgeInsets(top: 0, left: 30, bottom: 20, right: 30))
        
        let textField = SSAlertDisplayElement.textField(
            placeholder: "请输入金额",
            keyboardType: .decimal,
            insets: UIEdgeInsets(top: 0, left: 30, bottom: 20, right: 30),
            leftTitle: "$".ss_attribute.ss_font(font: .largePrice).ss_color(color: .red),
            rightTitle: nil) { (text) in
                content = text
                print(text)
        }
        
        let cancel = SSAlertDisplayElement.button(title: "取消", titleColor: .ss_main, backgroundColor: .ss_background, type: .cancel) {[weak self] (_) in
            self?.showToast("点击了取消")
        }
        
        let confirm = SSAlertDisplayElement.button(title: "确定/完成", titleColor: .white, backgroundColor: .ss_main, type: .confirm) {[weak self] (_) in
            if content.isEmpty {
                self?.showToast("点击了确定 未输入内容")
            }else{
                self?.showToast("点击了确定 输入内容： \(content)")
            }
        }
        
        let elements: [SSAlertDisplayElement] = [
            titleLabel,
            textField,
            detail,
            cancel,
            confirm
        ]
        
        SSAlert.show(elements)
    }

}

extension SSAlertDemoViewController {
    func showToast(_ msg: String?) {
        view.makeToast(msg, duration: 1.5, position: .center)
    }
}