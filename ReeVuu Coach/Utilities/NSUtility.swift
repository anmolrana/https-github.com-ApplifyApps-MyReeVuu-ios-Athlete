//
//  NSUtility.swift
//  Brezaa
//
//  Created by Deepak Bhagat on 5/11/17.
//  Copyright © 2017 Applify. All rights reserved.
//

import UIKit
//import KDLoadingView

let debubPrintLog:Int = 2

class NSUtility: NSObject {

    
    class func shared()-> NSUtility{
        let nsutility = NSUtility()
        return nsutility
    }
    
    static var loader :LoaderView!
    
    // MARK: - Show Loader
    
    class func showLoader(){
        
        if loader == nil {
            
            loader = Bundle.main.loadNibNamed("LoaderView", owner: self, options: nil)![0] as? LoaderView
            loader.frame = CGRect(x:0, y:0, width:KScreenWidth, height:KScreenHeight)
            let appDelegate = UIApplication.shared.delegate as? AppDelegate
            appDelegate?.window?.addSubview(loader)
        }
        
    }
    
    class func dismissLoader(){
        
        if loader != nil
        {
            loader.removeFromSuperview()
            loader = nil
        }
        
    }
    
    
    
    //MARK: - Check For Empty String
    
    class func checkIfStringContainsText(_ string:String?) -> Bool
    {
        if let stringEmpty = string {
            let newString = stringEmpty.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
            if(newString.isEmpty){
                return false
            }
            return true
        } else {
            return false
        }
    }
    
    
    
    //MARK: - Get value from user defaults
    class func getValueFromUserDefaultsForKey(_ keyName:String!) -> AnyObject? {
        if !NSUtility.checkIfStringContainsText(keyName) {
            return nil
        }
        let value: AnyObject? = UserDefaults.standard.object(forKey: keyName) as AnyObject
        if value != nil {
            return value
        } else {
            return nil
        }
    }
    //MARK: - Set value to user defaults
    
    class func setValueToUserDefaultsForKey(_ keyName:String!, value:AnyObject!) {
        
        if !NSUtility.checkIfStringContainsText(keyName) {
            return
        }
        if  value == nil {
            return
        }
        UserDefaults.standard.set(value, forKey: keyName)
        UserDefaults.standard.synchronize()
    }
    
    //MARK: - NSNotificationCenter methods
    class func addObserverToNSNotificationCenterForNameKey(_ observer: AnyObject, selector: Selector, name: String?, object: AnyObject?) {
        
        if !NSUtility.checkIfStringContainsText(name) {
            return
        }
        
        NotificationCenter.default.addObserver(observer, selector: selector, name: name.map { NSNotification.Name(rawValue: $0) },object: object)
        
    }
    
    
    //Remove Observer frpm NSNotificationCenter defaultCenter
    class func removeObserverFromNSNotificationCenterForNameKey(_ observer: AnyObject, name: String?,object: AnyObject?) {
        
        NotificationCenter.default.removeObserver(observer, name: name.map { NSNotification.Name(rawValue: $0) }, object: object)
        
    }

    
    /**
     isConnectedToNetwork - This funcation is used to check if net is connected or not
     */
    class func isConnectedToNetwork() -> Bool {
        let reach:Reachability = Reachability.forInternetConnection()
        let netStatus:NetworkStatus = reach.currentReachabilityStatus()
        
        if (netStatus == NotReachable)
        {
            return false
        }
        
        return true
    }
    
    
    
    
    // MARK: - Show DebubLogs Methods
    /*
     1.    set value 1 to debubPrintLog to Enable the debuging logs
     2.    set value 0 to debubPrintLog to Disable the debuging logs
     3.    debubPrintLog is a Global variable
     */
    
