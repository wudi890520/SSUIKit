//
//  SSToast.swift
//  DeviceKit
//
//  Created by 吴頔 on 2019/12/9.
//

import UIKit
import Toast_Swift
import RxCocoa
import RxSwift

public class SSToast: NSObject {

    static let shared = SSToast()
    
    fileprivate var lastView: UIView?
    
    private override init() {
        super.init()
        SSToast.setStyle()
    }
}

extension SSToast {
    static func setStyle() {
        var toastStyle = ToastStyle()
        toastStyle.backgroundColor = UIColor.black.withAlphaComponent(0.8)
        toastStyle.horizontalPadding = 16
        toastStyle.verticalPadding = 16
        toastStyle.cornerRadius = 8
        toastStyle.titleFont = UIFont.boldSystemFont(ofSize: 16)
        toastStyle.messageFont = UIFont.boldSystemFont(ofSize: 16)
        toastStyle.imageSize = CGSize(width: 16, height: 16)
        ToastManager.shared.style = toastStyle
        ToastManager.shared.duration = 2
        ToastManager.shared.position = .center
    }
}

public extension SSToast {
    static func show(_ message: String?, at position: ToastPosition = .center) {
        SSToast.setStyle()
        hide()
        SSToast.shared.lastView = UIApplication.rootView
        if let delegate = UIApplication.shared.delegate, let window = delegate.window {
            window?.makeToast(message, duration: 2, position: position)
        }else{
            UIApplication.visiableController?.view?.makeToast(message, duration: 2, position: position)
        }
    }
    
    static func hide() {
        SSToast.shared.lastView?.hideAllToasts()
        UIApplication.rootViewController?.view.hideAllToasts()
        UIApplication.visiableController?.view.hideAllToasts()
        UIApplication.visiableController?.navigationController?.view?.hideToast()
        if let delegate = UIApplication.shared.delegate, let window = delegate.window {
            window?.hideToast()
        }
    }
}

public extension UIView {
    func showToast(_ message: String?, at position: ToastPosition = .center) {
        SSToast.setStyle()
        SSToast.hide()
        SSToast.shared.lastView = self
        self.makeToast(message, duration: 2, position: position)
    }
}

public extension Reactive where Base: SSToast {
    var show: Binder<String?> {
        return Binder(base) { _, message in
            SSToast.show(message)
        }
    }
}

public extension Reactive where Base: UIView {
    var showToast: Binder<String?> {
        return Binder(base) { view, message in
            view.showToast(message)
        }
    }
}

public extension Reactive where Base: UIViewController {
    var showToast: Binder<String?> {
        return Binder(base) { _, message in
            SSToast.show(message)
        }
    }
}
