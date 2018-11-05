//
//  CreateProfileVC.swift
//  ReeVuu Coach
//
//  Created by Dev on 24/10/18.
//  Copyright © 2018 Dev. All rights reserved.
//

import UIKit
import Photos
import RSKImageCropper
import SDWebImage
import SwiftyJSON

var arrAthleteInfo = [AthleteBackgroundModal]()

class CreateProfileVC: UIViewController {

    @IBOutlet weak var constraintTblHt: NSLayoutConstraint!
    @IBOutlet weak var btnProfile: UIButton!
    @IBOutlet weak var btnAtheleteInfo: UIButton!
    @IBOutlet weak var btnPersonalInfo: UIButton!
    @IBOutlet weak var btnNext: UIButton!
    
    @IBOutlet weak var scrollV: UIScrollView!
    @IBOutlet weak var imgPlaceholder: UIImageView!
    @IBOutlet weak var imgEditProfilePic: UIImageView!
    @IBOutlet weak var txtFullName: UITextField!
    @IBOutlet weak var txtUserName: UITextField!
    @IBOutlet weak var lblUserNameAvailable: UILabel!
    
    @IBOutlet weak var tblSportsInfo: UITableView!
    @IBOutlet weak var btnGender: RightImagedButton!
    @IBOutlet weak var btnDexterity: RightImagedButton!
    @IBOutlet weak var btnWeight: RightImagedButton!
    @IBOutlet weak var btnHeight: RightImagedButton!
    @IBOutlet weak var btnDOB: RightImagedButton!
    
    @IBOutlet weak var constraintStack1Lead: NSLayoutConstraint!
    @IBOutlet weak var stackViewObj: UIStackView!
    @IBOutlet var btnPersonalInfoOptions: [UIButton]!
    var selectedGender : [String] = []
    var selectedDexterity : [String] = []
    
    var user: UserEntity? = nil
    var sportM = ChooseSportsModal()
    var noOfRows:Int = 1
    var arrSportsOptions : [String] = []
    var arrLevel :[String] = []
    var arrStates:[String] = []
    var picker1 = UIImagePickerController()
 //   var arrAthleteInfo = [AthleteBackgroundModal]()
    var firstSportModal = AthleteBackgroundModal()
    var secondSportModal = AthleteBackgroundModal()
    lazy var arrLevels :[LevelsEntity] = {
        return  DBManager.fetchDataWithParameters(dataType: LevelsEntity.self)
    }()
    
    lazy var arrSportInfo :[SportsInfoEntity] = {
        return  DBManager.fetchDataWithParameters(dataType: SportsInfoEntity.self)
    }()
    
    lazy var arrSport :[SportsEntity] = {
        return  DBManager.fetchDataWithParameters(dataType: SportsEntity.self)
    }()
    
