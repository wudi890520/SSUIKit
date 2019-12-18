//
//  SSNavigationViewController+BarButtonItem.swift
//  BlocksKit
//
//  Created by 吴頔 on 2019/12/11.
//

import UIKit

/// UIBarButtonItem在导航栏中的位置
public enum SSNavigationBarButtonItemDirection {
    
    /// 在导航栏左侧
    case left
    
    /// 在导航栏中间
    case center
    
    /// 在导航栏右侧
    case right
}

/// 回头车常用的UIBarButtonItem样式
public enum SSBarButtonItem {
    
    /// 清除，即不设置item
    case `nil`
    
    /// 返回
    case back
    
    /// 关闭
    case close
    
    /// 活动
    case active
    
    /// 更多
    case more
    
    /// 麦克风
    case microphone
    
    /// 分享
    case share
    
    /// 联系客服
    /// - Parameter isNeedIcon: 是否需要带个图标
    case connectService(isNeedIcon: Bool)

    var content: Any? {
        switch self {
        case .nil: return " "
        case .back: return "back".bundleImage
        case .close: return "close".bundleImage
        case .active: return "active".bundleImage
        case .more: return "more".bundleImage
        case .microphone: return "microphone".bundleImage
        case .share: return "share".bundleImage
        case .connectService: return "联系客服"
        default: return nil
        }
    }

}

public extension UIViewController {
    
    /// 添加UIButtonItem
    /// - Parameter content: 内容（支持的数据类型有：文本、图片、UIBarButtonItem.SystemItem，SSBarButtonItem, UIBarButtonItem）
    /// - Parameter direction: 位置
    /// - Parameter animated: 是否需要动画
    /// - Parameter tintColor: 颜色
    /// - Parameter fontSize: 文本字体大小
    func addBarButtonItem(with content: Any?, at direction: SSNavigationBarButtonItemDirection? = .right, animated: Bool = false, tintColor: UIColor? = nil, fontSize: CGFloat? = nil) {

        if let base = self as? SSBaseViewController, base.barStyle.isHidden {
            let items = UIViewController.mapToButtons(content: content, tintColor: tintColor, fontSize: fontSize)
            switch direction {
            case .left?:
                base.setLeftBarButtonItems(items)
            case .right?:
                base.setRightBarButtonItems(items)
            default:
                break
            }
        }else{
            let items = UIViewController.mapToItems(content: content, tintColor: tintColor, fontSize: fontSize)
            switch direction {
            case .left?:
                navigationItem.setLeftBarButtonItems(items, animated: animated)
            case .center?:
                navigationItem.titleView = items.first?.customView
            case .right?:
                navigationItem.setRightBarButtonItems(items, animated: animated)
            case .none:
                break
            }
        }
    }
}

extension UIViewController {
    
    internal static func mapToItems(content: Any?, tintColor: UIColor? = nil, fontSize: CGFloat? = nil) -> [UIBarButtonItem] {
        if let collection = content as? [Any] {
            return collection.map{ createItem(content: $0, tintColor: tintColor, fontSize: fontSize) }
        }else{
            return [createItem(content: content, tintColor: tintColor, fontSize: fontSize)]
        }
    }
    
    internal static func createItem(content: Any?, tintColor: UIColor? = nil, fontSize: CGFloat? = nil) -> UIBarButtonItem {
        
        if let ssBarButtonItem = content as? SSBarButtonItem {
            return createItem(content: ssBarButtonItem.content, tintColor: tintColor, fontSize: fontSize)
        }
        
        var item: UIBarButtonItem = UIBarButtonItem().ss_tintColor(tintColor)
        
        if let title = content as? String {
            item.ss_title(title)
        }else if let image = content as? UIImage {
            item.ss_image(image)
        }else if let custom = content as? UIView {
            item.ss_custom(custom)
        }else if let systemItem = content as? UIBarButtonItem.SystemItem {
            item = UIBarButtonItem(barButtonSystemItem: systemItem, target: nil, action: nil)
        }else if let barButtonItem = content as? UIBarButtonItem {
            item = barButtonItem
        }

        return item
    }
    
