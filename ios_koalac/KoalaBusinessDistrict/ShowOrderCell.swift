//
//  ShowOrderCell.swift
//  KoalaBusinessDistrict
//
//  Created by Adobe on 15/12/17.
//  Copyright © 2015年 koalac. All rights reserved.
//

import UIKit

class ShowOrderCell: UITableViewCell {

  
    @IBOutlet weak var goodNameLabel: UILabel!
    @IBOutlet weak var buyNumLabel: UILabel!
    @IBOutlet weak var goodImageView: UIImageView!

    
    var cellData:GoodModel = GoodModel(){
        didSet{
          
            pprLog("\(cellData.goods_name) \(cellData.quantity)")
            self.goodImageView.setImageWithURL(NSURL(string:   cellData.goods_image)!, placeholderImage: UIImage(named: "PlaceHolder"))
            self.goodNameLabel.text = self.cellData.goods_name
            
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
        self.buyNumLabel.textColor = GlobalStyleFontColor
    }
  
    static func cellIdentifier()->String{
        return "showOrderCell"
    }
    
    static func CellHeight()->CGFloat{
        return 80.0
    }
    
}
