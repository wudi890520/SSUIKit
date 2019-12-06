//
//  KeyboardBusinessLogic.swift
//  SSUIKit_Example
//
//  Created by 吴頔 on 2019/12/4.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

typealias SSLimitRule = (all: Int?, integer: Int?, decimal: Int?)

class SSKeyboardBusinessLogic: NSObject {
    
    /// 点击了键盘数字按钮
    ///
    /// - Parameters:
    ///   - input: 输入信号
    ///   - text: 当前输入框文本
    ///   - limitRule: 输入位数的限制
    /// - Returns: 输出信号
    static func didSelectedNumberButton(
        _ input: Driver<Int>,
        text: Driver<String>,
        limitRule: Driver<SSLimitRule>
        ) -> Driver<String> {
        
        let combineLatest = Driver.combineLatest(text, limitRule, input, resultSelector: { ($0, $1, $2) })
        let result = input.withLatestFrom(combineLatest)
            .map { (string, limit, number) -> String in
                
                let Empty = ""
                
                let text = string.filter(keywords: Empty)
                
                if let all = limit.all, text.count >= all {
                    return Empty
                }
                if let integer = limit.integer, let decimal = limit.decimal {
                    if text.contains(".") {
                        let array = text.components(separatedBy: ".")
                        let first = array.first?.count
                        let last = array.last?.count
                        let firstCount = first.orEmpty
                        let lastCount = last.orEmpty
                        if firstCount >= integer && lastCount >= decimal {
                            return Empty
                        }else if lastCount >= decimal {
                            return Empty
                        }
                    }else{
                        if text.count >= integer { return Empty }
                    }
                }
                if text.first == "0" && !text.contains("0.") {
                    return Empty
                }
                return number.ss_number.stringValue
            }
        
        return result
    }
    
    /// 点击自定义按钮（如：“X”, "."）
    ///
    /// - Parameters:
    ///   - input: 输入信号
    ///   - text: 当前输入框文本
    ///   - limitRule: 输入位数的限制
    /// - Returns: 输出信号
    static func didSelectedCustomButton(_ input: Driver<String>?, text: Driver<String>, limitRule: Driver<SSLimitRule>) -> Driver<String> {
        guard let input = input else { return Driver.just("") }

        let combineLatest = Driver.combineLatest(text, limitRule, input, resultSelector: { ($0, $1, $2) })
        let result = input.withLatestFrom(combineLatest)
                .map { (string, limit, replacementString) -> String in
                    let Empty = ""
                    let text = string.filter(keywords: Empty)
                    if let all = limit.all, text.count >= all {
                        return Empty
                    }
                    if replacementString == "." && (text.contains(".") || text.count == 0) {
                        return Empty
                    }
                    return replacementString
                }

        return result
    }
    
    /// 将所有的insert的信号合并
    ///
    /// - Parameter inserts: [Driver<String>]
    /// - Returns: Driver<String>
    static func mergeInserts(_ inserts: Driver<String>...) -> Driver<String> {
        return Driver.merge(inserts)
    }
    
    /// 点击了键盘的删除按钮
    ///
    /// - Parameters:
    ///   - input: 输入信号
    ///   - text: 当前输入框文本
    /// - Returns: 输出信号
    static func didSelectedDeleteButton(_ input: Driver<Void>, text: Driver<String>) -> Driver<Int> {
        return input
            .withLatestFrom(text)
            .map{ $0.last == " " ? 2 : 1 }
    }
}
