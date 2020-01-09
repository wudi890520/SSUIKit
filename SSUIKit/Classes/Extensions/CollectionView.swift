//
//  CollectionView.swift
//  DeviceKit
//
//  Created by 吴頔 on 2020/1/9.
//

import UIKit

public extension UICollectionView {
    @discardableResult
    public func ss_register(_ className: AnyClass) -> Self {
        let nibName = "\(className.description())".components(separatedBy: ".")
        if let path = Bundle.init(for: className).path(forResource: nibName.first, ofType: "bundle") {
            let bundle = Bundle.init(path: path)
            let nib = UINib.init(nibName: nibName.last ?? "", bundle: bundle)
            register(nib, forCellWithReuseIdentifier: nibName.last ?? "")
            return self
        }else{
            let bundle = Bundle.init(for: className)
            let nib = UINib.init(nibName: nibName.last ?? "", bundle: bundle)
            register(nib, forCellWithReuseIdentifier: nibName.last ?? "")
            return self
        }
    }
}
