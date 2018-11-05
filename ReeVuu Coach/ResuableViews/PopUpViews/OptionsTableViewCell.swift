//
//  OptionsTableViewCell.swift
//  ReeVuu Coach
//
//  Created by Dev on 23/10/18.
//  Copyright © 2018 Dev. All rights reserved.
//

import UIKit

class OptionsTableViewCell: UITableViewCell {
@IBOutlet weak var lblOption: UILabel!
    @IBOutlet weak var btnOptionSelect: UIButton!
    
    @IBOutlet weak var lblSeparator: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
