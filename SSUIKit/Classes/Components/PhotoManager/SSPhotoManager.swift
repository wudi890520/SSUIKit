//
//  SSPhotoManager.swift
//  DeviceKit
//
//  Created by 吴頔 on 2019/12/10.
//

import UIKit
import RxSwift
import RxCocoa

class SSPhotoManager: NSObject {
    
}

extension SSPhotoManager {
    static func show(_ item: SSActionSheetButtonItem<Any>) -> Driver<[UIImage]?> {
        switch item {
        case .camera:
            return SSPhotoCamera.show()
        case .album(let max):
            return SSPhotoAlbum.show(max)
        default:
            return .just(nil)
        }
    }
}
