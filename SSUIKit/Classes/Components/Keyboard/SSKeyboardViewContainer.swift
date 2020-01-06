//
//  KeyboardViewContainer.swift
//  SSUIKit_Example
//
//  Created by 吴頔 on 2019/12/4.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import UIKit

class SSKeyboardViewContainer: NSObject {
    
    public var keyboardType: SSKeyboardType?
    
    /// 键盘背景视图
    public let keyboardBackgroundView = UIView()
        .ss_frame(x: 0, y: 0, width: CGFloat.screenWidth, height: 0)
        .ss_backgroundColor(.ss_keyboardBackground)
        .ss_add(UIView(frame: UIScreen.main.bounds).ss_backgroundColor(.ss_keyboardBackground))
    
    /// 键盘删除按钮
    public let deleteBtn = UIButton()
        .ss_frame(size: Item.size)
        .ss_backgroundImage(.ss_keyboardBackground)
        .ss_backgroundImage(.ss_keyboardSelected, for: .highlighted)
        .ss_image("keyboard-delete".bundleImage)
        .ss_tag(-1)
        .ss_addGesture(UIGestureRecognizer.ss_longPress(0.8))
    
    /// 左下角的键盘按钮
    /// -- 小数键盘，此按钮为 "."
    /// -- 身份证键盘，此按钮为 "X"
    public lazy var customBtn: UIButton? = {
        guard let keyboardType = keyboardType else { return nil }
        return UIButton()
            .ss_backgroundImage(.ss_keyboardBackground)
            .ss_backgroundImage(.ss_keyboardSelected, for: .highlighted)
            .ss_title(keyboardType.customButtonTitle)
            .ss_titleColor(.black)
            .ss_font(Style.fontSize)
            .ss_tag(99)
    }()
    
    /// 键盘数字按钮
    public let numbers: [UIButton] = {
        return Range.numberRange
            .compactMap{ SSKeyboardViewContainer.creatBtn($0.ss_number) }
    }()
    
    /// 水平的线数组
    public let horizontalLines: [UIView] = {
        return Range.horizontalLine
            .compactMap{ UIView.line(tag: $0).ss_backgroundColor(.ss_keyboardBackground) }
    }()
    
    /// 垂直的线数组
    public let verticalLineLines: [UIView] = {
        return Range.verticalLine
            .compactMap{ UIView.line(tag: $0).ss_backgroundColor(.ss_keyboardBackground) }
    }()
    
}

extension SSKeyboardViewContainer {
    
    /// 初始化数字按钮
    ///
    /// - Parameter number: 数字
    /// - Returns: UIButton
    static func creatBtn(_ number: NSNumber) -> UIButton {
        return UIButton()
            .ss_frame(size: SSKeyboardViewContainer.Item.size)
            .ss_font(Style.fontSize)
            .ss_titleColor(.ss_black)
            .ss_backgroundImage(.ss_keyboardNormal)
            .ss_backgroundImage(.ss_keyboardSelected, for: .highlighted)
            .ss_title(number.stringValue)
            .ss_tag(number.intValue)
    }
}

extension SSKeyboardViewContainer {
    
    /// 键盘按钮的 高度、大小
    struct Item {
        static let height: CGFloat = 55
        static let size: CGSize = CGSize(width: CGFloat.screenWidth / Style.colume.ss_cgFloat, height: height)
    }
    
    /// 键盘的高度
    struct Content {
        static let height: CGFloat = Item.height * Style.row.ss_cgFloat
    }
    
    /// 范围
    struct Range {
        /// 数字键盘的范围
        static let numberRange = 0 ..< 10
        /// 水平线
        static let horizontalLine = 0 ..< Style.row + 1
        /// 垂直线
        static let verticalLine = 0 ..< Style.colume - 1
    }
    
    /// 样式
    struct Style {
        static let colume: Int = 3
        static let row: Int = 4
        static let fontSize: CGFloat = 24
    }
}
