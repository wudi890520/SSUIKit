//
//  SSActionSheetConfiguration.swift
//  DeviceKit
//
//  Created by 吴頔 on 2019/12/5.
//

import UIKit

public class SSActionSheetConfiguration: NSObject {

    static let shared = SSActionSheetConfiguration()
    
    /// 行高
    internal var rowHeight: CGFloat = 56
    
    /// 按钮标题字体大小
    internal var buttonItemFont: UIFont = .title
    
    /// actionSheet 标题字体大小
    internal var titleLabelFont: UIFont = .lightDetail
    
    private override init() {
        super.init()
    }
}
 
public extension SSActionSheetConfiguration {
    
    static var rowHeight: CGFloat = 56 {
        didSet { SSActionSheetConfiguration.shared.rowHeight = rowHeight }
    }
    
    static var buttonItemFont: UIFont = .title {
        didSet { SSActionSheetConfiguration.shared.buttonItemFont = buttonItemFont }
    }
    
    static var titleLabelFont: UIFont = .lightDetail {
        didSet { SSActionSheetConfiguration.shared.buttonItemFont = titleLabelFont }
    }
}
