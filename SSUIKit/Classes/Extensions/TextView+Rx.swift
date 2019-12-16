//
//  TextView+Rx.swift
//  BlocksKit
//
//  Created by 吴頔 on 2019/12/16.
//

import UIKit
import RxCocoa
import RxSwift

public extension UITextView {
    public var ss_textDriver: Driver<String> {
        return self.rx.text.orEmpty.asDriver()
    }
    
    public var ss_return: Driver<String> {
        return self.rx
            .methodInvoked(#selector(UITextViewDelegate.textView(_:shouldChangeTextIn:replacementText:)))
            .filter{ ($0.last as? String) == "\n" }
            .map{ $0.first as? UITextView }
            .asDriver(onErrorJustReturn: nil)
            .filterNil()
            .map{ $0.text.orEmpty }
    }
}

public extension UITextView {
    public var ss_textObservable: Observable<String> {
        return self.rx.text.orEmpty.asObservable()
    }
}

public extension Reactive where Base: UITextView {
    public var append: Binder<String?> {
        return Binder(base) { textView, text in
            guard let text = text else { return }
            textView.text = textView.text.add(text)
        }
    }
    
    public var becomeFirstResponder: Binder<Void> {
        return Binder(base) { textView, _ in
            textView.becomeFirstResponder()
        }
    }
}

