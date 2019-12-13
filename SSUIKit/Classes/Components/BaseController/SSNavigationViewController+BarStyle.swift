//
//  SSNavigationBarStyle.swift
//  BlocksKit
//
//  Created by 吴頔 on 2019/12/11.
//

import UIKit
import QMUIKit

public enum SSNavigationBarStyle {
    case `default`
    case black
    case clear
    case hidden
    case custom(statusBarStyle: UIStatusBarStyle, barBackgroundColor: UIColor, barTintColor: UIColor)
}

extension SSNavigationBarStyle {
    
    /// 状态栏颜色
    var statusBarStyle: UIStatusBarStyle {
        switch self {
        case .default:
            return .default
        case .black:
            return .lightContent
        case .clear:
            return .default
        case .hidden:
            return .default
        case let .custom(statusBarStyle, _, _):
            return statusBarStyle
        }
    }
    
    /// 导航栏背景颜色
    var barBackgroundImage: UIImage? {
        switch self {
        case .default:
            return nil
        case .black:
            return UIImage(color: .ss_weChatNavigation)
        case .clear:
            return UIImage(color: .clear)
        case .hidden:
            return UIImage(color: .clear)
        case let .custom(_, backgroundColor, _):
            return UIImage(color: backgroundColor)
        }
    }
    
    /// 导航栏上的item颜色
    var barTintColor: UIColor? {
        switch self {
        case .default:
            return .black
        case .black:
            return .white
        case .clear:
            return .black
        case .hidden:
            return .black
        case let .custom(_, _, barTintColor):
            return barTintColor
        }
    }
    
    var isHidden: Bool {
        switch self {
        case .hidden:
            return true
        default:
            return false
        }
    }
    
    
    /// 导航栏底部线条颜色
    var shadowImage: UIImage? {
        switch self {
        case .default:
            return nil
        default:
            return UIImage(color: .clear)
        }
    }
    
    /// 转场动画的key
    var barTransitionKey: String {
        barBackgroundImage?.qmui_averageColor().hexString()
        
        switch self {
        case .clear:
            return "-1"
        default:
            if let hex = barBackgroundImage?.qmui_averageColor().hexString() {
                return hex
            }else{
                return "0"
            }
        }
    }
}

extension SSBaseViewController {
    /// 导航栏背景颜色
    open override func navigationBarBackgroundImage() -> UIImage? {
        return barStyle.barBackgroundImage
    }
    
    /// 导航栏上BarButtonItem的颜色
    open override func navigationBarTintColor() -> UIColor? {
        return barStyle.barTintColor
    }
    
    /// 导航栏底部分割线颜色
    open override func navigationBarShadowImage() -> UIImage? {
        return barStyle.shadowImage
    }
    
    /// 状态栏样式
    open override var preferredStatusBarStyle: UIStatusBarStyle {
        return barStyle.statusBarStyle ?? .default
    }
    
    /// 转场时的动画Key
    open override func customNavigationBarTransitionKey() -> String? {
        return barStyle.barTransitionKey
    }
    
    /// 导航栏是否需要隐藏
    open override func preferredNavigationBarHidden() -> Bool {
        return barStyle.isHidden
    }
    
    open override func shouldCustomizeNavigationBarTransitionIfHideable() -> Bool {
        return true
    }
    
    /// 是否允许手势返回
    /// - Parameter byPopGesture: 手势返回
    open override func shouldPopViewController(byBackButtonOrPopGesture byPopGesture: Bool) -> Bool {
        if byPopGesture {
            return popGestureEnable
        }else{
            return true
        }
    }
    
    open override func forceEnableInteractivePopGestureRecognizer() -> Bool {
        return true
    }
}
