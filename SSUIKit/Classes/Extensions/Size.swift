//
//  Size.swift
//  FBSnapshotTestCase
//
//  Created by 吴頔 on 2019/11/30.
//

import UIKit

typealias Size = CGSize

public extension CGSize {
    
    /// 屏幕
    struct Screen {
        /// 屏幕尺寸
        static let size = UIScreen.main.bounds
        /// 屏幕高度
        static let height = size.height
        /// 屏幕宽度
        static let width = size.width
    }
}


public extension CGSize {
    
    /// 不安全区域
    struct UnsafeArea {
        /// 状态栏高度
        static var statusBar: CGFloat {
            if UIDevice.isBangsScreen {
                return 44
            }else{
                return 20
            }
        }
        
        /// 导航栏高度
        static let navigationBar: CGFloat = 44
        
        /// 选项卡高度
        static let tabbarBar: CGFloat = 49
        
        /// 顶部加起来一共是多高
        static var top: CGFloat { statusBar + navigationBar }
        
        /// 当刘海屏时，底部home bar的高度
        static var bottom: CGFloat {
            if UIDevice.isBangsScreen {
                return 34
            }else{
                return 0
            }
        }
        
        
    }
    
}


public extension CGSize {
    
    /// 安全区域
    struct SafeArea {
        /// 首页（含tabbar）的安全内容高度
        static var rootContentHeight = Screen.height - UnsafeArea.top - UnsafeArea.bottom - UnsafeArea.tabbarBar
        
        /// 子页面（不含tabbar）的安全内容高度
        static var childContentHeight = Screen.height - UnsafeArea.top - UnsafeArea.bottom
    }
}
