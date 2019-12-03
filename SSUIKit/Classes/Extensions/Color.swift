//
//  Color.swift
//  FBSnapshotTestCase
//
//  Created by 吴頔 on 2019/11/29.
//

import UIKit
import QMUIKit

public protocol SSColorCompatible {}

extension UIColor: SSColorCompatible {}

public struct Color {
    
    /// 主色
    public static let main: UIColor? = UIColor.hex("#00997b")
    
    /// 主色（浅）
    public static let lightMain: UIColor? = UIColor.hex("#ECFDFC")
    
    /// 背景颜色
    public static let background: UIColor? = UIColor.hex("#f2f6f7")
    
    /// 橙色
    public static let orange: UIColor? = UIColor.hex("#ff642b")
    
    /// 分割线颜色
    public static let line: UIColor? = UIColor.hex("#e1e1e0")
    
    /// 不可点击
    public static let disable: UIColor? = UIColor.hex("#cccccc")
    
    /// 红色
    public static let red: UIColor? = UIColor.hex("#ff5f51")
    
    /// 红色（浅）
    public static let lightRed: UIColor? = UIColor.hex("#FFE3E1")
    
    /// 蓝色
    public static let blue: UIColor? = UIColor.hex("#4285f4")
    
    /// 黄色
    public static let yellow: UIColor? = UIColor.hex("#ffd348")
    
    /// 金色
    public static let gold: UIColor? = UIColor.hex("#ca9335")
    
    /// 灰色
    public static let gray: UIColor? = UIColor.hex("#768197")
    
    /// 工具条颜色
    public static let toolBar: UIColor? = UIColor.hex("#f4f4f4")
    
    /// 键盘背景色
    public static let keyboardBackground: UIColor? = UIColor.hex("#ececec")
    
    /// 键盘普通状态颜色
    public static let keyboardNormal: UIColor? = UIColor.hex("#ffffff")
    
    /// 键盘点击颜色
    public static let keyboardSelected: UIColor? = UIColor.hex("#cdcdcd")
    
    /// cell点击颜色
    public static let cellSelected: UIColor? = UIColor.hex("#d9d9d9")
    
    /// 标签颜色
    public static let tag: UIColor? = UIColor.hex("#FFAC23")
    
    /// 标签颜色（浅）
    public static let lightTag: UIColor? = UIColor.hex("#FFF9EC")
    
    /// 标签颜色（深）
    public static let darkTag: UIColor? = UIColor.hex("#ED6C00")
    
    /// 倒计时颜色
    public static let countDown: UIColor? = UIColor.hex("#ABB0B5")
    
    /// 聊天背景颜色
    public static let chatBackground: UIColor? = UIColor.hex("#ededed")
    
    /// 微信主色（微信绿）
    public static let weChatTint: UIColor? = UIColor.hex("#232d31")
    
    /// 文本颜色
    public static let text: UIColor? = UIColor.darkText
    
    /// 白色
    public static let white: UIColor? = UIColor.white
    
    /// 黑色
    public static let black: UIColor? = UIColor.black
}

extension SSColorCompatible where Self: UIColor {
    
    public static var ss: Color.Type { Color.self }

}

extension SSColorCompatible where Self: UIColor {
    public static func hex(_ string: String?) -> UIColor? {
        return UIColor.qmui_color(withHexString: string)
    }
    
    public static func rgb(_ r: CGFloat, _ g: CGFloat, _ b: CGFloat, _ a: CGFloat = 1) -> UIColor? {
        return UIColor(red: r/255.0, green: g/255.0, blue: b/255.0, alpha: a)
    }
}

extension SSColorCompatible where Self: UIColor {
    
    /// 主色
    public static var ss_main: UIColor? { Color.main }
    
    /// 主色（浅）
    public static var ss_lightMain: UIColor? { Color.lightMain }
    
    /// 背景颜色
    public static var ss_background: UIColor? { Color.background }
    
    /// 橙色
    public static var ss_orange: UIColor? { Color.orange }
    
    /// 分割线颜色
    public static var ss_line: UIColor? { Color.line }
    
    /// 不可点击
    public static var ss_disable: UIColor? { Color.disable }
    
    /// 红色
    public static var ss_red: UIColor? { Color.red }
    
    /// 红色（浅）
    public static var ss_lightRed: UIColor? { Color.lightRed }
    
    /// 蓝色
    public static var ss_blue: UIColor? { Color.blue }
    
    /// 黄色
    public static var ss_yellow: UIColor? { Color.yellow }
    
    /// 金色
    public static var ss_gold: UIColor? { Color.gold }
    
    /// 灰色
    public static var ss_gray: UIColor? { Color.gray }
    
    /// 工具条颜色
    public static var ss_toolBar: UIColor? { Color.toolBar }
    
    /// 键盘背景色
    public static var ss_keyboardBackground: UIColor? { Color.keyboardBackground }
    
    /// 键盘普通状态颜色
    public static var ss_keyboardNormal: UIColor? { Color.keyboardNormal }
    
    /// 键盘点击颜色
    public static var ss_keyboardSelected: UIColor? { Color.keyboardSelected }
    
    /// cell点击颜色
    public static var ss_cellSelected: UIColor? { Color.cellSelected }
    
    /// 标签颜色
    public static var ss_tag: UIColor? { Color.tag }
    
    /// 标签颜色（浅）
    public static var ss_lightTag: UIColor? { Color.lightTag }
    
    /// 标签颜色（深）
    public static var ss_darkTag: UIColor? { Color.darkTag }
    
    /// 倒计时颜色
    public static var ss_countDown: UIColor? { Color.countDown }
    
    /// 聊天背景颜色
    public static var ss_chatBackground: UIColor? { Color.chatBackground }
    
    /// 微信主色（微信绿）
    public static var ss_weChatTint: UIColor? { Color.weChatTint }
    
    /// 文本颜色
    public static var ss_text: UIColor? { Color.text }
    
    /// 白色
    public static var ss_white: UIColor? { Color.white }
    
    /// 黑色
    public static var ss_black: UIColor? { Color.black }
}
