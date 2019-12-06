//
//  ImpactFeedback.swift
//  DeviceKit
//
//  Created by 吴頔 on 2019/12/2.
//

import UIKit

@available(iOS 10.0, *)
public extension UIImpactFeedbackGenerator {
    
    /// 振动反馈
    static func ss_impactOccurred() {
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.prepare()
        generator.impactOccurred()
    }
}

