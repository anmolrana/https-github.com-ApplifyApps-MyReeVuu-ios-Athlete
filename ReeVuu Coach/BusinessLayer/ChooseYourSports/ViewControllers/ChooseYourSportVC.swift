//
//  ChooseYourSportVC.swift
//  ReeVuu Coach
//
//  Created by Dev on 23/10/18.
//  Copyright © 2018 Dev. All rights reserved.
//

import UIKit
import SDWebImage
import RMPZoomTransitionAnimator

class ChooseYourSportVC: UIViewController {

    @IBOutlet weak var collectionViewSports: UICollectionView!
    @IBOutlet weak var btnNext: UIButton!
    
    lazy var arrSportsOptions :[SportsEntity] = {
        return  DBManager.fetchDataWithParameters(dataType: SportsEntity.self)
    }()
    var selectedImageView = UIImageView()
    var selectedImageFrame = CGRect.zero
    var arrData = [ChooseSportsModal]()
    var arrSportsIds:[String] = []
    let arrPlaceholderImage : [UIImage] = [UIImage.init(named: "ic_tennis") ?? UIImage(),UIImage.init(named: "ic_wrestling") ?? UIImage()]
    
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return .lightContent
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setData()
    }
    
    func setData(){
        for value1 in arrSportsOptions{
            let data = ChooseSportsModal()
            data.sportName = value1.name
            data.sportImage = value1.image
            data.id = value1.id ?? ""
            data.sportDescription = value1.sportDescription
            arrData.append(data)
            collectionViewSports.reloadData()
        }
    }

    //MARK:- Button action
    
    @IBAction func actionNext(_ sender: UIButton) {
       sportChoosen()
    }
    func sportChoosen(){
        let vc = StoreyBoard.StoreyboardIntial().storeyboadForReevuu.instantiateViewController(withIdentifier: "QuestionersVC") as! QuestionersVC
        arrSportsIds.removeAll()
        for d in arrData{
            
            if d.isSelected{
                arrSportsIds.append(d.id)
            }
        }
        if arrSportsIds.count == 0 {
            CommonFunctions.showAlertWithTitle(title: ValidationConstants.ErrorTitle, message: "Please select at least one sport to proceed")
            return
        }
        let str = arrSportsIds.joined(separator: ",")
        vc.sportId = str
        self.navigationController?.pushViewController(vc, animated: true)
        
       
//   
//        selectedImageFrame = (cell.imgEvent.convert((cell.imgEvent.bounds), to: self.view))
//        self.navigationController?.delegate = self
//        selectedImageView = UIImageView.init(frame: selectedImageFrame)
//        selectedImageView.image = cell.imgEvent.image
//        selectedImageView.clipsToBounds = true
//        self.navigationController?.pushViewController(vc, animated: true)
//        
        
    }
    
    
}

extension ChooseYourSportVC: UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CellIdentifiers.ChooseSportCollViewCell, for: indexPath) as? ChooseSportCollViewCell{
            cell.lblHeading.text = arrData[indexPath.item].sportName?.uppercased()
            cell.lblDescription.text = arrData[indexPath.item].sportDescription
        cell.imgChecked.image = arrData[indexPath.row].isSelected ? UIImage.init(named: "ic_select_tick") : UIImage()
            cell.imgSports.sd_setImage(with: URL(string: arrData[indexPath.item].sportImage ?? ""), placeholderImage: arrPlaceholderImage[indexPath.item], options: .highPriority, completed: nil)
            
        return cell
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let data = arrData[indexPath.item]
        data.isSelected = !data.isSelected
        let vc = StoreyBoard.StoreyboardIntial().storeyboadForReevuu.instantiateViewController(withIdentifier: "QuestionersVC") as! QuestionersVC
        arrSportsIds.removeAll()
//        for d in arrData{
//
//            if d.isSelected{
//                arrSportsIds.append(d.id)
//            }
//        }
//        if arrSportsIds.count == 0 {
//            CommonFunctions.showAlertWithTitle(title: ValidationConstants.ErrorTitle, message: "Please select at least one sport to proceed")
//            return
//        }
        arrSportsIds.append(arrData[indexPath.row].id)
        let str = arrSportsIds.joined(separator: ",")
        vc.sportId = str
        vc.sportM = data
        KUSERDEFAULT.set(data.sportName, forKey: UserDefaultConstants.sportPlayed)
        self.navigationController?.pushViewController(vc, animated: true)
            //sportChoosen()
//        for value in arrData{
//            if value != data{
//               value.isSelected = false
//            }
//        }
           // collectionView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize.init(width: KScreenWidth*0.471, height: KScreenHeight*0.4)
    }
    
}


extension ChooseYourSportVC :  UINavigationControllerDelegate,RMPZoomTransitionAnimating,RMPZoomTransitionDelegate {
    func zoomTransitionAnimator(_ animator: RMPZoomTransitionAnimator, didCompleteTransition didComplete: Bool, animatingSourceImageView imageView: UIImageView) {
//        if eventScreenType != NMEnumEventScreenType.Event.rawValue{
//
//            self.tabBarController?.tabBar.isHidden = true
//        }
    }
    func transitionSourceBackgroundColor() -> UIColor {
        return   self.view.backgroundColor!
    }
    
    
    func transitionSourceImageView() -> UIImageView {
        let imageView = UIImageView.init(frame: selectedImageView.frame)
        imageView.image = selectedImageView.image
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.isUserInteractionEnabled = false
        return imageView
    }
    func transitionDestinationImageViewFrame() -> CGRect {
        return  selectedImageFrame
    }
    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationController.Operation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        if toVC is QuestionersVC{
            let animator = RMPZoomTransitionAnimator()
            
            animator.goingForward = (operation == UINavigationController.Operation.push) ? true : false
            animator.sourceTransition = self
            animator.destinationTransition = toVC as?  RMPZoomTransitionAnimating & RMPZoomTransitionDelegate
            return animator
        }
        return nil
    }
}
