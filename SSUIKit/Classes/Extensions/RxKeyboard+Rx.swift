//
//  RxKeyboard+Rx.swift
//  BlocksKit
//
//  Created by 吴頔 on 2019/12/16.
//

import UIKit
import RxKeyboard
import RxSwift
import RxCocoa

public extension RxKeyboard {
    public var dismiss: Driver<Void> {
        return self.visibleHeight
            .filter{ $0 == 0 }
            .mapVoid()
    }
    
    public var visiable: Driver<Void> {
        return self.visibleHeight
            .filter{ $0 > 0 }
            .mapVoid()
    }
    
}
