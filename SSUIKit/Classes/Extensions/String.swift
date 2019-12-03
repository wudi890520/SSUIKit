//
//  String.swift
//  SSUIKit
//
//  Created by 吴頔 on 2019/11/30.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import UIKit
import QMUIKit

public protocol OptionalString {}
extension String: OptionalString {}

public extension Optional where Wrapped: OptionalString {
    
    /// 让String非Nil，当Nil时返回空字符串
    public var orEmpty: String {
        if self == nil {
            return ""
        }else{
            return self as! String
        }
    }
}

public extension String {

    /// String To NSString
    internal var ss_nsString: NSString {
        return NSString(string: self)
    }
    
    /// String To NSNumber
    public var ss_number: NSNumber {
        return NSNumber(floatLiteral: ss_nsString.doubleValue)
    }
    
    /// String To NSMutableAttributedString
    public var ss_attribute: NSMutableAttributedString {
        return NSMutableAttributedString(string: self)
    }
    
    /// String To NSDecimalNumber
    public var ss_decimalNumber: NSDecimalNumber {
        if isEmpty { return 0 }
        return NSDecimalNumber(string: self)
    }
    
    /// String To Float
    public var ss_float: Float {
        return ss_number.floatValue
    }
    
    /// String To Double
    public var ss_double: Double {
        return ss_number.doubleValue
    }
    
    /// String To Int
    public var ss_int: Int {
        return ss_number.intValue
    }
    
    /// String To URL (Optional)
    public var ss_url: URL? {
        return URL(string: self)
    }
    
    /// String To URL
    public var ss_samllUrl: URL? {
        let urlStr = replacingOccurrences(of: "?size=100X100", with: "")
            .replacingOccurrences(of: "?size=500X500", with: "")
            .replacingOccurrences(of: "?size=1000X1000", with: "")
        return URL(string: urlStr.add("?size=300x300"))
    }
    
    /// String To URL
    public var ss_largeUrl: URL? {
        let urlString = replacingOccurrences(of: "?size=100X100", with: "")
            .replacingOccurrences(of: "?size=500X500", with: "")
            .replacingOccurrences(of: "?size=1000X1000", with: "")
        return URL(string: urlString.add("?size=500X500"))
    }
 
    /// String To MD5
    public var ss_md5: String {
        return self.qmui_md5
    }
    
    /// String To Color
    public var ss_color: UIColor? {
        return UIColor.hex(self)
    }
    
    /// 分解成子字符串数组（ 如："123abc".ss_subs = ["1", "2", "3", "a", "b", "c"] ）
    public var ss_subs: [String] {
        var subs: [String] = []
        forEach{ subs.append("\($0)") }
        return subs
    }
    
    /// 将base64字符串转成图片
    public var ss_imageFromBase64: UIImage? {
        guard let data = Data(base64Encoded: self, options: .ignoreUnknownCharacters) else { return nil }
        guard let image = UIImage(data: data) else { return nil }
        return image
    }
    
    
}

extension String {
    
    public func add(_ strings: String...) -> String {
        var result: String = "\(self)"
        for str in strings {
            result = "\(result)\(str)"
        }
        return result
    }
}

extension String {
    
    public var asMobile: String {
        return "telprompt://\(self)"
    }
    
    public var asMobileURL: URL? {
        if let url = URL(string: asMobile) {
            return url
        }
        return nil
    }

}
