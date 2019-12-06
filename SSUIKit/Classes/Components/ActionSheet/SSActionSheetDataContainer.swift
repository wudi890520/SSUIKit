//
//  SSActionSheetDataContainer.swift
//  SSUIKit_Example
//
//  Created by 吴頔 on 2019/12/5.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class SSActionSheetDataContainer: NSObject {

    let selected: Driver<Int>
    
    private let selectedBehavior = BehaviorRelay<Int?>(value: nil)
    
    var dataSource: [SSActionSheetButtonItemData] = []
    
    override init() {
        selected = selectedBehavior.asDriver().filterNil()
        super.init()
    }
}

extension SSActionSheetDataContainer: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: SSActionSheetTableViewCell = tableView.dequeueReusableCell(withIdentifier: "SSActionSheetTableViewCell", for: indexPath) as! SSActionSheetTableViewCell
        let data = dataSource[indexPath.row]
        cell.titleLabel.text = data.title
        cell.titleLabel.textColor = data.titleColor
        cell.line.isHidden = indexPath.row == 0
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        selectedBehavior.accept(indexPath.row)
    }
}
