//
//  SSNavigationBarButtonItemDemoViewController.swift
//  SSUIKit_Example
//
//  Created by 吴頔 on 2019/12/12.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import UIKit
import SSUIKit
import RxSwift
import RxCocoa

class SSNavigationBarButtonItemDemoViewController: SSBaseViewController {

    let tableView = UITableView()
        .ss_frame(rect: UIScreen.main.bounds)
    
    let sectionTitles: [String] = ["一个","多个","其他"]
    
    let dataSource: [[String]] = [
        [
            "文本",
            "图片",
            "系统item",
            "回头车item"
        ],
        [
            "多个文本，带动画",
            "混合数组，指定color"
        ],
        [
            "中间样式-自定义view",
            "在隐藏导航栏模式下，添加item"
        ]
    ]
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .ss_background

        view.ss_add(tableView)
          
        tableView.register(SSDemoTableViewCell.self, forCellReuseIdentifier: "SSDemoTableViewCell")
        tableView.delegate = self
        tableView.dataSource = self
        
        
        
        // Do any additional setup after loading the view.
    }

    func reloadItemAction() {
        rightItemDidTap?
            .asObservable()
            .subscribe(onNext: { (_) in
                SSToast.show("你点了最右边的item")
            })
            .disposed(by: disposeBag)
        
        secondRightItemDidTap?
            .asObservable()
            .subscribe(onNext: { (_) in
                SSToast.show("你点了从右边数第 2 个item")
            })
            .disposed(by: disposeBag)
        
        thirdRightItemDidTap?
            .asObservable()
            .subscribe(onNext: { (_) in
                SSToast.show("你点了从右边数第 3 个item")
            })
            .disposed(by: disposeBag)
    }
}

extension SSNavigationBarButtonItemDemoViewController: UITableViewDataSource {
    
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
      
        switch dataSource[indexPath.section][indexPath.row] {

        case "文本":
            addBarButtonItem(with: "Text")

        case "图片":
            addBarButtonItem(with: UIImage(named: "QMUI_previewImage_checkbox_checked"))

        case "系统item":
            addBarButtonItem(with: UIBarButtonItem.SystemItem.add)

        case "回头车item":
            addBarButtonItem(with: SSBarButtonItem.more)
            
        case "多个文本，带动画":
            addBarButtonItem(with: ["Text0", "Text1"], animated: true)
        
        case "混合数组，指定color":
            addBarButtonItem(with: ["Text0", UIImage(named: "QMUI_previewImage_checkbox_checked")!, SSBarButtonItem.more], tintColor: .red)
        
        case "中间样式-自定义view":
            let customView = UILabel()
                .ss_frame(x: 0, y: 0, width: 100, height: 34)
                .ss_layerCornerRadius(17, isOnShadow: true)
                .ss_layerBorder(color: .ss_main, width: 1)
                .ss_attribute(
                    "自定义".ss_attribute
                        .ss_font(font: UIFont.largeTitle.bold)
                        .ss_color(color: .red)
                        .ss_color(color: .green, with: "定")
                        .ss_color(color: .blue, with: "义")
                        .ss_alignment(.center)
                )
            addBarButtonItem(with: customView, at: .center)
            
        case "在隐藏导航栏模式下，添加item":
            let controller = SSNavigationHiddenDemoViewController()
            controller.showIntroduction = true
            navigationController?.pushViewController(controller, animated: true)
        default:
            break
        }
        reloadItemAction()
    }
}
