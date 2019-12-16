//
//  UIView+Rx.swift
//  BlocksKit
//
//  Created by 吴頔 on 2019/12/16.
//

import UIKit
import RxCocoa
import RxSwift

public extension UIView {
    
    private struct AssociatedKeys {
        /// 原来的底部位置
        static var originBottom = "ss_uiView_originBottom"

    }
    
    /// 原来的底部位置
    var ss_originBottom: CGFloat? {
        set {
            objc_setAssociatedObject(self, &type(of: self).AssociatedKeys.originBottom, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        get {
            return objc_getAssociatedObject(self, &type(of: self).AssociatedKeys.originBottom) as? CGFloat
        }
    }
}

public extension Reactive where Base: UIView {
    
    /// 显示
    public var show: Binder<TimeInterval> {
        return Binder(base) { view, duration in
            UIView.animate(withDuration: duration, animations: {
                view.alpha = 1
            })
        }
    }
    
    /// 显示子视图
    public var showSubviews: Binder<TimeInterval> {
        return Binder(base) { view, duration in
            view.subviews.forEach { (v) in
                UIView.animate(withDuration: duration, animations: {
                    v.alpha = 1
                })
            }
        }
    }
    
    /// 隐藏
    public var dismiss: Binder<TimeInterval> {
        return Binder(base) { view, duration in
            UIView.animate(withDuration: duration, animations: {
                view.alpha = 0
            })
        }
    }
    
    public var alphaAnimation: Binder<Bool> {
        return Binder(base) { view, isHidden in
            let alpha: CGFloat = isHidden ? 0 : 1
            UIView.animate(withDuration: TimeInterval.Duration.ss_animate, animations: {
                view.alpha = alpha
            })
        }
    }
    
    /// 隐藏后从父类视图中移除
    public var removeAfterDismiss: Binder<TimeInterval> {
        return Binder(base) { view, duration in
            UIView.animate(withDuration: duration, animations: {
                view.alpha = 0
            }, completion: { (_) in
                view.removeFromSuperview()
            })
        }
    }
    
    public func autoMove(_ offset: CGFloat = 0, ignoreUnsafeBottom: Bool = false) -> Binder<CGFloat> {
        return Binder(base) { view, height in
            print(height)

            if height == 0 {
                view.bottom = view.ss_originBottom ?? CGFloat.screenHeight
                view.ss_originBottom = nil
            }else{
                view.ss_originBottom = view.bottom
                if ignoreUnsafeBottom {
                    view.bottom = CGFloat.screenHeight - height - offset + CGFloat.unsafeBottom
                }else{
                    view.bottom = CGFloat.screenHeight - height - offset
                }
            }

        }
    }
}

