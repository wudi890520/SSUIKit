//
//  SSNavigationDemoViewController.swift
//  SSUIKit_Example
//
//  Created by 吴頔 on 2019/12/11.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import UIKit
import SSUIKit
import RxSwift
import RxCocoa

class SSNavigationDemoViewController: SSBaseViewController {

    let tableView = UITableView()
        .ss_frame(rect: UIScreen.main.bounds)
       
    let sectionTitles: [String] = ["样式","控制"]
    
    let dataSource: [[String]] = [
        [
            "系统导航栏样式",
            "黑色导航栏",
            "透明导航栏",
            "自定义样式导航栏",
            "隐藏导航栏"
        ],
        [
            "是否允许滑动返回",
            "移除之前的视图控制器",
            "添加barButtonItem"
        ]
    ]
    
    let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "导航栏的使用"
        view.backgroundColor = .ss_background

        view.ss_add(tableView)
          
        tableView.register(SSDemoTableViewCell.self, forCellReuseIdentifier: "SSDemoTableViewCell")
        tableView.delegate = self
        tableView.dataSource = self
    }

}

extension SSNavigationDemoViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource[section].count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionTitles[section]
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: SSDemoTableViewCell = tableView.dequeueReusableCell(withIdentifier: "SSDemoTableViewCell", for: indexPath) as! SSDemoTableViewCell
        cell.textLabel?.text = dataSource[indexPath.section][indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        var controller: UIViewController?
        
        switch dataSource[indexPath.section][indexPath.row] {

        case "系统导航栏样式":
            controller = SSNavigationDefaultDemoViewController()

        case "黑色导航栏":
            controller = SSNavigationBlackDemoViewController()

        case "透明导航栏":
            controller = SSNavigationClearDemoViewController()

        case "隐藏导航栏":
            controller = SSNavigationHiddenDemoViewController()
            
        case "自定义样式导航栏":
            controller = SSNavigationCustomDemoViewController()
            
        case "是否允许滑动返回":
            controller = SSNavigationPopGestureDemoViewController()
        
        case "移除之前的视图控制器":
            controller = SSNavigationIgnoreDemoViewController()
            
        case "添加barButtonItem":
            controller = SSNavigationBarButtonItemDemoViewController()
            
        default:
            break
        }
        
        if let vc = controller {
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}

fileprivate class SSNavigationDefaultDemoViewController: SSBaseViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "默认系统样式"
        view.backgroundColor = .white
        barStyle = .default
    }
}

fileprivate class SSNavigationBlackDemoViewController: SSBaseViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "黑色"
        view.backgroundColor = .white
        barStyle = .black
    }
}

fileprivate class SSNavigationClearDemoViewController: SSBaseViewController {
    let redView = UIView().ss_backgroundColor(.red)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "透明"
        view.backgroundColor = .white
        barStyle = .clear
        
        view.addSubview(redView)
        redView.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.width.equalTo(50)
            make.height.equalTo(150)
            make.centerX.equalToSuperview()
        }
    }
}

class SSNavigationHiddenDemoViewController: SSBaseViewController, UITableViewDelegate, UITableViewDataSource {
    
    var showIntroduction = false
    
    let tableView = UITableView()
        .ss_frame(rect: UIScreen.main.bounds)
    
    lazy var navigationView: UIView = {
        let view = UIView().ss_backgroundColor(.red).ss_frame(x: 0, y: CGFloat.statusBar, width: CGFloat.screenWith, height: 44)
        return view
    }()
    
    var dataSource: [String] = (0 ... 100).map{ "第\($0)行cell" }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(tableView)
        
        if showIntroduction {
            let desctiptionTextValue = """


            1.即便是全部隐藏了导航栏，SSUIKit依然可以保持API不变添加UIButton到指定位置
            2.即使中途addSubview到父视图上，UIButton也还是会保持在最上层，请放心使用
            3.回调方式与UIBarButtonItem一致，监听leftItemDidTap和rightItemDidTap即可
            """
            dataSource.insert(desctiptionTextValue, at: 0)
        }
        
        tableView.register(SSDemoTableViewCell.self, forCellReuseIdentifier: "SSDemoTableViewCell")
        tableView.delegate = self
        tableView.dataSource = self
        
    }
    
    override func ss_setNavigation() {
        title = "隐藏"
        barStyle = .hidden
        
        if showIntroduction {
            addBarButtonItem(with: UIImage(named: "QMUI_previewImage_checkbox_checked"))
            rightItemDidTap?.asObservable()
                .subscribe(onNext: { (_) in
                    SSToast.show("你点击了右侧的item")
                })
                .disposed(by: dispose)
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: SSDemoTableViewCell = tableView.dequeueReusableCell(withIdentifier: "SSDemoTableViewCell", for: indexPath) as! SSDemoTableViewCell
        cell.textLabel?.numberOfLines = 0
        
        
        if showIntroduction {
            if indexPath.row == 0 {
                cell.accessoryView = nil
            }else{
                if indexPath.row % 2 == 0 {
                    cell.accessoryView = UILabel().ss_frame(x: 0, y: 0, width: 44, height: 44).ss_text("-").ss_font(.with(34)).ss_textColor(.red).ss_textAlignment(.center)
                }else{
                    cell.accessoryView = UILabel().ss_frame(x: 0, y: 0, width: 44, height: 44).ss_text("+").ss_font(.with(30)).ss_textAlignment(.center)
                }
            }
        }else{
            cell.accessoryView = nil
        }
        
        
        cell.textLabel?.text = dataSource[indexPath.row]
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.row % 2 == 0 {
            navigationView.removeFromSuperview()
        }else{
            if navigationView.superview == nil {
                view.addSubview(navigationView)
            }
        }
    }
}

fileprivate class SSNavigationCustomDemoViewController: SSBaseViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "自定义"
        view.backgroundColor = .white
        barStyle = .custom(statusBarStyle: .lightContent, barBackgroundColor: .red, barTintColor: .blue)
    }
}

fileprivate class SSNavigationPopGestureDemoViewController: SSBaseViewController {
    
    let switchUI = UISwitch()
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "手势返回"
        view.backgroundColor = .white
        
        view.addSubview(switchUI)
        switchUI.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
        }
        popGestureEnable = false
        switchUI.rx.controlEvent(.valueChanged)
            .asObservable()
            .subscribe(onNext: {[weak self] (_) in
                let enable = self?.switchUI.isOn ?? false
                self?.popGestureEnable = enable
            })
            .disposed(by: disposeBag)
    }
}
