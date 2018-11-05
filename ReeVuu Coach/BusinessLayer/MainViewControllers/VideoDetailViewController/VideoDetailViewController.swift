//
//  VideoDetailViewController.swift
//  ReeVuu Coach
//
//  Created by Dev on 29/10/18.
//  Copyright © 2018 Dev. All rights reserved.
//

import UIKit
import VGPlayer
class VideoDetailViewController: UIViewController,UIGestureRecognizerDelegate {
    var videoModel : VideoViewModel? = nil
     var arrExpertise = [ExpertiesViewModel]()
    var player : VGPlayer = {
        let playeView = VGCustomPlayerView()
        let playe = VGPlayer(playerView: playeView)
        return playe
    }()
    @IBOutlet weak var imgVideo: UIImageView!
    
   
   
    @IBOutlet weak var viewplayer: UIView!
    @IBOutlet weak var constraintCollHt: NSLayoutConstraint!
    @IBOutlet weak var collImprovements: UICollectionView!
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblViews: UILabel!
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var lblUserType: UILabel!
    @IBOutlet weak var lblUserName: UILabel!
    @IBOutlet weak var btnProfile: UIButton!
    @IBOutlet weak var lblSport: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.setData()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
        self.player.play()
       (UIApplication.shared.delegate as! AppDelegate).restrictRotation = .all
  
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if let layout = self.collImprovements.collectionViewLayout as? UICollectionViewFlowLayout{
            layout.estimatedItemSize = CGSize.init(width: 1, height: 48)
            
        }
        self.collImprovements.collectionViewLayout.invalidateLayout()
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.collImprovements.reloadData()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.tabBarController?.tabBar.isHidden = false
        self.player.pause()
    (UIApplication.shared.delegate as! AppDelegate).restrictRotation = .portrait
    }
   
    
    //MARK:- set data
    func setData(){
        self.btnProfile.sd_setImage(with: URL.init(string: videoModel?.fullname ?? videoModel?.profilePic ?? ""), for: .normal) { (image, error, type, url) in
            
        }
       
       self.setUpPlayer()
        self.lblSport.text = videoModel?.sport
        self.lblUserType.text = "Player"
        self.lblUserName.text = videoModel?.fullname
        self.lblTitle.text = videoModel?.title
        self.lblDescription.text = videoModel?.descriptionVideo
        arrExpertise = self.videoModel?.improvement ?? []
        self.collImprovements.reloadData()
    }
    func setUpPlayer(){
        if let url = URL.init(string: self.videoModel?.url ?? ""){
       self.player.replaceVideo(url)
     self.viewplayer.addSubview(self.player.displayView)
        self.player.displayView.frame = self.viewplayer.bounds
        self.player.backgroundMode = .suspend
        self.player.delegate = self
        self.player.displayView.delegate = self
//        self.player.displayView.snp.makeConstraints { [weak self] (make) in
//            guard let strongSelf = self else { return }
//            make.top.equalTo(strongSelf.view.snp.top)
//            make.left.equalTo(strongSelf.view.snp.left)
//            make.right.equalTo(strongSelf.view.snp.right)
//          // make.bottom.equalTo(strongSelf.view.snp.bottom)
//            make.height.equalTo(strongSelf.view.snp.width).multipliedBy(15.0/16.0) // you can 9.0/16.0
//        }
        }
    }
    func getGradientColors(forType type:String)->[UIColor]{
        if type == "1"{
            return [KGradient1A,KGradient1B]
        }
        else if type == "2"{
            return [KGradient2A,KGradient2B]
        }
        else if type == "3"{
            return [KGradient3A,KGradient3B]
        }
        else if type == "4"{
            return [KGradient4A,KGradient4B]
        }
        else if type == "5"{
            return [KGradient5A,KGradient5B]
        }
        else if type == "6"{
            return [KGradient6A,KGradient6B]
        }
        return [KGradient1A,KGradient1B]
    }
    //MARK:-Button actions
    @IBAction func actionPLayVideo(_ sender: Any) {
    }
    @IBAction func actionReport(_ sender: UIButton) {
        let optionV = UIView.loadFromNibNamedWithViewIndex("PopupView", index: 1)  as! OptionsPopupView
        optionV.delegate = self
        optionV.button = sender
        optionV.viewStyle = .OptionReport
        optionV.setUpView()
        optionV.btnDone.setTitle(EnumOptionsSelectionType.OptionReport.rawValue, for: .normal)
      optionV.showButtonDone = true
            optionV.lblHeading.text = EnumOptionsSelectionType.OptionReport.rawValue
            optionV.arrOptions = ["The video is irrelevant","This video contains inappropriate content","Video does'nt belong to any sports","Others"]
       
        optionV.tblOptions.reloadData()
        self.view.addSubview(optionV)
        optionV.viewBack.transform = CGAffineTransform.init(translationX: 0, y: KScreenHeight)
        UIView.animate(withDuration: 0.5) {
            optionV.viewBack.transform = .identity
        }
    }
    @IBAction func actionBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}


