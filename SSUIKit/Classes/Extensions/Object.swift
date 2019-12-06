//
//  Object.swift
//  SSUIKit_Example
//
//  Created by 吴頔 on 2019/12/4.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import UIKit

public func ss_filterNil<T>(_ cur: T?, _ placeholder: T) -> T {
    if let cur = cur {
        return cur
    }else{
        return placeholder
    }
}

