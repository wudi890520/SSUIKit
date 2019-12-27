//
//  SSPhotoLibrary.swift
//  DeviceKit
//
//  Created by 吴頔 on 2019/12/10.
//

import UIKit
import TZImagePickerController
import RxCocoa
import RxSwift

public class SSPhotoLibrary: NSObject {

}

extension SSPhotoLibrary {
    public static func show(_ max: Int) -> Driver<[UIImage]?> {
        UIApplication.endEditing()

        if SSPermission.request(.photoLibrary) != .allowed {
            return Driver.just(nil)
        }
       
        switch max {
        case 0:
            return Driver.just(nil)
        default:
            return mutable(max)
        }
    }
}

extension SSPhotoLibrary {
    
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
               UIApplication.visiableController?.present(picker, animated: true, completion: nil)
               return Disposables.create()
           }).asDriver(onErrorJustReturn: nil)
       }
}

extension SSPhotoLibrary {
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
