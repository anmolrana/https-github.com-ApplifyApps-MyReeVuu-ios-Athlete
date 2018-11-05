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
//        IQKeyboardManager.shared().isEnableAutoToolbar = false
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
        
        //let txtEmail =  NSUtility.trimAllSpaces(txtField: self.txtEmail)
        
        if !CommonFunctions.checkTextFieldHasText(txtFld: txtEmail) {
            CommonFunctions.showAlertWithTitle(title: ValidationConstants.ErrorTitle, message: ValidationConstants.ErrorEmailEmpty)
            return false
        }
        else  if !CommonFunctions.isValidEmail(txtFld: txtEmail) {
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
            
            CommonFunctions.showLoader(show: true)
            
           
            if !NSUtility.isConnectedToNetwork()
            {
                CommonFunctions.showAlertWithTitle(title:ValidationConstants.ErrorTitle, message: ValidationConstants.ErrorInternetConnection )
                return
            }
            // loader
            CommonFunctions.showLoader(show: true)
            var paramaters :NSDictionary = [:]
            
            
            paramaters = ["email":self.txtEmail.text ?? "","user_type":2] as [String : Any] as NSDictionary
            
            UserModal.StringResponseToApi(strApi: APIURL.BaseUrl+APIURL.forgotPassword, parameters: paramaters as NSDictionary, ProfilePic: nil, withCompletionHandler: { (response) in
                 CommonFunctions.showLoader(show: false)
                if let str = response as? String{
                    let alertController = UIAlertController(title:  nil, message: str, preferredStyle: .alert)
                    let defaultAction = UIAlertAction.init(title: "Ok", style: .default, handler: { (_) in
                        UIView.animate(withDuration: 0.4, animations: {
                            self.viewForgotPass.transform = CGAffineTransform.init(translationX: 0, y: KScreenHeight)
                        }) { (_) in
                            self.removeFromSuperview()
                        }
                    })
                    alertController.addAction(defaultAction)
                    CommonFunctions.fetchCurrentViewController().present(alertController, animated: true, completion: nil)
                    
                }
            }, AndError: { (error) in
                CommonFunctions.showLoader(show: false)
                CommonFunctions.showAlertWithTitle(title: ValidationConstants.ErrorTitle, message: error as? String ?? "")
            })
        }
    }
    
    @IBAction func actionResendEmail(_ sender: Any) {
        
        CommonFunctions.showLoader(show: true)
        
       
        if !NSUtility.isConnectedToNetwork()
        {
            CommonFunctions.showAlertWithTitle(title:ValidationConstants.ErrorTitle, message: ValidationConstants.ErrorInternetConnection )
            return
        }
        // loader
        CommonFunctions.showLoader(show: true)
        var paramaters :NSDictionary = [:]
        
        
        paramaters = ["access_token": KUSERDEFAULT.value(forKey: UserDefaultConstants.userAccessToken) ?? ""] as [String : Any] as NSDictionary
        
        UserModal.StringResponseToApi(strApi: APIURL.BaseUrl+APIURL.resendEmail, parameters: paramaters as NSDictionary, ProfilePic: nil, withCompletionHandler: { (response) in
            CommonFunctions.showLoader(show: false)
            if let str = response as? String{
                CommonFunctions.showAlertWithTitle(title: "", message: str)
            }
        }, AndError: { (error) in
            
        })
    }
    
}



class OptionsPopupView: UIView,UITableViewDataSource,UITableViewDelegate,UIGestureRecognizerDelegate {
    var arrOptions = [String]()
    var delegate : OptionSelectedDelegate? = nil
    var button : UIButton? = nil
    var arrSelectedOption = [String]()
    var multiSelection = false
    var viewStyle:EnumOptionsSelectionType = .OptionGender
    let layer1 = CAShapeLayer()
    var arrWeights:[String] = []
    var arrfeet:[String] = []
    var arrInches:[String] = []
    var showButtonDone = false
    
    
    @IBOutlet weak var pickerViewWeight: UIPickerView!
    @IBOutlet weak var viewWeight: UIView!
    @IBOutlet weak var viewHeight: UIView!
    @IBOutlet weak var pickerViewHeight: UIPickerView!
    @IBOutlet weak var viewDOB: UIView!
    @IBOutlet weak var constraintDoneBtm: NSLayoutConstraint!
    @IBOutlet weak var constraintDoneHt: NSLayoutConstraint!
    @IBOutlet weak var btnDone: UIButton!
    @IBOutlet weak var lblHeading: UILabel!
    @IBOutlet weak var myDatePicker: UIDatePicker!
    @IBOutlet weak var viewBack: UIView!
    
