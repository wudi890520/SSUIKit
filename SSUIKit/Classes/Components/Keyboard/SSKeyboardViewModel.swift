//
//  KeyboardViewModel.swift
//  SSUIKit_Example
//
//  Created by 吴頔 on 2019/12/4.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class SSKeyboardViewModel: NSObject, SSViewModelType {

    private let BLL = SSKeyboardBusinessLogic.self
    
    struct Limit {
        let all:     Driver<Int?>
        let integer: Driver<Int?>
        let decimal: Driver<Int?>
    }
}

extension SSKeyboardViewModel {
    struct Input {
        let text:   Driver<String>
        let number: Driver<Int>
        let delete: Driver<Void>
        let custom: Driver<String>?
        let limit:  Driver<SSLimitRule>
    }
    
    struct Output {
        let insert:         Driver<String>
        let deleteBackward: Driver<Int>
        let destroyTimer:   Driver<Void>
    }
}

extension SSKeyboardViewModel {
    func transform(input: Input) -> Output {
        
        
        let insertNumber   = BLL.didSelectedNumberButton(input.number, text: input.text, limitRule: input.limit)
        let insertCustom   = BLL.didSelectedCustomButton(input.custom, text: input.text, limitRule: input.limit)
        
        let insert         = BLL.mergeInserts(insertNumber, insertCustom)
        let deleteBackward = BLL.didSelectedDeleteButton(input.delete, text: input.text)
        
        let destroyTimer   = Driver.merge(input.taps())
        return Output(
            insert: insert,
            deleteBackward: deleteBackward,
            destroyTimer: destroyTimer
        )
    }
}

extension SSKeyboardViewModel.Input {
    func taps() -> [Driver<Void>] {
        var taps = [
            number.map{ _ in () },
            delete.map{ _ in () }
        ]
        
        if let custom = custom {
            taps.append(custom.map{ _ in () })
        }
        
        return taps
    }
}
