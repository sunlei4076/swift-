//
//  ActingShareView.swift
//  koalac_PPM
//
//  Created by seekey on 15/11/21.
//  Copyright (c) 2015年 koalac. All rights reserved.
//

import UIKit

class ActingShareView: UIView,UIAlertViewDelegate {

    @IBOutlet weak var shareTextLabel: UILabel!
    @IBOutlet weak var shareToWechatBtn: UIButton!
    @IBOutlet weak var shareToWechatPYQBtn: UIButton!
    
    var shareWebType = ""
    var shareWebURL = ""
    var shareTitle = ""
    var shareGoodData:ShopGoodModel?

    class func instantiateFromNib() -> ActingShareView {
        let view = UINib(nibName: "ActingShareView", bundle: nil).instantiateWithOwner(nil, options: nil).first as! ActingShareView
        
        return view
    }
    
    func actingShareViewShow(){
        self.initControl()
        self.initData()
    }
    
    private func initControl(){
        
        shareToWechatBtn.setTitleColor(GlobalStyleFontColor, forState: UIControlState.Normal)
        shareToWechatPYQBtn.setTitleColor(GlobalStyleFontColor, forState: UIControlState.Normal)
        let borderColor = UIColor(red: 236.0/255.0, green: 85.0/255.0, blue: 94.0/255.0, alpha: 1.0).CGColor
        shareToWechatBtn.layer.borderWidth = 1.0
        shareToWechatBtn.layer.borderColor = borderColor
        shareToWechatBtn.layer.cornerRadius = 5.0
        shareToWechatBtn.layer.masksToBounds = true;
        
        shareToWechatPYQBtn.layer.borderWidth = 1.0
        shareToWechatPYQBtn.layer.borderColor = borderColor
        shareToWechatPYQBtn.layer.cornerRadius = 5.0
        shareToWechatPYQBtn.layer.masksToBounds = true;
        
        self.shareTextLabel.font = GGetNormalCustomFont()
        self.shareTextLabel.textColor = GlobalStyleFontColor
        self.shareTextLabel.numberOfLines = 2
    }

    private func initData(){
        self.initShareData()
        //显示
        let window = UIApplication.sharedApplication().keyWindow
        self.frame = UIScreen.mainScreen().bounds
        window?.addSubview(self)
    }
    
    private func initShareData(){
        pprLog(self.shareWebType)
        pprLog(self.shareTitle)
        switch self.shareWebType {
            
        case "seckill":
            shareTitle = "我在考拉商圈做生意，参加秒杀帮你打造爆款，快来报名吧！"
        case "kmarket":
            shareTitle = "我在考拉商圈做生意，能进小区卖货的考拉集，快来报名吧！"
        case "headline":
            shareTitle = "我在考拉商圈做生意，不花钱印传单的上头条，快来报名吧！"
        case "get_coupon":
            shareTitle = "我在考拉商圈做生意，注册开店就有开店补贴，快来抢吧！"
        case "operate_analysis","我知道炫富不好，但是我就是忍不住啊！":
            shareTitle = "我知道炫富不好，但是我就是忍不住啊！"
        default:
            shareTitle = shareWebType.isEmpty ? "\(self.shareTitle)，我在考拉商圈开店" : shareWebType
            break
        }
        self.shareTextLabel.text = shareTitle
    }
    
    class func hide(){
        let window = UIApplication.sharedApplication().keyWindow
        for view in window!.subviews{
            if view.isKindOfClass(ActingShareView){
                view.removeFromSuperview()
            }
        }
    }
    
    func hide(){
        self.removeFromSuperview()
    }
    
    @IBAction func actionClose(sender: AnyObject) {
        self.hide()
    }


    @IBAction func actionShareToWechat(sender: AnyObject) {
        //店铺分享给微信好友
        //判断是否安装微信
        if WXApi.isWXAppInstalled() == false{
            GShowAlertMessage("请先下载安装微信客户端！")
            return
        }
        
        let message = WXMediaMessage()
        message.title = shareTitle
        message.description = "考拉商圈，专做社区生意！"
        if shareWebType == "operate_analysis" || shareWebType == "我知道炫富不好，但是我就是忍不住啊！" {
            message.setThumbImage(UIImage(imageLiteral: "shengyijing"))
        }
        else {
            message.setThumbImage(UIImage(imageLiteral: "shop_icon"))
        }
        
        let ext = WXWebpageObject()
        ext.webpageUrl = self.shareWebURL
        message.mediaObject = ext
        let req = SendMessageToWXReq()
        req.bText = false
        req.message = message
        req.scene = Int32(WXSceneSession.rawValue);
        WXApi.sendReq(req)
    }
    
    @IBAction func actionShareToWechatPYQ(sender: AnyObject) {
        //店铺分享给微信朋友圈
        //判断是否安装微信
        if WXApi.isWXAppInstalled() == false{
            GShowAlertMessage("请先下载安装微信客户端！")
            return
        }
        
        let message = WXMediaMessage()
        message.title = shareTitle
        
        if shareWebType == "operate_analysis" || shareWebType == "我知道炫富不好，但是我就是忍不住啊！" {
            message.setThumbImage(UIImage(imageLiteral: "shengyijing"))
        }
        else {
            message.setThumbImage(UIImage(imageLiteral: "shop_icon"))
        }
        
//        if let logoUrl = NSURL(string: self.shareImage){
//            if !String(logoUrl).isEmpty {
//                let imageData = NSData(contentsOfURL: logoUrl)
//                let image = UIImage(data: imageData!)
//                if image != nil{
//                    //设置图片大小不能超过32k，使用小图
//                    let smallImage = GFitSmallImage(image!, wantSize: CGSizeMake(60.0, 60.0), fitScale: true)
//                    message.setThumbImage(smallImage)
//                }
//            } else {
//                message.setThumbImage(UIImage(imageLiteral: "koalac_no_avatar"))
//            }
//        }
        
        let ext = WXWebpageObject()
        ext.webpageUrl = self.shareWebURL
        message.mediaObject = ext
        let req = SendMessageToWXReq()
        req.bText = false
        req.message = message
        req.scene = Int32(WXSceneTimeline.rawValue);
        WXApi.sendReq(req)
    }

}