    @IBOutlet weak var tblOptions: UITableView!
    
    @IBOutlet weak var constraintOptionsHt: NSLayoutConstraint!
    
    @IBOutlet weak var btnBottomDone: UIButton!
    @IBOutlet weak var lblHeadingTwo: UILabel!
    
    //MARK:-override funcations
    override func awakeFromNib() {
        super.awakeFromNib()
        self.tblOptions.register(UINib.init(nibName: "OptionsTableViewCell", bundle: nil), forCellReuseIdentifier: "OptionsTableViewCell")
        pickerViewHeight.delegate = self
        pickerViewHeight.dataSource = self
        pickerViewWeight.delegate = self
        pickerViewWeight.dataSource = self
        
        
        for i in 10...250{
            arrWeights.append("\(i) LBS")
        }
        
        for i in 3...8{
            arrfeet.append("\(i) Feet")
        }
        for i in 0...12{
            arrInches.append("\(i) Inch")
        }
        self.addTapGesture()
        
        let todate = Date()
        let dateComponent = NSDateComponents.init()
        dateComponent.year = -5
        self.myDatePicker.maximumDate = NSCalendar.current.date(byAdding: dateComponent as DateComponents, to: todate)
        
        let dateComponent1 = NSDateComponents.init()
        dateComponent1.year = -100
        self.myDatePicker.minimumDate = NSCalendar.current.date(byAdding: dateComponent1 as DateComponents, to: todate)
        self.myDatePicker.date = NSCalendar.current.date(byAdding: dateComponent as DateComponents, to: todate) ?? Date()
    }
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        let bPath  = UIBezierPath.init(roundedRect: rect, byRoundingCorners: [UIRectCorner.topLeft,UIRectCorner.topRight], cornerRadii: CGSize.init(width: 24, height: 24))
             layer1.path = bPath.cgPath

