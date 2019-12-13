//
//  SSHUD.swift
//  SSUIKit
//
//  Created by 吴頔 on 2019/11/30.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

fileprivate var hudImage: UIImage {
    return "HUDImage".bundleImage!
}

public class SSHUD: NSObject {
    
    static let shared = SSHUD()
    
    private override init() {
        super.init()
        SSToast.setStyle()
    }
}

extension SSHUD {
    static func setStyle() {
        SVProgressHUD.setDefaultStyle(.dark)
        SVProgressHUD.setBackgroundColor(UIColor.ss.black.ss_alpha(0.3))
        SVProgressHUD.setForegroundColor(.white)
        SVProgressHUD.setCornerRadius(8)
        SVProgressHUD.setFont(UIFont.systemFont(ofSize: 16))
        SVProgressHUD.setMinimumDismissTimeInterval(TimeInterval.infinity)
        SVProgressHUD.setMinimumSize(CGSize(width: 120, height: 120))
        SVProgressHUD.setInfoImage(hudImage)
        SVProgressHUD.setImageViewSize(CGSize(width: 50, height: 50))
        SVProgressHUD.setDefaultAnimationType(.native)
        SVProgressHUD.setShouldTintImages(false)
        
        guard
            let shared = SVProgressHUD.sharedView(),
            let hudView = shared.value(forKey: "hudView") as? UIVisualEffectView
        else { return }
        hudView.contentView.ss_backgroundColor(UIColor.black.withAlphaComponent(0.3))
    }
}

public extension SSHUD {
    static func show(for status: SSHUDStatus = .loading) {
        SSHUD.setStyle()
        SVProgressHUD.setDefaultMaskType(status.mask)
        SVProgressHUD.show(hudImage, status: status.status)
    }
    
    @objc static func dismiss() {
        SVProgressHUD.dismiss()
    }
}

public extension Driver {
    func showHUD(for status: SSHUDStatus = .loading) -> Driver<Element> {
        return self.do(onNext: { (_) in
            SSToast.hide()
            SSHUD.setStyle()
            SVProgressHUD.setDefaultMaskType(status.mask)
            SVProgressHUD.show(hudImage, status: status.status)
        }) as! SharedSequence<DriverSharingStrategy, Element>
    }
    
    func dismissHUD() -> Driver<Element> {
        return self.do(onNext: { (_) in
            SVProgressHUD.dismiss()
        }) as! SharedSequence<DriverSharingStrategy, Element>
    }
}

public extension Reactive where Base: UIViewController {
    func showHUD(for status: SSHUDStatus = .loading) -> Binder<Bool> {
        return Binder(base) { controller, isLoading -> Void in
            if isLoading {
                SSToast.hide()
                SSHUD.setStyle()
                controller.view.hideAllToasts()
                controller.navigationController?.view.hideAllToasts()
                SVProgressHUD.setDefaultMaskType(status.mask)
                SVProgressHUD.show(hudImage, status: status.status)
            }else{
                SVProgressHUD.dismiss()
            }
        }
    }
}
