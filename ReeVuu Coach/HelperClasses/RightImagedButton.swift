//
//  RightImagedButton.swift
//  ReeVuu Coach
//
//  Created by Dev on 22/10/18.
//  Copyright © 2018 Dev. All rights reserved.
//

import UIKit

class RightImagedButton: UIButton {

    override func draw(_ rect: CGRect) {
       super.draw(rect)
        self.titleEdgeInsets = UIEdgeInsets.init(top: 0, left: -(self.imageView?.frame.size.width)!, bottom: 0, right: (self.imageView?.frame.size.width)!)
        self.imageEdgeInsets = UIEdgeInsets.init(top: 0, left: self.frame.size.width - (self.imageView?.frame.size.width)!, bottom: 0, right: 0)
    }


}
