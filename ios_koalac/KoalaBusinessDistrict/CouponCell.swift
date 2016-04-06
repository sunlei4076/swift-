//
//  CouponCell.swift
//  koalac_PPM
//
//  Created by liuny on 15/7/3.
//  Copyright (c) 2015年 考拉先生. All rights reserved.
//

import UIKit

class CouponCell: UITableViewCell {

    @IBOutlet weak var showTimeLabel: UILabel!
    @IBOutlet weak var showConditionLabel: UILabel!
    @IBOutlet weak var tipCouponLabel: UILabel!
    @IBOutlet weak var tipYuanLabel: UILabel!
    @IBOutlet weak var showNumLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        self.initControl()
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    private func initControl(){
        let redColor = GGetColor(220.0, g: 46.0, b: 58.0)
        self.showNumLabel.font = GGetCustomFontWithSize(GBigFontSize + 2.0)
        self.showNumLabel.textColor = redColor
        self.tipYuanLabel.font = GGetCustomFontWithSize(GNormalFontSize - 2.0)
        self.tipYuanLabel.textColor = redColor
        self.tipCouponLabel.font = GGetNormalCustomFont()
        self.tipCouponLabel.textColor = redColor
        self.showConditionLabel.font = GGetNormalCustomFont()
        self.showTimeLabel.font = GGetCustomFontWithSize(GNormalFontSize-1.0)
        self.showTimeLabel.textColor = UIColor.lightGrayColor()
    }
    
    static func cellIdentifier()->String{
        return "CouponCell"
    }
    
    static func cellHeight()->CGFloat{
        return 100.0
    }
}
