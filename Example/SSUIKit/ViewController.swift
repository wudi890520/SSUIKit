//
//  ViewController.swift
//  SSUIKit
//
//  Created by wudi890520 on 11/29/2019.
//  Copyright (c) 2019 wudi890520. All rights reserved.
//

import UIKit
import SSUIKit
import CoreLocation

class ViewController: UIViewController {

    let demoView = UIView()
        .ss_frame(rect: UIScreen.main.bounds)
        .ss_tag(1)
        .ss_backgroundColor(UIColor.ss.white)
    
    let fontA = UIFont.Title.large.bold
    
    let fontB: UIFont = .largeTitle
    
    let fontC: UIFont = UIFont.with(10).bold
    
    let fontD: UIFont = .bold(10)
    
    let coor = CLLocationCoordinate2DMake(23.123456, 113.987654)
 
    override func viewDidLoad() {
        super.viewDidLoad()
   
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

