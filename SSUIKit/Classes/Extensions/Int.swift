//
//  Int.swift
//  SSUIKit
//
//  Created by 吴頔 on 2019/11/30.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import UIKit

public protocol OptionalInt {}
extension Int: OptionalInt {}
public extension Optional where Wrapped: OptionalInt {
    var orEmpty: Int {
        if self == nil {
            return 0
        }else{
            return self as! Int
        }
    }
}

public extension Int {
 
    var ss_number: NSNumber {
        return NSNumber(integerLiteral: self)
    }
    
    var ss_cgFloat: CGFloat {
        return CGFloat(self)
    }
    
    var ss_page: Int {
        
        if self == 0 {
            return 1
        }
        
        let prefixPage = self / 10
        let suffixPage = self % 10 == 0 ? 0 : 1
        let page = prefixPage + suffixPage
        return page
    }
}

public extension Int {
    func getRow(colume: Int) -> Int {
        let row = self / colume
        let suffix = self % colume == 0 ? 0 : 1
        return row + suffix
    }
}

