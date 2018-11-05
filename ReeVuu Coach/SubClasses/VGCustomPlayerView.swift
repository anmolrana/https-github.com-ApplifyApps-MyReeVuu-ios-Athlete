//
//  VGCustomPlayerView.swift
//  VGPlayerExample
//
//  Created by Vein on 2017/6/12.
//  Copyright © 2017年 Vein. All rights reserved.
//

import UIKit
import VGPlayer

class VGCustomPlayerView: VGPlayerView {
   
    
    var subtitles : VGSubtitles?
    let subtitlesLabel = UILabel()
    
    override func configurationUI() {
        super.configurationUI()
        self.titleLabel.removeFromSuperview()
        self.timeSlider.minimumTrackTintColor = #colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1)
        self.topView.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0)
        self.bottomView.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0)
        
        
        
        
        
        
        
        subtitlesLabel.font = UIFont.boldSystemFont(ofSize: 12.0)
        subtitlesLabel.numberOfLines = 0
        subtitlesLabel.textAlignment = .center
        subtitlesLabel.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        subtitlesLabel.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.5031571062)
        subtitlesLabel.adjustsFontSizeToFitWidth = true
        self.insertSubview(subtitlesLabel, belowSubview: self.bottomView)
        
        subtitlesLabel.snp.makeConstraints { (make) in
            make.right.equalTo(self).offset(-5)
            make.left.equalTo(self).offset(5)
            make.bottom.equalTo(snp.bottom).offset(-10)
            make.centerX.equalTo(self)
        }
    }
    
    override func playStateDidChange(_ state: VGPlayerState) {
        super.playStateDidChange(state)
        if state == .playing {
        }
    }
    
    override func displayControlView(_ isDisplay: Bool) {
        super.displayControlView(isDisplay)
        //self.bottomProgressView.isHidden = isDisplay
    }
    
    override func reloadPlayerView() {
        super.reloadPlayerView()
    }
    
    override func playerDurationDidChange(_ currentDuration: TimeInterval, totalDuration: TimeInterval) {
        super.playerDurationDidChange(currentDuration, totalDuration: totalDuration)
        if let sub = self.subtitles?.search(for: currentDuration) {
            self.subtitlesLabel.isHidden = false
            self.subtitlesLabel.text = sub.content
        } else {
            self.subtitlesLabel.isHidden = true
        }
       // self.bottomProgressView.setProgress(Float(currentDuration/totalDuration), animated: true)
    }
    
    open func setSubtitles(_ subtitles : VGSubtitles) {
        self.subtitles = subtitles
    }
    
    
}
