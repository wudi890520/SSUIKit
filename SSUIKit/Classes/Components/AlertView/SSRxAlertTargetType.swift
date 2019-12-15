//
//  SSRxAlertTargetType.swift
//  BlocksKit
//
//  Created by 吴頔 on 2019/12/15.
//

import UIKit
import RxCocoa
import RxSwift

public protocol SSRxAlertTargetType {
    var action: Driver<Bool> { get set }
    
    var isNeedObserverKeyboard: Bool { get }
    
    func presentCompletion()
}
