//
//  NewsDetailCell.swift
//  koalac_PPM
//
//  Created by liuny on 15/7/6.
//  Copyright (c) 2015年 考拉先生. All rights reserved.
//

import UIKit
class NewsDetailCell: UITableViewCell {

    @IBOutlet weak var newsLabel: UILabel!
    @IBOutlet weak var goodNameLabel: UILabel!
    @IBOutlet weak var goodImageView: UIImageView!
    @IBOutlet weak var userHeadIcon: UIImageView!
    
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var backBg: UIImageView!
    //头像回调
    var headIconDetailsBlock:(()->())?
    var cellData:NewsDetailModel = NewsDetailModel() {
        didSet{

                if cellData.hx_ext?.hx_msg_type == "orderpayed" || cellData.hx_ext?.hx_msg_type == "orderconfirm"||cellData.hx_ext?.hx_msg_type == "orderrefund" {  //订单支付通知

                     self.timeLabel.text = self.cellData.messageTime
//                        GTimeSecondToSting(self.cellData.messageTime, format: "yyyy-MM-dd")
                    self.newsLabel.text = cellData.messageContent
                    self.userHeadIcon.setImageWithURL(NSURL(string: (self.cellData.hx_ext?.hx_avator)!)!, placeholderImage: UIImage(named: "PlaceHolder"))
                    self.goodImageView.setImageWithURL(NSURL(string: (self.cellData.hx_ext?.hx_goods_image)!)!, placeholderImage: UIImage(named: "PlaceHolder"))
                    self.goodNameLabel.text = cellData.hx_ext?.hx_goods_name

                }else if cellData.hx_ext?.hx_msg_type == "order" {  //发送订单

                     self.timeLabel.text = self.cellData.messageTime
//                        GTimeSecondToSting(self.cellData.messageTime, format: "yyyy-MM-dd")
                    self.newsLabel.text = cellData.messageContent
                    self.userHeadIcon.setImageWithURL(NSURL(string: (self.cellData.hx_ext?.hx_avator)!)!, placeholderImage: UIImage(named: "PlaceHolder"))
                    self.goodImageView.setImageWithURL(NSURL(string: (self.cellData.hx_ext?.hx_order_image)!)!, placeholderImage: UIImage(named: "PlaceHolder"))
                    self.goodNameLabel.text = cellData.hx_ext?.hx_goods_name

                }else if cellData.hx_ext?.hx_msg_type == "goods" || cellData.hx_ext?.hx_msg_type == "ordercommented" {  //发送商品

                     self.timeLabel.text = self.cellData.messageTime
//                        GTimeSecondToSting(self.cellData.messageTime, format: "yyyy-MM-dd")
                    self.newsLabel.text = cellData.messageContent
                    self.userHeadIcon.setImageWithURL(NSURL(string: (self.cellData.hx_ext?.hx_avator)!)!, placeholderImage: UIImage(named: "PlaceHolder"))
                    self.goodNameLabel.text = cellData.hx_ext?.hx_goods_name
                    self.goodImageView.setImageWithURL(NSURL(string: (self.cellData.hx_ext?.hx_goods_image)!)!, placeholderImage: UIImage(named: "PlaceHolder"))


                }else if cellData.hx_ext?.hx_msg_type == "zhushou"{
                    self.timeLabel.text = self.cellData.messageTime
                    self.newsLabel.text = cellData.messageContent
                    self.userHeadIcon.setImageWithURL(NSURL(string: (self.cellData.hx_ext?.hx_avator)!)!, placeholderImage: UIImage(named: "PlaceHolder"))
                    self.goodNameLabel.text = cellData.hx_ext?.hx_description
                    self.goodImageView.setImageWithURL(NSURL(string: (self.cellData.hx_ext?.hx_imageurl)!)!, placeholderImage: UIImage(named: "PlaceHolder"))

                }else if cellData.hx_ext?.hx_msg_type == "shangji" {
                    self.timeLabel.text = self.cellData.messageTime
                    self.newsLabel.text = cellData.messageContent
                    self.userHeadIcon.setImageWithURL(NSURL(string: (self.cellData.hx_ext?.hx_avator)!)!, placeholderImage: UIImage(named: "PlaceHolder"))
                    self.goodNameLabel.text = cellData.hx_ext?.hx_description
                    self.goodImageView.setImageWithURL(NSURL(string: (self.cellData.hx_ext?.hx_imageurl)!)!, placeholderImage: UIImage(named: "PlaceHolder"))

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
        self.newsLabel.font = GGetNormalCustomFont()
        self.goodNameLabel.font = GGetNormalCustomFont()
        self.newsLabel.numberOfLines = 0
        self.goodNameLabel.numberOfLines = 0
        self.timeLabel.font = GGetCustomFontWithSize(12)
        let bgImage = UIImage(named: "News_MessageBG")
        self.backBg.image = bgImage?.stretchableImageWithLeftCapWidth(50, topCapHeight: 30)

         self.userHeadIcon.userInteractionEnabled = true
        let tapLogic: UITapGestureRecognizer = UITapGestureRecognizer.init(target: self, action: "logicTapAction")
        self.userHeadIcon.addGestureRecognizer(tapLogic)

    }
    func logicTapAction(){

        self.headIconDetailsBlock!()
    }
    static func cellIdentifier()->String{
        return "NewsDetailCell"
    }
    
    static func cellHeight()->CGFloat{
        return 150.0
    }
}
