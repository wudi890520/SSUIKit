//
//  ProgressView.swift
//  BlocksKit
//
//  Created by 吴頔 on 2019/12/16.
//

import UIKit

public typealias ProgressView = UIProgressView

protocol SSUIProgressViewCompatible {}
extension UIProgressView: SSUIProgressViewCompatible {}

extension SSUIProgressViewCompatible where Self: UIProgressView {

    /// 跟踪色
    ///
    /// - Returns: UIProgressView
    @discardableResult
    func ss_trackTintColor(_ color: UIColor) -> Self {
        trackTintColor = color
        return self
    }
    
    /// 进度条颜色
    ///
    /// - Returns: UIProgressView
    @discardableResult
    func ss_progressTintColor(_ color: UIColor) -> Self {
        progressTintColor = color
        return self
    }
}

