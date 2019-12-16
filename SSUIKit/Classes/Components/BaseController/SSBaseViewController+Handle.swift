//
//  SSBaseViewController+Handle.swift
//  BlocksKit
//
//  Created by 吴頔 on 2019/12/11.
//

import UIKit

public enum SSViewControllerIgnoredStrategy {
    
    /// 移除控制器下所有该类型的控制器
    case just(class: UIViewController.Type)
    
    /// 移除中间的所有控制器（保留root+current）
    case all
    
    /// 移除前一个控制器
    case previos
    
    /// 从当前控制器向前移除指定数量的控制器（如果max越界，至少会保留root+current）
    case collectionFromCurrent(max: Int)
}

extension UIViewController {
    
    /// 导航控制器下的所有视图控制器集合
    public var navigationViewControllers: [UIViewController] {
        guard let viewControllers = navigationController?.viewControllers else { return [] }
        return viewControllers
    }
    
    /// 导航控制器有多少个子控制器
    public var navigationViewControllersCount: Int {
        return navigationViewControllers.count
    }
    
    /// 当前视图控制器在导航控制中的位置
    public var indexOfNavigationControllers: Int {
        if let navigation = navigationController {
            for i in 0 ..< navigation.viewControllers.count {
                let controller = navigation.viewControllers[i]
                if controller == self {
                    return i
                    break
                }
            }
        }
        return 0
    }
    
    /// 当前视图控制器是否可见
    public var isVisiable: Bool {
        if let _ = view.window, isViewLoaded {
            return true
        }else{
            return false
        }
    }
}

public extension UIViewController {
    public func ignore(_ strategy: SSViewControllerIgnoredStrategy) {
        
        switch strategy {
        case let .just(cls):
            navigationController?.viewControllers = navigationViewControllers
                .filter{ $0.isKind(of: cls) == false }
            
        case .all:
            if navigationViewControllersCount <= 2 { return }
            let range = (1 ... navigationViewControllersCount-2)
            var controllers = navigationViewControllers
            controllers.replaceSubrange(range, with: [])
            navigationController?.viewControllers = controllers
            
        case .previos:
            if navigationViewControllersCount <= 2 { return }
            let preIndex = navigationViewControllersCount-2
            let range = (preIndex ... preIndex)
            var controllers = navigationViewControllers
            controllers.replaceSubrange(range, with: [])
            navigationController?.viewControllers = controllers
            
        case let .collectionFromCurrent(max):
            if navigationViewControllersCount <= 2 { return }
            var startIndex = navigationViewControllersCount-1-max
            if startIndex < 1 { startIndex = 1 }
            let range = (startIndex ... navigationViewControllersCount-2)
            var controllers = navigationViewControllers
            controllers.replaceSubrange(range, with: [])
            navigationController?.viewControllers = controllers
            
        default:
            break
        }
        
    }
}

public extension UIViewController {
    
    @discardableResult
    public func ss_hideTabbar() -> Self {
        hidesBottomBarWhenPushed = true
        return self
    }
    
    @discardableResult
    public func ss_asStork(_ height: CGFloat) -> Self {
        let transitionDelegate = SPStorkTransitioningDelegate()
        transitionDelegate.customHeight = height
        transitionDelegate.swipeToDismissEnabled = true
        transitionDelegate.showIndicator = false
        self.transitioningDelegate = transitionDelegate
        self.modalPresentationStyle = .custom
        self.modalPresentationCapturesStatusBarAppearance = true
        return self
    }
    
    @discardableResult
    public func ss_asModelPopup() -> Self {
        self.view.backgroundColor = .clear
        self.modalPresentationStyle = .overCurrentContext
        UIApplication.rootViewController?.modalPresentationStyle = .currentContext
        return self
    }
    
    @discardableResult
    public func ss_fullScreenPresentationStyle() -> Self {
        modalPresentationStyle = .fullScreen
        return self
    }
    
    @discardableResult
    public func ss_title(_ title: String?) -> Self {
        self.title = title
        hidesBottomBarWhenPushed = true
        return self
    }
 
    public func checkViewIfExsit<T: UIView>(type: T.Type, from superview: UIView?) -> T? {
        guard let superview = superview else { return nil }
        for view in superview.subviews where view.isKind(of: type) {
            return view as? T
        }
        return nil
    }
}
