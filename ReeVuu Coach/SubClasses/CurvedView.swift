//
//  CurvedView.swift
//  ReeVuu Coach
//
//  Created by Dev on 17/10/18.
//  Copyright © 2018 Dev. All rights reserved.
//

import UIKit

class CurvedView: UIView {

  
    var once = true
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if once {
            
            let bb = UIBezierPath()
            
            bb.move(to: CGPoint(x: 0, y: self.frame.size.height))
            
            // the offset here is 40 you can play with it to increase / decrease the curve height
            
            bb.addQuadCurve(to: CGPoint(x: self.frame.width, y: self.frame.size.height), controlPoint: CGPoint(x: self.frame.width / 2 , y: self.frame.size.height + 56))
            
            bb.close()
            
            let l = CAShapeLayer()
            
            l.path = bb.cgPath
            
            l.fillColor =  UIColor.black.cgColor
            self.layer.insertSublayer(l,at:0)

            once = false
        }
        
    }


    
    
}
