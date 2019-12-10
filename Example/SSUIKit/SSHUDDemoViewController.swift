//
//  SSHUDDemoViewController.swift
//  SSUIKit_Example
//
//  Created by 吴頔 on 2019/12/9.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import UIKit
import SSUIKit
import RxSwift
import RxCocoa

class SSHUDDemoViewController: UIViewController {

    let customButton = Button()
        .ss_style(.filled(tintColor: .ss_main))
        .ss_title("自定义文本")

    let clearButton = Button()
        .ss_style(.filled(tintColor: .ss_main))
        .ss_title("透明且不能操作页面")

    let blackButton = Button()
        .ss_style(.filled(tintColor: .ss_main))
        .ss_title("黑色背景且不能操作页面")
    
    let rxButton = Button()
        .ss_style(.filled(tintColor: .ss_main))
        .ss_title("配合RxSwift使用，模拟网络请求")
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Toast的使用"
        view.backgroundColor = .ss_background
        
        view.ss_add(customButton)
            .ss_add(clearButton)
            .ss_add(blackButton)
            .ss_add(rxButton)
          
        customButton.snp.makeConstraints { (make) in
            make.top.equalTo(CGFloat.unsafeTop+50)
            make.left.equalTo(44)
            make.right.equalToSuperview().offset(-44)
            make.height.equalTo(50)
        }
        
        clearButton.snp.makeConstraints { (make) in
            make.top.equalTo(customButton.snp.bottom).offset(15)
            make.left.equalTo(44)
            make.right.equalToSuperview().offset(-44)
            make.height.equalTo(50)
        }
        
        blackButton.snp.makeConstraints { (make) in
            make.top.equalTo(clearButton.snp.bottom).offset(15)
            make.left.equalTo(44)
            make.right.equalToSuperview().offset(-44)
            make.height.equalTo(50)
        }
        
        rxButton.snp.makeConstraints { (make) in
            make.top.equalTo(blackButton.snp.bottom).offset(15)
            make.left.equalTo(44)
            make.right.equalToSuperview().offset(-44)
            make.height.equalTo(50)
        }
        
        customButton.rx.tap
            .subscribe(onNext: {[weak self] (_) in
                self?.showHUD(status: SSHUDStatus.custom(status: "等一下"))
            })
            .disposed(by: disposeBag)
        
        clearButton.rx.tap
            .subscribe(onNext: {[weak self] (_) in
                self?.showHUD(status: SSHUDStatus.clear(.loading))
            })
            .disposed(by: disposeBag)
        
        blackButton.rx.tap
            .subscribe(onNext: {[weak self] (_) in
                self?.showHUD(status: SSHUDStatus.black(.waiting))
            })
            .disposed(by: disposeBag)
        
        rxButton.rx.tap
            .asDriver()
            /// 显示HUD
            .showHUD(for: .loading)
            /// 请求
            .flatMapLatest{ SSHUDDemoViewController.makeRequest() }
            /// 隐藏HUD
            .dismissHUD()
            .drive()
            .disposed(by: disposeBag)
        // Do any additional setup after loading the view.
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        SSHUD.dismiss()
    }
}

extension SSHUDDemoViewController {
    func showHUD(status: SSHUDStatus) {
        SSHUD.show(for: status)
        perform(#selector(dismissHUD), afterDelay: 3)
    }

    @objc func dismissHUD() {
        SSHUD.dismiss()
    }
}

extension SSHUDDemoViewController {
    static func makeRequest() -> Driver<Int> {
        return Driver.just(123).delay(.seconds(2))
    }
}
