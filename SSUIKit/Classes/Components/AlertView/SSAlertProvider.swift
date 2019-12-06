//
//  SSAlertProvider.swift
//  DeviceKit
//
//  Created by 吴頔 on 2019/12/6.
//

import UIKit
import JCAlertController

public typealias SSAlert = SSAlertProvider

public class SSAlertProvider: NSObject {}

public extension SSAlertProvider {
    
    static func show(_ title: String, _ dismissCompletion: (() -> Void)? = nil) {
        SSAlertConfiguration.Title.textAlignment = .center
        SSAlertConfiguration.shared.reloadStyle()
        guard let alert = JCAlertController.alert(withTitle: title, message: nil) else { return }
        JCPresentController.setOverlayWindowLevel(.alert)
        JCPresentController.presentViewControllerFIFO(alert, presentCompletion: nil, dismissCompletion: dismissCompletion)
        alert.addButton(withTitle: "我知道了", type: JCButtonType.init(rawValue: 0), clicked: nil)
    }
    
    static func show(_ title: String, _ confirmButtonTitle: String, _ dismissCompletion: (() -> Void)? = nil) {
        SSAlertConfiguration.Title.textAlignment = .center
        SSAlertConfiguration.shared.reloadStyle()
        guard let alert = JCAlertController.alert(withTitle: title, message: nil) else { return }
        JCPresentController.setOverlayWindowLevel(.alert)
        JCPresentController.presentViewControllerFIFO(alert, presentCompletion: nil, dismissCompletion: dismissCompletion)
        alert.addButton(withTitle: confirmButtonTitle, type: .init(rawValue: 0), clicked: nil)
    }
    
    static func show(
        _ title: String? = nil,
        message: String? = nil,
        cancelButtonTitle: String = "取消",
        confirmButtonTitle: String,
        handleCompletion: ((Bool) -> Void)? = nil) {
        SSAlertConfiguration.Title.textAlignment = .center
        SSAlertConfiguration.shared.reloadStyle()
        guard let alert = JCAlertController.alert(withTitle: title, message: message) else { return }
        JCPresentController.setOverlayWindowLevel(.alert)
        JCPresentController.presentViewControllerFIFO(alert, presentCompletion: nil, dismissCompletion: nil)
        alert.addButton(withTitle: cancelButtonTitle, type: .cancel) {
            handleCompletion?(false)
        }
        alert.addButton(withTitle: confirmButtonTitle, type: .init(rawValue: 0)) {
            handleCompletion?(true)
        }
    }
    
    static func show(_ elements: [SSAlertDisplayElement], handleCompletion: ((Bool) -> Void)? = nil) {
        SSAlertConfiguration.shared.reloadStyle()
        let customView = SSAlertCustomView(elements: elements)
        guard let alert = JCAlertController.alert(withTitle: nil, contentView: customView) else { return }
        JCPresentController.setOverlayWindowLevel(.alert)
        JCPresentController.presentViewControllerFIFO(alert, presentCompletion: nil, dismissCompletion: nil)
        
        customView.shouldDismiss = { _ in
            alert.dismiss(animated: true, completion: nil)
        }
    }
}
