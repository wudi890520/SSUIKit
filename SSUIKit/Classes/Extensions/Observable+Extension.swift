//
//  Observable.swift
//  BlocksKit
//
//  Created by 吴頔 on 2019/12/12.
//

import UIKit
import RxCocoa
import RxSwift

extension Observable {
    func mapVoid() -> Observable<Void> {
        return map{ _ in () }
    }
    
    /// 振动反馈
    public func impactOccurred() -> Observable<Element> {
        return self.do(onNext: { (_) in
            if #available(iOS 10.0, *) {
                UIImpactFeedbackGenerator.ss_impactOccurred()
            }
        })
    }
    
    /// 发送广播通知
    ///
    /// - Parameter name: 通知名
    func sendNotification(_ name: Notification.Name) -> Observable<Element> {
        return self.do(onNext: { (element) in
            NotificationCenter.default.post(name: name, object: element)
        })
    }
    
    /// 判断用户当前的手指是否在屏幕上
    func filterTrackingRunLoopMode() -> Observable<Element> {
        return self.filter({ (_) -> Bool in
            if let currentMode = RunLoop.current.currentMode, currentMode == .tracking {
                return true
            }
            return false
        })
    }
}
