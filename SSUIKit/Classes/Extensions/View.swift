//
//  SSUIView.swift
//  SSHuitouche
//
//  Created by 吴頔 on 2019/3/24.
//  Copyright © 2019 DDC. All rights reserved.
//

import UIKit
import QMUIKit

public typealias View = UIView

public protocol SSUIViewCompatible {}
extension UIView: SSUIViewCompatible {}

public extension SSUIViewCompatible where Self: UIView {
    /// 用CGRect约束Frame
    ///
    /// - Parameter rect: CGRect
    /// - Returns: UIView泛型
    @discardableResult
    func ss_frame(rect: CGRect) -> Self {
        self.frame = rect
        return self
    }

    /// 用x, y, width, height分别约束Frame
    ///
    /// - Parameters:
    ///   - x: 横坐标
    ///   - y: 纵坐标
    ///   - width: 视图宽度
    ///   - height: 视图高度
    /// - Returns: UIView泛型
    @discardableResult
    func ss_frame(x: CGFloat, y: CGFloat, width: CGFloat, height: CGFloat) -> Self {
        return ss_frame(rect: CGRect(x: x, y: y, width: width, height: height))
    }

    /// 用CGSize约束视图大小（此方法要求Point为0，即CGPoint = .zero）
    ///
    /// - Parameter size: CGSize
    /// - Returns: UIView泛型
    @discardableResult
    func ss_frame(size: CGSize) -> Self {
        return ss_frame(rect: CGRect(origin: .zero, size: size))
    }

    /// 设置视图背景颜色
    ///
    /// - Parameter color: UIColor
    /// - Returns: UIView泛型
    @discardableResult
    func ss_backgroundColor(_ color: UIColor?) -> Self {
        self.backgroundColor = color
        return self
    }

    
    /// 设置是否隐藏
    ///
    /// - Parameter isHidden: Bool类型。 true = 隐藏，false = 显示
    /// - Returns: UIView泛型
    @discardableResult
    func ss_isHidden(_ isHidden: Bool) -> Self {
        self.isHidden = isHidden
        return self
    }

    /// 设置透明度
    ///
    /// - Parameter alpha: CGFloat类型。范围0-1
    /// - Returns: UIView泛型
    @discardableResult
    func ss_alpha(_ alpha: CGFloat = 0) -> Self {
        self.alpha = alpha
        return self
    }

    /// 设置用户是否可点击
    ///
    /// - Parameter isEnable: Bool类型。 true = 可点击，false = 不可点击
    /// - Returns: UIView泛型
    @discardableResult
    func ss_isEnable(_ isEnable: Bool) -> Self {
        self.isUserInteractionEnabled = isEnable
        return self
    }

    /// 设置标签
    ///
    /// - Parameter tag: Int类型
    /// - Returns: UIView泛型
    @discardableResult
    func ss_tag(_ tag: Int) -> Self {
        self.tag = tag
        return self
    }

    /// 设置边界风格
    ///
    /// - Parameters:
    ///   - color: 边界线颜色
    ///   - width: 边界线宽度
    /// - Returns: UIView泛型
    @discardableResult
    func ss_layerBorder(color: UIColor?, width: CGFloat) -> Self {
        self.layer.borderColor = color?.cgColor
        self.layer.borderWidth = width
        return self
    }
    
    /// 设置阴影
    ///
    /// - Parameters:
    ///   - cornerRadius: 阴影半径
    ///   - shadowColor: 阴影颜色
    ///   - shadowOpacity: 阴影透明度
    ///   - shadowOffset: 阴影方向
    ///   - shadowRadius: 阴影长度
    /// - Returns: UIView泛型
    @discardableResult
    func ss_shadow(
        shadowColor: UIColor? = .hex("#e0e0e0"),
        shadowOpacity: Float = 1,
        shadowOffset: CGSize = .zero,
        shadowRadius: CGFloat = 3) -> Self {
        if backgroundColor == nil || backgroundColor == .clear {
            backgroundColor = .white
        }

        layer.shadowColor = shadowColor?.cgColor
        layer.shadowOpacity = shadowOpacity
        layer.shadowOffset = shadowOffset
        layer.shadowRadius = shadowRadius

        layer.shouldRasterize = true
        layer.rasterizationScale = UIScreen.main.scale

        return self
    }

    /// 设置圆角风格
    ///
    /// - Parameter cornerRadius: 圆角半径
    /// - Returns: UIView泛型
    @discardableResult
    func ss_layerCornerRadius(_ cornerRadius: CGFloat = 4, isOnShadow: Bool = false) -> Self {
        self.layer.cornerRadius = cornerRadius
        self.layer.masksToBounds = !isOnShadow
        return self
    }

