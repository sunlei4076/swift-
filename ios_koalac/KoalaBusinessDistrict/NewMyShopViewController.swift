//
//  ViewController.swift
//  koalac_PPM
//
//  Created by 黄沩湘 on 15/6/8.
//  Copyright (c) 2015年 考拉先生. All rights reserved.
//

import UIKit

class NewMyShopViewController: UIViewController,UICollectionViewDelegateFlowLayout,UIAlertViewDelegate{
    
    var isOnew:Bool = false
    
    var total:CGFloat = 0
    var heigthConstant:CGFloat?
    
    @IBOutlet weak var myShop_scrollViewHight: NSLayoutConstraint!
    private var colletGroup:[MyShopModel] = []
    private var colletTab:[tabModel] = []
    private var shopSaleData:MyShopSaleModel = MyShopSaleModel()
    private var shopTabVersion = ""
    
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var scroll_bottomView: UIView!
    var levelPic:UIImageView = UIImageView()
    
    let cellSpace:CGFloat = 0
    var statusCode:Int = -1 //false为未授权
    
    
    @IBOutlet weak var collectionView: UICollectionView!
    //    @IBOutlet weak var myCollectionHead: UILabel!
    @IBOutlet weak var myShopHeaderView: UIView!
    
    @IBOutlet weak var avatar: UIButton! // 头像
    @IBOutlet weak var shopName: UILabel!// 店名
    //    @IBOutlet weak var levelName: UILabel! // 等级
    @IBOutlet weak var shopScore: UILabel!//积分
    @IBOutlet weak var experienceLabel: UILabel!//经验
    @IBOutlet weak var honstyLabel: UILabel!
    @IBOutlet weak var honestyProView: UIProgressView!//诚信
    @IBOutlet weak var honestyNumLabel: UILabel!
    @IBOutlet weak var taskImageView: UIImageView!
    @IBOutlet weak var LevelView: UIView!//爱心
    
