//
//  ScrollView.swift
//  SSUIKit
//
//  Created by 吴頔 on 2019/11/30.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import UIKit
import QMUIKit

public typealias ScrollView = UIScrollView

public protocol SSUIScrollViewCompatible {}
extension UIScrollView: SSUIScrollViewCompatible {}

public extension SSUIScrollViewCompatible where Self: UIScrollView {
    
    /// 隐藏垂直指示条
    ///
    /// - Returns: UIScrollView
    @discardableResult
    func ss_hideVerticalIndicator() -> Self {
        showsVerticalScrollIndicator = false
        return self
    }
    
    /// 隐藏水平指示条
    ///
    /// - Returns: UIScrollView
    @discardableResult
    func ss_hideHorizontalIndicator() -> Self {
        showsHorizontalScrollIndicator = false
        return self
    }
    
    /// 隐藏垂直和水平指示条
    ///
    /// - Returns: UIScrollView
    @discardableResult
    func ss_hideAllIndicators() -> Self {
        showsVerticalScrollIndicator = false
        showsHorizontalScrollIndicator = false
        return self
    }
    
    /// 禁止回弹效果
    ///
    /// - Returns: UIScrollView
    @discardableResult
    func ss_bouncesDisable() -> Self {
        bounces = false
        return self
    }
    
    /// 设置键盘隐藏模式（默认滑动隐藏）
    ///
    /// - Parameter mode: UIScrollView.KeyboardDismissMode
    /// - Returns: UIScrollView
    @discardableResult
    func ss_keyboardDismissMode(_ mode: UIScrollView.KeyboardDismissMode = .interactive) -> Self {
        keyboardDismissMode = mode
        return self
    }
}

public extension UIScrollView {
    
    /// 判断UIScrollView是否已经处于顶部
    var ss_isAtTop: Bool { return qmui_alreadyAtTop }
    
    /// 判断UIScrollView是否已经处于底部
    var ss_isAtBottom: Bool { return qmui_alreadyAtBottom }
    
    /// inset
    var ss_contentInset: UIEdgeInsets { return qmui_contentInset }
    
}

public extension UIScrollView {
    
    /// 滚到顶部
    /// - Parameter animated: 是否需要动画, 默认为需要
    func ss_scrollToTop(_ animated: Bool = true) {
        qmui_scrollToTop(animated: animated)
    }
    
    /// 停止滚动
    func ss_stop() {
        qmui_stopDeceleratingIfNeeded()
    }
    
    /// 修改 contentInset
    /// - Parameter inset: UIEdgeInsets
    /// - Parameter animated: 是否要使用动画修改
    func ss_contentInset(_ inset: UIEdgeInsets, animated: Bool) {
        qmui_setContentInset(inset, animated: animated)
    }
}
