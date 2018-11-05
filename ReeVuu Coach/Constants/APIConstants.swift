//
//  APIConstants.swift
//  TestAPI
//
//  Created by Dev on 15/10/18.
//  Copyright © 2018 Dev. All rights reserved.
//

import UIKit


let kDeviceType = 1


struct APIURL {
   // static let BaseUrl = "http://192.168.1.111:3000/"
    static let BaseUrl = "http://52.52.111.12:3000/"
    static let SignUpUrl = "api/v1/athlete/registers"
    static let SignInUrl = "api/v1/athlete/authentications/authenticate"
    static let deviceTokenUpdateUrl = "api/v1/users/update_device_token"
    static let resendEmail = "api/v1/users/resend_email"
    static let forgotPassword = "api/v1/users/forget_password"
    static let athleteAnswer = "api/v1/athlete/answers"
    static let createProfile = "api/v1/athlete/profiles"
}

struct APIConstants {
    static let errorDescription = "error"
    
}

struct APIKeys{
    //signIn/signUp
    static let email =  "email"
    static let password = "password"
    static let platformStatus = "platform_status"
    static let deviceToken = "device_token"
    static let facebookId = "facebook_id"
    static let googleId = "google_id"
    static let accountType = "account_type"
    static let platformType = "platform_type"
    static let name = "name"
    static let imageUrl = "image_url"
    static let gender = "gender"
    static let emailVerified = "email_verified"
    static let dob = "dob"
    static let createdAt = "created_at"
    static let id = "id"
    static let isApproved = "is_approved"
    static let isBlocked = "is_blocked"
    static let phoneNo = "phone_number"
    static let profilePic = "profile_pic"
    static let userType = "user_type"
    static let updatedAt = "updated_at"
    static let profileStatus = "profile_status"
    //questioners
    static let accessToken = "access_token"
    static let sportsIds = "sport_ids"
    static let answers = "answers"
    static let questionId = "question_id"
    static let answer = "answer"
    static let questions = "questions"
    //create profile
    static let username = "username"
    static let height = "height"
    static let weight = "weight"
    static let dexterity = "dexterity"
    static let sportInfo = "sport_info"
    static let sportId = "sport_id"
    static let experience = "experience"
    static let level = "level"
    static let zipCode = "zip_code"
    static let stateId = "state_id"
    static let reason = "reason"
    static let videoId = "video_id"
    
}


struct StatusCode {
    static let success = 200
    static let failure = 400
}

public struct MimeType {
    public static let pdf: String = "application/pdf"
    public static let image: String = "image/jpg"
    public static let doc: String = "application/msword"
    public static let video:String = "video/mp4"
}
