//
//  TimeInterval.swift
//  SSUIKit
//
//  Created by 吴頔 on 2019/11/30.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import UIKit

/// 回头车日期格式化类型
///
/// - default: 标准格式 Example: yyyy-MM-dd HH:mm:ss
/// - date: 年月日 Example: yyyy-MM-dd
/// - dateByPoint: 年月日，用"."分割 Example: yyyy.MM.dd
/// - dateToMinute: 年月日时分 Example: yyyy-MM-dd HH:mm
/// - shortDateByCN: 月日，用中文显示 Example: MM月dd日
/// - minute: 时分 Example: HH:mm
/// - second: 月日时分 Example: MM-dd HH:mm
/// - automatic: 月日时分，用中文显示 Example: MM月dd日 HH:mm
/// - automaticByCN: 分秒 Example: mm:ss
/// - sign: 签名 Example: yyyyMMddHHmmss
public enum SSDateFormat {
    /// "yyyy-MM-dd HH:mm:ss"
    case `default`
    /// "yyyy-MM-dd"
    case date
    /// "MM-dd"
    case shortDate
    /// "yyyy.MM.dd"
    case dateByPoint
    /// "yyyy-MM-dd HH:mm"
    case dateToMinute
    /// "MM月dd日"
    case shortDateByCN
    /// "HH:mm"
    case minute
    /// "MM-dd HH:mm"
    case second
    /// "MM月dd日 HH:mm"
    case automatic
    /// "mm:ss"
    case automaticByCN
    /// "yyyyMMddHHmmss"
    case sign
}

extension SSDateFormat {
    var dateFormat: String {
        switch self {
        case .default: return "yyyy-MM-dd HH:mm:ss"
        case .date: return "yyyy-MM-dd"
        case .shortDate: return "MM-dd"
        case .dateByPoint: return "yyyy.MM.dd"
        case .dateToMinute: return "yyyy-MM-dd HH:mm"
        case .shortDateByCN: return "MM月dd日"
        case .minute: return "HH:mm"
        case .second: return "MM-dd HH:mm"
        case .automatic: return "MM月dd日 HH:mm"
        case .automaticByCN: return "mm:ss"
        case .sign: return "yyyyMMddHHmmss"
        }
    }
    
    var formatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en")
        formatter.dateFormat = dateFormat
        return formatter
    }
}

public protocol OptionalTimeInterval {}
extension TimeInterval: OptionalTimeInterval {}
public extension Optional where Wrapped: OptionalTimeInterval {
    var orEmpty: TimeInterval {
        if self == nil {
            return 0
        }else{
            return self as! TimeInterval
        }
    }
}

public extension TimeInterval {
    
    /// 时间戳 -> 时间
    var ss_date: Date {
        return Date(timeIntervalSince1970: self)
    }
    
    var ss_dateDescription: String {
        let dateFormat = DateFormatter()
        dateFormat.dateFormat = "yyyy年MM月dd日 H:mm"
        dateFormat.locale = Locale(identifier: "en")
        return dateFormat.string(from: ss_date)
    }
    
    /// 一天有多少秒
    static var ss_oneDay: TimeInterval {
        return 86400
    }
    
    /// 获取当前时间戳
    static var ss_current: TimeInterval {
        return Date().timeIntervalSince1970
    }
    
    /// 朋友圈的格式
    var ss_timeLine: String {
        let date = ss_date
        let calendar = Calendar.current
        let dateFormat = DateFormatter()
        
        if calendar.isDateInToday(date) {
            let changed = Date().timeIntervalSince1970 - self
            if changed < 60 {
                return "刚刚"
            }
            
            if changed < 60 * 60 {
                return "\(Int(changed / 60))分钟前"
            }
            
            return "\(Int(changed / 3600))小时前"
        }
        
        if calendar.isDateInYesterday(date) {
            dateFormat.dateFormat = "昨天 H:mm"
        }else{
            let year = calendar.component(.year, from: date)
            let thisYear = calendar.component(.year, from: Date())
            
            /// 如果是今年
            if year == thisYear {
                dateFormat.dateFormat = "MM/dd H:mm"
            } else {
                dateFormat.dateFormat = "yyyy/MM/dd H:mm"
            }
        }
        dateFormat.locale = Locale(identifier: "en")
        
        return dateFormat.string(from: date)
    }
    

    
}

extension TimeInterval {
    
    /// 时间戳 -> 字符串
    ///
    /// - Parameter type: HTCTimeFormatter
    /// - Returns: String
    func ss_string(_ format: SSDateFormat = .default) -> String {
        return format.formatter.string(from: ss_date)
    }

    /// 在当前时间的基础上加x天
    ///
    /// - Parameter day: 要加几天
    /// - Returns: TimeInterval
    func ss_increase(_ day: Int) -> TimeInterval {
        return TimeInterval.ss_current + TimeInterval(day) * TimeInterval.ss_oneDay
    }
    
    /// 在当前时间的基础上减x天
    ///
    /// - Parameter day: 要减几天
    /// - Returns: TimeInterval
    func ss_decrease(_ day: Int) -> TimeInterval {
        return TimeInterval.ss_current - TimeInterval(day) * TimeInterval.ss_oneDay
    }
}

public extension TimeInterval {
    struct Duration {
        static let ss_hornDelay: TimeInterval = 3
        static let ss_popDelay: TimeInterval = 2
        static let ss_delay: TimeInterval = 0.3
        static let ss_longDelay: TimeInterval = 0.4
        static let ss_animate: TimeInterval = 0.25
        static let ss_min: TimeInterval = 1/TimeInterval.infinity
    }
}

public extension DispatchTimeInterval {
    struct Duration {
        static let ss_hornDelay: DispatchTimeInterval = .seconds(3)
        static let ss_popDelay: DispatchTimeInterval = .seconds(2)
        static let ss_delay: DispatchTimeInterval = .milliseconds(300)
        static let ss_longDelay: DispatchTimeInterval = .milliseconds(400)
        static let ss_animate: DispatchTimeInterval = .milliseconds(250)
        static let ss_min: DispatchTimeInterval = .nanoseconds(1)
    }
}

public extension String {
    /// 时间戳 -> 字符串
    ///
    /// - Parameter type: HTCTimeFormatter
    /// - Returns: String
    func ss_interval(_ format: SSDateFormat = .default) -> TimeInterval {
        guard let date = format.formatter.date(from: self) else { return TimeInterval.ss_current }
        return date.timeIntervalSince1970
    }
    
}
