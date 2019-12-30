//
//  Driver.swift
//  BlocksKit
//
//  Created by 吴頔 on 2019/12/12.
//

import UIKit
import RxCocoa
import RxSwift

public extension Driver {
    /// 映射成空
    func mapVoid() -> Driver<Void> {
        return map{ _ in () } as! Driver<Void>
    }
    
    /// 振动反馈
    func impactOccurred() -> Driver<Element> {
        return self.do(onNext: { (_) in
            UIImpactFeedbackGenerator.ss_impactOccurred()
        }) as! SharedSequence<DriverSharingStrategy, Element>
    }
    
    /// 判断用户当前的手指是否在屏幕上
    func filterTrackingRunLoopMode() -> Driver<Element> {
        return self.filter({ (_) -> Bool in
            if let currentMode = RunLoop.current.currentMode, currentMode == .tracking {
                return true
            }
            return false
        }) as! SharedSequence<DriverSharingStrategy, Element>
    }
    
    /// 节流
    ///
    func debounceIfNeeded() -> Driver<Element> {
        return self.debounce(DispatchTimeInterval.Duration.ss_min) as! SharedSequence<DriverSharingStrategy, Element>
    }
    
    /// 发送广播通知
    ///
    /// - Parameter name: 通知名
    func sendNotification(_ name: Notification.Name?) -> Driver<Element> {
        return self.do(onNext: { (element) in
            if let name = name {
                NotificationCenter.default.post(name: name, object: element)
            }
        }) as! SharedSequence<DriverSharingStrategy, Element>
    }
    
    /// 自定计算高度
    ///
    /// - Parameter view: 要计算的视图
    func systemLayoutSizeFitting(_ view: UIView) -> Driver<Element> {
        return self.do(onNext: nil, onCompleted: {
            let size = view.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
            guard let superView = view.superview else { return }
            view.width = superView.width
            view.height = size.height
            (view.superview as? UITableView)?.reloadData()
        }) as! SharedSequence<DriverSharingStrategy, Element>
    }
    
    /// 映射成动画时间（用于加载完数据显示子视图）
    ///
    /// - Returns: TimeInterval
    func mapAnimationDuration() -> Driver<TimeInterval> {
        return self.map({ (_) -> TimeInterval in
            TimeInterval.Duration.ss_animate
        }) as! Driver<TimeInterval>
    }
    
    func popDelay(_ delay: TimeInterval = TimeInterval.Duration.ss_popDelay) -> Driver<Void> {
        return self
            .delay(.milliseconds(Int(delay * 1000)))
            .mapVoid()
    }
    
    func minDelay() -> Driver<Element> {
        return self.delay(DispatchTimeInterval.Duration.ss_min) as! SharedSequence<DriverSharingStrategy, Element>
    }
}

public extension Driver where Element == Bool {
    
    /// 反转Bool值
    func reverse() -> Driver<Element> {
        return self.map{ !$0 } as! SharedSequence<DriverSharingStrategy, Element>
    }
}

public extension Driver where Element == Notification.Name? {
    /// 发送通知
    func post() -> Driver<Element> {
        return self.do(onNext: { $0?.post() }) as! SharedSequence<DriverSharingStrategy, Element>
    }
}