    class func DBlog(_ message:AnyObject) {
        if debubPrintLog == 1{
            print(message)
        }
        else{
            
        }
        
    }
    /**
     getObjectForKey - This funcation is used to handle null values coming from backend and returning the value type required
     checkType - This funcation is used to check type required and return value of that type
     */
    class func getObjectForKey<P>(_ key:String!,dictResponse:NSDictionary!, type: P.Type) -> AnyObject! {
        if key != nil{
            if let dict = dictResponse {
                if let value = dict.value(forKey: key) as AnyObject? {
                    if let _:NSNull = value as? NSNull{
                        return checkType(type: type)
                    }else{
                        if let valueString = value as? String{
                            if valueString == "<null>"{
                                return checkType(type: type)
                            }
                        }
                        if value is Int || value is NSNumber{
                            return "\(value)" as AnyObject
                        }
                        return value
                    }
                } else {return checkType(type: type)}
            } else {return checkType(type: type)}
        } else {return checkType(type: type)}
    }
    
    class func checkType<T>(type: T.Type) -> AnyObject{
        var returntype:AnyObject?
        if type is String.Type {
            returntype = "" as AnyObject
            return returntype!
        }
        else if type is Int.Type {
            returntype = 0 as AnyObject
            return returntype!
        }
        else if type is Double.Type {
            returntype = 0.0 as AnyObject
            return returntype!
        }
        else if type is Float.Type {
            returntype = 0.0 as AnyObject
            return returntype!
        }
        else if type is NSNumber.Type {
            returntype = 0.0 as AnyObject
            return returntype!
        }
        else if type is NSArray.Type {
            let returnArr = NSArray()
            returntype = returnArr
            return returntype!
        }
        else if type is [String].Type {
            let returnArr = [String]()
            returntype = returnArr as AnyObject
            return returntype!
        }
        else if type is NSDictionary.Type {
            let returnDict = NSDictionary()
            returntype = returnDict
            return returntype!
        }
        returntype = "" as AnyObject
        return returntype!
    }
    
    
    //MARK: - Get value from dictionary

    class func getObjectForKey(_ key:String?,dictResponse:NSDictionary!) -> AnyObject! {
        if key != nil{
            if let dict = dictResponse {
                if let value = dict.value(forKey: key!) as AnyObject! {
                    if let _:NSNull = value as? NSNull{
                        return "" as AnyObject
                    }else{
                        if let valueString = value as? String{
                            if valueString == "<null>"{
                                return "" as AnyObject
                            }
                        }
                        return value
                    }
                } else {return "" as AnyObject}
            } else {return "" as AnyObject}
        } else {return "" as AnyObject}
    }
    
    class func getObjectForKeyNumber(_ key:String!,dictResponse:NSDictionary!) -> NSNumber! {
        if key != nil{
            if let dict = dictResponse {
                if let value: AnyObject = dict.value(forKey: key) as AnyObject! {
                    if let _:NSNull = value as? NSNull{
                        return 0
                    }else{
                        if let valueString = value as? String{
                            if valueString == "<null>"{
                                return 0
                            }
                        }
                        return value as? NSNumber
                    }
                } else {return 0}
            } else {return 0}
        } else {return 0}
    }
    
    class func getObjectForKeyInt(_ key:String!,dictResponse:NSDictionary!) -> Int! {
        if key != nil{
            if let dict = dictResponse {
                if let value: AnyObject = dict.value(forKey: key) as AnyObject! {
                    if let _:NSNull = value as? NSNull{
                        return 0
                    }else{
                        if let valueString = value as? String{
                            if valueString == "<null>"{
                                return 0
                            }
                        }
                        return Int(String(describing:value as AnyObject))
                    }
                } else {return 0}
            } else {return 0}
        } else {return 0}
    }
    
    



// Create Image from uicolor


class func GetImageWithColor(color:UIColor)->UIImage{

    let rect = CGRect(x:0.0, y:0.0, width:1.0, height:1.0 )
    UIGraphicsBeginImageContext(rect.size)
    let context = UIGraphicsGetCurrentContext()
    context!.setFillColor(color.cgColor)
    context!.fill(rect)
    let image = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()

    return image!
    
}
        
    
}
