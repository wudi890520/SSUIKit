//
//  SSHUDStatus.swift
//  DeviceKit
//
//  Created by 吴頔 on 2019/12/9.
//

import UIKit

public enum SSHUDStatus {

    /// 正在加载
    case loading
    
    /// 请稍后
    case waiting
    
    /// 正在上传
    case uploading
    
    /// 自定义文本
    case custom(status: String)
  
    /// 背景透明，且不让用户操作
    indirect case clear(SSHUDStatus)
    
    /// 背景黑色，且不让用户操作
    indirect case black(SSHUDStatus)
}

public extension SSHUDStatus {
    var status: String {
        switch self {
        case .loading, .clear(.loading), .black(.loading):
            return "正在加载"
        case .waiting, .clear(.waiting), .black(.waiting):
            return "请稍后"
        case .uploading, .clear(.uploading), .black(.uploading):
            return "正在上传"
        case .custom(let status), .clear(.custom(let status)), .black(.custom(let status)):
            return status
        default:
            return ""
        }
    }
    
    var mask: SVProgressHUDMaskType {
        switch self {
        case .loading, .waiting, .uploading, .custom:
            return .none
        case .clear(.loading), .clear(.waiting), .clear(.uploading), .clear(.custom):
            return .clear
        case .black(.loading), .black(.waiting), .black(.uploading), .black(.custom):
            return .black
        default:
            return .none
        }
    }
    
}
