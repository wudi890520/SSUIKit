//
//  SSPhotoPermission.swift
//  DeviceKit
//
//  Created by 吴頔 on 2019/12/10.
//

import UIKit
import AVFoundation
import Photos

class SSPhotoPermission: NSObject {

    /// 无法打开相机
    static let noCameraPermission = "无法打开相机"
    
    /// 请到设置 -> 隐私 -> 相机服务站开启【省省回头车】相机服务
    static let cameraPermissionDescription = "请到设置 -> 隐私 -> 相机服务站开启【省省回头车】相机服务"
    
    /// 无法打开相册
    static let noPhotoLibraryPermission = "无法打开相册"
    
    /// 请到设置 -> 隐私 -> 相册服务站开启【省省回头车】相册服务
    static let photoLibraryPermissionDescription = "请到设置 -> 隐私 -> 相册服务站开启【省省回头车】相册服务"
    
    /// 去开启
    static let open = "去开启"
}

extension SSPhotoPermission {
    static var camera: Bool {
        let T = SSPhotoPermission.self
        let authStatus = AVCaptureDevice.authorizationStatus(for: .video)
        if authStatus == .restricted || authStatus == .denied {
            SSAlert.show(
            T.noCameraPermission,
            message: T.cameraPermissionDescription,
            confirmButtonTitle: T.open) { (isEnable) in
                if isEnable {
                    UIApplication.open()
                }
            }
            return false
        }
        return true
    }
    
    static var album: Bool {
        let T = SSPhotoPermission.self
        let authStatus = PHPhotoLibrary.authorizationStatus()
        if authStatus == .restricted || authStatus == .denied {
            SSAlert.show(
            T.noPhotoLibraryPermission,
            message: T.photoLibraryPermissionDescription,
            confirmButtonTitle: T.open) { (isEnable) in
                if isEnable {
                    UIApplication.open()
                }
            }
            return false
        }
        return true
    }
}
