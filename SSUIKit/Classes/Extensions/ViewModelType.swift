//
//  ViewModel.swift
//  SSUIKit_Example
//
//  Created by 吴頔 on 2019/12/4.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import UIKit

protocol SSViewModelType {
    
    associatedtype Input
    associatedtype Output
    
    func transform(input: Input) -> Output

}
