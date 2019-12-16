//
//  SearchBar+Rx.swift
//  BlocksKit
//
//  Created by 吴頔 on 2019/12/16.
//

import UIKit
import RxCocoa
import RxSwift

public extension Reactive where Base: UISearchBar {
    public func showsCancelButton(animated: Bool = true) -> Binder<Bool> {
        return Binder(base) { view, showsCancelButton in
            view.setShowsCancelButton(showsCancelButton, animated: animated)
        }
    }
}
