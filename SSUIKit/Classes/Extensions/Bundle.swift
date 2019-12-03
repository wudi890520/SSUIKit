//
//  Bundle.swift
//  SSUIKit
//
//  Created by 吴頔 on 2019/11/30.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import UIKit

public extension Bundle {
    /// 获取当前App版本号（如：1.0.0，三位数的，不是build版本）
    public static var shortVersion: String? {
        let keyPath = "CFBundleShortVersionString"
        guard let version = Bundle.main.object(forInfoDictionaryKey: keyPath) as? String else { return nil }
        return version
    }
    
    /// 获取构建版本号
    public static var buildVersion: String? {
        let keyPath = "CFBundleVersion"
        guard let version = Bundle.main.object(forInfoDictionaryKey: keyPath) as? String else { return nil }
        return version
    }
}