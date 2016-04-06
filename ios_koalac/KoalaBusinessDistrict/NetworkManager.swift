//
//  NetworkManager.swift
//  koalac_PPM
//
//  Created by liuny on 15/6/8.
//  Copyright (c) 2015年 考拉先生. All rights reserved.
//

import UIKit
class NetworkManager: NSObject {

    #if DEBUG
//    let baseUrl = "http://test.lifeq.com.cn"
//    let feedUrl = "http://tmapi.lifeq.com.cn"
    let baseHXURL = "http://tpassport.lifeq.com.cn"
    
    let baseUrl = "http://www.lifeq.com.cn"
    let feedUrl = "http://mapi.lifeq.com.cn"

    #else
    let baseUrl = "http://www.lifeq.com.cn"
    let feedUrl = "http://mapi.lifeq.com.cn"
    let baseHXURL = "http://tpassport.lifeq.com.cn"
    
//    let baseUrl = "http://test.lifeq.com.cn"
//    let feedUrl = "http://tmapi.lifeq.com.cn"
//    let baseHXURL = "http://tpassport.lifeq.com.cn"
    #endif
    
    private var popoverJiFen:Bool = false
    //图片上传URL
    private let urlUploadImage:String
    //登录
    private let urlLogin:String
    //微信授权登录
    private let urlWXLogin:String
    //登出
    private let urlLogOut:String
    //注册
    private let urlRegister:String
    //检查用户名是否存在
    private let urlAccountExist:String
    //获得商铺分类
    private let urlShopTypeList:String
    //问题反馈
    private let urlSendQuestion:String
    //提现账户信息
    private let urlAccountDrawalInfo:String
    //收款账户列表
    private let urlDrawalCardList:String
    //提现密码设置
    private let urlDrawalPasswordSet:String
    //验证提现密码
    private let urlCheckDrawalPwd:String
    //商家提现
    private let urlDrawalDo:String
    //提现记录
    private let urlDrawalRecordList:String
    //收款账户类型
    private let urlCardTypeList:String
    //添加收款账户
    private let urlAddBankCard:String
    //客户管理列表
    private let urlCustomerList:String
    //客户管理列表详情
    private let urlCustomerDetail:String
    //特别关注或取消关注
    private let urlAttentionCustomer:String
    //商品列表
    private let urlShopGoodList:String
    //进货商品列表；
    private let urlBoughtGoodList:String
    //进货商品发布成功；
    private let urlBoughtGoodUpFinish:String
    //本店商品分类列表
    private let urlShopGoodTypeList:String
    //商店更新商品
    private let urlShopUpdateGood:String
    //商品上下架
    private let urlGoodOnOffLine:String
    //删除本店商品分类
    private let urlDeleteGoodType:String
    //编辑本店商品分类
    private let urlEditGoodType:String
    //添加本店分类
    private let urlAddGoodType:String
    //商城商品分类
    private let urlMallGoodTypeList:String
    //收货易：收货列表
    private let urlReceivingList:String
    //收货易：收货列表->详情
    private let urlReceivingDetailList:String
    //获取备注
    private let urlGetRemark:String
    //设置备注
    private let urlSetRemark:String
    //订单列表
    private let urlOrderList:String
    //发送到货提醒
    private let urlNotification:String
    //消息列表
    private let urlNewsList:String
    //编辑商店封面
    private let urlEditShopImage:String
    //编辑商品
    private let urlEditGoodInfo:String
    //添加商品
    private let urlAddGoodInfo:String
    //商品图片上传
    private let urlUploadGoodImage:String
    //销售额数据
    private let urlSaleCountList:String
    //城市列表
    private let urlCityList:String
    //确认收货
    private let urlFinishOrder:String
    //根据地区ID获取小区列表
    private let urlXiaoQuList:String
    //修改覆盖小区
    private let urlChangeXiaoQu:String
    //单个用户消息列表
    private let urlUserNewsList:String
    //根据订单ID获取订单详情
    private let urlOrderInfo:String
    //二维码扫描获取信息
    private let urlSweepOrderInfo:String
    //商城商品三级分类
    private let urlMallAllGoodTypeList:String
    //商家未读消息总数
    private let urlUnreadNewsTotal:String
    //更改商家覆盖范围
    private let urlChangeShopRadius:String
    //发现列表
    private let urlDiscoveryList:String
    //发现是否有更新
    private let urlDiscoveryUpdate:String
    //feed流(未登录)
    private let urlFeedListUnlogin:String
    //feed流(已登录)
    private let urlFeedListLogin:String
    //商家状态
    private let urlShopStatus:String
    //获取手机短信验证码
    private let urlGetSecurityCode:String
    //验证手机短信验证码
    private let urlCheckSecurityCode:String
    //提交店铺资料;
    private let urlUpdateStoreInfo:String
    //商家销售信息；
    private let urlGetAllSaleInfo:String
    //企业发布版本检测
    private let urlCompanyVersionCheck:String
    //绑定帐号接口
    private let urlBindAccount:String
    //重设密码
    private let urlChangePassword:String
    //我的店铺列表
    private let urlMyShopList:String
    //发现是否有更新
    private let urlMyShopListUpdate:String
    //广告
    private let urlAdvertisingInfo:String
    //广告点击量
    private let urlAdvertisingClickNumbe:String
    //HX
    private let urlGetHXAccount:String
    
     /*******/
    // 当面付订单勾选商品
    private let urlFaceOrderCheckShop :String
    // 当面付订单确认收货
    private let urlFaceOrderConfirmReceipt:String
    
     /*******/

    //dispatch_once单例
    class var sharedInstance : NetworkManager {
        struct Static {
            static var onceToken : dispatch_once_t = 0
            static var instance : NetworkManager? = nil
        }
        dispatch_once(&Static.onceToken) {
            Static.instance = NetworkManager()
        }
        return Static.instance!
    }
    
