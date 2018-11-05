//
//  BaseTabBarController.swift
//  ReeVuu Coach
//
//  Created by Dev on 26/10/18.
//  Copyright © 2018 Dev. All rights reserved.
//

import UIKit

class BaseTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.addUploadButton()
        let appearance = UITabBarItem.appearance()
       
        appearance.setTitleTextAttributes([.font:Fonts.FontRobotoRegular(size: 10).fontsForReevuu], for: .normal)
    }
    
    func addUploadButton(){
      let button = UIButton.init(type: .custom)
        button.setImage(UIImage.init(named: "ic_upload_video"), for: .normal)
       button.frame = CGRect.init(x: (KScreenWidth-77)/2, y: -30, width: 77, height: 77)
        button.addTarget(self, action: #selector(self.openUploadTab), for: .touchUpInside)
        self.tabBar.addSubview(button)
    }
   @objc func openUploadTab(){
        self.selectedIndex = 2
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
