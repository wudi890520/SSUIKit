//
//  SSActionSheetDataContainer.swift
//  SSUIKit_Example
//
//  Created by 吴頔 on 2019/12/5.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class SSActionSheetDataContainer: NSObject {
    
    /// 点击事件
    let selected: Driver<Int>
    
    private let selectedBehavior = BehaviorRelay<Int?>(value: nil)
    
    /// 数据源
    var dataSource: [SSActionSheetButtonItemData] = []
    
    override init() {
        selected = selectedBehavior.asDriver().filterNil()
        super.init()
    }
}

extension SSActionSheetDataContainer {
    func setSelected(_ indexPath: IndexPath) {
        selectedBehavior.accept(indexPath.row)
    }
}
