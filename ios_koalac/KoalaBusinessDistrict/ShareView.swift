//
//  ShareView.swift
//  koalac_PPM
//
//  Created by liuny on 15/8/13.
//  Copyright (c) 2015年 考拉先生. All rights reserved.
//

import UIKit

class ShareView: UIView,UIAlertViewDelegate {

    @IBOutlet weak var qrcodeImageView: UIImageView!
    @IBOutlet weak var qrcodeView: UIView!
    @IBOutlet weak var shopNameLabel: UILabel!
    @IBOutlet weak var bordView: UIView!
    
    var shareGoodData:ShopGoodModel?
    private var qrcodeUrl:String = ""
    private var buttonShareUrl:String = ""
    private var title:String = ""
    private var shareImage:String = ""
    
    private func initControl(){
        self.bordView.layer.cornerRadius = 3.0
        self.bordView.layer.masksToBounds = true;
        self.shopNameLabel.font = GGetNormalCustomFont()
        self.shopNameLabel.textColor = GlobalStyleFontColor
    }

    private func checkShopStatus()->Bool{
        var canGoIn = true
        let statusInt = (LoginInfoModel.sharedInstance.shopStatus as NSString).integerValue
        switch statusInt{
        case -1:
            //未开店
            canGoIn = false
            //弹出提交店铺页面
            let popover = OpenShopPopover.instantiateFromNib()
            popover.show({ () -> () in
                let register = RegisterInfoViewController(nibName:"RegisterInfoViewController", bundle:nil)
                register.hidesBottomBarWhenPushed = true
                let navVC = ProjectManager.sharedInstance.getTabSelectedNav()
                navVC.pushViewController(register, animated: true)
            })
            break
        case 0:
            //待审核
            canGoIn = false
            let alert = UIAlertView(title: "提示", message: "亲，您的店铺正在审核中", delegate: self, cancelButtonTitle: "确定", otherButtonTitles: "联系客服")
            
            alert.show()
            break
        case 1:
            //审核通过
            canGoIn = true
            break
        case 2:
            //已关闭
            canGoIn = false
            GShowAlertMessage("您的店铺已关闭！")
            break
        default:
            break
        }
        return canGoIn
    }
    
    private func initShareData(){
        if(self.shareGoodData != nil){
            self.title = self.shareGoodData!.goods_name
            self.qrcodeUrl = self.shareGoodData!.qrcode_goods_url
            self.buttonShareUrl = self.shareGoodData!.qrcode_goods_url
            self.shareImage = self.shareGoodData!.default_image
        }else{
            let loginUser = LoginInfoModel.sharedInstance
            self.title = loginUser.store.store_name
            self.qrcodeUrl = loginUser.store.qrcode_store_url
            self.buttonShareUrl = loginUser.store.store_url
            self.shareImage = loginUser.store.store_logo
        }
        self.shopNameLabel.text = self.title
        let image = QRCodeGenerator.qrImageForString(self.qrcodeUrl, imageSize: self.qrcodeView.bounds.size.width)
        self.qrcodeImageView.image = image
    }
    
    private func initData(){
        if ProjectManager.sharedInstance.checkHasLogin() == true{
            let statusInt = (LoginInfoModel.sharedInstance.shopStatus as NSString).integerValue
            if statusInt == 1{
                //已开店
                self.initShareData()
                //显示
                let window = UIApplication.sharedApplication().keyWindow
                self.frame = UIScreen.mainScreen().bounds
                window?.addSubview(self)
            }else{
                NetworkManager.sharedInstance.requestShopStatus({ (jsonDic:AnyObject) -> () in
                    let dic = jsonDic as! Dictionary<String,AnyObject>
                    let dataDic = JsonDicHelper.getJsonDicDictionary(dic, key: "data")
                    let objDic = JsonDicHelper.getJsonDicDictionary(dataDic, key: "obj")
                    let status = JsonDicHelper.getJsonDicValue(objDic, key: "status")
                    if status.isEmpty == true{
                        LoginInfoModel.sharedInstance.shopStatus = "-1"
                    }else{
                        LoginInfoModel.sharedInstance.shopStatus = status
                    }
                    
                    if self.checkShopStatus() == true {
                        self.initShareData()
                        //显示
                        let window = UIApplication.sharedApplication().keyWindow
                        self.frame = UIScreen.mainScreen().bounds
                        window?.addSubview(self)
                    }
                    }, fail: { (error:String, needRelogin:Bool) -> () in
                    
                })
            }
        }
    }
    class func instantiateFromNib() -> ShareView {
        let view = UINib(nibName: "ShareView", bundle: nil).instantiateWithOwner(nil, options: nil).first as! ShareView
        
