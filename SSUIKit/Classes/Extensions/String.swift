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
    var orEmpty: String {
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
    var ss_number: NSNumber {
        return NSNumber(floatLiteral: ss_nsString.doubleValue)
    }
    
    /// String To NSMutableAttributedString
    var ss_attribute: NSMutableAttributedString {
        return NSMutableAttributedString(string: self)
    }
    
    /// String To NSDecimalNumber
    var ss_decimalNumber: NSDecimalNumber {
        if isEmpty { return 0 }
        return NSDecimalNumber(string: self)
    }
    
    /// String To Float
    var ss_float: Float {
        return ss_number.floatValue
    }
    
    /// String To Double
    var ss_double: Double {
        return ss_number.doubleValue
    }
    
    /// String To Int
    var ss_int: Int {
        return ss_number.intValue
    }
    
    /// String To URL (Optional)
    var ss_url: URL? {
        return URL(string: self)
    }
    
    /// String To URL
    var ss_samllUrl: URL? {
        let urlStr = replacingOccurrences(of: "?size=100X100", with: "")
            .replacingOccurrences(of: "?size=500X500", with: "")
            .replacingOccurrences(of: "?size=1000X1000", with: "")
        return URL(string: urlStr.add("?size=300x300"))
    }
    
    /// String To URL
    var ss_largeUrl: URL? {
        let urlString = replacingOccurrences(of: "?size=100X100", with: "")
            .replacingOccurrences(of: "?size=500X500", with: "")
            .replacingOccurrences(of: "?size=1000X1000", with: "")
        return URL(string: urlString.add("?size=500X500"))
    }
 
    /// String To MD5
    var ss_md5: String {
        return self.qmui_md5
    }
    
    /// String To Color
    var ss_color: UIColor? {
        return UIColor.hex(self)
    }
    
    /// 分解成子字符串数组（ 如："123abc".ss_subs = ["1", "2", "3", "a", "b", "c"] ）
    var ss_subs: [String] {
        var subs: [String] = []
        forEach{ subs.append("\($0)") }
        return subs
    }
    
    /// 将base64字符串转成图片
    var ss_imageFromBase64: UIImage? {
        guard let data = Data(base64Encoded: self, options: .ignoreUnknownCharacters) else { return nil }
        guard let image = UIImage(data: data) else { return nil }
        return image
    }
    
    
}

public extension String {
    
    var asMobile: String {
        return "telprompt://\(self)"
    }
    
    var asMobileURL: URL? {
        if let url = URL(string: asMobile) {
            return url
        }
        return nil
    }

}

public extension String {
    
    /// 验证是否是手机号
    var ss_isMobile: Bool {
        let mobile = self
            .filter(keywords: "+86", "")
            .ss_sub(to: 11)
        
        if mobile.count != 11 {
            return false
        }

        if mobile.first != "1" {
            return false
        }
        return true
    }
    
    /// 验证是否是密码
    var ss_isPassword: Bool {
        return count >= 6 && count <= 16
    }
    
    /// 验证码长度
    var ss_isVerificationCode: Bool {
        return count == 4
    }
    
    /// 验证是否是身份证号码
    var ss_isIdentityCard: Bool {
        return String.isIDNumber(self)
    }

    var ss_charactors: [String] {
        var subs: [String] = []
        forEach{ subs.append("\($0)") }
        return subs
    }
    
    /// 是否是汉字
    var isPure: Bool {
        let match = "[\\u4e00-\\u9fa5]+$"
        let predicate = NSPredicate(format: "SELF matches %@", match)
        return predicate.evaluate(with: self)
    }
}

public extension String {
    
    /// 过滤字符串
    ///
    /// - Parameter keywords: 要过滤的关键字
    /// - Returns: String
    func filter(keywords: String...) -> String {
        var string = self
        keywords.forEach{ string = string.replacingOccurrences(of: $0, with: "") }
        return string
    }
    
    /// 向字符串中添加空格（用于将手机号Format）
    /// Example："18812345678".addBlank(true) = "+86 188 1234 5678"
    /// Example："18812345678".addBlank(false) = "188 1234 5678"
    ///
    /// - Parameter isNeedCountryCode: 是否需要添加国家代码
    /// - Returns: String
    func addBlank(_ isNeedCountryCode: Bool = true) -> String {
        
        if !ss_isMobile {
            return self
        }
        
        /// 运营商
        let operatorCode = ss_sub(to: 3)
        
        /// 城市
        let cityCode = ss_sub(from: 3).ss_sub(to: 4)
        
        /// 客户
        let customerCode = ss_sub(from: 7)
        
        /// 国家
        let countryCode: String = isNeedCountryCode ? "+86 " : ""
        
        return "\(countryCode)\(operatorCode) \(cityCode) \(customerCode)"
    }
    
    
}

