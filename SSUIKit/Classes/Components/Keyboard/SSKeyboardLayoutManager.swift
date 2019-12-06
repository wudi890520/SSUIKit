//
//  KeyboardLayoutManager.swift
//  SSUIKit_Example
//
//  Created by 吴頔 on 2019/12/4.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import UIKit
import SnapKit

class SSKeyboardLayoutManager: NSObject, SSLayoutType {
   
    typealias V = SSKeyboardViewContainer
    
    var superView: UIView?
    
    var children: SSKeyboardViewContainer?
    
}

extension SSKeyboardLayoutManager {
    func make(children views: SSKeyboardViewContainer, in view: UIView) {
        superView = view
        children = views
        addChildren()
        layoutChildren()
    }
}

extension SSKeyboardLayoutManager {
    
    func addChildren() {
        
        guard let superView = superView else { return }
        guard let children = children else { return }
        
        /// 嵌套函数，添加键盘的各种按钮
        ///
        /// - Parameter view: UIView
        func add(_ view: UIView) { children.keyboardBackgroundView.addSubview(view) }
        
        defer {
            /// 添加水平分隔线和垂直分隔线，线始终在最上面，所以最后添加
            (children.horizontalLines + children.verticalLineLines).forEach{ add($0) }
        }
        /// 父视图添加键盘背景视图
        superView.addSubview(children.keyboardBackgroundView)
        /// 添加数字（0-9）
        children.numbers.forEach{ add($0) }
        /// 添加删除按钮
        add(children.deleteBtn)
        
        /// 添加左下角按钮
        guard let customBtn = children.customBtn else { return }
        add(customBtn)
    }
    
    func layoutChildren() {
        guard let _ = superView else { return }
        guard let children = children else { return }
        
        children.keyboardBackgroundView.snp.makeConstraints { (make) in
            make.left.top.equalTo(0)
            make.size.equalTo(CGFloat.screenWith)
            make.height.equalTo(V.Content.height + CGFloat.unsafeBottom)
        }
    
        let btnsExceptZero = children.numbers.filter{ $0.tag != 0 }
        let btnsOnlyZero = children.numbers.filter{ $0.tag == 0 }
        let custom: [UIButton] = children.customBtn == nil ? [] : [children.customBtn!]
        let delete = [children.deleteBtn]
        var index: [Int] = (0 ..< 12).compactMap{ $0 }
        if custom.isEmpty { index.remove(at: 9) }

        let allButton = btnsExceptZero + custom + btnsOnlyZero + delete

        zip(allButton, index)
            .forEach { (button, index) in
                button.snp.makeConstraints({ (make) in
                    let left = (index % V.Style.colume).ss_cgFloat * V.Item.size.width
                    let top = (index / V.Style.colume).ss_cgFloat * V.Item.height
                    make.left.equalTo(left)
                    make.top.equalTo(top)
                    make.size.equalTo(V.Item.size)
                })
        }
        
        children.horizontalLines.forEach { (line) in
            line.snp.makeConstraints({ (make) in
                let top = line.tag.ss_cgFloat * V.Item.height
                make.left.equalTo(0)
                make.width.equalTo(CGFloat.screenWith)
                make.height.equalTo(CGFloat.line)
                make.top.equalTo(top)
            })
        }
        
        children.verticalLineLines.forEach { (line) in
            line.snp.makeConstraints({ (make) in
                let left = (line.tag + 1).ss_cgFloat * V.Item.size.width
                make.left.equalTo(left)
                make.top.equalTo(0)
                make.height.equalTo(V.Content.height)
                make.width.equalTo(CGFloat.line)
            })
        }
    }
}

