//
//  CommonProtocol.swift
//  ProjectTemplate
//
//  Created by Ankit Goyal on 15/03/2018.
//  Copyright © 2018 Applify Tech Pvt Ltd. All rights reserved.
//

import Foundation
import UIKit


protocol OptionSelectedDelegate {
 func optionsSelected(optionsSelected: [String], onButton: UIButton)
}

protocol SecondSportAddDelegate {
    func secondSportAdded(indexPath:IndexPath)
    func sportDeleted(indexPath:IndexPath, isSportAdded:Bool)
}

protocol HomeMuteDelegate {
    func muteUnmutePressedAt(indexpath:IndexPath)
}
