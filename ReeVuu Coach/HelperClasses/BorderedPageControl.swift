//
//  BorderedPageControl.swift
//  ReeVuu Coach
//
//  Created by Dev on 18/10/18.
//  Copyright © 2018 Dev. All rights reserved.
//

import UIKit

class BorderedPageControl: UIPageControl {
   
    override func draw(_ rect: CGRect) {
   
        super.draw(rect)
        for (pageIndex, dotView) in self.subviews.enumerated() {
            //dotView.layer.setAffineTransform(CGAffineTransform.init(scaleX: 1.5, y: 1.5))
            if self.currentPage == pageIndex {
                dotView.backgroundColor = KAppThemeColor
                dotView.layer.cornerRadius = dotView.frame.size.height / 2
                
            }else{
                dotView.backgroundColor = .clear
                dotView.layer.cornerRadius = dotView.frame.size.height / 2
                dotView.layer.borderColor = KAppThemeColor.cgColor
                dotView.layer.borderWidth = 1
            }
        }
    }
    
}
