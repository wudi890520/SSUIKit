//
//  SSPhotoAlbum.swift
//  DeviceKit
//
//  Created by 吴頔 on 2019/12/10.
//

import UIKit
import TZImagePickerController
import RxCocoa
import RxSwift

public class SSPhotoAlbum: NSObject {

}

extension SSPhotoAlbum {
    public static func show(_ max: Int) -> Driver<[UIImage]?> {
        UIApplication.endEditing()

        if !SSPhotoPermission.album {
            return Driver.just(nil)
        }
        
        switch max {
        case 0:
            return Driver.just(nil)
        case 1:
            return single()
        default:
            return mutable(max)
        }
    }
}

extension SSPhotoAlbum {
    /// 相册单选
    ///
    /// - Returns: 图片数组
    static func single() -> Driver<[UIImage]?> {
        return Observable.create({ (observer) in
            /// 初始化picker
            let picker = createPicker()
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
    
    static func mutable(_ max: Int)  -> Driver<[UIImage]?> {
           return Observable.create({ (observer) in
               
               /// 初始化picker
               let delegateHandler = TZImagePickerControllerDelegateHandler()
               guard let picker = TZImagePickerController(maxImagesCount: max, delegate: delegateHandler) else {
                   observer.onNext(nil)
                   observer.onCompleted()
                   return Disposables.create()
               }
               picker.naviBgColor = UIColor(hexString: "#282828")
               picker.naviTitleFont = UIFont.boldSystemFont(ofSize: 17)
               picker.barItemTextFont = UIFont.systemFont(ofSize: 17)
               picker.doneBtnTitleStr = "发送"
               picker.allowTakeVideo = false
               picker.allowPickingVideo = false
               picker.allowPickingGif = false
               picker.showPhotoCannotSelectLayer = true
               picker.modalPresentationStyle = .fullScreen
               
               picker.didFinishPickingPhotosHandle = { photos, _, isOriginalPhoto in
                   guard let photos = photos else {
                       observer.onNext(nil)
                       observer.onCompleted();
                       return
                   }
                   if photos.isEmpty {
                       observer.onNext(nil)
                   }else{
                       let ups = photos.map{ $0.ss_orientationUp()! }
                       observer.onNext(ups)
                   }
                   observer.onCompleted()
               }
               UIApplication.rootViewController?.present(picker, animated: true, completion: nil)
               return Disposables.create()
           }).asDriver(onErrorJustReturn: nil)
       }
}

extension SSPhotoAlbum {
    private static func createPicker() -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.sourceType = .photoLibrary
        picker.allowsEditing = false
        return picker
    }
}

/// TZImagePickerControllerDelegateHandler
fileprivate class TZImagePickerControllerDelegateHandler: NSObject {
    var didFinishPicking: (([UIImage]) -> Void)?
    var didCancel: (() -> Void)?
}

// MARK: - TZImagePickerControllerDelegate
extension TZImagePickerControllerDelegateHandler: TZImagePickerControllerDelegate {
    func imagePickerController(_ picker: TZImagePickerController!, didFinishPickingPhotos photos: [UIImage]!, sourceAssets assets: [Any]!, isSelectOriginalPhoto: Bool) {
        didFinishPicking?(photos)
    }
    
    func tz_imagePickerControllerDidCancel(_ picker: TZImagePickerController!) {
        didCancel?()
    }
}
