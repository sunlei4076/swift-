//
//  ShopGoodAddCell.swift
//  koalac_PPM
//
//  Created by liuny on 15/6/15.
//  Copyright (c) 2015年 考拉先生. All rights reserved.
//

import UIKit

class ShopGoodAddCell: UITableViewCell {


    @IBOutlet weak var goodImageView: UIImageView!
    @IBOutlet weak var showTimeLabel: UILabel!
    @IBOutlet weak var showGoodNameLabel: UILabel!
    

    var shopGoodData:ShopGoodModel = ShopGoodModel()
        {
        didSet{
            self.showGoodNameLabel.text = self.shopGoodData.goods_name
            self.showTimeLabel.text = GTimeSecondToSting(self.shopGoodData.add_time, format: "yyyy-MM-dd")
            self.goodImageView.setImageWithURL(NSURL(string: self.shopGoodData.default_image)!, placeholderImage: UIImage(named: "PlaceHolder"))
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
        self.showTimeLabel.font = GGetCustomFontWithSize(GNormalFontSize-1.0)
    }
    
    static func cellIdentifier()->String{
        return "ShopGoodAddCell"
    }
    
    static func cellHeight()->CGFloat{
        return 120.0
    }

}
