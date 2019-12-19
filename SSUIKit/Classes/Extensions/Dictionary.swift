//
//  Dictionary.swift
//  SSUIKit
//
//  Created by 吴頔 on 2019/11/30.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import UIKit

public extension Dictionary {
    var queryString: String {
        return reduce("", { sum, add in sum + "&\(add.key)=\(add.value)" })
    }
}

public enum SSDataContainerParametersKey: String {
    case url = "FFRouterParameterURL"
    case id = "id"
    case object = "object"
    case list = "list"
    case goods = "goods"
    case order = "order"
}

public extension Dictionary where Key == AnyHashable, Value == Any {
    public func ss_string(_ key: SSDataContainerParametersKey) -> String? {
        ss_string(key.rawValue)
    }
    
    public func ss_number(_ key: SSDataContainerParametersKey) -> NSNumber? {
        ss_number(key.rawValue)
    }
    
    public func ss_int(_ key: SSDataContainerParametersKey) -> Int? {
        ss_int(key.rawValue)
    }
    
    public func ss_float(_ key: SSDataContainerParametersKey) -> Float? {
        ss_float(key.rawValue)
    }
    
    public func ss_bool(_ key: SSDataContainerParametersKey) -> Bool? {
        ss_bool(key.rawValue)
    }
    
    public func ss_object<T>(_ key: SSDataContainerParametersKey, _ type: T.Type) -> T? {
        ss_object(key.rawValue, type)
    }
    
    public func ss_array<T>(_ key: SSDataContainerParametersKey, _ type: T.Type) -> [T]? {
        ss_array(key.rawValue, type)
    }
}

public extension Dictionary where Key == AnyHashable, Value == Any {
    public func ss_string(_ key: String) -> String? {
        guard let value = self[key] else { return nil }
        return "\(value)"
    }

    public func ss_number(_ key: String) -> NSNumber? {
        return ss_string(key)?.ss_number
    }

    public func ss_int(_ key: String) -> Int? {
        return ss_number(key)?.intValue
    }

    public func ss_float(_ key: String) -> Float? {
        return ss_number(key)?.floatValue
    }

    public func ss_cgFloat(_ key: String) -> CGFloat? {
        guard let float = ss_number(key)?.floatValue else { return nil }
        return CGFloat(float)
    }

    public func ss_bool(_ key: String) -> Bool? {
        if let value = self[key] as? Bool {
            return value
        }else{
            return ss_number(key)?.boolValue
        }
    }

    public func ss_object<T>(_ key: String, _ type: T.Type) -> T? {
        return self[key] as? T
    }

    public func ss_array<T>(_ key: String, _ type: T.Type) -> [T]? {
        return self[key] as? [T]
    }
}
