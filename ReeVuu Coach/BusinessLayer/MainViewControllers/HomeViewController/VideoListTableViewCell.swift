//
//  VideoListTableViewCell.swift
//  ReeVuu Coach
//
//  Created by Dev on 29/10/18.
//  Copyright © 2018 Dev. All rights reserved.
//

import UIKit

class VideoListTableViewCell: UITableViewCell {
    
    @IBOutlet weak var btnMuteUnmute: UIButton!
    var delegate:HomeMuteDelegate? = nil
    var indexPath:IndexPath? = nil
    @IBOutlet weak var lblUserName: UILabel!
    @IBOutlet weak var lblGame: UILabel!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var imgVideo: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func actionMute(_ sender: Any) {
      if  self.indexPath != nil && self.delegate != nil {
self.delegate!.muteUnmutePressedAt(indexpath: self.indexPath!)
        }
    }
}
