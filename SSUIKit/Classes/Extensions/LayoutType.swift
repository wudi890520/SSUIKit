//
//  Layout.swift
//  SSUIKit_Example
//
//  Created by 吴頔 on 2019/12/4.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import UIKit

public protocol SSLayoutType {
    
    associatedtype V
    
    var superView: UIView? { get set }
    
    /// 子视图容器
    var children: V? { get set }
    
    /// 绑定视图容器与视图约束管理者
    ///
    /// - Parameters:
    ///   - views: 子视图容器
    ///   - view: 父视图
    func make(children views: V, in view: UIView)
    
    /// 添加子视图
    func addChildren()
    
    /// 约束子视图
    func layoutChildren()
}
