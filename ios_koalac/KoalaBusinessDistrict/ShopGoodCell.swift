//
//  ShopGoodCell.swift
//  koalac_PPM
//
//  Created by liuny on 15/6/15.
//  Copyright (c) 2015年 考拉先生. All rights reserved.
//

import UIKit

class ShopGoodCell: UITableViewCell {

    @IBOutlet weak var qrcodeBtn: UIButton!
    @IBOutlet weak var goodImageView: UIImageView!
    @IBOutlet weak var editBtn: UIButton!
    @IBOutlet weak var onOffBtn: UIButton!
    @IBOutlet weak var updateBtn: UIButton!
    @IBOutlet weak var showTimeLabel: UILabel!
    @IBOutlet weak var showCurrPriceLabel: UILabel!
    @IBOutlet weak var showOriginPriceLabel: UILabel!
    @IBOutlet weak var showGoodNameLabel: UILabel!
    @IBOutlet weak var goodStock: UILabel!
    
    var shopGoodData:ShopGoodModel = ShopGoodModel()
        {
        didSet{
            self.showGoodNameLabel.text = self.shopGoodData.goods_name
            self.goodStock.text = "库存：" + self.shopGoodData.stock
            self.showCurrPriceLabel.text = "￥" + self.shopGoodData.price
            self.showOriginPriceLabel.text = "￥" + self.shopGoodData.orige_price
            self.showTimeLabel.text = GTimeSecondToSting(self.shopGoodData.add_time, format: "yyyy-MM-dd")
            
//            pprLog(self.shopGoodData.default_image)
            self.goodImageView.setImageWithURL(NSURL(string: self.shopGoodData.default_image)!, placeholderImage: UIImage(named: "PlaceHolder"))
            let isShow = self.shopGoodData.if_show
            let isShowFloat = (isShow as NSString).floatValue
            if isShowFloat == 1.0{
                self.onOffBtn.setTitle("下架", forState: UIControlState.Normal)
            }else{
                self.onOffBtn.setTitle("上架", forState: UIControlState.Normal)
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
        
        let norFont = GGetNormalCustomFont()
        self.showGoodNameLabel.font = norFont
        self.showCurrPriceLabel.font = norFont
        self.showOriginPriceLabel.font = norFont
        self.goodStock.font = norFont
        self.showTimeLabel.font = GGetCustomFontWithSize(GNormalFontSize-1.0)
        self.showCurrPriceLabel.textColor = GlobalStyleFontColor
        
        self.onOffBtn.titleLabel?.font = norFont
        self.updateBtn.titleLabel?.font = norFont
        self.editBtn.titleLabel?.font = norFont
        self.qrcodeBtn.titleLabel?.font = norFont
        
        let grayColor = UIColor.lightGrayColor()
        self.onOffBtn.setTitleColor(grayColor, forState: UIControlState.Normal)
        self.updateBtn.setTitleColor(grayColor, forState: UIControlState.Normal)
        self.editBtn.setTitleColor(grayColor, forState: UIControlState.Normal)
        self.qrcodeBtn.setTitleColor(grayColor, forState: UIControlState.Normal)
    }
    
    static func cellIdentifier()->String{
        return "ShopGoodCell"
    }
    
    static func cellHeight()->CGFloat{
        return 120.0
    }
    @IBAction func actionQrcodeShare(sender: AnyObject) {
        let shareView = ShareView.instantiateFromNib()
        shareView.shareGoodData = self.shopGoodData
        shareView.show()
    }
}




