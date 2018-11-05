//
//  UserModal.swift
//  ReeVuu Coach
//
//  Created by Dev on 22/10/18.
//  Copyright © 2018 Dev. All rights reserved.
//

import UIKit

class UserModal: NSObject {

    
    var firstName:String = ""
    var lastName:String = ""
  
    var profilePic:String = ""
    var facebookId:String = ""
    var platformStatus:String = ""
    var deviceId:String = ""
    var age:String = ""
    var userFbId:String = ""
    var profilePicUrl:String = ""
    
    
    var id: Int = 0
    var name:String = ""
    var username:String = ""
    var email: String = ""
    var gender: Int = 0
    var phoneNumber :String = ""
    var accessToken: String = ""
    var userType:Int = 0
    var accountType:Int = 0
    var emailVerified:Int = 0
    var isBlocked: Int = 0
    var isApproved: Int = 0
 
    var profileStatus: Int = 0
    var createdAt:String = ""
    var updatedAt: String = ""
    //let sportInfo: [Sport]
    
    var levels: [LevelModal]?
    var sports: [SportModal]?
    var states: [StateModal]?
    var sportInfo:[AthleteBackgroundModal]?
    var questions: [QuestionersModal]?
    var dexterity:String = ""
    var dob:String = ""
    var height:String = ""
    var weight:String = ""
    //var facebookPicUrl:String!
    //var profileStatus:String = ""
    
    var googleId:String!
  //  var googlePicUrl:String!
    var userSignInType:Int?       //0-normal, 1-facebook, 2-google
    var isEmailVerified:Int?

    
    static  func initWithDictionary(dict:NSDictionary)-> UserModal {
         let um = UserModal()
        um.accessToken = NSUtility.getObjectForKey(APIKeys.accessToken, dictResponse: dict) as? String ?? ""
        //um.accountType = NSUtility.getObjectForKey("account_type", dictResponse: dict)
        if NSUtility.getObjectForKey(APIKeys.accountType, dictResponse: dict) is String {
             um.accountType = 0
        }
        else{
              um.accountType = NSUtility.getObjectForKey(APIKeys.accountType, dictResponse: dict) as! Int
        }
        um.createdAt = NSUtility.getObjectForKey(APIKeys.createdAt, dictResponse: dict) as? String ?? ""
        um.dexterity = NSUtility.getObjectForKey(APIKeys.dexterity, dictResponse: dict) as? String ?? ""
        um.dob = NSUtility.getObjectForKey(APIKeys.dob, dictResponse: dict) as? String ?? ""
        um.email = NSUtility.getObjectForKey(APIKeys.email, dictResponse: dict) as? String ?? ""
        if NSUtility.getObjectForKey(APIKeys.emailVerified, dictResponse: dict) is String {
            um.emailVerified = 0
        }
        else{
            um.emailVerified = NSUtility.getObjectForKey(APIKeys.emailVerified, dictResponse: dict) as! Int
        }
        if NSUtility.getObjectForKey(APIKeys.gender, dictResponse: dict) is String {
            um.gender = 0
        }
        else{
            um.gender = NSUtility.getObjectForKey(APIKeys.gender, dictResponse: dict) as! Int
        }
        um.height = NSUtility.getObjectForKey(APIKeys.height, dictResponse: dict) as? String ?? ""
        if NSUtility.getObjectForKey(APIKeys.id, dictResponse: dict) is String {
            um.id = 0
        }
        else{
            um.id = NSUtility.getObjectForKey(APIKeys.id, dictResponse: dict) as! Int
        }
        if NSUtility.getObjectForKey(APIKeys.isApproved, dictResponse: dict) is String {
            um.isApproved = 0
        }
        else{
            um.isApproved = NSUtility.getObjectForKey(APIKeys.isApproved, dictResponse: dict) as! Int
        }
        if NSUtility.getObjectForKey(APIKeys.isBlocked, dictResponse: dict) is String {
            um.isBlocked = 0
        }
        else{
            um.isBlocked = NSUtility.getObjectForKey(APIKeys.isBlocked, dictResponse: dict) as! Int
        }
        um.name = NSUtility.getObjectForKey(APIKeys.name, dictResponse: dict) as? String ?? ""
        um.phoneNumber = NSUtility.getObjectForKey(APIKeys.phoneNo, dictResponse: dict) as? String ?? ""
        um.profilePic = NSUtility.getObjectForKey(APIKeys.profilePic, dictResponse: dict) as? String ?? ""
        if NSUtility.getObjectForKey(APIKeys.userType, dictResponse: dict) is String {
            um.userType = 0
        }
        else{
            um.userType = NSUtility.getObjectForKey(APIKeys.userType, dictResponse: dict) as! Int
        }
        um.username = NSUtility.getObjectForKey(APIKeys.username, dictResponse: dict) as? String ?? ""
        um.updatedAt = NSUtility.getObjectForKey(APIKeys.updatedAt, dictResponse: dict) as? String ?? ""
        um.weight = NSUtility.getObjectForKey(APIKeys.weight, dictResponse: dict) as? String ?? ""
        if NSUtility.getObjectForKey(APIKeys.profileStatus, dictResponse: dict) is String {
            um.profileStatus = 0
        }
        else{
            um.profileStatus = NSUtility.getObjectForKey(APIKeys.profileStatus, dictResponse: dict) as! Int
        }
        let array = dict.value(forKey: APIKeys.questions) as? NSArray
        if array != nil {
            um.questions = QuestionersModal.parseDictArrayToModalArray(attributes: array ?? []) as? [QuestionersModal]
        }
        if let array1 = dict.value(forKey: APIKeys.sportInfo){
            um.sportInfo = AthleteBackgroundModal.parseDictArrayToModalArray(attributes: array1 as! NSArray) as? [AthleteBackgroundModal]
        }
        return um
    }
    
