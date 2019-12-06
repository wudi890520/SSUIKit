//
//  ImageView.swift
//  SSUIKit
//
//  Created by 吴頔 on 2019/11/30.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import UIKit
import Kingfisher

public protocol SSUIImageViewCompatible {}

extension UIImageView: SSUIImageViewCompatible {}

public extension SSUIImageViewCompatible where Self: UIImageView {
    
    /// 设置图片
    ///
    /// - Parameter image: UIImage
    /// - Returns: UIImageView
    @discardableResult
    func ss_image(_ image: UIImage?) -> Self {
        self.image = image
        return self
    }
    
    /// 设置图片内容展示模式
    ///
    /// - Parameter contentMode: UIView.ContentMode
    /// - Returns: UIImageView
    @discardableResult
    func ss_contentMode(_ contentMode: UIView.ContentMode = .scaleAspectFill) -> Self {
        self.contentMode = contentMode
        return self
    }
    
    /// 加载网络图片
    ///
    /// - Parameter urlString: 图片链接地址
    /// - Returns: UIImageView
    @discardableResult
    func ss_kingfisherImage(_ urlString: String?, placeholder: UIImage? = nil, completion: ((UIImage?) ->Void)? = nil) -> Self {
        
        guard let url = urlString?.ss_url else {
            image = placeholder
            return self
        }
 
        if let completion = completion {
            self.kf.setImage(
                with: url,
                placeholder: placeholder,
                options: nil,
                progressBlock: nil) { (result) in
                    switch result {
                    case .success(let value):
                        completion(value.image)
                    case .failure:
                        return
                    }
            }
        }else{
            self.kf.setImage(with: url, placeholder: placeholder, options: nil)
        }
        
        return self
    }
    
    
}
