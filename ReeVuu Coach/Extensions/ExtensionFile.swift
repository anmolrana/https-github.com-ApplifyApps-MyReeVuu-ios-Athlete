//
//  ExtensionFile.swift
//  ProjectTemplate
//
//  Created by Ankit Goyal on 15/03/2018.
//  Copyright © 2018 Applify Tech Pvt Ltd. All rights reserved.
//

import Foundation
import UIKit
private var maxLengths = [UITextField: Int]()

extension UITextField {
    
    @IBInspectable var leftPadding: CGFloat {
        get {
            return self.layer.frame.width
        }
        set {
            let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: newValue, height: self.frame.size.height))
            self.leftView = paddingView
            self.leftViewMode = .always
        }
    }
    
    @IBInspectable var leftBorder: UIColor? {
        get {
            return self.leftBorder
        }
        set {
            let border = CALayer()
            let width = CGFloat(1.0)
            border.borderColor = newValue?.cgColor
            border.frame = CGRect(x: 0, y: self.frame.origin.y + 8, width:  1, height: self.frame.size.height - 16)
            border.borderWidth = width
            self.layer.addSublayer(border)
            self.layer.masksToBounds = true
        }
    }
    
    @IBInspectable var leftIcon: UIImage? {
        get {
            return self.leftIcon
        }
        set {
            let padding = 10
            let size = 20
            
            let outerView = UIView(frame: CGRect(x: 0, y: 0, width: size + padding, height: size) )
            let iconView = UIImageView(frame: CGRect(x: padding, y: 0, width: size, height: size))
            iconView.image = newValue
            iconView.center = outerView.center
            outerView.addSubview(iconView)
            
            leftView = outerView
            leftViewMode = .always
        }
    }
    
    func leftBorder(color: UIColor) {
        let border = CALayer()
        let width = CGFloat(1.0)
        border.borderColor = color.cgColor
        border.frame = CGRect(x: 0, y: self.frame.origin.y + 8, width:  1, height: self.frame.size.height - 16)
        border.borderWidth = width
        self.layer.addSublayer(border)
        self.layer.masksToBounds = true
    }
    
}

extension UIView {
    func addGradientToView(firstColor:UIColor,secondColor:UIColor,forFrame:CGRect,locations:[CGFloat]){
        for layer in (self.layer.sublayers ?? []){
            if let layer1 = layer as? CAGradientLayer{
                layer1.removeFromSuperlayer()
            }
        }
        let gradient = CAGradientLayer()
        gradient.cornerRadius = 8
        gradient.frame = forFrame
        gradient.colors = [firstColor.cgColor, secondColor.cgColor]
        gradient.locations = locations as [NSNumber]
        
        self.layer.borderWidth = 0
        self.layer.insertSublayer(gradient, at: 0)
    }
    
    func removeAllGradients(){
        for layer in (self.layer.sublayers ?? []){
            if let layer1 = layer as? CAGradientLayer{
                layer1.removeFromSuperlayer()
            }
        }
    }
    
    func fadeTransition(_ duration:CFTimeInterval) {
        let animation = CATransition()
        animation.timingFunction = CAMediaTimingFunction(name:
            CAMediaTimingFunctionName.easeInEaseOut)
        animation.type = CATransitionType.fade
        animation.duration = duration
        layer.add(animation, forKey: CATransitionType.fade.rawValue)
    }
    
    @IBInspectable var corner: CGFloat {
        get {
            return self.layer.cornerRadius
        }
        set {
            
            self.layer.cornerRadius = newValue
            self.clipsToBounds = true
        }
    }
    
    @IBInspectable var borderWidth: CGFloat {
        get {
            return self.layer.borderWidth
        }
        set {
            
            self.layer.borderWidth = newValue
            self.clipsToBounds = true
        }
    }
    
    @IBInspectable var borderColor: UIColor? {
        get {
            return UIColor.clear
        }
        set {
            
            self.layer.borderColor = newValue?.cgColor
            self.layer.borderWidth = 1.0
        }
    }
    
    @IBInspectable var shadowColor: UIColor? {
        get {
            return UIColor.clear
        }
        set {
            
            let shadowSize : CGFloat = 1.0
            let shadowPath = UIBezierPath(rect: CGRect(x: -shadowSize / 2,
                                                       y: -shadowSize / 2,
                                                       width: self.frame.size.width,
                                                       height: self.frame.size.height))
            self.layer.masksToBounds = false
            self.layer.shadowColor = UIColor.black.cgColor
            self.layer.shadowOffset = CGSize(width: 0.0, height: 0.5)
            self.layer.shadowOpacity = 0.2
            self.layer.shadowPath = shadowPath.cgPath
            self.layer.cornerRadius = 8
        }
    }
    
    @IBInspectable var makeRound: Bool {
        set {
            if newValue {
                layer.borderWidth = 1.0
                layer.masksToBounds = false
                layer.borderColor = UIColor.white.cgColor
                layer.cornerRadius = min(bounds.width, bounds.height) / 2.0
                clipsToBounds = true
            }
        }
        get {
            return true
        }
    }
    