extension VideoDetailViewController:UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return arrExpertise.count
        
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RegisterCollectionCell", for: indexPath) as! RegisterCollectionCell
        
        let str = (arrExpertise.map{$0.name })[indexPath.row]
        cell.lblSelection.text = str
        
        cell.removeAllGradients()
        
        let type = arrExpertise.map{$0.color}[indexPath.row]
        let colors = self.getGradientColors(forType: "\(type)")
        cell.addGradientToView(firstColor: colors.first!, secondColor: colors.last!, forFrame: cell.bounds, locations: [0.3,1.0])
        cell.lblSelection.textColor = .white
        
        self.constraintCollHt.constant = self.collImprovements.contentSize.height
        
        return cell
    }
   
}
extension VideoDetailViewController: VGPlayerDelegate,VGPlayerViewDelegate,OptionSelectedDelegate {
    func vgPlayer(_ player: VGPlayer, playerFailed error: VGPlayerError) {
        print(error)
    }
    func vgPlayer(_ player: VGPlayer, stateDidChange state: VGPlayerState) {
        print("player State ",state)
    }
    func vgPlayer(_ player: VGPlayer, bufferStateDidChange state: VGPlayerBufferstate) {
        print("buffer State", state)
    }
    
    
    func vgPlayerView(_ playerView: VGPlayerView, willFullscreen fullscreen: Bool) {
        
    }
    func vgPlayerView(didTappedClose playerView: VGPlayerView) {
        if playerView.isFullScreen {
            playerView.exitFullscreen()
        } else {
            self.navigationController?.popViewController(animated: true)
        }
        
    }
//    func vgPlayerView(didDisplayControl playerView: VGPlayerView) {
//        UIApplication.shared.setStatusBarHidden(
//        !playerView.isDisplayControl, with: .fade)
//    }
    func optionsSelected(optionsSelected: [String], onButton: UIButton) {
        if optionsSelected.count == 0{
        return
        }
        VideoViewModel.getVideosDataFromServer(parameters: [APIKeys.accessToken:KUSERDEFAULT.value(forKey: UserDefaultConstants.userAccessToken) ?? "",APIKeys.reason:optionsSelected.first ?? "",APIKeys.videoId:self.videoModel?.id ?? ""], showLoader: true, returnType: String.self, apiType: EnumApiType.ApiReports.rawValue, viewC: self, apiMethod: ApiMethod.POST, success: { (response) in
            if let str = response as? String{
                let alertController = UIAlertController(title:  nil, message: str, preferredStyle: .alert)
                let defaultAction = UIAlertAction.init(title: "Ok", style: .cancel, handler: { (_) in
                    
                })
                alertController.addAction(defaultAction)
                CommonFunctions.fetchCurrentViewController().present(alertController, animated: true, completion: nil)
                
            }
        }) { (_) in
            
        }
        
    }
}
