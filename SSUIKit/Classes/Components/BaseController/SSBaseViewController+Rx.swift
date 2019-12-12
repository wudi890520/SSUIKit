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

    var leftItemDidTap: Driver<Void>? {
        return leftTapAt(0)
    }
    
    var secondLeftItemDidTap: Driver<Void>? {
        return leftTapAt(1)
    }
    
    var thirdLeftItemDidTap: Driver<Void>? {
        return leftTapAt(2)
    }
    
    var rightItemDidTap: Driver<Void>? {
        return rightTapAt(0)
    }
    
    var secondRightItemDidTap: Driver<Void>? {
        return rightTapAt(1)
    }
    
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

public extension Reactive where Base: SSBaseViewController {
    var popGestureEnable: Binder<Bool> {
        return Binder(base) { controller, enable in
            controller.popGestureEnable = enable
        }
    }
}

public extension Reactive where Base: SSBaseViewController {
    var pop: Binder<Void> {
        return Binder(base) { controller, _ in
            controller.navigationController?.popViewController(animated: true)
        }
    }
    
    var popWithoutAnimated: Binder<Void> {
        return Binder(base) { controller, _ in
            controller.navigationController?.popViewController(animated: false)
        }
    }
    
    var popToRoot: Binder<Void> {
        return Binder(base) { controller, _ in
            controller.navigationController?.popToRootViewController(animated: true)
        }
    }
    
    var popToRootWithoutAnimated: Binder<Void> {
        return Binder(base) { controller, _ in
            controller.navigationController?.popToRootViewController(animated: false)
        }
    }
    
    var popTo: Binder<UIViewController.Type> {
        return Binder(base) { controller, cls in
            let last = controller.navigationController?.viewControllers.filter{ $0.isKind(of: cls) }.last
            guard let vc = last else { return }
            controller.navigationController?.popToViewController(vc, animated: true)
        }
    }
    
    var popToWithoutAnimated: Binder<UIViewController.Type> {
        return Binder(base) { controller, cls in
            let last = controller.navigationController?.viewControllers.filter{ $0.isKind(of: cls) }.last
            guard let vc = last else { return }
            controller.navigationController?.popToViewController(vc, animated: false)
        }
    }
}
