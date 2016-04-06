
//  AppDelegate.swift
//  koalac_PPM
//
//  Created by 黄沩湘 on 15/6/8.
//  Copyright (c) 2015年 考拉先生. All rights reserved.
//

import UIKit
import AVFoundation


//推送
var jPushJump = (isJPJump:false, jPTitle:"" , jPURL:"")

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UITabBarControllerDelegate, WXApiDelegate,UIAlertViewDelegate {
    
    var window: UIWindow?
    var keyboard:UIKeyboardViewController = UIKeyboardViewController()
    private var mapManager:BMKMapManager = BMKMapManager()
    private var jumpToULR:String?
    private var jumpToWebTitle:String?
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        //企业版-友盟应用统计分析
        MobClick.startWithAppkey("566652dbe0f55a4e1b002714", reportPolicy: BATCH, channelId:"")
        let curLocalVersion =  ProjectManager.sharedInstance.getCurrentLocalVersion()
        MobClick.setAppVersion(String(curLocalVersion))
        
        self.keepNotCrash()
        //微信
        WXApiTool.sharedInstance.register()
        
        //        百度地图
        mapManager.start("hdxc24pPbhfCzl7m9fU5LPEX", generalDelegate: nil)
        
        //入口
        let lastAccount = LoginAccountTool.getLastLoginAccount()
        
        if self.isShowGuide() == true{
            let guideVC = GuideViewController(nibName:"GuideViewController",bundle:nil)
            self.window?.rootViewController = guideVC
        }else{
            
            if lastAccount.name.isEmpty{
                let vc = NoLoginViewController()
                let nav = UINavigationController(rootViewController: vc)
                self.window?.rootViewController = nav
                
                
            }else{
                let vc = NoLoginViewController()
                let nav = UINavigationController(rootViewController: vc)
                self.window?.rootViewController = nav
                let hud = MBProgressHUD.showHUDAddedTo(self.window!, animated: true)
                hud.labelText = "正在登录"
                ProjectManager.sharedInstance.autoLogin({ () -> () in
                    let mainVC = UIStoryboard(name: "Main", bundle: nil).instantiateInitialViewController() as! UITabBarController
                    mainVC.delegate = self
                    self.window?.rootViewController = mainVC
                    hud.hide(true)
                    }, failBlock: { () -> () in
                        let vc = NoLoginViewController()
                        let nav = UINavigationController(rootViewController: vc)
                        self.window?.rootViewController = nav
                        hud.hide(true)
                })
            }
        }

        // MARK: - ————————开启极光推送————————
        if #available(iOS 8.0, *) {
            //8.0之后
            APService.registerForRemoteNotificationTypes(UIUserNotificationType.Badge.rawValue |
                UIUserNotificationType.Sound.rawValue |
                UIUserNotificationType.Alert.rawValue,
                categories:nil)
        } else {
            // Fallback on earlier versions
            //8.0之前
            APService.registerForRemoteNotificationTypes(UIRemoteNotificationType.Badge.rawValue | UIRemoteNotificationType.Sound.rawValue | UIRemoteNotificationType.Alert.rawValue,
                categories:nil)
        }
        
        APService.setupWithOption(launchOptions)
        
        // MARK: - ————————开启环信推送————————
        var hxApnsCertName = ""
        #if DEBUG
            hxApnsCertName = "hxKoalacPPMDev"
        #else
            hxApnsCertName = "qiyeHXPro"
        #endif
        
        EaseMob.sharedInstance().registerSDKWithAppKey("koalacmr#koalacmerchant", apnsCertName: hxApnsCertName)
        if #available(iOS 8.0, *) {
            application.registerForRemoteNotifications()
            
        } else {
            application.registerForRemoteNotificationTypes(UIRemoteNotificationType([.Badge,.Alert,.Sound]))
        }
        
        if #available(iOS 8.0, *) {
            application.registerUserNotificationSettings(UIUserNotificationSettings(forTypes:[.Badge,.Sound ,.Alert], categories: nil))
            
        } else {
            
        }
        
        EaseMob.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
        
        return true
    }
    
    func keepNotCrash(){
        //因版本更新 数据存储结构不同 会引起crash(没有改变时不用添加)
        let documentPath = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true)[0]
        let accountPath = (documentPath as NSString).stringByAppendingPathComponent("account1.data")
        if NSFileManager.defaultManager().fileExistsAtPath(accountPath) == false {
            LoginAccountTool.clearLastLoginAccount()
            let beforePath = (documentPath as NSString).stringByAppendingPathComponent("account.data")
            do{
                try NSFileManager.defaultManager().removeItemAtPath(beforePath)
            }catch{
                
            }
        }
    }
    
    /**************************************/
     //推送
     /**************************************/
    func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
        
        // MARK: - ————————极光推送————————
        APService.registerDeviceToken(deviceToken)
        
        //推送tag；
        #if DEBUG
            let dispatcher_test: Set<String> = ["dispatcher_test"]
            APService.setTags(dispatcher_test, callbackSelector:Selector(), object:nil)
            
        #else
                        let dispatcher: Set<String> = ["dispatcher"]
                        APService.setTags(dispatcher, callbackSelector:Selector(), object:nil)
            