    override init() {
         /*******/
        self.urlFaceOrderConfirmReceipt = self.baseUrl + "/mall/index.php?app=api_v2&act=order_confirm_receipt"
        self.urlFaceOrderCheckShop = self.baseUrl + "/mall/index.php?app=api_v2&act=submit_facepay_ordergoods"
        /*******/
        self.urlUploadImage = self.baseUrl + "/mall/index.php?app=api_v2&act=image_upload"
        self.urlLogin = self.baseUrl + "/mall/index.php?app=api_v2&act=login"
        self.urlWXLogin = self.baseUrl + "/mall/index.php?app=api_v2&act=weixin_login"
        self.urlAccountExist = self.baseUrl + "/mall/index.php?app=api_v2&act=username_exist"
        self.urlShopTypeList = self.baseUrl + "/mall/index.php?app=api_v2&act=get_store_cate"
        self.urlSendQuestion = self.baseUrl + "/mall/index.php?app=api_v2&act=send_question"
        //提现账户信息
//        self.urlAccountDrawalInfo = self.baseUrl + "/mall/index.php?app=api_v2&act=balance_and_drawaled"
        //提现账户信息新接口V2.8版
        self.urlAccountDrawalInfo = self.baseUrl + "/mall/index.php?app=api_drawal&act=balance_and_drawaled_new"

        //收款账户列表
//        self.urlDrawalCardList = self.baseUrl + "/mall/index.php?app=api_v2&act=drawal_card_list"
         self.urlDrawalCardList = self.baseUrl + "/mall/index.php?app=api_drawal&act=drawal_card_list_new"

        self.urlCheckDrawalPwd = self.baseUrl + "/mall/index.php?app=api_v2&act=check_drawalpwd"
        //82.提现申请接口（接入考拉钱包后）
//        self.urlDrawalDo = self.baseUrl + "/mall/index.php?app=api_v2&act=drawal_apply"
        self.urlDrawalDo = self.baseUrl + "/mall/index.php?app=api_drawal&act=drawal_apply_new"
        //已提现金额
//        self.urlDrawalRecordList = self.baseUrl + "/mall/index.php?app=api_v2&act=drawaled_list"
        self.urlDrawalRecordList = self.baseUrl + "/mall/index.php?app=api_drawal&act=drawaled_list_new"

        self.urlDrawalPasswordSet = self.baseUrl + "/mall/index.php?app=api_v2&act=set_drawalpwd"
        //提现银行类型列表接口（接入考拉钱包后）
//        self.urlCardTypeList = self.baseUrl + "/mall/index.php?app=api_v2&act=cardtype_list"
        self.urlCardTypeList = self.baseUrl + "/mall/index.php?app=api_drawal&act=cardtype_list_new"
        //79.添加提现收款银行账户接口（接入考拉钱包后）
//        self.urlAddBankCard = self.baseUrl + "/mall/index.php?app=api_v2&act=add_drawal_card"
          self.urlAddBankCard = self.baseUrl + "/mall/index.php?app=api_drawal&act=add_drawal_card_new"
        self.urlCustomerList = self.baseUrl + "/mall/index.php?app=api_v2&act=customer"
        self.urlCustomerDetail = self.baseUrl + "/mall/index.php?app=api_v2&act=customer_detail"
        self.urlAttentionCustomer = self.baseUrl + "/mall/index.php?app=api_v2&act=special_attention"
        self.urlShopGoodList = self.baseUrl + "/mall/index.php?app=api_v2&act=get_goods_list"
        self.urlShopGoodTypeList = self.baseUrl + "/mall/index.php?app=api_v2&act=get_store_goods_category"
        self.urlBoughtGoodList = self.baseUrl + "/mall/index.php?app=api_goods_manage&act=get_ws_goods_list"
        self.urlBoughtGoodUpFinish = self.baseUrl + "/mall/index.php?app=api_goods_manage&act=goods_up_finish"
        self.urlShopUpdateGood = self.baseUrl + "/mall/index.php?app=api_v2&act=update_goods"
        self.urlGoodOnOffLine = self.baseUrl + "/mall/index.php?app=api_v2&act=handle_goods_shelf"
        self.urlDeleteGoodType = self.baseUrl + "/mall/index.php?app=api_v2&act=del_store_category"
        self.urlEditGoodType = self.baseUrl + "/mall/index.php?app=api_v2&act=add_store_category"
        self.urlAddGoodType = self.baseUrl + "/mall/index.php?app=api_v2&act=add_store_category"
        self.urlMallGoodTypeList = self.baseUrl + "/mall/index.php?app=api_v2&act=get_mall_goods_category"
        self.urlReceivingList = self.baseUrl + "/mall/index.php?app=dapi_order&act=getSkuList"
        self.urlReceivingDetailList = self.baseUrl + "/mall/index.php?app=dapi_order&act=getSkuGoodsList"
        self.urlGetRemark = self.baseUrl + "/mall/index.php?app=dapi_order&act=getRemark"
        self.urlSetRemark = self.baseUrl + "/mall/index.php?app=dapi_order&act=setRemark"
        self.urlOrderList = self.baseUrl + "/mall/index.php?app=dapi_order&act=getOrderList2"
        self.urlNotification = self.baseUrl + "/mall/index.php?app=api_v2&act=notifyAllBuyers"
        self.urlNewsList = self.baseUrl + "/mall/index.php?app=api_v2&act=get_message_users"
        self.urlEditShopImage = self.baseUrl + "/mall/index.php?app=api_v2&act=edit_storecover"
        self.urlEditGoodInfo = self.baseUrl + "/mall/index.php?app=api_v2&act=goods_edit"
        self.urlUploadGoodImage = self.baseUrl + "/mall/index.php?app=api_v2&act=goods_image_upload"
        self.urlAddGoodInfo = self.baseUrl + "/mall/index.php?app=api_v2&act=goods_add"
        self.urlSaleCountList = self.baseUrl + "/mall/index.php?app=dapi_order&act=getSaleCount"
        self.urlCityList = self.baseUrl + "/mall/index.php?app=api_v2&act=get_location_select"
        self.urlFinishOrder = self.baseUrl + "/mall/index.php?app=dapi_order&act=finishOrder"
        self.urlXiaoQuList = self.baseUrl + "/mall/index.php?app=api_v2&act=get_xiaoqu_by_locationid"
        self.urlChangeXiaoQu = self.baseUrl + "/mall/index.php?app=api_v2&act=set_store_xiaoqu"
        self.urlLogOut = self.baseUrl + "/mall/index.php?app=dapi_order&act=logout"
//        self.urlRegister = self.baseUrl + "/mall/index.php?app=api_v2&act=register"
        self.urlRegister = self.baseUrl + "/mall/index.php?app=api_v2&act=submit_wxuser_info"
        self.urlUserNewsList = self.baseUrl + "/mall/index.php?app=api_v2&act=get_user_messages"
        self.urlOrderInfo = self.baseUrl + "/mall/index.php?app=api_v2&act=get_order_detail"
        self.urlSweepOrderInfo = self.baseUrl + "/mall/index.php?app=dapi_order&act=getOrderDetailsByQrcode"
        self.urlMallAllGoodTypeList = self.baseUrl + "/mall/index.php?app=api_v2&act=get_mall_goods_all_category"
        self.urlUnreadNewsTotal = self.baseUrl + "/mall/index.php?app=api_v2&act=get_unread_messages_total"
        self.urlChangeShopRadius = self.baseUrl + "/mall/index.php?app=api_v2&act=update_store_coverage"
        self.urlDiscoveryList = self.baseUrl + "/mall/index.php?app=api_found&act=get_found_tabs"
        self.urlDiscoveryUpdate = self.baseUrl + "/mall/index.php?app=api_found&act=get_tabs_newest_id"
        //feed请求
//        self.urlFeedListLogin = self.baseUrl + "/mall/index.php?app=api_v2&act=get_feeds"
         self.urlFeedListLogin = self.feedUrl + "/get_feed_dist"

        self.urlFeedListUnlogin = self.baseUrl + "/mall/index.php?app=api_v2&act=get_feeds_by_lnglat"
        self.urlShopStatus = self.baseUrl + "/mall/index.php?app=api_v2&act=get_store_status"
        self.urlGetSecurityCode = self.baseUrl + "/mall/index.php?app=api_v2&act=get_security_code"
        self.urlCheckSecurityCode = self.baseUrl + "/mall/index.php?app=api_v2&act=check_security_code"
        self.urlUpdateStoreInfo = self.baseUrl + "/mall/index.php?app=api_v2&act=update_store_info"
        self.urlCompanyVersionCheck = self.baseUrl + "/mall/index.php?app=dapi_order&act=getLatestVersion"
        self.urlGetAllSaleInfo = self.baseUrl + "/mall/index.php?app=dapi_order&act=getAllSaleInfo"
        self.urlBindAccount = self.baseUrl + "/mall/index.php?app=api_v2&act=bind_user"
        self.urlChangePassword = self.baseUrl + "/mall/index.php?app=api_v2&act=reset_password"
        self.urlMyShopList = self.baseUrl + "/mall/index.php?app=api_found&act=get_store_tabs"
        self.urlMyShopListUpdate = self.baseUrl + "/mall/index.php?app=api_found&act=get_store_tabs_version"
        self.urlAdvertisingInfo = self.baseUrl + "/mall/index.php?app=api_v2&act=get_screen_ad"
        self.urlAdvertisingClickNumbe = self.baseUrl + "/mall/index.php?app=api_v2&act=increase_ad_click_sum"
        
        //HX测试
        self.urlGetHXAccount = self.baseHXURL + "/HuanXin/createHunXinUser"
        
        super.init()
    }
    
    let timeOut:NSTimeInterval = 60
    
    //Post请求
    private func networkPost(url:String, params:AnyObject?, success:(AnyObject)->(), fail:(String,Bool)->())
    {
        
        let afManager = AFHTTPRequestOperationManager()
        //请求超时
        afManager.requestSerializer.timeoutInterval = timeOut
        //获取已经设置好的NSSet 并且添加缺少的
        let defaultSet:NSSet = afManager.responseSerializer.acceptableContentTypes!;
        afManager.responseSerializer.acceptableContentTypes = defaultSet.setByAddingObject("text/html")
        //显示loading
        let window = UIApplication.sharedApplication().keyWindow
        afManager.POST(url, parameters: params, success: { (operation:AFHTTPRequestOperation!, responseObject:AnyObject!) -> Void in
            MBProgressHUD.hideHUDForView(window, animated: false)
            self.networkSuccess(url,responseObject: responseObject, successBlock: success, failBlock: fail)
            }) { (operation:AFHTTPRequestOperation?, error:NSError!) -> Void in
            MBProgressHUD.hideHUDForView(window, animated: false)
            self.networkFail(fail)
        }
    }
    
    //Post请求(不显示loading)
    private func networkPostNotLoading(url:String, params:AnyObject?, success:(AnyObject)->(), fail:(String,Bool)->())
    {
        let afManager = AFHTTPRequestOperationManager()
        //请求超时
        afManager.requestSerializer.timeoutInterval = timeOut
        //获取已经设置好的NSSet 并且添加缺少的
        let defaultSet:NSSet = afManager.responseSerializer.acceptableContentTypes!;
        afManager.responseSerializer.acceptableContentTypes = defaultSet.setByAddingObject("text/html")
        afManager.POST(url, parameters: params, success: { (operation:AFHTTPRequestOperation!, responseObject:AnyObject!) -> Void in
            self.networkSuccess(url,responseObject: responseObject, successBlock: success, failBlock: fail)
            }) { (operation:AFHTTPRequestOperation?, error:NSError!) -> Void in
                self.networkFail(fail)
        }
    }
    