public extension String {
    public func ss_width(for font: UIFont) -> CGFloat {
        return ss_nsString.width(for: font)
    }
    
    public func ss_height(for font: UIFont, contentWidth: CGFloat) -> CGFloat {
        return ss_nsString.height(for: font, width: contentWidth)
    }
}

public extension String {
    public func ss_sub(from index: Int) -> String {
        if (0 ..< self.count).contains(index) {
            return ss_nsString.substring(from: index)
        }
        return self
    }
    
    public func ss_sub(to index: Int) -> String {
        if (0 ..< self.count).contains(index) {
            return ss_nsString.substring(to: index)
        }
        return self
    }
    
    public func ss_sub(in range: Range<Int>) -> String {
        
        var startIndex: Int = range.startIndex
        var endIndex: Int = range.endIndex
        
        if range.startIndex < 0 {
            startIndex = 0
        }else if range.startIndex >= self.count {
            return self
        }
        
        if range.endIndex < 0 {
            return self
        }else if range.endIndex >= self.count {
            endIndex = self.count - 1
        }
        
        let nsRange = NSMakeRange(startIndex, endIndex - startIndex)
        return ss_nsString.substring(with: nsRange)
    }
    
    func add(_ strings: String...) -> String {
        var result: String = "\(self)"
        for str in strings {
            result = "\(result)\(str)"
        }
        return result
    }
}