//            let dispatcher_test: Set<String> = ["dispatcher_test"]
//            APService.setTags(dispatcher_test, callbackSelector:Selector(), object:nil)
        #endif
        
        // MARK: - ————————环信推送————————
        EaseMob.sharedInstance().application(application, didRegisterForRemoteNotificationsWithDeviceToken: deviceToken)
        
    }
    
    func application(application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: NSError) {
        EaseMob.sharedInstance().application(application,didFailToRegisterForRemoteNotificationsWithError: error)
    }
    
    
    //MARK:点击推送通知
    func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject]) {
        if application.applicationState == UIApplicationState.Active {

            let dic = userInfo as! Dictionary<String,AnyObject>
            pprLog(dic)
            self.activeJPushCome(dic)
        }
        else if application.applicationState == UIApplicationState.Inactive {
            if LoginInfoModel.sharedInstance.m_auth.isEmpty {

            }else {
                let dic = userInfo as! Dictionary<String,AnyObject>
                self.remoteJPushClick(dic)
                if application.applicationIconBadgeNumber > 0{
                    application.applicationIconBadgeNumber = 0
                    APService.resetBadge()
                }
            }
        }
    }
    
    
    // MARK: 后台状态；
    func remoteJPushClick(dic: Dictionary <String,AnyObject>) {
        //HX点击
        pprLog(dic)
        let hxMessage = JsonDicHelper.getJsonDicValue(dic, key: "t")
        if hxMessage.isEmpty == false {
//            let newsDetailVC = NewsDetailViewController(nibName:"NewsDetailViewController",bundle:nil)
            let newsDetailVC = NewsDetailViewController()
            newsDetailVC.HXID = JsonDicHelper.getJsonDicValue(dic, key: "f")

            let hxid = JsonDicHelper.getJsonDicValue(dic, key: "t")
            let index = hxid.startIndex.advancedBy(3)
            let useid  = hxid.substringFromIndex(index)
            newsDetailVC.userId = useid
            let userDic = JsonDicHelper.getJsonDicDictionary(dic, key: "aps")
            let userText = JsonDicHelper.getJsonDicValue(userDic, key: "alert")
            let ee =   userText.componentsSeparatedByString(":")
            pprLog(ee)
            let userT = ee[0]
            newsDetailVC.title = userT

            newsDetailVC.hidesBottomBarWhenPushed = true
            let rootVC = ProjectManager.sharedInstance.getRootTab()
            pprLog(rootVC)
            rootVC.navigationController?.pushViewController(newsDetailVC, animated: false)
            
            return
        }
        
        let url = NetworkManager().baseUrl + JsonDicHelper.getJsonDicValue(dic,key: "url")
        let type = JsonDicHelper.getJsonDicValue(dic, key: "type")
        
        if type == "logout" {
            
            let rootVC = ProjectManager.sharedInstance.getRootTab()
            rootVC.selectedIndex = 3
            
            //            GShowAlertMessage("你的账号在其它手机上登录")
            //            ProjectManager.sharedInstance.checkHasLogin()
        } else {
            
            //            ProjectManager.sharedInstance.autoLogin()
            
            var pushVCTitle = ""
            let subType = JsonDicHelper.getJsonDicValue(dic,
                key: "subType")
            
            switch subType {
            case "passVerify":
                let rootVC = ProjectManager.sharedInstance.getRootTab()
                rootVC.selectedIndex = 3
                LoginInfoModel.sharedInstance.shopStatus = "1"
                
            case "notPassVerify":
                pprLog("审核不通过")
                LoginInfoModel.sharedInstance.shopStatus = "4"
                
            case "publishHeadline":
                self.JPushJumpTo("我要上头条", jumpURL: url)
                
            case "passVerifyHeadline":
                self.JPushJumpTo("我要上头条审核通过", jumpURL: url)
                
            case "publishSeckill":
                self.JPushJumpTo("秒杀", jumpURL: url)
            case "passVerifySeckill":
                self.JPushJumpTo("秒杀审核通过", jumpURL: url)
                //
            case "publishKmarket":
                self.JPushJumpTo("考拉集", jumpURL: url)
            case "passVerifyKmarket":
                self.JPushJumpTo("考拉集审核通过", jumpURL: url)
                
            case "publishHongBao":
                self.JPushJumpTo("抢红包", jumpURL: url)
                
            case "publishNotice":
                self.JPushJumpTo("公告", jumpURL: url)
                
            case "facePayOrder":
                let rootVC = ProjectManager.sharedInstance.getRootTab()
                jPushJump = (true,"" , "")
                rootVC.selectedIndex = 0
            case "newOrder":
                let rootVC = ProjectManager.sharedInstance.getRootTab()
                jPushJump = (true,"" , "")
                rootVC.selectedIndex = 0
            case "applyReturnGoods":
                let rootVC = ProjectManager.sharedInstance.getRootTab()
                jPushJump = (true,"" , "")
                rootVC.selectedIndex = 0
            case "WholesaleShipped":
                let rootVC = ProjectManager.sharedInstance.getRootTab()
                jPushJump = (true,"" , "")
                rootVC.selectedIndex = 0
            case "honesty":
                self.JPushJumpTo("我的记录", jumpURL: url)
            default:
                pushVCTitle = "未知消息详情"
                break
            }
        }
    }
    
    //后台跳转到H5；
    func JPushJumpTo(jumpTitle: String, jumpURL: String) {
        
        let rootVC = ProjectManager.sharedInstance.getRootTab()
        if rootVC.selectedIndex == 0{
            let webJPushVC = webHelper.openWebVC(jumpTitle, jumpURL:jumpURL)
            let mainVC = ProjectManager.sharedInstance.getTabSelectedNav()
            mainVC.pushViewController(webJPushVC, animated: true)
        }else{
            
            jPushJump = (true,jumpTitle , jumpURL)
            rootVC.selectedIndex = 0
        }
        
    }
    
    // MARK: 前台状态
    func activeJPushCome(dic: Dictionary <String,AnyObject>) {
        let url = NetworkManager().baseUrl + JsonDicHelper.getJsonDicValue(dic,
            key: "url")
        let type = JsonDicHelper.getJsonDicValue(dic,
            key: "type")
        
        if type == "logout" {
            // 尝试直接切换tabItem，进入已有的登录检测逻辑；
            ProjectManager.sharedInstance.checkHasLogin()
            
        } else {
            let subType = JsonDicHelper.getJsonDicValue(dic, key: "subType")
            if subType.isEmpty == false {
                let rootVC = ProjectManager.sharedInstance.getRootTab()
                let tabVC = rootVC as! MainTabViewController
                tabVC.newsVCRefresh()
            }
            
            switch subType {
            case "passVerify":
                GShowAlertMessage("恭喜，您的店铺已审核通过")
                let rootVC = ProjectManager.sharedInstance.getRootTab()
                rootVC.selectedIndex = 3
                LoginInfoModel.sharedInstance.shopStatus = "1"
                
            case "notPassVerify":
                GShowAlertMessage("很抱歉，您的店铺审核不通过")
                LoginInfoModel.sharedInstance.shopStatus = "4"
                
            case
            "publishHeadline","publishSeckill","publishKmarket","publishHongBao","publishNotice":
                pprLog("111")
                break
            case "passVerifyHeadline":
                jumpToWebTitle = "我要上头条审核通过"
                jumpToULR = url
                alertJPushJump("好消息",message: "您报名的我要上头条活动通过啦！")
            case "passVerifySeckill":
                jumpToWebTitle = "秒杀审核通过"
                jumpToULR = url
                alertJPushJump("好消息",message: "您报名的秒杀活动通过啦！")
            case "passVerifyKmarket":
                jumpToWebTitle = "考拉集审核通过"
                jumpToULR = url
                alertJPushJump("好消息",message: "您报名的考拉集活动通过啦！")
            case "facePayOrder":
                alertJPushJump("好消息",message: "当面付订单已收到")
                
                let aps = JsonDicHelper.getJsonDicDictionary(dic, key: "aps")
                let av = AVSpeechSynthesizer()
                let str = AVSpeechUtterance(string: aps["alert"]as! String)
                if #available(iOS 9.0, *) {
                    str.rate = AVSpeechUtteranceDefaultSpeechRate
                }else {
                    str.rate = AVSpeechUtteranceMinimumSpeechRate
                }
                av.speakUtterance(str)
                
            case "newOrder":
                alertJPushJump("提示",message: "您有一个新的订单")
                
                let aps = JsonDicHelper.getJsonDicDictionary(dic, key: "aps")
                let av = AVSpeechSynthesizer()
                let str = AVSpeechUtterance(string: aps["alert"]as! String)
                if #available(iOS 9.0, *) {
                    str.rate = AVSpeechUtteranceDefaultSpeechRate
                }else {
                    str.rate = AVSpeechUtteranceMinimumSpeechRate
                }
                av.speakUtterance(str)
                
            case "WholesaleShipped":
                let aps = JsonDicHelper.getJsonDicDictionary(dic, key: "aps")
                let messageStr = aps["alert"]as! String
                alertJPushJump("进货",message: messageStr)
                let av = AVSpeechSynthesizer()
                let str = AVSpeechUtterance(string:messageStr)
                if #available(iOS 9.0, *) {
                    str.rate = AVSpeechUtteranceDefaultSpeechRate
                }else {
                    str.rate = AVSpeechUtteranceMinimumSpeechRate
                }
                av.speakUtterance(str)
            case "honesty":
                
                self.JPushJumpTo("我的记录", jumpURL: url)
            default:
                pprLog("未知推送详情")
                break
            }
        }
    }
    
    //MARK:点击（环信转成）本地通知
    func application(application: UIApplication, didReceiveLocalNotification notification: UILocalNotification) {
        pprLog("本地通知")
        
        let rootVC = ProjectManager.sharedInstance.getRootTab()
        jPushJump = (true,"" , "")
        rootVC.selectedIndex = 0
        
        if let userInfoer = notification.userInfo{
            let userInfo = userInfoer as! Dictionary <String,AnyObject>
            pprLog(userInfo)
//            let newsDetailVC = NewsDetailViewController(nibName:"NewsDetailViewController",bundle:nil)
            let newsDetailVC = NewsDetailViewController()
            newsDetailVC.HXID = JsonDicHelper.getJsonDicValue(userInfo, key: "hxid")
            newsDetailVC.title = JsonDicHelper.getJsonDicValue(userInfo, key: "userName")
            newsDetailVC.userId = JsonDicHelper.getJsonDicValue(userInfo, key: "uid")
            newsDetailVC.hidesBottomBarWhenPushed = true
            let navVC = ProjectManager.sharedInstance.getTabSelectedNav()
            if navVC.viewControllers.count > 1 {
                navVC.popToRootViewControllerAnimated(false)
            }
            
            navVC.pushViewController(newsDetailVC, animated:false)
        }
        
    }
    
    func alertJPushJump(title:String, message:String){
        let alert = UIAlertView(title: title, message: message, delegate: self, cancelButtonTitle: "去看看", otherButtonTitles: "暂时不看")
        alert.show()
    }
    
    /**************************************/
     // MARK:- UITabBarControllerDelegate
     /**************************************/
    func tabBarController(tabBarController: UITabBarController, shouldSelectViewController viewController: UIViewController) -> Bool {
        return ProjectManager.sharedInstance.checkHasLogin()
    }
    
    /**************************************/
     //MARK:- 引导页显示
     /**************************************/
    private func isShowGuide()->Bool{
        var rtn = false
        let value = NSUserDefaults.standardUserDefaults().boolForKey("notFirstStart")
        if value == false{
            rtn = true
            NSUserDefaults.standardUserDefaults().setBool(true, forKey: "notFirstStart")
            NSUserDefaults.standardUserDefaults().synchronize()
        }else{
            rtn = false
        }
        return rtn
    }
    
    /**************************************/
     //微信分享 delegate
     /**************************************/
    
    func application(app: UIApplication, openURL url: NSURL, options: [String : AnyObject]) -> Bool {
        return WXApi.handleOpenURL(url, delegate: WXApiTool.sharedInstance)
    }
    
    func application(application: UIApplication, handleOpenURL url: NSURL) -> Bool {
        
        return WXApi.handleOpenURL(url, delegate: WXApiTool.sharedInstance)
    }
    
    func applicationWillResignActive(application: UIApplication) {
        //当应用即将后台时调用，停止一切调用opengl相关的操作
        BMKMapView.willBackGround()
        //        UIApplication.sharedApplication().cancelAllLocalNotifications()
        
    }
    
    func applicationDidEnterBackground(application: UIApplication) {
        
    }
    
    func applicationWillEnterForeground(application: UIApplication) {
        
    }
    
    func applicationDidBecomeActive(application: UIApplication) {
        
        //当应用恢复前台状态时调用，回复地图的渲染和opengl相关的操作
        BMKMapView.didForeGround()
        
    }
    
    func applicationWillTerminate(application: UIApplication) {
        
    }
    
    //MARK: - UIAlertViewDelegate
    func alertView(alertView: UIAlertView, clickedButtonAtIndex buttonIndex: Int) {
        let buttonStr = alertView.buttonTitleAtIndex(buttonIndex)
        if buttonStr == "去看看"{
            if alertView.title == "进货" {
                let rootVC = ProjectManager.sharedInstance.getRootTab()
                rootVC.selectedIndex = 0
            }
            
            if alertView.message == "您有一个新的订单"{
                
                let rootVC = ProjectManager.sharedInstance.getTabSelectedNav() 
                let orderVC = OrderViewController(nibName:"OrderViewController", bundle:nil)
                orderVC.hidesBottomBarWhenPushed = true
                //                orderVC.threeButton.selected = true
                
                rootVC.pushViewController(orderVC, animated: true)
                
            }else if alertView.message == "当面付订单已收到" {
                let rootVC = ProjectManager.sharedInstance.getRootTab()
                rootVC.selectedIndex = 0
                //            }else {
                //                self.JPushJumpToWeb(jumpToWebTitle!, jumpURL: jumpToULR!)
            }
        }
    }
    
}

