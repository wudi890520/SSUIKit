//
//  NavigationController+Rx.swift
//  BlocksKit
//
//  Created by 吴頔 on 2019/12/16.
//

import UIKit
import RxCocoa
import RxSwift

public extension Reactive where Base: UINavigationController {
    public var barIsHidden: Binder<Bool> {
        return Binder(base) { controller, isHidden in
            controller.setNavigationBarHidden(isHidden, animated: true)
        }
    }
}

