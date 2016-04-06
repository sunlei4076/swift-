//
//  InviteOpenStoreViewController.swift
//  
//
//  Created by seekey on 15/10/14.
//
//

import UIKit

class InviteOpenStoreViewController: UIViewController {
    
    @IBOutlet weak var inviteQrcodeImageView: UIImageView!
    
    var inviteQrcodeURL: String = ""

    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.initControl()
        
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    private func initControl(){
        self.title = "邀请开店"
        //back
        let backBtn = GNavigationBack()
        backBtn.addTarget(self, action:Selector("backAction"), forControlEvents: UIControlEvents.TouchUpInside)
        let backItem = UIBarButtonItem(customView: backBtn)
        self.navigationItem.leftBarButtonItem = backItem
        
        self.view.backgroundColor = GlobalBgColor
        
        //设置字体
        GSetFontInView(self.view, font: GGetNormalCustomFont())
//        self.showDrawalMoneyLabel.font = GGetCustomFontWithSize(GBigFontSize+2.0)
//        self.showUndrawalMoneyLabel.font = GGetCustomFontWithSize(GBigFontSize+4.0)
        
        //邀请二维码；
        self.inviteQrcodeURL = LoginInfoModel.sharedInstance.store.inviteOpenStoreURL
        pprLog("\(self.inviteQrcodeURL)")
        let image = QRCodeGenerator.qrImageForString(self.inviteQrcodeURL, imageSize: self.inviteQrcodeImageView.bounds.size.width)
        self.inviteQrcodeImageView.image = image
    }

    func backAction(){
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    @IBAction func actionShareCopy(sender: AnyObject) {
        let pasteboard = UIPasteboard.generalPasteboard()
        pasteboard.string = self.inviteQrcodeURL;
//        self.hide()
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
        message.title = "狂送1000万，手机开店干不干？"
        message.description = "马上开启考拉商圈，邻居都在买！"
        message.setThumbImage(UIImage(named: "do_notdo"))
        
        let ext = WXWebpageObject()
        ext.webpageUrl = self.inviteQrcodeURL
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
        message.title = "狂送1000万，手机开店干不干？"
        message.description = "马上开启考拉商圈，邻居都在买！"
        message.setThumbImage(UIImage(named: "do_notdo"))
        
        let ext = WXWebpageObject()
        ext.webpageUrl = self.inviteQrcodeURL
        message.mediaObject = ext
        let req = SendMessageToWXReq()
        req.bText = false
        req.message = message
        req.scene = Int32(WXSceneSession.rawValue);
        WXApi.sendReq(req)
        
    }
    
//    func hide(){
//        self.removeFromSuperview()
//    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