    static func parseDictArrayToModalArray(attributes : NSArray)->NSMutableArray{
        let modalArr=NSMutableArray()
        for dict in attributes {
            modalArr.add(self.initWithDictionary(dict: dict as! NSDictionary))
            
        }
        return modalArr
    }
    
   
    
    static func GetUserDataInResponseToApi(strApi:String,parameters : NSDictionary,ProfilePic:NSDictionary?,withCompletionHandler :@escaping (_ userData:UserModal)->Void, AndError :@escaping (_ error : NSString)->Void){
        
        if !NSUtility.isConnectedToNetwork()
        {
            AndError(ValidationConstants.ErrorInternetConnection as NSString)
            
        }
        else{
            if ProfilePic == nil{
                
                APIRequest.callApiWithParameters(url: strApi, method: .POST, parameters: parameters as! [String:AnyObject], headers: [:], image: nil, imageParameters: "", success: { (success) in
                    print(success)
                    let dict = success["response"]
                    if dict == nil{
                        if success["error"] != nil{
                            let dict1 = success["error"] as! NSDictionary
                            if dict1["code"] as! Int == 420{
                                CommonFunctions.HandleInvalidAccessToken()
                                
                                return
                            }
                            AndError(dict1["message"]! as! NSString)
                            return
                        }
                    }
                    else{
    
                        let sportDict = success["sports"]
                        if sportDict == nil{
                            if success["error"] != nil{
                                let dict1 = success["error"] as! NSDictionary
                                if dict1["code"] as! Int == 420{
                                    CommonFunctions.HandleInvalidAccessToken()
                                    
                                    return
                                }
                                AndError(dict1["message"]! as! NSString)
                                return
                            }
                        }
                        else{
                            _ = SportModal.parseDictArrayToModalArray(attributes : sportDict as! NSArray)
                        }
                        
                        let stateDict = success["states"]
                        if stateDict == nil{
                            if success["error"] != nil{
                                let dict1 = success["error"] as! NSDictionary
                                if dict1["code"] as! Int == 420{
                                    CommonFunctions.HandleInvalidAccessToken()
                                    
                                    return
                                }
                                AndError(dict1["message"]! as! NSString)
                                return
                            }
                        }
                        else{
                            _ = StateModal.parseDictArrayToModalArray(attributes : stateDict as! NSArray)

                        }
                        let levelDict = success["levels"]
                        if levelDict == nil{
                            if success["error"] != nil{
                                let dict1 = success["error"] as! NSDictionary
                                if dict1["code"] as! Int == 420{
                                    CommonFunctions.HandleInvalidAccessToken()
                                    
                                    return
                                }
                                AndError(dict1["message"]! as! NSString)
                                return
                            }
                        }
                        else{
                            _ = LevelModal.parseDictArrayToModalArray(attributes : levelDict as! NSArray)
                        }
                        
                        let um = self.initWithDictionary(dict: dict as! NSDictionary)
                        KUSERDEFAULT.setValue(um.accessToken, forKey: UserDefaultConstants.userAccessToken)
                        KUSERDEFAULT.setValue("\(um.id)", forKey: UserDefaultConstants.userID)
                        DBManager.saveUserDataWithParameters(uModal: um)
                        withCompletionHandler(um)
                    }
                }, failure: { (error) in
                    AndError(error as NSString)
                })
            }
            else{
                APIRequest.callApiWithParameters(url: strApi, method: .PostWithImage, parameters: parameters as! [String : AnyObject], headers: [:], image: ProfilePic?["pic"] as? UIImage, imageParameters: "profile_pic", success: { (success) in
                    let dict = success["response"]
                    //print(dict)
                    if dict == nil{
                        if success["error"] != nil{
                            let dict1 = success["error"] as! NSDictionary
                            if dict1["code"] as! Int == 420{
                                CommonFunctions.HandleInvalidAccessToken()
                                return
                            }
                            AndError(dict1["message"]! as! NSString)
                            return
                        }
                    }
                    else{
                        let um = self.initWithDictionary(dict: dict as! NSDictionary)
                        DBManager.saveUserDataWithParameters(uModal: um)
                        withCompletionHandler(um)
                    }
                }, failure: { (error) in
                    AndError(error as NSString)
                })
            }
        }
    }
    
    
    
