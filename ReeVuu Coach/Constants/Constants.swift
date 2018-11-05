//
//  Constants.swift
//  ProjectTemplate
//
//  Created by Ankit Goyal on 15/03/2018.
//  Copyright © 2018 Applify Tech Pvt Ltd. All rights reserved.
//

import Foundation
import UIKit


let arrYesNo = ["Yes","No"]
let arrLevel = ["State","National","International"]
let arrExpertise = ["Serve","Drop Shot","Net Game","Ground Strokes"]
let arrCertificate = ["Lorem ipsum","Certificate 1","National Level Certified ","Certificate 4"]
//let arrGender = ["Male","Female","Other"]
//let arrDexterity = ["Left","Right"]



struct AppColors {
    static let blue = UIColor.init(red: 0/255, green: 129/255, blue: 207/255, alpha: 1)
    static let gray = UIColor.init(red: 255/255, green: 255/255, blue: 255/255, alpha: 0.8)
    static let placeholderColor = UIColor.init(red: 255/255, green: 255/255, blue: 255/255, alpha: 0.5)
}

struct ValidationConstants {
    static let ErrorTitle = "Error"
    static let ErrorEmailInvalid = "Email is not valid."
    static let ErrorEmailEmpty = "Please enter email."
    
    static let ErrorTermsCondition = "Please select terms and conditions."
    static let ErrorInternetConnection = "Internet connection lost."
    static let ErrorEmptyPassword = "Please enter password."
    static let ErrorInvalidPassword = "Please enter valid password"
    static let ErrorWorkInprogress = "Work In Progress"
    static let ErrorCameraPermission = "The app does not have access to your camera. Please enable from Settings."
    static let ErrorPhotosPermission = "The app does not have access to your gallery. Please enable from Settings."
    static let ErrorMinPassword = "Password should be of minimum 8 characters"
    static let ErrorIssueFetchingImage = "Some issue fetching image"
    
    static let ErrorChooseProfilePic = "Please Choose your profile picture"
    static let ErrorEnterFullName = "Please enter your full name."
    static let ErrorEnterUsername = "Please enter your user name."
    static let ErrorFullNameMin = "Full name should be of minimum 2 characters"
    static let ErrorFullNameMax = "Full name should be of maximum 50 characters"
    static let ErrorSpecialCharacterNotAllowed = "Space and Special characters are not allowed for user name."
    static let ErrorUserNameMin = "User name should be of minimum 2 characters"
    static let ErrorUserNameMax = "User name should be of maximum 50 characters"
    static let ErrorSelectGender = "Please select your gender."
    static let ErrorSelectDOB = "Please select your Date of birth."
    static let ErrorSelectHeight = "Please select your height."
    static let ErrorSelectDexterity = "Please select your dexterity."
    static let ErrorSelectSport = "Please select sport played"
    static let ErrorSelectExperience = "Please select experience"
    static let ErrorSelectLevel = "Please select level of playing"
    static let ErrorEmptyZipcode = "Please enter zipcode"
    static let ErrorInvalidZipcode = "Zip code should have 3 - 10 characters"
    
    static let ErrorSelectOneOption = "Please select at least one option to proceed"
    

}

struct AlertConstants {
    static let AlertUploadPicture = "Upload Profile Picture"
    static let AlertCamera = "Take a Photo"
    static let AlertViewProfile = "View Photo"
    static let AlertRemovePic = "Remove Picture"
    static let AlertGallery = "Select from Gallery"
    static let AlertTitleInformation = "Information"
    
}

struct UserDefaultConstants {
    static let email  = "email"
    static let userloginType = "loginType"
    static let userPic = "userpic"
    static let userName = "name"
    static let userGender = "gender"
    static let userID = "RevuuUserID"
    static let userAccessToken = "RevuuUserAccessToken"
    static let sportPlayed = "ReevuuUserSportPlayed"
    static let userDeviceToken = "RevuuUserDeviceToken"
    static let notificationEmailVerification = "RevuuNotificationEmailVerification"
    static let tipShown = "RevuuUserTipShown"
    
}

struct CellIdentifiers {
    static let ChooseSportCollViewCell = "ChooseSportCollViewCell"
    static let QuesOneCollViewCell = "QuesOneCollViewCell"
    static let QuesTwoCollViewCell = "QuesTwoCollViewCell"
    static let AthleteInfoTableViewCell = "AthleteInfoTableViewCell"
}
