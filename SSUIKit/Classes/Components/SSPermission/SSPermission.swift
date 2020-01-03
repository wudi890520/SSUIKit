//
//  SSPermission.swift
//  BlocksKit
//
//  Created by 吴頔 on 2019/12/14.
//

import UIKit
import RxCocoa
import RxSwift

public typealias SSPermissionType = SPPermissionType

public extension SPPermissionType {
    
    var isAllowed: Bool {
        return SPPermission.isAllowed(self)
    }
    
    var isDenied: Bool {
        return SPPermission.isDenied(self)
    }
    
    var isNotDetermined: Bool {
        return !isAllowed && !isDenied
    }
    
    var alertTitle: String? {
        switch self {
        case .microphone: return SSPermissionConfiguration.shared.microphone.title
        case .locationAlwaysAndWhenInUse: return SSPermissionConfiguration.shared.location.title
        case .notification: return SSPermissionConfiguration.shared.notification.title
        case .camera: return SSPermissionConfiguration.shared.camera.title
        case .photoLibrary: return SSPermissionConfiguration.shared.photoLibrary.title
        case .contacts: return SSPermissionConfiguration.shared.contacts.title
        default: return nil
        }
    }
    
    var alertMessage: String? {
        switch self {
        case .microphone: return SSPermissionConfiguration.shared.microphone.message
        case .locationAlwaysAndWhenInUse: return SSPermissionConfiguration.shared.location.message
        case .notification: return SSPermissionConfiguration.shared.notification.message
        case .camera: return SSPermissionConfiguration.shared.camera.message
        case .photoLibrary: return SSPermissionConfiguration.shared.photoLibrary.message
        case .contacts: return SSPermissionConfiguration.shared.contacts.message
        default: return nil
        }
    }
    
    var cancel: String? {
        switch self {
        case .microphone: return SSPermissionConfiguration.shared.microphone.cancel
        case .locationAlwaysAndWhenInUse: return SSPermissionConfiguration.shared.location.cancel
        case .notification: return SSPermissionConfiguration.shared.notification.cancel
        case .camera: return SSPermissionConfiguration.shared.camera.cancel
        case .photoLibrary: return SSPermissionConfiguration.shared.photoLibrary.cancel
        case .contacts: return SSPermissionConfiguration.shared.contacts.cancel
        default: return nil
        }
    }
    
    var confirm: String? {
        switch self {
        case .microphone: return SSPermissionConfiguration.shared.microphone.confirm
        case .locationAlwaysAndWhenInUse: return SSPermissionConfiguration.shared.location.confirm
        case .notification: return SSPermissionConfiguration.shared.notification.confirm
        case .camera: return SSPermissionConfiguration.shared.camera.confirm
        case .photoLibrary: return SSPermissionConfiguration.shared.photoLibrary.confirm
        case .contacts: return SSPermissionConfiguration.shared.contacts.confirm
        default: return nil
        }
    }
}

public enum SSPermissionStatus {
    case allowed
    case denied
    case notDetermined
}

public class SSPermission: NSObject {
    public static var rx: SSRxPermission.Type { SSRxPermission.self }
}

public class SSRxPermission: NSObject {
    public static func request(_ permissionType: SSPermissionType, isNeedOpenSystemSetting: Bool = true) -> Driver<SSPermissionStatus> {
        return Observable.create({ observer in
            
            if permissionType.isNotDetermined {
                SPPermission.request(permissionType, with: {
                    let isAllow = SPPermission.isAllowed(permissionType)
                    observer.onNext(.allowed)
                    observer.onCompleted()
                })
            }else if permissionType.isDenied {
                if !isNeedOpenSystemSetting {
                    observer.onNext(.denied)
                    observer.onCompleted()
                }else{
                    SSAlert.showConfirm(
                        title: permissionType.alertTitle,
                        message: permissionType.alertMessage,
                        cancelButtonTitle: permissionType.cancel ?? "",
                        confirmButtonTitle: permissionType.confirm ?? ""
                        ) { (enable) in
                            if enable {
                                UIApplication.open()
                            }else{
                                observer.onNext(.denied)
                                observer.onCompleted()
                            }
                    }
                }
          
            }else{
                observer.onNext(.allowed)
                observer.onCompleted()
            }
            
            return Disposables.create()
        }).asDriver(onErrorJustReturn: .notDetermined)
    }
}

public extension SSPermission {
    public static func request(_ permissionType: SSPermissionType, isNeedOpenSystemSetting: Bool = true) -> SSPermissionStatus {
        if permissionType.isNotDetermined {
            SPPermission.request(permissionType) {}
            return .notDetermined
        }else if permissionType.isDenied {
            if !isNeedOpenSystemSetting {
                return .denied
            }
            SSAlert.showConfirm(
                title: permissionType.alertTitle,
                message: permissionType.alertMessage,
                cancelButtonTitle: permissionType.cancel ?? "",
                confirmButtonTitle: permissionType.confirm ?? ""
                ) { (enable) in
                    if enable {
                        UIApplication.open()
                    }
                }
            return .denied
        }else{
            return .allowed
        }
    }
}
