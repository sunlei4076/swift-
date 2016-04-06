//
//  ReceivingDetailCell.swift
//  koalac_PPM
//
//  Created by liuny on 15/6/18.
//  Copyright (c) 2015年 考拉先生. All rights reserved.
//

import UIKit

class ReceivingDetailCell: UITableViewCell {

    @IBOutlet weak var showGuiGeLabel: UILabel!
    @IBOutlet weak var statusTwoBuHuoBtn: UIButton!
    @IBOutlet weak var statusTwoLabel: UILabel!
    @IBOutlet weak var statusZeroShouQiBtn: UIButton!
    @IBOutlet weak var statusZeroQueHuoBtn: UIButton!
    @IBOutlet weak var statusTwoView: UIView!
    @IBOutlet weak var statusOneView: UIView!
    @IBOutlet weak var statusZeroView: UIView!
    @IBOutlet weak var showBuyNumLabel: UILabel!
    @IBOutlet weak var showGoodNameLable: UILabel!
    @IBOutlet weak var goodImageView: UIImageView!
    
    var cellData:ReceivingDetailModel = ReceivingDetailModel(){
        didSet{
            let statusFloat = (self.cellData.status as NSString).floatValue
            if statusFloat == 0{
                self.statusOneView.hidden = true
                self.statusTwoView.hidden = true
                self.statusZeroView.hidden = false
            }else if statusFloat == 1{
                self.statusZeroView.hidden = true
                self.statusOneView.hidden = true
                self.statusTwoView.hidden = false
                self.statusTwoLabel.text = "实收\(self.cellData.quantity)份    缺\(self.cellData.real_num)份"
            }else if statusFloat == 2{
                self.statusZeroView.hidden = true
                self.statusOneView.hidden = true
                self.statusTwoView.hidden = false
                self.statusTwoLabel.text = "实收\(self.cellData.quantity)份    缺\(self.cellData.real_num)份"
            }
            
            self.showGoodNameLable.text = self.cellData.goods_name
            self.showBuyNumLabel.text = "x" + self.cellData.quantity
            self.showGuiGeLabel.text = "规格:默认规格"
            self.goodImageView?.setImageWithURL(NSURL(string: self.cellData.goods_image)!, placeholderImage: UIImage(named: "Receiving_ShopIconHolder"))
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.initControl()
    }
    
    private func initControl(){
        self.showGoodNameLable.font = GGetNormalCustomFont()
        self.showGoodNameLable.numberOfLines = 2
        self.showBuyNumLabel.font = GGetNormalCustomFont()
        self.showGuiGeLabel.font = GGetCustomFontWithSize(GNormalFontSize-2.0)
        self.showGuiGeLabel.textColor = UIColor.lightGrayColor()
        
        self.statusZeroQueHuoBtn.layer.borderWidth = 1.0
        self.statusZeroQueHuoBtn.layer.borderColor = GlobalStyleFontColor.CGColor
        self.statusZeroQueHuoBtn.layer.cornerRadius = 2.0
        self.statusZeroQueHuoBtn.setTitleColor(GlobalStyleFontColor, forState: UIControlState.Normal)
        self.statusZeroQueHuoBtn.titleLabel?.font = GGetNormalCustomFont()
        
        let greenColor = GGetColor(87.0, g: 179.0, b: 141.0)
        self.statusZeroShouQiBtn.layer.borderWidth = 1.0
        self.statusZeroShouQiBtn.layer.borderColor = greenColor.CGColor
        self.statusZeroShouQiBtn.layer.cornerRadius = 2.0
        self.statusZeroShouQiBtn.setTitleColor(greenColor, forState: UIControlState.Normal)
        self.statusZeroShouQiBtn.titleLabel?.font = GGetNormalCustomFont()
        
        self.statusTwoBuHuoBtn.layer.cornerRadius = 2.0
        self.statusTwoBuHuoBtn.backgroundColor = GlobalStyleFontColor
        self.statusTwoBuHuoBtn.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        self.statusTwoBuHuoBtn.titleLabel?.font = GGetNormalCustomFont()
        
        self.statusTwoLabel.font = GGetCustomFontWithSize(GNormalFontSize-2.0)
        self.statusTwoLabel.textColor = GlobalStyleFontColor
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    static func cellHeight()->CGFloat{
        return 110.0
    }
    
    static func cellIdentifier()->String{
        return "ReceivingDetailCell"
    }
}
