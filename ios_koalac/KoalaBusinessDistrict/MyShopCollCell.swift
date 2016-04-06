//
//  MyShopCollCell.swift
//  KoalaBusinessDistrict
//
//  Created by seekey on 15/11/12.
//  Copyright © 2015年 koalac. All rights reserved.
//

import UIKit

class MyShopCollCell: UICollectionViewCell {
    
    @IBOutlet weak var cellIcon: UIImageView!
    @IBOutlet weak var cellTitle: UILabel!
    @IBOutlet weak var colletCellBadge: UIButton!
    
    var ShopCellData:tabModel = tabModel(){
        didSet{
            self.cellIcon.setImageWithURL(NSURL(string: self.ShopCellData.myShop_IconUrl)!, placeholderImage: UIImage(named: "koalac_no_avatar"))
            self.cellTitle.text = self.ShopCellData.myShop_tabName
        }
    }
    
    var unfinishOrder:String = "" {
        didSet{
//            if unfinishOrder.isEmpty  == false {
                if cellTitle.text == "订单管理" {
//                    self.colletCellBadge.hidden = false
                    if (unfinishOrder as NSString).integerValue > 1000 {
                        self.colletCellBadge.setTitle("...", forState: UIControlState.Normal)
                    }else{
                        self.colletCellBadge.setTitle(unfinishOrder, forState: UIControlState.Normal)
                    }

                    if unfinishOrder == "0" {
                        self.colletCellBadge.hidden = true
                    }
                    
                    
                    if LoginInfoModel.sharedInstance.shopStatus != "1"{
                        
                        self.colletCellBadge.hidden = true
                    }
                    
                  
                }

//            }
        }
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if cellTitle.text == "订单管理" {
//            pprLog(cellTitle.text)
//            self.colletCellBadge.hidden = false
//            self.colletCellBadge.setTitle(unfinishOrder, forState: UIControlState.Normal)
        }
        else {
            self.colletCellBadge.hidden = true
        }
        
    }
    
    override func awakeFromNib() {
      // 后面添加
//        self.colletCellBadge.hidden = true
    
        
//        self.colletCellBadge.setTitle(unfinishOrder, forState: UIControlState.Normal)
        self.cellTitle.font = UIFont(name: CustomFontName, size: (GSmallFontSize - 1))!
    }

}
