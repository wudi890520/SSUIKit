//
//  SSAlertDisplayElement.swift
//  DeviceKit
//
//  Created by 吴頔 on 2019/12/6.
//

import UIKit

public enum SSAlertDisplayElementButtonType {
    /// 在左边
    case cancel
    /// 在右边
    case confirm
    /// 在中间，就一个按钮
    case justOnly
    /// 在中间，且在白色content view的下面
    case close
}

public struct SSAlertDisplayTableViewItemData {
    let image: UIImage?
    let title: String?
    let subTitle: String?
    let extra: Any?
    
    public init(image: UIImage?, title: String?, subTitle: String?, extra: Any?) {
        self.image = image
        self.title = title
        self.subTitle = subTitle
        self.extra = extra
    }
}

/// 弹框上面的元素
public enum SSAlertDisplayElement {
    
    /// 标签，字体默认居中
    /// - Parameters content: 内容
    /// - Parameters insets: 上下左右间距
    case label(content: NSMutableAttributedString, insets: UIEdgeInsets)
    
    /// 输入框
    /// - Parameters placeholder: 提示文本
    /// - Parameters keyboardType: 键盘类型
    /// - Parameters insets: 上下左右间距
    /// - Parameters leftTitle: 左标题
    /// - Parameters rightTitle: 右标题
    /// - Parameters textDidChange: 文本变化
    case textField(placeholder: String, keyboardType: SSKeyboardType, insets: UIEdgeInsets, leftTitle: NSMutableAttributedString?, rightTitle: NSMutableAttributedString?, textDidChange: ((String) -> Void)?)
    
    /// 列表
    /// - Parameters dataSource: 数据源
    /// - Parameters rowHeight: 行高
    /// - Parameters selectedIndex: 列表点击事件
    case tableView(dataSource: [SSAlertDisplayTableViewItemData], rowHeight: CGFloat, selectedIndex: ((Any?) -> Void)?)
    
    /// 按钮
    /// - Parameters title: 按钮标题
    /// - Parameters titleColor: 按钮标题颜色
    /// - Parameters backgroundColor: 按钮背景颜色
    /// - Parameters type: 按钮类型
    /// - Parameters didTap: 按钮点击事件
    case button(title: String, titleColor: UIColor?, backgroundColor: UIColor?, type: SSAlertDisplayElementButtonType, didTap: ((Void) -> Void)?)
    
    /// 图片
    /// - Parameters source: 数据（可传入字符串，URL，UIImage）
    /// - Parameters maxHeight: 图片最大高度
    /// - Parameters maxWidth: 图片最大宽度
    /// - Parameters extra: 附加参数，会随着点击事件返回
    /// - Parameters didTap: 点击图片的回调
    case image(source: Any?, extra: Any?, didTap: ((Any?) -> Void)?)
    
    /// 自定义UI
    /// - Parameters extra: 附加参数，会随着点击事件返回
    case custom(view: UIView)
}

extension SSAlertDisplayElement: Equatable {
    public static func == (lhs: SSAlertDisplayElement, rhs: SSAlertDisplayElement) -> Bool {
        switch (lhs, rhs) {
        case (.label, .label):          return true
        case (.textField, .textField):  return true
        case (.tableView, .tableView):  return true
        case (.button, .button):        return true
        case (.image, .image):          return true
        case (.custom, .custom):        return true
        default:                        return false
        }
    }
}
 
extension Array where Element == SSAlertDisplayElement {
    var imageURL: URL? {
        for e in self {
            switch e {
            case let .image(source, _, _):
                if let url = source as? URL {
                    return url
                }else if let string = source as? String, let url = URL(string: string) {
                    return url
                }else{
                    return nil
                }
            default:
                continue
            }
        }
        return nil
    }
    
    func replaceImageElement(_ image: UIImage) -> [SSAlertDisplayElement] {
        for i in 0 ..< self.count {
            let e = self[i]
            switch e {
            case let .image(source, extra, didTap):
                let newImageElement = SSAlertDisplayElement.image(source: image, extra: extra, didTap: didTap)
                var newElements = self
                newElements[i] = newImageElement
                return newElements
            default:
                continue
            }
        }
        return self
    }
}