    lazy var arrState :[StatesEntity] = {
        return  DBManager.fetchDataWithParameters(dataType: StatesEntity.self)
    }()
    
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return .lightContent
    }
    let arrGender = ["Male","Female","Other"]
    let arrDexterity = ["Left","Right"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setData()
        setupTextFeilds()
        self.checkAndSetData()

        firstSportModal.sportPlayed = arrSportInfo[0].name ?? KUSERDEFAULT.value(forKey: UserDefaultConstants.sportPlayed) as? String ?? ""
            //KUSERDEFAULT.value(forKey: UserDefaultConstants.sportPlayed) as? String ?? ""
        arrAthleteInfo.append(firstSportModal)
       // arrAthleteInfo.append(secondSportModal)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.scrollV.contentSize = CGSize.init(width: self.scrollV.frame.size.width, height: self.stackViewObj.frame.size.height)
        self.scrollV.setContentOffset(.zero, animated: false)
        intialSetUP()
    }
    
    func setupTextFeilds(){
        txtUserName.delegate = self
        txtFullName.delegate = self
        txtFullName.attributedPlaceholder = NSAttributedString(string: "Enter full name", attributes: [NSAttributedString.Key.font : Fonts.FontRobotoRegular(size: 14).fontsForReevuu,NSAttributedString.Key.foregroundColor : KAppGreyColor])
        txtUserName.attributedPlaceholder = NSAttributedString(string: "Enter user name", attributes: [NSAttributedString.Key.font : Fonts.FontRobotoRegular(size: 14).fontsForReevuu,NSAttributedString.Key.foregroundColor : KAppGreyColor])
    }
    
    func setData(){
        for data in arrLevels{
            arrLevel.append(data.name ?? "")
        }
        for data in arrSport{
            arrSportsOptions.append(data.name ?? "")
        }
        for data in arrState{
            arrStates.append(data.name ?? "")
        }
    }
    //MARK:- Intial SetUP
    func intialSetUP(){
        lblUserNameAvailable.isHidden = true
        self.selectedPersonalInfoButton(sender: self.btnPersonalInfo)
        self.selectUnselectButton(btn: self.btnAtheleteInfo, select: false)
        //NSUtility.addTapGestureOnView(view: self.view, viewController: self)
    }
    
    func checkAndSetData(){
        user = DBManager.fetchUserDataWithParameters(userId: KUSERDEFAULT.value(forKey: UserDefaultConstants.userID) as? String ?? "")
        if user != nil{
            txtFullName.text = user?.userName
            imgPlaceholder.sd_setImage(with: URL.init(string: user?.userProfilePic ?? ""), placeholderImage: UIImage(named: "ic_profile_home"), options: .highPriority, completed: nil)
           // imgPlaceholder.contentMode = .scaleAspectFill
        }
        
    }
    
    //MARK:- select unselectButtons
    
    func selectUnselectButton(btn:UIButton,select:Bool){
        if select{
            btn.backgroundColor = KAppThemeColor
            btn.layer.borderColor = UIColor.clear.cgColor
            btn.layer.borderWidth = 0
            btn.setTitleColor(.white, for: .normal)
        }
        else{
            btn.backgroundColor = .clear
            btn.layer.borderColor = KAppGreyColor.cgColor
            btn.layer.borderWidth = 1
            btn.setTitleColor(KAppGreyColor, for: .normal)
        }
    }
    
    func selectedPersonalInfoButton(sender:UIButton){
        self.selectUnselectButton(btn: sender, select: true)
        self.selectUnselectButton(btn: self.btnAtheleteInfo, select: false)
        self.btnNext.setTitle("NEXT", for: .normal)
        let scrollFrame = self.scrollV.frame
        self.scrollV.contentSize = CGSize.init(width: scrollFrame.size.width, height: self.stackViewObj.frame.height)
        self.scrollV.setContentOffset(.zero, animated: false)
        self.constraintStack1Lead.constant = 0
        UIView.animate(withDuration: 0.2) {
            
            self.view.layoutIfNeeded()
        }
    }
    
    func selectedAtheleteInfoButton(sender:UIButton){
        self.selectUnselectButton(btn: sender, select: true)
        self.selectUnselectButton(btn: self.btnPersonalInfo, select: false)
        self.btnNext.setTitle("DONE", for: .normal)
        let scrollFrame = self.scrollV.frame
        self.scrollV.contentSize = CGSize.init(width: scrollFrame.size.width, height: self.tblSportsInfo.frame.height)
        self.scrollV.setContentOffset(.zero, animated: false)
        self.constraintStack1Lead.constant = -scrollFrame.size.width
        self.resetTableHT()
        UIView.animate(withDuration: 0.2) {
            self.view.layoutIfNeeded()
        }
    }
    
    //MARK:- Check Validations
    
    func checkValidationForPersonalInfo()->Bool{
        
        if imgPlaceholder.image == UIImage(named: "ic_profile_home"){
            CommonFunctions.showAlertWithTitle(title: ValidationConstants.ErrorTitle, message: ValidationConstants.ErrorChooseProfilePic)
            return false
        }
        else if !CommonFunctions.checkTextFieldHasText(txtFld: txtFullName){
            CommonFunctions.showAlertWithTitle(title: ValidationConstants.ErrorTitle, message: ValidationConstants.ErrorEnterFullName)
            return false
        }
        else if (txtFullName.text?.count)! < 2 || (txtFullName.text?.count)! > 50{
            if (txtFullName.text?.count)! < 2{
                CommonFunctions.showAlertWithTitle(title: ValidationConstants.ErrorTitle, message: ValidationConstants.ErrorFullNameMin)
            }
            else{
                CommonFunctions.showAlertWithTitle(title: ValidationConstants.ErrorTitle, message: ValidationConstants.ErrorFullNameMax)
            }
            return false
        }
        else if !CommonFunctions.checkTextFieldHasText(txtFld: txtUserName){
            CommonFunctions.showAlertWithTitle(title: ValidationConstants.ErrorTitle, message: ValidationConstants.ErrorEnterUsername)
            return false
        }
//        else if CommonFunctions.checkForSpecialCharacters(text: txtUserName.text ?? ""){
//            CommonFunctions.showAlertWithTitle(title: ValidationConstants.ErrorTitle, message: ValidationConstants.ErrorSpecialCharacterNotAllowed)
//            return false
//        }
        else if (txtUserName.text?.count)! < 2 || (txtUserName.text?.count)! > 50{
            if (txtUserName.text?.count)! < 2{
                CommonFunctions.showAlertWithTitle(title: ValidationConstants.ErrorTitle, message: ValidationConstants.ErrorUserNameMin)
            }
            else{
                CommonFunctions.showAlertWithTitle(title: ValidationConstants.ErrorTitle, message: ValidationConstants.ErrorUserNameMax)
            }
            return false
        }
        else if btnGender.title(for: .normal) == "" || btnGender.title(for: .normal) == "Select"{
            CommonFunctions.showAlertWithTitle(title: ValidationConstants.ErrorTitle, message:ValidationConstants.ErrorSelectGender )
            return false
        }
        else if btnDOB.title(for: .normal) == "" || btnDOB.title(for: .normal) == "Select"{
            CommonFunctions.showAlertWithTitle(title: ValidationConstants.ErrorTitle, message: ValidationConstants.ErrorSelectDOB)
            return false
        }
        else if btnHeight.title(for: .normal) == "" || btnHeight.title(for: .normal) == "Select"{
            CommonFunctions.showAlertWithTitle(title: ValidationConstants.ErrorTitle, message: ValidationConstants.ErrorSelectHeight)
            return false
        }
        else if btnDexterity.title(for: .normal) == "" || btnDexterity.title(for: .normal) == "Select"{
            CommonFunctions.showAlertWithTitle(title: ValidationConstants.ErrorTitle, message: ValidationConstants.ErrorSelectDexterity)
            return false
        }
        return true
    }
    
    func checkValidationForSportsInfo()->Bool{
        
        
        for sportsInfo in arrAthleteInfo{
            if  sportsInfo.sportPlayed == "" || sportsInfo.sportPlayed == "Select"{
                CommonFunctions.showAlertWithTitle(title: ValidationConstants.ErrorTitle, message: ValidationConstants.ErrorSelectSport)
                return false
            }else if  sportsInfo.yearOfPlayingExperience == "" || sportsInfo.yearOfPlayingExperience == "Select"{
                CommonFunctions.showAlertWithTitle(title: ValidationConstants.ErrorTitle, message: ValidationConstants.ErrorSelectExperience)
                return false
            }else if  sportsInfo.levelOfPlaying == "" || sportsInfo.levelOfPlaying == "Select"{
                CommonFunctions.showAlertWithTitle(title: ValidationConstants.ErrorTitle, message: ValidationConstants.ErrorSelectLevel)
                return false
            }
       //     else if  sportsInfo.stateYouParticipatedIn == "" || sportsInfo.stateYouParticipatedIn == "Select"{
           //     CommonFunctions.showAlertWithTitle(title: ValidationConstants.ErrorTitle, message: "Please select state")
        //        return false
          //  }
            else if sportsInfo.zipCode == ""{
                CommonFunctions.showAlertWithTitle(title: ValidationConstants.ErrorTitle, message: ValidationConstants.ErrorEmptyZipcode)
                return false
            }
            else if sportsInfo.zipCode.count < 3 || sportsInfo.zipCode.count > 10{
                CommonFunctions.showAlertWithTitle(title: ValidationConstants.ErrorTitle, message: ValidationConstants.ErrorInvalidZipcode )
                return false
            }
        }

        return true
    }
    
    //MARK:- Button actions
    

    @IBAction func actionEditProfilePic(_ sender: UIButton) {

        //show alert for options
        let alertVc = UIAlertController.init(title: AlertConstants.AlertUploadPicture, message: nil, preferredStyle: UIAlertController.Style.actionSheet)
        
        if UIDevice.current.userInterfaceIdiom == .pad{
            if let popoverController = alertVc.popoverPresentationController {
                popoverController.sourceView = sender
                popoverController.sourceRect = (sender as AnyObject).bounds
            }
        }
        alertVc.addAction(UIAlertAction.init(title: AlertConstants.AlertCamera, style: UIAlertAction.Style.default, handler: { (success) in
            CommonValidations.checkCameraPermissionsForCamera(camera: true, withSuccess: { (success) in
                if success{
                    self.picker1.sourceType = .camera
                    self.picker1.allowsEditing=false
                    self.picker1.delegate=self
                    self.present(self.picker1, animated: true, completion: nil)
                }
            })
            
        }))
        alertVc.addAction(UIAlertAction.init(title: AlertConstants.AlertGallery, style: UIAlertAction.Style.default, handler: { (success) in
            CommonValidations.checkCameraPermissionsForCamera(camera: false, withSuccess: { (success) in
                if success{
                    self.picker1.sourceType = .photoLibrary
                    self.picker1.allowsEditing=false
                    self.picker1.delegate=self
                    self.present(self.picker1, animated: true, completion: nil)
                }
            })
            
        }))

        alertVc.addAction(UIAlertAction.init(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil))
        self.present(alertVc, animated: true, completion: nil)
        
    }
    
    @IBAction func actionDOB(_ sender: UIButton) {
       addPopUpView(mode: .OptionDOB, sender: sender, arrData:arrGender)
        
    }
    
    @IBAction func actionWeight(_ sender: UIButton) {
      addPopUpView(mode: .OptionWeight, sender: sender, arrData:arrGender)
        
    }
    
    @IBAction func actionHeight(_ sender: UIButton) {
        addPopUpView(mode: .OptionHeight, sender: sender, arrData:arrGender)
    }
    
    @IBAction func actionGender(_ sender: UIButton) {
        addPopUpView(mode: .OptionGender, sender: sender, arrData: arrGender)
    }
    
    
    
    @IBAction func actionDexterity(_ sender: UIButton) {
        addPopUpView(mode: .OptionDexterity, sender: sender, arrData: arrDexterity)
    }
    
    
    @IBAction func actionNext(_ sender: UIButton) {
        if self.constraintStack1Lead.constant == 0{
        if checkValidationForPersonalInfo(){
            self.btnAtheleteInfo.isUserInteractionEnabled = true
            self.selectedAtheleteInfoButton(sender: self.btnAtheleteInfo)
        }
        }
        else{
            if arrAthleteInfo.count > 0 {
                self.tblSportsInfo.reloadData()
                if checkValidationForSportsInfo(){
                  hitAPI()
                }
               
            }
        }
    }
    
    //MARK:- upper button action
    
    
    @IBAction func actionPersonalInfo(_ sender: UIButton) {
        self.selectedPersonalInfoButton(sender: sender)
    }
    
    @IBAction func actionAthleteInfo(_ sender: UIButton) {
         self.selectedAtheleteInfoButton(sender: sender)
    }
    
    //MARK:- Add PopUP View
    
    func addPopUpView(mode:EnumOptionsSelectionType,sender:UIButton,arrData:[String]){
        let optionV = UIView.loadFromNibNamedWithViewIndex("PopupView", index: 1)  as! OptionsPopupView
        optionV.delegate = self
        optionV.button = sender
        optionV.frame = CGRect.init(x: 0, y: 0, width: KScreenWidth, height: KScreenHeight)
        optionV.viewStyle = mode
        switch mode {
        case .OptionGender:
            optionV.arrSelectedOption = selectedGender
        case .OptionDexterity:
            optionV.arrSelectedOption = selectedDexterity
        default:
            break
        }
        optionV.arrOptions = arrData
        optionV.setUpView()
        self.view.addSubview(optionV)
        optionV.viewBack.transform = CGAffineTransform.init(translationX: 0, y: KScreenHeight)
        UIView.animate(withDuration: 0.5) {
            optionV.viewBack.transform = .identity
        }
    }
    
     //MARK:- Hit api
    
    func hitAPI(){
        var arrAnswers=[[String:String]]()
       
        for data in arrAthleteInfo{

            var dict = [String:String]()
          
            let index = arrSport.map{$0.name ?? ""}.index(where: { object -> Bool in
                object == data.sportPlayed
                
            })
            let sportId = arrSport.map{$0.id ?? ""}[index ?? 0]
            let indexLevel = arrLevels.map{$0.name ?? ""}.index(where: { object -> Bool in
                object == data.levelOfPlaying
                
            })
            let levelId = arrLevels.map{$0.id ?? ""}[indexLevel ?? 0]
            
//            let indexState = arrState.map{$0.name ?? ""}.index(where: { object -> Bool in
//                object == data.stateYouParticipatedIn
//
//            })
//            let stateId = arrState.map{$0.id ?? ""}[indexState ?? 0]
            
            dict[APIKeys.sportId]=sportId
            dict[APIKeys.experience] = data.yearOfPlayingExperience
            dict[APIKeys.level] = levelId
            dict[APIKeys.stateId] = ""
            dict[APIKeys.zipCode] = data.zipCode
            arrAnswers.append(dict)
        }

        let jsonAnswers = JSON(arrAnswers).rawString()
        //date
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        let date = dateFormatter.date(from: self.btnDOB.title(for: .normal) ?? "")
        let strDate = dateFormatter.string(from: date ?? Date())
       
        //weight
        var weight = ""
        let stringArray = self.btnWeight.title(for: .normal)?.components(separatedBy: " ")
        for item in stringArray!{
            if let number = Int(item){
                weight = "\(number)"
            }
        }
        //height
        var arrDigits = [String]()
        let stringArray1 = self.btnHeight.title(for: .normal)?.components(separatedBy: " ")
        for item in stringArray1!{
            if let number = Int(item){
                arrDigits.append("\(number)")
            }
        }
        let height = arrDigits.joined(separator: ".")
        
        if !NSUtility.isConnectedToNetwork()
        {
            CommonFunctions.showAlertWithTitle(title:ValidationConstants.ErrorTitle, message: ValidationConstants.ErrorInternetConnection )
            return
        }
        // loader
        
        CommonFunctions.showLoader(show: true)
        let paramaters :NSMutableDictionary = [:]
        paramaters.addEntries(from: [APIKeys.accessToken:KUSERDEFAULT.value(forKey: UserDefaultConstants.userAccessToken) ??  "",
                                     APIKeys.name: self.txtFullName.text ?? "",
                                     APIKeys.username:self.txtUserName.text ?? ""])
        paramaters.addEntries(from: [APIKeys.gender:self.btnGender.title(for: .normal) ?? "",
                                     APIKeys.dob: strDate ,
                                     APIKeys.height:height ])
        paramaters.addEntries(from: [APIKeys.weight:weight ,
                                     APIKeys.dexterity:self.btnDexterity.title(for: .normal) ?? "",
                                     APIKeys.sportInfo: jsonAnswers ?? ""])

        UserModal.GetUserDataInResponseToApi(strApi: APIURL.BaseUrl+APIURL.createProfile, parameters: paramaters as NSDictionary, ProfilePic: ["pic": self.imgPlaceholder.image ?? ""], withCompletionHandler: { (response) in
            CommonFunctions.showLoader(show: false)
            arrAthleteInfo = [AthleteBackgroundModal]()
            let vc = StoreyBoard.StoreyboardMain().storeyboadForReevuu.instantiateViewController(withIdentifier: "BaseTabBarController") as! BaseTabBarController
            self.navigationController?.pushViewController(vc, animated: true)

        }, AndError: { (error) in
            CommonFunctions.showLoader(show: false)
            CommonFunctions.showAlertWithTitle(title: ValidationConstants.ErrorTitle, message: error as String)
        })
        
        
    }
    
    
    func profilePicDisplayed(pic:Bool) {
        if pic{
            imgEditProfilePic.image = UIImage(named: "ic_edit_pic")
        }
        else{
             imgEditProfilePic.image = UIImage(named: "ic_add_pic")
        }
        
    }
    
}
extension CreateProfileVC: UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == txtFullName{
            txtFullName.resignFirstResponder()
            txtUserName.becomeFirstResponder()
        }else{
            textField.resignFirstResponder()
        }
        return true
    }
}

