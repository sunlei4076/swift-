//
//  ReceivingCell.swift
//  koalac_PPM
//
//  Created by liuny on 15/6/17.
//  Copyright (c) 2015年 考拉先生. All rights reserved.
//

import UIKit

class ReceivingCell: UITableViewCell {

    @IBOutlet weak var bordView: UIView!
    @IBOutlet weak var shopImageView: UIImageView!
    @IBOutlet weak var receivingStatusLabel: UILabel!
    @IBOutlet weak var shopNameLabel: UILabel!
    
    var cellData:ReceivingModel = ReceivingModel(){
        didSet{
            self.shopNameLabel.text = self.cellData.name
            self.shopImageView.setImageWithURL(NSURL(string: self.cellData.avatar)!, placeholderImage: UIImage(named: "Receiving_ShopIconHolder"))
            let statusFloat = (self.cellData.status as NSString).floatValue
            if statusFloat == 0{
                self.receivingStatusLabel.text = "未入库"
            }else if statusFloat == 1{
                self.receivingStatusLabel.text = "缺货"
            }else if statusFloat == 2{
                self.receivingStatusLabel.text = "收齐"
            }
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        self.initControl()
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        if selected == true{
            self.bordView.backgroundColor = UIColor.lightGrayColor()
        }else{
            self.bordView.backgroundColor = UIColor.whiteColor()
        }
    }
    
    private func initControl(){
        self.backgroundColor = GlobalBgColor
        self.receivingStatusLabel.font = GGetCustomFontWithSize(GNormalFontSize-2.0)
        self.shopNameLabel.font = GGetNormalCustomFont()
        self.receivingStatusLabel.textColor = UIColor.lightGrayColor()
        
        self.bordView.layer.borderWidth = 1.0
        self.bordView.layer.borderColor = GlobalGrayFontColor.CGColor
    }
    
    static func cellIdentifier()->String{
        return "ReceivingCell"
    }
    
    static func cellHeight()->CGFloat{
        return 80.0
    }
}
