//
//  WXApiTool.swift
//  KoalaBusinessDistrict
//
//  Created by liuny on 15/8/25.
//  Copyright (c) 2015年 koalac. All rights reserved.
//

import UIKit

class WXApiTool: NSObject,WXApiDelegate{
    //微信给的ID
    let appID = "wx93f71a7c542ea78e"
    //微信给的秘钥
    let appSecret = "285b5c1d99a3fece56a03bc4a907b099"
    
    //商户号，填写商户对应参数
    let mchID = "1262452701"
    //商户API密钥，填写相应参数
    let partnerID = "9A0892FA3D844FB5342FBD573250EAD9"
    
    //接口调用凭证
    var wxAccessToken:String = ""
    //用户刷新access_token
    var wxRefreshToken:String = ""
    //授权用户唯一标识
    var wxOpenId:String = ""
    
    //预支付网关url地址
    var payURL:String = "https://api.mch.weixin.qq.com/pay/unifiedorder"
    //debug信息
    var debugInfo:String = ""
    
    var successBlock:((AnyObject)->())?
    var failBlock:((String, Bool)->())?
    
    
    //dispatch_once单例
    class var sharedInstance : WXApiTool {
        struct Static {
            static var onceToken : dispatch_once_t = 0
            static var instance : WXApiTool? = nil
        }
        dispatch_once(&Static.onceToken) {
            Static.instance = WXApiTool()
        }
        return Static.instance!
    }
    
    func register(){
        WXApi.registerApp(self.appID)
    }
    
    func sendAuthRequest(success:(AnyObject)->(), fail:(String, Bool)->()){
        if self.checkHasInstall() == true{
            self.successBlock = success
            self.failBlock = fail
            let req = SendAuthReq()
            //snsapi_message,snsapi_userinfo,snsapi_friend,snsapi_contact,post_timeline,sns
            req.scope = "snsapi_userinfo"
            req.state = "xxx";
            WXApi.sendReq(req)
        }
    }
    
    // MARK: - ————————支付相关————————
    func sendPayRequest(dicJson:Dictionary<String, AnyObject>,  success:(AnyObject)->(), fail:(String, Bool)->()){
        
        if self.checkHasInstall() == true{
            self.successBlock = success
            self.failBlock = fail
//            let device = "app-04"
            let wxPayManager = WXPayManager()
//            let dict = wxPayManager.getPrepayWithOrderName(name,orderNum:orderNum, price: price, device: device, notifyURL:notifyURL)
            pprLog(dicJson)
            
            if dicJson.isEmpty {
                wxPayManager.getDebugInfo()
                return;
            }
        
            let stamp = dicJson["timestamp"] as! String
            
            let req = PayReq()
//            partnerId;prepayId;nonceStr;timeStamp;package;sign;
            req.openID = dicJson["appid"] as! String
            req.partnerId = dicJson["partnerid"] as! String
            req.prepayId = dicJson["prepayid"] as! String
            req.nonceStr = dicJson["noncestr"] as! String
            req.timeStamp = UInt32(Int(stamp)!)
            pprLog(req.timeStamp)
            
            req.package = dicJson["package"] as! String
            req.sign = dicJson["sign"] as! String
            
            WXApi.safeSendReq(req)
        }
        
    }

    
    private func checkHasInstall()->Bool{
        if WXApi.isWXAppInstalled() == false{
            GShowAlertMessage("请先下载安装微信客户端！")
            return false
        }else{
            return true
        }
    }
    
    //通过code获取access_token
    private func requestAccessTokenWithCode(code:String){
        let afManager = AFHTTPRequestOperationManager()
        //请求超时
        afManager.requestSerializer.timeoutInterval = 30
        //获取已经设置好的NSSet 并且添加缺少的
        let defaultSet:NSSet = afManager.responseSerializer.acceptableContentTypes!;
        afManager.responseSerializer.acceptableContentTypes = defaultSet.setByAddingObject("text/plain")
        //显示loading
        let window = UIApplication.sharedApplication().keyWindow
        MBProgressHUD.showHUDAddedTo(window, animated: true)
        var params:Dictionary<String,String> = [:]
        params["appid"] = self.appID
        params["secret"] = self.appSecret
        params["code"] = code
        params["grant_type"] = "authorization_code"
        afManager.GET("https://api.weixin.qq.com/sns/oauth2/access_token", parameters: params, success: { (operation:AFHTTPRequestOperation!, responseObject:AnyObject!) -> Void in
            MBProgressHUD.hideHUDForView(window, animated: false)
            let dic = responseObject as! Dictionary<String,AnyObject>
            let accessToken = JsonDicHelper.getJsonDicValue(dic, key: "access_token")
            if accessToken.isEmpty == false{
                self.wxAccessToken = accessToken;
                self.wxRefreshToken = JsonDicHelper.getJsonDicValue(dic, key: "refresh_token")
                self.wxOpenId = JsonDicHelper.getJsonDicValue(dic, key: "openid")
                self.getUserInfo()
            }else{
                print("----获取Access失败---")
            }
            
            }) { (operation:AFHTTPRequestOperation?, error:NSError!) -> Void in
                MBProgressHUD.hideHUDForView(window, animated: false)
                GShowAlertMessage("网络异常")
        }
    }
    
