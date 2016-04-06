//
//  OrderGoodView.swift
//  koalac_PPM
//
//  Created by liuny on 15/6/15.
//  Copyright (c) 2015年 考拉先生. All rights reserved.
//

import UIKit

class OrderGoodView: UIView {
    @IBOutlet weak var showOrderNameLabel: UILabel!
    @IBOutlet weak var showOrderNumLabel: UILabel!
    
    var goodData:GoodModel = GoodModel()
        {
        didSet{
            self.showOrderNumLabel.text = "x" + self.goodData.quantity
            self.showOrderNameLabel.text = self.goodData.goods_name
        }
    }
    class func instantiateFromNib() -> OrderGoodView {
        let view = UINib(nibName: "OrderGoodView", bundle: nil).instantiateWithOwner(nil, options: nil).first as! OrderGoodView
        
        return view
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.initControl()
    }
    
    private func initControl()
    {
        self.backgroundColor = UIColor.clearColor()
        self.showOrderNameLabel.font = GGetCustomFontWithSize(GNormalFontSize-2.0)
        self.showOrderNumLabel.font = GGetCustomFontWithSize(GNormalFontSize-2.0)
    }
    
    static func viewHeight()->CGFloat{
        return 20.0;
    }
    
}