extension CreateProfileVC:OptionSelectedDelegate,SecondSportAddDelegate{
    func secondSportAdded(indexPath: IndexPath) {
        noOfRows = 2
        if arrAthleteInfo.count < 2{
            secondSportModal = AthleteBackgroundModal()
            if arrAthleteInfo[0].sportPlayed == "Tennis" && arrAthleteInfo[0].sportPlayed != "Select"{
                secondSportModal.sportPlayed = "Wrestling"
            }else{
                
                secondSportModal.sportPlayed = "Tennis"
            }
            
            arrAthleteInfo.append(secondSportModal)
        }
        tblSportsInfo.reloadData()
        self.perform(#selector(self.resetTableHT), with: nil, afterDelay: 0.1)
    }
    
    func sportDeleted(indexPath: IndexPath,isSportAdded:Bool) {
        noOfRows = 1
        if indexPath.row < arrAthleteInfo.count && isSportAdded{
        arrAthleteInfo.remove(at: indexPath.row)
        let indexPath1 = IndexPath(row: 0, section: 0)
        tblSportsInfo.scrollToRow(at: indexPath1, at: .top, animated: true)
        tblSportsInfo.reloadData()
            self.perform(#selector(self.resetTableHT), with: nil, afterDelay: 0.1)
        }
        
    }
    
 
    
    func optionsSelected(optionsSelected: [String], onButton: UIButton) {
        if optionsSelected.count == 1{
            onButton.setTitle(optionsSelected.first, for: .normal)
            onButton.setTitleColor(.white, for: .normal)
            switch onButton{
            case btnGender:
                selectedGender.removeAll()
               selectedGender.append(optionsSelected.first ?? "")
                break
            case btnDexterity:
                selectedDexterity.removeAll()
                selectedDexterity.append(optionsSelected.first ?? "")
                break
            default:
                break
            }
        }
    }
    

    
}



extension CreateProfileVC: UITableViewDataSource,UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return noOfRows
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifiers.AthleteInfoTableViewCell, for: indexPath) as? AthleteInfoTableViewCell{
           // cell.setData()
            
            cell.arrSportsOptions = self.arrSportsOptions
            cell.arrLevel = self.arrLevel
            cell.arrStates = self.arrStates
            if noOfRows > 1{
                cell.isSecondSportAdded = true
                if indexPath.row == 0{
                    cell.lblSportNo.text = "SPORT"
                    cell.btnDeleteSport.isHidden = true
                }else{
                    cell.lblSportNo.text = "SPORT 2"
                    cell.btnDeleteSport.isHidden = false
                }
                cell.constraintHeightAddSport.constant = 0
            }else{
                cell.isSecondSportAdded = false
                cell.btnDeleteSport.isHidden = true
              //  cell.constraintHeightAddSport.constant = 48
            }
            cell.view = self.view
            cell.delegate = self
            cell.indexPath = indexPath
            
            if indexPath.row < arrAthleteInfo.count && arrAthleteInfo[indexPath.row].sportPlayed != ""{
                cell.btnSportPlayed.setTitle(arrAthleteInfo[indexPath.row].sportPlayed, for: .normal)
                if cell.btnSportPlayed.title(for: .normal) != "Select"{
                    cell.btnSportPlayed.setTitleColor(.white, for: .normal)
                }
                cell.btnYearOfExperience.setTitle(arrAthleteInfo[indexPath.row].yearOfPlayingExperience, for: .normal)
                cell.btnLevelOfPlaying.setTitle(arrAthleteInfo[indexPath.row].levelOfPlaying, for: .normal)
//                cell.btnStateParticipatedIn.setTitle(arrAthleteInfo[indexPath.row].stateYouParticipatedIn, for: .normal)
                cell.txtZipCode.text = arrAthleteInfo[indexPath.row].zipCode
               
                
            
            }
            else{
                cell.btnSportPlayed.setTitle("Select", for: .normal)
                cell.btnSportPlayed.setTitleColor(KAppGreyColor, for: .normal)
                if cell.btnSportPlayed.title(for: .normal) != "Select"{
                    cell.btnSportPlayed.setTitleColor(.white, for: .normal)
                }
                cell.btnYearOfExperience.setTitle("Select", for: .normal)
                 cell.btnYearOfExperience.setTitleColor(KAppGreyColor, for: .normal)
                cell.btnLevelOfPlaying.setTitle("Select", for: .normal)
                cell.btnLevelOfPlaying.setTitleColor(KAppGreyColor, for: .normal)
             //   cell.btnStateParticipatedIn.setTitle("Select", for: .normal)
            //    cell.btnStateParticipatedIn.setTitleColor(KAppGreyColor, for: .normal)
                cell.txtZipCode.placeholder = "Enter"
                
                
            }
            if arrAthleteInfo.count == 0{
                return cell
            }
            cell.configureWithModal(sportModal: arrAthleteInfo[indexPath.row])
            self.resetTableHT()
            return cell
        }
        return UITableViewCell()
    }
    
    @objc func resetTableHT(){
        if self.constraintStack1Lead.constant == 0{
            return
        }
        self.constraintTblHt.constant = self.tblSportsInfo.contentSize.height < 500 ? 500 : self.tblSportsInfo.contentSize.height
        self.view.updateConstraintsIfNeeded()
        self.scrollV.contentSize = CGSize.init(width: self.scrollV.frame.size.width, height: self.constraintTblHt.constant)
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
}

