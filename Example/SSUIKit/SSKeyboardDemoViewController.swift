//
//  SSKeyboardDemoViewController.swift
//  SSUIKit_Example
//
//  Created by 吴頔 on 2019/12/6.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import UIKit
import SSUIKit
import RxCocoa
import RxSwift

class SSKeyboardDemoViewController: UIViewController {
    
    let keyboardTypeTitle = UILabel().ss_text("键盘类型").ss_font(12).ss_textColor(.lightGray)
    
    let keyboardTypeSegment: UISegmentedControl = {
        let segment = UISegmentedControl(items: ["默认", "数字", "小数", "身份证", "手机号", "银行卡"])
        segment.selectedSegmentIndex = 0
        return segment
    }()
    
    let dismissTypeTitle = UILabel().ss_text("隐藏键盘按钮").ss_font(12).ss_textColor(.lightGray)
    
    let showDismissButtonSwitch: UISwitch = {
        let s = UISwitch()
        s.isOn = false
        return s
    }()
    
    let addBlankTypeTitle = UILabel().ss_text("加空格/格式化").ss_font(12).ss_textColor(.lightGray)
    let addBlankSwitch: UISwitch = {
        let s = UISwitch()
        s.isOn = false
        return s
    }()
    
    let limitTypeTitle = UILabel().ss_text("限制输入长度").ss_font(12).ss_textColor(.lightGray)
    
    let allButton = UIButton().ss_title("最大长度")
        .ss_font(.detail)
        .ss_titleColor(.darkText)
        .ss_backgroundColor(.ss_background)
        .ss_layerCornerRadius()
    
    let intButton = UIButton().ss_title("整数部分")
        .ss_font(.detail)
        .ss_titleColor(.darkText)
        .ss_backgroundColor(.ss_background)
        .ss_layerCornerRadius()
    
    let floatButton = UIButton().ss_title("小数部分")
        .ss_font(.detail)
        .ss_titleColor(.darkText)
        .ss_backgroundColor(.ss_background)
        .ss_layerCornerRadius()
    
    
    let textField = TextField()
        .ss_keyboardType(.default)
        .ss_frame(x: 40, y: 50, width: 120, height: 44)
        .ss_layerCornerRadius()
        .ss_backgroundColor(.ss_background)
    
    let reload = BehaviorRelay<Void?>(value: nil)
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "键盘的使用"
        view.backgroundColor = .white
        
        view.ss_add(keyboardTypeSegment)
            .ss_add(showDismissButtonSwitch)
            .ss_add(keyboardTypeTitle)
            .ss_add(dismissTypeTitle)
            .ss_add(addBlankSwitch)
            .ss_add(addBlankTypeTitle)
            .ss_add(allButton)
            .ss_add(intButton)
            .ss_add(floatButton)
            .ss_add(limitTypeTitle)
            .ss_add(textField)
        
        keyboardTypeSegment.snp.makeConstraints { (make) in
            make.left.equalTo(8)
            make.right.equalToSuperview().offset(-8)
            make.top.equalToSuperview().offset(50+CGFloat.unsafeTop)
            make.centerX.equalToSuperview()
        }
        
        showDismissButtonSwitch.snp.makeConstraints { (make) in
            make.top.equalTo(keyboardTypeSegment.snp.bottom).offset(50)
            make.left.equalTo(keyboardTypeSegment)
        }
        
        addBlankSwitch.snp.makeConstraints { (make) in
            make.centerY.equalTo(showDismissButtonSwitch)
            make.leading.equalTo(keyboardTypeSegment.snp.centerX)
        }
        
        allButton.snp.makeConstraints { (make) in
            make.left.size.centerY.equalTo(intButton)
        }
        
        intButton.snp.makeConstraints { (make) in
            make.width.equalTo(80)
            make.height.equalTo(30)
            make.left.equalTo(keyboardTypeSegment)
            make.top.equalTo(showDismissButtonSwitch.snp.bottom).offset(50)
        }
        
        floatButton.snp.makeConstraints { (make) in
            make.left.equalTo(intButton.snp.right).offset(10)
            make.size.centerY.equalTo(intButton)
        }
        
        keyboardTypeTitle.snp.makeConstraints { (make) in
            make.left.equalTo(keyboardTypeSegment).offset(2)
            make.bottom.equalTo(keyboardTypeSegment.snp.top).offset(-8)
        }
        
        dismissTypeTitle.snp.makeConstraints { (make) in
            make.left.equalTo(showDismissButtonSwitch).offset(2)
            make.bottom.equalTo(showDismissButtonSwitch.snp.top).offset(-8)
        }
        
        addBlankTypeTitle.snp.makeConstraints { (make) in
            make.left.equalTo(addBlankSwitch).offset(2)
            make.bottom.equalTo(addBlankSwitch.snp.top).offset(-8)
        }
        
        limitTypeTitle.snp.makeConstraints { (make) in
            make.left.equalTo(intButton).offset(2)
            make.bottom.equalTo(intButton.snp.top).offset(-8)
        }
        
        textField.snp.makeConstraints { (make) in
            make.left.right.equalTo(keyboardTypeSegment)
            make.top.equalTo(intButton.snp.bottom).offset(20)
            make.height.equalTo(50)
        }
        
