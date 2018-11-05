//
//  PushNotification.swift
//  Brezaa
//
//  Created by dev on 11/08/17.
//  Copyright © 2017 Applify. All rights reserved.
//

import UIKit
import CoreData
class PushNotification: NSObject {
    
    static let sharedInstance = PushNotification()
    
    public  func handlePushWithPushData(modalPush : PushModel) {
        let navController = KAPPDELEGATE?.window?.rootViewController as! UINavigationController
        
        if modalPush.pushType == "1"{
            
            if UserDefaults.standard.value(forKey: UserDefaultConstants.userAccessToken) != nil
            {
                let accessToken : String = UserDefaults.standard.value(forKey: UserDefaultConstants.userAccessToken) as! String
                let accessTokenFromPush  = modalPush.pushAccessToken
                
                if accessToken == accessTokenFromPush
                {
                    if KAPPDELEGATE?.isEmailVerificationScreenOpen == true
                    {
                        NotificationCenter.default.post(name: Notification.Name(UserDefaultConstants.notificationEmailVerification), object: nil)
                    }
                    else
                    {
                        let controller = StoreyBoard.StoreyboardIntial().storeyboadForReevuu.instantiateViewController(withIdentifier: "ChooseYourSportVC") as! ChooseYourSportVC
                        navController.pushViewController(controller, animated: false)
                    }
                }
            }
            
        }
        
    }
    
}

