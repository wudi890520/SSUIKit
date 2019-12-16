//
//  ProgressView+Rx.swift
//  BlocksKit
//
//  Created by 吴頔 on 2019/12/16.
//

import UIKit
import RxCocoa
import RxSwift
import BlocksKit

public extension Reactive where Base: UIProgressView {
    /// 停止刷新
    public var animatedProgress: Binder<Double> {
        return Binder(base) { view, progress in
            let progress = Float(progress)
            view.setProgress(progress, animated: true)
            if progress >= 1 {
                view.bk_perform({ (_) in
                    view.progress = 0
                }, afterDelay: 0.35)
            }
        }
    }
}
