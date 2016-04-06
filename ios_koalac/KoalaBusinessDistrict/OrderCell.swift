//
//  OrderCell.swift
//  koalac_PPM
//
//  Created by liuny on 15/6/18.
//  Copyright (c) 2015年 考拉先生. All rights reserved.
//

import UIKit

class OrderCell: UITableViewCell {

   
    @IBOutlet weak var showOrderInfoView: UIView!
    @IBOutlet weak var showPayWayLabel: UILabel!
    @IBOutlet weak var showDateLabel: UILabel!
    @IBOutlet weak var showNameLabel: UILabel!
    @IBOutlet weak var headIconImageView: UIImageView!
    
    var cellData:OrderModel = OrderModel()
        {
        didSet{
            self.showDateLabel.text = GTimeSecondToSting(self.cellData.add_time, format: "yyyy-MM-dd")
            self.showNameLabel.text = self.cellData.user_name
            self.headIconImageView.setImageWithURL(NSURL(string: self.cellData.avatar)!, placeholderImage: UIImage(named: "PlaceHolder"))
            
            var isOrderFinished = false
            let statusInt = (self.cellData.status as NSString).integerValue
            if statusInt == 0{
            
            }else if statusInt == 10{
            
            }else if statusInt == 20{
            
            }else if statusInt == 30{
                
            }else if statusInt == 40{
                isOrderFinished = true
            }else{
                
            }
            
            if isOrderFinished == true{
                self.showPayWayLabel.textColor = GlobalStyleFontColor
                self.showPayWayLabel.text = "已完成"
            }else{
                self.showPayWayLabel.textColor = UIColor.lightGrayColor()
                if self.cellData.payType == "cod"{
                    self.showPayWayLabel.text = "支付方式：货到付款"
                }else if self.cellData.payType == "lifeqcard"{
                    self.showPayWayLabel.text = "支付方式：考拉钱包"
                }else{
                    self.showPayWayLabel.text = "支付方式：其他方式"
                }
            }
            
            for item in self.showOrderInfoView.subviews{
                if item.isKindOfClass(OrderGoodView){
                    item.removeFromSuperview()
                }
            }
            
            var index:CGFloat = 0.0
            for item in self.cellData.goods{
                let goodView = OrderGoodView.instantiateFromNib()
                goodView.goodData = item
                let yLocation = index*(OrderGoodView.viewHeight())
                goodView.frame = CGRectMake(80.0, yLocation, UIScreen.mainScreen().bounds.size.width-80.0, OrderGoodView.viewHeight())
                self.showOrderInfoView.addSubview(goodView)
                index++
            }
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        self.initControl()
    }

    private func initControl(){
        self.showPayWayLabel.font = GGetCustomFontWithSize(GNormalFontSize - 1.0)
        self.showPayWayLabel.textColor = UIColor.lightGrayColor()
        self.showNameLabel.font = GGetNormalCustomFont()
        self.showNameLabel.textColor = GlobalStyleFontColor
        self.showDateLabel.font = GGetCustomFontWithSize(GNormalFontSize-2.0)
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    static func cellIdentifier()->String{
        return "OrderCell"
    }
    
    static func cellHeight()->CGFloat{
        return 80.0
    }
}