        return view
    }
    
    class func hide(){
        let window = UIApplication.sharedApplication().keyWindow
        for view in window!.subviews{
            if view.isKindOfClass(ShareView){
                view.removeFromSuperview()
            }
        }
    }
    
    func show(){
        self.initControl()
        self.initData()
    }
    
    func hide(){
        self.removeFromSuperview()
    }
    
    @IBAction func actionClose(sender: AnyObject) {
        self.hide()
    }
    @IBAction func actionShareCopy(sender: AnyObject) {
        //复制链接
        let pasteboard = UIPasteboard.generalPasteboard()
        pasteboard.string = self.buttonShareUrl;
        self.hide()
        GShowAlertMessage("店铺链接复制成功！")
    }
    @IBAction func actionShareWechatPYQ(sender: AnyObject) {
        //店铺分享给微信朋友圈
        //判断是否安装微信
        if WXApi.isWXAppInstalled() == false{
            GShowAlertMessage("请先下载安装微信客户端！")
            return
        }
        
        let message = WXMediaMessage()
        if self.shareGoodData == nil{
            message.title = "\(self.title)小店，欢迎各位亲光临~"
//            message.title = "光临\(self.title)小店，每个邻居送10元！"
        }else{
            message.title = self.title
            message.description = self.shareGoodData!.goodDescription
            pprLog(message.description)
        }
        
        if let logoUrl = NSURL(string: self.shareImage){
            if !String(logoUrl).isEmpty {
                let imageData = NSData(contentsOfURL: logoUrl)
                let image = UIImage(data: imageData!)
                if image != nil{
                    //设置图片大小不能超过32k，使用小图
                    let smallImage = GFitSmallImage(image!, wantSize: CGSizeMake(60.0, 60.0), fitScale: true)
                    message.setThumbImage(smallImage)
                }
            } else {
                message.setThumbImage(UIImage(imageLiteral: "koalac_no_avatar"))
            }
        }
        
        let ext = WXWebpageObject()
        ext.webpageUrl = self.buttonShareUrl
        message.mediaObject = ext
        let req = SendMessageToWXReq()
        req.bText = false
        req.message = message
        req.scene = Int32(WXSceneTimeline.rawValue);
        WXApi.sendReq(req)
    }
    @IBAction func actionShareWechat(sender: AnyObject) {
        //店铺分享给微信好友
        //判断是否安装微信
        if WXApi.isWXAppInstalled() == false{
            GShowAlertMessage("请先下载安装微信客户端！")
            return
        }
        
        let message = WXMediaMessage()
        if self.shareGoodData == nil{
//            message.title = "\(self.title)小店，欢迎各位亲光临~"
            message.title = "光临\(self.title)小店，每个邻居送10元！"
            if LoginInfoModel.sharedInstance.store.description_t.isEmpty
            {
                message.description = "考拉商圈，专做社区生意！"
            }else{
                message.description = LoginInfoModel.sharedInstance.store.description_t
            }

        }else{
            message.title = self.title
            message.description = self.shareGoodData!.goodDescription
        }
        
        if let logoUrl = NSURL(string: self.shareImage){
            if !String(logoUrl).isEmpty {
                let imageData = NSData(contentsOfURL: logoUrl)
                let image = UIImage(data: imageData!)
                if image != nil{
                    //设置图片大小不能超过32k，使用小图
                    let smallImage = GFitSmallImage(image!, wantSize: CGSizeMake(60.0, 60.0), fitScale: true)
                    message.setThumbImage(smallImage)
                }
            } else {
                message.setThumbImage(UIImage(imageLiteral: "koalac_no_avatar"))
            }
        }
        
        let ext = WXWebpageObject()
        ext.webpageUrl = self.buttonShareUrl
        message.mediaObject = ext
        let req = SendMessageToWXReq()
        req.bText = false
        req.message = message
        req.scene = Int32(WXSceneSession.rawValue);
        WXApi.sendReq(req)
    }
    
    func alertView(alertView: UIAlertView, clickedButtonAtIndex buttonIndex: Int){
        
        if(buttonIndex == 1){
            
            UIApplication.sharedApplication().openURL(NSURL(string: "tel://4000588577")!)
        }
        
    }
}
