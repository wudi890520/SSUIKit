//
//  SSBrowserDemoViewController.swift
//  SSUIKit_Example
//
//  Created by 吴頔 on 2019/12/12.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import UIKit
import SSUIKit
import QMUIKit

class SSBrowserDemoViewController: SSBaseViewController {

    static let images = [
        UIImage(named: "guide0")!,
        UIImage(named: "guide1")!,
        UIImage(named: "guide2")!,
        UIImage(named: "guide3")!
    ]
    
    static let urls = [
        "https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1576159656602&di=29798e825c53d73e9c2871803a988825&imgtype=0&src=http%3A%2F%2Fpic1.win4000.com%2Fwallpaper%2Ff%2F5850aab00d9fc.jpg",
        "https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1576754399&di=99dcbd81e7f4b74571f0d1c1681c3324&imgtype=jpg&er=1&src=http%3A%2F%2F00.minipic.eastday.com%2F20170706%2F20170706000054_d41d8cd98f00b204e9800998ecf8427e_4.jpeg",
        "https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1576159691459&di=eee87476836cdd0bec4d9a6ab0ff6d85&imgtype=0&src=http%3A%2F%2Fimg.zcool.cn%2Fcommunity%2F01017158328e6aa801219c777ba163.jpg%401280w_1l_2o_100sh.jpg",
        "https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1576159725659&di=d821f2530b435075106a1deb5efbeec4&imgtype=0&src=http%3A%2F%2Fzkres1.myzaker.com%2F201705%2F592263c7a07aec6a5504a3cd_640.jpg"
    ]
    
    let nativeTitle = UILabel()
        .ss_frame(x: 15, y: CGFloat.unsafeTop + 20, width: 100, height: 20)
        .ss_font(.largeDetail)
        .ss_text("本地图")

    let nativeButtons: [UIButton] = (0 ..< 4).map { (index) -> UIButton in
        UIButton()
            .ss_frame(x: 15+80*index.ss_cgFloat, y: CGFloat.unsafeTop + 50, width: 70, height: 70)
            .ss_layerCornerRadius(0)
            .ss_contentMode()
            .ss_image(UIImage(named: "guide\(index)"))
            .ss_tag(index)
            
    }
    
    let networkTitle = UILabel()
        .ss_frame(x: 15, y: CGFloat.unsafeTop + 150, width: 100, height: 20)
        .ss_font(.largeDetail)
        .ss_text("网络图")
    
    let networkButtons: [UIButton] = (0 ..< 4).map { (index) -> UIButton in
        UIButton()
            .ss_frame(x: 15+80*index.ss_cgFloat, y: CGFloat.unsafeTop + 180, width: 70, height: 70)
            .ss_contentMode()
            .ss_layerCornerRadius(0)
            .ss_tag(index)
    }
    
    /// 预览大图的控制器
    lazy private var imagePreviewViewController: QMUIImagePreviewViewController = {
        let controller = QMUIImagePreviewViewController()
        controller.presentingStyle = .zoom
        controller.dismissingStyle = .zoom
        return controller
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "大图预览"
        
        view.addSubview(nativeTitle)
        
        for v in nativeButtons {
            view.addSubview(v)
            
            v.rx.tap.asObservable()
                .subscribe(onNext: {[weak self] (_) in
                    self?.presentPhotoBrowser(v)
                })
                .disposed(by: dispose)
        }
        
        view.addSubview(networkTitle)
        
        for v in networkButtons {
            view.addSubview(v)
            v.kf.setImage(with: SSBrowserDemoViewController.urls[v.tag].ss_url, for: .normal)
            
            v.rx.tap.asDriver()
                .flatMapLatest{[weak self] _ in  SSPhotoBrowser.show(source: SSBrowserDemoViewController.urls, sourceImageViews: self?.networkButtons, currentIndex: v.tag, customViews: nil) }
                .drive()
                .disposed(by: dispose)
        }
        
        // Do any additional setup after loading the view.
    }

    func presentPhotoBrowser(_ btn: UIButton?) {
        
        let browser = SSPhotoBrowser(source: SSBrowserDemoViewController.images, sourceImageViews: nativeButtons, currentIndex: btn?.tag ?? 0, customViews: nil)
        browser.didScrollTo = { index in
            print(index)
        }
        
        
//        imagePreviewViewController.imagePreviewView.delegate = self
//        imagePreviewViewController.imagePreviewView.currentImageIndex = UInt(btn?.tag ?? 0)
//        imagePreviewViewController.sourceImageView = { [weak self] in
//            let currentIndex = self?.imagePreviewViewController.imagePreviewView.currentImageIndex ?? 0
//            let view = self?.nativeButtons[Int(currentIndex)]
//            print(view?.frame)
//            return view
//        }
//        UIApplication.rootViewController?.present(imagePreviewViewController, animated: true, completion: nil)
//        self.present(imagePreviewViewController, animated: true, completion: nil)
        
//        SSPhotoBrowser.present(source: SSBrowserDemoViewController.images, sourceImageViews: nativeButtons, currentIndex: btn?.tag ?? 0, customViews: nil) { (index) in
//            print("index did change === \(index)")
//        }
    }
}

extension SSBrowserDemoViewController: QMUIImagePreviewViewDelegate {
    
    /// 有多少个图片
    func numberOfImages(in imagePreviewView: QMUIImagePreviewView!) -> UInt {
        return UInt(SSBrowserDemoViewController.images.count)
    }
    
    /// 加载大图
    func imagePreviewView(_ imagePreviewView: QMUIImagePreviewView!, renderZoomImageView zoomImageView: QMUIZoomImageView!, at index: UInt) {
        
        zoomImageView.image = SSBrowserDemoViewController.images[Int(index)]
//
//        /// 加载中
//        zoomImageView.showLoading()
//
//        /// 向极光请求大图数据
//        content?.largeImageData(progress: nil, completionHandler: {[weak self] (data, _, error) in
//            zoomImageView.hideEmpty()
//            guard let data = data else { return }
//            guard let image = UIImage(data: data) else { return }
//            zoomImageView.image = image
//            self?.largeImage = image
//            self?.contentImageView.image = image
//        })
    }
    
    /// 采用 QMUIImagePreviewMediaImage 策略
    func imagePreviewView(_ imagePreviewView: QMUIImagePreviewView!, assetTypeAt index: UInt) -> QMUIImagePreviewMediaType {
        return .image
    }
}

extension SSBrowserDemoViewController: QMUIZoomImageViewDelegate {
    
    /// 图片放大后，点击图片，缩小返回
    func singleTouch(inZooming zoomImageView: QMUIZoomImageView!, location: CGPoint) {
        imagePreviewViewController.dismiss(animated: true, completion: nil)
    }
}
