//
//  SSDemoTableViewCell.swift
//  SSUIKit_Example
//
//  Created by 吴頔 on 2019/12/6.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import UIKit

class SSDemoTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        textLabel?.numberOfLines = 0
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
