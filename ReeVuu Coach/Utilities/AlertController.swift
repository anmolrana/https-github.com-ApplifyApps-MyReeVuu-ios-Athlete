//
//  AlertController.swift
//  FoodCoupons
//
//  Created by Developer on 26/09/18.
//  Copyright © 2018 Developer. All rights reserved.
//
import UIKit

open class AlertController {
    
    // MARK: - Singleton
    
    static let instance = AlertController()
    
    // MARK: - Private Functions
    
    fileprivate func topMostController() -> UIViewController? {
        
        var presentedVC = UIApplication.shared.keyWindow?.rootViewController
        while let pVC = presentedVC?.presentedViewController {
            presentedVC = pVC
        }
        
        if presentedVC == nil {
            //print("AlertController Error: You don't have any views set. You may be calling in viewdidload. Try viewdidappear.")
        }
        return presentedVC
    }
    
    // MARK: - Class Functions
    
    open class func alert(title: String) {
        return alert(title: title, message: "")
    }
    
    open class func alert(message: String) {
        return alert(title: "",
                     message: message)
    }
    
    open class func alert(title: String,
                          message: String) {
        return alert(title: title,
                     message: message,
                     acceptMessage: "OK") { () -> () in
        }
    }
    
    open class func alert(title: String,
                          message: String,
                          acceptMessage: String,
                          acceptBlock: @escaping () -> ()) {
        DispatchQueue.main.async(execute: {
            // No use of title in parameter
            // Using app name as a title of alert
            let alert = UIAlertController(title: AppName,
                                          message: message,
                                          preferredStyle: .alert)
            let acceptButton = UIAlertAction(title: acceptMessage,
                                             style: .cancel,
                                             handler: { (action: UIAlertAction) in
                                                acceptBlock()
            })
            alert.addAction(acceptButton)
            instance.topMostController()?.present(alert,
                                                  animated: true,
                                                  completion: nil)
        })
    }
    
    open class func alert(title: String, message: String, buttons:[String], tapBlock:((UIAlertAction,Int) -> Void)?) {
        
       
        DispatchQueue.main.async(execute: {
            let alert = UIAlertController(title: title,
                                          message: message,
                                          preferredStyle: .alert,
                                          buttons: buttons,
                                          tapBlock: tapBlock)
            instance.topMostController()?.present(alert,
                                                  animated: true,
                                                  completion: nil)
        })
    }
    
    open class func actionSheet(title: String,
                                message: String,
                                sourceView: UIView,
                                actions: [UIAlertAction]) {
        DispatchQueue.main.async(execute: {
            let alert = UIAlertController(title: title,
                                          message: message,
                                          preferredStyle: .actionSheet)
            for action in actions {
                alert.addAction(action)
            }
            
            alert.popoverPresentationController?.sourceView = sourceView
            alert.popoverPresentationController?.sourceRect = sourceView.bounds
            instance.topMostController()?.present(alert,
                                                  animated: true,
                                                  completion: nil)
        })
    }
    
    open class func actionSheet(title: String,
                                message: String,
                                sourceView: UIView,
                                buttons: [String],
                                tapBlock: ((UIAlertAction,Int) -> Void)?) {
        DispatchQueue.main.async(execute: {
            let alert = UIAlertController(title: title,
                                          message: message,
                                          preferredStyle: .actionSheet,
                                          buttons: buttons,
                                          tapBlock: tapBlock)
            alert.popoverPresentationController?.sourceView = sourceView
            alert.popoverPresentationController?.sourceRect = sourceView.bounds
            instance.topMostController()?.present(alert,
                                                  animated: true,
                                                  completion: nil)
        })
    }
}

private extension UIAlertController {
    convenience init(title: String?,
                     message: String?,
                     preferredStyle: UIAlertControllerStyle,
                     buttons:[String],
                     tapBlock:((UIAlertAction,Int) -> Void)?) {
        self.init(title: title,
                  message: message,
                  preferredStyle: preferredStyle)
        var buttonIndex = 0
        for buttonTitle in buttons {
            let action = UIAlertAction(title: buttonTitle,
                                       preferredStyle: .cancel,
                                       buttonIndex: buttonIndex,
                                       tapBlock: tapBlock)
            buttonIndex += 1
            self.addAction(action)
        }
    }
}

private extension UIAlertAction {
    convenience init(title: String?,
                     preferredStyle: UIAlertActionStyle,
                     buttonIndex:Int, tapBlock:((UIAlertAction, Int) -> Void)?) {
        self.init(title: title,
                  style: preferredStyle) { (action: UIAlertAction) in
                    if let block = tapBlock {
                        block(action,buttonIndex)
                    }
        }
    }
}
