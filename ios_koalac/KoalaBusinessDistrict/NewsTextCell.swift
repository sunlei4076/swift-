//
//  NewsTextCell.swift
//  koalac_PPM
//
//  Created by liuny on 15/8/13.
//  Copyright (c) 2015年 考拉先生. All rights reserved.
//

import UIKit

class NewsTextCell: UITableViewCell {

    
    @IBOutlet weak var contentBG: UIImageView!
    @IBOutlet weak var messageContent: UILabel!
    @IBOutlet weak var userHeadIcon: UIImageView!
    
    @IBOutlet weak var timeLabel: UILabel!
    //头像回调
    var headIconBlock:(()->())?
    var cellData:NewsDetailModel = NewsDetailModel(){
        didSet{
            self.timeLabel.text = self.cellData.messageTime
//                GTimeSecondToSting(self.cellData.messageTime, format: "yyyy-MM-dd")
            self.userHeadIcon.setImageWithURL(NSURL(string: self.cellData.userHeadIcon)!, placeholderImage: UIImage(named: "PlaceHolder"))
            self.messageContent.text = self.cellData.messageContent

            
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
        self.messageContent.font = GGetNormalCustomFont()
        self.messageContent.numberOfLines = 0
        let screenWidth = UIScreen.mainScreen().bounds.width
        self.messageContent.preferredMaxLayoutWidth = screenWidth - 50 - 90;
        self.timeLabel.font = GGetCustomFontWithSize(12)
//        let bgImage = UIImage(named: "News_MessageBG")
//        self.contentBG.image = bgImage?.stretchableImageWithLeftCapWidth(50, topCapHeight: 30)
        
        let bgImage = UIImage(named:"leftHX")
        self.contentBG.image = bgImage?.stretchableImageWithLeftCapWidth(15, topCapHeight: 30)

        self.userHeadIcon.userInteractionEnabled = true
        let tapLogic: UITapGestureRecognizer = UITapGestureRecognizer.init(target: self, action: "logicTapAction")
        self.userHeadIcon.addGestureRecognizer(tapLogic)
    }

    func logicTapAction() {
        //回调闭包
        self.headIconBlock!()


    }
    static func cellIdentifier()->String{
        return "NewsTextCell"
    }
}
