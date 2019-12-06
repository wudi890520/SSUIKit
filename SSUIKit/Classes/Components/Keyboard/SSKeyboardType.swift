//
//  KeyboardType.swift
//  SSUIKit
//
//  Created by 吴頔 on 2019/12/3.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import UIKit

public enum SSKeyboardType {
    case `default`
    case number
    case decimal
    case idCard
    case mobile
}

extension SSKeyboardType: Hashable, Equatable {
    /// 左下角按钮的title
    public var customButtonTitle: String? {
        switch self {
        case .decimal: return "."
        case .idCard: return "X"
        default: return nil
        }
    }

    /// 实现哈希协议
    public func hash(into hasher: inout Hasher) {
        switch self {
        case .default: return hasher.combine(0)
        case .number: return hasher.combine(1)
        case .decimal: return hasher.combine(2)
        case .idCard: return hasher.combine(3)
        case .mobile: return hasher.combine(4)
        }
    }
    
    /// 实现Equatable协议
    public static func == (lhs: SSKeyboardType, rhs: SSKeyboardType) -> Bool {
        switch (lhs, rhs) {
        case (.default, .default): return true
        case (.number, .number): return true
        case (.decimal, .decimal): return true
        case (.idCard, .idCard): return true
        case (.mobile, .mobile): return true
        default: return false
        }
    }
}

