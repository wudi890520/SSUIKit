//
//  SSPhotoCamera.swift
//  DeviceKit
//
//  Created by 吴頔 on 2019/12/10.
//

import UIKit
import RxCocoa
import RxSwift

fileprivate class SSPhotoCameraPickerDelegate: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    static let shared = SSPhotoCameraPickerDelegate()
    
    var didFinishPicking: (([UIImagePickerController.InfoKey : Any]) -> Void)?
    var didCancel: (() -> Void)?
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        didFinishPicking?(info)
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        didCancel?()
        picker.dismiss(animated: true, completion: nil)
    }
}

public class SSPhotoCamera: NSObject {
    
}

extension SSPhotoCamera {
    public static func show() -> Driver<[UIImage]?> {
        UIApplication.endEditing()

        if SSPermission.request(.camera) != .allowed {
            return Driver.just(nil)
        }

        return Observable.create({ (observer) in
            
            /// 代理
            let delegateHandler = SSPhotoCameraPickerDelegate.shared
            
            /// 初始化picker
            let picker = SSPhotoCamera.createPicker(delegateHandler)
            
            /// 点击取消
            delegateHandler.didCancel = {
                observer.onNext(nil)
                observer.onCompleted()
            }
       
            /// 拍照完成并使用
            delegateHandler.didFinishPicking = { userInfo in
                /// 获取原图，并重新调整方向，另图片朝上
                if let image = userInfo[UIImagePickerController.InfoKey.originalImage] as? UIImage,
                    let up = image.ss_orientationUp() {
                    observer.onNext([up])
                }else{
                    observer.onNext(nil)
                }
                observer.onCompleted()
            }
            
            picker.modalPresentationStyle = .fullScreen
            UIApplication.rootViewController?.present(picker, animated: true, completion: nil)
            return Disposables.create()
        }).asDriver(onErrorJustReturn: nil)

    }
}

extension SSPhotoCamera {
    private static func createPicker<T>(_ delegateHandler: T) -> UIImagePickerController where T: UIImagePickerControllerDelegate, T: UINavigationControllerDelegate {
        let picker = UIImagePickerController()
        picker.sourceType = .camera
        picker.allowsEditing = false
        picker.cameraDevice = .rear
        picker.delegate = delegateHandler
        return picker
    }
}
