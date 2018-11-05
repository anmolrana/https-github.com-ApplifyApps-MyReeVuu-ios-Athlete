//
//  PushModal.swift
//  Brezaa
//
//  Created by dev on 11/08/17.
//  Copyright © 2017 Applify. All rights reserved.
//

import UIKit

class PushModel: NSObject {
    var pushType:String!
    var pushTitle:String!
    var pushBroadcastTitle:String!
    var pushBroadcastMessage:String!
    var pushBody:String!
    var pushId:String!
    var pushAccessToken:String!
    var pushUserId:String!
    var pushUserName:String!
    class func setAttributes(dict:NSDictionary)-> PushModel {
        let modelobject = PushModel()
        modelobject.pushType = NSUtility.getObjectForKey("push_type", dictResponse: dict, type: String.self) as! String?
        
        modelobject.pushTitle = NSUtility.getObjectForKey("title", dictResponse: dict, type: String.self) as! String?
        modelobject.pushBroadcastTitle = NSUtility.getObjectForKey("b_title", dictResponse: dict, type: String.self) as! String?
        modelobject.pushBroadcastMessage = NSUtility.getObjectForKey("message", dictResponse: dict, type: String.self) as! String?
        modelobject.pushBody = NSUtility.getObjectForKey("body", dictResponse: dict, type: String.self) as! String?
        modelobject.pushId = NSUtility.getObjectForKey("id", dictResponse: dict, type: String.self) as! String?
        modelobject.pushAccessToken = NSUtility.getObjectForKey("access_token", dictResponse: dict, type: String.self) as! String?
        
        modelobject.pushUserId = NSUtility.getObjectForKey("user_id", dictResponse: dict, type: String.self) as! String?
        modelobject.pushUserName = NSUtility.getObjectForKey("full_name", dictResponse: dict, type: String.self) as! String?
         
        return modelobject
    }
}

class ChatPushModal:NSObject{
    
    var pushType:String!
    var message:String!
    var accessToken:String!
    var chatDialogId:String!
    var name:String!
    var userId:String?
    
    
    class func setAttributes(dict:NSDictionary)-> ChatPushModal {
        let modelobject = ChatPushModal()
        modelobject.pushType = NSUtility.getObjectForKey("type", dictResponse: dict, type: String.self) as? String ?? ""
         modelobject.accessToken = NSUtility.getObjectForKey("access_token", dictResponse: dict, type: String.self) as? String ?? ""
        modelobject.message = NSUtility.getObjectForKey("message", dictResponse: dict, type: String.self) as? String ?? ""
        modelobject.name = NSUtility.getObjectForKey("sender_name", dictResponse: dict, type: String.self) as? String ?? ""
       
        modelobject.chatDialogId = NSUtility.getObjectForKey("chat_dialog_id", dictResponse: dict, type: String.self) as? String ?? ""
        modelobject.userId = NSUtility.getObjectForKey("sender_id", dictResponse: dict, type: String.self) as? String ?? ""
        
        return modelobject
    } 
    
}
