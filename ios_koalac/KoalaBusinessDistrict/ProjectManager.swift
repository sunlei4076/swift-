//
//  ProjectManager.swift
//  KoalaBusinessDistrict
//
//  Created by liuny on 15/8/24.
//  Copyright (c) 2015年 koalac. All rights reserved.
//

import UIKit

class ProjectManager: NSObject,UIAlertViewDelegate {
    
    /****/
    var is_select_goods:String = ""
    var orderID:String = ""
    /****/
    
    var currLocate:BMKReverseGeoCodeResult?
    let versionAlert:UIAlertView = UIAlertView()
    private var appStoreTrackUrl = ""
    //dispatch_once单例
    class var sharedInstance : ProjectManager {
        struct Static {
            static var onceToken : dispatch_once_t = 0
            static var instance : ProjectManager? = nil
        }
        dispatch_once(&Static.onceToken) {
            Static.instance = ProjectManager()
        }
        return Static.instance!
    }
    
    //自动登录
    func autoLogin(successBlock:()->(),failBlock:()->()){
        let lastAccount = LoginAccountTool.getLastLoginAccount()
        if lastAccount.name.isEmpty{
            //没有上次登录记录
            failBlock()//自动登录失败
        }else{
            if lastAccount.isWXLogin == true{
                //上次是微信授权登录
                NetworkManager.sharedInstance.requestWXLogin(lastAccount.openid, unionid: lastAccount.unionid, headimgurl: lastAccount.headUrl, nickname: lastAccount.name, success: { (jsonDic:AnyObject) -> () in
                    let dic = jsonDic as! Dictionary<String, AnyObject>
                    let dataDic = JsonDicHelper.getJsonDicDictionary(dic, key: "data")
                    let objDic = JsonDicHelper.getJsonDicDictionary(dataDic, key: "obj")
                    LoginInfoModel.sharedInstance.setDataWithJson(objDic)
                    //极光推送设置别名
                    //字符串转浮点型后再转整型，后转字符串；
                    let uidFt = (LoginInfoModel.sharedInstance.uid as NSString).floatValue
                    let uidInt = Int(uidFt)
                    let uid = String(uidInt)
                    APService.setAlias(uid, callbackSelector:Selector(), object: nil)
                    //环信
                    self.loginToHX({ () -> () in
                        //环信登录成功
                        successBlock()//自动登录成功
                    })
                    }, fail: { (error:String, needRelogin:Bool) -> () in
                        GShowAlertMessage(error)
                        failBlock()//自动登录失败
                })
            }else{
                //普通账号登录
                NetworkManager.sharedInstance.requestLogin(lastAccount.name, password: lastAccount.password, success: { (jsonDic:AnyObject) -> () in
                    let dic = jsonDic as! Dictionary<String, AnyObject>
                    let dataDic = JsonDicHelper.getJsonDicDictionary(dic, key: "data")
                    let objDic = JsonDicHelper.getJsonDicDictionary(dataDic, key: "obj")
                    LoginInfoModel.sharedInstance.setDataWithJson(objDic)
                    //极光推送设置别名
                    //字符串转浮点型后再转整型，后转字符串；
                    let uidFt = (LoginInfoModel.sharedInstance.uid as NSString).floatValue
                    let uidInt = Int(uidFt)
                    let uid = String(uidInt)
                    
                    APService.setAlias(uid, callbackSelector:Selector(), object: nil)
                    
                    //环信
                    self.loginToHX({ () -> () in
                        //环信登录成功
                        successBlock()//自动登录成功
                    })
                    }, fail: { (error:String, needRelogin:Bool) -> () in
                        GShowAlertMessage(error)
                        failBlock()//自动登录失败
                })
            }
        }
    }
    
    
    
    
    
