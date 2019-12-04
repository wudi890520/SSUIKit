//
//  Array.swift
//  SSUIKit
//
//  Created by 吴頔 on 2019/11/30.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import UIKit

public protocol OptionalArray {}
extension Array: OptionalArray {}
public extension Optional where Wrapped: OptionalArray {
    var orEmpty: Wrapped {
        if self == nil {
            return [] as! Wrapped
        }else{
            return self!
        }
    }
}

public extension Array {
    
    /// 数组去重
    /// - Parameter filter: 根据什么参照物去过滤
    func filterDuplicates<E: Equatable>(_ filter: (Element) -> E) -> [Element] {
        
        var result = [Element]()
        
        for value in self {
            let key = filter(value)
            if !result.map({filter($0)}).contains(key) {
                result.append(value)
            }
        }

        return result
    }
    
    /// 数组切片(从0开始，到某个index结束)
    func sliceTo(_ to: Int) -> [Element] {
        if (0 ..< count).contains(to) {
            return Array(self[0 ..< to])
        }else{
            return self
        }
    }
    
    /// 数组切片(从某个index开始，到数组末尾结束)
    func sliceFrom(_ from: Int) -> [Element] {
        if (0 ..< count).contains(from) {
            return Array(self[from ..< count])
        }else{
            return self
        }
    }
     
    /// 数组切片
    func slice(_ range: Range<Int>) -> [Element] {
        if self.count < range.startIndex {
            return []
        }else if self.count < range.endIndex {
            return Array(self[range.startIndex ..< self.count])
        }else{
            return Array(self[range])
        }
    }
    
    /// 添加一个元素
    /// - Parameter element: 元素
    func add(_ element: Element) -> [Element] {
        var sequence = self
        sequence.append(element)
        return sequence
    }
    
    /// 追加一个数组
    /// - Parameter element: 元素
    func add(_ elements: [Element]) -> [Element] {
        var sequence = self
        sequence.append(contentsOf: elements)
        return sequence
    }
}