    internal static func mapToButtons(content: Any?, tintColor: UIColor? = nil, fontSize: CGFloat? = nil) -> [UIButton] {
        if let collection = content as? [Any] {
            return collection.map{ createButton(content: $0, tintColor: tintColor, fontSize: fontSize) }
        }else{
            return [createButton(content: content, tintColor: tintColor, fontSize: fontSize)]
        }
    }
    
    internal static func createButton(content: Any?, tintColor: UIColor? = nil, fontSize: CGFloat? = nil) -> UIButton {
        
        if let ssBarButtonItem = content as? SSBarButtonItem {
            return createButton(content: ssBarButtonItem.content, tintColor: tintColor, fontSize: fontSize)
        }
        
        var item: UIButton = UIButton().ss_frame(x: 0, y: 0, width: 0, height: 44)
        let font = fontSize == nil ? UIFont.lightTitle : UIFont.with(fontSize!)
        
        if let title = content as? String {
            
            item.ss_title(title).ss_titleColor(tintColor).ss_font(font).ss_fitWidth(with: 15)
            
        }else if let image = content as? UIImage {
            
            item.width = image.size.width + 30
            if let tintColor = tintColor {
                item.ss_image(image.byTintColor(tintColor))
            }else{
                item.ss_image(image)
            }
            
        }else if let custom = content as? UIView {
            
            item.width = custom.width + 30
            item.addSubview(custom)
            custom.centerX = item.width/2
            
        }

        return item
    }
}

extension SSBaseViewController {
    fileprivate func setLeftBarButtonItems(_ items: [UIButton]) {
        leftBarButtonItems = items
        var left: CGFloat = 0
        for button in items {
            button.top = CGFloat.statusBar
            button.left = left
            left = button.right
            view.addSubview(button)
        }

        view.rx.methodInvoked(#selector(UIView.addSubview(_:)))
            .subscribe(onNext: {[weak self] (subviews) in
                self?.bringAllBarButtonItemsFront()
            })
            .disposed(by: dispose)
    }
    
    fileprivate func setRightBarButtonItems(_ items: [UIButton]) {
        rightBarButtonItems = items
        var right: CGFloat = CGFloat.screenWith
        for button in items {
            button.top = CGFloat.statusBar
            button.right = right
            right = button.left
            view.addSubview(button)
        }
        
        view.rx.methodInvoked(#selector(UIView.addSubview(_:)))
            .map{ $0.first as? [UIView] }
            .distinctUntilChanged()
            .subscribe(onNext: {[weak self] (subviews) in
                print("添加了子视图")
                self?.bringAllBarButtonItemsFront()
            })
            .disposed(by: dispose)
    }
    
    fileprivate func bringAllBarButtonItemsFront() {
        if let leftBarButtonItems = leftBarButtonItems {
            for item in leftBarButtonItems {
                view.bringSubviewToFront(item)
            }
        }
        
        if let rightBarButtonItems = rightBarButtonItems {
            for item in rightBarButtonItems {
                view.bringSubviewToFront(item)
            }
        }
    }
}

extension SSBaseViewController {
    
    /// 设置左上角的BarButtonItem
    func setBackOrCloseBarButtonItem() {
        
        if let _ = navigationItem.leftBarButtonItems {
            return
        }
        
        var item: Any?
        if qmui_isPresented() {
            if indexOfNavigationControllers == 0 {
                item = SSBarButtonItem.close
            }else{
                item = SSBarButtonItem.back
            }
        }else{
            if indexOfNavigationControllers == 0 {
                item = nil
            }else{
                item = SSBarButtonItem.back
            }
        }
        
        addBarButtonItem(with: item, at: .left)
        leftItemDidTap?.asDriver().drive(rx.pop).disposed(by: dispose)
    }

}