    //    func autoLogin()->Bool{
    //        let lastAccount = LoginAccountTool.getLastLoginAccount()
    //        if lastAccount.name.isEmpty{
    //            //没有上次登录记录
    //            NSNotificationCenter.defaultCenter().postNotificationName("ChangeLogin", object: self)
    //            return false
    //        }else{
    //            if lastAccount.isWXLogin == true{
    //                //上次是微信授权登录
    //                NetworkManager.sharedInstance.requestWXLogin(lastAccount.openid, unionid: lastAccount.unionid, headimgurl: lastAccount.headUrl, nickname: lastAccount.name, success: { (jsonDic:AnyObject) -> () in
    //                    let dic = jsonDic as! Dictionary<String, AnyObject>
    //                    let dataDic = JsonDicHelper.getJsonDicDictionary(dic, key: "data")
    //                    let objDic = JsonDicHelper.getJsonDicDictionary(dataDic, key: "obj")
    //
    //                    LoginInfoModel.sharedInstance.setDataWithJson(objDic)
    //
    //                    //极光推送设置别名
    //                   //字符串转浮点型后再转整型，后转字符串；
    //                    let uidFt = (LoginInfoModel.sharedInstance.uid as NSString).floatValue
    //                    let uidInt = Int(uidFt)
    //                    let uid = String(uidInt)
    //                    APService.setAlias(uid, callbackSelector:Selector(), object: nil)
    ////                    pprLog(uid)
    //
    //                    //环信
    //                    self.loginToHX({ () -> () in
    //                        //环信登录成功
    //                    })
    //
    ////                    NSNotificationCenter.defaultCenter().postNotificationName("ChangeLogin", object: self)
    //                    }, fail: { (error:String, needRelogin:Bool) -> () in
    //                        GShowAlertMessage(error)
    //                })
    //            }else{
    //                //普通账号登录
    //                NetworkManager.sharedInstance.requestLogin(lastAccount.name, password: lastAccount.password, success: { (jsonDic:AnyObject) -> () in
    //                    let dic = jsonDic as! Dictionary<String, AnyObject>
    //                    let dataDic = JsonDicHelper.getJsonDicDictionary(dic, key: "data")
    //                    let objDic = JsonDicHelper.getJsonDicDictionary(dataDic, key: "obj")
    //                    LoginInfoModel.sharedInstance.setDataWithJson(objDic)
    //
    //                    //极光推送设置别名
    //                    //字符串转浮点型后再转整型，后转字符串；
    //                    let uidFt = (LoginInfoModel.sharedInstance.uid as NSString).floatValue
    //                    let uidInt = Int(uidFt)
    //                    let uid = String(uidInt)
    //
    //                    APService.setAlias(uid, callbackSelector:Selector(), object: nil)
    //
    //                    //环信
    //                    self.loginToHX({ () -> () in
    //                        //环信登录成功
    //                    })
    //
    ////                    NSNotificationCenter.defaultCenter().postNotificationName("ChangeLogin", object: self)
    //                    }, fail: { (error:String, needRelogin:Bool) -> () in
    //                    GShowAlertMessage(error)
    //                })
    //            }
    //            return true
    //        }
    //    }
    
    // MARK: - ————————判断是否登录————————
    func checkHasLogin()->Bool{
        
        if LoginInfoModel.sharedInstance.m_auth.isEmpty{
            let app:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            let rootVC = app.window?.rootViewController
            
            pprLog(rootVC!)
            let loginVC = LoginViewController(nibName:"LoginViewController", bundle:nil)
            //更新登陆界面1202
            loginVC.view.backgroundColor = UIColor(red: 1/255.0, green: 1/255.0, blue: 1/255.0, alpha: 0.6)
            
            //MARK : - 如果未登录时,windowRootViewController 是NoLoginViewController那么下面的方法在切换帐号时,NoLoginViewController 页面cell 点击没有反应
            //              rootVC?.presentViewController(loginVC, animated: true, completion: nil)
            
            if rootVC!.isKindOfClass(MainTabViewController) {
                
                UIApplication.sharedApplication().keyWindow?.rootViewController?.presentedViewController?.presentViewController(loginVC, animated: true, completion: nil)
                
            }else{
                
                rootVC?.presentViewController(loginVC, animated: true, completion: nil)
                
            }
            return false
        }else{
            return true
        }
    }
    
    //拼接环信帐号登录
    internal func loginToHX(successBlock:()->()) {
        let hxAccount = "lq_" + LoginInfoModel.sharedInstance.uid
        let hxPas = "hx_123456"
        EaseMob.sharedInstance().chatManager.asyncLoginWithUsername(hxAccount, password: hxPas, completion: {loginInfo,error in
            if(error == nil){
                //环信登录成功
                successBlock()
                let optionsPushNotifi = EaseMob.sharedInstance().chatManager.pushNotificationOptions
                optionsPushNotifi.displayStyle = EMPushNotificationDisplayStyle.ePushNotificationDisplayStyle_messageSummary
                EaseMob.sharedInstance().chatManager.asyncUpdatePushOptions(optionsPushNotifi)
            }else {
                //环信登录失败
                self.loginToHXKoalac({ () -> () in
                    successBlock()
                })
            }
            }, onQueue: nil)
    }
    
    
    
