//
//  VideoModel.swift
//  ReeVuu Coach
//
//  Created by Dev on 29/10/18.
//  Copyright © 2018 Dev. All rights reserved.
//

import UIKit
import Foundation

struct VideoData: Codable {
    let response: [VideoModel]
    let code: Int
}

struct VideoModel: Codable {
    let id, userType: Int
    let profilePic: String
    let sportID: Int
    let sport: String
    let privacy: Int
    let improvement: [Experty]?
    let url: String
    let thumbnail: String
    let fullname, title, description: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case userType = "user_type"
        case profilePic = "profile_pic"
        case sportID = "sport_id"
        case sport, privacy, improvement, url, thumbnail, fullname, title, description
    }
}

struct Experty: Codable {
    let id: Int
    let name: String
    let color: Int
}

