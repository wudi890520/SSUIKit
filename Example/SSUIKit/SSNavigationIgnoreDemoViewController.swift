//
//  SSNavigationIgnoreDemoViewController.swift
//  SSUIKit_Example
//
//  Created by 吴頔 on 2019/12/11.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import UIKit
import SSUIKit
import RxSwift
import RxCocoa

class SSNavigationIgnoreDemoViewController: SSBaseViewController {

    var index: Int = 0
    
    let tableView = UITableView()
        .ss_frame(rect: UIScreen.main.bounds)
       
    let dataSource: [String] = [
        "移除《导航栏的使用》控制器 - SSNavigationDemoViewController",
        "移除所有控制器",
        "移除前一个控制器",
        "移除前N个控制器"
    ]
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "这是navigation的第\(navigationViewControllersCount)个"
        view.backgroundColor = .ss_background
        view.addSubview(tableView)
        
        tableView.register(SSDemoTableViewCell.self, forCellReuseIdentifier: "SSDemoTableViewCell")
        tableView.delegate = self
        tableView.dataSource = self
        
        let barBackgroundColor = UIColor.qmui_random()
        let barTintColor = barBackgroundColor.qmui_inverse()
        barStyle = .custom(statusBarStyle: .lightContent, barBackgroundColor: barBackgroundColor, barTintColor: barTintColor)
        
        addBarButtonItem(with: "下一页")
        
        rightItemDidTap?.asObservable()
            .subscribe(onNext: {[weak self] (_) in
                self?.navigationController?.pushViewController(SSNavigationIgnoreDemoViewController(), animated: true)
            })
            .disposed(by: disposeBag)
    }

}

extension SSNavigationIgnoreDemoViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: SSDemoTableViewCell = tableView.dequeueReusableCell(withIdentifier: "SSDemoTableViewCell", for: indexPath) as! SSDemoTableViewCell
        cell.textLabel?.numberOfLines = 0
        cell.textLabel?.text = dataSource[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        switch dataSource[indexPath.row] {

        case "移除《导航栏的使用》控制器 - SSNavigationDemoViewController":
            ignore(.just(class: SSNavigationDemoViewController.self))

        case "移除所有控制器":
            ignore(.all)

        case "移除前一个控制器":
            ignore(.previos)

        case "移除前N个控制器":
            
            var maxCount: Int?
            
            let textField = SSAlertDisplayElement.textField(placeholder: "输入个数", keyboardType: .number, insets: UIEdgeInsets(top: 40, left: 30, bottom: 30, right: 30), leftTitle: nil, rightTitle: nil) { (count) in
                maxCount = count.ss_int
            }
            
            let cancel = SSAlertDisplayElement.button(title: "取消", titleColor: .gray, backgroundColor: UIColor.ss.background, type: .cancel, didTap: nil)
            
            let confirm = SSAlertDisplayElement.button(title: "确定", titleColor: .white, backgroundColor: UIColor.ss.main, type: .confirm) {[weak self] (_) in
                if let max = maxCount {
                    self?.ignore(.collectionFromCurrent(max: max))
                }
            }
            
            SSAlert.present([textField, cancel, confirm])
            
        default:
            break
        }
    }
}

