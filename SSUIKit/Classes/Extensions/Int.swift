//
//  Int.swift
//  SSUIKit
//
//  Created by 吴頔 on 2019/11/30.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import UIKit

protocol OptionalInt {}
extension Int: OptionalInt {}
extension Optional where Wrapped: OptionalInt {
    var orEmpty: Int {
        if self == nil {
            return 0
        }else{
            return self as! Int
        }
    }
}

extension Int {
 
    public var ss_number: NSNumber {
        return NSNumber(integerLiteral: self)
    }
    
    public var ss_cgFloat: CGFloat {
        return CGFloat(self)
    }
    
    public var ss_page: Int {
        
        if self == 0 {
            return 1
        }
        
        let prefixPage = self / 10
        let suffixPage = self % 10 == 0 ? 0 : 1
        let page = prefixPage + suffixPage
        return page
    }
}
extension Int {
    public func getRow(colume: Int) -> Int {
        let row = self / colume
        let suffix = self % colume == 0 ? 0 : 1
        return row + suffix
    }
}

