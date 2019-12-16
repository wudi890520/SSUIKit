//
//  ScrollView+Rx.swift
//  BlocksKit
//
//  Created by 吴頔 on 2019/12/16.
//

import UIKit
import RxCocoa
import RxSwift

public extension Reactive where Base: UIScrollView {
    
    public var scrollToTop: Binder<Void> {
        return Binder.init(base, binding: { (scrollView, _) in
            scrollView.scrollToTop(animated: true)
        })
    }
    
    public var hideAllIndicators: Binder<Void> {
        return Binder.init(base, binding: { (scrollView, _) in
            scrollView.ss_hideAllIndicators()
        })
    }
}

public extension Reactive where Base: UIScrollView {
    public var contentOffsetY: Driver<CGFloat> {
        let scrollView = base
        return base.rx.didScroll
            .asDriver()
            .map{ _ in scrollView.contentOffset.y }
    }
}



