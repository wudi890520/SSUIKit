//
//  RefreshControl.swift
//  SSUIKit
//
//  Created by 吴頔 on 2019/11/30.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import UIKit
import MJRefresh

extension MJRefreshGifHeader {
    
    /// 重写父类setState方法，注入UIImpactFeedbackGenerator
    /// 当state为MJRefreshStatePulling（松手即可刷新）的状态时，加入系统触感反馈
    open override var state: MJRefreshState {
        didSet {
            if state == .pulling || state == .refreshing {
                
                if state == .pulling, #available(iOS 10.0, *) {
                    UIImpactFeedbackGenerator.ss_impactOccurred()
                }
                
                let stateKey = NSNumber(integerLiteral: state.rawValue)
                
                guard let stateImages = value(forKey: "stateImages") as? [NSNumber: Any] else { return }
                guard let images = stateImages[stateKey] as? [UIImage], !images.isEmpty else { return }
                gifView.stopAnimating()
                if images.count == 1 {
                    gifView.image = images.last
                }else{
                    gifView.animationImages = images
                    let stateDurations = value(forKey: "stateImages") as? [NSNumber: String] ?? [:]
                    let duration = stateDurations[stateKey] ?? "1.2"
                    gifView.animationDuration = Double(duration) ?? 1.2
                    gifView.startAnimating()
                }
            }else if state == .idle {
                gifView.stopAnimating()
            }
        }
    }
}

extension MJRefreshGifHeader {
    
    /// 将要结束刷新
    public func willEndRefreshing() {
        guard let image = UIImage(named: "refreshEnded") else { return }
        setImages([image], for: .idle)
    }
    
    /// 重设idle images
    ///
    /// - Parameter delay: 等待刷新控件 自动收回后 0.3秒，悄悄的执行
    public func reloadIdleImages(_ delay: TimeInterval = 0.3) {
        perform(#selector(setIdleImages), afterDelay: delay)
    }
    
    /// 设置未刷新时状态下的图片数组（即下拉过程中的）
    @objc public func setIdleImages() {
        let idleImages = (0 ... 41)
            .map{ UIImage(named: "idle_\($0)") }
            .filter{ $0 != nil }
            .map{ $0! }
        setImages(idleImages, for: .idle)
    }
    
    /// 设置刷新中状态下的图片数组（正在刷新...）
    @objc public func setRefreshingImages() {
        let refreshingImages = (42 ..< 60)
            .map{ UIImage(named: "refreshing_\($0)") }
            .filter{ $0 != nil }
            .map{ $0! }
        setImages(refreshingImages, duration: 1.2, for: .refreshing)
    }
}
