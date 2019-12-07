//
//  SSActionSheetDemoViewController.swift
//  SSUIKit_Example
//
//  Created by 吴頔 on 2019/12/6.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import UIKit
import SSUIKit
import RxCocoa
import RxSwift

class SSActionSheetDemoViewController: UIViewController {

    let button = Button()
        .ss_style(.filled(tintColor: .ss_main))
        .ss_title("弹出")
    
    let resultTitleLabel = UILabel().ss_font(.detail).ss_text("返回结果")
    let resultContentLabel = UILabel().ss_font(UIFont.lightPrice.bold).ss_textColor(.red)
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "ActionSheet的使用"
        view.backgroundColor = .ss_background
        
        view.addSubview(button)
        view.addSubview(resultTitleLabel)
        view.addSubview(resultContentLabel)
        
        button.snp.makeConstraints { (make) in
            make.top.equalTo(CGFloat.unsafeTop+50)
            make.left.equalTo(44)
            make.right.equalToSuperview().offset(-44)
            make.height.equalTo(50)
        }
        
        resultTitleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(button.snp.bottom).offset(40)
            make.centerX.equalToSuperview()
        }
        
        resultContentLabel.snp.makeConstraints { (make) in
            make.top.equalTo(resultTitleLabel.snp.bottom).offset(5)
            make.centerX.equalToSuperview()
        }
        
        let image = UIImage(named: "QMUI_previewImage_checkbox_checked")
        
        let attribute = "自定义富文本".ss_attribute
            .ss_font(font: .detail)
            .ss_color(color: .lightGray)
            .ss_font(font: UIFont.largeTitle.bold, with: "富文本")
            .ss_color(color: .orange, with: "富文本")
            .ss_addAttribute(key: .underlineStyle, with: "自定义")
            .ss_image(image: image, bounds: CGRect(x: 0, y: 0, width: 15, height: 15), insertAtFirst: true)
            .ss_alignment(.right)
        
        let items: [SSActionSheetButtonItem<Int>] = [
            .custom(title: "自定义按钮", titleColor: nil, extra: nil),
            .custom(title: "自定义按钮带颜色", titleColor: .ss_main, extra: nil),
            .custom(title: "自定义按钮带额外参数", titleColor: .orange, extra: 250),
            .attribute(attribute: attribute, extra: 999),
            .destructive(title: "删除", extra: nil)
        ]
        
        button.rx.tap
            .asDriver()
            .flatMapLatest{ SSActionSheet.show("这是标题", buttonItems: items) }
            .asObservable()
            .subscribe(onNext: {[weak self] (extra) in
                var message = ""
                if let value = extra {
                    message = "\(value)"
                }else{
                    message = "this item not has value"
                }
                self?.resultContentLabel.text = message
            })
            .disposed(by: disposeBag)
        // Do any additional setup after loading the view.
    }


}
