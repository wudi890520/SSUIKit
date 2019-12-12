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

    let tableView = UITableView()
        .ss_frame(rect: UIScreen.main.bounds)
       
    let dataSource: [String] = [
        "自定义文本",
        "透明且不能操作页面",
        "黑色背景且不能操作页面",
        "配合RxSwift使用，模拟网络请求"
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
        
        tableView.rx.itemSelected.asDriver()
            .map{ [weak self] indexPath in self?.dataSource[indexPath.row] }
            .filter{ $0 == "配合RxSwift使用，模拟网络请求" }
            .showHUD(for: .loading)
            .flatMapLatest{ _ in SSHUDDemoViewController.simulatedNetworkRequest() }
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

extension SSHUDDemoViewController: UITableViewDelegate, UITableViewDataSource {
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

        case "自定义文本":
            showHUD(status: SSHUDStatus.custom(status: "我叫自定义"))

        case "透明且不能操作页面":
            showHUD(status: SSHUDStatus.clear(.loading))

        case "黑色背景且不能操作页面":
            showHUD(status: SSHUDStatus.black(.waiting))

        default:
            break
        }
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
    static func simulatedNetworkRequest() -> Driver<Int> {
        return Driver.just(123).delay(.seconds(2))
    }
}