    static func updateDeviceTokenApi(strApi:String,parameters : NSDictionary,ProfilePic:NSDictionary?,withCompletionHandler :@escaping (_ str:String)->Void, AndError :@escaping (_ error : NSString)->Void){
       
        APIRequest.callApiWithParameters(url: strApi, method: .POST, parameters: parameters as! [String : AnyObject], headers: [:], image: nil, imageParameters: "", success: { (success) in
            
        }, failure: { (error) in
            
        })
    }
    
    
    static func StringResponseToApi(strApi:String,parameters : NSDictionary,ProfilePic:NSDictionary?,withCompletionHandler :@escaping (_ str:String)->Void, AndError :@escaping (_ error : NSString)->Void){
        
        
        if !NSUtility.isConnectedToNetwork()
        {
            AndError(ValidationConstants.ErrorInternetConnection as NSString)
            return
        }
        
        
        APIRequest.callApiWithParameters(url: strApi, method: .POST, parameters: parameters as! [String : AnyObject], headers: [:], image: nil, imageParameters: "", success: { (success) in
            let dict = success["response"]
            if dict == nil{
                if success["error"] != nil{
                    let dict1 = success["error"] as! NSDictionary
                    if dict1["code"] as! Int == 420{
                        CommonFunctions.HandleInvalidAccessToken()
                        return
                    }
                    AndError(dict1["message"]! as! NSString)
                    return
                }
            }
            else{
                if success["response"] is NSString{
                    withCompletionHandler((success["response"] as! NSString) as String)
                    return
                }
                let dict1 = success["response"] as! NSDictionary
                withCompletionHandler((dict1["message"] as! NSString) as String)
            }
        }, failure: { (error) in
            AndError(error as NSString)
        })
        
        
    }
    
}




class LevelModal: NSObject {
    var id: Int = 0
    var name: String = ""
    static func initWithDictionary(dict:NSDictionary)-> LevelModal {
        let sm = LevelModal()
        sm.name = NSUtility.getObjectForKey("name", dictResponse: dict) as? String ?? ""
        if NSUtility.getObjectForKey("id", dictResponse: dict) is String {
            sm.id = 0
        }
        else{
            sm.id = NSUtility.getObjectForKey("id", dictResponse: dict) as! Int
        }
        return sm
    }
    
    static func parseDictArrayToModalArray(attributes : NSArray)->NSMutableArray{
        let modalArr=NSMutableArray()
        for dict in attributes {
            let sm = self.initWithDictionary(dict: dict as! NSDictionary)
            modalArr.add(sm)
            DBManager.saveDataWithParameters(uModal: sm, dataType: LevelModal.self)
        }
        return modalArr
    }
}



class SportModal: NSObject {
    var id: Int = 0
    var name:String = ""
    var sportDescription: String = ""
    var image: String = ""
    
    
    static func initWithDictionary(dict:NSDictionary)-> SportModal {
        let sm = SportModal()
        sm.name = NSUtility.getObjectForKey("name", dictResponse: dict) as? String ?? ""
        if NSUtility.getObjectForKey("id", dictResponse: dict) is String {
            sm.id = 0
        }
        else{
            sm.id = NSUtility.getObjectForKey("id", dictResponse: dict) as! Int
        }
        sm.sportDescription = NSUtility.getObjectForKey("description", dictResponse: dict) as? String ?? ""
        sm.image = NSUtility.getObjectForKey("image", dictResponse: dict) as? String ?? ""
        return sm
    }
    
    static func parseDictArrayToModalArray(attributes : NSArray)->NSMutableArray{
        let modalArr=NSMutableArray()
        for dict in attributes {
            let sm = self.initWithDictionary(dict: dict as! NSDictionary)
            modalArr.add(sm)
            DBManager.saveDataWithParameters(uModal: sm, dataType: SportModal.self)
        }
        return modalArr
    }
}


class StateModal:NSObject{
    var id: Int = 0
    var name: String = ""
    static func initWithDictionary(dict:NSDictionary)-> StateModal {
        let sm = StateModal()
        sm.name = NSUtility.getObjectForKey("name", dictResponse: dict) as? String ?? ""
        if NSUtility.getObjectForKey("id", dictResponse: dict) is String {
            sm.id = 0
        }
        else{
            sm.id = NSUtility.getObjectForKey("id", dictResponse: dict) as! Int
        }
        return sm
    }
    
    static func parseDictArrayToModalArray(attributes : NSArray)->NSMutableArray{
        let modalArr=NSMutableArray()
        for dict in attributes {
            let sm = self.initWithDictionary(dict: dict as! NSDictionary)
            modalArr.add(sm)
            DBManager.saveDataWithParameters(uModal: sm, dataType: StateModal.self)
        }
        return modalArr
    }
}
