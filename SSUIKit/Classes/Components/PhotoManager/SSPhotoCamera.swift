//
//  SSPhotoCamera.swift
//  DeviceKit
//
//  Created by 吴頔 on 2019/12/10.
//

import UIKit
import RxCocoa
import RxSwift
import BlocksKit

public class SSPhotoCamera: NSObject {
    
}

extension SSPhotoCamera {
    public static func show() -> Driver<[UIImage]?> {
        UIApplication.endEditing()

        if !SSPhotoPermission.camera {
            return Driver.just(nil)
        }

        return Observable.create({ (observer) in
            /// 初始化picker
            let picker = SSPhotoCamera.createPicker()
            /// 点击取消
            picker.bk_didCancelBlock = { controller in
                observer.onNext(nil)
                observer.onCompleted()
                controller?.dismiss(animated: true, completion: nil)
            }
            /// 拍照完成并使用
            picker.bk_didFinishPickingMediaBlock = { controller, userInfo in
                /// 获取原图，并重新调整方向，另图片朝上
                if let image = userInfo?[UIImagePickerController.InfoKey.originalImage] as? UIImage,
                    let up = image.ss_orientationUp() {
                    observer.onNext([up])
                }else{
                    observer.onNext(nil)
                }
                observer.onCompleted()
                controller?.dismiss(animated: true, completion: nil)
            }
            picker.modalPresentationStyle = .fullScreen
            UIApplication.rootViewController?.present(picker, animated: true, completion: nil)
            return Disposables.create()
        }).asDriver(onErrorJustReturn: nil)

    }
}

extension SSPhotoCamera {
    private static func createPicker() -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.sourceType = .camera
        picker.allowsEditing = false
        picker.cameraDevice = .rear
        return picker
    }
}
