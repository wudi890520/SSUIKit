//
//  SSBaseViewController+Protocol.swift
//  BlocksKit
//
//  Created by 吴頔 on 2019/12/12.
//

import UIKit

@objc protocol SSBaseViewControllerFlow {

    /// 初始化一些其他对象（在viewDidLoad之前，如果有需要的话）
    func ss_initSomeObjects()
    
    /// 设置导航栏的属性（BarButtonItem, Title ...）
    func ss_setNavigation()
    
    /// 添加子视图并进行约束
    func ss_layoutSubviews()
    
    /// 绑定数据与视图的关系
    func ss_bindDataSource()
}

extension SSBaseViewController: SSBaseViewControllerFlow {
    open func ss_initSomeObjects() {
        
    }
    
    open func ss_setNavigation() {
        
    }
    
    open func ss_layoutSubviews() {
        
    }
    
    open func ss_bindDataSource() {
        
    }
}
