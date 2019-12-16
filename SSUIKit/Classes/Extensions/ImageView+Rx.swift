//
//  ImageView+Rx.swift
//  BlocksKit
//
//  Created by 吴頔 on 2019/12/16.
//

import UIKit
import RxCocoa
import RxSwift
import Kingfisher

public extension Reactive where Base: UIImageView {
  
    public var kfImage: Binder<(String, UIImage?)> {
        return Binder(base) { imageView, tuple in
            let (urlString, placeholderImage) = tuple
            if urlString.isEmpty {
                imageView.image = placeholderImage
            }else{
                imageView.kf.setImage(with: urlString.ss_url, placeholder: placeholderImage)
            }
        }
    }
    
}