    /// 设置部分圆角
    ///
    /// - Parameters:
    ///   - rectCorner: 分为左上，右上，左下，右下，可随意组合。示例：[UIRectCorner.topLeft, UIRectCorner.bottomRight]
    ///   - cornerRadius: 圆角半径
    ///   - borderColor: 边界线颜色
    ///   - borderWidth: 边界线宽度
    /// - Returns: UIView泛型
    @discardableResult
    func ss_partLayerCornerRadius(rectCorner: UIRectCorner, cornerRadius: CGFloat, borderColor: UIColor = .clear, borderWidth: CGFloat = 1.0/UIScreen.main.scale) -> Self {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: rectCorner, cornerRadii: CGSize(width: cornerRadius, height: cornerRadius))
        let mask = CAShapeLayer()
        mask.frame = bounds
        mask.path = path.cgPath
        mask.borderColor = borderColor.cgColor
        mask.borderWidth = borderWidth
        self.layer.mask = mask
        return self
    }

    /// 添加手势
    ///
    /// - Parameter gesture: 手势实例
    /// - Returns: UIView泛型
    @discardableResult
    func ss_addGesture(_ gesture: UIGestureRecognizer) -> Self {
        isUserInteractionEnabled = true
        addGestureRecognizer(gesture)
        return self
    }
}

public protocol SSUIViewAddChild {}
extension UIView: SSUIViewAddChild {}
public extension SSUIViewAddChild where Self: UIView {
    /// 添加子视图
    ///
    /// - Parameter subview: 子视图实例
    /// - Returns: UIView泛型
    @discardableResult
    func ss_add(_ subview: UIView) -> Self {
        addSubview(subview)
        return self
    }

    /// 添加一条线(利用border)
    ///
    /// - Parameter position: QMUIViewBorderPosition
    /// - Returns: UIView泛型
    @discardableResult
    func ss_border(at position: QMUIViewBorderPosition = .top, color: UIColor? = .ss_line, lineWidth: CGFloat = CGFloat.line, insets: UIEdgeInsets? = nil) -> Self {
        if let insets = insets {
            let borderView = UIView().ss_backgroundColor(color)
            self.addSubview(borderView)
            switch position {
            case .top:
                borderView.snp.makeConstraints { (make) in
                    make.left.equalToSuperview().offset(insets.left)
                    make.right.equalToSuperview().offset(-insets.right)
                    make.top.equalTo(0).offset(insets.top)
                    make.height.equalTo(lineWidth)
                }
            case .bottom:
                borderView.snp.makeConstraints { (make) in
                    make.left.equalToSuperview().offset(insets.left)
                    make.right.equalToSuperview().offset(-insets.right)
                    make.bottom.equalToSuperview().offset(-insets.bottom)
                    make.height.equalTo(lineWidth)
                }
            case .left:
                borderView.snp.makeConstraints { (make) in
                    make.top.equalToSuperview().offset(insets.top)
                    make.bottom.equalToSuperview().offset(-insets.bottom)
                    make.left.equalToSuperview().offset(insets.left)
                    make.width.equalTo(lineWidth)
                }
            case .right:
                borderView.snp.makeConstraints { (make) in
                    make.top.equalToSuperview().offset(insets.top)
                    make.bottom.equalToSuperview().offset(-insets.bottom)
                    make.right.equalToSuperview().offset(-insets.right)
                    make.width.equalTo(lineWidth)
                }
            default:
                break
            }
        }else{
            qmui_borderPosition = position
            qmui_borderColor = color
            qmui_borderWidth = lineWidth
        }
        return self
    }
}

let SSViewTopLineTag = 250001
let SSViewBottomLineTag = 250002
let SSViewLeftLineTag = 250003
public extension UIView {

    /// 初始化一条线
    ///
    /// - Parameter isHidden: 是否需要隐藏 默认不隐藏
    /// - Returns: UIView
    static func line(_ isHidden: Bool = false, tag: Int? = nil) -> UIView {
        return UIView()
            .ss_frame(x: 0, y: 0, width: CGFloat.screenWidth, height: CGFloat.line)
            .ss_backgroundColor(.ss_line)
            .ss_isHidden(isHidden)
            .ss_tag(tag.orEmpty)
    }

}

public extension UIView {

    /// 开始无限旋转动画
    func infinityRotate() {
        let animation = CABasicAnimation(keyPath: "transform.rotation.z")
        animation.toValue = Float.pi * 2
        animation.duration = 1
        animation.isCumulative = true
        animation.repeatCount = Float.infinity
        layer.add(animation, forKey: "rotationAnimation")
    }

    /// 停止旋转
    func stopRotate() {
        layer.removeAllAnimations()
    }
}

public extension UIView {
    func ss_update(_ animated: Bool = true, duration: TimeInterval = 0.25, delay: TimeInterval = 0, completion: (() -> Void)? = nil) {
        needsUpdateConstraints()
        updateConstraintsIfNeeded()

        if animated {
            UIView.animate(withDuration: duration, delay: delay, options: .curveEaseOut, animations: {
                self.layoutIfNeeded()
            }) { (finished) in
                if let completion = completion {
                    completion()
                }
            }
        }else{
            layoutIfNeeded()
        }
    }
}

public extension UIView {
    /// 开启调试模式，所有的subviews随机设置背景颜色
    @discardableResult
    func ss_debug() -> Self {
        qmui_shouldShowDebugColor = true
        qmui_needsDifferentDebugColor = true
        return self
    }

    /// 对当前视图截图
    func ss_snapshotImage(_ afterScreenUpdates: Bool) -> UIImage? {
        if afterScreenUpdates {
            return qmui_snapshotImage(afterScreenUpdates: afterScreenUpdates)
        }else{
            return qmui_snapshotLayerImage()
        }
    }

    /// 获取当前 view 所在的 UIViewController
    func ss_superViewController() -> UIViewController? {
        return qmui_viewController
    }
}
