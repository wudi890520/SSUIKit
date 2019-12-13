//
//  SSPhotoBrowser.swift
//  BlocksKit
//
//  Created by 吴頔 on 2019/12/12.
//

import UIKit
import QMUIKit
import Kingfisher
import RxCocoa
import RxSwift

public class SSPhotoBrowser: NSObject {
    
    public var singleTouch: ((Void) -> Void)?
    
    public var didScrollTo: ((Int) -> Void)?
    
    lazy var previewController: QMUIImagePreviewViewController = {
        let controller = QMUIImagePreviewViewController()
        controller.presentingStyle = .zoom
        controller.dismissingStyle = .zoom
        return controller
    }()
  
    var urls: [URL]?
    var images: [UIImage]?
    
    public init(source: Any?,
         sourceImageViews: [UIView]? = nil,
         currentIndex: Int = 0,
         customViews: [UIView]? = nil) {
        super.init()
        
        if let images = source as? [UIImage] {
            self.images = images
        }else if let urls = source as? [URL] {
            self.urls = urls
        }else if let strings = source as? [String] {
            self.urls = strings.map{ $0.ss_url }.filter{ $0 != nil }.map{ $0! }
        }
   
        previewController.imagePreviewView.delegate = self
        previewController.imagePreviewView.currentImageIndex = UInt(currentIndex)
        previewController.sourceImageView = {
            let view = sourceImageViews?[currentIndex]
            print(view?.frame)
            return view
        }
        
        UIApplication.rootViewController?.present(previewController, animated: true, completion: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension SSPhotoBrowser: QMUIImagePreviewViewDelegate {
    public func numberOfImages(in imagePreviewView: QMUIImagePreviewView!) -> UInt {
        if let images = self.images {
            return UInt(images.count)
        }else if let urls = self.urls {
            return UInt(urls.count)
        }
        return 4
    }
       
    /// 加载大图
    public func imagePreviewView(_ imagePreviewView: QMUIImagePreviewView!, renderZoomImageView zoomImageView: QMUIZoomImageView!, at index: UInt) {
       
        if let images = images {
            zoomImageView.image = images[Int(index)]
        }else if let urls = urls{
            /// 加载中
            zoomImageView.showLoading()
            let url = urls[Int(index)]
            ImageDownloader.default.downloadImage(with: url, options: nil) { (result) in
                switch result {
                case let .success(response):
                    let image = response.image
                    zoomImageView.hideEmpty()
                    zoomImageView.image = image
                    
                case let .failure(error):
                    print(error.errorDescription as Any)
                }
            }
        }
    }

    /// 采用 QMUIImagePreviewMediaImage 策略
    public func imagePreviewView(_ imagePreviewView: QMUIImagePreviewView!, assetTypeAt index: UInt) -> QMUIImagePreviewMediaType {
       return .image
    }

//    public func imagePreviewView(_ imagePreviewView: QMUIImagePreviewView!, didScrollTo index: UInt) {
//        self.didScrollTo?(Int(index))
//    }
}

extension SSPhotoBrowser: QMUIZoomImageViewDelegate {

    /// 图片放大后，点击图片，缩小返回
    public func singleTouch(inZooming zoomImageView: QMUIZoomImageView!, location: CGPoint) {
        self.singleTouch?(())
        previewController.dismiss(animated: true, completion: nil)
    }
    
}

public extension SSPhotoBrowser {
    static func present(
        source: Any?,
        sourceImageViews: [UIView]? = nil,
        currentIndex: Int = 0,
        customViews: [UIView]? = nil,
        indexDidChange: ((Int) -> Void)? = nil) {
        
        let browser = SSPhotoBrowser(
            source: source,
            sourceImageViews: sourceImageViews,
            currentIndex: currentIndex,
            customViews: customViews
        )
        browser.didScrollTo = indexDidChange

    }
}

public extension SSPhotoBrowser {
    static func show(
        source: Any?,
        sourceImageViews: [UIView]? = nil,
        currentIndex: Int = 0,
        customViews: [UIView]? = nil
        ) -> Driver<Int> {
        
        return Observable.create { (observer) in
            let browser = SSPhotoBrowser(
                source: source,
                sourceImageViews: sourceImageViews,
                currentIndex: currentIndex,
                customViews: customViews
            )
            
            browser.didScrollTo = { index in
                observer.onNext(index)
            }
            
            browser.singleTouch = { _ in
                observer.onCompleted()
            }
                        
            return Disposables.create()
        }.asDriver(onErrorJustReturn: currentIndex)

    }
}
