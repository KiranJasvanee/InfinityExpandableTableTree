//
//  1dot1_TableViewCell.swift
//  KJExpandableTableTree
//
//  Created by MAC241 on 12/05/17.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import UIKit

class _dot1_TableViewCell: UITableViewCell {

    @IBOutlet weak var labelIndex: UILabel!
    @IBOutlet weak var buttonState: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        labelIndex.font = UIFont(name: "HelveticaNeue-Bold", size: 14)
    }

    func cellFillUp(indexParam: String) {
        
        labelIndex.text = "Custom cell - Index: \(indexParam)"
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
