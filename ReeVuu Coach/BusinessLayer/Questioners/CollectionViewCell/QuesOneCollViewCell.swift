//
//  QuseOneCollViewCell.swift
//  ReeVuu Coach
//
//  Created by Dev on 23/10/18.
//  Copyright © 2018 Dev. All rights reserved.
//

import UIKit

class QuesOneCollViewCell: UICollectionViewCell {
    
    @IBOutlet weak var lblQuesNo: UILabel!
    @IBOutlet weak var lblQues: UILabel!
    var noOfOptions:Int = 1
    var arrOption = [OptionModal]()
    
    @IBOutlet weak var collectionViewOptions: UICollectionView!
    
    func setup() {
        collectionViewOptions.delegate = self
        collectionViewOptions.dataSource = self
        collectionViewOptions.reloadData()
    }
    
   
    
}
extension QuesOneCollViewCell: UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
            return arrOption.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CellIdentifiers.QuesTwoCollViewCell, for: indexPath) as? QuesTwoCollViewCell{
            cell.configure(data: arrOption[indexPath.item])
            return cell
        }
        
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    
        let data = arrOption[indexPath.item]
        
        data.isSelected = !data.isSelected
        if let cell = collectionView.cellForItem(at: indexPath) as? QuesTwoCollViewCell {
            cell.setBackgroundColor(isSelected: data.isSelected)
        }
        //arrOption.filter{$0.isSelected == true}
        if data.questionType == "1"{
            
            
            for (index,value) in arrOption.enumerated(){
                if value != data {
                    value.isSelected = false
                    if let cell = collectionView.cellForItem(at: IndexPath(item: index, section: 0)) as? QuesTwoCollViewCell {
                        cell.setBackgroundColor(isSelected: value.isSelected)
                    }
                }
            }
            
            
        }else{
            data.isMultiple = true
        }
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if arrOption.count  > 3{
            return CGSize.init(width: collectionView.frame.size.width/2.12, height: 46)
        }else{
            return CGSize.init(width: collectionView.frame.size.width, height: 46)
        }
        
    }
    
}
