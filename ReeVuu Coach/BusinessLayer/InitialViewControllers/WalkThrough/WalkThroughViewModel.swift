//
//  WalkThroughViewModel.swift
//  Barrel13
//
//  Created by developer on 05/02/18.
//  Copyright © 2018 developer. All rights reserved.
//

import UIKit
import FSPagerView
class WalkThroughViewModel: NSObject {
    
}

extension WalkThrough : FSPagerViewDataSource,FSPagerViewDelegate{
    //MARK:-FSPager data sorce
    public func numberOfItems(in pagerView: FSPagerView) -> Int {
        return 5
    }
    
    public func pagerView(_ pagerView: FSPagerView, cellForItemAt index: Int) -> FSPagerViewCell {
        let cell = pagerView.dequeueReusableCell(withReuseIdentifier: "cell", at: index)
        switch  index {
        case 0:
           cell.imageView?.image = UIImage.init(named: WalthroughsImages.walk1.rawValue)
           break
        case 1:
            cell.imageView?.image = UIImage.init(named: WalthroughsImages.walk2.rawValue)
            break
        case 2:
            cell.imageView?.image = UIImage.init(named: WalthroughsImages.walk3.rawValue)
            break
        case 3:
            cell.imageView?.image = UIImage.init(named: WalthroughsImages.walk4.rawValue)
            break
        case 4:
            cell.imageView?.image = UIImage.init(named: WalthroughsImages.walk5.rawValue)
            break
        default:
            cell.imageView?.image = UIImage.init(named: WalthroughsImages.walk1.rawValue)
            break
        }
        cell.imageView?.contentMode = .scaleAspectFit
        
        return cell
    }
    
    func pagerView(_ pagerView: FSPagerView, willDisplay cell: FSPagerViewCell, forItemAt index: Int){
     
    }
    @objc func changeScrollState(){
        self.isScrolling = false
        viewPager.automaticSlidingInterval = 6.0
    }
    func changeTitleAndDescription(forIndex index :Int){
        self.btnNext.setTitle("NEXT", for: .normal)
        self.lblDescription.fadeTransition(0.5)
        self.lblTitle.fadeTransition(0.5)
        switch  index {
        case 0:
            
            self.lblTitle.text = WalthroughsHeading.heading1.rawValue
       self.lblDescription.text = WalthroughsDescription.Description1.rawValue
        case 1:
              self.lblDescription.text = WalthroughsDescription.Description2.rawValue
            self.lblTitle.text = WalthroughsHeading.heading2.rawValue
        case 2:
            self.lblDescription.text = WalthroughsDescription.Description3.rawValue
            self.lblTitle.text = WalthroughsHeading.heading3.rawValue
        case 3:
            self.lblDescription.text = WalthroughsDescription.Description4.rawValue
            self.lblTitle.text = WalthroughsHeading.heading4.rawValue
        case 4:
            self.btnNext.setTitle("GET STARTED", for: .normal)
            self.lblDescription.text = WalthroughsDescription.Description5.rawValue
            self.lblTitle.text = WalthroughsHeading.heading5.rawValue
            
            
        default:
            self.lblDescription.text = WalthroughsDescription.Description1.rawValue
            self.lblTitle.text = WalthroughsHeading.heading1.rawValue
        }
      
        if index == 5{
            self.viewPager.automaticSlidingInterval = -1
        }
        else{
            self.viewPager.automaticSlidingInterval = 6
        }
            self.pageControl.currentPage=index
           self.pageControl.setNeedsDisplay()
        
    }
    
    func pagerViewDidScroll(_ pagerView: FSPagerView){
        if isScrolling{
            return
        }
        let index = pagerView.currentIndex
        self.changeTitleAndDescription(forIndex: index)
     
        
    }
    func pagerViewDidEndDecelerating(_ pagerView: FSPagerView) {
        if isScrolling{
            return
        }
          let index = pagerView.currentIndex
       self.changeTitleAndDescription(forIndex: index)
       
    }
    func pagerViewWillEndDragging(_ pagerView: FSPagerView, targetIndex: Int) {
        if isScrolling{
            return
        }
          let index = pagerView.currentIndex
        self.changeTitleAndDescription(forIndex: index)
       
    }
    
}

