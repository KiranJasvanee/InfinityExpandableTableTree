//
//  index_2_1_TableViewCell.swift
//  KJExpandableTableTree
//
//  Created by MAC241 on 12/05/17.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import UIKit

class index_2_1_TableViewCell: UITableViewCell {

    @IBOutlet weak var imageviewBackground: UIImageView!
    @IBOutlet weak var buttonState: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
