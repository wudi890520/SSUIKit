//
//  SSActionSheetItem.swift
//  SSUIKit_Example
//
//  Created by 吴頔 on 2019/12/5.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import UIKit

public struct SSActionSheetButtonItemData {
    let title: String?
    let titleColor: UIColor?
    let attribute: NSMutableAttributedString?
}

public enum SSActionSheetButtonItem<T> {
    
    /// 相机/拍照
    case camera
    
    /// 从相册选择
    case album
    
    /// 取消
    case cancel(extra: T?)

    /// 红色标题的按钮
    case destructive(title: String, extra: T?)
    
    /// 自定义标题和颜色
    case custom(title: String, titleColor: UIColor?, extra: T?)
    
    /// 自定义富文本标题（可改变文字大小，粗细，带图片，下划线....）
    case attribute(attribute: NSMutableAttributedString, extra: T?)
}

extension SSActionSheetButtonItem {
    
    /// 按钮标题
    public var title: String? {
        switch self {
        case .camera: return "拍照"
        case .album: return "从相册选择"
        case .cancel: return "取消"
        case let .destructive(title, _): return title
        case let .custom(title, _, _): return title
        default: return nil
        }
    }
    
    /// 按钮标题颜色
    public var titleColor: UIColor? {
        switch self {
        case .destructive: return .red
        case let .custom(_, titleColor, _): return titleColor ?? .black
        case .attribute: return nil
        default: return .black
        }
    }
    
    /// 按钮标题颜色
    public var attribute: NSMutableAttributedString? {
        switch self {
        case let .attribute(attribute, _): return attribute
        default: return nil
        }
    }
    
    /// 按钮携带的附加参数，用于回调后继续使用
    public var extra: T? {
        switch self {
        case let .cancel(extra): return extra
        case let .destructive(_, extra): return extra
        case let .custom(_, _, extra): return extra
        case let .attribute(_, extra): return extra
        default: return nil
        }
    }
    
    public var data: SSActionSheetButtonItemData {
        return SSActionSheetButtonItemData(title: title, titleColor: titleColor, attribute: attribute)
    }
}

extension SSActionSheetButtonItem: Equatable {
    public static func == (lhs: SSActionSheetButtonItem, rhs: SSActionSheetButtonItem) -> Bool {
        switch (lhs, rhs) {
        case (.camera, .camera): return true
        case (.album, .album): return true
        case (.cancel, .cancel): return true
        case let (.destructive(l_title, _), .destructive(r_title, _)): return l_title == r_title
        case let (.custom(l_title, _, _), .custom(r_title, _,  _)): return l_title == r_title
        default: return false
        }
    }
}
