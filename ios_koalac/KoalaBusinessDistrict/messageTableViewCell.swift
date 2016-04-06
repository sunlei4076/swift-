//
//  messageTableViewCell.swift
//  KoalaBusinessDistrict
//
//  Created by seekey on 15/12/7.
//  Copyright © 2015年 koalac. All rights reserved.
//

import UIKit

class messageTableViewCell: UITableViewCell {
    //图片
    @IBOutlet weak var contentBG1: UIImageView!
    @IBOutlet weak var messageContent1: UILabel!
    @IBOutlet weak var userHeadIcon1: UIImageView!
    @IBOutlet weak var timeLabel1: UILabel!
    
    var cellData1:NewsDetailModel = NewsDetailModel(){
        didSet{
            
            self.timeLabel1.text = self.cellData1.messageTime
//                GTimeSecondToSting(self.cellData1.messageTime, format: "yyyy-MM-dd")
            self.userHeadIcon1.setImageWithURL(NSURL(string: LoginInfoModel.sharedInstance.avatar)!, placeholderImage: UIImage(named: "koalac_no_avatar"))
            self.messageContent1.text = self.cellData1.messageContent;
            
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
        self.messageContent1.font = GGetNormalCustomFont()
        self.messageContent1.numberOfLines = 0
        let screenWidth = UIScreen.mainScreen().bounds.width
        self.messageContent1.preferredMaxLayoutWidth = screenWidth - 90 - 50
        self.timeLabel1.font = GGetCustomFontWithSize(12)
        self.messageContent1.textColor = UIColor(red: 34/255.0, green: 34/255.0, blue: 34/255.0, alpha: 0.9)


         let bgImage = UIImage(named:"right_backGroud_hx")
//        self.contentBG1.image = bgImage?.stretchableImageWithLeftCapWidth(50, topCapHeight: 30)
          self.contentBG1.image = bgImage?.stretchableImageWithLeftCapWidth(12, topCapHeight: 28)
    }
    
    static func cellIdentifier()->String{
        return "NewsTaerCell"
    }
}
