//
//  SSBannerConvertible.swift
//  BlocksKit
//
//  Created by 吴頔 on 2019/12/10.
//

import UIKit

public protocol SSBannerConvertible {
    var urlValue: URL? { get }
    var urlStringValue: String? { get }
    var imageValue: UIImage? { get }
}

extension UIImage: SSBannerConvertible {
    public var urlValue: URL? {
        return nil
    }
    
    public var urlStringValue: String? {
        return nil
    }
    
    public var imageValue: UIImage? {
        return self
    }
}

extension URL: SSBannerConvertible {
    public var urlValue: URL? {
        return self
    }
    
    public var urlStringValue: String? {
        return self.absoluteString
    }
    
    public var imageValue: UIImage? {
        return nil
    }
}

extension String: SSBannerConvertible {
    public var urlValue: URL? {
        if let url = URL(string: self) {
           return url
        }
        var set = CharacterSet()
        set.formUnion(.urlHostAllowed)
        set.formUnion(.urlPathAllowed)
        set.formUnion(.urlQueryAllowed)
        set.formUnion(.urlFragmentAllowed)
        return self.addingPercentEncoding(withAllowedCharacters: set).flatMap { URL(string: $0) }
    }
    
    public var urlStringValue: String? {
        return self
    }
    
    public var imageValue: UIImage? {
        return nil
    }
}

extension SSBannerImageItem: SSBannerConvertible {
    public var urlValue: URL? {
        if let string = source as? String {
            if let url = URL(string: string) {
               return url
            }
            var set = CharacterSet()
            set.formUnion(.urlHostAllowed)
            set.formUnion(.urlPathAllowed)
            set.formUnion(.urlQueryAllowed)
            set.formUnion(.urlFragmentAllowed)
            return string.addingPercentEncoding(withAllowedCharacters: set).flatMap { URL(string: $0) }
        }else{
            return source as? URL
        }
    }
    
    public var urlStringValue: String? {
        if let url = source as? URL {
            return url.absoluteString
        }else{
            return source as? String
        }
    }
    
    public var imageValue: UIImage? {
        return source as? UIImage
    }
}

//extension Array where Element: SSBannerConvertible {
//    public var urlValues: [URL]? {
//        return nil
//    }
//
//    public var urlStringValues: [String]? {
//        return nil
//    }
//
//    public var imageValues: [UIImage]? {
//        return nil
//    }
//}
