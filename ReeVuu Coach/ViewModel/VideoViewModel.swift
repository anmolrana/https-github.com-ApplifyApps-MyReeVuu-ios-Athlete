//
//  VideoViewModel.swift
//  ReeVuu Coach
//
//  Created by Dev on 29/10/18.
//  Copyright © 2018 Dev. All rights reserved.
//

import UIKit

class VideoViewModel: NSObject {
    let id, userType, sportID, privacy: String
    var improvement = [ExpertiesViewModel]()
    let url: String
    let fullname, title, descriptionVideo: String
    let profilePic: String
    let sport: String
    let thumbnail: String
    init(video:VideoModel) {
        self.id = "\(video.id)"
        self.userType = "\(video.userType)"
        self.sportID = "\(video.sportID)"
        self.privacy = "\(video.privacy)"
        for experty in video.improvement ?? []{
            let cm = ExpertiesViewModel.init(experty: experty)
            self.improvement.append(cm)
        }
        self.url = video.url
        self.fullname = video.fullname
        self.title = video.title
        self.sport = video.sport
        self.thumbnail = video.thumbnail
        self.profilePic = video.profilePic
        self.descriptionVideo = video.description
    }
    static func getVideosDataFromServer<P>(parameters:[String:Any],showLoader:Bool,returnType:P.Type,apiType:String,viewC:UIViewController,apiMethod:ApiMethod,success:@escaping (Any)->Void, failure:@escaping (String)->Void){
        if showLoader{
            CommonFunctions.showLoader(show: true)
        }
        APIManager.callApiWithParameters(url: (APIURL.BaseUrl + apiType), withParameters: parameters , returnType: returnType, success: { (responseBack) in
            CommonFunctions.showLoader(show: false)
            if responseBack is VideoData{
                if let videoM = (responseBack as? VideoData)?.response {
                    var arrVideos = [VideoViewModel]()
                    
                    for video in videoM {
                       arrVideos.append(VideoViewModel.init(video: video))
                    }
                    
                    
                    success(arrVideos)
                }
            }
            else if responseBack is String{
                success(responseBack as! String)
            }
            
        }, failure: { (error) in
            failure(error as String)
            CommonFunctions.showLoader(show: false)
            CommonFunctions.showAlertWithTitle(title: ValidationConstants.ErrorTitle, message: error as String)
            
        }, method: apiMethod, img: nil, imageParamater: "", headers: [:])
    }
}
class ExpertiesViewModel: NSObject {
    let id: Int
    let name: String
    let color: Int
    init(experty:Experty) {
        self.id =  experty.id
        self.name = experty.name
        self.color = experty.color
    }
}
