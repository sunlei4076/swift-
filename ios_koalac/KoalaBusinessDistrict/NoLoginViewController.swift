//
//  NoLoginViewController.swift
//  KoalaBusinessDistrict
//
//  Created by Adobe on 15/12/25.
//  Copyright © 2015年 koalac. All rights reserved.
//

import UIKit

class NoLoginViewController: UIViewController , UITableViewDataSource ,UITableViewDelegate ,UIAlertViewDelegate{

    
    private var feedList:[FeedModel] = []
    private var currPage:Int = 6
    private var feedCell:FeedCell?
    
    lazy var tableView:UITableView = {
        let tableView = UITableView()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.frame = self.view.bounds
        return tableView
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.initControl()
        self.setup()
        
        pprLog(self.tableView.frame)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("notificationFunction"), name: "ChangeLogin", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("notifiChangeStoreStatus"), name: "ChangeStoreStatus", object: nil)
    }
    
    private func setup(){
        // 如果没有登录,就使用feedcell
        self.tableView.registerNib(UINib.init(nibName: "FeedCell", bundle: nil), forCellReuseIdentifier: FeedCell.cellIdentifier())
        self.loginBtn.addTarget(self, action: Selector("loginNormal"), forControlEvents: UIControlEvents.TouchUpInside)
        view.addSubview(self.loginBtn)
        
        
        self.wechatBtn.addTarget(self, action: Selector("wechatLogin"), forControlEvents: UIControlEvents.TouchUpInside)
        view.addSubview(wechatBtn)
    }
    
    private func loadData(){
        
        var lng:Double = 0
        var lat:Double = 0
        

        if let locate = ProjectManager.sharedInstance.currLocate {
            lng = locate.location.longitude
            lat = locate.location.latitude
        }
        
        let window = UIApplication.sharedApplication().keyWindow
        MBProgressHUD.showHUDAddedTo(window, animated: true)
        
        NetworkManager.sharedInstance.requestFeedListLogin(true, lng: lng, lat: lat, currPage: self.currPage, pageNum: 10, success: { (jsonDic:AnyObject) -> () in
            let dic = jsonDic as! Dictionary<String, AnyObject>
            
            MBProgressHUD.hideHUDForView(window, animated: false)

            self.requestSuccess(dic)
            }, fail: { (error:String, needRelogin:Bool) -> () in
                self.endRefresh()
                if needRelogin == true{
                    
                }else{
                    GShowAlertMessage(error)
                }
        })
        
    }
    
    private func addFootRefresh(){
        self.tableView.footer = MJRefreshAutoNormalFooter(){
            self.currPage += 1
            self.loadData()
        }
    }
    
    
    func notificationFunction(){
        let rightBtn = rightBtnItem()
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: rightBtn)
        if LoginInfoModel.sharedInstance.m_auth.isEmpty{
            self.currPage = 0
            
        }else{
            self.currPage = 0
            
        }
    }
    
    func notifiChangeStoreStatus(){
        let rightBtn =  rightBtnItem()
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: rightBtn)
    }

    
    private func initControl(){
        
        GNavgationStyle(self.navigationController!.navigationBar)
        
        self.title = "邻居都在买"
        view.addSubview(tableView)
        
        tableView.registerNib(UINib(nibName: "FeedCell", bundle: nil), forCellReuseIdentifier: FeedCell.cellIdentifier())
        tableView.backgroundColor = GlobalBgColor
        self.tableView.header = MJRefreshNormalHeader(){
            self.currPage = 0
            self.loadData()
        }
        
        self.addFootRefresh()
        self.currPage = 0
        self.loadData()
        
    }

    func rightBtnItem() -> UIButton {
        let rightBtn:UIButton = UIButton(type:UIButtonType.Custom)
        var rightBtnTitle: String?
        if LoginInfoModel.sharedInstance.shopStatus == "1" || LoginInfoModel.sharedInstance.shopStatus == "0" {
            rightBtnTitle =  "推广"
        }
            //        if LoginInfoModel.sharedInstance.shopStatus == "-1"{
            //            rightBtnTitle =  "开店"
            //        }
        else {
            rightBtnTitle =  "开店"
        }
        rightBtn.setTitle(rightBtnTitle, forState: UIControlState.Normal)
        rightBtn.titleLabel?.font = GGetNormalCustomFont()
        rightBtn.frame = CGRectMake(0, 0, 40, 30)
        rightBtn.addTarget(self, action: Selector("shareAction"), forControlEvents: UIControlEvents.TouchUpInside)
        
        return rightBtn
    }
    
    private func endRefresh(){
        if self.tableView.footer.isRefreshing(){
            self.tableView.footer.endRefreshing()
        }
        if self.tableView.header.isRefreshing(){
            self.tableView.header.endRefreshing()
        }
    }
    

    private func getCellHeight(cell:UITableViewCell)->CGFloat{
        cell.layoutIfNeeded()
        cell.updateConstraintsIfNeeded()
        
        let height = cell.contentView.systemLayoutSizeFittingSize(UILayoutFittingCompressedSize).height;
        return height+1.0
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        let model = self.feedList[indexPath.row]
        
        pprLog(model.avatar)
        if model.cellHeight == 0{
            //只创建一个cell用作测量高度
            if self.feedCell == nil{
                feedCell = NSBundle.mainBundle().loadNibNamed("FeedCell", owner: nil, options: nil).first as? FeedCell
            }
            self.feedCell!.cellData = model
            self.feedCell?.backgroundColor = UIColor.redColor()
            model.cellHeight = self.getCellHeight(self.feedCell!)
        }
        
        return model.cellHeight
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.feedList.count
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        pprLog(self.feedList.count)
        let cell = self.tableView.dequeueReusableCellWithIdentifier(FeedCell.cellIdentifier(), forIndexPath: indexPath) as! FeedCell
        
        cell.cellData = self.feedList[indexPath.row]
        
        cell.selectionStyle =  UITableViewCellSelectionStyle.None
        
        cell.index = indexPath.row
        cell.showAllBlock = {(index:Int)->() in
            let model = self.feedList[index]
            model.isShowAll = true
            model.cellHeight = 0
            let refreshRow = NSIndexPath(forRow: index, inSection: 0)
            self.tableView.reloadRowsAtIndexPaths([refreshRow], withRowAnimation: UITableViewRowAnimation.Fade)
        }
        return cell
    }
    
    private func requestSuccess(dic:Dictionary<String, AnyObject>){
        let dataDic = JsonDicHelper.getJsonDicDictionary(dic, key: "data")
        let listArray = JsonDicHelper.getJsonDicArray(dataDic, key: "list")
        
        if self.currPage == 0{
            self.feedList.removeAll(keepCapacity: true)
        }
        
        for item in listArray{
            if item is Dictionary<String, AnyObject>{
                let new = FeedModel(jsonDic: item as! Dictionary<String,AnyObject>)
                self.feedList.append(new)
            }
        }
        pprLog(listArray.count)
        if listArray.count < 10{
            
            if self.currPage == 0 && listArray.count == 0{
                GShowAlertMessage("无数据！")
                
                if let autoNormalFooter = self.tableView.footer as? MJRefreshAutoNormalFooter{
                    autoNormalFooter.setTitle("暂无数据", forState: MJRefreshStateNoMoreData)
                }
                
            }else{
                
                if let autoNormalFooter = self.tableView.footer as? MJRefreshAutoNormalFooter{
                    autoNormalFooter.setTitle("已加载全部", forState: MJRefreshStateNoMoreData)
                }
            }
            self.tableView.footer.endRefreshingWithNoMoreData()
        }else{
            self.tableView.footer.resetNoMoreData()
        }
        self.endRefresh()
        self.tableView.reloadData()
    }
    
    
    //0:待审核，1：审核通过，2：已关闭， 3：注册成功但未提交店铺资料，4：审核不通过 -1：未开店
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
        else  if LoginInfoModel.sharedInstance.shopStatus == "-1" {
            
            // 如果没有帐号 LoginInfoModel.sharedInstance.m_auth
            if LoginInfoModel.sharedInstance.m_auth.isEmpty{
                
                let login =  LoginViewController(nibName:"LoginViewController", bundle:nil)
                login.hidesBottomBarWhenPushed = true
                login.view.backgroundColor = UIColor(red: 1/255.0, green: 1/255.0, blue: 1/255.0, alpha: 0.6)
                self.presentViewController(login, animated: true, completion: nil)
                
            }else{
                
                let register = RegisteriPhoneIdentifyController(nibName:"RegisteriPhoneIdentifyController", bundle:nil)
                register.hidesBottomBarWhenPushed = true
                self.navigationController!.pushViewController(register, animated: true)
            }
            
        }else{
            
            let login =  LoginViewController(nibName:"LoginViewController", bundle:nil)
            login.hidesBottomBarWhenPushed = true
            login.view.backgroundColor = UIColor(red: 1/255.0, green: 1/255.0, blue: 1/255.0, alpha: 0.6)
            self.presentViewController(login, animated: true, completion: nil)
        }
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
    
    lazy var loginBtn:UIButton = {
        let logingBtn = UIButton.init(type: UIButtonType.Custom)
        
        logingBtn.setTitle("登录", forState: UIControlState.Normal)
        
        logingBtn.backgroundColor = GlobalStyleButtonColor
        
        logingBtn.setImage(UIImage(named:"login"),forState:.Normal)
        
        //        button.contentEdgeInsets = UIEdgeInsetsMake(0, 20, 0, 0);
        
        logingBtn.imageEdgeInsets = UIEdgeInsets(top: 0, left: -20, bottom: 0, right: 0)
        
        //        logingBtn.contentEdgeInsets = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
        
        let btnY:CGFloat = CGFloat(screenHeight - 114)
        
        logingBtn.frame = CGRect(x: 0, y: btnY, width: screenWidth * 0.5, height: 50)
        
        return logingBtn
    }()
    
    lazy var wechatBtn:UIButton = {
        let wechatBtn = UIButton.init(type: UIButtonType.Custom)
        
        wechatBtn.setTitle("开店", forState: UIControlState.Normal)
        wechatBtn.backgroundColor = GlobalStyleButtonColor
        wechatBtn.setImage(UIImage(named:"dianpu"),forState:.Normal)
        wechatBtn.imageEdgeInsets = UIEdgeInsets(top: 0, left: -20, bottom: 0, right: 0)
        let btnY:CGFloat = CGFloat(screenHeight - 114)
        
        wechatBtn.frame = CGRect(x: screenWidth * 0.5, y: btnY, width: screenWidth * 0.5, height: 50)
        
        return wechatBtn
    }()

    
    
    
    func loginNormal(){
        // 跳转到登录界面
        
        //添加账号
        
        let loginVC = LoginViewController(nibName:"LoginViewController", bundle:nil)
        loginVC.showLastLoginInfo = false
 
        //更新登陆界面1202
        loginVC.view.backgroundColor = UIColor(red: 1/255.0, green: 1/255.0, blue: 1/255.0, alpha: 0.6)
        self.presentViewController(loginVC, animated: true, completion: nil)
        
    }
    
    func wechatLogin(){
        
        let loginVC = LoginViewController(nibName:"LoginViewController", bundle:nil)
        loginVC.showLastLoginInfo = false
        
        //更新登陆界面1202
        loginVC.view.backgroundColor = UIColor(red: 1/255.0, green: 1/255.0, blue: 1/255.0, alpha: 0.6)
        self.presentViewController(loginVC, animated: true, completion: nil)

        //  直接微信登录
        
        
        //        //微信登陆
        //        WXApiTool.sharedInstance.sendAuthRequest({ (jsonDic:AnyObject) -> () in
        //            //成功
        //
        //            //HX帐号注销
        //            if HXMessageModel.sharedHXInstance.hxUsername.isEmpty == false {
        //
        //                EaseMob.sharedInstance().chatManager.asyncLogoffWithUnbindDeviceToken(true)
        //            }
        //
        //            let dic = jsonDic as! Dictionary<String, AnyObject>
        //            let dataDic = JsonDicHelper.getJsonDicDictionary(dic, key: "data")
        //            let objDic = JsonDicHelper.getJsonDicDictionary(dataDic, key: "obj")
        //            LoginInfoModel.sharedInstance.setDataWithJson(objDic)
        //
        //            //环信
        //            ProjectManager.sharedInstance.loginToHX()
        //            //            NSNotificationCenter.defaultCenter().postNotificationName("ChangeLogin", object: self)
        //
        //            //跳转到主页
        //            self.dismissViewControllerAnimated(true, completion: nil)
        ////            let rootVC = ProjectManager.sharedInstance.getRootTab()
        ////            if rootVC.selectedIndex != 0{
        ////                rootVC.selectedIndex = 0
        ////            }
        //
        //            let mainVC = UIStoryboard(name: "Main", bundle: nil).instantiateInitialViewController() as! UITabBarController
        //
        //            UIApplication.sharedApplication().delegate?.window?!.rootViewController = mainVC
        //
        //            }, fail: { (error:String, needRelogin:Bool) -> () in
        //                if needRelogin == true{
        //                    //需要重新登录
        //                    //do nothing
        //                }else{
        //                    //失败
        //                    GShowAlertMessage(error)
        //                }
        //        })
        
        
    }


}
