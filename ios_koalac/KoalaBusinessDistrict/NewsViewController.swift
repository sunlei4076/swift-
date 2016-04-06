//
//  KoalacNewsViewController.swift
//  KoalaBusinessDistrict
//
//  Created by twksky on 15/12/17.
//  Copyright © 2015年 koalac. All rights reserved.
//

import UIKit

//标识是否显示广告
var isShowAdvistFlag:Bool = false

class NewsViewController: UIViewController,UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate {
    
    var  advertisingM:advertisingModel = advertisingModel()
    // MARK - property
    @IBOutlet weak var tableView: UITableView!
    
    private var newsList:[NewsModel] = [] //最后展示数组
    private var newsListOriData:[NewsModel] = [] //最新商机，商家小助手
    private var newsListHXData:[NewsModel] = [] //环信对象数组
    private var currPage:Int = 0
    var imageViewForBackGroud:UIImageView? //消息背景图
    var labelForBackGroud:UILabel? //消息文案
    var headIconImageBlock:((imageURLList:[CustomerModel])->())? //环信主动发消息的头像获取
//    var urlImage:String = "" //HX主动发消息情况下获取头像
//    var useNickName:String = "" //HX主动发消息情况下获取昵称
     private var customerList:[CustomerModel] = [] //服务器数组
    //系统未读消息，貌似没有用，因为系统接口有返回
    private var systemUnreadMessageCount:Int = 0{
        didSet{
            //TODO :暂时不用管
        }
    }
    //最近未读消息
    private var recentlyUnreadMessageCount:Int = 0{
        didSet{
            if recentlyUnreadMessageCount == 0{
                if self.navigationController == nil{
                    pprLog("ppppp")
                }else{
                    self.navigationController!.tabBarItem.badgeValue = nil
                }
                //self.navigationController!.tabBarItem.badgeValue = nil
            }else{
                if (self.tabBarItem.badgeValue != nil) {
                    if self.navigationController == nil{
                    }else{
                        self.navigationController!.tabBarItem.badgeValue = String( Int(self.tabBarItem.badgeValue!)! + recentlyUnreadMessageCount)
                    }
                    //                    self.navigationController!.tabBarItem.badgeValue = String( Int(self.tabBarItem.badgeValue!)! + recentlyUnreadMessageCount)
                }else{
                    if self.navigationController == nil{
                    }else{
                        self.navigationController!.tabBarItem.badgeValue = String(recentlyUnreadMessageCount)
                    }
                    //                    self.navigationController!.tabBarItem.badgeValue = String(recentlyUnreadMessageCount)
                }
            }
        }
    }
        
    private var recentlyContactArray:NSMutableArray = []
    
    internal func refreshEaseMob(){
        
        self.getConversationWithMessage("firstCallNew")
        let conversations:NSArray = EaseMob.sharedInstance().chatManager!.conversations!
        var unreadCount:Int = 0
        for conversation in conversations{
            let num:Int = Int(conversation.unreadMessagesCount())
            unreadCount = num + unreadCount
        }
        self.recentlyUnreadMessageCount = unreadCount
    }
    
