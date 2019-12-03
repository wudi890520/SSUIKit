//
//  Dictionary.swift
//  SSUIKit
//
//  Created by 吴頔 on 2019/11/30.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import UIKit

public extension Dictionary {
    public var queryString: String {
        return reduce("", { sum, add in sum + "&\(add.key)=\(add.value)" })
    }
}
