//
//  Childs3rdStageTableViewCell.swift
//  Expandable3
//
//  Created by MAC241 on 11/05/17.
//  Copyright © 2017 KiranJasvanee. All rights reserved.
//

import UIKit

class Childs3rdStageTableViewCell: UITableViewCell {

    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var labelSubTitle: UILabel!
    @IBOutlet weak var labelIndex: UILabel!
    
    @IBOutlet weak var buttonState: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        labelTitle.font = UIFont(name: "HelveticaNeue-Bold", size: 15)
        labelSubTitle.font = UIFont(name: "HelveticaNeue-Bold", size: 15)
        labelIndex.font = UIFont(name: "HelveticaNeue-Bold", size: 14)
    }

    func cellFillUp(indexParam: String) {
        labelTitle.textColor = UIColor.white
        labelSubTitle.textColor = UIColor.white
        labelIndex.textColor = UIColor.white
        
        labelTitle.text = "Child custom cell"
        labelSubTitle.text = "Index of:"
        labelIndex.text = indexParam
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