    // MARk: - VCCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.headIconImageBlock = {
            (imageURLList) -> () in
            self.customerList = imageURLList
             self.getConversationWithMessage("")
        }
        //是否显示广告
        self.adtistRequsetNet()
        self.newsList.removeAll(keepCapacity: true)
        self.newsListOriData.removeAll(keepCapacity: true)
        self.newsListHXData.removeAll(keepCapacity: true)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("refreshEaseMob"), name: "refreshEaseMob", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("notificationFunction"), name: "ChangeLogin", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("notifiChangeStoreStatus"), name: "ChangeStoreStatus", object: nil)
        self.initControl()
        //第一次进来
        self.initData("firstComing")
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        if jPushJump.isJPJump  {
            if jPushJump.jPTitle.isEmpty == false {
                let webJPushVC = webHelper.openWebVC(jPushJump.jPTitle, jumpURL:jPushJump.jPURL)
                pprLog(self.navigationController)
                self.navigationController?.pushViewController(webJPushVC, animated: true)
            }
        }
                self.initData("tabcoming")
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidAppear(true)
        
        if jPushJump.isJPJump == true {
            
            jPushJump = (false, "" ,"")
        }
    }
    
    // MARk: - Method
    internal func initControl(){
        GNavgationStyle(self.navigationController!.navigationBar)
        let rightBtn = self.rightBtnItem()
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: rightBtn)
        
        self.tableView.registerNib(UINib(nibName: "NewsCell", bundle: nil), forCellReuseIdentifier: NewsCell.cellIdentifier())
        self.tableView.backgroundColor = GlobalBgColor
        //数据为空的时候添加背景图片
        let imageBackGround = UIImage.init(named: "imageForMessageBG")
        self.imageViewForBackGroud = UIImageView.init(image: imageBackGround)
        self.imageViewForBackGroud?.center.x = self.view.center.x
        self.imageViewForBackGroud?.center.y = self.view.center.y - (self.imageViewForBackGroud?.frame.size.height)!/2 - 20
        self.labelForBackGroud = UILabel.init()
        self.labelForBackGroud?.textAlignment = NSTextAlignment.Center
        self.labelForBackGroud?.text = "暂时没有新消息～快和你的客户互动吧！"
        self.labelForBackGroud?.textColor = UIColor.init(red: 148.0/255, green: 148.0/255, blue: 148.0/255, alpha: 1)
        self.labelForBackGroud?.center.x = self.view.center.x
        self.labelForBackGroud?.center.y = self.view.center.y + (self.imageViewForBackGroud?.frame.size.height)!
        self.labelForBackGroud?.frame = CGRectMake(0, CGRectGetMaxY(self.imageViewForBackGroud!.frame)-10, self.view.frame.width, 70)
        self.view.addSubview(self.imageViewForBackGroud!)
        self.view.addSubview(self.self.labelForBackGroud!)
        self.imageViewForBackGroud?.hidden = true
        self.labelForBackGroud?.hidden = true

    }

    func notificationFunction(){
        let rightBtn =  rightBtnItem()
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: rightBtn)
        self.refreshEaseMob()
        if LoginInfoModel.sharedInstance.m_auth.isEmpty == false{
            self.currPage = 0
            self.initData("n")
        }
    }
    
    func notifiChangeStoreStatus(){
        let rightBtn =  rightBtnItem()
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: rightBtn)
    }
    
    func rightBtnItem() -> UIButton {
        let rightBtn:UIButton = UIButton(type:UIButtonType.Custom)
        var rightBtnTitle: String?
        if LoginInfoModel.sharedInstance.shopStatus == "1" || LoginInfoModel.sharedInstance.shopStatus == "0" {
            rightBtnTitle =  "推广"
        }
        else {
            rightBtnTitle =  "开店"
        }
        rightBtn.setTitle(rightBtnTitle, forState: UIControlState.Normal)
        rightBtn.titleLabel?.font = GGetNormalCustomFont()
        rightBtn.frame = CGRectMake(0, 0, 40, 30)
        rightBtn.addTarget(self, action: Selector("shareAction"), forControlEvents: UIControlEvents.TouchUpInside)
        return rightBtn
    }
    
    func shareAction(){
        if LoginInfoModel.sharedInstance.shopStatus == "1"
        {
            let shareView = ShareView.instantiateFromNib()
            shareView.show()
        }
        else if LoginInfoModel.sharedInstance.shopStatus == "0" {
            let alert = UIAlertView(title: "提示", message: "亲，您的店铺正在审核中", delegate: self, cancelButtonTitle: "联系客服", otherButtonTitles: "我知道了")
            alert.show()
        }
        else if LoginInfoModel.sharedInstance.shopStatus == "4" {
            let alert = UIAlertView(title: "提示", message: "店铺审核不通过", delegate: self, cancelButtonTitle: "重新申请", otherButtonTitles: "我知道了")
            alert.show()
        }
        else {
            let register = RegisteriPhoneIdentifyController(nibName:"RegisteriPhoneIdentifyController", bundle:nil)
            register.hidesBottomBarWhenPushed = true
            self.navigationController!.pushViewController(register, animated: true)
        }
    }
    
    private func endRefresh(){
        if self.tableView.footer.isRefreshing(){
            self.tableView.footer.endRefreshing()
        }
        if self.tableView.header.isRefreshing(){
            self.tableView.header.endRefreshing()
        }
    }
    
    private func initData(firstTime:String){

        //1.会话列表
        self.convenienceKoalac(firstTime)

    }
    
    func convenienceKoalac(nuberTime:String){
        self.getConversationWithMessage(nuberTime)
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.newsList.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCellWithIdentifier(NewsCell.cellIdentifier(), forIndexPath: indexPath) as! NewsCell
        cell.selectionStyle = UITableViewCellSelectionStyle.Gray
        cell.cellData = self.newsList[indexPath.row]

        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let model = self.newsList[indexPath.row]
//        let newsDetailVC = NewsDetailViewController(nibName:"NewsDetailViewController",bundle:nil)
        let newsDetailVC = NewsDetailViewController()
//        newsDetailVC.telphoneUser = (model.hx_ext?.hx_disp_tel)!
        newsDetailVC.HXID = model.hxid
        newsDetailVC.userName = model.userName
        newsDetailVC.userId = model.uid
        newsDetailVC.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(newsDetailVC, animated: true)
        
        //更新未读消息数目
        let userUnreadNum = (model.unreadNum as NSString).integerValue
        
        if let unreadNumTotalStr = self.navigationController?.tabBarItem.badgeValue
        {
            var unreadNumTotal = Int(unreadNumTotalStr)
            if unreadNumTotal! - userUnreadNum > 0{
                self.navigationController?.tabBarItem.badgeValue = String(unreadNumTotal! - userUnreadNum)
            }else{
                self.navigationController?.tabBarItem.badgeValue = nil
            }
            unreadNumTotal! -= 1
        }
        model.unreadNum = "0"
        tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.None)
    }

    // MARK:- alertViewDelegate
    func alertView(alertView: UIAlertView, clickedButtonAtIndex buttonIndex: Int){
        let buttonStr = alertView.buttonTitleAtIndex(buttonIndex)
        if buttonStr == "联系客服" {
            UIApplication.sharedApplication().openURL(NSURL(string: "tel://4000588577")!)
        }
        else if buttonStr == "重新申请"{
            let setShopInfo = SetShopInfoViewController(nibName:"SetShopInfoViewController", bundle:nil)
            setShopInfo.hidesBottomBarWhenPushed = true
            self.navigationController!.pushViewController(setShopInfo, animated: true)
            
        }
    }
    
    //这个用户在聊天列表里面存在
    func containRecentlyContactWithUserID(userID userID:String) -> Bool{
        if self.newsListHXData.count != 0
        {
            let sameElement:Bool = false
            let hx_messageModel = NewsModel()
            for tempModel in self.newsListHXData
            {
                if hx_messageModel.uid == tempModel.uid {
                    return true
                }
            }
            return sameElement;
        }
        return true
    }
    
    // MARk: - ManagerMethod
    func getContactIndexWithUserID(userID:NSString) -> (NSInteger){
        let contact = self.getContactWithUserID(userID)
        return self.recentlyContactArray.indexOfObject(contact)
    }
    
    func getContactWithUserID(userID:NSString) -> AnyObject{
        return 0
    }
    
    func unreadMessage(){
        let conversations:NSArray = EaseMob.sharedInstance().chatManager!.conversations!
        var unreadCount:Int = 0
        //        let _:EMConversation
        for conversation in conversations{
            let num:Int = Int(conversation.unreadMessagesCount())
            //            self.updateUnreadCount(count: num, userID: conversation.chatter)
            for model in self.newsList{
                conversation.messageBodies
                let uid = "lq_" + model.uid as NSString
                if uid.isEqualToString(conversation.chatter){
                    model.unreadNum = String(num)
                }
            }
            unreadCount = num + unreadCount
        }
        if (self.tableView != nil){
            self.tableView.reloadData()
        }
        self.recentlyUnreadMessageCount = unreadCount;//更新下面的小圆点
    }
    //数组按时间排序
    func sortMessageArray(){
        self.newsListHXData.sortInPlace { (a:NewsModel, b:NewsModel) -> Bool in
            if  a.newDate > b.newDate
            {
                return true
            }
            return false
        }
    }
    
    
    // 根据text类型EMMessage得到一个text类型模型
    // func getOneTextMessageModel(hx_message:EMMessage)->HXEMMessageForTextModel
    
    //根据会话页面消息体合会话对象返回一个模型-不是通用方法[头像和昵称去对方最后一条消息，消息内容和时间取整个列表最后一条]
    func getMessageModel(latest_otherMessage:EMMessage,latest_conversation:EMConversation,imageURLstr:String,useNickName:String)->NewsModel{
        
        let hx_messageModel = NewsModel()
        let latest_m:EMMessage = latest_conversation.latestMessage()
        if latest_otherMessage.ext != nil
        {
            //消息体内扩展模型
            let messageExt = latest_otherMessage.ext as! Dictionary<String,AnyObject>
            let modelExt = XHMessageExtModel.init(ext:messageExt)
            hx_messageModel.hx_ext = modelExt
                 hx_messageModel.userHeadIcon = (hx_messageModel.hx_ext?.hx_avator)!
            hx_messageModel.userName = (hx_messageModel.hx_ext?.hx_nickname)!
        }else {
            hx_messageModel.userHeadIcon = imageURLstr
            hx_messageModel.userName = useNickName
        }
        
        //最后一条消息时间戳，有可能是自己有可能是对方
        hx_messageModel.newDate = String(latest_m.timestamp / 1000)
        //取消息体
        let latestMessageBody = latest_m.messageBodies.first
        //判断消息体类型
        if latestMessageBody is EMTextMessageBody
        {
            let latestStr = latestMessageBody as! EMTextMessageBody
            //消息内容
            hx_messageModel.lastNew = latestStr.text
        }
        //get uid from hxid
        let hxid:String = latest_conversation.chatter
        hx_messageModel.hxid = latest_conversation.chatter
        let index = hxid.startIndex.advancedBy(3)
        let useid  = hxid.substringFromIndex(index)
        hx_messageModel.uid = useid
        
        return hx_messageModel
    }
    
    //获取会话数据
    func getConversationWithMessage(numberTime:String){

        self.newsListOriData = []
        self.newsListHXData = []
        self.newsList = []
        if (self.tableView != nil){
            self.tableView.reloadData()
        }
        if let conversations:NSArray? = EaseMob.sharedInstance().chatManager.loadAllConversationsFromDatabaseWithAppend2Chat!(true)
        {


            if conversations?.count != 0
            {
                for tempMessage in conversations!
                {
                    let  latest_conversation = tempMessage as! EMConversation
                    NSLog("%@", latest_conversation.chatter)
                    
                    //1.获取最近联系人的数组
                    
                    //2.获取最后一条对话
                    
                    

                    if let latest_message:EMMessage = latest_conversation.latestMessageFromOthers()
                    {
                         pprLog("====***1**===[\(latest_conversation.chatter)]=")
                        //1.得到EMMessage模型
                        let hx_messageModel:NewsModel =      self.getMessageModel(latest_message, latest_conversation: latest_conversation,imageURLstr:"",useNickName:"")
                        
                        //2.添加会话对象到列表数组
                        if hx_messageModel.uid == "1" || hx_messageModel.uid == "2" {
                            self.newsListOriData.append(hx_messageModel)
                        }else{
                            self.newsListHXData.append(hx_messageModel)
                        }
                        //3.数组按时间排序
                        self.sortMessageArray()
                        //4.拼接最新商机商圈小助手数组和聊天数组
                        self.newsList = self.newsListOriData + self.newsListHXData
                        if self.newsList.count != 0 {
                            self.imageViewForBackGroud?.hidden = true
                            self.labelForBackGroud?.hidden = true
                        }
                        if (self.tableView != nil){
                            self.tableView.reloadData()
                        }
                        self.unreadMessage()
                        
                    }else{

                        if let latest_messageForMe:EMMessage = latest_conversation.latestMessage() {

                            if self.customerList.count == 0{

                            }else{
                                for temp in self.customerList {

                                    let hxid = "lq_" + temp.uid
                                    if  hxid == latest_messageForMe.to{

                                        let hx_messageModel:NewsModel = self.getMessageModel(latest_messageForMe, latest_conversation: latest_conversation,imageURLstr:temp.avatar,useNickName:temp.name)
                                        self.newsListHXData.append(hx_messageModel)
                                        
                                    }
                                    
                                    
                                }}

                            self.newsList =  self.newsListOriData + self.newsListHXData
                            if self.newsList.count != 0 {
                                self.imageViewForBackGroud?.hidden = true
                                self.labelForBackGroud?.hidden = true
                            }
                            
                            if (self.tableView != nil){
                                self.tableView.reloadData()
                            }
                        }

                    }
                }
                
            }else{
                self.imageViewForBackGroud?.hidden = false
                self.labelForBackGroud?.hidden = false
                
            }
        }else{
            if self.newsList.count == 0 {
                self.imageViewForBackGroud?.hidden = false
                self.labelForBackGroud?.hidden = false
            }

            
        }


        
    }
    
    //是否显示广告
    func adtistRequsetNet(){
        
        let rootVC = ProjectManager.sharedInstance.getRootTab()
        NetworkManager.sharedInstance.requestAdvertisingInfo({ (jsonDic:AnyObject) -> () in
            let dic = jsonDic as! Dictionary<String,AnyObject>
            let dataDic = JsonDicHelper.getJsonDicDictionary(dic, key: "data")
            let objDic = JsonDicHelper.getJsonDicDictionary(dataDic, key: "obj")
            self.advertisingM = advertisingModel(jsonDic: objDic)
            
            let defaults = NSUserDefaults.standardUserDefaults()
            let old_ad_id = defaults.objectForKey("ad_id") as? String
            let old_clickIndex = defaults.objectForKey("clickIndex") as? String
            
            //判断图片ID
            if old_ad_id != self.advertisingM.ad_id  //新图片
            {   //没有广告时候
                if self.advertisingM.ad_id.isEmpty {
                    ProjectManager.sharedInstance.versionCheck()
                }else{
                    defaults.setObject(self.advertisingM.ad_id, forKey: "ad_id")
                    defaults.setObject("0", forKey: "clickIndex")
                    defaults.synchronize()
                    let advistVC = ADViewController(nibName:"ADViewController",bundle:nil)
                    advistVC.advertisingM = self.advertisingM
                    advistVC.view.backgroundColor = UIColor(red: 1/255.0, green: 1/255.0, blue: 1/255.0, alpha: 0.8)
                    rootVC.presentViewController(advistVC, animated: true, completion: nil)
                    
                    isShowAdvistFlag = true
                }
            }else{ //旧图片
                if self.advertisingM.is_need_click == "0" {//0是不强制点击
                    ProjectManager.sharedInstance.versionCheck()
                }else {
                    if old_clickIndex == "1" {//1是已经点击
                        ProjectManager.sharedInstance.versionCheck()
                    }else{
                        let advistVC = ADViewController(nibName:"ADViewController",bundle:nil)
                        advistVC.advertisingM = self.advertisingM
                        advistVC.view.backgroundColor = UIColor(red: 1/255.0, green: 1/255.0, blue: 1/255.0, alpha: 0.8)
                        rootVC.presentViewController(advistVC, animated: true, completion: nil)
                        
                        isShowAdvistFlag = true
                    }
                }
            }
            }, fail: { (error:String, needRelogin:Bool) -> () in
                if needRelogin == true{
                    //                                         GShowAlertMessage(error)
                    ProjectManager.sharedInstance.versionCheck()
                }else{
                    //                                        GShowAlertMessage(error)
                    ProjectManager.sharedInstance.versionCheck()
                }
        })
        
    }
    
    
    private func startLocationWithBlock(success:(()->()),fail:(()->())){
        pprLog("定位中")
        //保证已经获取到地理位置
        if ProjectManager.sharedInstance.currLocate == nil{
            //显示loading
            let window = UIApplication.sharedApplication().keyWindow
            let hud = MBProgressHUD.showHUDAddedTo(window, animated: true)
            hud.labelText = "定位中..."
            LocateTool.shareInstance().startLocationWithReverse(true, success: { (result:BMKReverseGeoCodeResult!, location:BMKUserLocation!) -> Void in
                MBProgressHUD.hideHUDForView(window, animated: false)
                
                ProjectManager.sharedInstance.currLocate = result
                success()
                
                }, fail: { () -> Void in
                    
                    GShowAlertMessage("请允许定位服务！")
                    MBProgressHUD.hideHUDForView(window, animated: false)
                    fail()
                    
            })
        }else{
            success()
        }
    }
    
    func loginNormal(){
        // 跳转到登录界面
        //添加账号
        let rootVC = ProjectManager.sharedInstance.getRootTab()
        let loginVC = LoginViewController(nibName:"LoginViewController", bundle:nil)
        loginVC.showLastLoginInfo = false
        //更新登陆界面1202
        loginVC.view.backgroundColor = UIColor(red: 1/255.0, green: 1/255.0, blue: 1/255.0, alpha: 0.6)
        rootVC.presentViewController(loginVC, animated: true, completion: nil)
    }
    
    func wechatLogin(){
        //  直接微信登录
        
        //微信登陆
        WXApiTool.sharedInstance.sendAuthRequest({ (jsonDic:AnyObject) -> () in
            //成功
            
            //HX帐号注销
            if HXMessageModel.sharedHXInstance.hxUsername.isEmpty == false {
                
                EaseMob.sharedInstance().chatManager.asyncLogoffWithUnbindDeviceToken(true)
            }
            
            let dic = jsonDic as! Dictionary<String, AnyObject>
            let dataDic = JsonDicHelper.getJsonDicDictionary(dic, key: "data")
            let objDic = JsonDicHelper.getJsonDicDictionary(dataDic, key: "obj")
            LoginInfoModel.sharedInstance.setDataWithJson(objDic)
            
            //环信
            ProjectManager.sharedInstance.loginToHX({ () -> () in
                //跳转到主页
                self.dismissViewControllerAnimated(true, completion: nil)
                let rootVC = ProjectManager.sharedInstance.getRootTab()
                if rootVC.selectedIndex != 0{
                    rootVC.selectedIndex = 0
                }
            })
            //            NSNotificationCenter.defaultCenter().postNotificationName("ChangeLogin", object: self)
            
            
            }, fail: { (error:String, needRelogin:Bool) -> () in
                if needRelogin == true{
                    //需要重新登录
                    //do nothing
                }else{
                    //失败
                    GShowAlertMessage(error)
                }
        })
    }
    
}
