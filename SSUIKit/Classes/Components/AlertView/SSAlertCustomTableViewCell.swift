//
//  SSAlertCustomTableViewCell.swift
//  DeviceKit
//
//  Created by 吴頔 on 2019/12/7.
//

import UIKit

class SSAlertCustomTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
        accessoryType = .none
        tintColor = .ss_main
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        if selected {
            accessoryType = .checkmark
        }else{
            accessoryType = .none
        }
        // Configure the view for the selected state
    }
    
}
