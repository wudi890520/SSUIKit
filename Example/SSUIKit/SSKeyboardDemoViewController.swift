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
        let segment = UISegmentedControl(items: ["default", "number", "decimal", "idCard", "mobile"])
        segment.selectedSegmentIndex = 0
        return segment
    }()
    
    let dismissTypeTitle = UILabel().ss_text("是否需要显示隐藏键盘按钮").ss_font(12).ss_textColor(.lightGray)
    
    let showDismissButtonSegment: UISegmentedControl = {
        let segment = UISegmentedControl(items: ["disable", "enable"])
        segment.selectedSegmentIndex = 0
        return segment
    }()
    
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
            .ss_add(showDismissButtonSegment)
            .ss_add(keyboardTypeTitle)
            .ss_add(dismissTypeTitle)
            .ss_add(textField)
        
        keyboardTypeSegment.snp.makeConstraints { (make) in
            make.left.equalTo(20)
            make.right.equalToSuperview().offset(-20)
            make.top.equalToSuperview().offset(50+CGFloat.unsafeTop)
            make.centerX.equalToSuperview()
        }
        
        showDismissButtonSegment.snp.makeConstraints { (make) in
            make.top.equalTo(keyboardTypeSegment.snp.bottom).offset(50)
            make.left.equalTo(keyboardTypeSegment)
        }
        
        keyboardTypeTitle.snp.makeConstraints { (make) in
            make.left.equalTo(keyboardTypeSegment).offset(5)
            make.bottom.equalTo(keyboardTypeSegment.snp.top).offset(-8)
        }
        
        dismissTypeTitle.snp.makeConstraints { (make) in
            make.left.equalTo(showDismissButtonSegment).offset(5)
            make.bottom.equalTo(showDismissButtonSegment.snp.top).offset(-8)
        }
        
        textField.snp.makeConstraints { (make) in
            make.left.right.equalTo(keyboardTypeSegment)
            make.top.equalTo(showDismissButtonSegment.snp.bottom).offset(50)
            make.height.equalTo(50)
        }
        
        keyboardTypeSegment.rx.selectedSegmentIndex
            .asObservable()
            .subscribe(onNext: {[weak self] (index) in
                if (0 ..< 5).contains(index) == false { return }
                let keyboardTypes: [SSKeyboardType] = [.default, .number, .decimal, .idCard, .mobile]
                self?.textField.ss_keyboardType(keyboardTypes[index])
                self?.reload.accept(())
            })
            .disposed(by: disposeBag)
        
        showDismissButtonSegment.rx.selectedSegmentIndex
            .asObservable()
            .subscribe(onNext: {[weak self] (index) in
                let isEnable = index.ss_number.boolValue
                self?.textField.ss_showDismissButtonItem(isEnable)
                self?.reload.accept(())
            })
            .disposed(by: disposeBag)
        
        reload.asObservable().filterNil()
            .do(onNext: {[weak self] (_) in
                self?.textField.resignFirstResponder()
            })
            .delay(.milliseconds(500), scheduler: MainScheduler.instance)
            .subscribe(onNext: {[weak self] (_) in
                self?.textField.becomeFirstResponder()
            })
            .disposed(by: disposeBag)
        // Do any additional setup after loading the view.
    }
    
}
