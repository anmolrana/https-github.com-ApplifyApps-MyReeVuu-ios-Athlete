//
//  Enums.swift
//  ProjectTemplate
//
//  Created by Ankit Goyal on 15/03/2018.
//  Copyright © 2018 Applify Tech Pvt Ltd. All rights reserved.
//

import Foundation
import UIKit

enum StoreyBoard {
    case StoreyboardIntial()
     case StoreyboardMain()
    
    var storeyboadForReevuu : UIStoryboard{
        switch self {
        case .StoreyboardIntial():
            return UIStoryboard.init(name: "Intial", bundle: Bundle.main)
        case .StoreyboardMain():
            return UIStoryboard.init(name: "Main", bundle: Bundle.main)
        }
    }
    
}

enum  SignUpStyle: String{
    case SignUp = "SignUp"
    case SignIn = "SignIn"
}

enum EnumPopUPType{
    case PopUpForgotPassword
    case PopUpEmailVerify
    
}

enum EnumOptionsSelectionType:String{
    
    typealias RawValue = String
    
    case OptionSportPlayed = "SPORT PLAYED"
    case OptionPlayingExperience = "PLAYING EXPERIENCE"
    case OptionLevelOfPlaying = "LEVEL OF PLAYING"
    case OptionStateYouParticipated = "STATE YOU PARTICIPATED IN"
    
    case OptionPlayedInCollege = "DID YOU PLAY SPORT IN COLLEGE?"
    case OptionHighestLevelCompeted = "HIGHEST LEVEL YOU COMPETED IN"
    case OptionHighestLevelCoached = "HIGHEST LEVEL YOU COACHED IN"
    case OptionCoachingExp = "YEARS OF COACHING EXPERIENCE"
    case OptionCoachingCertificate = "SELECT COACHING CERTIFICATE"
    case OptionGender = "SELECT GENDER"
    case OptionDexterity = "SELECT DEXTERITY"
    case OptionHeight = "SELECT HEIGHT"
    case OptionWeight = "SELECT WEIGHT"
    case OptionDOB = "SELECT DATE OF BIRTH"
    case OptionCurrency = "CURRENCY"
    case OptionReport = "REPORT VIDEO"
    
}



enum Fonts {
    case FontRodtoBold(size : Int)
    case FontRobotoBoldItalic(size : Int)
    case FontRobotoItalic(size : Int)
    case FontRobotoLight(size : Int)
    case FontRobotoLightItalic(size:Int)
    case FontRobotoRegular(size:Int)
    var fontsForReevuu : UIFont{
        switch self {
        case .FontRodtoBold(let size):
            return  UIFont.init(name: "RobotoCondensed-Bold", size: CGFloat(size))!
        case .FontRobotoBoldItalic(let size):
            return  UIFont.init(name: "RobotoCondensed-BoldItalic", size: CGFloat(size))!
            
        case .FontRobotoItalic(let size):
            return  UIFont.init(name: "RobotoCondensed-Italic", size: CGFloat(size))!
            
        case .FontRobotoLight(let size):
            return  UIFont.init(name: "RobotoCondensed-Light", size: CGFloat(size))!
        case .FontRobotoLightItalic(let size):
            return  UIFont.init(name: "RobotoCondensed-LightItalic", size: CGFloat(size))!
        case .FontRobotoRegular(let size):
            return  UIFont.init(name: "RobotoCondensed-Regular", size: CGFloat(size))!
        }
    }
}

enum EnumApiType:String{
    
    typealias RawValue = String
    
    case ApiSignup =  "coach/registers",ApiLogin="coach/authentications/authenticate",ApiCreateProfile="coach/profile",ApiForgotPassword="users/forget_password",ApiResendEmail="users/resend_email",ApiUpdateDeviceToken="users/update_device_token",ApiRegisterAsCoach = "coach/coaches",ApiCheckUserName = "users/username",ApiGetFeeds = "api/v1/feeds",ApiReports = "api/v1/reports"
    
}
