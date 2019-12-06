//
//  SSAlertActionButtonItem.swift
//  DeviceKit
//
//  Created by 吴頔 on 2019/12/6.
//

import UIKit

public enum SSAlertActionButtonItem<T> {
    
    /// 确定
    case ok(extra: T?)
    
    /// 取消
    case cancel(extra: T?)
    
    /// 我知道了
    case iKnow(extra: T?)
    
    /// 自定义标题和颜色
    case custom(title: String, titleColor: UIColor?, extra: T?)
}

extension SSAlertActionButtonItem {

    /// 按钮标题
    public var title: String {
        switch self {
        case .ok: return "确定"
        case .cancel: return "取消"
        case .iKnow: return "我知道了"
        case let .custom(title, _, _): return title
        }
    }

    /// 按钮标题颜色
    public var titleColor: UIColor {
        switch self {
        case .ok: return UIColor.ss.main!
        case .cancel: return UIColor.gray
        case .iKnow: return UIColor.ss.main!
        case let .custom(_, titleColor, _): return titleColor ?? UIColor.ss.main!
        default: return .black
        }
    }

    /// 按钮携带的附加参数，用于回调后继续使用
    public var extra: T? {
        switch self {
        case let .ok(extra): return extra
        case let .cancel(extra): return extra
        case let .iKnow(extra): return extra
        case let .custom(_, _, extra): return extra
        default: return nil
        }
    }

}