        keyboardTypeSegment.rx.selectedSegmentIndex
            .asObservable()
            .subscribe(onNext: {[weak self] (index) in
                if (0 ..< 6).contains(index) == false { return }
                let keyboardTypes: [SSKeyboardType] = [
                    .default,
                    .number,
                    .decimal,
                    .idCard(isNeedBlank: self?.addBlankSwitch.isOn ?? false),
                    .mobile(isNeedBlank: self?.addBlankSwitch.isOn ?? false),
                    .bankCard(isNeedBlank: self?.addBlankSwitch.isOn ?? false)
                ]
                
                self?.addBlankTypeTitle.isHidden = (0 ... 2).contains(index)
                self?.addBlankSwitch.isHidden = (0 ... 2).contains(index)
                self?.limitTypeTitle.isHidden = !(0 ... 2).contains(index)
                self?.intButton.isHidden = index != 2
                self?.floatButton.isHidden = index != 2
                self?.allButton.isHidden = index > 1
                
                self?.textField.ss_keyboardType(keyboardTypes[index])
                self?.reload.accept(())
            })
            .disposed(by: disposeBag)
        
        showDismissButtonSwitch.rx.value
            .asObservable()
            .subscribe(onNext: {[weak self] (isOn) in
                self?.textField.ss_showDismissButtonItem(isOn)
                self?.reload.accept(())
            })
            .disposed(by: disposeBag)
        
        addBlankSwitch.rx.value
            .asObservable()
            .subscribe(onNext: {[weak self] (isOn) in
                guard let keyboardType = self?.textField.ss_keyboardType else { return }
                switch keyboardType {
                case .idCard: self?.textField.ss_keyboardType(.idCard(isNeedBlank: isOn))
                case .mobile: self?.textField.ss_keyboardType(.mobile(isNeedBlank: isOn))
                case .bankCard: self?.textField.ss_keyboardType(.bankCard(isNeedBlank: isOn))
                default: return
                }
                self?.reload.accept(())
            })
            .disposed(by: disposeBag)
        
        reload.asObservable().filterNil()
            .subscribe(onNext: {[weak self] (_) in
                self?.textField.text = nil
                self?.textField.resignFirstResponder()
                self?.textField.becomeFirstResponder()
            })
            .disposed(by: disposeBag)
        
        allButton.rx.tap
            .subscribe(onNext: {[weak self] (_) in
                let sheet = UIAlertController(title: "选择最大位数", message: nil, preferredStyle: .actionSheet)
                sheet.addAction(UIAlertAction(title: "5位", style: .default, handler: { (_) in
                    self?.textField.ss_limit(5, for: .all)
                    self?.reload.accept(())
                }))
                sheet.addAction(UIAlertAction(title: "10位", style: .default, handler: { (_) in
                    self?.textField.ss_limit(10, for: .all)
                    self?.reload.accept(())
                }))
                sheet.addAction(UIAlertAction(title: "15位", style: .default, handler: { (_) in
                    self?.textField.ss_limit(15, for: .all)
                    self?.reload.accept(())
                }))
                sheet.addAction(UIAlertAction(title: "取消", style: .cancel, handler: nil))
                self?.present(sheet, animated: true, completion: nil)
            })
            .disposed(by: disposeBag)
        
        intButton.rx.tap
            .subscribe(onNext: {[weak self] (_) in
                let sheet = UIAlertController(title: "选择整数部分最大位数", message: nil, preferredStyle: .actionSheet)
                sheet.addAction(UIAlertAction(title: "2位", style: .default, handler: { (_) in
                    self?.textField.ss_limit(2, for: .integer)
                    self?.reload.accept(())
                }))
                sheet.addAction(UIAlertAction(title: "3位", style: .default, handler: { (_) in
                    self?.textField.ss_limit(3, for: .integer)
                    self?.reload.accept(())
                }))
                sheet.addAction(UIAlertAction(title: "4位", style: .default, handler: { (_) in
                    self?.textField.ss_limit(4, for: .integer)
                    self?.reload.accept(())
                }))
                sheet.addAction(UIAlertAction(title: "取消", style: .cancel, handler: nil))
                self?.present(sheet, animated: true, completion: nil)
            })
            .disposed(by: disposeBag)
        
        floatButton.rx.tap
            .subscribe(onNext: {[weak self] (_) in
                let sheet = UIAlertController(title: "选择小数部分最大位数", message: nil, preferredStyle: .actionSheet)
                sheet.addAction(UIAlertAction(title: "1位", style: .default, handler: { (_) in
                    self?.textField.ss_limit(1, for: .decimal)
                    self?.reload.accept(())
                }))
                sheet.addAction(UIAlertAction(title: "2位", style: .default, handler: { (_) in
                    self?.textField.ss_limit(2, for: .decimal)
                    self?.reload.accept(())
                }))
                sheet.addAction(UIAlertAction(title: "取消", style: .cancel, handler: nil))
                self?.present(sheet, animated: true, completion: nil)
            })
            .disposed(by: disposeBag)
        // Do any additional setup after loading the view.
    }
    
}
