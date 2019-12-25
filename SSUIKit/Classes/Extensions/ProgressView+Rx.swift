//
//  ProgressView+Rx.swift
//  BlocksKit
//
//  Created by 吴頔 on 2019/12/16.
//

import UIKit
import RxCocoa
import RxSwift

public extension Reactive where Base: UIProgressView {
    /// 停止刷新
    public var animatedProgress: Binder<Double> {
        return Binder(base) { view, progress in
            let progress = Float(progress)
            view.setProgress(progress, animated: true)
            UIView.animate(withDuration: 0.01, delay: 0.35, options: UIView.AnimationOptions.curveEaseOut, animations: {}) { (_) in
                view.progress = 0
            }
        }
    }
}