    @IBOutlet weak var visitNumLabel: UILabel!
    @IBOutlet weak var orderNumLabel: UILabel!
    @IBOutlet weak var saleNumLabel: UILabel!
    @IBOutlet weak var taskNameLabel: UILabel!
    @IBOutlet weak var taskStatusName: UILabel!
    @IBOutlet weak var storeMedalPic: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("notificationFunction"), name: "ChangeLogin", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("notifiChangeStoreStatus"), name: "ChangeStoreStatus", object: nil)
        
        self.title = "我的店铺"
        GNavgationStyle(self.navigationController!.navigationBar)
        let rightBtn =  self.rightBtnItem()
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: rightBtn)
        
        let leftBtn:UIButton = UIButton(type:UIButtonType.Custom)
        leftBtn.setTitle("预览", forState: UIControlState.Normal)
        leftBtn.titleLabel?.font = GGetNormalCustomFont()
        leftBtn.frame = CGRectMake(0, 0, 40, 30)
        leftBtn.addTarget(self, action: Selector("showStoreToMe"), forControlEvents: UIControlEvents.TouchUpInside)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: leftBtn)
        
        self.avatar.layer.cornerRadius = 25.0
        self.avatar.layer.masksToBounds = true
        
        self.initData()
        //        self.initControl()
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(true)
        self.total = 0

        if jPushJump.isJPJump == true {
            
            jPushJump = (false, "" ,"")
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
//       self.collectionView.reloadData()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        
        //        if jPushJump.isJPJump{
        //
        //            if jPushJump.jPURL == "OrderViewController"{
        //
        //                let orderVC = OrderViewController(nibName:"OrderViewController", bundle:nil)
        //                orderVC.hidesBottomBarWhenPushed = true
        //
        //                self.navigationController?.pushViewController(orderVC, animated: true)
        ////            }else{
        ////                let webJPushVC = webHelper.openWebVC(jPushJump.jPTitle, jumpURL:jPushJump.jPURL)
        ////                pprLog(self.navigationController)
        ////                self.navigationController?.pushViewController(webJPushVC, animated: true)
        //            }
        //        }
        //        else {
        //
        
        //获取商家销售信息
        NetworkManager.sharedInstance.requestGetAllSaleInfo({ (jsonDic:AnyObject) -> () in
            let dic = jsonDic as! Dictionary<String,AnyObject>
            //            pprLog(dic)
            let dataDic = JsonDicHelper.getJsonDicDictionary(dic, key: "data")
            let shopSale = JsonDicHelper.getJsonDicDictionary(dataDic, key: "obj")
            
            self.shopSaleData = MyShopSaleModel(jsonDic: shopSale)
            self.myShopHeaderViewLoad()
 
//            if  self.isOnew == true{
//                self.collectionView.reloadData()
//            }else{
//                self.isOnew = true
//            }

//            self.collectionView.reloadData()
//             pprLog(self.shopSaleData.unfinishOrderTotal)
            
            }) { (error:String, needRelogin:Bool) -> () in
                if needRelogin == true{
                    
                }else{
                    GShowAlertMessage(error)
                }
        }
        
        
        //        }
    }
    
    
    
    func myShopHeaderViewLoad() {
        let avatarURL = LoginInfoModel.sharedInstance.avatar
        self.avatar.setBackgroundImageForState(UIControlState.Normal, withURL: NSURL(string: avatarURL)!, placeholderImage: UIImage(named: "koalac_no_avatar"))
        let storeName = LoginInfoModel.sharedInstance.store.store_name
        self.shopName.text = storeName.isEmpty ? "未设置" : storeName
        
        //        self.levelName.text = self.shopSaleData.levelName
        
        self.addLevelPic()
        
        self.shopScore.text = self.shopSaleData.pointsTotal.isEmpty ? "0": self.shopSaleData.pointsTotal
        self.experienceLabel.text = self.shopSaleData.experienceTotal.isEmpty ? "0": self.shopSaleData.experienceTotal
        let honestyScore = Float(self.shopSaleData.honestyScore)
        let honestyScoreTotal = Float(self.shopSaleData.honestyScoreTotal)
        if (honestyScore != nil) && (honestyScoreTotal != nil)
        {
            let honeer = honestyScore! / honestyScoreTotal!
            self.honestyProView.progress = honeer
            
            self.honestyNumLabel.text = self.shopSaleData.honestyScore + "/" + self.shopSaleData.honestyScoreTotal
        }
        
        self.visitNumLabel.text = self.shopSaleData.pv.isEmpty  ? "0": self.shopSaleData.pv
        self.orderNumLabel.text = self.shopSaleData.orderTotal.isEmpty ? "0": self.shopSaleData.orderTotal
        self.saleNumLabel.text = self.shopSaleData.moneyTotal.isEmpty ? "0":self.shopSaleData.moneyTotal
        self.taskStatusName.text = self.shopSaleData.taskStatusName
        if LoginInfoModel.sharedInstance.shopStatus == "3" || LoginInfoModel.sharedInstance.shopStatus == "-1" {
            taskNameLabel.text = "你还未开店"
            honstyLabel.hidden = true
            honestyProView.hidden = true
            honestyNumLabel.hidden = true
            
        }else {
            self.taskNameLabel.text = self.shopSaleData.taskName
            
            //            self.storeMedalPic.setImageWithURL(NSURL(string: shopSaleData.storeMedalPic)!)
        }
    }
    
    func notificationFunction(){
        self.navigationController?.popToRootViewControllerAnimated(false)
        if LoginInfoModel.sharedInstance.m_auth.isEmpty == false{
            self.initData()
        }
        
        for view in self.LevelView.subviews{
            if view.isKindOfClass(UIImageView){
                view.removeFromSuperview()
            }
        }
        
        
        self.levelPic.removeFromSuperview()
        let rightBtn = self.rightBtnItem()
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: rightBtn)
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
        pprLog(LoginInfoModel.sharedInstance.shopStatus)
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
    
    func showStoreToMe() {
//        let webVC: WebViewToJSController?
//        let kstoreId = LoginInfoModel.sharedInstance.store.store_id
//        let webTURL = "http://www.lifeq.com.cn/store_ws.php"
//        let userDeviceType = "4" //设备类型  4表示ios
//        webVC = webHelper.openAppointWebVC("我要进货正式", jumpURL: webTURL, param1: kstoreId, param2: userDeviceType)
//        self.navigationController?.pushViewController(webVC!, animated: true)
        
        
        
        if LoginInfoModel.sharedInstance.shopStatus == "1" {
            let myStoreName = LoginInfoModel.sharedInstance.store.store_name
            let myStoreURL = LoginInfoModel.sharedInstance.store.app_store_url
            let myStoreWeb = webHelper.openWebVC(myStoreName, jumpURL:myStoreURL)
            let navVC = ProjectManager.sharedInstance.getTabSelectedNav()
            navVC.pushViewController(myStoreWeb, animated: true)

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
            openStorePoper(self.navigationController!)
        }
        
    }
    
    private func initData(){
        
        NetworkManager.sharedInstance.requestMyShopListUpdate({ (jsonDic:AnyObject) -> () in
            let dic = jsonDic as! Dictionary<String, AnyObject>
            let dataDic = JsonDicHelper.getJsonDicDictionary(dic, key: "data")
            let myShopListObj = JsonDicHelper.getJsonDicDictionary(dataDic, key: "obj")
            //            pprLog(myShopListObj)
            //            pprLog(self.shopTabVersion)
            let newTabVersion = JsonDicHelper.getJsonDicValue(myShopListObj, key: "version")
            //            pprLog(newTabVersion)
            if newTabVersion != self.shopTabVersion {
                //获取colleCell数据；
                self.colletGroup.removeAll(keepCapacity: true)
                self.getNewMyshopTab()
                self.shopTabVersion = newTabVersion
            }
            
            }, fail: { (error:String, needRelogin:Bool) -> () in
                if needRelogin == true{
                    
                }else{
                    if jPushJump.isJPJump != true {
                        GShowAlertMessage(error)
                    }
                    //                GShowAlertMessage(error)
                }
        })
    }
    
    func getNewMyshopTab() {
        NetworkManager.sharedInstance.requestMyShopList({ (jsonDic:AnyObject) -> () in
            let dic = jsonDic as! Dictionary<String, AnyObject>
            //            pprLog(dic)
            let dataDic = JsonDicHelper.getJsonDicDictionary(dic, key: "data")
            let listArray = JsonDicHelper.getJsonDicArray(dataDic, key: "list")
            for item in listArray{
                if item is Dictionary<String, AnyObject> {
                    let model = MyShopModel(jsonDic: item as! Dictionary<String,AnyObject>)
                    self.colletGroup.append(model)
                }
            }
            self.collectionView?.reloadData()
            }, fail: { (error:String, needRelogin:Bool) -> () in
                if needRelogin == true{
                    
                }else{
                    if jPushJump.isJPJump != true {
                        GShowAlertMessage(error)
                    }
                    //                    GShowAlertMessage(error)
                }
        })
    }
    
    // MARK:- UICollectionViewDataSource
    func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        var reusableView: UICollectionReusableView?
        
        if kind == UICollectionElementKindSectionHeader {
            reusableView = collectionView.dequeueReusableSupplementaryViewOfKind(UICollectionElementKindSectionHeader, withReuseIdentifier: "HeaderView", forIndexPath: indexPath)
            let sectionName = self.colletGroup[indexPath.section]
            (reusableView as! MyShopColleHeader).colletHead.text = sectionName.myShop_GroupName
            return reusableView!
        }
        reusableView = collectionView.dequeueReusableSupplementaryViewOfKind(UICollectionElementKindSectionFooter, withReuseIdentifier: "FooterView", forIndexPath: indexPath)
        
        return reusableView!
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        
        return self.colletGroup.count
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let colletGrouper = self.colletGroup[section]
        var hegiht:Int = 0
        if colletGrouper.tabModels.count > 4{
            hegiht = ((Int)(screenWidth / 4) * (colletGrouper.tabModels.count / 4)) + (Int)(screenWidth / 4)
            
            
        }else{
            hegiht = (Int)(screenWidth / 4)
        }
        
        let  heigthConstant:CGFloat = CGFloat(190 + 50 + 45 + 40 * 3)
        
        self.total += CGFloat(hegiht)
        
        self.heigthConstant = heigthConstant + self.total
        