    func addShadow() {
        let shadowSize : CGFloat = 1.0
        let shadowPath = UIBezierPath(rect: CGRect(x: -shadowSize / 2,
                                                   y: -shadowSize / 2,
                                                   width: self.frame.size.width,
                                                   height: self.frame.size.height))
        self.layer.masksToBounds = false
        self.layer.shadowColor = UIColor.lightGray.cgColor
        self.layer.shadowOffset = CGSize(width: 0.0, height: 0.5)
        self.layer.shadowOpacity = 0.8
        self.layer.shadowPath = shadowPath.cgPath
        self.layer.cornerRadius = 8
    }
    
    class func loadFromNibNamed(_ nibNamed: String, bundle : Bundle? = nil) -> UIView? {
        return UINib(
            nibName: nibNamed,
            bundle: bundle
            ).instantiate(withOwner: nil, options: nil)[0] as? UIView
    }
    
    
    
    class func loadFromNibNamedWithViewIndex(_ nibNamed: String, bundle : Bundle? = nil, index:Int) -> UIView? {
        return UINib(
            nibName: nibNamed,
            bundle: bundle
            ).instantiate(withOwner: nil, options: nil)[index] as? UIView
    }
    
    
    
}

extension UILabel{
    
    
    @IBInspectable var characterSpacing: Float  {
        get {
            return self.characterSpacing
        }
        set {
            
            let attributedString = NSMutableAttributedString(string: self.text!)
            attributedString.addAttribute(NSAttributedString.Key.kern, value: newValue, range: NSRange(location: 0, length: attributedString.length))
            self.attributedText = attributedString
        }
    }
}

extension String {
    func trim() -> String
    {
        return self.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    func rangeFromNSRange(string:String,range : Range<String.Index>) -> NSRange? {
        guard let range = self.range(of: string, options: .caseInsensitive, range: range, locale: .current) else {
            return nil
            
        }
        
        return NSRange(range, in: self)
    }
    
    func nsRange(from range: Range<String.Index>) -> NSRange {
        let from = range.lowerBound.samePosition(in: utf16)!
        let to = range.upperBound.samePosition(in: utf16)!
        
        return NSRange(location: utf16.distance(from: utf16.startIndex, to: from),
                       length: utf16.distance(from: from, to: to))
    }

}

extension UIColor{
    public convenience init(hexString: String) {
        let hexString = hexString.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines) as String
        let scanner = Scanner(string: hexString)
        
        if (hexString.hasPrefix("#")) {
            scanner.scanLocation = 1
        }
        
        var color: UInt32 = 0
        scanner.scanHexInt32(&color)
        
        let mask = 0x000000FF
        let r = Int(color >> 16) & mask
        let g = Int(color >> 8 ) & mask
        let b = Int(color) & mask
        
        let red = CGFloat(r) / 255.0
        let green = CGFloat(g) / 255.0
        let blue = CGFloat(b) / 255.0
        
        self.init(red:red, green:green, blue:blue, alpha:1)
    }
}

extension NSString{
    
    class func convertDeviceTokenToString(_ deviceToken:Data) -> String {
        //  Convert binary Device Token to a String (and remove the <,> and white space charaters).
        
        
        var token = ""
        for i in 0..<deviceToken.count {
            token = token + String(format: "%02.2hhx", arguments: [deviceToken[i]])
        }
        
        return token
    }
    
}



extension UITapGestureRecognizer {
    
    func didTapAttributedTextInLabel(label: UILabel, inRange targetRange: NSRange) -> Bool {
        // Create instances of NSLayoutManager, NSTextContainer and NSTextStorage
        let layoutManager = NSLayoutManager()
        let textContainer = NSTextContainer(size: CGSize.zero)
        let textStorage = NSTextStorage(attributedString: label.attributedText!)
        
        // Configure layoutManager and textStorage
        layoutManager.addTextContainer(textContainer)
        textStorage.addLayoutManager(layoutManager)
        
        // Configure textContainer
        textContainer.lineFragmentPadding = 0.0
        textContainer.lineBreakMode = label.lineBreakMode
        textContainer.maximumNumberOfLines = label.numberOfLines
        let labelSize = label.bounds.size
        textContainer.size = labelSize
        
        // Find the tapped character location and compare it to the specified range
        let locationOfTouchInLabel = self.location(in: label)
        let textBoundingBox = layoutManager.usedRect(for: textContainer)
        let textContainerOffset = CGPoint.init(x: (labelSize.width - textBoundingBox.size.width) * 0.5 - textBoundingBox.origin.x, y: (labelSize.height - textBoundingBox.size.height) * 0.5 - textBoundingBox.origin.y);
        let locationOfTouchInTextContainer = CGPoint.init(x: locationOfTouchInLabel.x - textContainerOffset.x, y:  locationOfTouchInLabel.y - textContainerOffset.y)
        
        let indexOfCharacter = layoutManager.characterIndex(for: locationOfTouchInTextContainer, in: textContainer, fractionOfDistanceBetweenInsertionPoints: nil)
        
        return NSLocationInRange(indexOfCharacter, targetRange)
    }
    
}