    private func popoverJiFen(requestUrl:String,responseObject:AnyObject!){
        if self.popoverJiFen == true{
            self.popoverJiFen = false
            let jiFenRequestUrl=[self.urlAddBankCard,self.urlFinishOrder,self.urlAddGoodInfo,self.urlDrawalDo,self.urlGoodOnOffLine]
            let jiFenType = ["bind_bank_card","confirm_delivery","first_add_goods","finish_drawal_apply","first_add_goods"]
            var request = false
            var index = -1
            for var i=0; i<jiFenRequestUrl.count;i++ {
                if jiFenRequestUrl[i] == requestUrl{
                    request = true
                    index = i
                }
            }
            if request == true{
                var params:Dictionary<String,String> = [:]
                params["m_auth"] = LoginInfoModel.sharedInstance.m_auth
                params["action"] = jiFenType[index]
                self.networkPost(baseUrl+"/mall/index.php?app=api_credit&act=update_store_experience_credit", params: params, success: { (AnyObject) -> () in
                    
                    }, fail: { (String, Bool) -> () in
    
                })
            }
        }else{
            let jsonDic = responseObject as! Dictionary<String,AnyObject>
            let error = JsonDicHelper.getJsonDicValue(jsonDic, key: "error")
            let errorFloat = (error as NSString).floatValue
            if errorFloat == 0{
                //积分弹屏
                let dataDic = JsonDicHelper.getJsonDicDictionary(jsonDic, key: "data")
                let objDic = JsonDicHelper.getJsonDicDictionary(dataDic, key: "obj")
                let rewordDic = JsonDicHelper.getJsonDicDictionary(objDic, key: "reword")
                let rewordModel = RewordModel(jsonDic: rewordDic )
                let pointInt = (rewordModel.pointsGet as NSString).intValue
                let experienceInt = (rewordModel.experienceGet as NSString).intValue

                if pointInt > 0 || experienceInt > 0
                {
                    //有广告就点击广告后再弹积分等级弹框，没广告就直接弹积分等级弹框
                    if isShowAdvistFlag == true
                    {
                        isShowAdvistFlag = false
                        levelModelInfoBlock = {() ->() in
                            let rewordView = LevelUpView.instantiateFromNib()
                            rewordView.show(rewordModel)
                        }

                    }else{
                        let rewordView = LevelUpView.instantiateFromNib()
                        NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                            rewordView.show(rewordModel)
                        })
                    }
                    
                }
            }
        }
    }
    
    private func networkFail(failBlock:(String,Bool)->()){
        failBlock("网络异常",false)
    }
    
    private func networkSuccess(requestUrl:String, responseObject:AnyObject!, successBlock:(AnyObject)->(), failBlock:(String,Bool)->()){
        if responseObject == nil{
            return
        }
        let jsonDic = responseObject as! Dictionary<String,AnyObject>
        let error = JsonDicHelper.getJsonDicValue(jsonDic, key: "error")
        let errorFloat = (error as NSString).floatValue
        switch errorFloat{
        case 0:
            //请求成功 积分
            // 测试推送
            self.popoverJiFen(requestUrl, responseObject: responseObject)
            
            successBlock(jsonDic)
        case 101:
            //授权失败，需要重新登录
            let errorMsg = JsonDicHelper.getJsonDicValue(jsonDic, key:"msg")
            GShowAlertMessage("授权失败！")
            failBlock(errorMsg,true)
            let rootVC = ProjectManager.sharedInstance.getRootTab()
            let loginVC = LoginViewController(nibName:"LoginViewController", bundle:nil)
            loginVC.showLastLoginInfo = true
            loginVC.status = showType.logout
            loginVC.view.backgroundColor = UIColor(red: 1/255.0, green: 1/255.0, blue: 1/255.0, alpha: 0.6)
            rootVC.presentViewController(loginVC, animated: true) { () -> Void in
                ProjectManager.sharedInstance.popMainNavToRoot()
                rootVC.selectedIndex = 0
            }
        default:
            //失败
            let errorMsg = JsonDicHelper.getJsonDicValue(jsonDic, key:"msg")
            failBlock(errorMsg,false)
        }
    }
    
    //Get请求
    private func networkGet(url:String, params:AnyObject?, success:(AnyObject)->(), fail:(String,Bool)->()){
        let afManager = AFHTTPRequestOperationManager()
        //请求超时
        afManager.requestSerializer.timeoutInterval = timeOut
        //获取已经设置好的NSSet 并且添加缺少的
        let defaultSet:NSSet = afManager.responseSerializer.acceptableContentTypes!;
        afManager.responseSerializer.acceptableContentTypes = defaultSet.setByAddingObject("text/html")
        //显示loading
        let window = UIApplication.sharedApplication().keyWindow
        MBProgressHUD.showHUDAddedTo(window, animated: true)
        
        afManager.GET(url, parameters: params, success: { (operation:AFHTTPRequestOperation!, responseObject:AnyObject!) -> Void in
            MBProgressHUD.hideHUDForView(window, animated: false)
            self.networkSuccess(url, responseObject: responseObject, successBlock: success, failBlock: fail)
            }) { (operation:AFHTTPRequestOperation?, error:NSError!) -> Void in
                MBProgressHUD.hideHUDForView(window, animated: false)
                self.networkFail(fail)
        }
    }
    
    //dic->json string
    private func dictionaryJson(dic:Dictionary<String,AnyObject>)->String{
        if NSJSONSerialization.isValidJSONObject(dic){
            if let data = try? NSJSONSerialization.dataWithJSONObject(dic, options: NSJSONWritingOptions.PrettyPrinted){
                return NSString(data:data, encoding:NSUTF8StringEncoding)! as String
            }
        }
        return ""
    }
    
    //上传单张图片
    private func networkUploadImage(url:String, params:AnyObject?, imageData:NSData, imageParamsKey:String, imageUploadName:String, success:(AnyObject)->(), fail:(String,Bool)->()){
        let afManager = AFHTTPRequestOperationManager()
        //请求超时
        afManager.requestSerializer.timeoutInterval = timeOut
        //显示loading
        let window = UIApplication.sharedApplication().keyWindow
        MBProgressHUD.showHUDAddedTo(window, animated: true)
        
        afManager.POST(url, parameters: params, constructingBodyWithBlock: { (fromData:AFMultipartFormData!) -> Void in
            fromData.appendPartWithFileData(imageData, name: imageParamsKey, fileName: imageUploadName, mimeType: "image/png,image/jpeg")
            }, success: { (operation:AFHTTPRequestOperation!, responseObject:AnyObject!) -> Void in
                MBProgressHUD.hideHUDForView(window, animated: false)
                self.networkSuccess(url, responseObject: responseObject, successBlock: success, failBlock: fail)
            }) { (operation:AFHTTPRequestOperation?, error:NSError!) -> Void in
                MBProgressHUD.hideHUDForView(window, animated: false)
                self.networkFail(fail)
        }
    }
    
    //登录
    func requestLogin(name:String, password:String, success:(AnyObject)->(), fail:(String, Bool)->()){
        var params:Dictionary<String,String> = [:]
        params["user_name"] = name
        params["password"] = password
        
        if let deviceId: AnyObject = NSUserDefaults.standardUserDefaults().objectForKey("deviceId"){
            params["device_id"] = deviceId as? String
            pprLog("\(deviceId)")
            
        }else{
            //改用极光的rid；
            let rid = APService.registrationID()
            params["device_id"] = rid
            
        }
        
        self.networkPost(self.urlLogin, params: params, success: success, fail: fail)
    }
    
    //微信授权登录
    func requestWXLogin(openid:String,unionid:String,headimgurl:String,nickname:String,success:(AnyObject)->(), fail:(String, Bool)->()){
        var params:Dictionary<String,String> = [:]
        params["nickname"] = nickname
        params["openid"] = openid
        params["unionid"] = unionid
        params["headimgurl"] = headimgurl
        if let deviceId: AnyObject = NSUserDefaults.standardUserDefaults().objectForKey("deviceId"){
            params["device_id"] = deviceId as? String
            pprLog("\(deviceId)")
            
        }else{
//            let uuid = UIDevice.currentDevice().identifierForVendor!.UUIDString
            //改用极光的rid；
            let rid = APService.registrationID()
            params["device_id"] = rid
        }
        
        self.networkPost(self.urlWXLogin, params: params, success: success, fail: fail)
    }
    
    //登出
    func requestLogOut(success:(AnyObject)->(), fail:(String, Bool)->()){
        var params:Dictionary<String,String> = [:]
        params["m_auth"] = LoginInfoModel.sharedInstance.m_auth
        self.networkPost(self.urlLogOut, params: params, success: success, fail: fail)
    }
    
    //注册
    func requestRegister(account:RegisterModel, success:(AnyObject)->(), fail:(String, Bool)->()){
        var headUrl = ""
        let imageData = UIImageJPEGRepresentation(account.headIcon!, 0.3)
        self.networkUploadImage(self.urlUploadImage, params: nil, imageData: imageData!, imageParamsKey: "Filedata", imageUploadName: "headIcon.jpg", success: { (jsonDic:AnyObject) -> () in
            let dic = jsonDic as! Dictionary<String,AnyObject>
            let dataDic = JsonDicHelper.getJsonDicDictionary(dic, key: "data")
            let objDic = JsonDicHelper.getJsonDicDictionary(dataDic, key: "obj")
            headUrl = JsonDicHelper.getJsonDicValue(objDic, key: "thumb_ios")
            
            //上传身份证照片
            let window = UIApplication.sharedApplication().keyWindow
            MBProgressHUD.showHUDAddedTo(window, animated: true)
            var mutableOperation:[AFHTTPRequestOperation] = []
            var cardUrl:[String] = []
            for item in account.cardImage{
                let imageData = UIImageJPEGRepresentation(item, 0.3)
                let request = AFHTTPRequestSerializer().multipartFormRequestWithMethod("POST", URLString: self.urlUploadImage, parameters: nil, constructingBodyWithBlock: { (fromData:AFMultipartFormData!) -> Void in
                    fromData.appendPartWithFileData(imageData!, name: "Filedata", fileName: "image.jpg", mimeType: "image/png,image/jpeg")
                    }, error: nil)
                
                let operation = AFHTTPRequestOperation(request: request)
                operation.responseSerializer = AFJSONResponseSerializer()
                operation.setCompletionBlockWithSuccess({ (operation:AFHTTPRequestOperation!, responseObject:AnyObject!) -> Void in
                    
                    let dic = responseObject as! Dictionary<String,AnyObject>
                    let dataDic = JsonDicHelper.getJsonDicDictionary(dic, key: "data")
                    let objDic = JsonDicHelper.getJsonDicDictionary(dataDic, key: "obj")
                    cardUrl.append(JsonDicHelper.getJsonDicValue(objDic, key: "thumb_ios"))
                    }, failure: nil)
                mutableOperation.append(operation)
            }
            let operations = AFURLConnectionOperation.batchOfRequestOperations(mutableOperation, progressBlock: { (numberOfFinishedOperations:UInt, totalNumberOfOperations:UInt) -> Void in
                
                }) { (operations:[AnyObject]!) -> Void in
                    MBProgressHUD.hideHUDForView(window, animated: false)
                    var params:Dictionary<String,String> = [:]
//                    params["user_name"] = account.userName
//                    params["password"] = account.password
                    params["cate_id"] = account.cate_id
                    params["store_name"] = account.stroe_name
                    params["real_name"] = account.real_name
                    params["province"] = account.province
                    params["city"] = account.city
                    params["lng"] = account.lng
                    params["lat"] = account.lat
                    params["tel"] = account.tel
                    params["address"] = account.address
                    params["m_auth"] = account.mAuth
                    params["logo"] = headUrl
                    params["service_type"] = "1"//1：半径覆盖，2：城市覆盖
                    params["radius"] = account.radius
                    
                    //推荐人；
                    params["recommend_info"] = account.recommendInfo
                    
                    if cardUrl.count > 0{
                        var cardImages = cardUrl.first!
                        for var i=1;i<cardUrl.count;i++ {
                            cardImages += ",\(cardUrl[i])"
                        }
                        params["id_images"] = cardImages
                    }

                    self.networkPost(self.urlRegister, params: params, success: success, fail: fail)
                    pprLog("\(params)")
            }
            NSOperationQueue.mainQueue().addOperations((operations as! [NSOperation]), waitUntilFinished: false)
            
        }, fail: fail)
    }
    
    //检查用户名是否存在
    func requiredAccountExist(account:String, success:(AnyObject)->(), fail:(String, Bool)->()){
        var params:Dictionary<String,String> = [:]
        params["user_name"] = account
        self.networkPost(self.urlAccountExist, params: params, success: success, fail: fail)
    }
    
    //获得商铺分类
    func requestGetShopTypeList(success:(AnyObject)->(), fail:(String, Bool)->()){
        self.networkGet(self.urlShopTypeList, params: nil, success: success, fail: fail)
    }
    
    //问题反馈
    func requestSendQuestion(questionTxt:String, success:(AnyObject)->(), fail:(String, Bool)->()){
        var params:Dictionary<String,String> = [:]
        params["m_auth"] = LoginInfoModel.sharedInstance.m_auth
        params["question"] = questionTxt
        self.networkPost(self.urlSendQuestion, params: params, success: success, fail: fail)
    }
    

    //提现账户信息
    func requestAccountDrawalInfo(success:(AnyObject)->(), fail:(String, Bool)->()){
        var params:Dictionary<String,String> = [:]
        params["m_auth"] = LoginInfoModel.sharedInstance.m_auth
        self.networkPost(self.urlAccountDrawalInfo, params: params, success: success, fail: fail)
    }
    
    //收款账户列表
    func requestDrawalCardList(success:(AnyObject)->(), fail:(String, Bool)->()){
        var params:Dictionary<String,String> = [:]
        params["m_auth"] = LoginInfoModel.sharedInstance.m_auth
        self.networkPost(self.urlDrawalCardList, params: params, success: success, fail: fail)
    }
    
    //提现密码设置
    func requestDrawalPasswordSet(newPassword:String,repeatPassword:String, success:(AnyObject)->(), fail:(String, Bool)->()){
        var params:Dictionary<String,String> = [:]
        params["m_auth"] = LoginInfoModel.sharedInstance.m_auth
        params["drawalpwd"] = newPassword
        params["redrawalpwd"] = repeatPassword
        self.networkPost(self.urlDrawalPasswordSet, params: params, success: success, fail: fail)
    }
    
    //验证提现密码
    func requestCheckDrawalPwd(password:String, success:(AnyObject)->(), fail:(String, Bool)->()){
        var params:Dictionary<String,String> = [:]
        params["m_auth"] = LoginInfoModel.sharedInstance.m_auth
        params["drawalpwd"] = password
        self.networkPost(self.urlCheckDrawalPwd, params: params, success: success, fail: fail)
    }
    
    //商家提现
    func requestDrawalDo(money:String,drawalpwd:String,cardInfo:BankCardInfoNewModel, success:(AnyObject)->(), fail:(String, Bool)->()){
        var params:Dictionary<String,String> = [:]
        params["m_auth"] = LoginInfoModel.sharedInstance.m_auth
        params["money"] = money
        params["drawalpwd"] = drawalpwd
        params["store_bank_id"] = cardInfo.store_bank_id
        params["bank_type_id"] = cardInfo.bank_type_id
        params["bank_type_name"] = cardInfo.bank_type_name
        params["bank_owner"] = cardInfo.bank_owner
        params["bank_account"] = cardInfo.bank_account
        params["bank_branch"] = cardInfo.bank_branch
        params["bank_address"] = cardInfo.bank_address

        self.popoverJiFen = true
        self.networkPost(self.urlDrawalDo, params: params, success: success, fail: fail)
    }
    
    //提现记录 V2.8新增drawal_status参数
    func requestDrawalRecordList(drawal_status:String,success:(AnyObject)->(), fail:(String, Bool)->()){
        var params:Dictionary<String,String> = [:]
        params["m_auth"] = LoginInfoModel.sharedInstance.m_auth
        params["drawal_status"] = drawal_status
        self.networkPost(self.urlDrawalRecordList, params: params, success: success, fail: fail)
    }
    
    //收款账户类型
    func requestCardTypeList(success:(AnyObject)->(), fail:(String, Bool)->()){
        var params:Dictionary<String,String> = [:]
        params["m_auth"] = LoginInfoModel.sharedInstance.m_auth
        self.networkPost(self.urlCardTypeList, params: params, success: success, fail: fail)
    }
    
    //添加收款账户
    func requestAddBankCard(bank_type_id:String, bank_account:String, bank_branch:String, card_owner:String, province:String,city:String,success:(AnyObject)->(), fail:(String, Bool)->()){
        var params:Dictionary<String,String> = [:]
        params["m_auth"] = LoginInfoModel.sharedInstance.m_auth
        params["bank_type_id"] = bank_type_id //银行类型id
        params["bank_account"] = bank_account//银行卡号（注意：不要有空格！）
        params["bank_branch"] = bank_branch//银行支行
        params["card_owner"] = card_owner//银行卡持有者姓名
        params["province"] = province//开户银行所在省
        params["city"] = city//开户银行所在市
//        params["address"] = address//开户银行具体地址
        self.popoverJiFen = true
        self.networkPost(self.urlAddBankCard, params: params, success: success, fail: fail)
    }
    
    //客户管理列表
    func requestCustomerList(keyword:String, success:(AnyObject)->(), fail:(String, Bool)->()){
        var params:Dictionary<String,String> = [:]
        params["m_auth"] = LoginInfoModel.sharedInstance.m_auth
        params["store_id"] = LoginInfoModel.sharedInstance.store.store_id
        //客户名关键字（为空表示返回所有客户，不空则返回名字有该关键字的所有客户）
        params["keyword"] = keyword
        self.networkPost(self.urlCustomerList, params: params, success: success, fail: fail)
    }
    
    //客户管理列表 分页
    func requestCustomerListPage(keyword:String, page :Int, success:(AnyObject)->(), fail:(String, Bool)->()){
        var params:Dictionary<String,String> = [:]
        params["m_auth"] = LoginInfoModel.sharedInstance.m_auth
        params["store_id"] = LoginInfoModel.sharedInstance.store.store_id
        //客户名关键字（为空表示返回所有客户，不空则返回名字有该关键字的所有客户）
        params["keyword"] = keyword
        params["page"] = String(page)
        self.networkPost(self.urlCustomerList, params: params, success: success, fail: fail)
    }
    
    //客户管理列表详情
    func requestCustomDetail(uid:String, success:(AnyObject)->(), fail:(String, Bool)->()){
        var params:Dictionary<String,String> = [:]
        params["m_auth"] = LoginInfoModel.sharedInstance.m_auth
        params["store_id"] = LoginInfoModel.sharedInstance.store.store_id
        params["uid"] = uid
        self.networkPost(self.urlCustomerDetail, params: params, success: success, fail: fail)
    }
    
    //特别关注或取消关注 attentionType:true,关注  false,取消关注
    func requestAttentionCustomer(attentionType:Bool, uid:String, success:(AnyObject)->(), fail:(String, Bool)->()){
        var params:Dictionary<String,String> = [:]
        params["m_auth"] = LoginInfoModel.sharedInstance.m_auth
        params["store_id"] = LoginInfoModel.sharedInstance.store.store_id
        params["uid"] = uid
        if attentionType == true{
            params["do"] = "do_attention"
        }else{
            params["do"] = "cancel_attention"
        }
        self.networkPost(self.urlAttentionCustomer, params: params, success: success, fail: fail)
    }
    
    //商品列表
    func requestShopGoodList(page:Int, pageNum:Int, success:(AnyObject)->(), fail:(String, Bool)->()){
        var params:Dictionary<String,String> = [:]
        params["m_auth"] = LoginInfoModel.sharedInstance.m_auth
        params["page"] = String(page)
        params["perpage"] = String(pageNum)
        params["detail"] = String(1)
        
        self.networkPost(self.urlShopGoodList, params: params, success: success, fail: fail)
    }
    
    func requestShopGoodList(page:Int, onOrOff:Bool, pageNum:Int, success:(AnyObject)->(), fail:(String, Bool)->()){
        var params:Dictionary<String,String> = [:]
        params["m_auth"] = LoginInfoModel.sharedInstance.m_auth
        params["page"] = String(page)
        params["perpage"] = String(pageNum)
        params["detail"] = String(1)
        if onOrOff == true{
            params["character"] = "show"
        }else{
            params["character"] = "hide"
        }
        
        self.networkPost(self.urlShopGoodList, params: params, success: success, fail: fail)
    }
    
    //MARK: - 获取进货商品列表
    func requestBoughtGoodList(page:Int, pageNum:Int, success:(AnyObject)->(), fail:(String, Bool)->()){
        var params:Dictionary<String,String> = [:]
        params["m_auth"] = LoginInfoModel.sharedInstance.m_auth
        params["page"] = String(page)
        params["perpage"] = String(pageNum)
        params["detail"] = String(1)
        
        self.networkPost(self.urlBoughtGoodList, params: params, success: success, fail: fail)
    }
    
    
    //本店商品分类列表
    func requestShopGoodTypeList(success:(AnyObject)->(), fail:(String, Bool)->()){
        var params:Dictionary<String,String> = [:]
        params["m_auth"] = LoginInfoModel.sharedInstance.m_auth
        
        self.networkPost(self.urlShopGoodTypeList, params: params, success: success, fail: fail)
    }
    
    //商店更新商品
    func requestShopUpdateGood(goodId:String, success:(AnyObject)->(), fail:(String, Bool)->()){
        var params:Dictionary<String,String> = [:]
        params["m_auth"] = LoginInfoModel.sharedInstance.m_auth
        params["goods_id"] = goodId
        self.networkPost(self.urlShopUpdateGood, params: params, success: success, fail: fail)
    }
    
    //商品上下架 onOffType:true,上架  false,下架
    func requestGoodOnOffLine(goodId:String, onOffType:Bool, success:(AnyObject)->(), fail:(String, Bool)->()){
        var params:Dictionary<String,String> = [:]
        params["m_auth"] = LoginInfoModel.sharedInstance.m_auth
        params["goods_id"] = goodId
        params["do"] = onOffType ? "1" : "0"
        if onOffType == true{
            self.popoverJiFen = true
        }
        self.networkPost(self.urlGoodOnOffLine, params: params, success: success, fail: fail)
    }
    
    //删除本店商品分类
    func requestDeleteGoodType(deleteId:String, success:(AnyObject)->(), fail:(String, Bool)->()){
        var params:Dictionary<String,String> = [:]
        params["m_auth"] = LoginInfoModel.sharedInstance.m_auth
        params["id[]"] = deleteId
        self.networkPost(self.urlDeleteGoodType, params: params, success: success, fail: fail)
    }
    
    //编辑本店商品分类
    func requestEditGoodType(typeId:String, typeName:String, success:(AnyObject)->(), fail:(String, Bool)->()){
        var params:Dictionary<String,String> = [:]
        params["m_auth"] = LoginInfoModel.sharedInstance.m_auth
        params["cate_id"] = typeId
        params["cate_name"] = typeName
        params["if_show"] = "1"
        self.networkPost(self.urlEditGoodType, params: params, success: success, fail: fail)
    }
    
    //添加本店分类
    func requestAddGoodType(typeName:String, success:(AnyObject)->(), fail:(String, Bool)->()){
        var params:Dictionary<String,String> = [:]
        params["m_auth"] = LoginInfoModel.sharedInstance.m_auth
        params["cate_name"] = typeName
        params["if_show"] = "1"
        self.networkPost(self.urlAddGoodType, params: params, success: success, fail: fail)
    }
    
    //商城商品分类
    func requestMallGoodTypeList(success:(AnyObject)->(), fail:(String, Bool)->()){
        var params:Dictionary<String,String> = [:]
        params["m_auth"] = LoginInfoModel.sharedInstance.m_auth
        self.networkPost(self.urlMallGoodTypeList, params: params, success: success, fail: fail)
    }
    
    //商城三级商品分类
    func requestMallAllGoodTypeList(success:(AnyObject)->(), fail:(String, Bool)->()){
        var params:Dictionary<String,String> = [:]
        params["m_auth"] = LoginInfoModel.sharedInstance.m_auth
        self.networkPost(self.urlMallAllGoodTypeList, params: params, success: success, fail: fail)
    }
    
    //收货易：收货列表
    func requestReceivingList(date:NSDate, page:Int, pageNum:Int, success:(AnyObject)->(), fail:(String, Bool)->()){
        var params:Dictionary<String,String> = [:]
        params["m_auth"] = LoginInfoModel.sharedInstance.m_auth
        params["page"] = String(page)
        params["perpage"] = String(pageNum)
        
        let calendar = NSCalendar.currentCalendar()
        let dateComponents = calendar.components([.NSYearCalendarUnit, .NSMonthCalendarUnit, .NSDayCalendarUnit], fromDate: date)
        params["year"] = String(dateComponents.year)
        params["month"] = String(dateComponents.month)
        params["day"] = String(dateComponents.day)
        self.networkPost(self.urlReceivingList, params: params, success: success, fail: fail)
    }
    
    //收货易：收货列表->详情
    func requestReceivingDetailList(date:NSDate, page:Int, pageNum:Int, storeId:String, success:(AnyObject)->(), fail:(String, Bool)->()){
        var params:Dictionary<String,String> = [:]
        params["m_auth"] = LoginInfoModel.sharedInstance.m_auth
        params["page"] = String(page)
        params["perpage"] = String(pageNum)
        params["store_id"] = storeId
        
        let calendar = NSCalendar.currentCalendar()
        let dateComponents = calendar.components([.NSYearCalendarUnit, .NSMonthCalendarUnit, .NSDayCalendarUnit], fromDate: date)
        params["year"] = String(dateComponents.year)
        params["month"] = String(dateComponents.month)
        params["day"] = String(dateComponents.day)
        self.networkPost(self.urlReceivingDetailList, params: params, success: success, fail: fail)
    }
    
    //获取备注
    func requestGetRemark(date:NSDate, success:(AnyObject)->(), fail:(String, Bool)->()){
        var params:Dictionary<String,String> = [:]
        params["m_auth"] = LoginInfoModel.sharedInstance.m_auth
        
        let calendar = NSCalendar.currentCalendar()
        let dateComponents = calendar.components([.NSYearCalendarUnit, .NSMonthCalendarUnit, .NSDayCalendarUnit], fromDate: date)
        params["year"] = String(dateComponents.year)
        params["month"] = String(dateComponents.month)
        params["day"] = String(dateComponents.day)
        self.networkPost(self.urlGetRemark, params: params, success: success, fail: fail)
    }
    
    //设置备注
    func requestSetMark(date:NSDate, content:String, success:(AnyObject)->(), fail:(String, Bool)->()){
        var params:Dictionary<String,String> = [:]
        params["m_auth"] = LoginInfoModel.sharedInstance.m_auth
        params["content"] = content
        
        let calendar = NSCalendar.currentCalendar()
        let dateComponents = calendar.components([.NSYearCalendarUnit, .NSMonthCalendarUnit, .NSDayCalendarUnit], fromDate: date)
        params["year"] = String(dateComponents.year)
        params["month"] = String(dateComponents.month)
        params["day"] = String(dateComponents.day)
        self.networkPost(self.urlSetRemark, params: params, success: success, fail: fail)
    }
    
    //订单列表 status： 订单状态标识（0：全部类型订单，1：已发货，2：已发货，3：待退货，4：已取消）
    func requestOrderList(date:NSDate, status:Int, keyword:String, page:Int, pageNum:Int, success:(AnyObject)->(), fail:(String, Bool)->()){
        var params:Dictionary<String,String> = [:]
        params["m_auth"] = LoginInfoModel.sharedInstance.m_auth
        params["keyword"] = keyword
        params["status"] = String(status)
        params["page"] = String(page)
        params["perpage"] = String(pageNum)
        
        let calendar = NSCalendar.currentCalendar()
        let dateComponents = calendar.components([.NSYearCalendarUnit, .NSMonthCalendarUnit, .NSDayCalendarUnit], fromDate: date)
        params["year"] = String(dateComponents.year)
        params["month"] = String(dateComponents.month)
        params["day"] = String(dateComponents.day)
        self.networkPost(self.urlOrderList, params: params, success: success, fail: fail)
    }
    
    //发送到货提醒
    func requestNotification(success:(AnyObject)->(), fail:(String, Bool)->()){
        var params:Dictionary<String,String> = [:]
        params["m_auth"] = LoginInfoModel.sharedInstance.m_auth
        self.networkPost(self.urlNotification, params: params, success: success, fail: fail)
    }
    
    //消息列表
    func requestNewsList(page:Int, pageNum:Int, success:(AnyObject)->(), fail:(String, Bool)->()){
        var params:Dictionary<String,String> = [:]
        params["m_auth"] = LoginInfoModel.sharedInstance.m_auth
        params["page"] = String(page)
        params["perpage"] = String(pageNum)
 
        self.networkPost(self.urlNewsList, params: params, success: success, fail: fail)

    }
    
    //消息列表 不转圈
    func requestNewsListNotLoading(page:Int, pageNum:Int, success:(AnyObject)->(), fail:(String, Bool)->()){
        var params:Dictionary<String,String> = [:]
        params["m_auth"] = LoginInfoModel.sharedInstance.m_auth
        params["page"] = String(page)
        params["perpage"] = String(pageNum)
        
        self.networkPostNotLoading(self.urlNewsList, params: params, success: success, fail: fail)
    }
    
    
    //编辑商店封面
    func requestEditShopImage(image:UIImage, success:(AnyObject)->(), fail:(String, Bool)->()){
        let imageData = UIImageJPEGRepresentation(image, 0.3)
        self.networkUploadImage(self.urlUploadImage, params: nil, imageData: imageData!, imageParamsKey: "Filedata", imageUploadName: "shopImage.jpg", success: { (jsonDic:AnyObject) -> () in
            let dic = jsonDic as! Dictionary<String, AnyObject>
            var params:Dictionary<String,String> = [:]
            params["m_auth"] = LoginInfoModel.sharedInstance.m_auth
            let dataDic = JsonDicHelper.getJsonDicDictionary(dic, key: "data")
            let objDic = JsonDicHelper.getJsonDicDictionary(dataDic, key: "obj")
            params["picurl"] = JsonDicHelper.getJsonDicValue(objDic, key: "thumb_ios")
            params["store_id"] = LoginInfoModel.sharedInstance.store.store_id
            self.networkPost(self.urlEditShopImage, params: params, success: success, fail: fail)
        }, fail: fail)
    }
    
    //商品封面图片上传
    func requestUploadGoodImage(images:[UIImage], goodId:String, success:(AnyObject)->(), fail:(String, Bool)->()){
        var params:Dictionary<String,String> = [:]
        params["m_auth"] = LoginInfoModel.sharedInstance.m_auth
        params["goods_id"] = goodId
        
        pprLog(images.count)
        
        let window = UIApplication.sharedApplication().keyWindow
        let hud = MBProgressHUD.showHUDAddedTo(window, animated: true)
        hud.labelText = "封面图片上传..."
        var mutableOperation:[AFHTTPRequestOperation] = []
        var fileID:[goodCoverImageModel] = []
        
        pprLog(fileID)
        
        for item in images{
            let imageData = UIImageJPEGRepresentation(item, 0.6)
            let request = AFHTTPRequestSerializer().multipartFormRequestWithMethod("POST", URLString: self.urlUploadGoodImage, parameters: params, constructingBodyWithBlock: { (fromData:AFMultipartFormData!) -> Void in
                fromData.appendPartWithFileData(imageData!, name: "Filedata", fileName: "image.jpg", mimeType: "image/png,image/jpeg")
            }, error: nil)
            
            let operation = AFHTTPRequestOperation(request: request)
            operation.responseSerializer = AFJSONResponseSerializer()
            operation.setCompletionBlockWithSuccess({ (operation:AFHTTPRequestOperation!, responseObject:AnyObject!) -> Void in
            
                let dic = responseObject as! Dictionary<String,AnyObject>
                let dataDic = JsonDicHelper.getJsonDicDictionary(dic, key: "data")
                let objDic = JsonDicHelper.getJsonDicDictionary(dataDic, key: "obj")
                let coverModel = goodCoverImageModel()
                coverModel.file_id = JsonDicHelper.getJsonDicValue(objDic, key: "file_id")
                coverModel.image_url = JsonDicHelper.getJsonDicValue(objDic, key: "upyun_path")
                fileID.append(coverModel)
                
                pprLog(fileID)
                
                }, failure: nil)
            mutableOperation.append(operation)
        }
        pprLog(fileID)
        
        let operations = AFURLConnectionOperation.batchOfRequestOperations(mutableOperation, progressBlock: { (numberOfFinishedOperations:UInt, totalNumberOfOperations:UInt) -> Void in
            
            }) { (operations:[AnyObject]!) -> Void in
                MBProgressHUD.hideHUDForView(window, animated: false)
            success(fileID)
                pprLog(fileID)
        }
        NSOperationQueue.mainQueue().addOperations((operations as! [NSOperation]), waitUntilFinished: false)
    }
    
    //商品描述图片上传
    func requestUploadGoodDescripImage(images:[UIImage], success:(AnyObject)->(), fail:(String, Bool)->()){
        
        pprLog(images)
        
        let window = UIApplication.sharedApplication().keyWindow
        let hud = MBProgressHUD.showHUDAddedTo(window, animated: true)
        hud.labelText = "描述图片上传..."
        var mutableOperation:[AFHTTPRequestOperation] = []
        var imageUrl:[String] = []
        for item in images{
            let imageData = UIImageJPEGRepresentation(item, 0.3)
            let request = AFHTTPRequestSerializer().multipartFormRequestWithMethod("POST", URLString: self.urlUploadImage, parameters: nil, constructingBodyWithBlock: { (fromData:AFMultipartFormData!) -> Void in
                fromData.appendPartWithFileData(imageData!, name: "Filedata", fileName: "image.jpg", mimeType: "image/png,image/jpeg")
                }, error: nil)
            
            let operation = AFHTTPRequestOperation(request: request)
            operation.responseSerializer = AFJSONResponseSerializer()
            operation.setCompletionBlockWithSuccess({ (operation:AFHTTPRequestOperation!, responseObject:AnyObject!) -> Void in
                
                let dic = responseObject as! Dictionary<String,AnyObject>
                let dataDic = JsonDicHelper.getJsonDicDictionary(dic, key: "data")
                let objDic = JsonDicHelper.getJsonDicDictionary(dataDic, key: "obj")
                let url = JsonDicHelper.getJsonDicValue(objDic, key: "upyun_path")
                imageUrl.append(url)
                }, failure: nil)
            mutableOperation.append(operation)
        }
        let operations = AFURLConnectionOperation.batchOfRequestOperations(mutableOperation, progressBlock: { (numberOfFinishedOperations:UInt, totalNumberOfOperations:UInt) -> Void in
            
            }) { (operations:[AnyObject]!) -> Void in
                MBProgressHUD.hideHUDForView(window, animated: false)
                success(imageUrl)
                pprLog(imageUrl)
                
        }
        NSOperationQueue.mainQueue().addOperations((operations as! [NSOperation]), waitUntilFinished: false)
    }
    
    //编辑商品\添加商品
    func requestEditOrAddGoodInfo(goodInfo:ShopGoodModel, success:(AnyObject)->(), fail:(String, Bool)->()){
        let requestUrl:String
        
        var params:Dictionary<String,String> = [:]
        params["m_auth"] = LoginInfoModel.sharedInstance.m_auth
        if goodInfo.goods_id == "0"{
            requestUrl = self.urlAddGoodInfo
            self.popoverJiFen = true
        }else{
            params["goods_id"] = goodInfo.goods_id
            requestUrl = self.urlEditGoodInfo
        }
        
        params["if_show"] = "1"
        params["cate_id"] = goodInfo.cate_id
        params["cate_name"] = goodInfo.cate_name
        params["cate_second_id"] = goodInfo.cateSecendId
        params["cate_third_id"] = goodInfo.cateThridId
        params["goods_name"] = goodInfo.goods_name
        params["description"] = goodInfo.goodDescription
        params["sgcate_id[]"] = goodInfo.shopCate_id
        params["orige_price"] = goodInfo.orige_price
        params["price"] = goodInfo.price
        params["stock"] = goodInfo.stock
        
        pprLog(goodInfo.goodCoverImages.count)
        for var i=0;i<goodInfo.goodCoverImages.count;i++ {
            let key = "goods_file_id[\(i)]"
            params[key] = goodInfo.goodCoverImages[i].file_id
        }
        
        pprLog(goodInfo.goodDescripImages.count)
        for var i=0;i<goodInfo.goodDescripImages.count;i++ {
            let key = "desc_file_url[\(i)]"
            params[key] = goodInfo.goodDescripImages[i]
        }
        
        self.networkPost(requestUrl, params: params, success: success, fail: fail)
    }
    
    //销售额
    func requestSaleCountList(dayNum:Int, success:(AnyObject)->(), fail:(String, Bool)->()){
        var params:Dictionary<String,String> = [:]
        params["m_auth"] = LoginInfoModel.sharedInstance.m_auth
        params["daynum"] = String(dayNum)
        self.networkPost(self.urlSaleCountList, params: params, success: success, fail: fail)
    }
    
    //城市列表
    func requestCityList(success:(AnyObject)->(), fail:(String, Bool)->()){
        self.networkPost(self.urlCityList, params: nil, success: success, fail: fail)
    }
    
    //订单操作 type:操作类型(1：确认发货 2：取消订单 3：确认退货 4：拒绝退货)
    func requestFinistOrder(type:Int, orderId:String, success:(AnyObject)->(), fail:(String, Bool)->()){
        var params:Dictionary<String,String> = [:]
        params["m_auth"] = LoginInfoModel.sharedInstance.m_auth
        params["order_id"] = orderId
        
        let typeCode:String
        switch type{
        case 1:
            typeCode = ""
            self.popoverJiFen = true
        case 2:
            typeCode = "cancel_order"
        case 3:
            typeCode = "return_goods"
        case 4:
            typeCode = "reject_return_goods"
        default:
            typeCode = ""
        }
        
        params["type"] = typeCode
        self.networkPost(self.urlFinishOrder, params: params, success: success, fail: fail)
    }
    
    //根据地区ID获取小区列表
    func requestXiaoQuList(locationId:String, success:(AnyObject)->(), fail:(String, Bool)->()){
        var params:Dictionary<String,String> = [:]
        params["locationid"] = locationId
        self.networkPost(self.urlXiaoQuList, params: params, success: success, fail: fail)
    }
    
    //修改覆盖小区
    func requestChangeXiaoQu(xiaoQuIds:[String], success:(AnyObject)->(), fail:(String, Bool)->()){
        var params:Dictionary<String,String> = [:]
        params["m_auth"] = LoginInfoModel.sharedInstance.m_auth
        params["ios"] = "1"
        let dic = ["xiaoqu_ids":xiaoQuIds]
        let jsonString = self.dictionaryJson(dic)
        params["xiaoqu_ids"] = jsonString
        self.networkPost(self.urlChangeXiaoQu, params: params, success: success, fail: fail)
    }
    
    //单个用户消息列表
    func requestUserNewsList(userId:String, currPage:Int, pageNum:Int, success:(AnyObject)->(), fail:(String, Bool)->()){
        var params:Dictionary<String,String> = [:]
        params["m_auth"] = LoginInfoModel.sharedInstance.m_auth
        params["uid"] = userId
        params["page"] = String(currPage)
        params["perpage"] = String(pageNum)
        self.networkPost(self.urlUserNewsList, params: params, success: success, fail: fail)
    }
    
    //根据订单ID获取订单详情
    func requestOrderInfo(orderId:String, success:(AnyObject)->(), fail:(String, Bool)->()){
        var params:Dictionary<String,String> = [:]
        params["m_auth"] = LoginInfoModel.sharedInstance.m_auth
        params["order_id"] = orderId
        pprLog(params)
        pprLog(orderId)
        self.networkPost(self.urlOrderInfo, params: params, success: success, fail: fail)
    }
    
    //二维码扫描获取订单详情
    func requestSweepOrderInfo(scanStr:String, success:(AnyObject)->(), fail:(String, Bool)->()){
        var params:Dictionary<String,String> = [:]
        params["m_auth"] = LoginInfoModel.sharedInstance.m_auth
        params["qrcode"] = scanStr
        self.networkPost(self.urlSweepOrderInfo, params: params, success: success, fail: fail)
    }
    
