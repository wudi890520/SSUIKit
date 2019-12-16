//
//  Device.swift
//  SSUIKit
//
//  Created by 吴頔 on 2019/11/30.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import UIKit
import DeviceKit
import AdSupport

public extension UIDevice {
    /// 是否是刘海屏
    /// - True: 是刘海屏
    /// - False: 不是
    public static var isBangsScreen: Bool {
        let device = Device.current
        switch device {
        case .iPhone4, .iPhone4s,
             .iPhone5, .iPhone5c, .iPhone5s,
             .iPhone6, .iPhone6Plus, .iPhone6s, .iPhone6sPlus,
             .iPhone7, .iPhone7Plus,
             .iPhone8, .iPhone8Plus,
             .iPhoneSE:
             return false
            
        case .simulator(.iPhone4), .simulator(.iPhone4s),
             .simulator(.iPhone5), .simulator(.iPhone5c), .simulator(.iPhone5s),
             .simulator(.iPhone6), .simulator(.iPhone6Plus), .simulator(.iPhone6s), .simulator(.iPhone6sPlus),
             .simulator(.iPhone7), .simulator(.iPhone7Plus),
             .simulator(.iPhone8), .simulator(.iPhone8Plus),
             .simulator(.iPhoneSE):
            return false
            
        default:
            return true
        }
    }
    
    /// 系统版本号
    public static var systemVersion: String? {
        return Device.current.systemVersion
    }
    
    /// 广告标识符
    public static var IDFA: String? {
        return ASIdentifierManager.shared().advertisingIdentifier.uuidString
    }
    
    /// 应用开发商标识符
    public static var IDFV: String? {
        return UIDevice.current.identifierForVendor?.uuidString
    }
    
    /// 设备描述
    public static var description: String {
        return Device.current.description
    }
}
