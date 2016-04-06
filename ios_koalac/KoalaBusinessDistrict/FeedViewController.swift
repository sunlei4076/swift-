//
//  FeedViewController.swift
//  KoalaBusinessDistrict
//
//  Created by liuny on 15/8/22.
//  Copyright (c) 2015年 koalac. All rights reserved.
//

import UIKit

class FeedViewController: UIViewController,UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate {
    
    
    private var feedList:[FeedModel] = []
    private var currPage:Int = 6
    private var feedCell:FeedCell?
    var firstGetLocation:Int = 0
    lazy var tableView:UITableView = {
        let tableView = UITableView()
        tableView.frame = self.view.bounds
        tableView.dataSource = self
        tableView.delegate = self
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("notificationFunction"), name: "ChangeLogin", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("notifiChangeStoreStatus"), name: "ChangeStoreStatus", object: nil)
        
        self.initControl()
//        self.initData()
        
    }
    
//    override func viewWillAppear(animated: Bool) {
//        super.viewWillAppear(true)
//        
//        self.loadData()
//    }
    
    func backAction(){
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    private func loadData(){
        
        var lng:Double = 0
        var lat:Double = 0
        
        
        if ProjectManager.sharedInstance.currLocate == nil && self.firstGetLocation == 0 {
            self.startLocationWithBlock({ () -> () in
                self.firstGetLocation += 1
                }, fail: { () -> () in
                    self.tableView.header.beginRefreshing()
                    self.firstGetLocation += 1
                    pprLog(self.firstGetLocation)
            })
        }
        
        if let locate = ProjectManager.sharedInstance.currLocate {
            lng = locate.location.longitude
            lat = locate.location.latitude
        }
        
        
        let window = UIApplication.sharedApplication().keyWindow
        MBProgressHUD.showHUDAddedTo(window, animated: true)
        //        hud.labelText = "数据加载中..."
        
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
//        let rightBtn = rightBtnItem()
//        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: rightBtn)
        if LoginInfoModel.sharedInstance.m_auth.isEmpty{
            self.currPage = 0
            
        }else{
            self.currPage = 0
            
        }
    }
    
    func notifiChangeStoreStatus(){
//        let rightBtn =  rightBtnItem()
//        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: rightBtn)
    }
    
    private func initControl(){
        
        GNavgationStyle(self.navigationController!.navigationBar)
        
//        let rightBtn = self.rightBtnItem()
//        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: rightBtn)
        self.title = "邻居都在买"
        view.addSubview(tableView)
        
        let backBtn = GNavigationBack()
        backBtn.addTarget(self, action:Selector("backAction"), forControlEvents: UIControlEvents.TouchUpInside)
        let backItem = UIBarButtonItem(customView: backBtn)
        self.navigationItem.leftBarButtonItem = backItem
        
        tableView.registerNib(UINib(nibName: "FeedCell", bundle: nil), forCellReuseIdentifier: FeedCell.cellIdentifier())
        tableView.backgroundColor = GlobalBgColor
        view.backgroundColor = UIColor.whiteColor()
        self.tableView.header = MJRefreshNormalHeader(){
            self.currPage = 0
            self.loadData()
        }
        
        self.addFootRefresh()
        self.currPage = 0
        self.loadData()
        
    }
    
    

//    func rightBtnItem() -> UIButton {
//        let rightBtn:UIButton = UIButton(type:UIButtonType.Custom)
//        var rightBtnTitle: String?
//        if LoginInfoModel.sharedInstance.shopStatus == "1" || LoginInfoModel.sharedInstance.shopStatus == "0" {
//            rightBtnTitle =  "推广"
//        }
////        if LoginInfoModel.sharedInstance.shopStatus == "-1"{
////            rightBtnTitle =  "开店"
////        }
//        else {
//            rightBtnTitle =  "开店"
//        }
//        rightBtn.setTitle(rightBtnTitle, forState: UIControlState.Normal)
//        rightBtn.titleLabel?.font = GGetNormalCustomFont()
//        rightBtn.frame = CGRectMake(0, 0, 40, 30)
//        rightBtn.addTarget(self, action: Selector("shareAction"), forControlEvents: UIControlEvents.TouchUpInside)
//        
//        return rightBtn
//    }
//    

    
    private func endRefresh(){
        if self.tableView.footer.isRefreshing(){
            self.tableView.footer.endRefreshing()
        }
        if self.tableView.header.isRefreshing(){
            self.tableView.header.endRefreshing()
        }
    }
    
//    private func initData(){
//        ProjectManager.sharedInstance.autoLogin(<#T##successBlock: () -> ()##() -> ()#>, failBlock: <#T##() -> ()#>)
//    }
    
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
    
    
    
    private func startLocationWithBlock(success:(()->()),fail:(()->())){
        pprLog("定位中")
        //保证已经获取到地理位置
        if ProjectManager.sharedInstance.currLocate == nil{
            //显示loading
            let window = UIApplication.sharedApplication().keyWindow
            let hud = MBProgressHUD.showHUDAddedTo(window, animated: true)
            hud.labelText = "定位中..."
            
            LocateTool.shareInstance().startLocationWithReverse(true, success: { (result:BMKReverseGeoCodeResult!, location:BMKUserLocation!) -> Void in
                
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
    
    
}
