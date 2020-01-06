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

class SSAlertPresentProvider: NSObject {
    static let shared = SSAlertPresentProvider()
    
    /// 当前的Alert控制器
    internal var currentAlertController: UIViewController?
    
    /// Alert当前是否可见
    public var isVisiable: Bool {
        if let _ = currentAlertController {
            return true
        }else{
            return false
        }
    }
    
    private override init() {
        super.init()
    }
}

public class SSAlertProvider: NSObject {
    internal static let JCPresentControllersAllDismissedNotification = Notification.Name.init("JCPresentControllersAllDismissedNotification")
    
    public static var rx: SSRxAlertProvider.Type { SSRxAlertProvider.self }
    
    public static var isVisiable: Bool {
        return SSAlertPresentProvider.shared.isVisiable
    }
}

extension SSAlertProvider {
    fileprivate static func creatContentAttributeView(_ attributeString: NSAttributedString?) -> UIView? {
        guard let attributeString = attributeString else { return nil }
        let contentWidth = CGFloat.screenWidth - 80
        let contentLabel = UILabel()
            .ss_numberOfLines()
            .ss_frame(x: 20, y: 5, width: contentWidth, height: attributeString.size(withMaxWidth: contentWidth).height)
        contentLabel.attributedText = attributeString
        let contentView = UIView()
            .ss_backgroundColor(.white)
            .ss_frame(x: 0, y: 0, width: SSAlertConfiguration.shared.displayView.width, height: contentLabel.height+25)
        contentView.addSubview(contentLabel)
        return contentView
    }
}

public extension SSAlertProvider {
    /// 弹出对话框（只有一个按钮）
    /// - Parameter title: 标题
    /// - Parameter message: 内容
    /// - Parameter messageAligment: 内容对齐方式
    /// - Parameter confirmButtonTitle: 按钮标题
    /// - Parameter dismissCompletion: 点击按钮之后的回调
    public static func showAlert(
        _ title: String?,
        _ message: String? = nil,
        _ messageAligment: NSTextAlignment = .center,
        _ confirmButtonTitle: String = "我知道了",
        _ dismissCompletion: (() -> Void)? = nil) {
        
        SSAlertConfiguration.shared.reloadStyle()
        SSAlertConfiguration.Title.textAlignment = .center
        SSAlertConfiguration.Content.textAlignment = messageAligment
        
        guard let alert = JCAlertController.alert(withTitle: title, message: message) else { return }
        alert.addButton(withTitle: confirmButtonTitle, type: .init(rawValue: 0), clicked: nil)
        SSAlertProvider.presentViewController(alert)
    }
    
    /// 弹出对话框（有确定和取消2个按钮）
    /// - Parameter title: 标题
    /// - Parameter message: 内容
    /// - Parameter messageAligment: 内容对齐方式
    /// - Parameter cancelButtonTitle: 取消按钮标题
    /// - Parameter confirmButtonTitle: 确定按钮标题
    /// - Parameter handleCompletion: 点击按钮之后的回调（true = 确定， false = 取消）
    public static func showConfirm(
        title: String?,
        message: String? = nil,
        messageAligment: NSTextAlignment = .center,
        cancelButtonTitle: String = "取消",
        confirmButtonTitle: String = "确定",
        handleCompletion: ((Bool) -> Void)? = nil) {
        
        SSAlertConfiguration.shared.reloadStyle()
        SSAlertConfiguration.Title.textAlignment = .center
        SSAlertConfiguration.Content.textAlignment = messageAligment
        
        guard let alert = JCAlertController.alert(withTitle: title, message: message) else { return }
        alert.addButton(withTitle: cancelButtonTitle, type: .cancel) {
            handleCompletion?(false)
        }
        alert.addButton(withTitle: confirmButtonTitle, type: .init(rawValue: 0)) {
            handleCompletion?(true)
        }
        SSAlertProvider.presentViewController(alert)
    }
    
    /// 弹出带有富文本内容的对话框（有确定和取消2个按钮）
    /// - Parameter title: 标题
    /// - Parameter message: 内容（富文本）
    /// - Parameter cancelButtonTitle: 取消按钮标题
    /// - Parameter confirmButtonTitle: 确定按钮标题
    /// - Parameter handleCompletion: 点击按钮之后的回调（true = 确定， false = 取消）
    public static func showAttributeConfirm(
        title: String?,
        message: NSMutableAttributedString? = nil,
        cancelButtonTitle: String = "取消",
        confirmButtonTitle: String = "确定",
        handleCompletion: ((Bool) -> Void)? = nil) {
        
        SSAlertConfiguration.shared.reloadStyle()
        SSAlertConfiguration.Title.textAlignment = .center
        
        guard let contentView = creatContentAttributeView(message) else { return }
        guard let alert = JCAlertController.alert(withTitle: title, contentView: contentView) else { return }
        alert.addButton(withTitle: cancelButtonTitle, type: .cancel) {
            handleCompletion?(false)
        }
        alert.addButton(withTitle: confirmButtonTitle, type: .init(rawValue: 0)) {
            handleCompletion?(true)
        }
        SSAlertProvider.presentViewController(alert)
    }
    
