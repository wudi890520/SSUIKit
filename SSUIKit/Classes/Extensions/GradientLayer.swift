//
//  GradientLayer.swift
//  BlocksKit
//
//  Created by 吴頔 on 2019/12/25.
//

import UIKit

public protocol SSCAGradientLayerCompatible {}

extension CAGradientLayer: SSCAGradientLayerCompatible {}

public extension SSCAGradientLayerCompatible where Self: CAGradientLayer {
    
    /// 默认样式
    static func `default`() -> CAGradientLayer {
        return CAGradientLayer()
            .ss_frame(CGRect(x: 0, y: 0, width: CGFloat.screenWith, height: CGFloat.unsafeTop))
            .ss_direction(.fromTop)
            .ss_darkMode()
    }
}


public extension SSCAGradientLayerCompatible where Self: CAGradientLayer {
    /// 用CGRect约束Frame
    ///
    /// - Parameter rect: CGRect
    /// - Returns: UIView泛型
    @discardableResult
    func ss_frame(_ rect: CGRect) -> Self {
        self.frame = rect
        return self
    }
    
    /// 颜色数组
    /// - Parameter colors: [UIColor]
    @discardableResult
    func ss_colors(_ colors: [UIColor]) -> Self {
        self.colors = colors.map{ $0.cgColor }
        return self
    }
    
    /// 变色起点
    /// - Parameter point: CGPoint
    @discardableResult
    func ss_startPoint(_ point: CGPoint) -> Self {
        self.startPoint = point
        return self
    }
    
    /// 变色终点
    /// - Parameter point: CGPoint
    @discardableResult
    func ss_endPoint(_ point: CGPoint) -> Self {
        self.endPoint = point
        return self
    }
}

/// 变色方向
public enum SSCAGradientLayerDirection {
    /// start point 从顶部开始
    case fromTop
    /// start point 从底部开始
    case fromBottom
}

public extension SSCAGradientLayerCompatible where Self: CAGradientLayer {
    
    /// 设置渐变方向
    /// - Parameter direction: SSCAGradientLayerDirection
    @discardableResult
    func ss_direction(_ direction: SSCAGradientLayerDirection) -> Self {
        switch direction {
        case .fromTop:
            startPoint = CGPoint(x: 0, y: 0)
            endPoint = CGPoint(x: 0, y: 1)
        case .fromBottom:
            startPoint = CGPoint(x: 0, y: 1)
            endPoint = CGPoint(x: 0, y: 0)
        }
        return self
    }
    
    /// 设置成黑色渐变
    @discardableResult
    func ss_darkMode() -> Self {
        self.colors = [UIColor.ss_weChatTint, UIColor(hexString: "#3c4244")!.cgColor]
        return self
    }
}


