
//
//  QuestionersVC.swift
//  ReeVuu Coach
//
//  Created by Dev on 23/10/18.
//  Copyright © 2018 Dev. All rights reserved.
//

import UIKit
import SwiftyJSON
class QuestionersVC: UIViewController {

    @IBOutlet weak var collectionViewQues: UICollectionView!
    
    @IBOutlet weak var btnNext: UIButton!
    
    lazy var arrQuestions :[QuestionEntity] = {
        return  DBManager.fetchDataWithParameters(dataType: QuestionEntity.self)
    }()
    var arrData = [QuestionersModal]()
    var row:Int = 0
    var sportId = ""
    var sportM = ChooseSportsModal()
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let qm = QuestionersModal()
        arrData = qm.setData(arrEntity: arrQuestions)
    }
    
    @IBAction func actionNext(_ sender: UIButton) {
        var isValueSelected:Bool = false
        var isValueSelectedForReload = false
        for data in arrData{
            for d in data.options{
                if d.isSelected{
                    isValueSelected = true
                    break
                }
            }
        }
        for d in arrData[row].options{
            if d.isSelected{
                isValueSelectedForReload = true
                break
            }
        }
        if row < arrData.count{
            if  row <= arrData.count-1 && isValueSelectedForReload == true{
               
                collectionViewQues.reloadData()
            }
            else{
                CommonFunctions.showAlertWithTitle(title: ValidationConstants.ErrorTitle, message: ValidationConstants.ErrorSelectOneOption)
                return
            }
        }
        if btnNext.title(for: .normal) == "SUBMIT" && isValueSelected{
            hitAPI()
            return
        }
        row = row + 1
        if row == arrData.count-1{
            btnNext.setTitle("SUBMIT", for: .normal)
        }
    }
    
    func hitAPI(){
        var arrAnswers=[[String:String]]()
        
        for data in arrData{
            let questionId = data.id
            var dict = [String:String]()
            dict[APIKeys.questionId]=questionId
            var answers = [String]()
            for option in data.options{
                if option.isSelected {
                    answers.append(option.options ?? "")
                }
            }
         dict[APIKeys.answer] = answers.joined(separator: ",")
            arrAnswers.append(dict)
        }
        
        let jsonAnswers = JSON(arrAnswers).rawString()
       
        if !NSUtility.isConnectedToNetwork()
        {
            CommonFunctions.showAlertWithTitle(title:ValidationConstants.ErrorTitle, message: ValidationConstants.ErrorInternetConnection )
            return
        }
        // loader
        CommonFunctions.showLoader(show: true)
        var paramaters :NSDictionary = [:]
      
        paramaters = [APIKeys.accessToken:KUSERDEFAULT.value(forKey: UserDefaultConstants.userAccessToken) ??  "",
                      APIKeys.sportsIds:self.sportId,
                      APIKeys.answers: jsonAnswers ?? ""] as [String : Any] as NSDictionary
     
        
        UserModal.GetUserDataInResponseToApi(strApi: APIURL.BaseUrl+APIURL.athleteAnswer, parameters: paramaters as NSDictionary, ProfilePic: nil, withCompletionHandler: { (response) in
            
            CommonFunctions.showLoader(show: false)
          
            
                let vc = StoreyBoard.StoreyboardIntial().storeyboadForReevuu.instantiateViewController(withIdentifier: "CreateProfileVC") as! CreateProfileVC
                vc.sportM = self.sportM
                self.navigationController?.pushViewController(vc, animated: true)
            
            
        }, AndError: { (error) in
            
        })
        
    }
    
    
}

extension QuestionersVC: UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let data = arrData[row]
      
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CellIdentifiers.QuesOneCollViewCell, for: indexPath) as? QuesOneCollViewCell{
           cell.lblQuesNo.text =  "\(data.quesNo ?? 0)"
            cell.arrOption = data.options
            cell.setup()
            cell.lblQues.text = data.question
            
            let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(self.leftSwiped))
            swipeLeft.direction = UISwipeGestureRecognizer.Direction.left
            cell.addGestureRecognizer(swipeLeft)
            
            let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(self.rightSwiped))
            swipeRight.direction = UISwipeGestureRecognizer.Direction.right
            cell.addGestureRecognizer(swipeRight)
            return cell
        }
        
        
        return UICollectionViewCell()
    }
    
    @objc func leftSwiped(){
        print("left swipe----------->>>>")
//        var isValueSelected:Bool = false
//        var isValueSelectedForReload = false
//        for data in arrData{
//            for d in data.options{
//                if d.isSelected{
//                    isValueSelected = true
//                    break
//                }
//            }
//        }
//        for d in arrData[row].options{
//            if d.isSelected{
//                isValueSelectedForReload = true
//                break
//            }
//        }
//        if row < arrData.count{
//            if  row <= arrData.count-1 && isValueSelectedForReload == true{
//
//                collectionViewQues.reloadData()
//            }
//            else{
//                CommonFunctions.showAlertWithTitle(title: ValidationConstants.ErrorTitle, message: ValidationConstants.ErrorSelectOneOption)
//                return
//            }
//        }
//        if btnNext.title(for: .normal) == "SUBMIT" && isValueSelected{
//           // hitAPI()
//            return
//        }
        if row < arrData.count-1{
            if row <= arrData.count-1{
                 collectionViewQues.reloadData()
            }
        row = row + 1
        
        }
        if row == arrData.count-1{
            btnNext.setTitle("SUBMIT", for: .normal)
        }
    }
    @objc func rightSwiped(){
         print("right swipe----------->>>>")
//        var isValueSelected:Bool = false
//        var isValueSelectedForReload = false
//        for data in arrData{
//            for d in data.options{
//                if d.isSelected{
//                    isValueSelected = true
//                    break
//                }
//            }
//        }
//        for d in arrData[row].options{
//            if d.isSelected{
//                isValueSelectedForReload = true
//                break
//            }
//        }
//        if row < arrData.count{
//            if  row <= arrData.count-1 && isValueSelectedForReload == true{
//
//                collectionViewQues.reloadData()
//            }
//            else{
//                CommonFunctions.showAlertWithTitle(title: ValidationConstants.ErrorTitle, message: ValidationConstants.ErrorSelectOneOption)
//                return
//            }
//        }
////        if btnNext.title(for: .normal) == "SUBMIT" && isValueSelected{
////          //  hitAPI()
////            return
////        }
        if row > 0{
            row = row - 1
            collectionViewQues.reloadData()
        }
        if row == arrData.count-1{
            btnNext.setTitle("SUBMIT", for: .normal)
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
       
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize.init(width: collectionView.frame.size.width, height: collectionView.frame.size.height)
    }
    
}
