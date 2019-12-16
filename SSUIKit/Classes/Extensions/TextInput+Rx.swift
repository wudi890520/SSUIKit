//
//  TextInput+Rx.swift
//  BlocksKit
//
//  Created by 吴頔 on 2019/12/16.
//

import UIKit
import RxCocoa
import RxSwift

public extension Reactive where Base: UITextInput {
    
    public var ss_deleteBackward: Binder<Int?> {
        return Binder(base) { input, count in
            guard let count = count else { return }
            for _ in 0 ..< count { input.deleteBackward() }
        }
    }
    
    public var ss_insert: Binder<String?> {
        return Binder(base) { input, text in
            guard let text = text, !text.isEmpty else { return }
            input.insertText(text)
        }
    }
}

public extension Reactive where Base: UITextInput {

    public var ss_textDriver: Driver<String>? {
        if let textField = base as? UITextField {
            return textField.ss_textDriver
        }else if let textView = base as? UITextView {
            return textView.ss_textDriver
        }
        return nil
    }
    
}

