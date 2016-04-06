
//
//  ShopViewController.swift
//  koalac_PPM
//
//  Created by seeky on 15/10/05.
//  Copyright (c) 2015年 seeky. All rights reserved.
//

import UIKit

class ShopGoodAddController: UIViewController,UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    var currPage:Int = 0
    //标识选中商品列表还是分类，0：出售中 1：已下架 2：分类
    var selectedIndex:Int = 0 {
        didSet{
            self.tableView.tableFooterView = nil
            self.tableView.header = MJRefreshNormalHeader(){
                self.currPage = 0
                self.requestGoodList()
            }
            self.addFootRefresh()
            self.currPage = 0
            self.requestGoodList()
            self.tableView.reloadData()
        }
    }
    var shopGoodList:[ShopGoodModel] = []
    var shopTypeList:[ShopTypeModel] = []
    var totalGoods:Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.initControl()
        //        self.initData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.currPage = 0
        self.requestGoodList()
    }
    
    private func initControl(){
        self.title = "发布已进货商品"
        //back
        let backBtn = GNavigationBack()
        backBtn.addTarget(self, action:Selector("backAction"), forControlEvents: UIControlEvents.TouchUpInside)
        let backItem = UIBarButtonItem(customView: backBtn)
        self.navigationItem.leftBarButtonItem = backItem
        
        self.view.backgroundColor = GlobalBgColor
        self.tableView.backgroundColor = GlobalBgColor
        self.tableView.tableFooterView = nil
        self.tableView.header = MJRefreshNormalHeader(){
            self.currPage = 0
            self.requestGoodList()
        }
        self.addFootRefresh()
    }
    
    func backAction(){
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    //shopGoodAdd
    private func addFootRefresh(){
        self.tableView.footer = MJRefreshAutoNormalFooter(){
            self.currPage += 1
            self.requestGoodList()
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
    
    private func requestGoodList(){
        NetworkManager.sharedInstance.requestBoughtGoodList(self.currPage, pageNum: 10, success:{ (jsonDic:AnyObject) -> () in
            let dic = jsonDic as! Dictionary<String, AnyObject>
            let dataDic = JsonDicHelper.getJsonDicDictionary(dic, key: "data")
            let listArray = JsonDicHelper.getJsonDicArray(dataDic, key: "list")
            let objDic = JsonDicHelper.getJsonDicDictionary(dataDic, key: "obj")
            
            let total = JsonDicHelper.getJsonDicValue(objDic, key: "total_num")
            self.totalGoods = (total as NSString).integerValue
            
            if self.currPage == 0{
                self.shopGoodList.removeAll(keepCapacity: true)
            }
            for item in listArray
            {
                if item is Dictionary<String, AnyObject>{
                    let good = ShopGoodModel(jsonDic: item as! Dictionary<String, AnyObject>)
                    self.shopGoodList.append(good)
                }
            }
            
            if listArray.count < 10{
                if self.currPage == 0 && listArray.count == 0{
                    //                GShowAlertMessage("货架空空如也，老板赶快进货吧！")
                    let label = UILabel()

                    let labelY = CGFloat(screenHeight - 110)
                    pprLog(labelY)
                    label.frame = CGRectMake(0, labelY, screenWidth, 50)
                    label.text = "进货的商品需确认收货才可以上架哦"
                    label.font = GGetSmallCustomFont()
                    label.textAlignment = NSTextAlignment.Center

                    label.textColor = UIColor.whiteColor()
                    label.backgroundColor  = GlobalStyleButtonColor
                    self.view.addSubview(label)
                    
                    let alert = UIAlertView(title: "提示", message:"货架空空如也，老板赶紧进货吧", delegate: self, cancelButtonTitle: "马上进货", otherButtonTitles: "我知道了")
                    alert.show()
                    
                }else{
                    self.tableView.footer.endRefreshingWithNoMoreData()
                }
            }else{
                self.tableView.footer.resetNoMoreData()
            }
            self.endRefresh()
            self.tableView.reloadData()
            }) { (error:String, needRelogin:Bool) -> () in
                if self.currPage != 0{
                    self.currPage -= 1
                }
                if needRelogin == true{
                    
                }else{
                    self.endRefresh()
                    GShowAlertMessage(error)
                }
        }
    }
    
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return ShopGoodCell.cellHeight()
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.shopGoodList.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        self.tableView.registerNib(UINib(nibName: "ShopGoodAddCell", bundle: nil), forCellReuseIdentifier: ShopGoodAddCell.cellIdentifier())
        let cell = self.tableView.dequeueReusableCellWithIdentifier(ShopGoodAddCell.cellIdentifier(), forIndexPath: indexPath) as! ShopGoodAddCell
        cell.selectionStyle = UITableViewCellSelectionStyle.Gray
        cell.shopGoodData = self.shopGoodList[indexPath.row]
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        pprLog(indexPath)
        let goodDetailVC = ShopGoodDetailViewController(nibName:"ShopGoodDetailViewController",bundle:nil)
        goodDetailVC.showBoughtGood = true
        goodDetailVC.goodData = self.shopGoodList[indexPath.row]
        
        self.navigationController?.pushViewController(goodDetailVC, animated: true)
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
    }
    
    func alertView(alertView: UIAlertView, clickedButtonAtIndex buttonIndex: Int) {
        let buttonStr = alertView.buttonTitleAtIndex(buttonIndex)
        let title = alertView.title
        
        if title == "提示"
        {
            if buttonStr == "马上进货"
            {
                
                let webVC: WebViewToJSController?
                let kstoreId = LoginInfoModel.sharedInstance.store.store_id
                let webTURL = LoginInfoModel.sharedInstance.store.purchase_url
                let userDeviceType = "4" //设备类型  4表示ios
                webVC = webHelper.openAppointWebVC("我要进货", jumpURL: webTURL, param1: kstoreId, param2: userDeviceType)
                self.navigationController?.pushViewController(webVC!, animated: true)
                
            }
            
        }
        
    }
    
}
