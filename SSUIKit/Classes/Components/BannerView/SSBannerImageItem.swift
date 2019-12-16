//
//  SSBannerImageItem.swift
//  DeviceKit
//
//  Created by 吴頔 on 2019/12/9.
//

import UIKit

public struct SSBannerImageItem {
    
    /// 可传入string， URL， UIImage
    public let source: Any?
    
    /// http...
    public let page: String?
    
    /// 初始化方法
    /// - Parameter source: 图片资源
    /// - Parameter page: H5链接地址
    public init(source: Any?, page: String?) {
        self.source = source
        self.page = page
    }
}
