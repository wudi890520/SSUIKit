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

    let tableView = UITableView()
        .ss_frame(rect: UIScreen.main.bounds)
       
    let dataSource: [String] = [
        "静态方法弹出",
        "绑定控制器的observer",
        "绑定self.view的observer"
    ]
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Toast的使用"
        view.backgroundColor = .ss_background
        view.addSubview(tableView)
        
        tableView.register(SSDemoTableViewCell.self, forCellReuseIdentifier: "SSDemoTableViewCell")
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.rx.itemSelected
            .filter{ $0.row == 0 }
            .subscribe(onNext: { (_) in
                SSToast.show("message 静态方法弹出", at: .bottom)
            })
            .disposed(by: disposeBag)
        
        tableView.rx.itemSelected
            .filter{ $0.row == 1 }
            .map{ _ in "message 绑定控制器的observer" }
            .bind(to: rx.showToast)
            .disposed(by: disposeBag)
            
        tableView.rx.itemSelected
            .filter{ $0.row == 2 }
            .map{ _ in "message 绑定view的observer" }
            .bind(to: view.rx.showToast)
            .disposed(by: disposeBag)

    }

}

extension SSToastDemoViewController: UITableViewDelegate, UITableViewDataSource {
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
    }
}
