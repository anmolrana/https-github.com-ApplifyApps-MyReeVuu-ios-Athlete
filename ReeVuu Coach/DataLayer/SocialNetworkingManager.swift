//
//  SocialNetworkingManager.swift
//  ReeVuu Coach
//
//  Created by Dev on 18/10/18.
//  Copyright © 2018 Dev. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit
import GoogleSignIn

class SocialNetworkingManager: NSObject ,GIDSignInDelegate,GIDSignInUIDelegate{

    static let shared: SocialNetworkingManager  = SocialNetworkingManager()
    
    class func connectToFacebook(fromViewController:UIViewController,completion: @escaping(_ success:Bool,_ userModal:UserModal?)->Void){
        
       
        if !NSUtility.isConnectedToNetwork()
        {
            CommonFunctions.showAlertWithTitle(title: ValidationConstants.ErrorTitle, message: ValidationConstants.ErrorInternetConnection)
            return
        }
        
        
        let loginManager: FBSDKLoginManager = FBSDKLoginManager()
        loginManager.logOut()
        
        
        if (FBSDKAccessToken.current() == nil) {
            
            let facebookReadPermissions = ["public_profile", "email"]
            
            FBSDKLoginManager().loginBehavior = FBSDKLoginBehavior.web
            FBSDKLoginManager().logIn(withReadPermissions: facebookReadPermissions, from: fromViewController, handler: { (result:FBSDKLoginManagerLoginResult!, error:Error! ) -> Void in
                if ((error) != nil)
                {
                    print(error?.localizedDescription ?? "")
                    CommonFunctions.showAlertWithTitle(title: ValidationConstants.ErrorTitle, message: error.localizedDescription)
                    completion(false,nil)
                    
                }
                else
                {
                    FBSDKGraphRequest.init(graphPath: "me", parameters: ["fields":"first_name, last_name, picture.width(640).height(640),email,id,gender"]).start { (connection, result, error) -> Void in
                        guard (result as? NSDictionary) != nil else{
                        completion(false,nil)
                            return
                        }
                        
                        if let temp = result as? NSDictionary{
                            let strFullName: String = (temp["first_name"] as? String)! + " " + (temp["last_name"] as? String)!
                            let strFirstName: String = (temp["first_name"] as? String) ?? ""
                            let strLastName: String = (temp["last_name"] as? String) ?? ""
                            let fbImageUrl = temp.value(forKeyPath: "picture.data.url") as! String
                            let gender: String = (temp["gender"] as? String) ?? ""
                            print("###########\(gender)")
                            let userObject = UserModal()
                            userObject.username = strFullName
                            userObject.firstName = strFirstName
                            userObject.lastName = strLastName
                            userObject.email = temp["email"] as? String ?? ""
                            userObject.userFbId =  temp["id"] as? String ?? ""
                            userObject.profilePic = fbImageUrl
                            userObject.profilePicUrl = fbImageUrl
                            userObject.platformStatus = "1"
                            userObject.userSignInType = 1
                            completion(true,userObject)

                        }
                    }
                }
                } as FBSDKLoginManagerRequestTokenHandler)
        }
        else{
            let graphRequest : FBSDKGraphRequest = FBSDKGraphRequest(graphPath:  "me?fields=id,first_name, last_name,email,gender,picture.type(large)", parameters: nil)
            graphRequest.start(completionHandler: { (connection, result, error) -> Void in
                
                if ((error) != nil)
                {
                    
                    print(error?.localizedDescription ?? "")
                    completion(false,nil)
                }
                else
                {
                    
                    guard (result as? NSDictionary) != nil else{
                      completion(false,nil)
                        return
                    }
                    
                    let temp = result as! NSDictionary
                    let strFullName: String = (temp["name"] as? String) ?? ""
                    let strFirstName: String = (temp["first_name"] as? String) ?? ""
                    let strLastName: String = (temp["last_name"] as? String) ?? ""
                    let fbImageUrl = temp.value(forKeyPath: "picture.data.url") as! String
                    let gender: String = (temp["gender"] as? String) ?? ""
                    print("###########\(gender)")
                    
                    let userObject = UserModal()
                    userObject.username = strFullName
                    userObject.firstName = strFirstName
                    userObject.lastName = strLastName
                    userObject.email = temp["email"] as? String ?? ""
                    userObject.userFbId =  temp["id"] as? String ?? ""
                    userObject.profilePic = fbImageUrl
                    userObject.profilePicUrl = fbImageUrl
                    userObject.platformStatus = "1"
                    userObject.userSignInType = 1
                    completion(true,userObject)
                }
            })
        }
        
        
    }
    
    //MARK:- Google Integration
    
    func setupDelegates(){
        GIDSignIn.sharedInstance().delegate = self
    }
    
    class func connectToGoogle(){
       
        
        if !NSUtility.isConnectedToNetwork()
        {
            CommonFunctions.showAlertWithTitle(title: ValidationConstants.ErrorTitle, message: ValidationConstants.ErrorInternetConnection)
            return
        }
        GIDSignIn.sharedInstance().signOut()
        GIDSignIn.sharedInstance().signIn()
    }
    
    
    // google SignIn delegates

    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!){
        
        if let error = error{
            print("\(error.localizedDescription)")
            if appDelegateObject().googleSignInCallback != nil {
                appDelegateObject().googleSignInCallback(false,nil)
            }
        }
        else{
            //perform any operation on signed in user here
            let userId = user.userID
            // let idToken = user.authentication.idToken
            let fullname = user.profile.name
            let givenName = user.profile.givenName
            let familyName = user.profile.familyName
            let email = user.profile.email
            var img = ""
            if user.profile.hasImage {
                img = user.profile.imageURL(withDimension: 200*200)?.absoluteString ?? ""
            }
            
            let userObject = UserModal()
            userObject.username = fullname ?? ""
            userObject.firstName = givenName ?? ""
            userObject.lastName = familyName ?? ""
            userObject.email = email ?? ""
            
            userObject.profilePic = img
            userObject.googleId = userId
            userObject.userSignInType = 2
            if appDelegateObject().googleSignInCallback != nil {
                appDelegateObject().googleSignInCallback(true,userObject)
            }
            
        }
    }
    
    
    
    
    
}