        if multiSelection{
            self.btnDone.isHidden = false
            self.constraintDoneHt.constant = 56
            self.constraintDoneBtm.constant = 20
        }
        if showButtonDone{
            self.btnDone.isHidden = false
            self.constraintDoneHt.constant = 56
            self.constraintDoneBtm.constant = 20
        }
    }
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if touch.view?.isDescendant(of: self.tblOptions) == true {
            return false
        }
        return true
    }
    func setUpView(){
        switch viewStyle {
        case .OptionGender:
            viewBack.layer.mask = layer1
            lblHeading.text = EnumOptionsSelectionType.OptionGender.rawValue
            viewBack.isHidden = false
            viewHeight.isHidden = true
            viewWeight.isHidden = true
            viewDOB.isHidden = true
        case .OptionDOB:
            viewDOB.layer.mask = layer1
            viewBack.isHidden = true
            viewHeight.isHidden = true
            viewWeight.isHidden = true
            viewDOB.isHidden = false
        case .OptionHeight:
            viewHeight.layer.mask = layer1
            viewBack.isHidden = true
            viewHeight.isHidden = false
            viewWeight.isHidden = true
            viewDOB.isHidden = true
        case .OptionWeight:
            viewWeight.layer.mask = layer1
            lblHeadingTwo.text = EnumOptionsSelectionType.OptionWeight.rawValue
            viewBack.isHidden = true
            viewHeight.isHidden = true
            viewWeight.isHidden = false
            viewDOB.isHidden = true
        case .OptionDexterity:
            viewBack.layer.mask = layer1
            lblHeading.text = EnumOptionsSelectionType.OptionDexterity.rawValue
            viewBack.isHidden = false
            viewHeight.isHidden = true
            viewWeight.isHidden = true
            viewDOB.isHidden = true
            
        case .OptionSportPlayed:
            viewBack.layer.mask = layer1
            lblHeading.text = EnumOptionsSelectionType.OptionSportPlayed.rawValue
            viewBack.isHidden = false
            viewHeight.isHidden = true
            viewWeight.isHidden = true
            viewDOB.isHidden = true
            
        case .OptionPlayingExperience:
            viewBack.layer.mask = layer1
            lblHeading.text = EnumOptionsSelectionType.OptionPlayingExperience.rawValue
            viewBack.isHidden = false
            viewHeight.isHidden = true
            viewWeight.isHidden = true
            viewDOB.isHidden = true
            
        case .OptionLevelOfPlaying:
            viewBack.layer.mask = layer1
            lblHeading.text = EnumOptionsSelectionType.OptionLevelOfPlaying.rawValue
            viewBack.isHidden = false
            viewHeight.isHidden = true
            viewWeight.isHidden = true
            viewDOB.isHidden = true
            
        case .OptionStateYouParticipated:
            viewWeight.layer.mask = layer1
            lblHeadingTwo.text = EnumOptionsSelectionType.OptionStateYouParticipated.rawValue
            viewBack.isHidden = true
            viewHeight.isHidden = true
            viewWeight.isHidden = false
            viewDOB.isHidden = true
        case .OptionReport:
            viewBack.layer.mask = layer1
            lblHeadingTwo.text = EnumOptionsSelectionType.OptionReport.rawValue
            viewBack.isHidden = false
            viewHeight.isHidden = true
            viewWeight.isHidden = true
            viewDOB.isHidden = true
        default:
            break
            
        }
    }
    
    //MARK:-Tap Handler
    func addTapGesture(){
       
            let tapGstr = UITapGestureRecognizer.init(target: self, action: #selector(self.handleTap))
            //tapGstr.cancelsTouchesInView = false
        tapGstr.delegate = self
            self.addGestureRecognizer(tapGstr)
      self.bringSubviewToFront(self.viewBack)
    }
    @objc func handleTap(){
        UIView.animate(withDuration: 0.2, animations: {
            self.viewBack.transform = CGAffineTransform.init(translationX: 0, y: KScreenHeight)
        }) { (_) in
            self.removeFromSuperview()
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrOptions.count
    }
    
    
    @IBAction func actionPickerDone(_ sender: UIButton) {
        if !multiSelection{
            arrSelectedOption.removeAll()
        }
        switch viewStyle {
        case .OptionDOB:
            if !multiSelection{
                arrSelectedOption.removeAll()
            }
            
            myDatePicker.datePickerMode = .date
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd MMM yyyy"
            let strDate = dateFormatter.string(from: myDatePicker.date)
            arrSelectedOption.append(strDate)
            if !multiSelection{
                if delegate != nil && button != nil{
                    self.delegate?.optionsSelected(optionsSelected: arrSelectedOption,onButton: button!)
                }
                UIView.animate(withDuration: 0.2, animations: {
                    self.viewBack.transform = CGAffineTransform.init(translationX: 0, y: KScreenHeight)
                }) { (_) in
                    self.removeFromSuperview()
                }
            }
            break
        case .OptionHeight: pickerViewHeight.selectedRow(inComponent: 0)
        var data = ""
          let feetrow = pickerViewHeight.selectedRow(inComponent: 0)
            let inchrow = pickerViewHeight.selectedRow(inComponent: 1)
       
            data.append(contentsOf: arrfeet[feetrow])
            data.append(contentsOf: " ")
            data.append(contentsOf: arrInches[inchrow])
            
            arrSelectedOption.append(data)
            
            if !multiSelection{
                if delegate != nil && button != nil{
                    self.delegate?.optionsSelected(optionsSelected: arrSelectedOption,onButton: button!)
                }
                UIView.animate(withDuration: 0.2, animations: {
                    self.viewBack.transform = CGAffineTransform.init(translationX: 0, y: KScreenHeight)
                }) { (_) in
                    self.removeFromSuperview()
                }
            }
        
            break
        case .OptionWeight:
            let row  = pickerViewWeight.selectedRow(inComponent: 0)
            let selectedWeight = arrWeights[row]
            arrSelectedOption.append(selectedWeight)
            if !multiSelection{
                if delegate != nil && button != nil{
                    self.delegate?.optionsSelected(optionsSelected: arrSelectedOption,onButton: button!)
                    
                }
                UIView.animate(withDuration: 0.2, animations: {
                    self.viewBack.transform = CGAffineTransform.init(translationX: 0, y: KScreenHeight)
                }) { (_) in
                    self.removeFromSuperview()
                }
            }
            break
        case .OptionStateYouParticipated:
            let row  = pickerViewWeight.selectedRow(inComponent: 0)
            let selectedstate = arrOptions[row]
            arrSelectedOption.append(selectedstate)
            if !multiSelection{
                if delegate != nil && button != nil{
                    self.delegate?.optionsSelected(optionsSelected: arrSelectedOption,onButton: button!)
                    
                }
                UIView.animate(withDuration: 0.2, animations: {
                    self.viewBack.transform = CGAffineTransform.init(translationX: 0, y: KScreenHeight)
                }) { (_) in
                    self.removeFromSuperview()
                }
            }
            break
        default:
            break
        }
    }
    
    
    @IBAction func actionDatePicker(_ sender: UIDatePicker) {
//        if !multiSelection{
//            arrSelectedOption.removeAll()
//        }
//
//        myDatePicker.datePickerMode = .date
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "dd MMM yyyy"
//        let strDate = dateFormatter.string(from: myDatePicker.date)
//        arrSelectedOption.append(strDate)
//        if !multiSelection{
//            if delegate != nil && button != nil{
//                self.delegate?.optionsSelected(optionsSelected: arrSelectedOption,onButton: button!)
//            }
//            UIView.animate(withDuration: 0.2, animations: {
//                self.viewBack.transform = CGAffineTransform.init(translationX: 0, y: KScreenHeight)
//            }) { (_) in
//                self.removeFromSuperview()
//            }
//        }
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tblOptions.dequeueReusableCell(withIdentifier: "OptionsTableViewCell", for: indexPath) as! OptionsTableViewCell
        let str = arrOptions[indexPath.row]
        cell.lblOption.text = str
        cell.btnOptionSelect.setImage(multiSelection ? (UIImage.init(named: "ic_blank_circle")) : nil, for: .normal)
        cell.btnOptionSelect.isSelected = arrSelectedOption.contains(str) ? true : false
        cell.lblSeparator.isHidden = indexPath.row == arrOptions.count-1 ? true : false
        self.constraintOptionsHt.constant = self.tblOptions.contentSize.height < 200 ?  self.tblOptions.contentSize.height : 200
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if !multiSelection{
            arrSelectedOption.removeAll()
        }
        arrSelectedOption.append(arrOptions[indexPath.row])
        
        self.tblOptions.reloadData()
        if !multiSelection && self.btnBottomDone.isHidden{
            if delegate != nil && button != nil{
                self.delegate?.optionsSelected(optionsSelected: arrSelectedOption,onButton: button!)
            }
            UIView.animate(withDuration: 0.2, animations: {
                self.viewBack.transform = CGAffineTransform.init(translationX: 0, y: KScreenHeight)
            }) { (_) in
                self.removeFromSuperview()
            }
        }
    }
    
    @IBAction func actionDone(_ sender: Any) {
        if delegate != nil && button != nil{
            self.delegate?.optionsSelected(optionsSelected: arrSelectedOption,onButton: button!)
        }
        UIView.animate(withDuration: 0.2, animations: {
            self.viewBack.transform = CGAffineTransform.init(translationX: 0, y: KScreenHeight)
        }) { (_) in
            self.removeFromSuperview()
        }
    }
}

extension OptionsPopupView: UIPickerViewDelegate,UIPickerViewDataSource{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        if pickerView == pickerViewHeight{
            return 2
        }
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == pickerViewWeight{
            return viewStyle == .OptionWeight ? arrWeights.count : arrOptions.count
        }else{
            if component == 0{
                 return arrfeet.count
            }else{
                 return arrInches.count
            }
           
        }
        
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == pickerViewWeight{
            
            return viewStyle == .OptionWeight ? arrWeights[row] : arrOptions[row]
        }else{
            if component == 0{
                return arrfeet[row]
            }else{
                return arrInches[row]
            }
        }
        
    }
    
    
}

class TipPopUpView:UIView{
    
    @IBOutlet weak var constraintTipBtm: NSLayoutConstraint!
    @IBAction func actionGotIt(_ sender: Any) {
        UIView.animate(withDuration: 0.2, animations: {
            self.alpha = 0
        }) { (_) in
            self.removeFromSuperview()
        }
    }
    
    
}
