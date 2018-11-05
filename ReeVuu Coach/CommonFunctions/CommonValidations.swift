//
//  CommonValidations.swift
//  ReeVuu Coach
//
//  Created by Dev on 22/10/18.
//  Copyright © 2018 Dev. All rights reserved.
//
import UIKit
import AVFoundation
import Photos

class CommonValidations: NSObject {
    //MARK:- check camera permissions
    static func checkCameraPermissionsForCamera(camera:Bool,withSuccess :@escaping (_ success:Bool)->Void){
        if (camera) {
            let  status = AVCaptureDevice.authorizationStatus(for: AVMediaType.video)
            if(status == .notDetermined) {
                AVCaptureDevice.requestAccess(for: AVMediaType.video, completionHandler: { (granted: Bool) -> Void in
                    if granted == true {
                        // User granted
                        withSuccess(true)
                    } else {
                        // User rejected
                        withSuccess(false)
                    }
                })
                
            } else if (status == .authorized) {
                
                withSuccess(true)
                
            } else if (status == .restricted) {
                
                self.showNoAccessAlert(camera: camera)
                withSuccess(false)
            } else if (status == .denied) {
                self.showNoAccessAlert(camera: camera)
                withSuccess(false)
            }
            else{
                withSuccess(false)
            }
        }
            
        else{
            let status = PHPhotoLibrary.authorizationStatus()
            
            if(status == .notDetermined) {
                // Request photo authorization
                PHPhotoLibrary.requestAuthorization({ (status) in
                    if status == .authorized{
                        withSuccess(true)
                    }
                    else{
                        withSuccess(false)
                    }
                })
            } else if (status == .authorized) {
                withSuccess(true)
                
            } else if (status == .restricted) {
                
                self.showNoAccessAlert(camera: camera)
                withSuccess(false)
            } else if (status == .denied) {
                self.showNoAccessAlert(camera: camera)
                withSuccess(false)
            }
            else{
                withSuccess(false)
            }
        }
    }
   static func showNoAccessAlert (camera : Bool){
        var alert = UIAlertController()
        if camera{
            alert = UIAlertController.init(title: ValidationConstants.ErrorTitle, message: ValidationConstants.ErrorCameraPermission, preferredStyle: UIAlertController.Style.alert)
        }
        else{
            alert = UIAlertController.init(title: ValidationConstants.ErrorTitle, message: ValidationConstants.ErrorPhotosPermission, preferredStyle: UIAlertController.Style.alert)
        }
    alert.addAction(UIAlertAction.init(title: "Settings", style: UIAlertAction.Style.default, handler: { (success) in
    if #available(iOS 10.0, *) {
        UIApplication.shared.open(URL.init(string: UIApplication.openSettingsURLString)!, options: [:], completionHandler: nil)
    } else {
        // Fallback on earlier versions
        UIApplication.shared.openURL(URL.init(string: UIApplication.openSettingsURLString)!)
    }
  }))
    alert.addAction(UIAlertAction.init(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil))
    
    let currentVc = CommonFunctions.fetchCurrentViewController()
        currentVc.present(alert, animated: true, completion: nil)

    }

}
