//
//  SSPermissionConfiguration.swift
//  BlocksKit
//
//  Created by 吴頔 on 2019/12/14.
//

import UIKit

protocol SSPermissonTextElement {
    var title: String? { get set }
    var message: String? { get set }
    var cancel: String? { get set }
    var confirm: String? { get set }
}

class SSMicrophonePermission: SSPermissonTextElement {
    var title: String? = "无法录音"
    
    var message: String? = "请在iPhone的“设置-隐私-麦克风”选择中，允许省省回头车访问您的手机麦克风。"
    
    var cancel: String? = "暂不开启"
    
    var confirm: String? = "去开启"
}

class SSLocationPermission: SSPermissonTextElement {
    var title: String? = "请开启定位服务"
    
    var message: String? = "我们建议您开启定位服务，这样系统可以向您推荐附近的车源、货源、以及附近是否有交警查车。"
    
    var cancel: String? = "暂不开启"
    
    var confirm: String? = "开启定位"
}

class SSNotificationPermission: SSPermissonTextElement {
    var title: String? = "请开启通知服务"
    
    var message: String? = "我们建议您开启通知服务，这样可以实时的收到货源消息、订单变更消息、钱包消息、及聊天等其他消息。"
    
    var cancel: String? = "暂不开启"
    
    var confirm: String? = "开启通知"
}

class SSCameraPermission: SSPermissonTextElement {
    var title: String? = "无法打开相机"
    
    var message: String? = "请到设置 -> 隐私 -> 相机服务开启【省省回头车】相机服务"
    
    var cancel: String? = "暂不开启"
    
    var confirm: String? = "去开启"
}

class SSPhotoLibraryPermission: SSPermissonTextElement {
    var title: String? = "无法打开相册"
    
    var message: String? = "请到设置 -> 隐私 -> 相册服务开启【省省回头车】相册服务"
    
    var cancel: String? = "暂不开启"
    
    var confirm: String? = "去开启"
}

class SSContactsPermission: SSPermissonTextElement {
    var title: String? = "无法打开通讯录"
    
    var message: String? = "请到设置 -> 隐私 -> 通讯录服务开启【省省回头车】通讯录服务"
    
    var cancel: String? = "暂不开启"
    
    var confirm: String? = "去开启"
}

public class SSPermissionConfiguration: NSObject {

    static let shared = SSPermissionConfiguration()
    
    /// 麦克风
    internal let microphone = SSMicrophonePermission()
    
    /// 定位
    internal let location = SSLocationPermission()
    
    /// 推送
    internal let notification = SSNotificationPermission()
    
    /// 相机
    internal let camera = SSCameraPermission()
    
    /// 相册
    internal let photoLibrary = SSPhotoLibraryPermission()
    
    /// 通讯录
    internal let contacts = SSContactsPermission()
}

public extension SSPermissionConfiguration {
    struct Microphone {
        public static var title: String? = "无法录音" {
            didSet { SSPermissionConfiguration.shared.microphone.title = title }
        }
        
        public static var message: String? = "请在iPhone的“设置-隐私-麦克风”选择中，允许省省回头车访问您的手机麦克风。" {
            didSet { SSPermissionConfiguration.shared.microphone.message = message }
        }
        
        public static var cancel: String? = "暂不开启" {
            didSet { SSPermissionConfiguration.shared.microphone.cancel = cancel }
        }
        
        public static var confirm: String? = "去开启" {
            didSet { SSPermissionConfiguration.shared.microphone.confirm = confirm }
        }

    }
    
    struct Location {
        public static var title: String? = "请开启定位服务" {
            didSet { SSPermissionConfiguration.shared.location.title = title }
        }
        
        public static var message: String? = "我们建议您开启定位服务，这样系统可以向您推荐附近的车源、货源、以及附近是否有交警查车。" {
            didSet { SSPermissionConfiguration.shared.location.message = message }
        }
        
        public static var cancel: String? = "暂不开启" {
            didSet { SSPermissionConfiguration.shared.location.cancel = cancel }
        }
        
        public static var confirm: String? = "去开启" {
            didSet { SSPermissionConfiguration.shared.location.confirm = confirm }
        }

    }
    
    struct Notification {
        public static var title: String? = "请开启通知服务" {
            didSet { SSPermissionConfiguration.shared.notification.title = title }
        }
        
        public static var message: String? = "我们建议您开启通知服务，这样可以实时的收到货源消息、订单变更消息、钱包消息、及聊天等其他消息。" {
            didSet { SSPermissionConfiguration.shared.notification.message = message }
        }
        
        public static var cancel: String? = "暂不开启" {
            didSet { SSPermissionConfiguration.shared.notification.cancel = cancel }
        }
        
        public static var confirm: String? = "去开启" {
            didSet { SSPermissionConfiguration.shared.notification.confirm = confirm }
        }

    }
    
    struct Camera {
        public static var title: String? = "无法打开相机" {
            didSet { SSPermissionConfiguration.shared.camera.title = title }
        }
        
        public static var message: String? = "请到设置 -> 隐私 -> 相机服务开启【省省回头车】相机服务" {
            didSet { SSPermissionConfiguration.shared.camera.message = message }
        }
        
        public static var cancel: String? = "暂不开启" {
            didSet { SSPermissionConfiguration.shared.camera.cancel = cancel }
        }
        
        public static var confirm: String? = "去开启" {
            didSet { SSPermissionConfiguration.shared.camera.confirm = confirm }
        }

    }
    
    struct PhotoLibrary {
        public static var title: String? = "无法打开相册" {
            didSet { SSPermissionConfiguration.shared.photoLibrary.title = title }
        }
        
        public static var message: String? = "请到设置 -> 隐私 -> 相册服务开启【省省回头车】相册服务" {
            didSet { SSPermissionConfiguration.shared.photoLibrary.message = message }
        }
        
        public static var cancel: String? = "暂不开启" {
            didSet { SSPermissionConfiguration.shared.photoLibrary.cancel = cancel }
        }
        
        public static var confirm: String? = "去开启" {
            didSet { SSPermissionConfiguration.shared.photoLibrary.confirm = confirm }
        }

    }
    
    struct Contacts {
        public static var title: String? = "无法打开通讯录" {
            didSet { SSPermissionConfiguration.shared.contacts.title = title }
        }
        
        public static var message: String? = "请到设置 -> 隐私 -> 通讯录服务开启【省省回头车】通讯录服务" {
            didSet { SSPermissionConfiguration.shared.contacts.message = message }
        }
        
        public static var cancel: String? = "暂不开启" {
            didSet { SSPermissionConfiguration.shared.contacts.cancel = cancel }
        }
        
        public static var confirm: String? = "去开启" {
            didSet { SSPermissionConfiguration.shared.photoLibrary.confirm = confirm }
        }

    }
}
