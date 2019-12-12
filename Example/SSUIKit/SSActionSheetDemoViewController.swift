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

    let tableView = UITableView()
        .ss_frame(rect: UIScreen.main.bounds)
    
    let dataSource: [String] = [
        "弹出",
        "相机/相册"
    ]

    let banner = SSBannerView()
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "ActionSheet的使用"
        view.backgroundColor = .ss_background
        
        view.addSubview(tableView)
        banner.bannerView.size = CGSize(width: CGFloat.screenWith, height: 200)
      
        tableView.register(SSDemoTableViewCell.self, forCellReuseIdentifier: "SSDemoTableViewCell")
        tableView.delegate = self
        tableView.dataSource = self
    }

}

extension SSActionSheetDemoViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: SSDemoTableViewCell = tableView.dequeueReusableCell(withIdentifier: "SSDemoTableViewCell", for: indexPath) as! SSDemoTableViewCell
        
        cell.textLabel?.text = dataSource[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        switch dataSource[indexPath.row] {
        case "弹出": showCustom()
        case "相机/相册": showPhoto()
        default: break
        }
    }
}

extension SSActionSheetDemoViewController {
    private func showCustom() {
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
        
        SSActionSheet.show("这是标题", buttonItems: items)
            .asObservable()
            .subscribe(onNext: { (extra) in
                var message = "该item未设置参数"
                if let value = extra {
                    message = "参数：\(value)"
                }
                SSToast.show(message)
            })
            .disposed(by: disposeBag)
    }
    
    private func showPhoto() {
        let `是否需要相机` = true
        let `相册最大可选数量`: Int = 5
        SSActionSheet.photo(isNeedCamera: `是否需要相机`, albumMaxCount: `相册最大可选数量`)
            .map{ $0 }
            .do(onNext: {[weak self] (photos) in
                self?.tableView.tableHeaderView = self?.banner.bannerView
            })
            .drive(banner.dataSource.rx.dataSource)
            .disposed(by: disposeBag)
    }
}
