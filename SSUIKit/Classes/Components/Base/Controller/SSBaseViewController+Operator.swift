//
//  SSBaseViewController+Operator.swift
//  BlocksKit
//
//  Created by 吴頔 on 2019/12/12.
//

import UIKit
import RxSwift
import RxCocoa
import RxKeyboard

/// 信号源 >> 监听者
infix operator >> : BitwiseShiftPrecedence

/// 信号源 >> 无监听
infix operator ..

/// 信号源 >> 收起键盘
infix operator !!

/// 信号源 >> 无返回值的函数体（会自动执行）
infix operator **

// MARK: - DriverSharingStrategy
public func >> <E, Observer>(left: SharedSequence<DriverSharingStrategy, E>? = nil, right: Observer? = nil) -> RxSwift.Disposable where Observer : RxSwift.ObserverType, E == Observer.Element {
    guard let left = left else { return Disposables.create() }
    guard let right = right else { return Disposables.create() }
    return left.drive(right)
}


public func >> <E, Observer>(left: SharedSequence<DriverSharingStrategy, E>? = nil, right: Observer? = nil) -> RxSwift.Disposable where Observer : RxSwift.ObserverType, Observer.Element == E? {
    guard let left = left else { return Disposables.create() }
    guard let right = right else { return Disposables.create() }
    return left.drive(right)
}


public func >> <E, Observer>(left: SharedSequence<DriverSharingStrategy, E>, observers: [Observer?]) -> RxSwift.Disposable where Observer : RxSwift.ObserverType, Observer.Element == E {
    return left.asObservable() >> observers
        
}


public func >> <E, Observer>(left: SharedSequence<DriverSharingStrategy, E>, observers: [Observer?]) -> RxSwift.Disposable where Observer : RxSwift.ObserverType, Observer.Element == E?  {
    return left.asObservable() >> observers
        
}


public func >> <E>(left: SharedSequence<DriverSharingStrategy, E>? = nil, right: RxRelay.BehaviorRelay<E>? = nil) -> RxSwift.Disposable {
    guard let left = left else { return Disposables.create() }
    guard let right = right else { return Disposables.create() }
    return left.drive(right)
}


public func >> <E>(left: SharedSequence<DriverSharingStrategy, E>? = nil, right: RxRelay.BehaviorRelay<E?>? = nil) -> RxSwift.Disposable {
    guard let left = left else { return Disposables.create() }
    guard let right = right else { return Disposables.create() }
    return left.drive(right)
}


public func >> <E, R>(left: SharedSequence<DriverSharingStrategy, E>, right: (RxSwift.Observable<E> ) -> R) -> R {
    return left.drive(right)
}


public func .. <E>(_ left: SharedSequence<DriverSharingStrategy, E>, right: Void) -> Disposable {
    return left.drive()
}


public func !! <E>(_ left: SharedSequence<DriverSharingStrategy, E>, right: Void) -> Disposable {
    return left.do(onNext: { _ in UIApplication.endEditing() }).drive()
}

public func ** <E>(_ left: SharedSequence<DriverSharingStrategy, E>, function: @escaping () -> Void) -> Disposable {
    return left.do(onNext: { _ in function() }).drive()
}

// MARK: - ObservableType

public func >> <E, Observer>(left: Observable<E>? = nil, right: Observer? = nil) -> RxSwift.Disposable where Observer : RxSwift.ObserverType, E == Observer.Element {
    guard let left = left else { return Disposables.create() }
    guard let right = right else { return Disposables.create() }
    return left.bind(to: right)
}


public func >> <E, Observer>(left: Observable<E>? = nil, right: Observer? = nil) -> RxSwift.Disposable where Observer : RxSwift.ObserverType, Observer.Element == E? {
    guard let left = left else { return Disposables.create() }
    guard let right = right else { return Disposables.create() }
    return left.bind(to: right)
}


public func >> <E, Observer: ObserverType>(left: Observable<E>, observers: [Observer?]) -> RxSwift.Disposable where Observer.Element == E {
    return left.subscribe { (event) in
        observers.forEach{ $0?.on(event) }
    }
}


public func >> <E, Observer: ObserverType>(left: Observable<E>, observers: [Observer?]) -> RxSwift.Disposable where Observer.Element == E?  {
    return left.map{ $0 as E? }.subscribe { (event) in
        observers.forEach{ $0?.on(event) }
    }
}


public func >> <E, R>(left: Observable<E>, right: (RxSwift.Observable<E> ) -> R) -> R {
    return left.bind(to: right)
}


public func .. <E>(_ left: Observable<E>, right: Void) -> Disposable {
    return left.subscribe()
}


public func .. <E>(_ left: Observable<E>?, right: Void) -> Disposable {
    guard let left = left else { return Disposables.create() }
    return left.subscribe()
}


public func !! <E>(_ left: Observable<E>, right: Void) -> Disposable {
    return left.asObservable().do(onNext: { _ in UIApplication.endEditing() }).subscribe()
}

public func ** <E>(_ left: Observable<E>, function: @escaping () -> Void) -> Disposable {
    return left.asObservable().do(onNext: { _ in function() }).subscribe()
}
