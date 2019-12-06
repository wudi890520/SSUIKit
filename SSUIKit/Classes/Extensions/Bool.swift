//
//  Bool.swift
//  SSUIKit_Example
//
//  Created by 吴頔 on 2019/12/4.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import UIKit

public protocol OptionalBool {}
extension Bool: OptionalBool {}
public extension Optional where Wrapped: OptionalBool {
    var orEmpty: Bool {
        if self == nil {
            return false
        }else{
            return self as! Bool
        }
    }
    
    var orTrue: Bool {
        if self == nil {
            return true
        }else{
            return self as! Bool
        }
    }
    
    var orFalse: Bool {
        if self == nil {
            return false
        }else{
            return self as! Bool
        }
    }
}

public extension Bool {
    func ss_ternary<T>(_ trueValue: T, _ falseValue: T) -> T {
        if self == true {
            return trueValue
        }else{
            return falseValue
        }
    }
}
