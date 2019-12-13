//
//  Float.swift
//  SSUIKit
//
//  Created by 吴頔 on 2019/11/30.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import UIKit

public protocol OptionalFloat {}
extension Float: OptionalFloat {}
public extension Optional where Wrapped: OptionalFloat {
    var orEmpty: Float {
        if self == nil {
            return 0
        }else{
            return self as! Float
        }
    }
}

public protocol OptionalDouble {}
extension Double: OptionalDouble {}
public extension Optional where Wrapped: OptionalDouble {
    var orEmpty: Double {
        if self == nil {
            return 0
        }else{
            return self as! Double
        }
    }
}

public protocol OptionalCGFloat {}
extension CGFloat: OptionalCGFloat {}
public extension Optional where Wrapped: OptionalCGFloat {
    var orEmpty: CGFloat {
        if self == nil {
            return 0
        }else{
            return self as! CGFloat
        }
    }
}

public extension CGFloat {
    static var statusBar: CGFloat { Size.UnsafeArea.statusBar }
    static var navigationBar: CGFloat { Size.UnsafeArea.navigationBar }
    static var unsafeTop: CGFloat { Size.UnsafeArea.top }
    static var unsafeBottom: CGFloat { Size.UnsafeArea.bottom }
    static var tabbar: CGFloat { Size.UnsafeArea.tabbarBar }
}

public extension CGFloat {
    static var safeRootContentHeight: CGFloat { Size.SafeArea.rootContentHeight }
    static var safeChildContentHeight: CGFloat { Size.SafeArea.childContentHeight }
}

public extension CGFloat {
    
    /// 线的宽度
    static let line: CGFloat = 1.0 / UIScreen.main.scale
    
    /// 接近于0
    static let zero: CGFloat = 1.0 / CGFloat.infinity
    
    /// 间距
    static let edge: CGFloat = 15
    
    /// cell高度
    static let cell: CGFloat = 54
    
    /// 按钮高度
    static let button: CGFloat = 45
}

public extension CGFloat {
    
    /// 屏幕宽度
    static let screenWith = Size.Screen.width
    
    /// 屏幕高度
    static let screenHeight = Size.Screen.height
 
}
