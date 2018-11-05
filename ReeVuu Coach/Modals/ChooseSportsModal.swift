//
//  ChooseSportsModal.swift
//  ReeVuu Coach
//
//  Created by Dev on 23/10/18.
//  Copyright © 2018 Dev. All rights reserved.
//

import UIKit

class ChooseSportsModal: NSObject {
    var id:String = ""
    var sportName:String?
    var sportDescription:String?
    var sportImage:String?
    var isSelected:Bool = false

}


class AthleteBackgroundModal:NSObject{
    static let shared = AthleteBackgroundModal()
    var sportPlayed:String = "Select"
    var yearOfPlayingExperience:String = "Select"
    var levelOfPlaying:String = "Select"
    var stateYouParticipatedIn:String = "Select"
    var zipCode:String = ""
    var isSelectedOption:String = ""
    
    
    var sportId:Int = 0
    var level :Int = 0
    var experience:Int = 0
    var zipcodeInfo:Int = 0
    var name:String = ""
    
    static func initWithDictionary(dict:NSDictionary)-> AthleteBackgroundModal {
        let sm = AthleteBackgroundModal()
        sm.name = NSUtility.getObjectForKey("name", dictResponse: dict) as? String ?? ""
      //  sm.name = NSUtility.getObjectForKey("name", dictResponse: dict) as? String ?? ""
        if NSUtility.getObjectForKey("sport_id", dictResponse: dict) is String {
            sm.sportId = 0
        }
        else{
            sm.sportId = NSUtility.getObjectForKey("sport_id", dictResponse: dict) as! Int
        }
        if NSUtility.getObjectForKey("experience", dictResponse: dict) is String {
            sm.experience = 0
        }
        else{
            sm.experience = NSUtility.getObjectForKey("experience", dictResponse: dict) as! Int
        }
        if NSUtility.getObjectForKey("level", dictResponse: dict) is String {
            sm.level = 0
        }
        else{
            sm.level = NSUtility.getObjectForKey("level", dictResponse: dict) as! Int
        }
        if NSUtility.getObjectForKey("zip_code", dictResponse: dict) is String {
            sm.zipcodeInfo = 0
        }
        else{
            sm.zipcodeInfo = NSUtility.getObjectForKey("zip_code", dictResponse: dict) as! Int
        }
        
//        if NSUtility.getObjectForKey("state_id", dictResponse: dict) is String {
//            sm.sportId = 0
//        }
//        else{
//            sm.sportId = NSUtility.getObjectForKey("state_id", dictResponse: dict) as! Int
//        }
       
        return sm
    }
    
    static func parseDictArrayToModalArray(attributes : NSArray)->NSMutableArray{
        let modalArr=NSMutableArray()
        for dict in attributes {
            let sm = self.initWithDictionary(dict: dict as! NSDictionary)
            modalArr.add(sm)
            DBManager.saveDataWithParameters(uModal: sm, dataType: AthleteBackgroundModal.self)
        }
        return modalArr
    }
}
