//
//  Image.swift
//  SSUIKit
//
//  Created by 吴頔 on 2019/11/30.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import UIKit
import QMUIKit
import YYCategories

extension UIImage {
    /// 旋转图片方向（旋转后为向上）
    ///
    /// - Returns: UIImage（optional）
    func ss_orientationUp() -> UIImage? {
        if imageOrientation != .up {
            UIGraphicsBeginImageContextWithOptions(size, false, scale)
            draw(in: CGRect(origin: .zero, size: size))
            let newImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            return newImage
        }
        return self
    }
    
    /// 切割图片为圆角
    /// - Parameter cornerRadius: 圆角大小
    func ss_clippedCorner(_ cornerRadius: CGFloat) -> UIImage? {
        return self.qmui_image(withClippedCornerRadius: cornerRadius)
    }
    
    /// 为图片添加边框
    /// - Parameter borderColor: 边框颜色
    /// - Parameter borderWidth: 边框线的大小（粗细）
    /// - Parameter cornerRadius: 边框圆角
    func ss_layerBorderStyle(borderColor: UIColor, borderWidth: CGFloat, cornerRadius: CGFloat) -> UIImage? {
         return self.qmui_image(withBorderColor: borderColor, borderWidth: borderWidth, cornerRadius: cornerRadius)
    }
    
    /// 缩放图片
    /// - Parameter maxWidth: 缩放后的最大宽度
    /// - Parameter maxHeight: 缩放后的最大高度
    func ss_zoom(maxWidth: CGFloat, maxHeight: CGFloat) -> UIImage? {
        return self.qmui_imageResized(inLimitedSize: CGSize(width: maxWidth, height: maxHeight))
    }
    
    /// 将图片改变颜色
    /// - Parameter color: 要改变的颜色
    func ss_color(_ color: UIColor) -> UIImage? {
        return self.qmui_image(withTintColor: color)
    }
}

extension UIImage {
    /// 将图片转base64字符串
    var ss_base64: String? {
        let maxWidth: CGFloat = 500
        guard let resized = self.qmui_imageResized(inLimitedSize: CGSize(width: maxWidth, height: maxWidth)) else { return nil }
        guard let data = resized.pngData() else { return nil }
        let base64String = data.base64EncodedString(options: .lineLength64Characters)
        return base64String
            .replacingOccurrences(of: "\n", with: "")
            .replacingOccurrences(of: "\r", with: "")
    }
    
}

extension UIImage {
    /// 创建一个纯色的图片
    /// - Parameter color: 图片颜色
    /// - Parameter size: 图片大小
    /// - Parameter cornerRadius: 图片圆角
    static func ss_image(with color: UIColor?, size: CGSize, cornerRadius: CGFloat = 0) -> UIImage? {
        return qmui_image(with: color, size: size, cornerRadius: cornerRadius)
    }
    
    /// 将文字渲染成图片，最终图片和文字一样大
    /// - Parameter attributeString: 文字
    static func ss_image(with attributeString: NSAttributedString?) -> UIImage? {
        guard let attributeString = attributeString else { return nil }
        return qmui_image(with: attributeString)
    }
    
    /// 将视图截图转成Image
    /// - Parameter view: 要截图的视图
    static func ss_snapshot(_ view: UIView?) -> UIImage? {
        guard let view = view else { return nil }
        return qmui_image(with: view)
    }
    
}

extension UIImage {
    
    /// 保持图片大小不变，延展图片
    /// - Parameter top: 顶部延展
    /// - Parameter left: 左边
    /// - Parameter bottom: 底部
    /// - Parameter right: 右边
    func ss_extension(top: CGFloat, left: CGFloat, bottom: CGFloat, right: CGFloat) -> UIImage? {
        let insets = UIEdgeInsets(top: top, left: left, bottom: bottom, right: right)
        return self.qmui_image(withSpacingExtensionInsets: insets)
    }
    
    /// 保持图片大小不变，向左延展图片
    ///
    /// - Parameter space: 延展距离
    /// - Returns: UIImage（optional）
    func ss_extensionLeft(_ space: CGFloat) -> UIImage? {
        return ss_extension(top: 0, left: space, bottom: 0, right: 0)
    }
    
    /// 保持图片大小不变，向右延展图片
    ///
    /// - Parameter space: 延展距离
    /// - Returns: UIImage（optional）
    func ss_extensionRight(_ space: CGFloat) -> UIImage? {
        return ss_extension(top: 0, left: 0, bottom: 0, right: space)
    }
    
    /// 保持图片大小不变，向上延展图片
    ///
    /// - Parameter space: 延展距离
    /// - Returns: UIImage（optional）
    func ss_extensionTop(_ space: CGFloat) -> UIImage? {
        return ss_extension(top: space, left: 0, bottom: 0, right: 0)
    }
    
    /// 保持图片大小不变，向下延展图片
    ///
    /// - Parameter space: 延展距离
    /// - Returns: UIImage（optional）
    func ss_extensionBottom(_ space: CGFloat) -> UIImage? {
        return ss_extension(top: 0, left: 0, bottom: space, right: 0)
    }
}
