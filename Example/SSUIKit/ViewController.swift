//
//  ViewController.swift
//  SSUIKit
//
//  Created by wudi890520 on 11/29/2019.
//  Copyright (c) 2019 wudi890520. All rights reserved.
//

import UIKit
import CoreLocation
import SSUIKit
import RxCocoa
import RxSwift

class ViewController: UIViewController {

    let demoView = TextField()
        .ss_keyboardType(.decimal)
        .ss_showDismissButtonItem()
        .ss_frame(x: 40, y: 50, width: 120, height: 44)
        .ss_layerCornerRadius()
        .ss_backgroundColor(.ss_background)

    let fontA = UIFont.Title.large.bold

    let fontB: UIFont = .largeTitle

    let fontC: UIFont = UIFont.with(10).bold

    let fontD: UIFont = .bold(10)

    let now = TimeInterval.ss_current
    
    let coor = CLLocationCoordinate2DMake(23.123456, 113.987654)

    let attribute = ""
    
    let dispose = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.ss_add(demoView)
    
        perform(#selector(showActionSheet), afterDelay: 3)
        
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}


extension ViewController {
    @objc func showActionSheet() {
        let items: [SSActionSheetButtonItem<Int>] = [
            .custom(title: "相册", titleColor: .ss_red, extra: 10),
            .custom(title: "拍照", titleColor: .ss_blue, extra: 50),
            .destructive(title: "删除", extra: nil)
        ]
        
        SSActionSheet.show(nil, buttonItems: items)
            .asObservable()
            .subscribe(onNext: {[weak self] (extra) in
                print(extra)
                self?.showPhotoSheet()
            })
            .disposed(by: dispose)
    }
    
    @objc func showPhotoSheet() {
        SSActionSheet.photo()
            .asObservable()
            .subscribe(onNext: { (item) in
        
                if item == .camera {
                    print("拍照")
                }else if item == .album {
                    print("从相册选择")
                }
            })
            .disposed(by: dispose)
    }
}