extension CreateProfileVC:UIImagePickerControllerDelegate,UINavigationControllerDelegate,RSKImageCropViewControllerDelegate{
 

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        var img = info[.editedImage]
        if img == nil{
            img = info[.originalImage]
        }
        if img == nil {
            if #available(iOS 11.0, *) {
                let asset = info[.phAsset] as? PHAsset
                if asset != nil{
                    img = self.getAssetThumbnail(asset: asset!)
                }
            } else {
                CommonFunctions.showAlertWithTitle(title: ValidationConstants.ErrorTitle, message:ValidationConstants.ErrorIssueFetchingImage)
                return
            }
        }
        let imageCropVC = RSKImageCropViewController(image: img as! UIImage , cropMode: RSKImageCropMode.square)
        imageCropVC.delegate = self
        picker.present(imageCropVC, animated: true, completion: nil)
    }

    
    func getAssetThumbnail(asset: PHAsset) -> UIImage {
        let manager = PHImageManager.default()
        let option = PHImageRequestOptions()
        var thumbnail = UIImage()
        option.isSynchronous = true
        manager.requestImage(for: asset, targetSize: CGSize(width: self.imgPlaceholder.frame.size.width*2, height: self.imgPlaceholder.frame.size.height*2), contentMode: .aspectFit, options: option, resultHandler: {(result, info)->Void in
            thumbnail = result!
        })
        return thumbnail
    }
    
    func imageCropViewController(_ controller: RSKImageCropViewController, willCropImage originalImage: UIImage){
    }
    
    func imageCropViewControllerDidCancelCrop(_ controller: RSKImageCropViewController){
        controller.dismiss(animated: true) {
            self.picker1.dismiss(animated: true, completion: nil)
        }
        
    }
    
    func imageCropViewController(_ controller: RSKImageCropViewController, didCropImage croppedImage: UIImage, usingCropRect cropRect: CGRect, rotationAngle: CGFloat) {
        let img1 = croppedImage
        self.imgPlaceholder.contentMode = .scaleAspectFill
        self.imgPlaceholder.image = img1
       self.profilePicDisplayed(pic: true)
        controller.dismiss(animated: true) {
            self.picker1.dismiss(animated: true, completion: nil)
        }
    }
}


