//
//  SSBaseViewController.swift
//  BlocksKit
//
//  Created by 吴頔 on 2019/12/11.
//

import UIKit
import QMUIKit
import RxCocoa
import RxSwift

open class SSBaseViewController: QMUICommonViewController {
  
    /// 导航栏样式
    public var barStyle: SSNavigationBarStyle = .white

    /// 是否允许滑动返回
    public var popGestureEnable: Bool = true
    
    /// 导航栏位置左侧的items（仅当barStyle == .hidden的时候生效）
    internal var leftBarButtonItems: [UIButton]?
    
    /// 导航栏位置右侧的items（仅当barStyle == .hidden的时候生效）
    internal var rightBarButtonItems: [UIButton]?
 
    public var parameters: [AnyHashable: Any]?
    
    /// 信号回收
    public var dispose = DisposeBag()

    open override func viewDidLoad() {
        /// 初始化一些东西
        ss_initSomeObjects()
        
        super.viewDidLoad()
        
        view.backgroundColor = .ss_background
        
        defer {
            /// 绑定信号
            ss_bindDataSource()
        }
        
        /// 设置导航栏
        ss_setNavigation()
        setBackOrCloseBarButtonItem()
        
        /// 对UI进行布局
        ss_layoutSubviews()
    }
    
    deinit {
        /// 移除对话框
        SSAlert.dismiss()
        /// 移除菊花
        SVProgressHUD.dismiss()
        /// 移除监听
        bk_removeAllBlockObservers()
        /// 移除通知
        NotificationCenter.default.removeObserverBlocks()
        /// 移除信号
        dispose = DisposeBag()
        print("\(className()) deinit")
    }
}

extension SSBaseViewController {
    public static func create(_ className: String, prefix: String, parameters: [AnyHashable: Any]? = nil) -> SSBaseViewController {
        if let `class` = NSClassFromString("\(prefix).\(className)") as? SSBaseViewController.Type,
            let cls = `class`.init() as? SSBaseViewController {
            cls.parameters = parameters
            return cls
        }else{
            assert(false, "\(className)不是SSBaseViewController类型")
            return SSBaseViewController()
        }
    }
}
