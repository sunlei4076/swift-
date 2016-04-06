//
//  ShopTypeCell.swift
//  koalac_PPM
//
//  Created by liuny on 15/6/15.
//  Copyright (c) 2015年 考拉先生. All rights reserved.
//

import UIKit

class ShopTypeCell: UITableViewCell {

    @IBOutlet weak var editBtn: UIButton!
    @IBOutlet weak var deleteBtn: UIButton!
    @IBOutlet weak var showNumLabel: UILabel!
    @IBOutlet weak var showTypeNameLabel: UILabel!
    
    var shopTypeData:ShopTypeModel = ShopTypeModel(){
        didSet{
            self.showTypeNameLabel.text = self.shopTypeData.cate_name
            let num:Int = (self.shopTypeData.goods_num as NSString).integerValue
            self.showNumLabel.text = "共\(num)件商品"
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
        self.showTypeNameLabel.font = GGetNormalCustomFont()
        self.showNumLabel.font = GGetCustomFontWithSize(GNormalFontSize - 2.0)
        self.showNumLabel.textColor = GlobalGrayFontColor
    }
    
    static func cellIdentifier()->String{
        return "ShopTypeCell"
    }
    static func cellHeight()->CGFloat{
        return 60.0
    }
}
