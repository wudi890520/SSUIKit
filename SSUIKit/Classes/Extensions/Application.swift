//
//  Application.swift
//  DeviceKit
//
//  Created by 吴頔 on 2019/12/10.
//

import UIKit

public extension UIApplication {
    static var rootViewController: UIViewController? {
        return UIApplication.shared.keyWindow?.rootViewController
    }
    
    static var rootView: UIView? {
        return rootViewController?.view
    }
}

public extension UIApplication {
    static func open(_ url: URL? = URL(string: UIApplication.openSettingsURLString)) {
        if let url = url, UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    
    @objc static func endEditing() {
        rootView?.endEditing(true)
    }
}
