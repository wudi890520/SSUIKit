//
//  SSAlertProvider.swift
//  DeviceKit
//
//  Created by 吴頔 on 2019/12/6.
//

import UIKit
import JCAlertController
import Kingfisher
import RxCocoa
import RxSwift

public typealias SSAlert = SSAlertProvider

public class SSAlertProvider: NSObject {
    static let JCPresentControllersAllDismissedNotification = Notification.Name.init("JCPresentControllersAllDismissedNotification")
}

public extension SSAlertProvider {
  
    static func present(_ title: String, _ confirmButtonTitle: String = "我知道了", _ dismissCompletion: (() -> Void)? = nil) {
        SSAlertConfiguration.Title.textAlignment = .center
        SSAlertConfiguration.shared.reloadStyle()
        guard let alert = JCAlertController.alert(withTitle: title, message: nil) else { return }
        JCPresentController.setOverlayWindowLevel(.alert)
        JCPresentController.presentViewControllerFIFO(alert, presentCompletion: nil, dismissCompletion: dismissCompletion)
        alert.addButton(withTitle: confirmButtonTitle, type: .init(rawValue: 0), clicked: nil)
    }
    
    static func present(
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
    
    static func present(_ elements: [SSAlertDisplayElement], handleCompletion: ((Bool) -> Void)? = nil) {
        SSAlertConfiguration.shared.reloadStyle()
        if let url = elements.imageURL {
            ImageDownloader.default.downloadImage(with: url, options: KingfisherManager.shared.defaultOptions) { (result) in
                switch result {
                case let .success(imageResult):
                    let image = imageResult.image
                    let newElements = elements.replaceImageElement(image)
                    let customView = SSAlertCustomView(elements: newElements)
                    guard let alert = JCAlertController.alert(withTitle: nil, contentView: customView) else { return }
                    JCPresentController.setOverlayWindowLevel(.alert)
                    JCPresentController.presentViewControllerFIFO(alert, presentCompletion: nil, dismissCompletion: nil)
                    customView.shouldDismiss = { _ in
                        alert.dismiss(animated: true, completion: nil)
                    }
                case let .failure(error):
                    return
                }
            }
        }else{
            let customView = SSAlertCustomView(elements: elements)
            guard let alert = JCAlertController.alert(withTitle: nil, contentView: customView) else { return }
            JCPresentController.setOverlayWindowLevel(.alert)
            JCPresentController.presentViewControllerFIFO(alert, presentCompletion: nil, dismissCompletion: nil)
            customView.shouldDismiss = { _ in
                alert.dismiss(animated: true, completion: nil)
            }
        }

    }
}

public extension SSAlertProvider {
    static func show(_ title: String, confirmButtonTitle: String = "我知道了") -> Driver<Void> {
        return Observable.create({ (observer) -> Disposable in
            SSAlertConfiguration.Title.textAlignment = .center
            SSAlertConfiguration.shared.reloadStyle()
            if let alert = JCAlertController.alert(withTitle: title, message: nil) {
                JCPresentController.setOverlayWindowLevel(.alert)
                JCPresentController.presentViewControllerFIFO(alert, presentCompletion: nil, dismissCompletion: nil)
                alert.addButton(withTitle: confirmButtonTitle, type: JCButtonType.init(rawValue: 0)) {
                    observer.onNext(())
                    observer.onCompleted()
                }
            }
            return Disposables.create()
        }).asDriver(onErrorJustReturn: ())
    }
    
    static func show(
        title: String? = nil,
        message: String? = nil,
        cancelButtonTitle: String = "取消",
        confirmButtonTitle: String = "确定") -> Driver<Bool> {
        return Observable.create({ (observer) -> Disposable in
            SSAlertConfiguration.Title.textAlignment = .center
            SSAlertConfiguration.shared.reloadStyle()
            if let alert = JCAlertController.alert(withTitle: title, message: message) {
                JCPresentController.setOverlayWindowLevel(.alert)
                JCPresentController.presentViewControllerFIFO(alert, presentCompletion: nil, dismissCompletion: nil)
                alert.addButton(withTitle: cancelButtonTitle, type: JCButtonType.init(rawValue: 0)) {
                    observer.onNext(false)
                    observer.onCompleted()
                }
                alert.addButton(withTitle: confirmButtonTitle, type: .init(rawValue: 0)) {
                    observer.onNext(true)
                    observer.onCompleted()
                }
            }
            return Disposables.create()
        }).asDriver(onErrorJustReturn: false)
    }
    
    static func show<T>(
        extra: T?,
        title: String? = nil,
        message: String? = nil,
        cancelButtonTitle: String = "取消",
        confirmButtonTitle: String = "确定") -> Driver<T?> {
        return Observable.create({ (observer) -> Disposable in
            SSAlertConfiguration.Title.textAlignment = .center
            SSAlertConfiguration.shared.reloadStyle()
            if let alert = JCAlertController.alert(withTitle: title, message: message) {
                JCPresentController.setOverlayWindowLevel(.alert)
                JCPresentController.presentViewControllerFIFO(alert, presentCompletion: nil, dismissCompletion: nil)
                alert.addButton(withTitle: cancelButtonTitle, type: JCButtonType.init(rawValue: 0)) {
                    observer.onNext(nil)
                    observer.onCompleted()
                }
                alert.addButton(withTitle: confirmButtonTitle, type: .init(rawValue: 0)) {
                    observer.onNext(extra)
                    observer.onCompleted()
                }
            }
            return Disposables.create()
        }).asDriver(onErrorJustReturn: nil)
    }
}

extension SSAlertProvider {
    static func dismiss() {
        JCPresentControllersAllDismissedNotification.post()
    }
}
