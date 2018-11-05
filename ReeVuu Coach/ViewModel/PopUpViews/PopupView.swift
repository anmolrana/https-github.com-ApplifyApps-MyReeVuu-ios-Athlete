//
//  PopupView.swift
//  ReeVuu Coach
//
//  Created by Dev on 22/10/18.
//  Copyright © 2018 Dev. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
class PopupView: UIView,UITextFieldDelegate {
    var popupType : EnumPopUPType = .PopUpForgotPassword
    @IBOutlet weak var txtEmail: UITextField!
    
    @IBOutlet weak var viewForgotPass: UIView!
    
    @IBOutlet weak var lblVerifyEmail: UILabel!
    @IBOutlet weak var viewVerifyEmail: UIView!
    
    
    
    //MARK:-override funcations
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.addTapGesture()
       
    }
    override func draw(_ rect: CGRect) {
        super.draw(rect)
       // IQKeyboardManager.shared().isEnableAutoToolbar = false
        let bPath  = UIBezierPath.init(roundedRect: rect, byRoundingCorners: [UIRectCorner.topLeft,UIRectCorner.topRight], cornerRadii: CGSize.init(width: 24, height: 24))
        let layer = CAShapeLayer()
        layer.path = bPath.cgPath
       
        if popupType == .PopUpForgotPassword{
            self.viewForgotPass.alpha = 1

            self.viewForgotPass.layer.mask = layer
        }
        else if popupType == .PopUpEmailVerify{
            self.viewVerifyEmail.alpha = 1

            self.viewVerifyEmail.layer.mask = layer
            
        }
        
    }
    
    //MARK:-Tap Handler
    func addTapGesture(){
        if popupType == .PopUpForgotPassword{
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(self.handleTap))
        
        self.addGestureRecognizer(tap)
        }
    }
    @objc func handleTap(){
        if popupType == .PopUpEmailVerify{
        return
        }
        if self.txtEmail.isFirstResponder{
            self.endEditing(true)
            return
        }
        UIView.animate(withDuration: 0.4, animations: {
            self.viewForgotPass.transform = CGAffineTransform.init(translationX: 0, y: KScreenHeight)
        }) { (_) in
            self.removeFromSuperview()
        }
    }
    
    //MARK:- check validations
    /**
     - check validations: This function is used to check validation for each entry before submiting the form to backend.
     */
    func CheckValdations()-> Bool{
        
       // let txtEmail =  self.txtEmail.text?.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)  //NSUtility.trimAllSpaces(txtField: self.txtEmail)
        
        if !CommonFunctions.checkTextFieldHasText(txtFld: self.txtEmail) {
            CommonFunctions.showAlertWithTitle(title: ValidationConstants.ErrorTitle, message: ValidationConstants.ErrorEmailEmpty)
            return false
        }
        else  if !CommonFunctions.isValidEmail(txtFld: self.txtEmail) {
           CommonFunctions.showAlertWithTitle(title: ValidationConstants.ErrorTitle, message: ValidationConstants.ErrorEmailInvalid)
            return false
        }
        
        
        return true
    }
    
    //MARK:- UITextFieldDelegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    //MARK:-button action
    @IBAction func actionReset(_ sender: Any) {
        if self.CheckValdations(){
            
        }
    }
    
    @IBAction func actionResendEmail(_ sender: Any) {
    }
    
}
