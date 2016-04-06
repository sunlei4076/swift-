//
//  ShopViewController.swift
//  koalac_PPM
//
//  Created by liuny on 15/6/15.
//  Copyright (c) 2015年 考拉先生. All rights reserved.
//

import UIKit

class ShopViewController: UIViewController,UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    
    @IBOutlet weak var createNewTypeBtn: UIButton!
    @IBOutlet var createNewTypeView: UIView!
    @IBOutlet weak var goodTypeBtn: UIButton!
    @IBOutlet weak var allGoodsBtn: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet var tableHeadView: UIView!
    
    @IBOutlet weak var offLineBtn: UIButton!
    var currPage:Int = 0
    //标识选中商品列表还是分类，0：出售中 1：已下架 2：分类
    var selectedIndex:Int = 0
        {
        didSet{
            if self.selectedIndex == 0{
                self.allGoodsBtn.selected = true
                self.goodTypeBtn.selected = false
                self.offLineBtn.selected = false
                self.tableView.tableFooterView = nil
                self.tableView.header = MJRefreshNormalHeader(){
                    self.currPage = 0
                    self.requestGoodList()
                }
                self.addFootRefresh()
                self.currPage = 0
                self.requestGoodList()
            }else if self.selectedIndex == 1{
                self.allGoodsBtn.selected = false
                self.goodTypeBtn.selected = false
                self.offLineBtn.selected = true
                self.tableView.tableFooterView = nil
                self.tableView.header = MJRefreshNormalHeader(){
                    self.currPage = 0
                    self.requestGoodList()
                }
                self.addFootRefresh()
                self.currPage = 0
                self.requestGoodList()
            }else if self.selectedIndex == 2{
                self.allGoodsBtn.selected = false
                self.goodTypeBtn.selected = true
                self.offLineBtn.selected = false
                self.tableView.tableFooterView = self.createNewTypeView
                self.tableView.header = nil
                self.tableView.footer = nil
            }
            self.tableView.reloadData()
        }
    }
    var shopGoodList:[ShopGoodModel] = []
    var shopTypeList:[ShopTypeModel] = []
    var totalGoods:Int = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.initControl()
        self.initData()
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
        self.title = "商品管理"
        //back
        let backBtn = GNavigationBack()
        backBtn.addTarget(self, action:Selector("backAction"), forControlEvents: UIControlEvents.TouchUpInside)
        let backItem = UIBarButtonItem(customView: backBtn)
        self.navigationItem.leftBarButtonItem = backItem
        
        let rightBtn:UIButton = UIButton(type: UIButtonType.Custom)
        rightBtn.frame = CGRectMake(0, 0, 40, 30)
        rightBtn.setTitle("添加", forState: UIControlState.Normal)
        rightBtn.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        rightBtn.titleLabel?.font = GGetNormalCustomFont()
        rightBtn.addTarget(self, action: Selector("addGoodOnLine"), forControlEvents: UIControlEvents.TouchUpInside)
        let rightItem = UIBarButtonItem(customView: rightBtn)
        self.navigationItem.rightBarButtonItem = rightItem
        
        self.view.backgroundColor = GlobalBgColor
        self.tableView.backgroundColor = GlobalBgColor
        self.tableHeadView.backgroundColor = GlobalBgColor
        self.allGoodsBtn.selected = true
        self.goodTypeBtn.selected = false
        self.offLineBtn.selected = false
        self.tableView.tableFooterView = nil
        self.tableView.header = MJRefreshNormalHeader(){
            self.currPage = 0
            self.requestGoodList()
        }
        self.addFootRefresh()
        //设置字体
        self.allGoodsBtn.titleLabel?.font = GGetNormalCustomFont()
        self.goodTypeBtn.titleLabel?.font = GGetNormalCustomFont()
        self.offLineBtn.titleLabel?.font = GGetNormalCustomFont()
        
        self.allGoodsBtn.setTitleColor(GlobalStyleFontColor, forState: UIControlState.Selected)
        self.allGoodsBtn.setTitleColor(GlobalGrayFontColor, forState: UIControlState.Normal)
        self.goodTypeBtn.setTitleColor(GlobalGrayFontColor, forState: UIControlState.Normal)
        self.goodTypeBtn.setTitleColor(GlobalStyleFontColor, forState: UIControlState.Selected)
        self.offLineBtn.setTitleColor(GlobalGrayFontColor, forState: UIControlState.Normal)
        self.offLineBtn.setTitleColor(GlobalStyleFontColor, forState: UIControlState.Selected)
        
        self.createNewTypeBtn.setTitleColor(GlobalStyleFontColor, forState: UIControlState.Normal)
        self.createNewTypeBtn.titleLabel?.font = GGetNormalCustomFont()
    }
    
    func backAction(){
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    func addGoodOnLine() {
        //        let goodDetailVC = ShopGoodDetailViewController(nibName:"ShopGoodDetailViewController",bundle:nil)
        //        self.navigationController?.pushViewController(goodDetailVC, animated: true)
        
        //进货
        if #available(iOS 8.0, *) {
            let alertController = UIAlertController(title: nil, message:nil, preferredStyle: .ActionSheet)
            
            let cancelAction = UIAlertAction(title: "取消", style: .Cancel) { (action) in
                
            }
            alertController.addAction(cancelAction)
            let showNewGoodAction = UIAlertAction(title: "发布新商品", style: .Default) { (action) in
                self.addGoodAction()
            }
            alertController.addAction(showNewGoodAction)
            
            let showBuyGoodAction = UIAlertAction(title: "发布已进货商品", style: .Default) { (action) in
                self.addBuyGoodAction()
            }
            alertController.addAction(showBuyGoodAction)
            self.presentViewController(alertController, animated: true, completion: nil)
        } else {
            // Fallback on earlier versions
        }
    }
    
    func addGoodAction(){
        let goodDetailVC = ShopGoodDetailViewController(nibName:"ShopGoodDetailViewController",bundle:nil)
        self.navigationController?.pushViewController(goodDetailVC, animated: true)
    }
    
    func addBuyGoodAction() {
        let addBuyGoodVC = ShopGoodAddController(nibName:"ShopGoodAddController",bundle:nil)
        self.navigationController?.pushViewController(addBuyGoodVC, animated: true)
    }
    
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
        //获取商品列表
        var onOrOff:Bool = true
        if self.selectedIndex == 0{
            onOrOff = true
        }else if self.selectedIndex == 1{
            onOrOff = false
        }
        NetworkManager.sharedInstance.requestShopGoodList(self.currPage, onOrOff:onOrOff, pageNum: 10, success: { (jsonDic:AnyObject) -> () in
            let dic = jsonDic as! Dictionary<String, AnyObject>
            let dataDic = JsonDicHelper.getJsonDicDictionary(dic, key: "data")
            let listArray = JsonDicHelper.getJsonDicArray(dataDic, key: "list")
            let objDic = JsonDicHelper.getJsonDicDictionary(dataDic, key: "obj")
            //            let shopImage = JsonDicHelper.getJsonDicValue(objDic, key: "store_banner")
            
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
                
                if self.currPage == 0 && listArray.count == 0
                {
                    if self.selectedIndex == 0{
                        
                        GShowAlertMessage("货架空空如也,老板赶快进货吧")
                        
                    }else{
                        GShowAlertMessage("暂没有下架商品哦！")
                    }
                }else{
                    if self.selectedIndex == 2{
                        
                    }else{
                        
                        self.tableView.footer.endRefreshingWithNoMoreData()
                    }
                }
            }else{
                self.tableView.footer.resetNoMoreData()
            }
            
            if self.selectedIndex == 2{
                
            }else{
                
                self.endRefresh()
            }
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
    
    private func requestTypeList(){
        self.shopTypeList.removeAll(keepCapacity: true)
        //获得店铺商品分类列表
        NetworkManager.sharedInstance.requestShopGoodTypeList({ (jsonDic:AnyObject) -> () in
            let dic = jsonDic as! Dictionary<String, AnyObject>
            let dataDic = JsonDicHelper.getJsonDicDictionary(dic, key: "data")
            let listArray = JsonDicHelper.getJsonDicArray(dataDic, key: "list")
            
            for item in listArray{
                if item is Dictionary<String, AnyObject>{
                    let type = ShopTypeModel(jsonDic: item as! Dictionary<String, AnyObject>)
                    self.shopTypeList.append(type)
                }
            }
            if self.shopTypeList.count == 0{
                GShowAlertMessage("无分类数据！")
            }
            self.tableView.reloadData()
            }, fail: { (error:String, needRelogin:Bool) -> () in
                if needRelogin == true{
                    
                }else{
                    GShowAlertMessage(error)
                }
        })
    }
    
    private func initData(){
        self.requestTypeList()
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if self.selectedIndex == 0 || self.selectedIndex == 1{
            return ShopGoodCell.cellHeight()
        }else{
            return ShopTypeCell.cellHeight()
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.selectedIndex == 0 || self.selectedIndex == 1{
            return self.shopGoodList.count
        }else{
            return self.shopTypeList.count
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if self.selectedIndex == 0 || self.selectedIndex == 1{
            self.tableView.registerNib(UINib(nibName: "ShopGoodCell", bundle: nil), forCellReuseIdentifier: ShopGoodCell.cellIdentifier())
            let cell = self.tableView.dequeueReusableCellWithIdentifier(ShopGoodCell.cellIdentifier(), forIndexPath: indexPath) as! ShopGoodCell
            cell.selectionStyle = UITableViewCellSelectionStyle.Gray
            cell.shopGoodData = self.shopGoodList[indexPath.row]
            cell.editBtn.tag = indexPath.row
            cell.updateBtn.tag = indexPath.row
            cell.onOffBtn.tag = indexPath.row
            cell.editBtn.addTarget(self, action: Selector("actionEdit:"), forControlEvents: UIControlEvents.TouchUpInside)
            cell.updateBtn.addTarget(self, action: Selector("actionUpdate:"), forControlEvents: UIControlEvents.TouchUpInside)
            cell.onOffBtn.addTarget(self, action: Selector("actionOnOffLine:"), forControlEvents: UIControlEvents.TouchUpInside)
            
            return cell
        }else{
            self.tableView.registerNib(UINib(nibName: "ShopTypeCell", bundle: nil), forCellReuseIdentifier: ShopTypeCell.cellIdentifier())
            let cell = self.tableView.dequeueReusableCellWithIdentifier(ShopTypeCell.cellIdentifier(), forIndexPath: indexPath) as! ShopTypeCell
            cell.selectionStyle = UITableViewCellSelectionStyle.None
            cell.shopTypeData = self.shopTypeList[indexPath.row]
            cell.deleteBtn.tag = indexPath.row
            cell.editBtn.tag = indexPath.row
            cell.deleteBtn.addTarget(self, action: Selector("actionDeleteType:"), forControlEvents: UIControlEvents.TouchUpInside)
            cell.editBtn.addTarget(self, action: Selector("actionEditType:"), forControlEvents: UIControlEvents.TouchUpInside)
            return cell
        }
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if self.selectedIndex == 0{
            let webVC = WebViewController()
            webVC.webUrl = self.shopGoodList[indexPath.row].goods_url
            webVC.title = "商品信息"
            self.navigationController?.pushViewController(webVC, animated: true)
            tableView.deselectRowAtIndexPath(indexPath, animated: true)
        }
    }
    
    //编辑
    func actionEdit(sender:UIButton){
        let goodDetailVC = ShopGoodDetailViewController(nibName:"ShopGoodDetailViewController",bundle:nil)
        goodDetailVC.goodData = self.shopGoodList[sender.tag]
        self.navigationController?.pushViewController(goodDetailVC, animated: true)
    }
    
    //上架/下架
    func actionOnOffLine(sender:UIButton){
        let isShow = self.shopGoodList[sender.tag].if_show
        let isShowFloat = (isShow as NSString).floatValue
        
        let onOffType = isShowFloat == 1.0 ? false : true
        let goodId = self.shopGoodList[sender.tag].goods_id
        
        NetworkManager.sharedInstance.requestGoodOnOffLine(goodId, onOffType: onOffType, success: { (jsonDic:AnyObject) -> () in
            self.shopGoodList.removeAtIndex(sender.tag)
            let indexPath = NSIndexPath(forRow: sender.tag, inSection: 0)
            self.tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Fade)
            self.tableView.reloadData()
            }) { (error:String, needRelogin:Bool) -> () in
                if needRelogin == true{
                    
                }else{
                    GShowAlertMessage(error)
                }
        }
    }
    
    //分享
    func actionUpdate(sender:UIButton){
        /*更新
        let goodId = self.shopGoodList[sender.tag].goods_id
        NetworkManager.sharedInstance.requestShopUpdateGood(goodId, success: { (jsonDic:AnyObject) -> () in
        GShowAlertMessage("更新成功！")
        }) { (error:String, needRelogin:Bool) -> () in
        if needRelogin == true{
        
        }else{
        GShowAlertMessage(error)
        }
        }*/
        //商品分享
        
        //判断是否安装微信
        if WXApi.isWXAppInstalled() == false{
            GShowAlertMessage("请先下载安装微信客户端！")
            return
        }
        let good = self.shopGoodList[sender.tag]
        let message = WXMediaMessage()
        message.title = good.goods_name
        message.description = good.goodDescription
        
        if let logoUrl = NSURL(string:good.default_image){
            let imageData = NSData(contentsOfURL: logoUrl)
            let image = UIImage(data: imageData!)
            if image != nil{
                //设置图片大小不能超过32k
                let smallImage = GFitSmallImage(image!, wantSize: CGSizeMake(60.0, 60.0), fitScale: true)
                message.setThumbImage(smallImage)
            }
        }
        
        let ext = WXWebpageObject()
        ext.webpageUrl = good.qrcode_goods_url
        message.mediaObject = ext
        let req = SendMessageToWXReq()
        req.bText = false
        req.message = message
        req.scene = Int32(WXSceneSession.rawValue)
        WXApi.sendReq(req)
    }
    
    //删除分类
    func actionDeleteType(sender:UIButton){
        let alert = UIAlertView(title: "删除分类", message: "是否删除该分类?", delegate: self, cancelButtonTitle: "取消", otherButtonTitles: "确定")
        alert.tag = sender.tag
        alert.show()
    }
    
    //编辑分类
    func actionEditType(sender:UIButton){
        let alert = UIAlertView()
        alert.title = "编辑分类"
        alert.delegate = self
        alert.addButtonWithTitle("取消")
        alert.addButtonWithTitle("确定")
        
        alert.alertViewStyle = UIAlertViewStyle.PlainTextInput
        let textFiled = alert.textFieldAtIndex(0)
        textFiled!.text = self.shopTypeList[sender.tag].cate_name
        alert.tag = sender.tag
        alert.show()
    }
    
    //新建分类
    @IBAction func actionCreateNewType(sender: AnyObject) {
        let alert = UIAlertView()
        alert.title = "添加类目"
        alert.delegate = self
        alert.addButtonWithTitle("取消")
        alert.addButtonWithTitle("确定")
        
        alert.alertViewStyle = UIAlertViewStyle.PlainTextInput
        let textFiled = alert.textFieldAtIndex(0)
        textFiled?.placeholder = "类目名称"
        alert.show()
    }
    @IBAction func actionShowType(sender: AnyObject) {
        self.selectedIndex = 2
    }
    @IBAction func actionShowGood(sender: AnyObject) {
        self.selectedIndex = 0
    }
    @IBAction func actionShowOffLine(sender: AnyObject) {
        self.selectedIndex = 1
    }
    
    func alertView(alertView: UIAlertView, clickedButtonAtIndex buttonIndex: Int) {
        let buttonStr = alertView.buttonTitleAtIndex(buttonIndex)
        let title = alertView.title
        if title == "编辑分类"{
            if buttonStr == "确定"{
                let typeModel = self.shopTypeList[alertView.tag]
                let typeName = alertView.textFieldAtIndex(0)!.text
                NetworkManager.sharedInstance.requestEditGoodType(typeModel.cate_id, typeName: typeName!, success: { (jsonDic:AnyObject) -> () in
                    self.shopTypeList[alertView.tag].cate_name = typeName!
                    self.tableView.reloadData()
                    }, fail: { (error:String, needRelogin:Bool) -> () in
                        if needRelogin == true{
                            
                        }else{
                            GShowAlertMessage(error)
                        }
                })
            }
        }else if title == "删除分类"{
            if buttonStr == "确定"{
                let deleteId = self.shopTypeList[alertView.tag].cate_id
                NetworkManager.sharedInstance.requestDeleteGoodType(deleteId, success: { (jsonDic:AnyObject) -> () in
                    self.shopTypeList.removeAtIndex(alertView.tag)
                    self.tableView.reloadData()
                    GShowAlertMessage("删除成功！")
                    }, fail: { (error:String, needRelogin:Bool) -> () in
                        if needRelogin == true{
                            
                        }else{
                            GShowAlertMessage(error)
                        }
                })
            }
        }else if title == "添加类目"{
            if buttonStr == "确定"{
                if let typeName = alertView.textFieldAtIndex(0)!.text{
                    NetworkManager.sharedInstance.requestAddGoodType(typeName, success: { (jsonDic:AnyObject) -> () in
                        self.requestTypeList()
                        GShowAlertMessage("添加成功！")
                        }, fail: { (error:String, needRelogin:Bool) -> () in
                            if needRelogin == true{
                                
                            }else{
                                GShowAlertMessage(error)
                            }
                    })
                }else{
                    
                }
            }
        }
    }
}