//    //商家未读消息总数
//    func requestUnreadNewsTotal(success:(AnyObject)->(), fail:(String, Bool)->()){
//        var params:Dictionary<String,String> = [:]
//        params["m_auth"] = LoginInfoModel.sharedInstance.m_auth
//        self.networkPost(self.urlUnreadNewsTotal, params: params, success: success, fail: fail)
//    }

    //更改商家覆盖范围
    func requestChangeShopRadius(radius:String, success:(AnyObject)->(), fail:(String, Bool)->()){
        var params:Dictionary<String,String> = [:]
        params["m_auth"] = LoginInfoModel.sharedInstance.m_auth
        params["service_type"] = "1" //服务范围类型（1：半径覆盖，2：城市覆盖）
        params["radius"] = radius
        self.networkPost(self.urlChangeShopRadius, params: params, success: success, fail: fail)
    }
    
    //发现列表
    func requestDiscoveryList(success:(AnyObject)->(), fail:(String, Bool)->()){
        var params:Dictionary<String,String> = [:]
        params["m_auth"] = LoginInfoModel.sharedInstance.m_auth
        self.networkPost(self.urlDiscoveryList, params: params, success: success, fail: fail)
    }
    
    //发现更新
    func requestDiscoveryUpdate(success:(AnyObject)->(), fail:(String, Bool)->()){
        var params:Dictionary<String,String> = [:]
        params["m_auth"] = LoginInfoModel.sharedInstance.m_auth
        self.networkPost(self.urlDiscoveryUpdate, params: params, success: success, fail: fail)
    }
    
    //feed流(未登录)
    func requestFeedListUnlogin(showLoading:Bool, lng:Double, lat:Double, currPage:Int, pageNum:Int, success:(AnyObject)->(), fail:(String, Bool)->()){
        var params:Dictionary<String,String> = [:]
        params["page"] = String(currPage)
        params["perpage"] = String(pageNum)
        params["lng"] = String(stringInterpolationSegment: lng)
        params["lat"] = String(stringInterpolationSegment: lat)
        if showLoading == true{
            self.networkPost(self.urlFeedListUnlogin, params: params, success: success, fail: fail)
        }else{
            self.networkPostNotLoading(self.urlFeedListUnlogin, params: params, success: success, fail: fail)
        }
    }
    
