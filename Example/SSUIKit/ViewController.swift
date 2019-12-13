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

class ViewController: SSBaseViewController {

    let tableView = UITableView()
        .ss_frame(rect: UIScreen.main.bounds)
    
    let dataSource: [String] = [
        "基本用法",
        "键盘",
        "Action Sheet",
        "Alert",
        "Banner",
        "Toast",
        "HUD",
        "导航栏"
    ]
    
    let alertButton = Button()
        .ss_style(.filled(tintColor: .ss_red))
        .ss_title("弹出alert")
        
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "SSUIKit"
        view.ss_add(tableView)
        tableView.register(SSDemoTableViewCell.self, forCellReuseIdentifier: "SSDemoTableViewCell")
        tableView.delegate = self
        tableView.dataSource = self
        // Do any additional setup after loading the view, typically from a nib.
    }
}

extension ViewController: UITableViewDataSource {
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
            
        case "Banner":
            controller = SSBannerDemoViewController()
            
        case "Toast":
            controller = SSToastDemoViewController()
            
        case "HUD":
            controller = SSHUDDemoViewController()
         
        case "导航栏":
            controller = SSNavigationDemoViewController()
            
        default:
            break
        }
        
        if let vc = controller {
            vc.hidesBottomBarWhenPushed = true
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}


extension UIViewController {
    func showToast(_ msg: String?) {
        view.makeToast(msg, duration: 1.5, position: .center)
    }
}
