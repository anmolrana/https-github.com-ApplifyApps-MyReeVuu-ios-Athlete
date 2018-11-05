//
//  APIRequest.swift
//  TestAPI
//
//  Created by Dev on 15/10/18.
//  Copyright © 2018 Dev. All rights reserved.
//

import UIKit
import Alamofire



enum APIMethod{
    case GET
    case POST
    case PUT
    case PostWithImage
}

class APIRequest: NSObject {

    
    class func callApiWithParameters(url:String,method:APIMethod,parameters:[String:AnyObject],headers:[String:String],image:UIImage?,imageParameters:String,success: @escaping (NSDictionary)->Void, failure:@escaping (NSString)-> Void){
        
        if !NSUtility.isConnectedToNetwork()
        {
            CommonFunctions.showAlertWithTitle(title: ValidationConstants.ErrorTitle, message: ValidationConstants.ErrorInternetConnection)
            return
        }
        
       // CommonFunctions.showLoader(show: true)
        let alamofireManager = Alamofire.SessionManager.default
        alamofireManager.session.configuration.timeoutIntervalForRequest = 120
        switch method{
        case .GET :
            alamofireManager.request(url, method: .get, parameters: parameters, encoding: URLEncoding.default, headers: headers).responseJSON{ response in
                       // CommonFunctions.showLoader(show: false)

                let statusCode = response.response?.statusCode
                switch response.result{
                case .success(_):
                    if statusCode == StatusCode.success{
                        if let data = response.result.value{
                            success((data as AnyObject) as! NSDictionary)
                        }
                    }else{
                        if let data = response.result.value{
                            let dict = data as! NSDictionary
                            failure(dict.value(forKey: APIConstants.errorDescription) as! NSString)
                        }else if let error = response.result.error{
                            failure(error.localizedDescription as NSString)
                        }
                    }
                    break
                case .failure(_):
                    if let error = response.result.error{
                        let str = error.localizedDescription as NSString
                        if str.isEqual(to: "JSON could not be serialized because of error:\nThe data couldn’t be read because it isn’t in the correct format."){
                            return
                        }
                        failure(error.localizedDescription as NSString)
                    }
                }
            }
            break
        case .POST:
            alamofireManager.request(url, method: .post, parameters: parameters, encoding: URLEncoding.default, headers: headers).responseJSON{ response in
             //   CommonFunctions.showLoader(show: false)

                let statusCode = response.response?.statusCode
                switch response.result{
                case .success(_):
                    if statusCode == StatusCode.success{
                        if let dict = response.result.value as? NSDictionary{
                            if let error = dict.value(forKeyPath: "error") as? NSDictionary{
                                if let message = error.value(forKey: "message") as? String{
                                    failure(message as NSString)
                                    return
                                }
                                
                            }
                            
                            if let data = response.result.value{
                                success((data as AnyObject) as! NSDictionary)
                            }
                        }
                        
                    }else{
                        if let data = response.result.value{
                            let dict=data as! NSDictionary
                            if let error = dict.value(forKeyPath: "error") as? NSDictionary{
                                if let message = error.value(forKey: "message") as? String{
                                    failure(message as NSString)
                                }
                                
                            }
                            else{
                                failure(dict.value(forKeyPath: "error") as! NSString)
                            }
                        }
                        else if let error = response.result.error{
                            failure(error.localizedDescription as NSString)
                        }
                    }
                    
                    
                    
//                    if statusCode == StatusCode.success{
//                        if let data = response.result.value{
//                            success((data as AnyObject) as! NSDictionary)
//                        }
//                    }else{
//                        if let data = response.result.value{
//                            let dict = data as! NSDictionary
//                            failure(dict.value(forKey: APIConstants.errorDescription) as! NSString)
//                        }else if let error = response.result.error{
//                            failure(error.localizedDescription as NSString)
//                        }
//                    }
                    break
                case .failure(_):
                    if let error = response.result.error{
                        let str = error.localizedDescription as NSString
                        if str.isEqual(to: "JSON could not be serialized because of error:\nThe data couldn’t be read because it isn’t in the correct format."){
                            return
                        }
                        failure(error.localizedDescription as NSString)
                    }
                }
            }
            break
        case .PUT:
            alamofireManager.request(url, method: .put, parameters: parameters, encoding: URLEncoding.default, headers: headers).responseJSON{ response in
              //  CommonFunctions.showLoader(show: false)
                let statusCode = response.response?.statusCode
                switch response.result{
                case .success(_):
                    if statusCode == StatusCode.success{
                        if let data = response.result.value{
                            success((data as AnyObject) as! NSDictionary)
                        }
                    }else{
                        if let data = response.result.value{
                            let dict = data as! NSDictionary
                            failure(dict.value(forKey: APIConstants.errorDescription) as! NSString)
                        }else if let error = response.result.error{
                            failure(error.localizedDescription as NSString)
                        }
                    }
                    break
                case .failure(_):
                    if let error = response.result.error{
                        let str = error.localizedDescription as NSString
                        if str.isEqual(to: "JSON could not be serialized because of error:\nThe data couldn’t be read because it isn’t in the correct format."){
                            return
                        }
                        failure(error.localizedDescription as NSString)
                    }
                }
            }
            break
        case .PostWithImage:
            guard image != nil else
            {
                return
                
            }
            let imageData = getImageData(image:image!)
            alamofireManager.upload(multipartFormData: {multipartFormData in
                multipartFormData.append(imageData, withName: imageParameters, fileName: "file.jpeg", mimeType: MimeType.image)
                for (key,value) in parameters{
                   let valueString = String.init(format: "%@", value as! CVarArg)
                    multipartFormData.append(valueString.data(using: String.Encoding(rawValue: String.Encoding.utf8.rawValue))!, withName: key)
                }
                
            }, to: url){result in
              //  CommonFunctions.showLoader(show: false)

                switch result{
                case .success(let upload,_,_):
                    upload.uploadProgress{_ in
                        
                    }
                    upload.responseJSON {response in
                        let statusCode = response.response?.statusCode
                        if(statusCode==200){
                            if let data = response.result.value{
                                success((data as AnyObject) as! NSDictionary)
                            }
                        }
                        else{
                            if let data = response.result.value{
                                let dict=data as! NSDictionary
                                failure(dict.value(forKey: "error_description") as! NSString)
                            }
                            else if let error = response.result.error{
                                failure(error.localizedDescription as NSString)
                            }
                        }
                    }
                case .failure(let EncodingError):
                    failure(EncodingError.localizedDescription as NSString)
                }
                
            }
            break
        }
    }
    
    
    
//    class func apiCallForMultipleImagesWithParameters(url:String,method:APIMethod,parameters:[String:AnyObject],headers:[String:String],images:NSArray?,success: @escaping (NSDictionary)->Void, failure:@escaping (NSString)-> Void){
//       NSUtility.showLoader()
//
//        if NetworkManager.shared.isReachable() == false{
//            CommonFunctions.showLoader(show: false)
//
//            let err:NSString = "No Internet connection"
//            AlertController.alert(title: "Error", message: err as String)
//            failure(err)
//        }
//
//        let alamofireManager = Alamofire.SessionManager.default
//        alamofireManager.session.configuration.timeoutIntervalForRequest = 120
//
//        alamofireManager.upload(multipartFormData: {multipartFormData in
//            var i: Int = 0
//            for image in images!{
//                i = i + 1
//                let imageData = getImageData(image: image as! UIImage)
//                let imageName:NSString?
//                imageName = String.init(format: "image_%d", i) as NSString?
//                multipartFormData.append(imageData, withName: imageName! as String, fileName: "file.jpeg", mimeType: MimeType.image)
//            }
//
//            for (key,value) in parameters{
//                let valueString = String.init(format: "%@", value as! CVarArg)
//                multipartFormData.append(valueString.data(using: String.Encoding(rawValue: String.Encoding.utf8.rawValue))!, withName: key)
//            }
//
//        }, to: url){result in
//            CommonFunctions.showLoader(show: false)
//
//            switch result{
//            case .success(let upload,_,_):
//                upload.uploadProgress{_ in
//
//                }
//                upload.responseJSON {response in
//                    let statusCode = response.response?.statusCode
//                    if(statusCode==200){
//                        if let data = response.result.value{
//                            success((data as AnyObject) as! NSDictionary)
//                        }
//                    }
//                    else{
//                        if let data = response.result.value{
//                            let dict=data as! NSDictionary
//                            failure(dict.value(forKey: "error_description") as! NSString)
//                        }
//                        else if let error = response.result.error{
//                            failure(error.localizedDescription as NSString)
//                        }
//                    }
//                }
//            case .failure(let EncodingError):
//                failure(EncodingError.localizedDescription as NSString)
//            }
//
//        }
//    }
//
//    class func apiCallForMultipleImagesWithDifferentParameters(url:String,method:APIMethod,parameters:[String:AnyObject],headers:[String:String],images:NSDictionary?,success: @escaping (NSDictionary)->Void, failure:@escaping (NSString)-> Void){
//        NSUtility.showLoader()
//        if NetworkManager.shared.isReachable() == false{
//            CommonFunctions.showLoader(show: false)
//
//            let err:NSString = "No Internet connection"
//            AlertController.alert(title: "Error", message: err as String)
//            failure(err)
//        }
//
//        let alamofireManager = Alamofire.SessionManager.default
//        alamofireManager.session.configuration.timeoutIntervalForRequest = 120
//
//        alamofireManager.upload(multipartFormData: {multipartFormData in
//            var i: Int = 0
//            for key in (images?.allKeys)!{
//                i = i + 1
//                let image = images?.object(forKey: key)
//                let imageData = getImageData(image: image as! UIImage)
//                multipartFormData.append(imageData, withName: key as! String, fileName: "file.jpeg", mimeType: MimeType.image)
//            }
//
//            for (key,value) in parameters{
//                let valueString = String.init(format: "%@", value as! CVarArg)
//                multipartFormData.append(valueString.data(using: String.Encoding(rawValue: String.Encoding.utf8.rawValue))!, withName: key)
//            }
//
//        }, to: url){result in
//            NSUtility.dismissLoader()
//
//            switch result{
//            case .success(let upload,_,_):
//                upload.uploadProgress{_ in
//
//                }
//                upload.responseJSON {response in
//                    let statusCode = response.response?.statusCode
//                    if(statusCode==200){
//                        if let data = response.result.value{
//                            success((data as AnyObject) as! NSDictionary)
//                        }
//                    }
//                    else{
//                        if let data = response.result.value{
//                            let dict=data as! NSDictionary
//                            failure(dict.value(forKey: "error_description") as! NSString)
//                        }
//                        else if let error = response.result.error{
//                            failure(error.localizedDescription as NSString)
//                        }
//                    }
//                }
//            case .failure(let EncodingError):
//                failure(EncodingError.localizedDescription as NSString)
//            }
//
//        }
//    }
//
//    class func apiCallForMultipleFilesParameters(url:String,method:APIMethod,parameters:[String:AnyObject],images: NSArray?, videoThumb: UIImage? , video : URL? ,headers:[String:String],success: @escaping (NSDictionary)->Void, failure:@escaping (NSString)-> Void){
//        NSUtility.showLoader()
//        if NetworkManager.shared.isReachable() == false{
//           CommonFunctions.showLoader(show: false)
//            let err:NSString = "No Internet connection"
//            AlertController.alert(title: "Error", message: err as String)
//            failure(err)
//        }
//
//        let alamofireManager = Alamofire.SessionManager.default
//        alamofireManager.session.configuration.timeoutIntervalForRequest = 120
//
//        alamofireManager.upload(multipartFormData: {multipartFormData in
//            var i: Int = 0
//            if images != nil{
//                for image in images!{
//                    i = i + 1
//                    let imageData = getImageData(image: image as! UIImage)
//                    multipartFormData.append(imageData, withName: "images[]" as String, fileName: "file.jpeg", mimeType: MimeType.image)
//                }
//            }
//
//            if videoThumb != nil{
//                guard let videoThumbData = UIImageJPEGRepresentation(videoThumb! , 0.5) else { return }
//                multipartFormData.append(videoThumbData, withName: "v_thumbnail", fileName: "file.jpeg", mimeType: MimeType.image)
//            }
//
//            if video != nil{
//                do{
//                    let videoData = try Data(contentsOf: video!)
//                    multipartFormData.append(videoData, withName: "video", fileName: "file.mp4", mimeType: MimeType.video)
//                }catch{
//                    return
//                }
//            }
//
//            for (key,value) in parameters{
//                let valueString = String.init(format: "%@", value as! CVarArg)
//                multipartFormData.append(valueString.data(using: String.Encoding(rawValue: String.Encoding.utf8.rawValue))!, withName: key)
//            }
//
//        }, to: url){result in
//           CommonFunctions.showLoader(show: false)
//
//            switch result{
//            case .success(let upload,_,_):
//                upload.uploadProgress{_ in
//
//                }
//                upload.responseJSON {response in
//                    let statusCode = response.response?.statusCode
//                    if(statusCode==200){
//                        if let data = response.result.value{
//                            success((data as AnyObject) as! NSDictionary)
//                        }
//                    }
//                    else{
//                        if let data = response.result.value{
//                            let dict=data as! NSDictionary
//                            failure(dict.value(forKey: "error_description") as! NSString)
//                        }
//                        else if let error = response.result.error{
//                            failure(error.localizedDescription as NSString)
//                        }
//                    }
//                }
//            case .failure(let EncodingError):
//                failure(EncodingError.localizedDescription as NSString)
//            }
//
//        }
//    }
//
    class func getImageData(image:UIImage)->Data{
        var imageData:Data!
        let myData = image.jpegData(compressionQuality: 1)
        let totalKbCount = Int(round(Double((myData?.count)!/1024)))
        if (totalKbCount>1024*6) {
            imageData = image.jpegData(compressionQuality: 0.001) //UIImageJPEGRepresentation(image, 0.001)
            return imageData
        }else if (totalKbCount>1024*5) {
            imageData = image.jpegData(compressionQuality: 0.002)
            return imageData
        }
        else if (totalKbCount>1024*4)
        {
            imageData = image.jpegData(compressionQuality: 0.08)
            return imageData
        }
        else if (totalKbCount>1024*3)
        {
            imageData = image.jpegData(compressionQuality: 0.1)
            return imageData
        }
        else if (totalKbCount>1024*2)
        {
            imageData =  image.jpegData(compressionQuality: 0.02)
            return imageData
        }
        else if (totalKbCount>1024)
        {
            imageData = image.jpegData(compressionQuality: 0.04)
            return imageData
        }
        else{
            imageData = image.jpegData(compressionQuality: 0.8)
            return imageData
        }
    }
    
}
