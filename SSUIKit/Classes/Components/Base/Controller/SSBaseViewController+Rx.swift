//
//  SSBaseViewController+Rx.swift
//  BlocksKit
//
//  Created by 吴頔 on 2019/12/11.
//

import UIKit
import RxCocoa
import RxSwift

public extension UIViewController {
    
    /// 最左边的item被点击
    var leftItemDidTap: Driver<Void>? {
        return leftTapAt(0)
    }
    
    /// 从左边数，第二个item被点击
    var secondLeftItemDidTap: Driver<Void>? {
        return leftTapAt(1)
    }
    
    /// 从左边数，第三个item被点击
    var thirdLeftItemDidTap: Driver<Void>? {
        return leftTapAt(2)
    }
    
    /// 最右边的item被点击
    var rightItemDidTap: Driver<Void>? {
        return rightTapAt(0)
    }
    
    /// 从右边数，第二个item被点击
    var secondRightItemDidTap: Driver<Void>? {
        return rightTapAt(1)
    }
    
    /// 从右边数，第三个item被点击
    var thirdRightItemDidTap: Driver<Void>? {
        return rightTapAt(2)
    }
    
    private func leftTapAt(_ index: Int) -> Driver<Void>? {
        if let base = self as? SSBaseViewController, base.barStyle.isHidden == true {
            guard let items = base.leftBarButtonItems, items.count >= index+1 else { return nil }
            return items[index].rx.tap.asDriver()
        }else{
            guard let items = navigationItem.leftBarButtonItems, items.count >= index+1 else { return nil }
            return items[index].rx.tap.asDriver()
        }
    }
    
    private func rightTapAt(_ index: Int) -> Driver<Void>? {
        if let base = self as? SSBaseViewController, base.barStyle.isHidden == true {
            guard let items = base.rightBarButtonItems, items.count >= index+1 else { return nil }
            return items[index].rx.tap.asDriver()
        }else{
            guard let items = navigationItem.rightBarButtonItems, items.count >= index+1 else { return nil }
            return items[index].rx.tap.asDriver()
        }
    }
}

public extension SSBaseViewController {
    
    /// 绑定
    /// - Parameter dispose: Disposable
    public func BD(_ dispose: Disposable) {
        binding(dispose)
    }

    private func binding(_ dispose: Disposable) {
        dispose.disposed(by: self.dispose)
    }

}

public extension Reactive where Base: SSBaseViewController {
    
    /// 控制滑动返回是否可用
    var popGestureEnable: Binder<Bool> {
        return Binder(base) { controller, enable in
            controller.popGestureEnable = enable
        }
    }
    
    /// 移除导航栏左边的按钮
    var removeLeftBarButtonItem: Binder<Void> {
        return Binder(base) { controller, enable in
            controller.addBarButtonItem(with: SSBarButtonItem.nil, at: .left)
        }
    }
    
    /// 移除导航栏右边的按钮
    var removeRightBarButtonItem: Binder<Void> {
        return Binder(base) { controller, enable in
            controller.addBarButtonItem(with: SSBarButtonItem.nil)
        }
    }
}

public extension Reactive where Base: SSBaseViewController {
    
    /// 回到上一页（有动画）
    var pop: Binder<Void> {
        return Binder(base) { controller, _ in
            controller.navigationController?.popViewController(animated: true)
        }
    }
    
    /// 回到上一页（无动画）
    var popWithoutAnimated: Binder<Void> {
        return Binder(base) { controller, _ in
            controller.navigationController?.popViewController(animated: false)
        }
    }
    
    /// 回到根控制器（有动画）
    var popToRoot: Binder<Void> {
        return Binder(base) { controller, _ in
            controller.navigationController?.popToRootViewController(animated: true)
        }
    }
    
    /// 回到根控制器（无动画）
    var popToRootWithoutAnimated: Binder<Void> {
        return Binder(base) { controller, _ in
            controller.navigationController?.popToRootViewController(animated: false)
        }
    }
    
    /// 根据类名，回到离当前页面最近的该类名页面（有动画）
    var popTo: Binder<UIViewController.Type> {
        return Binder(base) { controller, cls in
            let last = controller.navigationController?.viewControllers.filter{ $0.isKind(of: cls) }.last
            guard let vc = last else { return }
            controller.navigationController?.popToViewController(vc, animated: true)
        }
    }
    
    /// 根据类名，回到离当前页面最近的该类名页面（无动画）
    var popToWithoutAnimated: Binder<UIViewController.Type> {
        return Binder(base) { controller, cls in
            let last = controller.navigationController?.viewControllers.filter{ $0.isKind(of: cls) }.last
            guard let vc = last else { return }
            controller.navigationController?.popToViewController(vc, animated: false)
        }
    }
    
    /// 当模态弹出时，让本控制器消失（有动画）
    var dismiss: Binder<Void> {
        return Binder(base) { controller, _ in
            controller.dismiss(animated: true, completion: nil)
        }
    }
    
    /// 当模态弹出时，让本控制器消失（无动画）
    var dismissWithoutAnimated: Binder<Void> {
        return Binder(base) { controller, _ in
            controller.dismiss(animated: false, completion: nil)
        }
    }
    
    /// 统一返回，不管转场用的是堆栈还是模态（有动画）
    var back: Binder<Void> {
        return Binder(base) { controller, _ in
            if controller.qmui_isPresented() && controller.indexOfNavigationControllers == 0 {
                controller.dismiss(animated: true, completion: nil)
            }else{
                controller.navigationController?.popViewController(animated: true)
            }
        }
    }
    
    /// 统一返回，不管转场用的是堆栈还是模态（无动画）
    var backWithoutAnimated: Binder<Void> {
        return Binder(base) { controller, _ in
            if controller.qmui_isPresented() && controller.indexOfNavigationControllers == 0 {
                controller.dismiss(animated: false, completion: nil)
            }else{
                controller.navigationController?.popViewController(animated: false)
            }
        }
    }
}