//    嗲几家就打  
    //feed流(已登录)
    func requestFeedListLogin(showLoading:Bool, lng:Double, lat:Double,currPage:Int, pageNum:Int, success:(AnyObject)->(), fail:(String, Bool)->()){
        var params:Dictionary<String,String> = [:]
        params["m_auth"] = LoginInfoModel.sharedInstance.m_auth
        params["page"] = String(currPage)
        params["perpage"] = String(pageNum)
        params["store_id"] = LoginInfoModel.sharedInstance.store.store_id
//        params["lng"] = String(stringInterpolationSegment: lng)
//        params["lat"] = String(stringInterpolationSegment: lat)
        if showLoading == true{
            self.networkPost(self.urlFeedListLogin, params: params, success: success, fail: fail)
        }else{
            self.networkPostNotLoading(self.urlFeedListLogin, params: params, success: success, fail: fail)
        }
        
    }
    
    //获取商家状态信息
    func requestShopStatus(success:(AnyObject)->(), fail:(String, Bool)->()){
        var params:Dictionary<String,String> = [:]
        params["m_auth"] = LoginInfoModel.sharedInstance.m_auth
        self.networkPostNotLoading(self.urlShopStatus, params: params, success: success, fail: fail)
    }
    
    // MARK: - 手机短信验证
    func requestGetSecurityCode(phoneNum:String, success:(AnyObject)->(), fail:(String, Bool)->()){
        var params:Dictionary<String,String> = [:]
        params["m_auth"] = LoginInfoModel.sharedInstance.m_auth
        params["phone_number"] = phoneNum
        self.networkPost(self.urlGetSecurityCode, params: params, success: success, fail: fail)
    }

    func requestCheckSecurityCode(phoneNum:String,securityCode:String, success:(AnyObject)->(), fail:(String, Bool)->()){
        var params:Dictionary<String,String> = [:]
        params["m_auth"] = LoginInfoModel.sharedInstance.m_auth
        params["phone_number"] = phoneNum
        params["security_code"] = securityCode
        
        pprLog(params)
        self.networkPost(self.urlCheckSecurityCode, params: params, success: success, fail: fail)
    }

    // MARK: - 提交店铺资料
    func requestUpdateStoreInfo(account:RegisterModel, success:(AnyObject)->(), fail:(String, Bool)->()){
        
        //logo;
        var headUrl = ""
        let imageData = UIImageJPEGRepresentation(account.headIcon!, 0.3)
        
        self.networkUploadImage(self.urlUploadImage, params: nil, imageData: imageData!, imageParamsKey: "Filedata", imageUploadName: "headIcon.jpg", success: { (jsonDic:AnyObject) -> () in
            let dic = jsonDic as! Dictionary<String,AnyObject>
            let dataDic = JsonDicHelper.getJsonDicDictionary(dic, key: "data")
            let objDic = JsonDicHelper.getJsonDicDictionary(dataDic, key: "obj")
            headUrl = JsonDicHelper.getJsonDicValue(objDic, key: "thumb_ios")
            
            pprLog("\(headUrl)")
            //显示上传进度；
            let window = UIApplication.sharedApplication().keyWindow
            MBProgressHUD.showHUDAddedTo(window, animated: true)
            var mutableOperation:[AFHTTPRequestOperation] = []
            
            //上传证件照片
            var cardUrl:[String] = []
            
            for item in account.cardImage{
                let imageData = UIImageJPEGRepresentation(item, 0.3)
                
                let request = AFHTTPRequestSerializer().multipartFormRequestWithMethod("POST", URLString: self.urlUploadImage, parameters: nil, constructingBodyWithBlock: { (fromData:AFMultipartFormData!) -> Void in
                    fromData.appendPartWithFileData(imageData!, name: "Filedata", fileName: "image.jpg", mimeType: "image/png,image/jpeg")
                    }, error: nil)
                
                let operation = AFHTTPRequestOperation(request: request)
                operation.responseSerializer = AFJSONResponseSerializer()
                operation.setCompletionBlockWithSuccess({ (operation:AFHTTPRequestOperation!, responseObject:AnyObject!) -> Void in
                    
                    let dic = responseObject as! Dictionary<String,AnyObject>
                    let dataDic = JsonDicHelper.getJsonDicDictionary(dic, key: "data")
                    let objDic = JsonDicHelper.getJsonDicDictionary(dataDic, key: "obj")
                    cardUrl.append(JsonDicHelper.getJsonDicValue(objDic, key: "thumb_ios"))
                    }, failure: nil)
                mutableOperation.append(operation)
            }
            
            
            let operations = AFURLConnectionOperation.batchOfRequestOperations(mutableOperation, progressBlock: { (numberOfFinishedOperations:UInt, totalNumberOfOperations:UInt) -> Void in
                
                }) { (operations:[AnyObject]!) -> Void in
                    MBProgressHUD.hideHUDForView(window, animated: false)
                    var params:Dictionary<String,String> = [:]
                    params["cate_id"] = account.cate_id
                    params["store_name"] = account.stroe_name
                    params["real_name"] = account.real_name
                    params["province"] = account.province
                    params["city"] = account.city
                    params["area"] = account.area
                    params["lng"] = account.lng
                    params["lat"] = account.lat
                    params["tel"] = account.tel
                    params["address"] = account.address
                    params["m_auth"] = account.mAuth
                    params["logo"] = headUrl
                    params["service_type"] = "1"//1：半径覆盖，2：城市覆盖
                    params["radius"] = account.radius
                    
                    //店铺公告；
                    params["description"] = account.description_t
                    //推荐人；
                    params["recommend_info"] = account.recommendInfo
                    pprLog(cardUrl.count)
                    if cardUrl.count > 0 {
                        var cardImages = cardUrl.first!
                        for var i=1;i<cardUrl.count;i++ {
                            cardImages += ",\(cardUrl[i])"
                        }
                        params["id_images"] = cardImages
                    }
                    
                    self.networkPost(self.urlUpdateStoreInfo, params: params, success: success, fail: fail)
                    pprLog("\(params)")
            }
            NSOperationQueue.mainQueue().addOperations((operations as! [NSOperation]), waitUntilFinished: false)
            
            }, fail: fail)
    }

    //获取商家销售信息
    func requestGetAllSaleInfo(success:(AnyObject)->(), fail:(String, Bool)->()) {
        var params:Dictionary<String,String> = [:]
        params["m_auth"] = LoginInfoModel.sharedInstance.m_auth
        self.networkPostNotLoading(self.urlGetAllSaleInfo, params: params, success: success, fail: fail)
    }
    
    //企业发布版本检测
    func requestCompanyVersionCheck(success:(AnyObject)->(), fail:(String, Bool)->()){
        var params:Dictionary<String,String> = [:]
        params["project"] = "ios"
        self.networkPostNotLoading(self.urlCompanyVersionCheck, params: params, success: success, fail: fail)
    }
    
    //绑定帐号接口
    func requestBindAccount(name:String, password:String, success:(AnyObject)->(), fail:(String, Bool)->()){
        var params:Dictionary<String,String> = [:]
        params["m_auth"] = LoginInfoModel.sharedInstance.m_auth
        params["bind_type"] = "weixin_bind_username"
        params["user_name"] = name
        params["password"] = password
        params["openid"] = LoginInfoModel.sharedInstance.openid
        self.networkPost(self.urlBindAccount, params: params, success: success, fail: fail)
    }
    
    //重设密码
    func requestChangePassword(oldPassword:String, newPassword:String, success:(AnyObject)->(), fail:(String, Bool)->()){
        var params:Dictionary<String,String> = [:]
        params["m_auth"] = LoginInfoModel.sharedInstance.m_auth
        params["resettype"] = "store_login"
        params["old_password"] = oldPassword
        params["new_password"] = newPassword
        self.networkPost(self.urlChangePassword, params: params, success: success, fail: fail)
    }
    
    // MARK: - 进货商品发布成功；
    func requestBoughtGoodUpFinish(orderRecId:String, success:(AnyObject)->(), fail:(String, Bool)->()){
        var params:Dictionary<String,String> = [:]
        params["m_auth"] = LoginInfoModel.sharedInstance.m_auth
        params["order_rec_id"] = orderRecId
        self.networkPost(self.urlBoughtGoodUpFinish, params: params, success: success, fail: fail)
    }
    
    //我的店铺列表
    func requestMyShopList(success:(AnyObject)->(), fail:(String, Bool)->()){
        var params:Dictionary<String,String> = [:]
        params["m_auth"] = LoginInfoModel.sharedInstance.m_auth
        self.networkPost(self.urlMyShopList, params: params, success: success, fail: fail)
    }
    
    //我的店铺列表更新
    func requestMyShopListUpdate(success:(AnyObject)->(), fail:(String, Bool)->()){
        var params:Dictionary<String,String> = [:]
        params["m_auth"] = LoginInfoModel.sharedInstance.m_auth
        self.networkPost(self.urlMyShopListUpdate, params: params, success: success, fail: fail)
    }

    //广告
    func requestAdvertisingInfo(success:(AnyObject)->(), fail:(String, Bool)->()){
        var params:Dictionary<String,String> = [:]
         params["app_type"] = "1"
        self.networkPostNotLoading(self.urlAdvertisingInfo, params: params, success: success, fail: fail)
    }
    //广告点击量统计
    func requestAdvertisingClickNumbe(ad_id:String,success:(AnyObject)->(), fail:(String, Bool)->()){
        var params:Dictionary<String,String> = [:]
        params["click_num"] = "1"
        params["ad_id"] = ad_id
        self.networkPostNotLoading(self.urlAdvertisingClickNumbe, params: params, success: success, fail: fail)
    }


    //HX登录
    func requestGetHXAccount(success:(AnyObject)->(), fail:(String, Bool)->()) {
        var params:Dictionary<String,String> = [:]
        params["userid"] = LoginInfoModel.sharedInstance.uid
        self.networkPost(self.urlGetHXAccount, params: params, success: success, fail: fail)
    }
    
    // 当面付勾选商品
    func requestFaceOrderCheckShop(orderID:String, goodsID: String , goodsNums:String ,success: (AnyObject)->(), fail:(String, Bool)->()){
        
        var params:Dictionary<String,String> = [:]
        params["m_auth"] = LoginInfoModel.sharedInstance.m_auth
        params["order_id"] = orderID
        params["goods_ids"] = goodsID
        params["goods_nums"] = goodsNums
        self.networkPost(self.urlFaceOrderCheckShop, params: params, success: success, fail: fail)
        
    }
    
    //当面付确认收货
    func requestFaceOrderConfirmreceipt(orderID:String ,success:(AnyObject) ->() ,fail:(String,Bool)->()){
        
        var params:Dictionary<String,String> = [:]
        
        params["m_auth"] = LoginInfoModel.sharedInstance.m_auth
        
        params["order_id"] = orderID
        
        
        self.networkPost(self.urlFaceOrderConfirmReceipt, params: params, success: success, fail: fail)
        
    }
    
    
}