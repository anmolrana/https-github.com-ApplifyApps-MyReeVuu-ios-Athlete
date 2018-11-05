//
//  ViewController.swift
//  ReeVuu_Coach
//
//  Created by Ankit Goyal on 15/03/2018.
//  Copyright © 2018 Applify Tech Pvt Ltd. All rights reserved.
//

import UIKit
import FSPagerView

class WalkThrough: UIViewController {
    var isScrolling = false
    var timer = Timer()
     var viewSplash: UIView!
    
    @IBOutlet weak var btnNext: UIButton!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var viewPager: FSPagerView!
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return .lightContent
    }
    
    //MARK: Override funcations
   override func viewDidLoad() {
        super.viewDidLoad()
       // Do any additional setup after loading the view, typically from a nib.
    self.setUp()
    }

    //MARK:-IntialSetUP
    func setUp(){
          self.checkScreen()
        // register cell intially before cellForRow gets called
         viewPager.register(FSPagerViewCell.self, forCellWithReuseIdentifier: "cell")
        viewSplash = UIView.loadFromNibNamed("SplashView", bundle: nil) as! SplashView
        viewSplash.frame = CGRect.init(x: 0, y: 0, width: KScreenWidth, height: KScreenHeight)
        KAPPDELEGATE?.window?.addSubview(viewSplash)
        self.perform(#selector(self.hideSplashImage), with: nil, afterDelay: 0.5)
        
        
    }
    
    //MARK:- splash animation
    @objc func hideSplashImage(){
       
         UIView.animate(withDuration: 0.4, animations: {
                self.viewSplash.alpha = 0
                self.viewSplash.transform = CGAffineTransform.init(scaleX: 3.0, y: 3.0)
            }) { (_) in
          
            }
    }
   
    //MARK:- set up pager view
    func checkScreen(){
        let user = DBManager.fetchUserDataWithParameters(userId: KUSERDEFAULT.value(forKey: UserDefaultConstants.userID) as? String ?? "")
        if user == nil{
            self.setUpPager()
        }
        else if user?.userProfileStatus == "0" && user?.userEmailVerified == "1"{
            self.openQuestionaires()
        }
        else if user?.userProfileStatus == "1"{
            self.openCreateProfile()
        }
        else if user?.userProfileStatus == "2"{
            self.openLanding()
        }
    }
    func openQuestionaires(){
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ChooseYourSportVC") as! ChooseYourSportVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    func openCreateProfile(){
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "CreateProfileVC") as! CreateProfileVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    func openLanding(){
        let vc = StoreyBoard.StoreyboardMain().storeyboadForReevuu.instantiateViewController(withIdentifier: "BaseTabBarController") as! BaseTabBarController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func setUpPager(){
        
       
        viewPager.automaticSlidingInterval = 6.0
        viewPager.transformer = FSPagerViewTransformer(type: .linear)
        
        viewPager.interitemSpacing = 0
        viewPager.alwaysBounceHorizontal=false
        
    }
    
    
    //MARK:- button actions
    @IBAction func actionSkip(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "SignUpViewController") as! SignUpViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func actionNext(_ sender: Any) {
        if viewPager.currentIndex != 4 {
            let index = viewPager.currentIndex + 1
            viewPager.scrollToItem(at: index, animated: true)

            viewPager.automaticSlidingInterval = -1
            isScrolling = true
            self.changeTitleAndDescription(forIndex: index)
            timer.invalidate()
            timer =  Timer.scheduledTimer(timeInterval: 0.4, target: self, selector: #selector(self.changeScrollState), userInfo: nil, repeats: false)
        }
        else{
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "SignUpViewController") as! SignUpViewController
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}

