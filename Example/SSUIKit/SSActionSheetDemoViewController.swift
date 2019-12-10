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
    
    let photoButton = Button()
        .ss_style(.filled(tintColor: .ss_main))
        .ss_title("相机/相册")

    let banner = SSBannerView()
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "ActionSheet的使用"
        view.backgroundColor = .ss_background
        
        view.addSubview(button)
        view.addSubview(photoButton)
        view.addSubview(banner.bannerView)
        
        button.snp.makeConstraints { (make) in
            make.top.equalTo(CGFloat.unsafeTop+50)
            make.left.equalTo(44)
            make.right.equalToSuperview().offset(-44)
            make.height.equalTo(50)
        }
        
        photoButton.snp.makeConstraints { (make) in
            make.top.equalTo(button.snp.bottom).offset(40)
            make.left.equalTo(44)
            make.right.equalToSuperview().offset(-44)
            make.height.equalTo(50)
        }
        
        banner.bannerView.snp.makeConstraints { (make) in
            make.left.equalTo(30)
            make.right.equalToSuperview().offset(-30)
            make.top.equalTo(photoButton.snp.bottom).offset(40)
            make.bottom.equalToSuperview().offset(-100)
        }
        
        let image = UIImage(named: "QMUI_previewImage_checkbox_checked")
        
        let attribute = "自定义富文本带额外参数：999".ss_attribute
            .ss_font(font: .detail)
            .ss_color(color: .lightGray)
            .ss_font(font: UIFont.largeTitle.bold, with: "富文本")
            .ss_color(color: .orange, with: "富文本")
            .ss_addAttribute(key: .underlineStyle, with: "自定义")
            .ss_image(image: image, bounds: CGRect(x: 0, y: 0, width: 15, height: 15), insertAtFirst: true)
            .ss_alignment(.right)
        
        let items: [SSActionSheetButtonItem<Int>] = [
            .custom(title: "自定义按钮（无参数）", titleColor: nil, extra: nil),
            .custom(title: "自定义按钮带颜色（无参数）", titleColor: .ss_main, extra: nil),
            .custom(title: "自定义按钮带额外参数：250", titleColor: .orange, extra: 250),
            .attribute(attribute: attribute, extra: 999),
            .destructive(title: "删除带额外参数：-1", extra: -1)
        ]
        
        button.rx.tap
            .asDriver()
            .flatMapLatest{ SSActionSheet.show("这是标题", buttonItems: items) }
            .asObservable()
            .subscribe(onNext: { (extra) in
                var message = "该item未设置参数"
                if let value = extra {
                    message = "\(value)"
                }
                SSToast.show(message)
            })
            .disposed(by: disposeBag)
  
        photoButton.rx.tap
            .asDriver()
            .flatMapLatest{ SSActionSheet.photo(albumMaxCount: 5) }
            .map{ $0 }
            .drive(banner.dataSource.rx.dataSource)
            .disposed(by: disposeBag)

        // Do any additional setup after loading the view.
    }


}
