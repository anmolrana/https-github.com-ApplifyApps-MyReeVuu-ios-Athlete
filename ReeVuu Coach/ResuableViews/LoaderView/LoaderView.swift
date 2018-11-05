//
//  LoaderView.swift
//  Tul
//
//  Created by dev on 28/09/17.
//  Copyright © 2017 dev. All rights reserved.
//

import UIKit
import SVProgressHUD

class LoaderView: UIView {
   
    @IBOutlet weak var loadingView: SVProgressHUD!
    
    func showloader(show:Bool){
        SVProgressHUD.setBackgroundColor(UIColor.clear)
        SVProgressHUD.setForegroundColor(AppColors.blue)
        show ? SVProgressHUD.show() : SVProgressHUD.dismiss()
    }
   

}
