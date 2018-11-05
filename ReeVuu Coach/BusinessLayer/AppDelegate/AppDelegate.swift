//
//  AppDelegate.swift
//  ProjectTemplate
//
//  Created by Ankit Goyal on 15/03/2018.
//  Copyright © 2018 Applify Tech Pvt Ltd. All rights reserved.
//

import UIKit
import CoreData
import FBSDKCoreKit
import GoogleSignIn
import IQKeyboardManagerSwift
import Firebase
import FirebaseMessaging
import UserNotifications
import UserNotificationsUI

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate,UNUserNotificationCenterDelegate,MessagingDelegate{

    var window: UIWindow?
    typealias GoogleSignInCallback = (_ success:Bool,_ userModal:UserModal?)->Void
    var googleSignInCallback:GoogleSignInCallback! = nil
    var isEmailVerificationScreenOpen = Bool()
    var restrictRotation:UIInterfaceOrientationMask = .portrait

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.shouldResignOnTouchOutside = true
        GIDSignIn.sharedInstance()?.clientID = "491905689238-nc2l95a5tal6td2qjtmkou6eaivts3ct.apps.googleusercontent.com"
      //  GIDSignIn.sharedInstance().clientID = "445619030814-ci8k8ja1hjs2auf48gn6sqgh1vurecqm.apps.googleusercontent.com"
        FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
        
        //firebase
        FirebaseApp.configure()
        
        self.registerForPushNotifications(application)
        
        return true
    }

    //MARK:- Helper
    func registerForPushNotifications(_ application: UIApplication){
        Messaging.messaging().delegate = self
        if #available(iOS 10, *) {
            
            let center = UNUserNotificationCenter.current()
            center.requestAuthorization(options:[.badge, .alert, .sound]) { (granted, error) in
                // Enable or disable features based on authorization.
            }
            center.delegate=self
            application.registerForRemoteNotifications()
        }
        else{
            let settings = UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            application.registerUserNotificationSettings(settings)
            application.registerForRemoteNotifications()
        }
    }
    
    // MARK: Notification Delegate method
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {
        
        let token = fcmToken
        KUSERDEFAULT.setValue(token, forKey: UserDefaultConstants.userDeviceToken)
        KUSERDEFAULT.synchronize()
        if KUSERDEFAULT.value(forKey: UserDefaultConstants.userAccessToken) == nil {
            return
        }
        UserModal.updateDeviceTokenApi(strApi: APIURL.BaseUrl + APIURL.deviceTokenUpdateUrl, parameters: ["access_token":KUSERDEFAULT.value(forKey: UserDefaultConstants.userAccessToken) as Any,"device_token":token], ProfilePic: nil, withCompletionHandler: { (success) in
            
        }) { (error) in
            
        }
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        _ = NSString.convertDeviceTokenToString(deviceToken)
        Messaging.messaging().apnsToken = deviceToken
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        //  print("Device token for push notifications: FAIL -- ")
        
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }
    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask
    {
        return self.restrictRotation
    }
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        self.saveContext()
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        GIDSignIn.sharedInstance().handle(url, sourceApplication: options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String, annotation: options[UIApplication.OpenURLOptionsKey.annotation])
        return FBSDKApplicationDelegate.sharedInstance().application(app, open: url, options: options)
    }

    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Swift.Void){
        //  print("push will recieve")
        let pushDictionary = notification.request.content.userInfo
        let modalPush = PushModel.setAttributes(dict: pushDictionary as NSDictionary)
        if modalPush.pushType == "1" && isEmailVerificationScreenOpen == true{
            NotificationCenter.default.post(name: Notification.Name(UserDefaultConstants.notificationEmailVerification), object: nil)
            return
        }

        else{

            //            if  USERDEFAULT.value(forKey: NMUserDefaultAccessToken) != nil && modalPush.pushType  != "2"{
            completionHandler([.alert,.sound])
            //  }
        }
        
        
    }
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Swift.Void){
        let pushDictionary = response.notification.request.content.userInfo
        let pushObject = PushNotification.sharedInstance as PushNotification
        let modalPush = PushModel.setAttributes(dict: pushDictionary as NSDictionary)
        
        pushObject.handlePushWithPushData(modalPush: modalPush)
    }
    

    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "ReeVuu_Coach")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

}

func appDelegateObject()-> AppDelegate{
    return UIApplication.shared.delegate as! AppDelegate
}