    /// 弹出带有自定义元素的对话框
    /// - Parameter elements: SSAlertDisplayElement数组
    public static func showElements(_ elements: [SSAlertDisplayElement], autoDismiss: Bool = true) {
        SSAlertConfiguration.shared.reloadStyle()
        if let url = elements.imageURL {
            ImageDownloader.default.downloadImage(with: url, options: KingfisherManager.shared.defaultOptions) { (result) in
                switch result {
                case let .success(imageResult):
                    let image = imageResult.image
                    let newElements = elements.replaceImageElement(image)
                    let customView = SSAlertCustomView(elements: newElements)
                    guard let alert = JCAlertController.alert(withTitle: nil, contentView: customView) else { return }
                    customView.shouldDismiss = { _ in
                        if autoDismiss {
                            alert.dismiss(animated: true, completion: nil)
                        }
                    }
                    SSAlertProvider.presentViewController(alert)
                case let .failure(error):
                    return
                }
            }
        }else{
            let customView = SSAlertCustomView(elements: elements)
            guard let alert = JCAlertController.alert(withTitle: nil, contentView: customView) else { return }
            customView.shouldDismiss = { _ in
                if autoDismiss {
                    alert.dismiss(animated: true, completion: nil)
                }
            }
            SSAlertProvider.presentViewController(alert)
     
        }

    }
}

public class SSRxAlertProvider: NSObject {
    /// 弹出对话框（只有一个按钮）
    /// - Parameter title: 标题
    /// - Parameter message: 内容
    /// - Parameter messageAligment: 内容对齐方式
    /// - Parameter confirmButtonTitle: 按钮标题
    public static func showAlert(
        _ title: String?,
        _ message: String? = nil,
        _ messageAligment: NSTextAlignment = .center,
        _ confirmButtonTitle: String = "我知道了") -> Driver<Void> {
        return Observable.create({ (observer) -> Disposable in
            
            SSAlertConfiguration.shared.reloadStyle()
            SSAlertConfiguration.Title.textAlignment = .center
            SSAlertConfiguration.Content.textAlignment = messageAligment
            
            if let alert = JCAlertController.alert(withTitle: title, message: message) {
                alert.addButton(withTitle: confirmButtonTitle, type: JCButtonType.init(rawValue: 0)) {
                    observer.onNext(())
                    observer.onCompleted()
                }
                SSAlertProvider.presentViewController(alert)
            }
            return Disposables.create()
        }).asDriver(onErrorJustReturn: ())
    }
    
    /// 弹出对话框（有确定和取消2个按钮）
    /// - Parameter title: 标题
    /// - Parameter message: 内容
    /// - Parameter messageAligment: 内容对齐方式
    /// - Parameter cancelButtonTitle: 取消按钮标题
    /// - Parameter confirmButtonTitle: 确定按钮标题
    public static func showConfirm(
        title: String?,
        message: String? = nil,
        messageAligment: NSTextAlignment = .center,
        cancelButtonTitle: String = "取消",
        confirmButtonTitle: String = "确定") -> Driver<Bool> {
        
        return Observable.create({ (observer) -> Disposable in
            
            SSAlertConfiguration.shared.reloadStyle()
            SSAlertConfiguration.Title.textAlignment = .center
            SSAlertConfiguration.Content.textAlignment = messageAligment
            
            if let alert = JCAlertController.alert(withTitle: title, message: message) {
                alert.addButton(withTitle: cancelButtonTitle, type: .cancel) {
                    observer.onNext(false)
                    observer.onCompleted()
                }
                alert.addButton(withTitle: confirmButtonTitle, type: .init(rawValue: 0)) {
                    observer.onNext(true)
                    observer.onCompleted()
                }
                SSAlertProvider.presentViewController(alert)
            }
            return Disposables.create()
        }).asDriver(onErrorJustReturn: false)
 
    }
    
    /// 弹出带有富文本内容的对话框（有确定和取消2个按钮）
    /// - Parameter title: 标题
    /// - Parameter message: 内容（富文本）
    /// - Parameter cancelButtonTitle: 取消按钮标题
    /// - Parameter confirmButtonTitle: 确定按钮标题
    public static func showAttributeConfirm(
        title: String?,
        message: NSMutableAttributedString? = nil,
        cancelButtonTitle: String = "取消",
        confirmButtonTitle: String = "确定") -> Driver<Bool> {
        
        return Observable.create({ (observer) -> Disposable in
            
            SSAlertConfiguration.shared.reloadStyle()
            SSAlertConfiguration.Title.textAlignment = .center
            
            guard let contentView = SSAlertProvider.creatContentAttributeView(message) else {
                observer.onNext(false)
                observer.onCompleted()
                return Disposables.create()
            }
            guard let alert = JCAlertController.alert(withTitle: title, contentView: contentView) else {
                observer.onNext(false)
                observer.onCompleted()
                return Disposables.create()
            }
            
            alert.addButton(withTitle: cancelButtonTitle, type: .cancel) {
                observer.onNext(false)
                observer.onCompleted()
            }
            alert.addButton(withTitle: confirmButtonTitle, type: .init(rawValue: 0)) {
                observer.onNext(true)
                observer.onCompleted()
            }
            
            SSAlertProvider.presentViewController(alert)
            return Disposables.create()
        }).asDriver(onErrorJustReturn: false)

    }
}

