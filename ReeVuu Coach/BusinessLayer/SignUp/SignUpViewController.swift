//
//  ViewController.swift
//  ReevuuDemo
//
//  Created by Dev on 17/10/18.
//  Copyright © 2018 Dev. All rights reserved.
//

import UIKit
import GoogleSignIn
import SVProgressHUD
import IQKeyboardManagerSwift
import SafariServices


class SignUpViewController: UIViewController,GIDSignInUIDelegate{
    
    @IBOutlet weak var lblWelcomeText: UILabel!
    @IBOutlet weak var lblDescriptionText: UILabel!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var btnContinue: UIButton!
    @IBOutlet weak var viewTermsAndCondition: UIView!
    @IBOutlet weak var lblSigninSignupText: UILabel!
    @IBOutlet weak var btnSigninSignup: UIButton!
    @IBOutlet weak var btnTermsAndCondition: UIButton!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var lblAlreadyRegistered: UILabel!
    @IBOutlet weak var viewForgotPassword: UIView!
    
    @IBOutlet weak var lblPrivacyTerms: UILabel!
    var signUpStyle : SignUpStyle = .SignUp
    
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
       IQKeyboardManager.shared.enableAutoToolbar = false
//        let tapGesture = UITapGestureRecognizer.init(target: self, action: #selector(self.handleTap))
//        self.view.addGestureRecognizer(tapGesture)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        checkSignupType()
    }
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        txtEmail.attributedPlaceholder = NSAttributedString(string: "Enter email", attributes: [NSAttributedString.Key.font : Fonts.FontRobotoRegular(size: 14).fontsForReevuu,NSAttributedString.Key.foregroundColor : AppColors.placeholderColor])
        
    }
    
    @objc func handleTap(tapGstr : UITapGestureRecognizer){
        SVProgressHUD.dismiss()
    }
    //MARK:- setup data
    
    func checkSignupType(){
        switch signUpStyle {
        case .SignIn:
            viewTermsAndCondition.isHidden = true
            lblWelcomeText.text = KWelcomeBackText
            lblSigninSignupText.text = "OR SIGN IN WITH"
            self.lblDescriptionText.text = KSignInDescriptionText
            btnContinue.setTitle("SIGN IN", for: .normal)
            btnSigninSignup.setTitle("SIGNUP", for: .normal)
            lblAlreadyRegistered.text = KDontHaveAccount
            viewForgotPassword.isHidden = false
            txtPassword.attributedPlaceholder = NSAttributedString(string: "Enter password", attributes: [NSAttributedString.Key.font : Fonts.FontRobotoRegular(size: 14).fontsForReevuu,NSAttributedString.Key.foregroundColor : AppColors.placeholderColor])

        case .SignUp:
            viewTermsAndCondition.isHidden = false
            lblWelcomeText.text = KWelcomeText
            self.lblDescriptionText.text = KSignUpDescriptionText
            lblSigninSignupText.text = "OR SIGN UP WITH"
            btnContinue.setTitle("CONTINUE WITH EMAIL", for: .normal)
            btnSigninSignup.setTitle("SIGNIN", for: .normal)
            lblAlreadyRegistered.text = KAlreadyregister
            viewForgotPassword.isHidden = true
            txtPassword.attributedPlaceholder = NSAttributedString(string: "Set password", attributes: [NSAttributedString.Key.font : Fonts.FontRobotoRegular(size: 14).fontsForReevuu,NSAttributedString.Key.foregroundColor : AppColors.placeholderColor])

            
        }
    }

    func checkValidation()->Bool{
        
        if !CommonFunctions.checkTextFieldHasText(txtFld: self.txtEmail) {
            CommonFunctions.showAlertWithTitle(title: ValidationConstants.ErrorTitle, message: ValidationConstants.ErrorEmailEmpty)
            return false
        }
        else  if !CommonFunctions.isValidEmail(txtFld: self.txtEmail) {
            CommonFunctions.showAlertWithTitle(title: ValidationConstants.ErrorTitle, message: ValidationConstants.ErrorEmailInvalid)
            return false
        }else if !CommonFunctions.checkTextFieldHasText(txtFld: self.txtPassword) {
            CommonFunctions.showAlertWithTitle(title: ValidationConstants.ErrorTitle, message: ValidationConstants.ErrorEmptyPassword)
            return false
        }
        else  if (self.txtPassword.text?.count)!<8 || (self.txtPassword.text?.count)!>40 {
            if (txtPassword.text?.count)! < 8 && signUpStyle == .SignUp{
                 CommonFunctions.showAlertWithTitle(title: ValidationConstants.ErrorTitle, message: ValidationConstants.ErrorMinPassword)
            }else{
                CommonFunctions.showAlertWithTitle(title: ValidationConstants.ErrorTitle, message: ValidationConstants.ErrorInvalidPassword)
            }
            return false
        }
        if signUpStyle == .SignUp && !btnTermsAndCondition.isSelected{
            CommonFunctions.showAlertWithTitle(title: ValidationConstants.ErrorTitle, message: ValidationConstants.ErrorTermsCondition)
                return false
        }
        
        return true
    }
    
    //MARK:- Button Actions
    
    @IBAction func actionContinueWithEmail(_ sender: UIButton) {
        // dismiss keyboard if present
        txtEmail.resignFirstResponder()
        txtPassword.resignFirstResponder()
        
        if !checkValidation(){
            return
        }
        
        if !NSUtility.isConnectedToNetwork()
        {
            CommonFunctions.showAlertWithTitle(title:ValidationConstants.ErrorTitle, message: ValidationConstants.ErrorInternetConnection )
            return
        }
        // loader
        CommonFunctions.showLoader(show: true)
        var paramaters :NSDictionary = [:]
        var apiurl = ""
        
        if signUpStyle == .SignUp{
           apiurl =  APIURL.BaseUrl+APIURL.SignUpUrl
             paramaters = [APIKeys.email:self.txtEmail.text ?? "",
                           APIKeys.password:self.txtPassword.text ?? "",
                           APIKeys.platformStatus:1,
                           APIKeys.deviceToken:KUSERDEFAULT.value(forKey: UserDefaultConstants.userDeviceToken) ?? "123"] as [String : Any] as NSDictionary
        }else{
            apiurl = APIURL.BaseUrl+APIURL.SignInUrl
            paramaters = [APIKeys.email:txtEmail.text ?? "",
                          APIKeys.password:self.txtPassword.text ?? "",
                          APIKeys.platformStatus:1,
                          APIKeys.deviceToken:KUSERDEFAULT.value(forKey: UserDefaultConstants.userDeviceToken) ?? "123",
                          APIKeys.facebookId:"",
                          APIKeys.googleId:"",
                          APIKeys.accountType:"1",
                          APIKeys.platformType:"1",
                          APIKeys.name: "",
                          APIKeys.imageUrl: "",
                          APIKeys.gender:"",
                          APIKeys.dob:""] as [String : Any] as NSDictionary as NSDictionary
        }
        
        UserModal.GetUserDataInResponseToApi(strApi: apiurl, parameters: paramaters as NSDictionary, ProfilePic: nil, withCompletionHandler: { (userM) in
            self.perform(#selector(self.stopButtonLoadingForSuccess(userM:)), with: userM, afterDelay: 0.5)
        }) { (error) in
            self.perform(#selector(self.stopButtonLoading(error:)), with: error, afterDelay: 0.5)
        }
        
    }
    
    
    @IBAction func actionSignInSignup(_ sender: UIButton) {
        txtEmail.text = ""
        txtPassword.text = ""
        btnTermsAndCondition.isSelected = false
        btnTermsAndCondition.backgroundColor = UIColor.clear
        btnTermsAndCondition.borderColor = AppColors.gray
        btnTermsAndCondition.setImage(nil, for: .normal)
        if signUpStyle == .SignUp{
            let sorey  = UIStoryboard.init(name: "Intial", bundle: nil)
            let vc = sorey.instantiateViewController(withIdentifier: "SignUpViewController") as! SignUpViewController
            vc.signUpStyle = signUpStyle == .SignUp ? .SignIn : .SignUp
            self.navigationController?.pushViewController(vc, animated: true)
        }else{
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    
    @IBAction func actionTermsAndCondition(_ sender: UIButton) {
        btnTermsAndCondition.isSelected = !btnTermsAndCondition.isSelected
        if btnTermsAndCondition.isSelected{
            btnTermsAndCondition.backgroundColor = AppColors.blue
            btnTermsAndCondition.borderColor = AppColors.blue
            btnTermsAndCondition.setImage(#imageLiteral(resourceName: "ic_otp_success"), for: .normal)
        }else{
            btnTermsAndCondition.backgroundColor = UIColor.clear
            btnTermsAndCondition.borderColor = AppColors.gray
            btnTermsAndCondition.setImage(nil, for: .normal)
        }
    }
    
    
    @IBAction func actionFBlogin(_ sender: UIButton) {
        if signUpStyle == .SignUp && !btnTermsAndCondition.isSelected{
            CommonFunctions.showAlertWithTitle(title: ValidationConstants.ErrorTitle, message: ValidationConstants.ErrorTermsCondition)
            return
        }
        self.view.isUserInteractionEnabled = false
        SocialNetworkingManager.connectToFacebook(fromViewController: self, completion: {success,userModal  in
            CommonFunctions.showLoader(show: true)
            if success{
                
               
                if !NSUtility.isConnectedToNetwork()
                {
                    CommonFunctions.showAlertWithTitle(title:ValidationConstants.ErrorTitle, message: ValidationConstants.ErrorInternetConnection )
                    return
                }
                // loader
                CommonFunctions.showLoader(show: true)
                var paramaters :NSDictionary = [:]
                paramaters = [APIKeys.email:userModal?.email ?? "",
                              APIKeys.password:self.txtPassword.text ?? "",
                              APIKeys.platformStatus:1,
                              APIKeys.deviceToken:KUSERDEFAULT.value(forKey: UserDefaultConstants.userDeviceToken) ?? "123",
                              APIKeys.facebookId:userModal?.userFbId ?? "",
                              APIKeys.googleId:"",
                              APIKeys.accountType:"2",
                              APIKeys.platformType:"1",
                              APIKeys.name:userModal?.username ?? "",
                              APIKeys.imageUrl:userModal?.profilePic ?? "",
                              APIKeys.gender:"",
                              APIKeys.dob:""] as [String : Any] as NSDictionary
                UserModal.GetUserDataInResponseToApi(strApi: APIURL.BaseUrl+APIURL.SignInUrl, parameters: paramaters as NSDictionary, ProfilePic: nil, withCompletionHandler: { (userM) in
                    self.perform(#selector(self.stopButtonLoadingForSuccess(userM:)), with: userM, afterDelay: 0.5)
                }) { (error) in
                    self.perform(#selector(self.stopButtonLoading(error:)), with: error, afterDelay: 0.5)
                    
                }

            }else{
                self.perform(#selector(self.stopButtonLoading(error:)), with: "Problem in facebook connection", afterDelay: 0.5)
            }
            
        })
    }
    
    @IBAction func actionGoogleLogin(_ sender: UIButton) {
        if signUpStyle == .SignUp && !btnTermsAndCondition.isSelected{
            CommonFunctions.showAlertWithTitle(title: ValidationConstants.ErrorTitle, message: ValidationConstants.ErrorTermsCondition)
            return
        }
        GIDSignIn.sharedInstance().uiDelegate = self
        SocialNetworkingManager.shared.setupDelegates()
        SocialNetworkingManager.connectToGoogle()
        appDelegateObject().googleSignInCallback = {(success,userModal)->() in
            CommonFunctions.showLoader(show: true)
            if success{
               
                if !NSUtility.isConnectedToNetwork()
                {
                    CommonFunctions.showAlertWithTitle(title:ValidationConstants.ErrorTitle, message: ValidationConstants.ErrorInternetConnection )
                    return
                }
                // loader
                CommonFunctions.showLoader(show: true)
                var paramaters :NSDictionary = [:]
                paramaters = [APIKeys.email:userModal?.email ?? "",
                              APIKeys.password:self.txtPassword.text ?? "",
                              APIKeys.platformStatus:1,
                              APIKeys.deviceToken:KUSERDEFAULT.value(forKey: UserDefaultConstants.userDeviceToken) ?? "123",
                              APIKeys.facebookId:"",
                              APIKeys.googleId:userModal?.googleId ?? "",
                              APIKeys.accountType:"3",
                              APIKeys.platformType:"1",
                              APIKeys.name:userModal?.username ?? "",
                              APIKeys.imageUrl:userModal?.profilePic ?? "",
                              APIKeys.gender:"",
                              APIKeys.dob:""] as [String : Any] as NSDictionary
                UserModal.GetUserDataInResponseToApi(strApi: APIURL.BaseUrl+APIURL.SignInUrl, parameters: paramaters as NSDictionary, ProfilePic: nil, withCompletionHandler: { (userM) in
                    
                    self.perform(#selector(self.stopButtonLoadingForSuccess(userM:)), with: userM, afterDelay: 0.5)
                }) { (error) in
                    self.perform(#selector(self.stopButtonLoading(error:)), with: error, afterDelay: 0.5)
                    
                }
            }else{
                self.perform(#selector(self.stopButtonLoading(error:)), with: "Problem in Google connection", afterDelay: 0.5)
            }
           
        }
    }
    
    @IBAction func actionForgotPassword(_ sender: UIButton) {
        let v = UIView.loadFromNibNamedWithViewIndex("PopupView", index: 0) as! PopupView
        v.frame = CGRect.init(x: 0, y: 0, width: KScreenWidth, height: KScreenHeight)
        v.popupType = .PopUpForgotPassword
        self.view.addSubview(v)
        v.viewForgotPass.transform = CGAffineTransform.init(translationX: 0, y: KScreenHeight)
        UIView.animate(withDuration: 0.5) {
            v.viewForgotPass.transform = .identity
        }
    }
    
    
    @IBAction func actionPrivacyTermsTapped(_ sender: UITapGestureRecognizer) {
        let termsRange = self.lblPrivacyTerms.text?.range(of: "Terms & Privacy policy")
        
        if sender.didTapAttributedTextInLabel(label: self.lblPrivacyTerms, inRange: (self.lblPrivacyTerms.text?.nsRange(from: termsRange!))!) {
            // print("Tapped terms")
            let svc = SFSafariViewController(url: (URL(string: "http://www.google.com"))!)
            present(svc, animated: true)
        }  else {
            // print("Tapped none")
        }
    }
    
    
    //MARk:- Function success/error
    
    @objc func stopButtonLoading (error : String){
        CommonFunctions.showLoader(show: false)
        CommonFunctions.showAlertWithTitle(title:ValidationConstants.ErrorTitle, message: error as String)
        self.view.isUserInteractionEnabled=true
    }
    
    @objc func stopButtonLoadingForSuccess (userM : UserModal){
        CommonFunctions.showLoader(show: false)
         self.view.isUserInteractionEnabled = true
        if userM.emailVerified == 0{
            self.openVerifyEmailPopUP()
        }
        else if userM.profileStatus == 0{
            self.openQuestionairs()
        }
        else if userM.profileStatus == 1{
            self.openCreateProfile()
        }
        else if userM.profileStatus == 2{
            self.openLanding()
        }
       
    }

    func openVerifyEmailPopUP(){
        KAPPDELEGATE?.isEmailVerificationScreenOpen = true
        let v = UIView.loadFromNibNamedWithViewIndex("PopupView", index: 0) as! PopupView
        v.frame = CGRect.init(x: 0, y: 0, width: KScreenWidth, height: KScreenHeight)
        v.popupType = .PopUpEmailVerify
        let str = "A verification email has been sent to your registered email \(self.txtEmail.text ?? ""). Please click the link to continue sign up process."
        let atrStr = NSMutableAttributedString.init(string: str)
        
        atrStr.addAttribute(.foregroundColor, value: UIColor.black, range:  str.rangeFromNSRange(string: self.txtEmail.text!, range: (str.range(of: self.txtEmail.text ?? "")!))!)
        v.lblVerifyEmail.attributedText = atrStr
        self.view.addSubview(v)
        v.viewVerifyEmail.transform = CGAffineTransform.init(translationX: 0, y: KScreenHeight)
        UIView.animate(withDuration: 0.5) {
            v.viewVerifyEmail.transform = .identity
        }
        
        NotificationCenter.default.removeObserver(self, name: Notification.Name(UserDefaultConstants.notificationEmailVerification), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(getCurrentUserDetail), name: Notification.Name(UserDefaultConstants.notificationEmailVerification), object: nil)
    }
    
    // MARK: Get Current Data of Login User
    @objc func getCurrentUserDetail()
    {
        if KUSERDEFAULT.value(forKey: UserDefaultConstants.userAccessToken) != nil{
            DBManager.UpdateUserEmailVerified(userId: (KUSERDEFAULT.value(forKey: UserDefaultConstants.userID) as? String) ?? "")
            self.openQuestionairs()
        }
        
        
    }
    //MARK:- Open Controllers
    
    func openQuestionairs(){
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ChooseYourSportVC") as! ChooseYourSportVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func openCreateProfile(){
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "CreateProfileVC") as! CreateProfileVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func openLanding(){
        let vc = StoreyBoard.StoreyboardMain().storeyboadForReevuu.instantiateViewController(withIdentifier: "BaseTabBarController") as! BaseTabBarController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    

}

extension SignUpViewController: UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == txtEmail{
            txtEmail.resignFirstResponder()
            txtPassword.becomeFirstResponder()
        }else{
            textField.resignFirstResponder()
             self.view.endEditing(true)
        }

        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let newText = (textField.text! as NSString).replacingCharacters(in: range, with: string)
        if textField != txtPassword{
            return true
        }
        let numberOfChars = newText.count
        let charcCount = 30
        
        ///charcCount = textField == txtPassword ? 8 : 20
        
        return numberOfChars <= charcCount
        
    }
}

