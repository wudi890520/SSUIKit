//
//  Button+Rx.swift
//  BlocksKit
//
//  Created by 吴頔 on 2019/12/16.
//

import UIKit
import RxCocoa
import RxSwift
import Kingfisher

public extension UIButton {
    public var ss_tapDriver: Driver<Void> {
        return self.rx.tap.asDriver()
    }
}

public extension UIButton {
    public var ss_tapObservable: Observable<Void> {
        return self.rx.tap.asObservable()
    }
}

public extension Reactive where Base: UIButton {
    var titleColor: Binder<UIColor> {
        return Binder(base) { button, titleColor in
            button.ss_titleColor(titleColor)
        }
    }
    
    var touchUpInside: Binder<Void> {
        return Binder(base) { button, titleColor in
            button.sendActions(for: .touchUpInside)
        }
    }
    
    var kfImage: Binder<(String, UIImage?)> {
        return Binder(base) { button, tuple in
            let (urlString, placeholderImage) = tuple
            button.kf.setImage(with: urlString.ss_url, for: .normal, placeholder: placeholderImage)
            button.kf.setImage(with: urlString.ss_url, for: .highlighted, placeholder: placeholderImage)
        }
    }
    
}

