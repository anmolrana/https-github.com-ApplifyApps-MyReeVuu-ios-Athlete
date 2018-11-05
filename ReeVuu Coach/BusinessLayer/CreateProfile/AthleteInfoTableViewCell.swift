//
//  AthleteInfoTableViewCell.swift
//  ReeVuu Coach
//
//  Created by Dev on 25/10/18.
//  Copyright © 2018 Dev. All rights reserved.
//

import UIKit



class AthleteInfoTableViewCell: UITableViewCell {
    
    @IBOutlet weak var btnDeleteSport: UIButton!
    @IBOutlet weak var viewAddSports: UIView!
    @IBOutlet weak var lblSportNo: UILabel!
    @IBOutlet weak var stackViewObj: UIStackView!
    
    @IBOutlet weak var txtZipCode: UITextField!
  //  @IBOutlet weak var btnStateParticipatedIn: RightImagedButton!
    @IBOutlet weak var btnLevelOfPlaying: RightImagedButton!
    @IBOutlet weak var btnYearOfExperience: RightImagedButton!
    @IBOutlet weak var btnSportPlayed: RightImagedButton!
    @IBOutlet weak var constraintHeightAddSport: NSLayoutConstraint!
    var delegate:SecondSportAddDelegate? = nil
    var isSecondSportAdded:Bool = false
    var arrSelectedOption:[String] = []
     var indexPath:IndexPath? = nil
    var atheleteModal = AthleteBackgroundModal()
    lazy var arrExperience :[String] = {
        var arr = ["< 1 year", "1 year"]
        for i in 2..<21 {
            arr.append("\(i) years")
        }
        return arr
    }()
   
    var arrSportsOptions : [String] = []
    var arrLevel :[String] = []
    var arrStates:[String] = []
    
    var row:Int = 0
    var view :UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
//        let um = AthleteBackgroundModal()
//        arrAthleteInfo.append(um)
        txtZipCode.delegate = self
//        setData()
        // Initialization code
    }

    func configureWithModal(sportModal: AthleteBackgroundModal) {
        atheleteModal = sportModal
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        
    }
    

    @IBAction func actionAddSports(_ sender: UIButton) {
//         isSecondSportAdded = true
//        if  delegate !=  nil && indexPath != nil{
//            delegate?.secondSportAdded(indexPath: indexPath ?? IndexPath())
//        }
    }
    
    @IBAction func actionDeleteSport(_ sender: UIButton) {
//        if  delegate != nil  && indexPath != nil{
//            delegate?.sportDeleted(indexPath: indexPath ?? IndexPath(), isSportAdded: true)
//        }
    }
    
    @IBAction func actionSportPlayed(_ sender: UIButton) {
//        if indexPath?.row == 0{
//        addPopUpView(mode: .OptionSportPlayed, sender: sender, arrData: arrSportsOptions)
//        }
    }
    
    
    @IBAction func actionYearPlayingExperience(_ sender: UIButton) {
        addPopUpView(mode: .OptionPlayingExperience, sender: sender, arrData: arrExperience)
    
    }
    
    @IBAction func actionLevelOfPlaying(_ sender: UIButton) {
        addPopUpView(mode: .OptionLevelOfPlaying, sender: sender, arrData: arrLevel)
    }
    
    @IBAction func actionHighestlevel(_ sender: UIButton) {
        addPopUpView(mode: .OptionStateYouParticipated, sender: sender, arrData: arrStates)
        
    }
    
    func addPopUpView(mode:EnumOptionsSelectionType,sender:UIButton,arrData:[String]){
        txtZipCode.resignFirstResponder()
        let optionV = UIView.loadFromNibNamedWithViewIndex("PopupView", index: 1)  as! OptionsPopupView
        optionV.delegate = self
        optionV.button = sender
        optionV.frame = CGRect.init(x: 0, y: 0, width: KScreenWidth, height: KScreenHeight)
        optionV.viewStyle = mode
        optionV.arrOptions = arrData
        switch mode {
//        case .OptionSportPlayed:
//            optionV.arrSelectedOption = [atheleteModal.sportPlayed]
        case .OptionPlayingExperience:
             optionV.arrSelectedOption = arrSelectedOption
        case .OptionLevelOfPlaying:
            optionV.arrSelectedOption = [atheleteModal.levelOfPlaying]
        case .OptionStateYouParticipated:
            optionV.arrSelectedOption = [atheleteModal.stateYouParticipatedIn]
        default:
            break
        }
       
        optionV.setUpView()
        self.view.addSubview(optionV)
        optionV.viewBack.transform = CGAffineTransform.init(translationX: 0, y: KScreenHeight)
        UIView.animate(withDuration: 0.4) {
            optionV.viewBack.transform = .identity
        }
    }
    
    
    
}
extension AthleteInfoTableViewCell:OptionSelectedDelegate{
    func optionsSelected(optionsSelected: [String], onButton: UIButton) {
        if optionsSelected.count == 1{
            
            onButton.setTitle(optionsSelected.first, for: .normal)
            onButton.setTitleColor(.white, for: .normal)
            
            switch onButton{
            case btnSportPlayed:
                
                let previousValue = atheleteModal.sportPlayed
                
                 atheleteModal.sportPlayed = optionsSelected.first ?? ""
                 
                if optionsSelected.first != previousValue && previousValue != "Select" && indexPath?.count ?? 0 > 1{
                    if  delegate != nil  && indexPath != nil{
                        delegate?.sportDeleted(indexPath: indexPath ?? IndexPath(), isSportAdded: isSecondSportAdded)
   
                    }
                }
              
               
                break
            case btnYearOfExperience:
                atheleteModal.yearOfPlayingExperience = optionsSelected.first ?? ""
                arrSelectedOption.removeAll()
                arrSelectedOption.append(atheleteModal.yearOfPlayingExperience)
                 //arrAthleteInfo[self.indexPath?.row ?? 0].yearOfPlayingExperience = optionsSelected.first ?? ""
                break
            case btnLevelOfPlaying:
                atheleteModal.levelOfPlaying = optionsSelected.first ?? ""
                 //arrAthleteInfo[self.indexPath?.row ?? 0].levelOfPlaying = optionsSelected.first ?? ""
                break
//            case btnStateParticipatedIn:
//                atheleteModal.stateYouParticipatedIn = optionsSelected.first ?? ""
//                //arrAthleteInfo[self.indexPath?.row ?? 0].stateYouParticipatedIn = optionsSelected.first ?? ""
//                break
            default:
                break
            }
            
        }
    }
    
    
}

extension AthleteInfoTableViewCell : UITextFieldDelegate{
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let newText = (textField.text! as NSString).replacingCharacters(in: range, with: string)
        let numberOfChars = newText.count
        var charcCount = 30
        charcCount = textField == txtZipCode ? 8 : 20
        return numberOfChars <= charcCount
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        return true
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == self.txtZipCode{
            atheleteModal.zipCode = textField.text ?? ""
      //arrAthleteInfo[self.indexPath?.row ?? 0].zipCode = textField.text ?? ""
          //  arrAthleteInfo.append(atheleteModal)
        }
        
        }
    
}
