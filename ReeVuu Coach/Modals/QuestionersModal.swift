//
//  QuestionersModal.swift
//  ReeVuu Coach
//
//  Created by Dev on 23/10/18.
//  Copyright © 2018 Dev. All rights reserved.
//

import UIKit

class QuestionersModal: NSObject {
    static let shared : QuestionersModal = QuestionersModal()
    var quesNo:Int?
    var question:String?
    //var quesType:Int = 1 //1-3buttons,2-6buttons
    var isSelected:Bool = false
    var options = [OptionModal]()
   
    
   
    var arrQues = [QuestionersModal]()
    
    var id :String = ""
    var answer:String = ""
    var option:String = ""
    var questionType:Int = 0 // 1 for single, 2- multiple selection
   
    
    
    func setData(arrEntity:[QuestionEntity])->[QuestionersModal]{
        var i = 0
        for value1 in arrEntity{
           i = i + 1
           let data = QuestionersModal()
            data.quesNo = i
            data.question = value1.question
            data.id = value1.id ?? ""
            
            let arrOption = value1.option?.components(separatedBy: ",")
            for a in arrOption ?? []{
                let d = OptionModal()
                d.options = a
                d.questionType = value1.type
                data.options.append(d)
            }
            data.questionType = Int(value1.type ?? "") ?? 0
            
           arrQues.append(data)
        }
        
        
        return arrQues
    }
    
    
    static func initWithDictionary(dict:NSDictionary)-> QuestionersModal {
        let sm = QuestionersModal()
        sm.question = NSUtility.getObjectForKey("question", dictResponse: dict) as? String ?? ""
        if NSUtility.getObjectForKey("id", dictResponse: dict) is String {
            sm.id = ""
        }
        else{
            sm.id = "\(NSUtility.getObjectForKey("id", dictResponse: dict) as! Int)"
        }
        sm.answer = NSUtility.getObjectForKey("answers", dictResponse: dict) as? String ?? ""
        sm.option = NSUtility.getObjectForKey("option", dictResponse: dict) as? String ?? ""
      
        if NSUtility.getObjectForKey("question_type", dictResponse: dict) is String {
            sm.questionType = 0
        }
        else{
            sm.questionType = NSUtility.getObjectForKey("question_type", dictResponse: dict) as! Int
        }
        return sm
    }
    
    static func parseDictArrayToModalArray(attributes : NSArray)->NSMutableArray{
        let modalArr=NSMutableArray()
        for dict in attributes {
            let sm = self.initWithDictionary(dict: dict as! NSDictionary)
            modalArr.add(sm)
            DBManager.saveDataWithParameters(uModal: sm, dataType: QuestionersModal.self)
        }
        return modalArr
    }
    
}



class OptionModal:NSObject{
    var options:String?
    var isSelected:Bool = false
    var isMultiple:Bool = true
    var questionType:String?
}
