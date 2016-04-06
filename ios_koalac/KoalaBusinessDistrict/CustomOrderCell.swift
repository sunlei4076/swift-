//
//  CustomOrderCell.swift
//  koalac_PPM
//
//  Created by liuny on 15/6/15.
//  Copyright (c) 2015年 考拉先生. All rights reserved.
//

import UIKit

class CustomOrderCell: UITableViewCell {

    @IBOutlet weak var boardView: UIView!
    @IBOutlet weak var showTimeLabel: UILabel!
    @IBOutlet weak var showNameLabel: UILabel!
    var orderData:CustomerOrderModel = CustomerOrderModel()
        {
        didSet{
            self.showNameLabel.text = self.orderData.customerName
            self.showTimeLabel.text = GTimeSecondToSting(self.orderData.order_time, format: "yyyy-MM-dd")
            
            for item in self.boardView.subviews{
                if item.isKindOfClass(OrderGoodView){
                    item.removeFromSuperview()
                }
            }
            
            var index:CGFloat = 0.0
            for item in self.orderData.orderList{
                let goodView = OrderGoodView.instantiateFromNib()
                goodView.goodData = item
                let yLocation = 44.0 + index*(OrderGoodView.viewHeight())
                goodView.frame = CGRectMake(0, yLocation, self.boardView.bounds.size.width, OrderGoodView.viewHeight())
                self.boardView.addSubview(goodView)
                index++
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.initControl()
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    private func initControl(){
        self.backgroundColor = GlobalBgColor
        self.showNameLabel.textColor = GlobalStyleFontColor
        self.showNameLabel.font = GGetNormalCustomFont()
        self.showTimeLabel.textColor = UIColor.darkGrayColor()
        self.showTimeLabel.font = GGetCustomFontWithSize(GNormalFontSize-2.0)
        
        self.boardView.layer.borderColor = GlobalGrayFontColor.CGColor
        self.boardView.layer.borderWidth = 1.0
    }
    
    static func cellIdentifier()->String{
        return "CustomOrderCell"
    }
    
    static func cellHeight()->CGFloat{
        return 60.0+10
    }
    
}
