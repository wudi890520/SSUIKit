//
//  BehaviorRelay+Extension.swift
//  BlocksKit
//
//  Created by 吴頔 on 2019/12/16.
//

import UIKit
import RxSwift
import RxCocoa
import RxOptional

public extension BehaviorRelay where BehaviorRelay.Element : RxOptional.OptionalType {
    public func asSafeDriver() -> Driver<BehaviorRelay.Element.Wrapped> {
        return self.asDriver().filterNil()
    }
}
