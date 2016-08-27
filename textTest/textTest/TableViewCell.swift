//
//  TableViewCell.swift
//  textTest
//
//  Created by Lai Zih Ci on 2016/8/25.
//  Copyright © 2016年 ZihCiLai. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell {

    @IBOutlet weak var label: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
