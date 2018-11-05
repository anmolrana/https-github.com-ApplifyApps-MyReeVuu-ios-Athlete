//
//  HomeViewController.swift
//  ReeVuu Coach
//
//  Created by Dev on 26/10/18.
//  Copyright © 2018 Dev. All rights reserved.
//

import UIKit
import AVFoundation
import MMPlayerView
class HomeViewController: UIViewController {
    var arrVideos = [VideoViewModel]()
    lazy var mmPlayerLayer: MMPlayerLayer = {
        let l = MMPlayerLayer()
    l.setCoverView(enable: false)
        l.cacheType = .none
     //   l.autoPlay = true
        l.coverFitType = .fitToPlayerView
        l.videoGravity = AVLayerVideoGravity.resizeAspectFill
       // l.replace(cover: CoverA.instantiateFromNib())
        return l
    }()
    @IBOutlet weak var tblVideos: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.setupTableView()
        self.getData()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.checkForTip()
        if (mmPlayerLayer.player?.timeControlStatus == AVPlayer.TimeControlStatus.paused){
            mmPlayerLayer.player?.play()
        }
        self.startLoading()
        tblVideos.reloadData()

    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.mmPlayerLayer.player?.pause()
    }
    func getData(){
        VideoViewModel.getVideosDataFromServer(parameters: [APIKeys.accessToken:KUSERDEFAULT.value(forKey: UserDefaultConstants.userAccessToken) ?? ""], showLoader: true, returnType: VideoData.self, apiType: EnumApiType.ApiGetFeeds.rawValue, viewC: self, apiMethod: ApiMethod.GET, success: { (arrVideosM) in
            self.arrVideos = arrVideosM as! [VideoViewModel]
            if self.arrVideos.count > 0 {
                self.updateCell(at: IndexPath(row: 0, section: 0))
            }
            self.tblVideos.reloadData()
        }) { (error) in
            
        }
    }
    //MARK:- Setup Tableview
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "contentOffset" {
            self.updateByContentOffset()
            NSObject.cancelPreviousPerformRequests(withTarget: self)
            self.perform(#selector(startLoading), with: nil, afterDelay: 0.3)
            
        } else {
            super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
        }
    }
    func setupTableView(){
        self.startLoading()
        tblVideos.reloadData()
        self.tblVideos.addObserver(self, forKeyPath: "contentOffset", options: [.new], context: nil)
      //  self.tblVideos.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 20, right:0)
        //        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
        //
        //
        //        }
        DispatchQueue.global(qos: .background).async {
            self.updateByContentOffset()
            
            DispatchQueue.main.async {
                self.startLoading()
            }
        }
         
    }
    fileprivate func updateByContentOffset() {
        let p = CGPoint(x: tblVideos.frame.width/2, y: tblVideos.contentOffset.y + tblVideos.frame.width/2)
        
        if let path = tblVideos.indexPathForRow(at: p),
            self.presentedViewController == nil {
            self.updateCell(at: path)
        }
    }
    @objc fileprivate func startLoading() {
        if self.presentedViewController != nil {
            return
        }
        mmPlayerLayer.startLoading()
        //  self.landscapeAction()
    }
    fileprivate func updateCell(at indexPath: IndexPath) {
        if let cell = tblVideos.cellForRow(at: indexPath) as? VideoListTableViewCell{
            let vm = arrVideos[indexPath.row]
            // this thumb use when transition start and your video dosent start
            mmPlayerLayer.playView?.frame = cell.imgVideo.bounds
            mmPlayerLayer.thumbImageView.image = cell.imgVideo.image
            // set video where to play
            if !MMLandscapeWindow.shared.isKeyWindow {
                mmPlayerLayer.playView = cell.imgVideo
            }
            // set url prepare to load
            if let url = URL.init(string:vm.url){
            mmPlayerLayer.set(url: url, state: { (status) in
                switch status {
                case .failed(let err):
//                    let alert = UIAlertController(title: "err", message: err.description, preferredStyle: .alert)
//                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
//                    self.present(alert, animated: true, completion: nil)
                    break
                case .ready:
                    print("Ready to Play")
                case .playing:
                    print("Playing")
                case .pause:
                    print("Pause")
                case .end:
                    self.mmPlayerLayer.player?.seek(to: CMTime.zero)
                    self.mmPlayerLayer.player?.play()
                    print("End")
                default: break
                }
            })
            }
        }
    }
    
    // MARK: - check whether to show tip or not
    func checkForTip(){
        if (KUSERDEFAULT.value(forKey: UserDefaultConstants.tipShown) == nil){
            let view = UIView.loadFromNibNamedWithViewIndex("PopupView", index: 2) as! TipPopUpView
            view.frame = CGRect.init(x: 0, y: 0, width: KScreenWidth, height: KScreenHeight)
            view.alpha = 0
        KAPPDELEGATE?.window?.addSubview(view)
            view.constraintTipBtm.constant = (self.tabBarController?.tabBar.frame.size.height ?? 44) - 47
        view.updateConstraintsIfNeeded()
            UIView.animate(withDuration: 0.4, animations: {
                view.alpha = 1
            }) { (_) in
                
            }
            KUSERDEFAULT.set(true, forKey: UserDefaultConstants.tipShown)
        }
    }

    @IBAction func actionSearch(_ sender: Any) {
        let alert = UIAlertController.init(title: "Alert", message: "Are you sure want to Log Out?", preferredStyle: .alert)
        alert.addAction(UIAlertAction.init(title: "Yes", style: .default, handler: { (_) in
            CommonFunctions.sendToStart()
            
        }))
        alert.addAction(UIAlertAction.init(title: "No", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
        
    }
    @IBAction func actionNotification(_ sender: Any) {
        CommonFunctions.showAlertWithTitle(title: ValidationConstants.ErrorTitle, message: ValidationConstants.ErrorWorkInprogress)

    }
    
}

extension HomeViewController:UITableViewDataSource,UITableViewDelegate,HomeMuteDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrVideos.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "VideoListTableViewCell", for: indexPath) as! VideoListTableViewCell
        cell.delegate = self
        cell.indexPath = indexPath
        let vm = arrVideos[indexPath.row]
        cell.imgVideo.sd_setImage(with: URL.init(string: vm.thumbnail)) { (image, error, type, url) in
            
        }
        cell.lblTitle.text = vm.title
        cell.lblUserName.text = "By " + vm.fullname
        cell.lblGame.text = vm.sport
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "VideoDetailViewController") as! VideoDetailViewController
        vc.videoModel = arrVideos[indexPath.row]
        self.navigationController?.pushViewController(vc, animated: true)
    }
    func muteUnmutePressedAt(indexpath: IndexPath) {
        let cell = self.tblVideos.cellForRow(at: indexpath) as! VideoListTableViewCell
        cell.btnMuteUnmute.isSelected = !(self.mmPlayerLayer.player?.isMuted ?? false)
        self.mmPlayerLayer.player?.isMuted =  !(self.mmPlayerLayer.player?.isMuted ?? false)
    }
}