    //后台获取环信帐号登录
    internal func loginToHXKoalac(successBlock:()->()) {
        NetworkManager.sharedInstance.requestGetHXAccount({ (jsonDic:AnyObject) -> () in
            let dic = jsonDic as! Dictionary<String, AnyObject>
            let objHXDic = JsonDicHelper.getJsonDicDictionary(dic, key: "obj")
            HXMessageModel.sharedHXInstance.setHXDataWithJson(objHXDic)
//            let hxAccount = HXMessageModel.sharedHXInstance.hxUsername
            let hxAccount = "lq_" + LoginInfoModel.sharedInstance.uid
            let hxPas = "hx_123456"
            EaseMob.sharedInstance().chatManager.asyncLoginWithUsername(hxAccount, password: hxPas, completion: {loginInfo,error in
                if(error == nil){
                    successBlock()
                    let optionsPushNotifi = EaseMob.sharedInstance().chatManager.pushNotificationOptions
                    optionsPushNotifi.displayStyle = EMPushNotificationDisplayStyle.ePushNotificationDisplayStyle_messageSummary
                    EaseMob.sharedInstance().chatManager.asyncUpdatePushOptions(optionsPushNotifi)
                }else {
                    //注册失败
                    GShowAlertMessage(error.description+"..")
                }
                }, onQueue: nil)
            
            }, fail: { (error:String, needRelogin:Bool) -> () in
                GShowAlertMessage(error+".")
        })
    }
    
    
    func getRootTab()->UITabBarController{
        let app:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let rootVC:UITabBarController = app.window?.rootViewController as! UITabBarController
        //        GShowAlertMessage("关闭推送测试2.6")
        return rootVC
    }
    
    //返回1个UINavigationController；
    func getTabSelectedNav()->UINavigationController
    {
        let tabVC = self.getRootTab()
        //        GShowAlertMessage("关闭推送测试2.9")
        let selectVC:UINavigationController = tabVC.selectedViewController as! UINavigationController
        return selectVC
    }
    
    func popMainNavToRoot(){
        let tabVC = self.getRootTab()
        if let viewControls = tabVC.viewControllers{
            for item in viewControls{
                if let nav = item as? UINavigationController{
                    nav.popToRootViewControllerAnimated(false)
                }
            }
        }
    }
    
    //MARK: - app版本检测
    func versionCheck(){
        if kReleaseType == kCompanyRelease{
            self.versionCheckForCompany()
        }else if kReleaseType == kAppStoreRelease{
            self.versionCheckForAppStore()
        }
    }
    
    func getCurrentLocalVersion()->Float{
        let infoDict:NSDictionary = NSBundle.mainBundle().infoDictionary!
        let localVersion:String =  infoDict.objectForKey("CFBundleShortVersionString") as! String
        return Float(localVersion)!
    }
    
    //AppStore发布版本检测
    private func versionCheckForAppStore(){
        if self.versionAlert.visible == true {
            self.versionAlert.dismissWithClickedButtonIndex(1, animated: false)
        }
        
        let url = "http://itunes.apple.com/lookup?id=977118117"
        //网络请求
        let afManager = AFHTTPRequestOperationManager()
        afManager.POST(url, parameters: nil, success: { (operation:AFHTTPRequestOperation!, responseObject:AnyObject!) -> Void in
            //成功
            let jsonDic = responseObject as! Dictionary<String,AnyObject>
            let resultsArray = JsonDicHelper.getJsonDicArray(jsonDic, key: "results")
            if resultsArray.count > 0{
                let firstDic = resultsArray[0] as! Dictionary<String,AnyObject>
                let versionStr = JsonDicHelper.getJsonDicValue(firstDic, key: "version")
                self.appStoreTrackUrl = JsonDicHelper.getJsonDicValue(firstDic, key: "trackViewUrl")
                let versionFloat = Float(versionStr)!
                let localVersion = self.getCurrentLocalVersion()
                if versionFloat > localVersion{
                    //有新版本
                    self.versionAlert.title = "发现新版本"
                    self.versionAlert.message = "新版本" + versionStr + "已发布！"
                    self.versionAlert.addButtonWithTitle("立即更新")
                    self.versionAlert.addButtonWithTitle("以后再说")
                    self.versionAlert.delegate = self
                    self.versionAlert.tag = 5
                    self.versionAlert.show()
                    //                }else{
                    //已经是最新版本
                    //                    pprLog("已经是最新版本")
                }
            }
            }) { (operation:AFHTTPRequestOperation?, error:NSError!) -> Void in
                //失败
                pprLog(error)
        }
    }
    
