//
//  SSBannerDemoViewController.swift
//  SSUIKit_Example
//
//  Created by 吴頔 on 2019/12/9.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import UIKit
import SSUIKit
import RxSwift
import RxCocoa

class SSBannerDemoViewController: UIViewController {

    let tableView = UITableView()
        .ss_frame(rect: UIScreen.main.bounds)
    
    let dataSource: [String] = [
        "本地图片",
        "网络图片",
        "CoverFlow"
    ]
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Banner的使用"
        view.backgroundColor = .ss_background
        view.ss_add(tableView)
        tableView.register(SSDemoTableViewCell.self, forCellReuseIdentifier: "SSDemoTableViewCell")
        tableView.delegate = self
        tableView.dataSource = self
    }
 
}

extension SSBannerDemoViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: SSDemoTableViewCell = tableView.dequeueReusableCell(withIdentifier: "SSDemoTableViewCell", for: indexPath) as! SSDemoTableViewCell
        cell.textLabel?.text = dataSource[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        var controller: UIViewController?
        switch dataSource[indexPath.row] {
        case "本地图片": controller = SSBannerNativeDemoViewController()
        case "网络图片": controller = SSBannerNetworkDemoViewController()
        case "CoverFlow": controller = SSBannerTransformDemoViewController()
        default: break
        }
        if let vc = controller {
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}

class SSBannerNativeDemoViewController: UIViewController {
    
    let banner = SSBannerView()
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .ss_background
        view.addSubview(banner.bannerView)
        
        banner.bannerView.isInfinite = false
        banner.bannerView.bounces = false
        banner.bannerView.automaticSlidingInterval = 0
        
        banner.bannerView.snp.makeConstraints { (make) in
            make.left.right.top.bottom.equalToSuperview()
        }
        
        let images: [UIImage?] = [
            UIImage(named: "guide0"),
            UIImage(named: "guide1"),
            UIImage(named: "guide2"),
            UIImage(named: "guide3")
        ]
     
        Driver.just(images)
            .drive(banner.dataSource.rx.dataSource)
            .disposed(by: disposeBag)
                
        banner.dataSource.rx.tap
            .subscribe(onNext: {[weak self] (_) in
                self?.navigationController?.popViewController(animated: true)
            })
            .disposed(by: disposeBag)
    }
}

class SSBannerNetworkDemoViewController: UIViewController {
    let banner = SSBannerView()
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .ss_background
        view.addSubview(banner.bannerView)
        
        banner.bannerView.snp.makeConstraints { (make) in
            make.left.equalTo(15)
            make.right.equalToSuperview().offset(-15)
            make.top.equalToSuperview().offset(100)
            make.height.equalTo(200)
        }
        
        let dataSource: [SSBannerImageItem] = [
            SSBannerImageItem(source: "https://img.huitouche.com/20191118/014f5c6581067165ee4d7c3d27dadd771.png", page: "https://mp.huitouche.com/index/?url=actives/education/earn-strategy.html"),
            SSBannerImageItem(source: "https://img.huitouche.com/20190827/08fc6026d9e6a9d615afbd4c04545b6ff.jpg", page: "https://mp.huitouche.com/index/?url=actives/phone_bill/index.html"),
        ]
       
        Driver.just(dataSource).drive(banner.dataSource.rx.dataSource).disposed(by: disposeBag)
        
        banner.dataSource.rx.tap.asObservable()
            .subscribe(onNext: { (item) in
                SSToast.show(item.page)
            })
            .disposed(by: disposeBag)
        
    }
}

class SSBannerTransformDemoViewController: UIViewController {
    static let bannerWidth = (CGFloat.screenWith - 40)
    static let bannerHeight = bannerWidth / 2.875
    let banner = SSBannerView(isNeedTransformer: true, itemSize: CGSize(width: bannerWidth, height: bannerHeight))
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .ss_background
        view.addSubview(banner.bannerView)
        
        banner.dataSource.cornerRadius = 5
        
        banner.bannerView.snp.makeConstraints { (make) in
            make.left.equalTo(0)
            make.right.equalToSuperview()
            make.top.equalToSuperview().offset(40)
            make.height.equalTo(300)
        }
      
        let dataSource: [SSBannerImageItem] = [
            SSBannerImageItem(source: "https://img.huitouche.com/20191118/014f5c6581067165ee4d7c3d27dadd771.png", page: "https://mp.huitouche.com/index/?url=actives/education/earn-strategy.html"),
            SSBannerImageItem(source: "https://img.huitouche.com/20190827/08fc6026d9e6a9d615afbd4c04545b6ff.jpg", page: "https://mp.huitouche.com/index/?url=actives/phone_bill/index.html"),
        ]
       
        Driver.just(dataSource).drive(banner.dataSource.rx.dataSource).disposed(by: disposeBag)
        
        banner.dataSource.rx.tap.asObservable()
            .subscribe(onNext: { (item) in
                SSToast.show(item.page)
            })
            .disposed(by: disposeBag)
        
    }
}