    //获取用户个人信息（UnionID机制）
    private func getUserInfo(){
        let afManager = AFHTTPRequestOperationManager()
        //请求超时
        afManager.requestSerializer.timeoutInterval = 30
        //获取已经设置好的NSSet 并且添加缺少的
        let defaultSet:NSSet = afManager.responseSerializer.acceptableContentTypes!
        afManager.responseSerializer.acceptableContentTypes = defaultSet.setByAddingObject("text/plain")
        //显示loading
        let window = UIApplication.sharedApplication().keyWindow
        MBProgressHUD.showHUDAddedTo(window, animated: true)
        var params:Dictionary<String,String> = [:]
        params["access_token"] = self.wxAccessToken
        params["openid"] = self.wxOpenId
        afManager.GET("https://api.weixin.qq.com/sns/userinfo", parameters: params, success: { (operation:AFHTTPRequestOperation!, responseObject:AnyObject!) -> Void in
            MBProgressHUD.hideHUDForView(window, animated: false)
            let dic = responseObject as! Dictionary<String,AnyObject>
            let openid = JsonDicHelper.getJsonDicValue(dic, key: "openid")
            let unionid = JsonDicHelper.getJsonDicValue(dic, key: "unionid")
            let headimgurl = JsonDicHelper.getJsonDicValue(dic, key: "headimgurl")
            let nickname = JsonDicHelper.getJsonDicValue(dic, key: "nickname")
            
            NetworkManager.sharedInstance.requestWXLogin(openid, unionid: unionid, headimgurl: headimgurl, nickname: nickname, success: { (jsonDic:AnyObject) -> () in
                
                //保存账号
                let account = AccountInfo(name: nickname, headUrl: headimgurl, openid: openid, unionid: unionid)
                let accountTool = LoginAccountTool()
                accountTool.saveAccount(account)
                LoginAccountTool.saveLastLoginAccount(account)
                
                if self.successBlock != nil{
                    self.successBlock!(jsonDic)
                }
            }, fail: self.failBlock!)
            }) { (operation:AFHTTPRequestOperation?, error:NSError!) -> Void in
                MBProgressHUD.hideHUDForView(window, animated: false)
                GShowAlertMessage("网络异常")
        }
    }
    
    /***************WXApiDelegate******************/
    //发送一个sendReq后，收到微信的回应
    func onResp(resp: BaseResp!) {
        if let authResp = resp as? SendAuthResp{
            //用户授权响应
            switch authResp.errCode{
            case WXSuccess.rawValue:
                //用户同意
                let code = authResp.code
                self.requestAccessTokenWithCode(code)
                break
            case WXErrCodeUserCancel.rawValue:
                break
            case WXErrCodeAuthDeny.rawValue:
                break
            default:
                break
            }
            
        }else if let wxResp = resp as? SendMessageToWXResp{
            //微信转发响应
            
            pprLog(resp)
            pprLog(wxResp.lang)
            pprLog(wxResp.country)
            pprLog(wxResp.debugDescription)
            
            //隐藏分享页面
            ShareView.hide()
            ActingShareView.hide()
            
            switch wxResp.errCode{
            case WXSuccess.rawValue:
                break
            case WXErrCodeCommon.rawValue:
                break
            case WXErrCodeSentFail.rawValue:
                break
            case WXErrCodeUnsupport.rawValue:
                break
            default:
                break
            }
        }else if let payResp = resp as? PayResp {
            //微信支付
            pprLog(payResp)
            //支付返回结果，实际支付结果需要去微信服务器端查询
            
            switch payResp.errCode{
            case WXSuccess.rawValue:
                
                if self.successBlock != nil{
                    self.successBlock!(0)
                }
                
                break
            case WXErrCodeCommon.rawValue:
                if self.failBlock != nil {
                    self.failBlock!("支付失败",false)
                }
                
                break
            case WXErrCodeSentFail.rawValue:
                if self.failBlock != nil {
                    self.failBlock!("支付失败",false)
                }
                break
            case WXErrCodeUnsupport.rawValue:
                if self.failBlock != nil {
                    self.failBlock!("支付失败",false)
                }
                break
            case WXErrCodeUserCancel.rawValue:
                if self.failBlock != nil {
                    self.failBlock!("支付失败",false)
                }
                break
            default:
                if self.failBlock != nil {
                    self.failBlock!("支付失败",false)
                }
                break
            }
        }
    }

}
    