    //企业发布版本检测
    private func versionCheckForCompany(){
        if self.versionAlert.visible == true {
            self.versionAlert.dismissWithClickedButtonIndex(1, animated: false)
        }
        NetworkManager.sharedInstance.requestCompanyVersionCheck({ (jsonDic:AnyObject) -> () in
            let dic = jsonDic as! Dictionary<String,AnyObject>
            let dataDic = JsonDicHelper.getJsonDicDictionary(dic, key: "data")
            let objDic = JsonDicHelper.getJsonDicDictionary(dataDic, key: "obj")
            let version = JsonDicHelper.getJsonDicValue(objDic, key: "version")
            let versionFloat = Float(version)
            let localVersion = self.getCurrentLocalVersion()
            
            if versionFloat > localVersion{
                //有新版本
                self.versionAlert.title = "发现新版本"
                let describe = JsonDicHelper.getJsonDicValue(objDic, key: "describe")
                self.versionAlert.message = "新版本:" + version + "\n" + describe
                self.versionAlert.addButtonWithTitle("立即更新")
                self.versionAlert.addButtonWithTitle("以后再说")
                self.versionAlert.delegate = self
                self.versionAlert.tag = 6
                self.versionAlert.show()
                //            }else{
                //                //已经是最新版本
                //                pprLog("已经是最新版本")
            }
            }) { (error:String, needRelogin:Bool) -> () in
                pprLog(error)
        }
    }
    
    //MARK: - UIAlertViewDelegate
    func alertView(alertView: UIAlertView, clickedButtonAtIndex buttonIndex: Int) {
        if buttonIndex == 0{
            if alertView.tag == 5{
                //AppStore更新
                UIApplication.sharedApplication().openURL(NSURL(string: self.appStoreTrackUrl)!)
            }else if alertView.tag == 6{
                //企业版本更新
                let url = "http://fir.im/udvt"
                UIApplication.sharedApplication().openURL(NSURL(string: url)!)
            }
        }
    }
    // MARK:- 根据text类型EMMessage得到一个text类型模型
    func getOneTextMessageModel(hx_message:EMMessage)->HXEMMessageForTextModel{
        
        let hx_messageModel = HXEMMessageForTextModel()
        
        //2.取消息体信息
        let hx_messageBodies = hx_message.messageBodies.first
        if hx_messageBodies is EMTextMessageBody
        {
            let textStr = hx_messageBodies as! EMTextMessageBody
            switch(textStr.messageBodyType)
            {
            case MessageBodyType.eMessageBodyType_Text :
                //1.EMMessage类里面ext字段对应XHMessageExtModel模型
                if hx_message.ext != nil
                {
                    //消息体内扩展模型
                    let messageExt = hx_message.ext as! Dictionary<String,AnyObject>
                    let modelExt = XHMessageExtModel.init(ext:messageExt)
                    hx_messageModel.hx_ext = modelExt
                }
                hx_messageModel.hx_messageText = textStr.text //tex消息内容
                hx_messageModel.hx_message_type = "text_message" //这个很鸡肋md
                hx_messageModel.hx_timeStamp = hx_message.timestamp //Int时间戳
                hx_messageModel.hx_timeStampForString = String(hx_message.timestamp / 1000) //字符串类型时间
                //get uid from hxid
                let hxid:String = hx_message.from
                hx_messageModel.hxid = hx_message.from
                let index = hxid.startIndex.advancedBy(3)
                let useid  = hxid.substringFromIndex(index)
                hx_messageModel.uid = useid
                
            default:
                break
            }
        }
        
        return hx_messageModel
    }
    
    
    
}