//        pprLog("\(self.heigthConstant! ) + \(self.total )")
        //        self.myShop_scrollViewHight.constant = 400
        self.myShop_scrollViewHight.constant = self.heigthConstant!
        
        self.scroll_bottomView.updateConstraintsIfNeeded()
        self.scroll_bottomView.updateConstraints()
        
        return colletGrouper.tabModels.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("MyShopCell", forIndexPath: indexPath) as! MyShopCollCell
        let shopTabs = self.colletGroup[indexPath.section]
        
        cell.ShopCellData = shopTabs.tabModels[indexPath.row]
//        pprLog(self.shopSaleData.unfinishOrderTotal)
        cell.unfinishOrder = self.shopSaleData.unfinishOrderTotal
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        
        let cellW = (screenWidth - cellSpace * 5) / 4
        return CGSizeMake(cellW, cellW)
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        
        return UIEdgeInsetsMake(cellSpace, cellSpace, cellSpace, cellSpace)
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        return cellSpace
    }
    
    func collectionView(collectionView: UICollectionView, shouldSelectItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        let shopTabs = self.colletGroup[indexPath.section]
        
        let module = shopTabs.tabModels[indexPath.row]
        
        self.goNext(module)
        collectionView.deselectItemAtIndexPath(indexPath, animated: true)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
    
    // MARK:- 点击header后的跳转
    @IBAction func headerDetailsClick(sender: AnyObject) {
        if LoginInfoModel.sharedInstance.shopStatus == "1"
        {
            let webVC: WebViewController?
            webVC = webHelper.openWebVC("我的记录", jumpURL: self.shopSaleData.headURL)
            let navVC = ProjectManager.sharedInstance.getTabSelectedNav()
            navVC.pushViewController(webVC!, animated: true)
            
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
            openStorePoper(self.navigationController!)
        }
    }
    
    
    @IBAction func taskClick(sender: AnyObject) {
        if LoginInfoModel.sharedInstance.shopStatus == "1"
        {
            let webVC: WebViewController?
            webVC = webHelper.openWebVC("任务", jumpURL: self.shopSaleData.taskURL)
            let navVC = ProjectManager.sharedInstance.getTabSelectedNav()
            navVC.pushViewController(webVC!, animated: true)
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
            openStorePoper(self.navigationController!)
        }
    }
    
    // MARK:- 点击cell后的跳转
    private func checkShopStatus()->Bool{
        var canGoIn:Bool = false
        let statusInt = (LoginInfoModel.sharedInstance.shopStatus as NSString).integerValue
        pprLog(statusInt)
        
        switch statusInt{
        case -1,3:
            //未开店
            canGoIn = false
            //弹出提交店铺页面
            openStorePoper(self.navigationController!)
            break
        case 0:
            //待审核
            canGoIn = false
            let alert = UIAlertView(title: "提示", message: "亲，您的店铺正在审核中", delegate: self, cancelButtonTitle: "联系客服", otherButtonTitles: "我知道了")
            alert.show()
            break
        case 1:
            //审核通过
            canGoIn = true
            break
        case 2:
            //已关闭
            canGoIn = false
            GShowAlertMessage("您的店铺已关闭！")
            break
        case 4:
            //审核失败
            canGoIn = false
            let alert = UIAlertView(title: "提示", message: "店铺审核不通过", delegate: self, cancelButtonTitle: "重新申请", otherButtonTitles: "我知道了")
            alert.show()
            break
            
        default:
            break
        }
        return canGoIn
    }
    
    private func goNext(module:tabModel)
        
    {
        let statusInt = (LoginInfoModel.sharedInstance.shopStatus as NSString).integerValue
        
        if statusInt == 1 {
            self.pushVCWithModule(module)
            
        }else{
//            if module.myShop_tabName == "设置" || module.myShop_tabName == "联系客服"{
            if module.myShop_Tag == "set_up" || module.myShop_Tag == "customer_service"{
            
                self.pushVCWithModule(module)
                
            }else if statusInt == -1  {
                if self.checkShopStatus() == true{
                    self.pushVCWithModule(module)
                }
            }else{
                NetworkManager.sharedInstance.requestShopStatus({ (jsonDic:AnyObject) -> () in
                    let dic = jsonDic as! Dictionary<String,AnyObject>
                    let dataDic = JsonDicHelper.getJsonDicDictionary(dic, key: "data")
                    let objDic = JsonDicHelper.getJsonDicDictionary(dataDic, key: "obj")
                    let status = JsonDicHelper.getJsonDicValue(objDic, key: "status")
                    if status.isEmpty == true{
                        LoginInfoModel.sharedInstance.shopStatus = "-1"
                    }else{
                        LoginInfoModel.sharedInstance.shopStatus = status
                    }
                    
                    if self.checkShopStatus() == true{
                        self.pushVCWithModule(module)
                    }
                    }, fail: { (error:String, needRelogin:Bool) -> () in
                        
                })
            }
        }
    }
    
    private func pushVCWithModule(module:tabModel)
    {
        let titleStr = module.myShop_tabName
        let itemTag = module.myShop_Tag
//        pprLog(itemTag)
        switch itemTag {
//        switch titleStr{
        
//        case "设置":
        case "set_up":
            let setVC = SetViewController(nibName:"SetViewController", bundle:nil)
            setVC.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(setVC, animated: true)
//        case "商品管理":
        case "goods_manage":
            let shopVC = ShopViewController(nibName:"ShopViewController", bundle:nil)
            shopVC.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(shopVC, animated: true)
//        case "订单管理":
       case "order_manage":
            let orderVC = OrderViewController(nibName:"OrderViewController", bundle:nil)
            orderVC.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(orderVC, animated: true)
//        case "联系客服":
        case "customer_service":
            UIApplication.sharedApplication().openURL(NSURL(string: "tel:4000588577")!)
//        case "商家提现":
        case "store_drawal":
            let tixianVC = ShowAccountCashViewController(nibName:"ShowAccountCashViewController", bundle:nil)
            tixianVC.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(tixianVC, animated: true)
//        case "邀请开店":
        case "invite_open_store":
            let inviteVC = InviteOpenStoreViewController(nibName:"InviteOpenStoreViewController", bundle:nil)
            inviteVC.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(inviteVC, animated: true)
//        case "客户管理":
        case "customer_manage":
            pprLog("要改为生意经URL,后台没改")
//            let customerManagerVC = CustomerViewController()
//            customerManagerVC.hidesBottomBarWhenPushed = true
//            self.navigationController?.pushViewController(customerManagerVC, animated: true)
            
//        case "收款","优惠券","空中充值","活动":
        case "receive_money","coupon","air_pay","avtivity":
            let webVC: WebViewController?
            let webJumper = module.myShop_ClickUrl
            pprLog(webJumper)
            if webJumper.isEmpty {
                GShowAlertMessage("开发中，敬请期待！")
            }else {
                webVC = webHelper.openWebVC(titleStr, jumpURL: webJumper)
                self.navigationController?.pushViewController(webVC!, animated: true)
            }
            
        case "purchase_manage":
            let webVC: WebViewToJSController?
            let webJumper = module.myShop_ClickUrl
            let kstoreId = LoginInfoModel.sharedInstance.store.store_id
            let userDeviceType = "4" //设备类型  4表示ios
            webVC = webHelper.openAppointWebVC(titleStr, jumpURL: webJumper, param1: kstoreId, param2: userDeviceType)
            self.navigationController?.pushViewController(webVC!, animated: true)

        default:
            let webVC: WebViewController?
            let webJumper = module.myShop_ClickUrl
            pprLog(webJumper)
            if webJumper.isEmpty {
                GShowAlertMessage("开发中，敬请期待！")
            }else {
                webVC = webHelper.openWebVC(titleStr, jumpURL: webJumper)
                self.navigationController?.pushViewController(webVC!, animated: true)
            }
        }
    }
    
    private func addLevelPic(){
        let num  = (self.shopSaleData.picNum as NSString).integerValue
        
        for var i = 0 ; i < num ; i++ {
            
            self.levelPic = UIImageView()
            
            levelPic.setImageWithURL(NSURL(string: self.shopSaleData.levelPic)!)
            
            let  margin = CGFloat(18 * i)
            
            levelPic.frame = CGRectMake( margin  , 0 ,  GNormalFontSize - 1 ,  GNormalFontSize - 1)
            
            
            self.LevelView .addSubview(levelPic)
            
        }
    }
    
    
    
    
    
}

