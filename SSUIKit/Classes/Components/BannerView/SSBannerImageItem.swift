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
    
    public init(source: Any, page: String?) {
        self.source = source
        self.page = page
    }
}
