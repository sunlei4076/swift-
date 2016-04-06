//
//  LevelUpView.swift
//  KoalaBusinessDistrict
//
//  Created by liuny on 15/11/11.
//  Copyright © 2015年 koalac. All rights reserved.
//

import UIKit

class LevelUpView: UIView {

    @IBOutlet weak var levelProgress: UIProgressView!
    @IBOutlet weak var preLevelLabel: UILabel!
    @IBOutlet weak var nextLevelLabel: UILabel!
    @IBOutlet weak var levelUpInfoLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var leftButton: UIButton!
    @IBOutlet weak var rightButton: UIButton!
    
    private var rewordData:RewordModel = RewordModel()
    
    
    class func instantiateFromNib() -> LevelUpView {
        let nibs = UINib(nibName: "LevelUpView", bundle: nil).instantiateWithOwner(nil, options: nil)
        return nibs.first as! LevelUpView
    }

    func show(reword:RewordModel){
        self.rewordData = reword
        let window = UIApplication.sharedApplication().keyWindow
        self.frame = UIScreen.mainScreen().bounds
        window?.addSubview(self)
        self.initControl()
        self.initData()
    }
    
    private func initControl(){
        self.leftButton.layer.borderColor = GlobalStyleFontColor.CGColor
        self.rightButton.layer.borderColor = GlobalStyleFontColor.CGColor
        self.rightButton.layer.borderWidth = 1.0
        self.leftButton.layer.borderWidth = 1.0
        self.leftButton.layer.cornerRadius = 5.0
        self.rightButton.layer.cornerRadius = 5.0
        self.contentLabel.numberOfLines = 0
    }
    
    private func initData(){
        self.preLevelLabel.text = self.rewordData.preLevelName
        self.nextLevelLabel.text = self.rewordData.nextLevelName
        self.levelUpInfoLabel.text = "经验+\(self.rewordData.experienceGet) 积分+\(self.rewordData.pointsGet)"
        var content:String = ""
        for item in self.rewordData.creditRuleArray{
            content += item.message + "\n"
        }
        self.contentLabel.text = content
        
        let preLevel:Float = Float(self.rewordData.preLevelExperience)!
        let nextLevel:Float = Float(self.rewordData.nextLevelExperience)!
        let currExperience:Float = Float(self.rewordData.experienceTotal)!
        self.levelProgress.progress = (currExperience - preLevel)/(nextLevel - preLevel)
        self.addProgressValueView()
    }
    
    private func addProgressValueView(){
        let label = UILabel()
        label.font = UIFont.systemFontOfSize(12)
        label.textColor = UIColor.whiteColor()
        label.frame = CGRectMake(0, 0, 30, 18)
        label.backgroundColor = GlobalStyleFontColor
        label.textAlignment = NSTextAlignment.Center
        label.text = "\(Int(self.levelProgress.progress*100))%"
        self.levelProgress.superview?.addSubview(label)
        
        let screenWidth = UIScreen.mainScreen().bounds.size.width
        let progressWith = screenWidth-100
        let progressFrame = self.levelProgress.frame
        var centerPoint = CGPointZero
        centerPoint.y = CGRectGetMidY(progressFrame)
        centerPoint.x = progressFrame.origin.x + CGFloat(self.levelProgress.progress)*progressWith
        
        if centerPoint.x < 15{
            centerPoint.x += 15
        }
        
        if centerPoint.x > (progressWith-15){
            centerPoint.x -= 15
        }
        
        label.center = centerPoint
    }
    
    private func share(shareType:Bool){
        //判断是否安装微信
        if WXApi.isWXAppInstalled() == false{
            GShowAlertMessage("请先下载安装微信客户端！")
            return
        }
        
        let message = WXMediaMessage()
        message.title = "狂送1000万，手机开店干不干？"
        message.description = "马上开启考拉商圈，邻居都在买！"
        message.setThumbImage(UIImage(named: "LevleUp_ShareIcon"))
        
        if self.rewordData.creditRuleArray.count > 0{
            let url = self.rewordData.creditRuleArray[0].downloadUrl
            let ext = WXWebpageObject()
            ext.webpageUrl = url
            message.mediaObject = ext
        }
        
        let req = SendMessageToWXReq()
        req.bText = false
        req.message = message
        if shareType == true{
            //微信朋友圈
            req.scene = Int32(WXSceneTimeline.rawValue);
        }else{
            //微信好友
            req.scene = Int32(WXSceneSession.rawValue);
        }
        
        WXApi.sendReq(req)
    }
    
    @IBAction func closeAction(sender: AnyObject) {
        //版本检查
         ProjectManager.sharedInstance.versionCheck()
        self.removeFromSuperview()
    }
    
    @IBAction func shareToFriendAction(sender: AnyObject) {
         ProjectManager.sharedInstance.versionCheck()
        self.share(false)
        self.removeFromSuperview()
    }
    
    @IBAction func shareToPYQAction(sender: AnyObject) {
         ProjectManager.sharedInstance.versionCheck()
        self.share(true)
        self.removeFromSuperview()
    }
}
