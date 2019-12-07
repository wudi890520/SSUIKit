//
//  ViewController.swift
//  SSUIKit
//
//  Created by wudi890520 on 11/29/2019.
//  Copyright (c) 2019 wudi890520. All rights reserved.
//

import UIKit
import CoreLocation
import SSUIKit
import RxCocoa
import RxSwift
import SnapKit
import QMUIKit

class ViewController: UIViewController {

    let tableView = UITableView()
        .ss_frame(rect: UIScreen.main.bounds)
    
    let dataSource: [String] = [
        "基本用法",
        "键盘",
        "Action Sheet",
        "Alert"
    ]
    
    let alertButton = Button()
        .ss_style(.filled(tintColor: .ss_red))
        .ss_title("弹出alert")
    
    let dispose = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "SSUIKit"
        view.ss_add(tableView)
        tableView.register(SSDemoTableViewCell.self, forCellReuseIdentifier: "SSDemoTableViewCell")
        tableView.delegate = self
        tableView.dataSource = self
        
//        view.ss_add(textField)
//            .ss_add(actionSheetButton)
//            .ss_add(alertButton)

//        textField.snp.makeConstraints { (make) in
//            make.left.equalTo(50)
//            make.top.equalTo(CGFloat.unsafeTop).offset(50)
//            make.right.equalToSuperview().offset(-50)
//            make.height.equalTo(50)
//        }
//        alertButton.snp.makeConstraints { (make) in
//            make.left.right.height.equalTo(textField)
//            make.top.equalTo(actionSheetButton.snp.bottom).offset(30)
//        }
//
//        alertButton.rx.tap
//            .subscribe(onNext: {[weak self] (_) in
//                self?.showAlert()
//            })
//            .disposed(by: dispose)
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}


extension ViewController {
    
    
    @objc func showAlert() {
        
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
        
        let cancel = SSAlertDisplayElement.button(title: "取消", titleColor: .ss_main, backgroundColor: .ss_background, type: .cancel) { (_) in
            print("取消")
        }
        
        let confirm = SSAlertDisplayElement.button(title: "确定/完成", titleColor: .white, backgroundColor: .ss_main, type: .confirm) { (_) in
            print("确定 content = \(content)")
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

extension ViewController: UITableViewDelegate, UITableViewDataSource {
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
        
        var controller: UIViewController?
        
        switch dataSource[indexPath.row] {
        case "基本用法":
            controller = SSBasicViewController()
            
        case "键盘":
            controller = SSKeyboardDemoViewController()
            
        case "Action Sheet":
            controller = SSActionSheetDemoViewController()
            
        case "Alert":
            controller = SSAlertDemoViewController()
            
        default:
            break
        }
        
        if let vc = controller {
            vc.hidesBottomBarWhenPushed = true
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}
