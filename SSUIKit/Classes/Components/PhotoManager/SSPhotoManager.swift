//
//  SSPhotoManager.swift
//  DeviceKit
//
//  Created by 吴頔 on 2019/12/10.
//

import UIKit
import RxSwift
import RxCocoa

public class SSPhotoManager: NSObject {
    
}

extension SSPhotoManager {
    public static func show(_ item: SSActionSheetButtonItem<Any>) -> Driver<[UIImage]?> {
        switch item {
        case .camera:
            return SSPhotoCamera.show()
        case .album(let max):
            return SSPhotoLibrary.show(max)
        default:
            return .just(nil)
        }
    }
}
