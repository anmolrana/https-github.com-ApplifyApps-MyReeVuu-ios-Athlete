//
//  QuesTwoCollViewCell.swift
//  ReeVuu Coach
//
//  Created by Dev on 23/10/18.
//  Copyright © 2018 Dev. All rights reserved.
//

import UIKit

class QuesTwoCollViewCell: UICollectionViewCell {
    
    @IBOutlet weak var btnOption: UIButton!
    
    @IBAction func actionBtnOption(_ sender: UIButton) {
    }
    
    
    func configure(data: OptionModal) {
        btnOption.setTitle(data.options, for: .normal)
        if data.isSelected{
            btnOption.backgroundColor = AppColors.blue
            btnOption.borderColor = AppColors.blue
        }else{
            btnOption.backgroundColor = UIColor.clear
            btnOption.borderColor = AppColors.gray
        }
    }
    
    func setBackgroundColor(isSelected: Bool) {
        if isSelected{
            btnOption.backgroundColor = AppColors.blue
            btnOption.borderColor = AppColors.blue
        }else{
            btnOption.backgroundColor = UIColor.clear
            btnOption.borderColor = AppColors.gray
        }
    }
    
}