extension SSRxAlertProvider {
    public static func showAlert<T>(
        _ extra: T?,
        _ title: String?,
        _ message: String? = nil,
        _ messageAligment: NSTextAlignment = .center,
        _ confirmButtonTitle: String = "我知道了") -> Driver<T?> {
        return Observable.create({ (observer) -> Disposable in
            
            SSAlertConfiguration.shared.reloadStyle()
            SSAlertConfiguration.Title.textAlignment = .center
            SSAlertConfiguration.Content.textAlignment = messageAligment
            
            if let alert = JCAlertController.alert(withTitle: title, message: message) {
                alert.addButton(withTitle: confirmButtonTitle, type: JCButtonType.init(rawValue: 0)) {
                    observer.onNext(extra)
                    observer.onCompleted()
                }
                SSAlertProvider.presentViewController(alert)
            }
            return Disposables.create()
        }).asDriver(onErrorJustReturn: extra)
    }
    
    /// 弹出对话框（有确定和取消2个按钮）
    /// - Parameter title: 标题
    /// - Parameter message: 内容
    /// - Parameter messageAligment: 内容对齐方式
    /// - Parameter cancelButtonTitle: 取消按钮标题
    /// - Parameter confirmButtonTitle: 确定按钮标题
    /// - Parameter handleCompletion: 点击按钮之后的回调（true = 确定， false = 取消）
    public static func showConfirm<T>(
        extra: T?,
        title: String?,
        message: String? = nil,
        messageAligment: NSTextAlignment = .center,
        cancelButtonTitle: String = "取消",
        confirmButtonTitle: String = "确定") -> Driver<T?> {
        
        return Observable.create({ (observer) -> Disposable in
            
            SSAlertConfiguration.shared.reloadStyle()
            SSAlertConfiguration.Title.textAlignment = .center
            SSAlertConfiguration.Content.textAlignment = messageAligment
            
            if let alert = JCAlertController.alert(withTitle: title, message: message) {
                alert.addButton(withTitle: cancelButtonTitle, type: .cancel) {
                    observer.onNext(nil)
                    observer.onCompleted()
                }
                alert.addButton(withTitle: confirmButtonTitle, type: .init(rawValue: 0)) {
                    observer.onNext(extra)
                    observer.onCompleted()
                }
                SSAlertProvider.presentViewController(alert)
            }
            return Disposables.create()
        }).asDriver(onErrorJustReturn: nil)
 
    }
    
    /// 弹出带有富文本内容的对话框（有确定和取消2个按钮）
    /// - Parameter title: 标题
    /// - Parameter message: 内容（富文本）
    /// - Parameter cancelButtonTitle: 取消按钮标题
    /// - Parameter confirmButtonTitle: 确定按钮标题
    /// - Parameter handleCompletion: 点击按钮之后的回调（true = 确定， false = 取消）
    public static func showAttributeConfirm<T>(
        extra: T?,
        title: String?,
        message: NSMutableAttributedString? = nil,
        cancelButtonTitle: String = "取消",
        confirmButtonTitle: String = "确定") -> Driver<T?> {
        
        return Observable.create({ (observer) -> Disposable in
            
            SSAlertConfiguration.shared.reloadStyle()
            SSAlertConfiguration.Title.textAlignment = .center
            
            guard let contentView = SSAlertProvider.creatContentAttributeView(message) else {
                observer.onNext(nil)
                observer.onCompleted()
                return Disposables.create()
            }
            guard let alert = JCAlertController.alert(withTitle: title, contentView: contentView) else {
                observer.onNext(nil)
                observer.onCompleted()
                return Disposables.create()
            }
            
            alert.addButton(withTitle: cancelButtonTitle, type: .cancel) {
                observer.onNext(nil)
                observer.onCompleted()
            }
            alert.addButton(withTitle: confirmButtonTitle, type: .init(rawValue: 0)) {
                observer.onNext(extra)
                observer.onCompleted()
            }
            
            SSAlertProvider.presentViewController(alert)
            return Disposables.create()
        }).asDriver(onErrorJustReturn: nil)

    }
}

public extension SSAlertProvider {
    
    internal static func presentViewController(_ alertController: UIViewController) {
        JCPresentController.setOverlayWindowLevel(.alert)
        JCPresentController.presentViewControllerFIFO(alertController, presentCompletion: {
            SSAlertPresentProvider.shared.currentAlertController = alertController
        }) {
            SSAlertPresentProvider.shared.currentAlertController = nil
        }
    }
    
    /// 让alert消失
    public static func dismiss() {
        if let alertController = SSAlertPresentProvider.shared.currentAlertController {
            alertController.dismiss(animated: true, completion: nil)
        }else{
            JCPresentControllersAllDismissedNotification.post()
        }
    }
}
