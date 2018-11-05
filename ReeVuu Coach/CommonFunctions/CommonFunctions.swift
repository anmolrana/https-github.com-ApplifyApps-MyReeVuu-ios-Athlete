//
//  CommonFunctions.swift
//  ReeVuu Coach
//
//  Created by Dev on 22/10/18.
//  Copyright © 2018 Dev. All rights reserved.
//

import UIKit
import SVProgressHUD
import CoreTelephony
import CoreData

class CommonFunctions: NSObject {
    
    static  var loaderV = LoaderView()
    //MARK:-  validation
    
    class func isValidEmail(txtFld : UITextField) -> Bool {
        // print("validate calendar: \(testStr)")
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: txtFld.text)
    }
    
    class func checkTextFieldHasText(txtFld : UITextField) -> Bool {
        if txtFld.text?.trimmingCharacters(in: CharacterSet.whitespaces).count == 0 {
            return false
        }
        return true
    }
    class func sendToStart(){
        DBManager.deleteAllData()
        let token = KUSERDEFAULT.value(forKey: UserDefaultConstants.userDeviceToken)
        for key in KUSERDEFAULT.dictionaryRepresentation().keys{
            KUSERDEFAULT.removeObject(forKey: key)
        }
        KUSERDEFAULT.setValue(token, forKey: UserDefaultConstants.userDeviceToken);
//        for vc in (self.fetchCurrentViewController().navigationController?.viewControllers)!{
//            if let vc1 = vc as? SignUpViewController{
//                self.fetchCurrentViewController().navigationController?.popToViewController(vc1, animated: true)
//                return
//            }
//        }
        let vc = StoreyBoard.StoreyboardIntial().storeyboadForReevuu.instantiateViewController(withIdentifier: "SignUpViewController") as! SignUpViewController
        vc.signUpStyle = .SignUp
        
        self.fetchCurrentViewController().navigationController?.viewControllers = [vc]
    }
    class func checkForSpecialCharacters(text:String)->Bool{
        let characterset = CharacterSet(charactersIn: "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789")
        if text.rangeOfCharacter(from: characterset.inverted) != nil {
            return true
        }
        return false
    }
    //MARK:- Alert Function
    
    class func showAlertWithTitle(title : String,message : String) {
        let alertVc = UIAlertController.init(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        alertVc.addAction(UIAlertAction.init(title: "OK", style: UIAlertAction.Style.cancel, handler: nil))
        let currentVc = self.fetchCurrentViewController()
        currentVc.present(alertVc, animated: true, completion: nil)
        
    }
    
    static func fetchCurrentViewController()->UIViewController{
        let navCntrl = KAPPDELEGATE?.window?.rootViewController as! UINavigationController
        let currentVc = navCntrl.viewControllers.last!
        return currentVc
    }
    
    //MARK:- Loader
    
    static func showLoader(show : Bool) {
        if show {
            if (!(KAPPDELEGATE?.window?.subviews.contains(loaderV))!)  {
                loaderV = UIView.loadFromNibNamed("LoaderView", bundle: Bundle.main) as! LoaderView
                loaderV.frame = CGRect.init(x: 0, y: 0, width: KScreenWidth, height: KScreenHeight)
                loaderV.showloader(show:true)
                loaderV.loadingView.isHidden=false
                KAPPDELEGATE?.window?.addSubview(loaderV)
            }
        }
        else{
            if loaderV.loadingView != nil{
                loaderV.showloader(show:false)
                loaderV.removeFromSuperview()
            }
        }
    }
    
    //handle invalid accces token
    
    static func HandleInvalidAccessToken() {
        CommonFunctions.showLoader(show: false)
//        if USERDEFAULT.value(forKey: UserDefaultConstants.userAccessToken) == nil{
//            return
//        }
//        FirbaseServices.updateOnlineStatus(statusValue: "0")
//        APPDELEGATE?.controllerCache.removeAllObjects()
//        FirbaseServices.DeleteAllObservers()
//
//        DBManager.deleteAllData()
//        for key in  USERDEFAULT.dictionaryRepresentation().keys{
//            if key != NMUserDefaultUserDeviceToken{
//                USERDEFAULT.removeObject(forKey: key)
//            }
//        }
//        let alertVc = UIAlertController.init(title: ErrorTitle, message: ErrorInvalidAccessToken, preferredStyle: UIAlertControllerStyle.alert)
//        alertVc.addAction(UIAlertAction.init(title: NSLocalizedString("OK_text", comment: ""), style: UIAlertActionStyle.default, handler: { (action) in
//
//            let storeyb = UIStoryboard.init(name: "Main", bundle: Bundle.main)
//            let vc = storeyb.instantiateViewController(withIdentifier: "NRSalesRentalOptionVc")
//            let navCntrl = APPDELEGATE?.window?.rootViewController as! UINavigationController
//            navCntrl.viewControllers = [vc]
//        }))
        
     //   let currentVc = self.fetchCurrentViewController()
       // currentVc.present(alertVc, animated: true, completion: nil)
        
    }
    
}
