//
//  SSBannerImageItem.swift
//  DeviceKit
//
//  Created by 吴頔 on 2019/12/9.
//

import UIKit

public struct SSBannerImageItem {
    
    /// 可传入string， URL， UIImage
    let source: Any?
    
    /// http...
    let page: String?
    
    init(source: Any, page: String?) {
        self.source = source
        self.page = page
    }
}
