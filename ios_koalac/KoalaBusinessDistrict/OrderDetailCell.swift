//
//  OrderDetailCell.swift
//  koalac_PPM
//
//  Created by liuny on 15/6/19.
//  Copyright (c) 2015年 考拉先生. All rights reserved.
//

import UIKit

class OrderDetailCell: UITableViewCell {

    @IBOutlet weak var goodNameLabel: UILabel!
    @IBOutlet weak var buyNumLabel: UILabel!
    @IBOutlet weak var goodGuiGeLabel: UILabel!
    @IBOutlet weak var goodImageView: UIImageView!
    
    var cellData:GoodModel = GoodModel(){
        didSet{
            self.goodImageView.setImageWithURL(NSURL(string: self.cellData.goods_image)!, placeholderImage: UIImage(named: "PlaceHolder"))
            self.goodNameLabel.text = self.cellData.goods_name
            self.goodGuiGeLabel.text = "规格：默认规格"
            self.buyNumLabel.text = "x" + self.cellData.quantity
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
        self.goodNameLabel.numberOfLines = 2
        self.goodNameLabel.font = GGetNormalCustomFont()
        self.buyNumLabel.font = GGetNormalCustomFont()
        self.goodGuiGeLabel.font = GGetCustomFontWithSize(GNormalFontSize-1.0)
        self.buyNumLabel.textColor = GlobalStyleFontColor
    }
    
    static func cellIdentifier()->String{
        return "OrderDetailCell"
    }
    
    static func CellHeight()->CGFloat{
        return 80.0
    }
}
