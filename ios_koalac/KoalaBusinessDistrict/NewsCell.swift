//
//  NewsCell.swift
//  koalac_PPM
//
//  Created by liuny on 15/6/23.
//  Copyright (c) 2015年 考拉先生. All rights reserved.
//

import UIKit
class NewsCell: UITableViewCell {
       
    @IBOutlet weak var unreadNumLabel: UILabel!
    @IBOutlet weak var unreadView: UIView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var lastNewLabel: UILabel!
    @IBOutlet weak var headImage: UIImageView!
    
    var cellData:NewsModel = NewsModel(){
        didSet{
            self.headImage.setImageWithURL(NSURL(string: self.cellData.userHeadIcon)!, placeholderImage: UIImage(named: "koalac_no_avatar"))
            self.nameLabel.text = self.cellData.userName
            self.dateLabel.text = GTimeSecondToSting(self.cellData.newDate, format: "yyyy-MM-dd") 
            self.lastNewLabel.text = self.cellData.lastNew
            let unreadNum = (self.cellData.unreadNum as NSString).integerValue
            if unreadNum == 0{
                self.unreadView.hidden = true
            }else{
                self.unreadView.hidden = false
                self.unreadNumLabel.text = String(unreadNum)
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
        self.nameLabel.font = GGetNormalCustomFont()
        self.nameLabel.numberOfLines = 2
        self.dateLabel.font = GGetCustomFontWithSize(GNormalFontSize-2.0)
        self.lastNewLabel.font = GGetCustomFontWithSize(GNormalFontSize-1.0)
        self.lastNewLabel.textColor = UIColor.lightGrayColor()
        self.dateLabel.textColor = UIColor.lightGrayColor()
        
        self.unreadView.backgroundColor = UIColor.redColor()
        self.unreadView.layer.cornerRadius = 11.0
        self.unreadView.layer.masksToBounds = true
        
        self.unreadNumLabel.font = GGetNormalCustomFont()
        self.unreadNumLabel.textColor = UIColor.whiteColor()
    }
    
    static func cellIdentifier()->String{
        return "NewsCell"
    }
    
    static func cellHeight()->CGFloat{
        return 80.0
    }
}
