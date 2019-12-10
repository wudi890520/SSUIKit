//
//  SSToastDemoViewController.swift
//  SSUIKit_Example
//
//  Created by 吴頔 on 2019/12/9.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import UIKit
import SSUIKit
import RxSwift
import RxCocoa

class SSToastDemoViewController: UIViewController {

    let topButton = Button()
        .ss_style(.filled(tintColor: .ss_main))
        .ss_title("静态方法弹出")
    
    let centerButton = Button()
        .ss_style(.filled(tintColor: .ss_main))
        .ss_title("绑定控制器的observer")
    
    let bottomButton = Button()
        .ss_style(.filled(tintColor: .ss_main))
        .ss_title("绑定self.view的observer")
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Toast的使用"
        view.backgroundColor = .ss_background
        view.ss_add(topButton)
            .ss_add(centerButton)
            .ss_add(bottomButton)
          
        topButton.snp.makeConstraints { (make) in
            make.top.equalTo(CGFloat.unsafeTop+50)
            make.left.equalTo(44)
            make.right.equalToSuperview().offset(-44)
            make.height.equalTo(50)
        }
        
        centerButton.snp.makeConstraints { (make) in
            make.top.equalTo(topButton.snp.bottom).offset(15)
            make.left.equalTo(44)
            make.right.equalToSuperview().offset(-44)
            make.height.equalTo(50)
        }
        
        bottomButton.snp.makeConstraints { (make) in
            make.top.equalTo(centerButton.snp.bottom).offset(15)
            make.left.equalTo(44)
            make.right.equalToSuperview().offset(-44)
            make.height.equalTo(50)
        }
        
        topButton.rx.tap
            .subscribe(onNext: { (_) in
                SSToast.show("message 静态方法弹出", at: .bottom)
            })
            .disposed(by: disposeBag)
        
        centerButton.rx.tap
            .map{ "message 绑定控制器的observer" }
            .bind(to: rx.showToast)
            .disposed(by: disposeBag)
        
        bottomButton.rx.tap
            .map{ "message 绑定view的observer" }
            .bind(to: view.rx.showToast)
            .disposed(by: disposeBag)
        // Do any additional setup after loading the view.
    }

}
