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
            
            bb.move(to: CGPoint(x: 0, y: 0))
           
            bb.addQuadCurve(to: CGPoint(x: self.frame.size.width, y: 0), controlPoint: CGPoint(x: self.frame.size.width / 2 , y: 0 + 90))
            bb.addLine(to: CGPoint(x:self.frame.size.width, y: 0))
            
            bb.addLine(to: CGPoint(x:self.frame.size.width, y: self.frame.size.height))
            bb.addLine(to: CGPoint(x:0, y: self.frame.size.height))
            bb.addLine(to: CGPoint(x:0, y: 0))
            //bb.close()
            let l = CAShapeLayer()
            l.path = bb.cgPath
            
            l.fillColor = UIColor.white.cgColor  //UIColor.black.cgColor
            self.layer.insertSublayer(l,at:0)
            once = false
        }
        
    }


    
    
}
class PointingView: UIView {
    
    
    var once = true
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if once {
            
            let bb = UIBezierPath()
            
            bb.move(to: CGPoint(x: self.frame.size.width/2-8, y: self.frame.size.height))
            
            bb.addLine(to: CGPoint(x:self.frame.size.width/2, y:self.frame.size.height+8))
            
            bb.addLine(to: CGPoint(x:self.frame.size.width/2+8, y: self.frame.size.height))
            bb.close()
            let l = CAShapeLayer()
            l.path = bb.cgPath
            
            l.fillColor = UIColor.white.cgColor
            //UIColor.black.cgColor
            self.layer.addSublayer(l)
            once = false
        }
        
    }
    
    
    
    
}
