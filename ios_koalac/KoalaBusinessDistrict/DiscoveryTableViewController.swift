//
//  DiscoveryTableViewController.swift
//  koalac_PPM
//
//  Created by liuny on 15/8/21.
//  Copyright (c) 2015年 考拉先生. All rights reserved.
//

import UIKit

class DiscoveryTableViewController: UITableViewController,UIAlertViewDelegate {
    
    private var tableData:[[DiscoveryModel]] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initControl()
        self.initData()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("notificationFunction"), name: "ChangeLogin", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("notifiChangeStoreStatus"), name: "ChangeStoreStatus", object: nil)
    }

    override func viewDidDisappear(animated: Bool) {
        super.viewDidAppear(true)
        
        if jPushJump.isJPJump == true {
            
            jPushJump = (false, "" ,"")
        }
    }
    
    func notificationFunction(){
        let rightBtn = self.rightBtnItem()
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: rightBtn)
        
        if LoginInfoModel.sharedInstance.m_auth.isEmpty == false{
            self.initData()
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
    
    
    private func initControl(){
//        self.title = "发现"
        GNavgationStyle(self.navigationController!.navigationBar)
        let rightBtn = self.rightBtnItem()
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: rightBtn)
        
        let screenWidth = UIScreen.mainScreen().bounds.width
        self.tableView.tableHeaderView = UIView(frame: CGRectMake(0, 0, screenWidth, 20))
    }
    
    private func initData(){
        self.tableData.removeAll(keepCapacity: true)
        NetworkManager.sharedInstance.requestDiscoveryList({ (jsonDic:AnyObject) -> () in
            let dic = jsonDic as! Dictionary<String, AnyObject>
            let dataDic = JsonDicHelper.getJsonDicDictionary(dic, key: "data")
            let listArray = JsonDicHelper.getJsonDicArray(dataDic, key: "list")
            
            for item in listArray{
                if item is Dictionary<String, AnyObject>{
                    let model = DiscoveryModel(jsonDic: item as! Dictionary<String,AnyObject>)
                    //group判断
                    var toAddSection = true
                    var sameSection = 0
                    
                    for var i=0;i<self.tableData.count;i++ {
                        let array = self.tableData[i]
                        if let firstOne = array.first{
                            if firstOne.discovery_Group == model.discovery_Group{
                                toAddSection = false
                                sameSection = i
                                break
                            }
                        }
                    }
                    
                    if toAddSection == true {
                        let tempArray:[DiscoveryModel] = [model]
                        self.tableData.append(tempArray)
                    }else{
                        var toAddArray = self.tableData[sameSection]
                        toAddArray.append(model)
                        self.tableData[sameSection] = toAddArray;
                    }
                }
            }
            
            self.requestUpdate()
            
            }, fail: { (error:String, needRelogin:Bool) -> () in
                if needRelogin == true{
                    
                }else{
                    GShowAlertMessage(error)
                }
        })
    }
    
    private func requestUpdate(){
        NetworkManager.sharedInstance.requestDiscoveryUpdate({ (jsonDic:AnyObject) -> () in
            let dic = jsonDic as! Dictionary<String, AnyObject>
            let dataDic = JsonDicHelper.getJsonDicDictionary(dic, key: "data")
            let listArray = JsonDicHelper.getJsonDicArray(dataDic, key: "list")
            
            for item in listArray{
                if item is Dictionary<String, AnyObject>{
                    let itemDic = item as! Dictionary<String, AnyObject>
                    let newest_id = JsonDicHelper.getJsonDicValue(itemDic, key: "newest_id")
                    let id = JsonDicHelper.getJsonDicValue(itemDic, key: "id")
                    //没有更新
                    if (newest_id.characters.count == 0 || (newest_id as NSString).integerValue == 0){
                        continue
                    }
                    
                    //有更新
                    for array in self.tableData{
                        for model in array{
                            if (model.discovery_Id as NSString).integerValue == (id as NSString).integerValue{
                                model.discovery_Update = newest_id
                                break
                            }
                        }
//                        break
                    }
                }
                
            }
            self.tableView.reloadData()
            }, fail: { (error:String, needRelogin:Bool) -> () in
                if needRelogin == true{
                    
                }else{
                    GShowAlertMessage(error)
                }
        })
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return self.tableData.count
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.tableData[section].count
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 44
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("DiscoveryCell", forIndexPath: indexPath) as! DiscoveryCell

        let array = self.tableData[indexPath.section]
        let model = array[indexPath.row]
        cell.cellData = model
        
        return cell
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        if LoginInfoModel.sharedInstance.shopStatus == "0" {
            let alert = UIAlertView(title: "提示", message: "亲，您的店铺正在审核中", delegate: self, cancelButtonTitle: "联系客服", otherButtonTitles: "我知道了")
            alert.show()
        }
        else if LoginInfoModel.sharedInstance.shopStatus == "4" {
            let alert = UIAlertView(title: "提示", message: "店铺审核不通过", delegate: self, cancelButtonTitle: "重新申请", otherButtonTitles: "我知道了")
            alert.show()
        }        
        else if LoginInfoModel.sharedInstance.shopStatus == "1" {
            let array = self.tableData[indexPath.section]
            let model = array[indexPath.row]
            //更新未读消息数目
            let userUnreadNum = (model.discovery_Update as NSString).integerValue
            
            if userUnreadNum > 0{
                /*显示数字
                if let unreadNumTotal = self.navigationController?.tabBarItem.badgeValue?.toInt(){
                if unreadNumTotal-userUnreadNum > 0{
                self.navigationController?.tabBarItem.badgeValue = String(unreadNumTotal-userUnreadNum)
                }else{
                self.navigationController?.tabBarItem.badgeValue = nil
                }
                }*/
                let tabVC = ProjectManager.sharedInstance.getRootTab()
                if let mainTab = tabVC as? MainTabViewController{
                    mainTab.discoveryNum -= userUnreadNum
                    
                    clearDiscoveryNum(mainTab.discoveryNum)
                }
                model.discovery_Update = "0"
                tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.None)
            }
         

            
            let webType = model.discovery_tag
            let webTitle = model.discovery_Title
            
            
            
            if indexPath.section == 0 {
                
                let vc = FeedViewController()
                
                vc.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(vc, animated: true)
            }else{
                
                if webType == "purchase" {
                    let webVC: WebViewToJSController?
                    let kstoreId = LoginInfoModel.sharedInstance.store.store_id
                    let userDeviceType = "4" //设备类型  4表示ios
                    webVC = webHelper.openAppointWebVC(webTitle, jumpURL: model.discovery_ClickUrl, param1: kstoreId, param2: userDeviceType)
                    self.navigationController?.pushViewController(webVC!, animated: true)
                }
                else {
                    let webVC: WebViewShareController?
                    webVC = webHelper.openWebShareVC(webTitle, jumpURL: model.discovery_ClickUrl)
                    webVC?.webShareType = webType
                    self.navigationController?.pushViewController(webVC!, animated: true)
                }
            }
        }
        else {
            openStorePoper(self.navigationController!)
        }
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    func clearDiscoveryNum(num:Int) -> Int{
        
        return num
    }
    
            
}
