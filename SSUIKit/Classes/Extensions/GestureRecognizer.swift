//
//  GestureRecognizer.swift
//  SSUIKit_Example
//
//  Created by 吴頔 on 2019/12/4.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import UIKit

public extension UIGestureRecognizer {

    /// 长按手势
    ///
    /// - Parameter minimumPressDuration: 最小时长间隔
    /// - Returns: UILongPressGestureRecognizer
    static func ss_longPress(_ minimumPressDuration: TimeInterval) -> UILongPressGestureRecognizer {
        let gesture = UILongPressGestureRecognizer()
        gesture.minimumPressDuration = minimumPressDuration
        return gesture
    }
    
    /// 点击手势
    ///
    /// - Returns: UITapGestureRecognizer
    static func ss_tap() -> UITapGestureRecognizer {
        return UITapGestureRecognizer()
    }
}
