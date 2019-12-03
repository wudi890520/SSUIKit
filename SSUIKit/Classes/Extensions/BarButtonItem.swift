//
//  BarButtonItem.swift
//  SSUIKit
//
//  Created by 吴頔 on 2019/11/30.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import UIKit
protocol SSBarButtonItemCompatible {}

extension UIBarButtonItem: SSBarButtonItemCompatible {}

extension SSBarButtonItemCompatible where Self: UIBarButtonItem {
    /// 设置标题
    ///
    /// - Parameter title: 标题
    /// - Returns: UIBarButtonItem
    @discardableResult
    func ss_title(_ title: String?) -> Self {
        self.title = title
        return self
    }
    
    /// 设置图片
    ///
    /// - Parameter image: 图片
    /// - Returns: UIBarButtonItem
    @discardableResult
    func ss_image(_ image: UIImage?) -> Self {
        self.image = image
        return self
    }
    
    /// 设置视图
    ///
    /// - Parameter custom: UIView
    /// - Returns: UIBarButtonItem
    @discardableResult
    func ss_custom(_ custom: UIView?) -> Self {
        self.customView = custom
        return self
    }
    
    /// 设置标题字体大小
    ///
    /// - Parameter fontSize: 字号
    /// - Returns: UIBarButtonItem
    @discardableResult
    func ss_font(_ fontSize: CGFloat?) -> Self {
        guard let fontSize = fontSize else { return self }
        self.setTitleTextAttributes(
            [.font : UIFont.systemFont(ofSize: fontSize)],
            for: .normal
        )
        return self
    }
    
    /// 设置内容颜色
    ///
    /// - Parameter tintColor: 颜色
    /// - Returns: UIBarButtonItem
    @discardableResult
    func ss_tintColor(_ tintColor: UIColor?) -> Self {
        self.tintColor = tintColor
        return self
    }
}