extension String {
    static func isIDNumber(_ text: String) -> Bool {
        
        func getStringByRangeIntValue(Str : NSString,location : Int, length : Int) -> Int{
            let a = Str.substring(with: NSRange(location: location, length: length))
            let intValue = (a as NSString).integerValue
            return intValue
        }
        
        var value = text
        value = value.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        var length : Int = 0
        length = value.count
        if length != 15 && length != 18{
           //不满足15位和18位，即身份证错误
            return false
        }
        // 省份代码
        let areasArray = ["11","12", "13","14", "15","21", "22","23", "31","32", "33","34", "35","36", "37","41", "42","43", "44","45", "46","50", "51","52", "53","54", "61","62", "63","64", "65","71", "81","82", "91"]
        // 检测省份身份行政区代码
        let index = value.index(value.startIndex, offsetBy: 2)
        let valueStart2 = value.substring(to: index)
        //标识省份代码是否正确
        var areaFlag = false
        for areaCode in areasArray {
            if areaCode == valueStart2 {
                areaFlag = true
                break
            }
        }
        if !areaFlag {
           return false
        }
        var regularExpression : NSRegularExpression?
        var numberofMatch : Int?
        var year = 0
        switch length {
            case 15:
                 //获取年份对应的数字
                let valueNSStr = value as NSString
                let yearStr = valueNSStr.substring(with: NSRange.init(location: 6, length: 2)) as NSString
                year = yearStr.integerValue + 1900
                if year % 4 == 0 || (year % 100 == 0 && year % 4 == 0) {
                    //创建正则表达式 NSRegularExpressionCaseInsensitive：不区分字母大小写的模式
                    //测试出生日期的合法性
                    regularExpression = try! NSRegularExpression.init(pattern: "^[1-9][0-9]{5}[0-9]{2}((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|[1-2][0-9]))[0-9]{3}$", options: NSRegularExpression.Options.caseInsensitive)
                }else{
                    //测试出生日期的合法性
                    regularExpression = try! NSRegularExpression.init(pattern: "^[1-9][0-9]{5}[0-9]{2}((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|1[0-9]|2[0-8]))[0-9]{3}$", options: NSRegularExpression.Options.caseInsensitive)
                }
                numberofMatch = regularExpression?.numberOfMatches(in: value, options: NSRegularExpression.MatchingOptions.reportProgress, range: NSRange.init(location: 0, length: value.count))
                if numberofMatch! > 0 {
                    return true
                }else{
                    return false
                }
            case 18:
                let valueNSStr = value as NSString
                let yearStr = valueNSStr.substring(with: NSRange.init(location: 6, length: 4)) as NSString
                year = yearStr.integerValue
                if year % 4 == 0 || (year % 100 == 0 && year % 4 == 0) {
                    //测试出生日期的合法性
                    regularExpression = try! NSRegularExpression.init(pattern: "^((1[1-5])|(2[1-3])|(3[1-7])|(4[1-6])|(5[0-4])|(6[1-5])|71|(8[12])|91)\\d{4}(((19|20)\\d{2}(0[13-9]|1[012])(0[1-9]|[12]\\d|30))|((19|20)\\d{2}(0[13578]|1[02])31)|((19|20)\\d{2}02(0[1-9]|1\\d|2[0-8]))|((19|20)([13579][26]|[2468][048]|0[048])0229))\\d{3}(\\d|X|x)?$", options: NSRegularExpression.Options.caseInsensitive)
                    
                }else{
                    //测试出生日期的合法性
                    regularExpression = try! NSRegularExpression.init(pattern: "^((1[1-5])|(2[1-3])|(3[1-7])|(4[1-6])|(5[0-4])|(6[1-5])|71|(8[12])|91)\\d{4}(((19|20)\\d{2}(0[13-9]|1[012])(0[1-9]|[12]\\d|30))|((19|20)\\d{2}(0[13578]|1[02])31)|((19|20)\\d{2}02(0[1-9]|1\\d|2[0-8]))|((19|20)([13579][26]|[2468][048]|0[048])0229))\\d{3}(\\d|X|x)?$", options: NSRegularExpression.Options.caseInsensitive)
                    
                }
                numberofMatch = regularExpression?.numberOfMatches(in: value, options: NSRegularExpression.MatchingOptions.reportProgress, range: NSRange.init(location: 0, length: value.count))
                
                if numberofMatch! > 0 {
                    let a = getStringByRangeIntValue(Str: valueNSStr, location: 0, length: 1) * 7
                    let b = getStringByRangeIntValue(Str: valueNSStr, location: 10, length: 1) * 7
                    let c = getStringByRangeIntValue(Str: valueNSStr, location: 1, length: 1) * 9
                    let d = getStringByRangeIntValue(Str: valueNSStr, location: 11, length: 1) * 9
                    let e = getStringByRangeIntValue(Str: valueNSStr, location: 2, length: 1) * 10
                    let f = getStringByRangeIntValue(Str: valueNSStr, location: 12, length: 1) * 10
                    let g = getStringByRangeIntValue(Str: valueNSStr, location: 3, length: 1) * 5
                    let h = getStringByRangeIntValue(Str: valueNSStr, location: 13, length: 1) * 5
                    let i = getStringByRangeIntValue(Str: valueNSStr, location: 4, length: 1) * 8
                    let j = getStringByRangeIntValue(Str: valueNSStr, location: 14, length: 1) * 8
                    let k = getStringByRangeIntValue(Str: valueNSStr, location: 5, length: 1) * 4
                    let l = getStringByRangeIntValue(Str: valueNSStr, location: 15, length: 1) * 4
                    let m = getStringByRangeIntValue(Str: valueNSStr, location: 6, length: 1) * 2
                    let n = getStringByRangeIntValue(Str: valueNSStr, location: 16, length: 1) * 2
                    let o = getStringByRangeIntValue(Str: valueNSStr, location: 7, length: 1) * 1
                    let p = getStringByRangeIntValue(Str: valueNSStr, location: 8, length: 1) * 6
                    let q = getStringByRangeIntValue(Str: valueNSStr, location: 9, length: 1) * 3
                    let S = a + b + c + d + e + f + g + h + i + j + k + l + m + n + o + p + q
                    
                    let Y = S % 11
                    
                    var M = "F"
                    
                    let JYM = "10X98765432"
                    
                    M = (JYM as NSString).substring(with: NSRange.init(location: Y, length: 1))
                    
                    let lastStr = valueNSStr.substring(with: NSRange.init(location: 17, length: 1))
                    
                    if lastStr == "x" {
                        if M == "X" {
                            return true
                        }else{
                            return false
                        }
                    }else{
                        if M == lastStr {
                            return true
                        }else{
                            return false
                        }
                    }
                    
                }else{
                    return false
                }
            default:
                return false
          }
    }
    

}

extension String {
    var bundleImage: UIImage? {
        let bundle = Bundle.init(for: SSKeyboardView.self)
        if let path = bundle.path(forResource: "SSUIKit", ofType: "bundle") {
            return UIImage(named: self, in: Bundle(path: path)!, compatibleWith: nil)
        }else{
            return UIImage(named: self, in: bundle, compatibleWith: nil)
        }
    }
}
