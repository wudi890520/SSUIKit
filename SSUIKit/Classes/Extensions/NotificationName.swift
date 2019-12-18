//
//  Notification.swift
//  BlocksKit
//
//  Created by 吴頔 on 2019/12/12.
//

import UIKit
import RxSwift
import RxCocoa

public extension Notification.Name {

    public var asObservable: Observable<Notification> {
        return NotificationCenter.default.rx.notification(self)
    }
    
    public var asVoidDriver: Driver<Void> {
        return asObservable.mapVoid().asDriver(onErrorJustReturn: ())
    }
    
    public func asObservable<T>(_ type: T.Type) -> Observable<T> {
        return asObservable.map{ $0.object as? T }.filterNil()
    }
}

public extension Notification.Name {
    
    public func post(_ object: Any? = nil) {
        NotificationCenter.default.post(name: self, object: object)
    }
    
}
