//
//  Font.swift
//  SSUIKit
//
//  Created by 吴頔 on 2019/11/30.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import UIKit

public typealias Font = UIFont

public extension UIFont {
    /// 标题字体
    struct Title {
        /// 小（fontSize = 15.0）
        public static let light = UIFont.systemFont(ofSize: 15)
        /// 中（fontSize = 16.0）
        public static let normal = UIFont.systemFont(ofSize: 16)
        /// 系统 （fontSize = 17.0）
        public static let system = UIFont.systemFont(ofSize: 17)
        /// 大（fontSize = 18.0）
        public static let large = UIFont.systemFont(ofSize: 18)
    }
    
    /// 详情字体
    struct Detail {
        /// 小（fontSize = 12.0）
        public static let light = UIFont.systemFont(ofSize: 12)
        /// 中（fontSize = 13.0）
        public static let normal = UIFont.systemFont(ofSize: 13)
        /// 大（fontSize = 14.0）
        public static let large = UIFont.systemFont(ofSize: 14)
    }
    
    /// 价格字体
    struct Price {
        /// 小（fontSize = 20.0）
        public static let light = UIFont.systemFont(ofSize: 20)
        /// 大（fontSize = 24.0）
        public static let large = UIFont.systemFont(ofSize: 24)
    }
}

public extension UIFont {
    
    /// fontSize = 15.0
    static let lightTitle = Title.light
    
    /// fontSize = 16.0
    static let title = Title.normal
    
    /// fontSize = 18.0
    static let largeTitle = Title.large
    
    /// fontSize = 12.0
    static let lightDetail = Detail.light
    
    /// fontSize = 13.0
    static let detail = Detail.normal
    
    /// fontSize = 14.0
    static let largeDetail = Detail.large
    
    /// fontSize = 20.0
    static let lightPrice = Price.light
    
    /// fontSize = 24.0
    static let largePrice = Price.large
}

public extension UIFont {
    var bold: UIFont { .boldSystemFont(ofSize: pointSize) }
}

public extension UIFont {
    static func with(_ fontSize: CGFloat) -> UIFont {
        return .systemFont(ofSize: fontSize)
    }
    
    static func bold(_ fontSize: CGFloat) -> UIFont {
        return .boldSystemFont(ofSize: fontSize)
    }
}
