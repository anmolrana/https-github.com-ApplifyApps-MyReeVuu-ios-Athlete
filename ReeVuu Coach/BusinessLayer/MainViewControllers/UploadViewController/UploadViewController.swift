//
//  UploadViewController.swift
//  ReeVuu Coach
//
//  Created by Dev on 26/10/18.
//  Copyright © 2018 Dev. All rights reserved.
//

import UIKit
import PBJVision

class UploadViewController: UIViewController,PBJVisionDelegate {

    @IBOutlet weak var previewView: UIView!
    var previewLayer = PBJVision.sharedInstance().previewLayer
   var longPressGestureRecognizer = UILongPressGestureRecognizer()
    var recording = true
    override func viewDidLoad() {
        super.viewDidLoad()
        previewLayer.frame = previewView.bounds
        previewLayer.videoGravity = .resizeAspectFill
        previewView.layer.addSublayer(previewLayer)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        previewLayer.frame = previewView.bounds
        longPressGestureRecognizer.addTarget(self, action: #selector(self.handleLongPress(_:)))
        self.view.addGestureRecognizer(longPressGestureRecognizer)
        setup()
    }
   
    func setup() {
        
        longPressGestureRecognizer.isEnabled = true
        
        let vision = PBJVision.sharedInstance() as? PBJVision
        vision?.delegate = self
        
        vision?.cameraMode = PBJCameraMode.video
        vision?.cameraOrientation = PBJCameraOrientation.portrait
        vision?.focusMode = PBJFocusMode.continuousAutoFocus
        vision?.outputFormat = PBJOutputFormat.standard
        vision?.startPreview()
    }
    
    @objc func handleLongPress(_ gestureRecognizer: UIGestureRecognizer?) {
        switch gestureRecognizer?.state {
        case .began?:
            if recording {
                PBJVision.sharedInstance().startVideoCapture()
            } else {
                PBJVision.sharedInstance().resumeVideoCapture()
            }
        case .ended?, .cancelled?, .failed?:
            PBJVision.sharedInstance().pauseVideoCapture()
        default:
            break
        }
    }

    func vision(_ vision: PBJVision?, capturedVideo videoDict: [AnyHashable : Any]?, error:NSError) {
        if error != nil && ((error as NSError?)?.domain)?.isEqual(PBJVisionErrorDomain) ?? false && (error as NSError?)?.code == Int(Float(PBJVisionErrorType.cancelled.rawValue)) {
            print("recording session cancelled")
            return
        }
//        else if error != nil {
//            if let anError = error {
//                print("encounted an error in video capture (\(anError))")
//            }
//            return
//        }
        
       var currentVideo = videoDict
        
        let videoPath = currentVideo?[PBJVisionVideoPathKey] as? String
        if let aPath = URL(string: videoPath ?? "") {
            print("success")
//            assetLibrary.writeVideoAtPath(toSavedPhotosAlbum: aPath, completionBlock: { assetUrl, error1 in
//                let alert = UIAlertView(title: "Video Saved!", message: "Saved to the camera roll.", delegate: self, cancelButtonTitle: "", otherButtonTitles: "OK")
//                alert.show()
//            })
        }
    }


}
