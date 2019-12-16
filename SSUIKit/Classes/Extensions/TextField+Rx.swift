//
//  TextField+Rx.swift
//  BlocksKit
//
//  Created by 吴頔 on 2019/12/16.
//

import UIKit
import RxCocoa
import RxSwift

public extension UITextField {
    public var ss_textDriver: Driver<String> {
        return self.rx.text.orEmpty.asDriver()
    }
    
    public var ss_noRangeTextDriver: Driver<String> {
        return self.rx.text.orEmpty.asDriver()
            .filter{[weak self] _ in self?.markedTextRange == nil }
    }
}

public extension UITextField {
    public var ss_textObservable: Observable<String> {
        return self.rx.text.orEmpty.asObservable()
    }
}

public extension Reactive where Base: UITextField {
    public var placeholder: Binder<String?> {
        return Binder(base) { textField, placeholder in
            textField.placeholder = placeholder
        }
    }
    
    public var becomeFirstResponder: Binder<Void> {
        return Binder(base) { textField, _ in
            textField.becomeFirstResponder()
        }
    }
    
    public var resignFirstResponder: Binder<Void> {
        return Binder(base) { textField, _ in
            textField.resignFirstResponder()
        }
    }
    
    public var font: Binder<UIFont?> {
        return Binder(base) { textField, font in
            textField.font = font
        }
    }
}

