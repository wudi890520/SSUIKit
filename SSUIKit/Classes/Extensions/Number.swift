//
//  Number.swift
//  SSUIKit
//
//  Created by 吴頔 on 2019/11/30.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import UIKit

public extension NSNumber {
    
    /// 格式化
    /// - Parameter length: 小数点后几位
    /// - Parameter isForce: 是否强制
    public func ss_format(_ length: Int, isForce: Bool = false) -> String {
        if stringValue.contains(".") == false && isForce == false {
            return stringValue
        }
        return String(format: "%.\(length)f", floatValue)
    }
    
    /// 乘以一个系数
    /// - Parameter by: 系数
    public func ss_multiplied(_ by: Float) -> String {
        let result = self.floatValue * by
        let newValue = NSNumber(floatLiteral: Double(result))
        return newValue.ss_format(0)
    }
}
